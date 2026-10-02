import Foundation
import Observation
import SwiftUI

/// Ballonnen rules: 8 words, three balloons rise with meanings; pop the right one.
@Observable
final class BalloonsGame {
    enum Phase { case ready, playing, done }
    enum Outcome { case hit, wrong, missed }

    struct Question {
        let word: Word
        let options: [String]
        var correct: Int { options.firstIndex(of: word.en) ?? 0 }
    }

    static let questionCount = 8
    static let baseDuration: TimeInterval = 7
    static let minDuration: TimeInterval = 3.6
    /// Each balloon leaves a little later than the one before it.
    static let delays: [TimeInterval] = [0, 0.38, 0.18]

    let questions: [Question]
    private(set) var phase: Phase = .ready
    private(set) var index = 0
    private(set) var launchDate = Date.now
    private(set) var duration = baseDuration
    private(set) var picked: Int?
    private(set) var outcome: Outcome?
    /// Balloons stop where they are once the question is answered.
    private(set) var frozenAt: Date?
    private(set) var score = 0
    private(set) var combo = 0

    @ObservationIgnored private let round: RoundModel
    @ObservationIgnored private var pending: Task<Void, Never>?

    init(round: RoundModel) {
        self.round = round
        questions = round.pool.shuffled().prefix(Self.questionCount).map { word in
            Question(word: word, options: round.options(for: word))
        }
    }

    var question: Question? {
        questions.indices.contains(index) ? questions[index] : nil
    }

    func start() {
        guard phase == .ready, !questions.isEmpty else { return }
        phase = .playing
        round.balloons = RoundModel.Score(right: 0, total: questions.count)
        launch(0, duration: Self.baseDuration)
    }

    func stop() {
        pending?.cancel()
    }

    /// 0...1 rise progress of balloon `k` at `date`.
    func rise(of k: Int, at date: Date) -> Double {
        let now = frozenAt ?? date
        let delay = Self.delays[k % Self.delays.count]
        let t = now.timeIntervalSince(launchDate) - delay
        return max(0, min(1, t / duration))
    }

    func pop(_ k: Int) {
        guard phase == .playing, outcome == nil, let question, question.options.indices.contains(k) else { return }
        let ok = k == question.correct
        pending?.cancel()
        withAnimation(.spring(response: 0.28, dampingFraction: 0.6)) {
            frozenAt = .now
            picked = k
            outcome = ok ? .hit : .wrong
            if ok {
                score += 1
                combo += 1
            } else {
                combo = 0
            }
        }
        round.record(question.word.id, ok ? .good : .again)
        round.balloons = RoundModel.Score(right: score, total: questions.count)
        if ok {
            Haptics.success()
        } else {
            Haptics.error()
        }
        later(ok ? 0.85 : 1.4) { $0.next() }
    }

    private func miss(_ i: Int) {
        guard phase == .playing, index == i, outcome == nil, let question else { return }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            frozenAt = .now
            outcome = .missed
            combo = 0
        }
        round.record(question.word.id, .again)
        Haptics.thump()
        later(1.3) { $0.next() }
    }

    private func next() {
        let n = index + 1
        guard n < questions.count else {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) { phase = .done }
            return
        }
        launch(n, duration: max(Self.minDuration, Self.baseDuration - Double(combo) * 0.6))
    }

    private func launch(_ i: Int, duration: TimeInterval) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            index = i
            picked = nil
            outcome = nil
            frozenAt = nil
        }
        self.duration = duration
        launchDate = .now
        if let word = question?.word { Speech.shared.say(word.spoken) }
        let lastDelay = Self.delays.max() ?? 0
        later(duration + max(0.5, lastDelay + 0.1)) { $0.miss(i) }
    }

    private func later(_ seconds: Double, _ work: @escaping (BalloonsGame) -> Void) {
        pending?.cancel()
        pending = Task { [weak self] in
            try? await Task.sleep(for: .seconds(seconds))
            guard !Task.isCancelled, let self else { return }
            work(self)
        }
    }
}
