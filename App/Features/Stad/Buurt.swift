import Foundation
import Observation

/// A neighbourhood of Klinkerstad, named after a real Amsterdam neighbourhood where its places
/// really are. When every place in it is open, Ria brings a Delft Blue postcard of it.
nonisolated struct Buurt: Identifiable, Hashable, Sendable {
    let id: Int
    /// "de Jordaan", "het Centrum".
    let name: String
    let places: [Int]
    /// The buildings on the postcard, left to right.
    let picks: [Int]
    /// The one window lit warm on the card.
    let warm: Int
    /// Out of town: trees and fields instead of canal houses.
    var rural = false

    var title: String { "Groeten uit \(name)" }

    /// Grouped by where such places really are in Amsterdam, in the order their cards arrive
    /// (researched 2026-10-03; see FEATURES.md for the real examples).
    static let all: [Buurt] = [
        // Noordermarkt-side canals, Winkel 43, bruine cafés ('t Smalle, Papeneiland).
        Buurt(id: 1, name: "de Jordaan", places: [2, 3, 4, 6, 9, 10], picks: [2, 3, 6], warm: 3),
        // Rembrandttoren, Oosterpark, Montessori College Oost, OLVG Oost.
        Buurt(id: 2, name: "Oost", places: [7, 11, 13, 17, 18], picks: [7, 17, 13], warm: 17),
        // Centraal Station, OBA Oosterdok, Stopera, Magna Plaza, Bureau Warmoesstraat,
        // Tuschinski, Entrepotdok, Oude Kerk, Stadsschouwburg.
        Buurt(id: 3, name: "het Centrum", places: [1, 8, 12, 14, 16, 21, 23, 24, 25, 26], picks: [25, 23, 16], warm: 23),
        // Albert Cuypmarkt, De Dageraad, the eating-out quarter.
        Buurt(id: 4, name: "de Pijp", places: [5, 19, 20, 27, 28, 33, 34], picks: [19, 28, 20], warm: 28),
        // ABN AMRO tower, VU and VU-NT2, Rechtbank Amsterdam, the big law and notary firms.
        Buurt(id: 5, name: "de Zuidas", places: [15, 29, 30, 31, 32, 40, 41], picks: [15, 29, 32], warm: 29),
        // Molen van Sloten, the Belastingdienst tower at Teleport, Sloterstrand, under Schiphol's flight paths.
        Buurt(id: 6, name: "Nieuw-West", places: [36, 37, 39, 42, 43, 44, 46, 48], picks: [39, 44, 46], warm: 44, rural: true),
        // Rijksmuseum, Zuiderbad, Conservatorium Hotel, Kazerne Dirk, Concertgebouw.
        Buurt(id: 7, name: "het Museumkwartier", places: [22, 35, 49, 50, 51, 53, 55, 56], picks: [55, 22, 53], warm: 22),
        // NDSM (MediaWharf, IJ-Hallen), A Lab, Vliegenbos, Landelijk Noord, Concertgemaal Kadoelen,
        // the IJ ferries and the A'DAM Lookout.
        Buurt(id: 8, name: "Noord", places: [38, 45, 47, 52, 54, 57, 58, 59, 60, 61, 62], picks: [57, 62, 60], warm: 60),
    ]

    static func of(_ n: Int) -> Buurt? { all.first { $0.places.contains(n) } }

    /// The place that opens last: the postcard comes then.
    var last: Int { places.max() ?? 0 }

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
