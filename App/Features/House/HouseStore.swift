import Foundation
import Observation

/// Your house: which object stands in which spot. Saved as JSON in `UserDefaults` ("klinker.house").
/// Shared by `HouseCard` and `HouseView`.
@Observable
final class HouseStore {
    static let shared = HouseStore()
    static let defaultsKey = "klinker.house"

    @ObservationIgnored private let defaults: UserDefaults

    /// Spot id → object id.
    private(set) var placements: [String: String] = [:]
    /// Objects that have been in the house at least once (so they're no longer "nieuw").
    private(set) var everPlaced: Set<String> = []

    private struct Saved: Codable {
        var placements: [String: String]
        var everPlaced: [String]
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: Self.defaultsKey),
           let saved = try? JSONDecoder().decode(Saved.self, from: data) {
            placements = saved.placements.filter { HouseCatalog.slot($0.key) != nil && HouseCatalog.item($0.value) != nil }
            everPlaced = Set(saved.everPlaced)
        }
    }

    func place(_ itemID: String, in slotID: String) {
        for (slot, item) in placements where item == itemID { placements[slot] = nil }
        placements[slotID] = itemID
        everPlaced.insert(itemID)
        save()
    }

    func remove(_ itemID: String) {
        for (slot, item) in placements where item == itemID { placements[slot] = nil }
        save()
    }

    /// Takes out objects that are locked again (for example after "opnieuw beginnen").
    func prune(keeping unlocked: Set<String>) {
        let kept = placements.filter { unlocked.contains($0.value) }
        guard kept.count != placements.count else { return }
        placements = kept
        save()
    }

    func reset() {
        placements = [:]
        everPlaced = []
        defaults.removeObject(forKey: Self.defaultsKey)
    }

    private func save() {
        let saved = Saved(placements: placements, everPlaced: everPlaced.sorted())
        if let data = try? JSONEncoder().encode(saved) {
            defaults.set(data, forKey: Self.defaultsKey)
        }
    }
}

/// The house for one render: what's unlocked by course progress, where things are, how cosy it is.
struct HouseState {
    let unlocked: Set<String>
    /// Spot id → object id, only for unlocked objects.
    let placements: [String: String]
    let everPlaced: Set<String>

    init(store: HouseStore, completedSheets: Set<Int>) {
        let unlocked = Set(HouseCatalog.items.filter { completedSheets.contains($0.unlockSheet) }.map(\.id))
        self.unlocked = unlocked
        placements = store.placements.filter { unlocked.contains($0.value) }
        everPlaced = store.everPlaced
    }

    func isUnlocked(_ item: HouseItem) -> Bool { unlocked.contains(item.id) }

    func item(in slot: HouseSlot) -> HouseItem? { placements[slot.id].flatMap(HouseCatalog.item) }

    func slot(of item: HouseItem) -> HouseSlot? {
        placements.first { $0.value == item.id }.flatMap { HouseCatalog.slot($0.key) }
    }

    var unlockedItems: [HouseItem] { HouseCatalog.items.filter { unlocked.contains($0.id) } }
    var placedCount: Int { placements.count }

    /// Unlocked objects that have never been in the house yet: the card's "n nieuw".
    var newItems: [HouseItem] {
        unlockedItems.filter { slot(of: $0) == nil && !everPlaced.contains($0.id) }
    }

    func count(in room: HouseRoom) -> Int {
        placements.keys.compactMap(HouseCatalog.slot).filter { $0.room == room }.count
    }

    func hasFreeSlot(for kind: HouseKind) -> Bool {
        HouseCatalog.slots.contains { $0.kind == kind && placements[$0.id] == nil }
    }

    /// 0...100: three objects per room make it gezellig (four rooms, twelve objects).
    var score: Int { Self.score(placements) }

    static func score(_ placements: [String: String]) -> Int {
        var counts: [HouseRoom: Int] = [:]
        for slot in placements.keys.compactMap(HouseCatalog.slot) { counts[slot.room, default: 0] += 1 }
        let total = HouseRoom.allCases.reduce(0) { $0 + min(3, counts[$1] ?? 0) }
        return Int((Double(total) / 12 * 100).rounded())
    }

    var meterText: String {
        let pct = score
        let words = pct >= 100 ? "Echt gezellig!" : pct >= 67 ? "Bijna echt gezellig" : pct >= 34 ? "Al best gezellig" : pct > 0 ? "Het begint al" : "Nog heel kaal"
        return "\(pct)% · \(words)"
    }

    /// At night a room has a light on when it has furniture (the attic stays dark),
    /// or when de lamp or de kroonluchter is in it.
    func isLit(_ room: HouseRoom) -> Bool {
        if room != .zolder && count(in: room) > 0 { return true }
        return placements.contains { entry in
            (entry.value == "lamp" || entry.value == "kroonluchter") && HouseCatalog.slot(entry.key)?.room == room
        }
    }
}
