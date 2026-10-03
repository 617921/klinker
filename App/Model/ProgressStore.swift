import Foundation
import Observation
import SwiftData

enum SheetStatus: Equatable {
    /// All words firmly remembered (level 3+), memory fresh. Scaffolding is off.
    case built
    /// Built, but 3+ words are slipping (retrievability under 85%).
    case fading
    /// Every word answered right at least once, but not yet firmly remembered.
    /// The next place is open; this one keeps its scaffolding until reviews make it stick.
    case growing
    /// The sheet you're on now: not every word answered right yet.
    case current
    /// Not reached yet, or no content yet.
    case locked
}

/// The learner's progress: FSRS memory per word, finished sheets and streak.
/// Single source of truth for every screen. Inject with `.environment(progress)`.
@Observable
final class ProgressStore {
    @ObservationIgnored private let context: ModelContext?
    @ObservationIgnored let content: ContentStore
    @ObservationIgnored private let fsrs = FSRS.default
    @ObservationIgnored private var cards: [String: Card] = [:]
    @ObservationIgnored private let defaults: UserDefaults

    private(set) var states: [String: MemoryState] = [:]
    private(set) var completedSheets: Set<Int> = []
    private(set) var activeDays: Set<String> = []
    /// Test mode: every place with content is open, whatever the learner knows.
    /// Real progress is untouched, so switching it off restores the normal locks.
    private(set) var unlockAll = false

    static let fadingThreshold = 0.85

    init(context: ModelContext?, content: ContentStore = .shared, defaults: UserDefaults = .standard) {
        self.context = context
        self.content = content
        self.defaults = defaults
        if let context, let stored = try? context.fetch(FetchDescriptor<Card>()) {
            for card in stored {
                cards[card.wordID] = card
                states[card.wordID] = card.state
            }
        }
        completedSheets = Set(defaults.array(forKey: Keys.completed) as? [Int] ?? [])
        activeDays = Set(defaults.stringArray(forKey: Keys.days) ?? [])
        unlockAll = defaults.bool(forKey: Keys.unlockAll)
    }

    private enum Keys {
        static let completed = "682.completedSheets"
        static let days = "682.activeDays"
        static let unlockAll = "klinker.unlockAll"
    }

    // MARK: - Words

    func state(_ id: String) -> MemoryState? { states[id] }

    /// 0 Nieuw · 1 Gezien · 2 Herkennen · 3 Onthouden · 4 Beheerst
    func level(_ id: String) -> Int { states[id]?.level ?? 0 }

    func retrievability(_ id: String, now: Date = .now) -> Double? {
        guard let s = states[id], s.reps > 0 else { return nil }
        return s.retrievability(at: now)
    }

    /// Answered right at least once (every answer that wasn't "again").
    func isMet(_ id: String) -> Bool {
        guard let s = states[id] else { return false }
        return s.reps - s.lapses >= 1
    }

    func isFading(_ id: String, now: Date = .now) -> Bool {
        guard let r = retrievability(id, now: now) else { return false }
        return r < Self.fadingThreshold
    }

    /// Records one answer and returns the new memory state.
    @discardableResult
    func record(_ id: String, _ rating: Rating, now: Date = .now) -> MemoryState {
        let next = fsrs.review(states[id], rating: rating, now: now)
        states[id] = next
        if let card = cards[id] {
            card.state = next
        } else if let context {
            let card = Card(wordID: id, state: next)
            context.insert(card)
            cards[id] = card
        }
        try? context?.save()
        markActive(now)
        updateCompletedSheets()
        return next
    }

    // MARK: - Sheets

    /// Firmly remembered: every word at level 3+ ("Onthouden"). Takes the scaffolding off.
    func isLearned(_ sheet: Sheet) -> Bool {
        !sheet.words.isEmpty && sheet.words.allSatisfy { level($0.id) >= 3 }
    }

    /// Every word answered right at least once. Opens the next place.
    func isIntroduced(_ sheet: Sheet) -> Bool {
        !sheet.words.isEmpty && sheet.words.allSatisfy { isMet($0.id) }
    }

    private func updateCompletedSheets() {
        var changed = false
        for sheet in content.sheets where !completedSheets.contains(sheet.number) && isLearned(sheet) {
            completedSheets.insert(sheet.number)
            changed = true
        }
        if changed { defaults.set(Array(completedSheets), forKey: Keys.completed) }
    }

    /// The first sheet whose words haven't all been answered right yet.
    /// Places open one a day or so; firm memory comes later through reviews.
    var currentSheetNumber: Int {
        content.sheets.first { !completedSheets.contains($0.number) && !isIntroduced($0) }?.number
            ?? min(ContentStore.totalSheets, (content.sheets.last?.number ?? 0) + 1)
    }

    var currentSheet: Sheet? { content.sheet(currentSheetNumber) }

    func status(ofSheet number: Int, now: Date = .now) -> SheetStatus {
        if completedSheets.contains(number), let sheet = content.sheet(number) {
            let fading = sheet.words.filter { isFading($0.id, now: now) }.count
            return fading >= 3 ? .fading : .built
        }
        let current = currentSheetNumber
        if number == current, content.sheet(number) != nil { return .current }
        if number < current, content.sheet(number) != nil { return .growing }
        if unlockAll, content.sheet(number) != nil { return .growing }
        return .locked
    }

    /// Turns test mode (all places open) on or off. Remembered across launches.
    func setUnlockAll(_ on: Bool) {
        unlockAll = on
        defaults.set(on, forKey: Keys.unlockAll)
    }

    /// Open only because of test mode: the learner hasn't reached this place yet.
    func isOpenedByTestMode(_ number: Int) -> Bool {
        unlockAll && number > currentSheetNumber && content.sheet(number) != nil
    }

    /// Words of a sheet that are slipping, most urgent first.
    func fadingWords(inSheet number: Int, now: Date = .now) -> [Word] {
        guard let sheet = content.sheet(number) else { return [] }
        return sheet.words
            .filter { isFading($0.id, now: now) }
            .sorted { (retrievability($0.id, now: now) ?? 0) < (retrievability($1.id, now: now) ?? 0) }
    }

    // MARK: - Counts

    /// Words you've reached: every word of open places (up to and including the current one).
    var wordsOnWall: Int {
        let current = currentSheetNumber
        return content.sheets.filter { completedSheets.contains($0.number) || $0.number <= current }
            .reduce(0) { $0 + $1.words.count }
    }

    var masteredCount: Int { states.values.filter { $0.level >= 3 }.count }

    func learnedCount(inSheet number: Int) -> Int {
        content.sheet(number)?.words.filter { level($0.id) >= 3 }.count ?? 0
    }

    /// Words of a sheet answered right at least once.
    func metCount(inSheet number: Int) -> Int {
        content.sheet(number)?.words.filter { isMet($0.id) }.count ?? 0
    }

    // MARK: - Rounds

    /// Words due for review, most forgotten first.
    func dueWords(now: Date = .now, limit: Int = 20) -> [Word] {
        states
            .filter { $0.value.reps > 0 && ($0.value.due ?? .distantFuture) <= now }
            .sorted { $0.value.retrievability(at: now) < $1.value.retrievability(at: now) }
            .prefix(limit)
            .compactMap { content.word($0.key) }
    }

    /// How many words want a review now (outside the current sheet, which the round covers anyway).
    func reviewCount(now: Date = .now) -> Int {
        let current = Set(currentSheet?.words.map(\.id) ?? [])
        return states.filter { !current.contains($0.key) && $0.value.reps > 0 && ($0.value.due ?? .distantFuture) <= now }.count
    }

    /// The words for a round: the current sheet first, then due reviews.
    func roundPool(now: Date = .now, reviews: Int = 8) -> [Word] {
        var pool = currentSheet?.words ?? []
        let ids = Set(pool.map(\.id))
        pool += dueWords(now: now, limit: reviews).filter { !ids.contains($0.id) }
        return pool
    }

    // MARK: - Streak

    private static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    private func markActive(_ date: Date) {
        let key = Self.dayFormatter.string(from: date)
        guard !activeDays.contains(key) else { return }
        activeDays.insert(key)
        defaults.set(Array(activeDays), forKey: Keys.days)
    }

    /// Whether the learner answered anything on this day.
    func wasActive(on date: Date = .now) -> Bool {
        activeDays.contains(Self.dayFormatter.string(from: date))
    }

    /// Consecutive days with at least one answer, ending today or yesterday.
    func streak(now: Date = .now) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        var day = now
        if !activeDays.contains(Self.dayFormatter.string(from: day)) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: day),
                  activeDays.contains(Self.dayFormatter.string(from: yesterday)) else { return 0 }
            day = yesterday
        }
        var count = 0
        while activeDays.contains(Self.dayFormatter.string(from: day)) {
            count += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = previous
        }
        return count
    }

    // MARK: - Reset and demo

    func reset() {
        if let context {
            for card in cards.values { context.delete(card) }
            try? context.save()
        }
        cards = [:]
        states = [:]
        completedSheets = []
        activeDays = []
        defaults.removeObject(forKey: Keys.completed)
        defaults.removeObject(forKey: Keys.days)
    }

    /// Jumps to the demo moment: sheets 1–13 learned (Café and Huisarts fading), sheet 14 half-way, 12-day streak.
    func seedDemo(now: Date = .now) {
        reset()
        let day: Double = 86_400
        func put(_ id: String, stability: Double, reps: Int, lapses: Int = 0, daysAgo: Double) {
            let last = now.addingTimeInterval(-daysAgo * day)
            let state = MemoryState(
                stability: stability, difficulty: 5, reps: reps, lapses: lapses,
                lastReview: last, due: last.addingTimeInterval(stability * day)
            )
            states[id] = state
            if let context {
                let card = Card(wordID: id, state: state)
                context.insert(card)
                cards[id] = card
            }
        }
        for sheet in content.sheets where sheet.number < 14 {
            let fading = sheet.number == 6 || sheet.number == 9
            for (i, word) in sheet.words.enumerated() {
                if fading && i < 4 {
                    put(word.id, stability: 8, reps: 4, lapses: 1, daysAgo: 26)
                } else {
                    put(word.id, stability: 30 + Double(i), reps: 6, daysAgo: 4)
                }
            }
            completedSheets.insert(sheet.number)
        }
        let sheet14: [String: Int] = [
            "afspraak": 1, "formulier": 3, "loket": 1, "invullen": 2, "verplicht": 3, "geldig": 1,
        ]
        for (id, level) in sheet14 {
            switch level {
            case 1: put(id, stability: 1.2, reps: 1, daysAgo: 1)
            case 2: put(id, stability: 4, reps: 2, daysAgo: 1)
            default: put(id, stability: 10, reps: 3, daysAgo: 2)
            }
        }
        try? context?.save()
        defaults.set(Array(completedSheets), forKey: Keys.completed)
        let calendar = Calendar(identifier: .gregorian)
        for back in 0..<12 {
            if let d = calendar.date(byAdding: .day, value: -back - 1, to: now) {
                activeDays.insert(Self.dayFormatter.string(from: d))
            }
        }
        defaults.set(Array(activeDays), forKey: Keys.days)
    }
}
