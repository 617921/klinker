import AVFoundation
import UIKit

/// Dutch text-to-speech with the on-device voice. Works offline. Words are heard even on a
/// silent phone: `KlinkerAudio` switches to playback while one is spoken.
@MainActor
final class Speech: NSObject, AVSpeechSynthesizerDelegate {
    static let shared = Speech()

    private let synthesizer = AVSpeechSynthesizer()
    private lazy var voice: AVSpeechSynthesisVoice? = {
        let dutch = AVSpeechSynthesisVoice.speechVoices().filter { $0.language.hasPrefix("nl") }
        return dutch.first { $0.language == "nl-NL" && $0.quality != .default }
            ?? dutch.first { $0.language == "nl-NL" }
            ?? dutch.first
            ?? AVSpeechSynthesisVoice(language: "nl-NL")
    }()

    private override init() {
        super.init()
        synthesizer.delegate = self
    }

    /// Speaks Dutch text. `rate` 0.3 (slow) ... 0.55 (natural).
    func say(_ text: String, rate: Float = 0.45) {
        guard !text.isEmpty else { return }
        synthesizer.stopSpeaking(at: .immediate)
        KlinkerAudio.shared.beginSpeech()
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.rate = rate
        synthesizer.speak(utterance)
    }

    /// Speaks after a short pause (so a sound effect can ring first).
    func say(_ text: String, after delay: Double) {
        Task {
            try? await Task.sleep(for: .seconds(delay))
            say(text)
        }
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in self.finished() }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in self.finished() }
    }

    /// Back to the ambient session once nothing is left to say.
    private func finished() {
        Task {
            try? await Task.sleep(for: .milliseconds(300))
            if !synthesizer.isSpeaking { KlinkerAudio.shared.endSpeech() }
        }
    }
}

/// Light haptic feedback.
enum Haptics {
    static func tap() { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    static func thump() { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
    static func success() { UINotificationFeedbackGenerator().notificationOccurred(.success) }
    static func error() { UINotificationFeedbackGenerator().notificationOccurred(.error) }
}
