import Foundation
import Observation
import SwiftData

enum SheetStatus: Equatable {
    /// All words learned (level 3+), memory fresh.
    case built
    /// Learned, but 3+ words are slipping (retrievability under 85%).
    case fading
    /// The sheet you're on now.
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
    }

    private enum Keys {
        static let completed = "682.completedSheets"
        static let days = "682.activeDays"
    }

    // MARK: - Words

    func state(_ id: String) -> MemoryState? { states[id] }

    /// 0 Nieuw · 1 Gezien · 2 Herkennen · 3 Onthouden · 4 Beheerst
    func level(_ id: String) -> Int { states[id]?.level ?? 0 }

    func retrievability(_ id: String, now: Date = .now) -> Double? {
        guard let s = states[id], s.reps > 0 else { return nil }
        return s.retrievability(at: now)
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

    func isLearned(_ sheet: Sheet) -> Bool {
        !sheet.words.isEmpty && sheet.words.allSatisfy { level($0.id) >= 3 }
    }

    private func updateCompletedSheets() {
        var changed = false
        for sheet in content.sheets where !completedSheets.contains(sheet.number) && isLearned(sheet) {
            completedSheets.insert(sheet.number)
            changed = true
        }
        if changed { defaults.set(Array(completedSheets), forKey: Keys.completed) }
    }

    /// The first sheet that isn't finished yet.
    var currentSheetNumber: Int {
        content.sheets.first { !completedSheets.contains($0.number) }?.number
            ?? min(ContentStore.totalSheets, (content.sheets.last?.number ?? 0) + 1)
    }

    var currentSheet: Sheet? { content.sheet(currentSheetNumber) }

    func status(ofSheet number: Int, now: Date = .now) -> SheetStatus {
        if completedSheets.contains(number), let sheet = content.sheet(number) {
            let fading = sheet.words.filter { isFading($0.id, now: now) }.count
            return fading >= 3 ? .fading : .built
        }
        if number == currentSheetNumber, content.sheet(number) != nil { return .current }
        return .locked
    }

    /// Words of a sheet that are slipping, most urgent first.
    func fadingWords(inSheet number: Int, now: Date = .now) -> [Word] {
        guard let sheet = content.sheet(number) else { return [] }
        return sheet.words
            .filter { isFading($0.id, now: now) }
            .sorted { (retrievability($0.id, now: now) ?? 0) < (retrievability($1.id, now: now) ?? 0) }
    }

    // MARK: - Counts

    /// Words on the wall: every word of finished sheets plus the current sheet.
    var wordsOnWall: Int {
        content.sheets.filter { completedSheets.contains($0.number) || $0.number == currentSheetNumber }
            .reduce(0) { $0 + $1.words.count }
    }

    var masteredCount: Int { states.values.filter { $0.level >= 3 }.count }

    func learnedCount(inSheet number: Int) -> Int {
        content.sheet(number)?.words.filter { level($0.id) >= 3 }.count ?? 0
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
