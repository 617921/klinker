import Foundation
import Observation

/// A neighbourhood of Klinkerstad: about eight places in a row of lessons. When every place in it
/// is open, Ria brings a Delft Blue postcard of it.
nonisolated struct Buurt: Identifiable, Hashable, Sendable {
    let id: Int
    /// "de Jordaan", "het Centrum".
    let name: String
    let places: ClosedRange<Int>
    /// The buildings on the postcard, left to right.
    let picks: [Int]
    /// The one window lit warm on the card.
    let warm: Int
    /// Out of town: trees and fields instead of canal houses.
    var rural = false

    var title: String { "Groeten uit \(name)" }

    static let all: [Buurt] = [
        Buurt(id: 1, name: "het Centrum", places: 1...8, picks: [2, 3, 8], warm: 3),
        Buurt(id: 2, name: "de Grachtengordel", places: 9...16, picks: [10, 14, 16], warm: 14),
        Buurt(id: 3, name: "de Jordaan", places: 17...24, picks: [19, 22, 23], warm: 19),
        Buurt(id: 4, name: "het Museumkwartier", places: 25...32, picks: [27, 25, 26], warm: 27),
        Buurt(id: 5, name: "de Pijp", places: 33...40, picks: [33, 34, 40], warm: 40),
        Buurt(id: 6, name: "het Platteland", places: 41...48, picks: [45, 44], warm: 45, rural: true),
        Buurt(id: 7, name: "de Plantage", places: 49...55, picks: [50, 49, 53], warm: 49),
        Buurt(id: 8, name: "Noord", places: 56...62, picks: [56, 57, 62], warm: 57),
    ]

    static func of(_ n: Int) -> Buurt? { all.first { $0.places.contains(n) } }

    /// Every place open: its words all answered right at least once.
    func isComplete(_ statuses: [SheetStatus]) -> Bool {
        places.allSatisfy { n in
            guard n >= 1, n <= statuses.count else { return false }
            switch statuses[n - 1] {
            case .growing, .built, .fading: return true
            case .current, .locked: return false
            }
        }
    }

    /// How many places are still to open.
    func left(_ statuses: [SheetStatus]) -> Int {
        places.filter { n in
            guard n >= 1, n <= statuses.count else { return true }
            switch statuses[n - 1] {
            case .current, .locked: return true
            case .growing, .built, .fading: return false
            }
        }.count
    }
}

/// Which postcards the learner has looked at (new ones get a badge).
@Observable
final class AnsichtkaartStore {
    static let shared = AnsichtkaartStore()

    private(set) var seen: Set<Int>
    @ObservationIgnored private let defaults: UserDefaults
    private static let key = "klinker.postcardsSeen"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        seen = Set(defaults.array(forKey: Self.key) as? [Int] ?? [])
    }

    func markSeen(_ id: Int) {
        guard !seen.contains(id) else { return }
        seen.insert(id)
        defaults.set(Array(seen), forKey: Self.key)
    }
}
