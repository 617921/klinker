import SwiftUI
import Observation

/// The three ways to use the palace.
enum PalaceMode: String, CaseIterable, Identifiable {
    case verken, waar, weg

    var id: String { rawValue }

    var label: String {
        switch self {
        case .verken: "Verken"
        case .waar: "Waar is…?"
        case .weg: "Wat is weg?"
        }
    }
}

/// How an object in the room looks right now.
enum PalaceLook: Equatable {
    case plain, selected, right, wrong, pulse, hidden
}

/// Game state for one palace: Verken, Waar is…? and Wat is weg?
/// Right and wrong answers are recorded in FSRS through `ProgressStore`.
@Observable
final class PalaceGame {
    let room: PalaceRoom

    private(set) var mode: PalaceMode = .verken

    // Verken
    private(set) var found: Set<String> = []
    private(set) var selected: String?

    // Waar is…?
    private(set) var waarOrder: [String]
    private(set) var waarIndex = 0
    private(set) var waarScore = 0
    private(set) var waarDone = false
    private(set) var waarSeen: Set<String> = []
    /// The last tap: which object, and whether it was right.
    private(set) var waarTap: (id: String, right: Bool)?
    private var waarRounds = 0

    // Wat is weg?
    enum WegPhase { case look, gone, answered }
    private(set) var wegRounds: [PalaceWegRound] = []
    private(set) var wegIndex = 0
    private(set) var wegPhase: WegPhase = .look
    private(set) var wegPick: Int?
    private(set) var wegScore = 0
    private(set) var wegDone = false
    private var wegPlays = 0

    /// Bumped on a wrong tap, per object, to play a shake.
    private(set) var shakes: [String: Int] = [:]

    @ObservationIgnored private var timer: Task<Void, Never>?

    static let wegRoundCount = 5

    init(room: PalaceRoom) {
        self.room = room
        self.waarOrder = room.waarOrder
    }

    var total: Int { room.spots.count }
    var foundCount: Int { found.count }

    func word(_ id: String) -> Word? { room.spot(id)?.word }

    // MARK: Modes

    func setMode(_ next: PalaceMode) {
        cancelTimer()
        Speech.shared.stop()
        mode = next
        selected = nil
        switch next {
        case .verken:
            break
        case .waar:
            startWaar()
        case .weg:
            startWeg()
        }
    }

    func stop() {
        cancelTimer()
        Speech.shared.stop()
    }

    func resetVerken() {
        found = []
        selected = nil
    }

    // MARK: Taps on objects

    func tap(_ id: String, progress: ProgressStore) {
        guard let word = word(id) else { return }
        switch mode {
        case .verken:
            found.insert(id)
            selected = id
            Speech.shared.say(word.spoken)
            Haptics.tap()
        case .waar:
            answerWaar(id, progress: progress)
        case .weg:
            Speech.shared.say(word.spoken)
        }
    }

    // MARK: Waar is…?

    var waarTarget: Word? {
        guard mode == .waar, !waarDone, waarIndex < waarOrder.count else { return nil }
        return word(waarOrder[waarIndex])
    }

    private func startWaar() {
        waarRounds += 1
        if waarRounds > 1 {
            var ids = room.ids
            ids.shuffle()
            waarOrder = ids
        }
        waarIndex = 0
        waarScore = 0
        waarDone = waarOrder.isEmpty
        waarSeen = []
        waarTap = nil
        schedule(0.35) { $0.sayPrompt() }
    }

    func sayPrompt() {
        guard let target = waarTarget else { return }
        Speech.shared.say(room.promptSentence(for: target))
    }

    private func answerWaar(_ id: String, progress: ProgressStore) {
        guard !waarDone, waarTap == nil, let target = waarTarget else { return }
        waarSeen.insert(target.id)
        if id == target.id {
            waarTap = (id, true)
            waarScore += 1
            progress.record(target.id, .good)
            Speech.shared.say(target.spoken)
            Haptics.success()
            schedule(1.3) { $0.nextQuestion() }
        } else {
            waarTap = (id, false)
            progress.record(target.id, .again)
            shakes[id, default: 0] += 1
            Haptics.error()
            schedule(2.3) { $0.nextQuestion() }
        }
    }

    private func nextQuestion() {
        waarTap = nil
        if waarIndex + 1 >= waarOrder.count {
            waarDone = true
            Haptics.success()
            return
        }
        waarIndex += 1
        sayPrompt()
    }

    // MARK: Wat is weg?

    var wegRound: PalaceWegRound? { wegIndex < wegRounds.count ? wegRounds[wegIndex] : nil }

    private func startWeg() {
        wegPlays += 1
        wegRounds = wegPlays == 1 && room.wegRounds.count >= Self.wegRoundCount
            ? Array(room.wegRounds.prefix(Self.wegRoundCount))
            : Self.randomRounds(room.ids)
        wegIndex = 0
        wegScore = 0
        wegPick = nil
        wegDone = wegRounds.isEmpty
        wegPhase = .look
        if !wegDone { schedule(2) { $0.wegPhase = .gone } }
    }

    func pickWeg(_ k: Int, progress: ProgressStore) {
        guard wegPhase == .gone, !wegDone, let round = wegRound, k < round.options.count else { return }
        let right = round.options[k] == round.target
        wegPick = k
        wegPhase = .answered
        if right { wegScore += 1 }
        progress.record(round.target, right ? .good : .again)
        if let word = word(round.target) { Speech.shared.say(word.spoken) }
        if right { Haptics.success() } else { Haptics.error() }
    }

    func nextWeg() {
        cancelTimer()
        if wegIndex + 1 >= wegRounds.count {
            wegDone = true
            return
        }
        wegIndex += 1
        wegPick = nil
        wegPhase = .look
        schedule(2) { $0.wegPhase = .gone }
    }

    /// Five rounds, each with a different missing word and two other strips.
    static func randomRounds(_ ids: [String]) -> [PalaceWegRound] {
        guard ids.count >= 3 else { return [] }
        let targets = ids.shuffled().prefix(min(wegRoundCount, ids.count))
        return targets.map { target in
            let others = ids.filter { $0 != target }.shuffled().prefix(2)
            return PalaceWegRound(target: target, options: ([target] + others).shuffled())
        }
    }

    // MARK: Looks

    func look(_ id: String) -> PalaceLook {
        switch mode {
        case .verken:
            return selected == id ? .selected : .plain
        case .waar:
            guard let tap = waarTap else { return .plain }
            if tap.id == id { return tap.right ? .right : .wrong }
            if !tap.right, waarTarget?.id == id { return .pulse }
            return .plain
        case .weg:
            guard !wegDone, let round = wegRound, round.target == id else { return .plain }
            switch wegPhase {
            case .look: return .plain
            case .gone: return .hidden
            case .answered:
                return wegPick.map { round.options[$0] == id } == true ? .right : .pulse
            }
        }
    }

    /// Whether the word's strip hangs on its object.
    func isPinned(_ id: String) -> Bool {
        switch mode {
        case .verken: found.contains(id)
        case .waar: waarSeen.contains(id)
        case .weg: look(id) != .hidden
        }
    }

    /// An orange dot marks objects still hiding a word (Verken only).
    func hasDot(_ id: String) -> Bool { mode == .verken && !found.contains(id) }

    // MARK: Timer

    private func schedule(_ seconds: Double, _ action: @escaping (PalaceGame) -> Void) {
        cancelTimer()
        timer = Task { [weak self] in
            try? await Task.sleep(for: .seconds(seconds))
            guard !Task.isCancelled, let self else { return }
            action(self)
        }
    }

    private func cancelTimer() {
        timer?.cancel()
        timer = nil
    }
}
