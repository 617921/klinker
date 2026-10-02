import Foundation
import Observation

/// What the learner did with the letters: opened, decoded (both questions right), clues earned,
/// suspicion per suspect and whether the reveal was seen. Saved as JSON in UserDefaults.
@Observable
final class LetterStore {
    static let shared = LetterStore()
    static let defaultsKey = "klinker.letters"

    @ObservationIgnored private let defaults: UserDefaults

    private(set) var opened: Set<Int> = []
    private(set) var solved: Set<Int> = []
    private(set) var clues: Set<Int> = []
    /// Suspect id → 0…3 magnifiers.
    private(set) var suspicion: [String: Int] = [:]
    private(set) var revealSeen = false

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        guard let data = defaults.data(forKey: Self.defaultsKey),
              let saved = try? JSONDecoder().decode(Saved.self, from: data) else { return }
        opened = Set(saved.opened ?? [])
        solved = Set(saved.solved ?? [])
        clues = Set(saved.clues ?? [])
        suspicion = (saved.suspicion ?? [:]).mapValues { max(0, min(3, $0)) }
        revealSeen = saved.revealSeen ?? false
    }

    // MARK: - Changes

    func markOpened(_ number: Int) {
        guard !opened.contains(number) else { return }
        opened.insert(number)
        save()
    }

    /// Both questions right: the letter is decoded and its clue goes on the board.
    func markSolved(_ number: Int) {
        guard !solved.contains(number) || !clues.contains(number) else { return }
        opened.insert(number)
        solved.insert(number)
        clues.insert(number)
        save()
    }

    /// 0 → 1 → 2 → 3 → 0. Returns the new level.
    @discardableResult
    func cycleSuspicion(_ id: String) -> Int {
        let next = (level(of: id) + 1) % 4
        suspicion[id] = next
        save()
        return next
    }

    func level(of id: String) -> Int { suspicion[id] ?? 0 }

    func markRevealSeen() {
        guard !revealSeen else { return }
        revealSeen = true
        save()
    }

    func reset() {
        opened = []; solved = []; clues = []; suspicion = [:]; revealSeen = false
        defaults.removeObject(forKey: Self.defaultsKey)
    }

    // MARK: - Availability

    /// Letter n arrives when sheet n is the current sheet or already behind you.
    func isAvailable(_ number: Int, progress: ProgressStore) -> Bool {
        number <= progress.currentSheetNumber || progress.completedSheets.count >= ContentStore.totalSheets
    }

    func available(in content: LetterContent, progress: ProgressStore) -> [Letter] {
        content.letters.filter { isAvailable($0.number, progress: progress) }
    }

    func unreadCount(in content: LetterContent, progress: ProgressStore) -> Int {
        available(in: content, progress: progress).filter { !opened.contains($0.number) }.count
    }

    // MARK: - Saving

    private struct Saved: Codable {
        var opened: [Int]?
        var solved: [Int]?
        var clues: [Int]?
        var suspicion: [String: Int]?
        var revealSeen: Bool?
    }

    private func save() {
        let saved = Saved(opened: opened.sorted(), solved: solved.sorted(), clues: clues.sorted(),
                          suspicion: suspicion, revealSeen: revealSeen)
        if let data = try? JSONEncoder().encode(saved) { defaults.set(data, forKey: Self.defaultsKey) }
    }
}

/// The letters as the learner sees them right now: what has arrived, what's next, what's coming.
struct LetterShelf {
    let available: [Letter]
    let unread: [Letter]
    /// The next letter to read in story order (the earliest unread), else the latest one.
    let next: Letter?
    /// Letters not here yet (their sheet isn't reached).
    let upcoming: [Letter]
    let latest: Letter?

    init(content: LetterContent, store: LetterStore, progress: ProgressStore) {
        let available = store.available(in: content, progress: progress)
        self.available = available
        unread = available.filter { !store.opened.contains($0.number) }
        latest = available.last
        next = unread.first ?? available.last
        let numbers = Set(available.map(\.number))
        upcoming = content.letters.filter { !numbers.contains($0.number) }
    }

    var unreadCount: Int { unread.count }
}
