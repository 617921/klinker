import Foundation
import Observation
import SwiftUI

/// Knip & plak rules: glue cut-out word strips into the right Dutch sentence.
@Observable
final class RansomGame {
    struct Tile: Identifiable, Equatable {
        let id: Int
        let text: String
        let style: Int
        let tilt: Double
    }

    enum Answer { case right, wrong }

    let tasks: [SentenceTask]
    private(set) var index = 0
    /// All tiles of the current sentence, in tray order.
    private(set) var tiles: [Tile] = []
    /// Ids of glued tiles, in glue order.
    private(set) var glued: [Int] = []
    private(set) var answer: Answer?
    private(set) var showEmptyError = false
    private(set) var score = 0
    private(set) var finished = false

    @ObservationIgnored private let round: RoundModel

    init(round: RoundModel) {
        self.round = round
        tasks = round.sentences
        loadTiles()
    }

    var task: SentenceTask? { tasks.indices.contains(index) ? tasks[index] : nil }
    var isLast: Bool { index + 1 >= tasks.count }

    var trayTiles: [Tile] { tiles.filter { !glued.contains($0.id) } }
    var gluedTiles: [Tile] { glued.compactMap { id in tiles.first { $0.id == id } } }

    func glue(_ tile: Tile) {
        guard answer == nil, !glued.contains(tile.id) else { return }
        glued.append(tile.id)
        showEmptyError = false
        Speech.shared.say(tile.text)
        Haptics.tap()
    }

    func unglue(_ tile: Tile) {
        guard answer == nil else { return }
        glued.removeAll { $0 == tile.id }
        Haptics.tap()
    }

    func clear() {
        guard answer == nil, !glued.isEmpty else { return }
        glued = []
        showEmptyError = false
        Haptics.thump()
    }

    func check() {
        guard answer == nil, let task else { return }
        guard !glued.isEmpty else {
            showEmptyError = true
            KlinkerAudio.shared.play(.wrong)
            Haptics.error()
            return
        }
        let built = gluedTiles.map(\.text)
        let ok = built == task.nl
        answer = ok ? .right : .wrong
        if ok { score += 1 }
        for id in task.words {
            round.record(id, ok ? .good : .again)
        }
        round.sentenceScore = RoundModel.Score(right: score, total: tasks.count)
        Speech.shared.say(roundSentenceText(task.nl))
        if ok {
            KlinkerAudio.shared.play(.correct)
            Haptics.success()
        } else {
            KlinkerAudio.shared.play(.wrong)
            Haptics.error()
        }
    }

    /// Next sentence; returns false when this was the last one.
    func next() -> Bool {
        guard !isLast else {
            finished = true
            return false
        }
        index += 1
        glued = []
        answer = nil
        showEmptyError = false
        loadTiles()
        return true
    }

    private func loadTiles() {
        guard let task else {
            tiles = []
            return
        }
        let words = task.nl + task.distractors
        var order = Array(words.indices).shuffled()
        // Never hand out the answer already in order.
        var tries = 0
        while order.prefix(task.nl.count).elementsEqual(task.nl.indices), task.nl.count > 1, tries < 6 {
            order.shuffle()
            tries += 1
        }
        tiles = order.enumerated().map { position, k in
            let text = words[k]
            return Tile(
                id: index * 1_000 + k,
                text: text,
                style: round.style(forToken: text),
                tilt: Double(((position * 53) % 5) - 2) * 1.2
            )
        }
    }
}
