import Foundation

/// How well a word was recalled.
enum Rating: Int, Sendable {
    case again = 1, hard, good, easy
}

/// Memory of one word, as tracked by FSRS.
struct MemoryState: Equatable, Sendable {
    var stability: Double
    var difficulty: Double
    var reps: Int
    var lapses: Int
    var lastReview: Date?
    var due: Date?
}

/// FSRS-4.5 spaced repetition (Free Spaced Repetition Scheduler) with its default weights.
///
/// Simplification for a game app: answers given within half a day of the previous one
/// only nudge stability a little, so a fast round can't fake long-term memory.
struct FSRS: Sendable {
    static let decay = -0.5
    static let factor = 19.0 / 81.0
    static let `default` = FSRS()

    let w: [Double] = [0.4, 0.6, 2.4, 5.8, 4.93, 0.94, 0.86, 0.01, 1.49, 0.14, 0.94, 2.18, 0.05, 0.34, 1.26, 0.29, 2.61]
    var requestRetention = 0.9

    /// Probability of recall after `days` with stability `stability`.
    static func retrievability(days: Double, stability: Double) -> Double {
        guard stability > 0 else { return 0 }
        return pow(1 + factor * max(0, days) / stability, decay)
    }

    func interval(stability: Double) -> Double {
        stability / Self.factor * (pow(requestRetention, 1 / Self.decay) - 1)
    }

    private func initialDifficulty(_ rating: Rating) -> Double {
        clampD(w[4] - Double(rating.rawValue - 3) * w[5])
    }

    private func clampD(_ d: Double) -> Double { min(10, max(1, d)) }

    /// New state after answering with `rating` at `now`.
    func review(_ state: MemoryState?, rating: Rating, now: Date) -> MemoryState {
        guard let state, state.reps > 0, let last = state.lastReview else {
            let s = w[rating.rawValue - 1]
            return MemoryState(
                stability: s,
                difficulty: initialDifficulty(rating),
                reps: 1,
                lapses: rating == .again ? 1 : 0,
                lastReview: now,
                due: due(after: s, rating: rating, now: now)
            )
        }

        let days = now.timeIntervalSince(last) / 86_400
        let r = Self.retrievability(days: days, stability: state.stability)
        let g = Double(rating.rawValue)
        let d = clampD(w[7] * w[4] + (1 - w[7]) * (state.difficulty - w[6] * (g - 3)))

        var s: Double
        if days < 0.5 {
            // Same-session repeat: small nudge only.
            let nudge: [Rating: Double] = [.again: 0.6, .hard: 1.0, .good: 1.12, .easy: 1.25]
            s = max(0.1, state.stability * (nudge[rating] ?? 1))
        } else if rating == .again {
            s = w[11] * pow(d, -w[12]) * (pow(state.stability + 1, w[13]) - 1) * exp(w[14] * (1 - r))
            s = min(s, state.stability)
        } else {
            let hardPenalty = rating == .hard ? w[15] : 1
            let easyBonus = rating == .easy ? w[16] : 1
            s = state.stability * (1 + exp(w[8]) * (11 - d) * pow(state.stability, -w[9]) * (exp(w[10] * (1 - r)) - 1) * hardPenalty * easyBonus)
        }

        return MemoryState(
            stability: s,
            difficulty: d,
            reps: state.reps + 1,
            lapses: state.lapses + (rating == .again ? 1 : 0),
            lastReview: now,
            due: due(after: s, rating: rating, now: now)
        )
    }

    private func due(after stability: Double, rating: Rating, now: Date) -> Date {
        if rating == .again { return now.addingTimeInterval(10 * 60) }
        let days = max(1, interval(stability: stability).rounded())
        return now.addingTimeInterval(days * 86_400)
    }
}

extension MemoryState {
    /// Wall level 0...4: Nieuw, Gezien, Herkennen, Onthouden, Beheerst.
    var level: Int {
        guard reps > 0 else { return 0 }
        switch stability {
        case ..<2: return 1
        case ..<7: return 2
        case ..<21: return 3
        default: return 4
        }
    }

    func retrievability(at now: Date) -> Double {
        guard let lastReview else { return 0 }
        return FSRS.retrievability(days: now.timeIntervalSince(lastReview) / 86_400, stability: stability)
    }
}
