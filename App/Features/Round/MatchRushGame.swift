import Foundation
import Observation
import SwiftUI

/// Match rush rules: 45 seconds, a board of Dutch words and their meanings.
/// Every right pair is replaced by a new one from the pool.
@Observable
final class MatchRushGame {
    enum Phase { case ready, playing, done }
    enum Side { case dutch, english }

    /// One card position on the board. `id` changes when a new word lands in the slot.
    struct Slot: Identifiable, Equatable {
        let id: Int
        let word: Word
    }

    struct Flash: Equatable {
        let left: Int
        let right: Int
        let ok: Bool
    }

    static let duration: TimeInterval = 45
    static let boardSize = 5

    private(set) var phase: Phase = .ready
    private(set) var left: [Slot] = []
    private(set) var right: [Slot] = []
    private(set) var selectedLeft: Int?
    private(set) var selectedRight: Int?
    private(set) var flash: Flash?
    private(set) var pairs = 0
    private(set) var combo = 0
    private(set) var best = 0
    private(set) var startDate: Date?
    /// Bumps on every wrong pair (drives the shake).
    private(set) var misses = 0

    @ObservationIgnored private let round: RoundModel
    @ObservationIgnored private var queue: [Word]
    @ObservationIgnored private var cursor = 0
    @ObservationIgnored private var nextID = 0
    @ObservationIgnored private var pending: Task<Void, Never>?
    @ObservationIgnored private var clock: Task<Void, Never>?

    init(round: RoundModel) {
        self.round = round
        queue = round.pool.shuffled()
        var board: [Word] = []
        for _ in 0..<min(Self.boardSize, round.pool.count) {
            guard let word = drawWord(avoiding: board) else { break }
            board.append(word)
        }
        left = board.map { makeSlot($0) }
        right = Self.deranged(board).map { makeSlot($0) }
    }

    /// A shuffle where no word stays in its own row, so no pair starts side by side.
    private static func deranged(_ words: [Word]) -> [Word] {
        guard words.count > 1 else { return words }
        for _ in 0..<30 {
            let candidate = words.shuffled()
            if !zip(words, candidate).contains(where: { $0.id == $1.id }) { return candidate }
        }
        return Array(words[1...] + words[..<1])
    }

    func remaining(at date: Date) -> TimeInterval {
        switch phase {
        case .ready: Self.duration
        case .done: 0
        case .playing: max(0, Self.duration - date.timeIntervalSince(startDate ?? date))
        }
    }

    func start() {
        guard phase == .ready else { return }
        startDate = .now
        phase = .playing
        clock = Task { [weak self] in
            try? await Task.sleep(for: .seconds(Self.duration))
            guard !Task.isCancelled else { return }
            self?.finish()
        }
    }

    func stop() {
        clock?.cancel()
        pending?.cancel()
    }

    func pick(_ side: Side, _ index: Int) {
        guard phase == .playing, flash == nil else { return }
        switch side {
        case .dutch:
            guard left.indices.contains(index) else { return }
            selectedLeft = selectedLeft == index ? nil : index
        case .english:
            guard right.indices.contains(index) else { return }
            selectedRight = selectedRight == index ? nil : index
        }
        guard let l = selectedLeft, let r = selectedRight else {
            Haptics.tap()
            return
        }
        check(l, r)
    }

    private func check(_ l: Int, _ r: Int) {
        let word = left[l].word
        if word.id == right[r].word.id {
            combo += 1
            best = max(best, combo)
            pairs += 1
            flash = Flash(left: l, right: r, ok: true)
            round.record(word.id, .good)
            KlinkerAudio.shared.play(.correct)
            Speech.shared.say(word.spoken)
            Haptics.success()
            later(0.32) { $0.replace(l, r) }
        } else {
            combo = 0
            misses += 1
            flash = Flash(left: l, right: r, ok: false)
            round.record(word.id, .again)
            KlinkerAudio.shared.play(.wrong)
            Haptics.error()
            later(0.45) { game in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    game.clearSelection()
                }
            }
        }
        syncScore()
    }

    private func replace(_ l: Int, _ r: Int) {
        let others = left.enumerated().filter { $0.offset != l }.map(\.element.word)
        let matched = left[l].word
        withAnimation(.spring(response: 0.42, dampingFraction: 0.72)) {
            // Prefer a different word; only repeat the same one when the pool is tiny.
            if let word = drawWord(avoiding: others + [matched]) ?? drawWord(avoiding: others) {
                left[l] = makeSlot(word)
                right[r] = makeSlot(word)
                // A new pair must never land in the same row, or the answer is given away.
                if l == r, right.count > 1 {
                    let k = (r + Int.random(in: 1..<right.count)) % right.count
                    right.swapAt(r, k)
                }
            }
            clearSelection()
        }
    }

    private func clearSelection() {
        selectedLeft = nil
        selectedRight = nil
        flash = nil
    }

    private func finish() {
        guard phase == .playing else { return }
        pending?.cancel()
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
            clearSelection()
            phase = .done
        }
        syncScore()
        Haptics.thump()
    }

    private func syncScore() {
        round.pairs = pairs
        round.bestCombo = max(round.bestCombo, best)
    }

    private func later(_ seconds: Double, _ work: @escaping (MatchRushGame) -> Void) {
        pending?.cancel()
        pending = Task { [weak self] in
            try? await Task.sleep(for: .seconds(seconds))
            guard !Task.isCancelled, let self else { return }
            work(self)
        }
    }

    // MARK: - Board

    private func makeSlot(_ word: Word) -> Slot {
        nextID += 1
        return Slot(id: nextID, word: word)
    }

    /// Next word from the shuffled pool that isn't on the board yet
    /// (and whose meaning isn't on the board either, so every pair is unambiguous).
    private func drawWord(avoiding board: [Word]) -> Word? {
        guard !queue.isEmpty else { return nil }
        let ids = Set(board.map(\.id))
        let meanings = Set(board.map { RoundModel.key($0.en) })
        let dutch = Set(board.map { RoundModel.key($0.nl) })
        for _ in 0..<(queue.count * 2) {
            if cursor >= queue.count {
                cursor = 0
                queue.shuffle()
            }
            let word = queue[cursor]
            cursor += 1
            if !ids.contains(word.id), !meanings.contains(RoundModel.key(word.en)), !dutch.contains(RoundModel.key(word.nl)) {
                return word
            }
        }
        return nil
    }
}
