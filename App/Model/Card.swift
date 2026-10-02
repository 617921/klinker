import Foundation
import SwiftData

/// Stored memory of one word on this device.
@Model
final class Card {
    @Attribute(.unique) var wordID: String
    var stability: Double
    var difficulty: Double
    var reps: Int
    var lapses: Int
    var lastReview: Date?
    var due: Date?

    init(wordID: String, state: MemoryState) {
        self.wordID = wordID
        self.stability = state.stability
        self.difficulty = state.difficulty
        self.reps = state.reps
        self.lapses = state.lapses
        self.lastReview = state.lastReview
        self.due = state.due
    }

    var state: MemoryState {
        get {
            MemoryState(stability: stability, difficulty: difficulty, reps: reps, lapses: lapses, lastReview: lastReview, due: due)
        }
        set {
            stability = newValue.stability
            difficulty = newValue.difficulty
            reps = newValue.reps
            lapses = newValue.lapses
            lastReview = newValue.lastReview
            due = newValue.due
        }
    }
}
