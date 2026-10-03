import XCTest
@testable import Klinker

@MainActor
final class FSRSTests: XCTestCase {
    private let fsrs = FSRS.default
    private let start = Date(timeIntervalSince1970: 1_790_000_000)

    func testFirstAnswerSetsInitialStability() {
        let good = fsrs.review(nil, rating: .good, now: start)
        XCTAssertEqual(good.stability, 2.4, accuracy: 0.001)
        XCTAssertEqual(good.reps, 1)
        XCTAssertEqual(good.level, 2)

        let again = fsrs.review(nil, rating: .again, now: start)
        XCTAssertEqual(again.lapses, 1)
        XCTAssertLessThan(again.stability, good.stability)
    }

    func testRetrievabilityIsNinetyPercentAfterOneStability() {
        XCTAssertEqual(FSRS.retrievability(days: 10, stability: 10), 0.9, accuracy: 0.001)
        XCTAssertEqual(FSRS.retrievability(days: 0, stability: 10), 1, accuracy: 0.0001)
    }

    func testSuccessfulReviewAfterDelayGrowsStability() {
        let first = fsrs.review(nil, rating: .good, now: start)
        let later = start.addingTimeInterval(3 * 86_400)
        let second = fsrs.review(first, rating: .good, now: later)
        XCTAssertGreaterThan(second.stability, first.stability * 1.5)
        XCTAssertEqual(second.reps, 2)
    }

    func testForgettingShrinksStability() {
        var state = fsrs.review(nil, rating: .good, now: start)
        state = fsrs.review(state, rating: .good, now: start.addingTimeInterval(3 * 86_400))
        let lapse = fsrs.review(state, rating: .again, now: start.addingTimeInterval(20 * 86_400))
        XCTAssertLessThan(lapse.stability, state.stability)
        XCTAssertEqual(lapse.lapses, 1)
    }

    func testSameSessionRepeatsOnlyNudge() {
        let first = fsrs.review(nil, rating: .good, now: start)
        let repeated = fsrs.review(first, rating: .good, now: start.addingTimeInterval(60))
        XCTAssertLessThan(repeated.stability, first.stability * 1.2)
    }

    func testLevels() {
        func state(_ s: Double) -> MemoryState { MemoryState(stability: s, difficulty: 5, reps: 3, lapses: 0, lastReview: start, due: nil) }
        XCTAssertEqual(state(1).level, 1)
        XCTAssertEqual(state(5).level, 2)
        XCTAssertEqual(state(10).level, 3)
        XCTAssertEqual(state(40).level, 4)
    }

    func testProgressCurrentSheetAndStatus() {
        let words = (0..<3).map { Word(id: "w\($0)", nl: "woord\($0)", article: .de, pos: .noun, en: "word", forms: "", partners: "", example: "", style: $0) }
        let other = Word(id: "x", nl: "x", article: .het, pos: .noun, en: "x", forms: "", partners: "", example: "", style: 1)
        let content = ContentStore(sheets: [
            Sheet(number: 1, title: "Een", place: "Station", words: words, sentences: []),
            Sheet(number: 2, title: "Twee", place: "Bakker", words: [other], sentences: []),
        ])
        let defaults = UserDefaults(suiteName: "682.tests.\(UUID().uuidString)")!
        let progress = ProgressStore(context: nil, content: content, defaults: defaults)
        XCTAssertEqual(progress.currentSheetNumber, 1)
        XCTAssertEqual(progress.status(ofSheet: 2), .locked)

        // Learn sheet 1 over several spaced days.
        var t = start
        for _ in 0..<4 {
            for w in words { progress.record(w.id, .good, now: t) }
            t = t.addingTimeInterval(6 * 86_400)
        }
        XCTAssertTrue(words.allSatisfy { progress.level($0.id) >= 3 })
        XCTAssertEqual(progress.currentSheetNumber, 2)
        XCTAssertEqual(progress.status(ofSheet: 1, now: t), .built)
        XCTAssertEqual(progress.status(ofSheet: 1, now: t.addingTimeInterval(400 * 86_400)), .fading)
    }

    func testNextPlaceOpensAfterEveryWordIsRightOnce() {
        let words = (0..<3).map { Word(id: "u\($0)", nl: "woord\($0)", article: .de, pos: .noun, en: "word", forms: "", partners: "", example: "", style: $0) }
        let other = Word(id: "v", nl: "v", article: .het, pos: .noun, en: "v", forms: "", partners: "", example: "", style: 1)
        let content = ContentStore(sheets: [
            Sheet(number: 1, title: "Een", place: "Station", words: words, sentences: []),
            Sheet(number: 2, title: "Twee", place: "Bakker", words: [other], sentences: []),
        ])
        let defaults = UserDefaults(suiteName: "682.tests.\(UUID().uuidString)")!
        let progress = ProgressStore(context: nil, content: content, defaults: defaults)

        // A wrong answer doesn't count as met.
        progress.record("u0", .again, now: start)
        XCTAssertFalse(progress.isMet("u0"))
        XCTAssertEqual(progress.currentSheetNumber, 1)

        // One right answer for every word, all on day one: the next place opens.
        for w in words { progress.record(w.id, .good, now: start.addingTimeInterval(60)) }
        XCTAssertEqual(progress.metCount(inSheet: 1), 3)
        XCTAssertEqual(progress.currentSheetNumber, 2)
        XCTAssertEqual(progress.status(ofSheet: 1, now: start), .growing)
        XCTAssertEqual(progress.status(ofSheet: 2, now: start), .current)
        XCTAssertEqual(progress.wordsOnWall, 4)
    }

    func testTestModeOpensEveryPlaceWithoutTouchingProgress() {
        let words = (0..<2).map { Word(id: "t\($0)", nl: "woord\($0)", article: .de, pos: .noun, en: "word", forms: "", partners: "", example: "", style: $0) }
        let later = Word(id: "z", nl: "z", article: .het, pos: .noun, en: "z", forms: "", partners: "", example: "", style: 1)
        let content = ContentStore(sheets: [
            Sheet(number: 1, title: "Een", place: "Station", words: words, sentences: []),
            Sheet(number: 2, title: "Twee", place: "Bakker", words: [later], sentences: []),
        ])
        let defaults = UserDefaults(suiteName: "682.tests.\(UUID().uuidString)")!
        let progress = ProgressStore(context: nil, content: content, defaults: defaults)
        XCTAssertEqual(progress.status(ofSheet: 2), .locked)

        progress.setUnlockAll(true)
        XCTAssertEqual(progress.status(ofSheet: 2), .growing)
        XCTAssertTrue(progress.isOpenedByTestMode(2))
        XCTAssertEqual(progress.currentSheetNumber, 1, "test mode never moves real progress")
        XCTAssertEqual(progress.status(ofSheet: 3), .locked, "places without content stay locked")

        // Remembered across launches, and off restores the locks.
        XCTAssertTrue(ProgressStore(context: nil, content: content, defaults: defaults).unlockAll)
        progress.setUnlockAll(false)
        XCTAssertEqual(progress.status(ofSheet: 2), .locked)
    }
}
