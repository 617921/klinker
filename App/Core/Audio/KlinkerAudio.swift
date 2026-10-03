import AVFoundation
import Observation
import UIKit

/// Plays Klinker's sounds: one small engine with voices for effects and for the city.
/// Sounds are made by `SoundBank` at launch (in the background) — nothing is downloaded.
///
/// The session is `.ambient`, so the silent switch silences effects and the city and the
/// learner's own music keeps playing. Only while a word is spoken does it switch to
/// `.playback`, so words can still be heard on a silent phone (see `Speech`).
@Observable
final class KlinkerAudio {
    static let shared = KlinkerAudio()

    static let effectsKey = "klinker.sound"
    static let cityKey = "klinker.citySound"

    /// Taps, answers, bells and parties.
    var effectsOn: Bool {
        didSet { defaults.set(effectsOn, forKey: Self.effectsKey) }
    }

    /// The soft sounds of the city under the map.
    var cityOn: Bool {
        didSet {
            defaults.set(cityOn, forKey: Self.cityKey)
            if !cityOn { setBeds([:]) }
        }
    }

    @ObservationIgnored private let defaults: UserDefaults
    @ObservationIgnored private let engine = AVAudioEngine()
    @ObservationIgnored private let format = AVAudioFormat(standardFormatWithSampleRate: Synth.rate, channels: 1)!
    @ObservationIgnored private var effectVoices: [AVAudioPlayerNode] = []
    @ObservationIgnored private var cityVoices: [AVAudioPlayerNode] = []
    @ObservationIgnored private var bedVoices: [KlinkerSound: AVAudioPlayerNode] = [:]
    @ObservationIgnored private var nextEffect = 0
    @ObservationIgnored private var nextCity = 0
    @ObservationIgnored private var buffers: [KlinkerSound: AVAudioPCMBuffer] = [:]
    @ObservationIgnored private var strikes: [Int: AVAudioPCMBuffer] = [:]
    @ObservationIgnored private var bedLevels: [KlinkerSound: Float] = [:]
    @ObservationIgnored private var prepared = false
    @ObservationIgnored private var speaking = false
    @ObservationIgnored private var observers: [NSObjectProtocol] = []

    /// Another app is playing music or a podcast: keep the city quiet.
    private(set) var othersPlaying = false

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        effectsOn = defaults.object(forKey: Self.effectsKey) as? Bool ?? true
        cityOn = defaults.object(forKey: Self.cityKey) as? Bool ?? true
    }

    // MARK: Setup

    /// Builds the engine and makes the sounds. Call once at launch.
    func prepare() {
        guard !prepared else { return }
        prepared = true
        setCategory(speaking: false)
        for _ in 0..<6 { effectVoices.append(attach()) }
        for _ in 0..<4 { cityVoices.append(attach()) }
        for bed in KlinkerSound.allCases where bed.isBed {
            let node = attach()
            node.volume = 0
            bedVoices[bed] = node
        }
        engine.mainMixerNode.outputVolume = 1
        start()
        observe()
        othersPlaying = AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
        Task {
            // Effects first (they are short), then the long city beds.
            let order = KlinkerSound.allCases.filter { !$0.isBed } + KlinkerSound.allCases.filter(\.isBed)
            for sound in order {
                let samples = await Task.detached(priority: .utility) { SoundBank.render(sound) }.value
                buffers[sound] = pcm(samples)
                if sound.isBed { startBed(sound) }
            }
        }
    }

    private func attach() -> AVAudioPlayerNode {
        let node = AVAudioPlayerNode()
        engine.attach(node)
        engine.connect(node, to: engine.mainMixerNode, format: format)
        return node
    }

    private func pcm(_ samples: [Float]) -> AVAudioPCMBuffer? {
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(samples.count)),
              let channel = buffer.floatChannelData?[0] else { return nil }
        buffer.frameLength = AVAudioFrameCount(samples.count)
        samples.withUnsafeBufferPointer { channel.update(from: $0.baseAddress!, count: samples.count) }
        return buffer
    }

    private func start() {
        guard !engine.isRunning else { return }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            try engine.start()
        } catch {
            return
        }
        for bed in bedVoices.keys { startBed(bed) }
    }

    private func startBed(_ bed: KlinkerSound) {
        guard engine.isRunning, let node = bedVoices[bed], let buffer = buffers[bed] else { return }
        node.stop()
        node.scheduleBuffer(buffer, at: nil, options: .loops)
        node.volume = bedLevels[bed] ?? 0
        node.play()
    }

    private func observe() {
        let center = NotificationCenter.default
        observers.append(center.addObserver(forName: AVAudioSession.interruptionNotification, object: nil, queue: .main) { [weak self] note in
            let ended = (note.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt).flatMap(AVAudioSession.InterruptionType.init) == .ended
            MainActor.assumeIsolated { if ended { self?.start() } }
        })
        observers.append(center.addObserver(forName: .AVAudioEngineConfigurationChange, object: engine, queue: .main) { [weak self] _ in
            MainActor.assumeIsolated { self?.start() }
        })
        observers.append(center.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            MainActor.assumeIsolated { self?.start() }
        })
        observers.append(center.addObserver(forName: AVAudioSession.silenceSecondaryAudioHintNotification, object: nil, queue: .main) { [weak self] _ in
            MainActor.assumeIsolated {
                guard let self else { return }
                self.othersPlaying = AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
                if self.othersPlaying { self.setBeds([:]) }
            }
        })
    }

    // MARK: Playing

    /// An effect (taps, answers, parties). Silent when effects are off.
    func play(_ sound: KlinkerSound, volume: Float = 1) {
        guard effectsOn else { return }
        voice(sound, from: effectVoices, next: &nextEffect, volume: volume, pan: 0)
    }

    /// A sound in the city, placed left or right (`pan` −1...1). Silent when city sounds are off.
    func playCity(_ sound: KlinkerSound, volume: Float, pan: Float) {
        guard cityOn, !othersPlaying else { return }
        voice(sound, from: cityVoices, next: &nextCity, volume: volume, pan: pan)
    }

    /// The church bells strike the hour.
    func strike(hours: Int, volume: Float, pan: Float) {
        guard cityOn, !othersPlaying, engine.isRunning else { return }
        let n = max(1, min(12, hours))
        if strikes[n] == nil {
            Task {
                let samples = await Task.detached(priority: .utility) { SoundBank.strike(n) }.value
                strikes[n] = pcm(samples)
                play(buffer: strikes[n], on: cityVoices, next: &nextCity, volume: volume, pan: pan)
            }
            return
        }
        play(buffer: strikes[n], on: cityVoices, next: &nextCity, volume: volume, pan: pan)
    }

    private func voice(_ sound: KlinkerSound, from voices: [AVAudioPlayerNode], next: inout Int, volume: Float, pan: Float) {
        if !engine.isRunning { start() }
        play(buffer: buffers[sound], on: voices, next: &next, volume: volume, pan: pan)
    }

    private func play(buffer: AVAudioPCMBuffer?, on voices: [AVAudioPlayerNode], next: inout Int, volume: Float, pan: Float) {
        guard engine.isRunning, let buffer, !voices.isEmpty else { return }
        let node = voices[next % voices.count]
        next += 1
        node.stop()
        node.volume = volume
        node.pan = max(-1, min(1, pan))
        node.scheduleBuffer(buffer, at: nil, options: [])
        node.play()
    }

    /// Target levels for the looping beds (missing ones go silent).
    func setBeds(_ levels: [KlinkerSound: Float]) {
        let allowed = cityOn && !othersPlaying
        for (bed, node) in bedVoices {
            let level = allowed ? (levels[bed] ?? 0) : 0
            bedLevels[bed] = level
            node.volume = level
        }
    }

    // MARK: Speech

    /// Words must be heard even on a silent phone: switch to playback while one is spoken.
    func beginSpeech() {
        guard !speaking else { return }
        speaking = true
        setCategory(speaking: true)
    }

    func endSpeech() {
        guard speaking else { return }
        speaking = false
        setCategory(speaking: false)
    }

    private func setCategory(speaking: Bool) {
        let session = AVAudioSession.sharedInstance()
        if speaking {
            try? session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
        } else {
            try? session.setCategory(.ambient, mode: .default, options: [])
        }
        try? session.setActive(true)
    }
}
