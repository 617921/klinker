import AVFoundation
import UIKit

/// Dutch text-to-speech with the on-device voice. Works offline.
final class Speech {
    static let shared = Speech()

    private let synthesizer = AVSpeechSynthesizer()
    private lazy var voice: AVSpeechSynthesisVoice? = {
        let dutch = AVSpeechSynthesisVoice.speechVoices().filter { $0.language.hasPrefix("nl") }
        return dutch.first { $0.language == "nl-NL" && $0.quality != .default }
            ?? dutch.first { $0.language == "nl-NL" }
            ?? dutch.first
            ?? AVSpeechSynthesisVoice(language: "nl-NL")
    }()

    private init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
    }

    /// Speaks Dutch text. `rate` 0.3 (slow) ... 0.55 (natural).
    func say(_ text: String, rate: Float = 0.45) {
        guard !text.isEmpty else { return }
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.rate = rate
        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

/// Light haptic feedback.
enum Haptics {
    static func tap() { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    static func thump() { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
    static func success() { UINotificationFeedbackGenerator().notificationOccurred(.success) }
    static func error() { UINotificationFeedbackGenerator().notificationOccurred(.error) }
}
