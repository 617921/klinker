import Foundation
import Observation
import SwiftUI

/// State of one round: which games it plays, the words it uses, the scores so far
/// and the wall levels at the start (to show how the wall changed).
@Observable
final class RoundModel {
    enum Stage: Equatable {
        case match, balloons, ransom, results

        var title: String {
            switch self {
            case .match: RoundKind.match.title
            case .balloons: RoundKind.balloons.title
            case .ransom: RoundKind.ransom.title
            case .results: "Resultaat"
            }
        }
    }

    struct Score: Equatable {
        var right = 0
        var total = 0
    }

    /// A word whose wall level changed during this round.
    struct Change: Identifiable {
        let word: Word
        let from: Int
        let to: Int
        var id: String { word.id }
        var smaller: Bool { to > from }
    }

    let kind: RoundKind
    /// Words for this round: the current sheet first, then due reviews.
    let pool: [Word]
    /// Knip & plak sentences (max 3).
    let sentences: [SentenceTask]
    let stages: [Stage]
    private(set) var stageIndex = 0

    // Scores. `nil` = the game wasn't played in this round.
    var pairs: Int?
    var bestCombo = 0
    var balloons: Score?
    var sentenceScore: Score?

    @ObservationIgnored let progress: ProgressStore
    /// Wall level of every word at the moment it entered the round.
    @ObservationIgnored private var startLevels: [String: Int] = [:]
    @ObservationIgnored private var order: [String] = []
    @ObservationIgnored private lazy var styleByToken: [String: Int] = {
        var map: [String: Int] = [:]
        for word in progress.content.allWords where map[word.nl.lowercased()] == nil {
            map[word.nl.lowercased()] = word.style
        }
        return map
    }()

    init(kind: RoundKind, progress: ProgressStore) {
        self.kind = kind
        self.progress = progress
        let pool = progress.roundPool()
        self.pool = pool
        let sentences = Self.pickSentences(progress: progress, pool: pool)
        self.sentences = sentences

        switch kind {
        case .full:
            stages = sentences.isEmpty ? [.match, .balloons, .results] : [.match, .balloons, .ransom, .results]
        case .match: stages = [.match, .results]
        case .balloons: stages = [.balloons, .results]
        case .ransom: stages = [.ransom, .results]
        }

        for word in pool { snapshot(word.id) }
        for task in sentences {
            for id in task.words where progress.content.word(id) != nil { snapshot(id) }
        }
    }

    var isEmpty: Bool { pool.isEmpty }

    var stage: Stage { stages[min(stageIndex, stages.count - 1)] }

    // MARK: - Flow

    /// Label for the button at the end of a game.
    var nextLabel: String {
        let next = stageIndex + 1
        guard next < stages.count, stages[next] != .results else { return "Bekijk je resultaat" }
        return "Volgende: \(stages[next].title)"
    }

    func advance() {
        guard stageIndex + 1 < stages.count else { return }
        Speech.shared.stop()
        withAnimation(.spring(response: 0.5, dampingFraction: 0.86)) {
            stageIndex += 1
        }
    }

    // MARK: - Answers

    /// Saves one answer right away (progress survives closing the round).
    func record(_ id: String, _ rating: Rating) {
        guard progress.content.word(id) != nil else { return }
        snapshot(id)
        progress.record(id, rating)
    }

    private func snapshot(_ id: String) {
        guard startLevels[id] == nil else { return }
        startLevels[id] = progress.level(id)
        order.append(id)
    }

    /// Every word whose wall level is different now than at the start.
    var changes: [Change] {
        order.compactMap { id in
            guard let from = startLevels[id], let word = progress.content.word(id) else { return nil }
            let to = progress.level(id)
            return to == from ? nil : Change(word: word, from: from, to: to)
        }
    }

    // MARK: - Content helpers

    /// Shuffled answer options: the word's meaning plus English meanings of other words,
    /// preferring the same part of speech.
    func options(for word: Word, count: Int = 3) -> [String] {
        let all = progress.content.allWords
        let groups: [[Word]] = [
            pool.filter { $0.pos == word.pos },
            all.filter { $0.pos == word.pos },
            pool,
            all,
        ]
        var seen: Set<String> = [Self.key(word.en)]
        var picks: [String] = []
        for group in groups {
            for other in group.shuffled() where picks.count < count - 1 && other.id != word.id {
                let key = Self.key(other.en)
                guard !key.isEmpty, !seen.contains(key) else { continue }
                seen.insert(key)
                picks.append(other.en)
            }
            if picks.count >= count - 1 { break }
        }
        return ([word.en] + picks).shuffled()
    }

    /// Strip style for a Knip & plak token: the word's own style when the token is a word,
    /// otherwise a fixed style from the token's text.
    func style(forToken token: String) -> Int {
        let key = token.lowercased()
        if let style = styleByToken[key] { return style }
        return Self.stableHash(key) % StripStyle.all.count
    }

    nonisolated static func key(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    /// FNV-1a: the same token gets the same look on every launch (unlike `hashValue`).
    nonisolated static func stableHash(_ text: String) -> Int {
        var hash: UInt64 = 0xcbf2_9ce4_8422_2325
        for byte in text.utf8 {
            hash ^= UInt64(byte)
            hash = hash &* 0x100_0000_01b3
        }
        return Int(hash % 1_000_003)
    }

    private static func pickSentences(progress: ProgressStore, pool: [Word]) -> [SentenceTask] {
        let ids = Set(pool.map(\.id))
        var list = progress.currentSheet?.sentences ?? []
        if list.isEmpty {
            list = progress.content.sheets
                .filter { sheet in sheet.words.contains { ids.contains($0.id) } }
                .flatMap(\.sentences)
            let practising = list.filter { !ids.isDisjoint(with: $0.words) }
            if !practising.isEmpty { list = practising }
        }
        list = list.filter { !$0.nl.isEmpty }
        // Weakest words first, random among equals.
        func weakness(_ task: SentenceTask) -> Int {
            task.words.map { progress.level($0) }.min() ?? 0
        }
        let ranked = list.shuffled().map { ($0, weakness($0)) }.sorted { $0.1 < $1.1 }.map(\.0)
        return Array(ranked.prefix(3))
    }
}

/// "Ik moet mijn afspraak afzeggen." from tokens, with punctuation tokens glued on.
nonisolated func roundSentenceText(_ tokens: [String]) -> String {
    var text = ""
    for token in tokens {
        let isPunctuation = token.count == 1 && ",.!?;:".contains(token)
        if text.isEmpty || isPunctuation {
            text += token
        } else {
            text += " " + token
        }
    }
    if let last = text.last, !".!?".contains(last) { text += "." }
    return text
}
