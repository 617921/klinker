import Observation
import SwiftUI

/// The screens of De Anonieme Brieven.
enum LetterScreen: Equatable {
    case postbus, letter, quiz, dossier, reveal
}

/// Opening a new letter: the seal breaks, the flap flips, the letter slides out, then unfolds.
enum LetterPhase: Int, Comparable {
    case sealed, unsealed, sliding, open

    static func < (a: LetterPhase, b: LetterPhase) -> Bool { a.rawValue < b.rawValue }
}

/// The one state machine of `LettersView` (kept in a class so a screen can be set up directly).
@Observable
final class LetterSession {
    var screen: LetterScreen = .postbus
    /// The letter on the Brief and Ontcijfer screens.
    var number: Int?
    var phase: LetterPhase = .open
    /// Tapped token on the letter.
    var selectedToken: Int?

    // Quiz
    var question = 0
    var wrongPicks: Set<Int> = []
    var lastWrong: Int?
    /// Wrong taps per option (each bump plays one shake).
    var shakes: [Int: Int] = [:]
    var answeredRight = false
    var showClue = false

    // Dossier
    /// Suspect id just tapped on the board (for the "Jij verdenkt nu" line).
    var lastSuspect: String?

    init(screen: LetterScreen = .postbus, number: Int? = nil) {
        self.screen = screen
        self.number = number
    }

    /// Shows a letter. A letter that was never opened plays the opening first.
    func show(_ number: Int, firstTime: Bool, reduceMotion: Bool) {
        self.number = number
        selectedToken = nil
        resetQuiz()
        phase = firstTime && !reduceMotion ? .sealed : .open
        screen = .letter
    }

    func startQuiz() {
        resetQuiz()
        screen = .quiz
    }

    func resetQuiz() {
        question = 0
        wrongPicks = []
        lastWrong = nil
        shakes = [:]
        answeredRight = false
        showClue = false
    }

    func nextQuestion() {
        question += 1
        wrongPicks = []
        lastWrong = nil
        shakes = [:]
        answeredRight = false
    }
}
