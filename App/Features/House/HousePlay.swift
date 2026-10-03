import SwiftUI

/// A short note card on the stage: a word strip, one line, and a tip.
struct HouseToast: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let style: Int
    let article: Article
    let line: String
    var sub: String?

    static func placed(_ item: HouseItem, room: HouseRoom) -> HouseToast {
        HouseToast(label: item.word, style: item.style, article: item.article,
                   line: "\(item.spokenCapitalized) \(item.verb.rawValue) nu \(room.prep).", sub: item.verb.tip)
    }

    static func back(_ item: HouseItem) -> HouseToast {
        HouseToast(label: item.word, style: item.style, article: item.article,
                   line: "\(item.spokenCapitalized) is terug bij je spullen.")
    }

    static func steen() -> HouseToast {
        HouseToast(label: "gevelsteen", style: 7, article: .de, line: "Jouw huis heet: In de Kat.",
                   sub: "Vroeger hadden huizen geen nummer. Je herkende ze aan de gevelsteen.")
    }

    static func trap() -> HouseToast {
        HouseToast(label: "trap", style: 4, article: .de, line: "Een Hollandse trap is heel steil.",
                   sub: "Een bank of een kast past er niet op. Die gaan via de hijsbalk.")
    }

    static func henk() -> HouseToast {
        HouseToast(label: "buurman", style: 6, article: .de, line: "Henk: Mooi huis, Noor!",
                   sub: "Een grote bank? Die moet via de hijsbalk, hoor.")
    }
}

/// A big object on its way up along the outside, hanging from de hijsbalk.
struct HouseHoist: Equatable {
    let item: HouseItem
    let slot: HouseSlot
    /// Top-left of the hanging box (straps + object) in scene points.
    var left: CGFloat
    var top: CGFloat
    /// Swinging in through the window: the sway stops, straps and rope let go.
    var swingingIn = false

    /// Where the rope hangs from the pulley.
    static let ropeX: CGFloat = 344
    static let ropeTop: CGFloat = 76
    static let strap: CGFloat = 12

    /// On the street, ready to go up.
    static func start(_ item: HouseItem, _ slot: HouseSlot) -> HouseHoist {
        HouseHoist(item: item, slot: slot, left: ropeX - slot.rect.width / 2, top: 416 - slot.rect.height - strap)
    }
}

/// Everything that happens on the house screen: picking, placing, the hoist, notes and sheets.
@Observable
final class HousePlay {
    var inside: Bool
    var selectedID: String?
    /// A locked object that was just tapped (wiggle + hint).
    var nudgedID: String?
    var nudges: [String: Int] = [:]
    var toast: HouseToast?
    var caption: String?
    var hoist: HouseHoist?
    /// The spot that just received a hoisted object: it lands with a squash instead of a drop.
    var landingSlotID: String?
    var info: HouseItem?
    var sharing = false
    var nightOverride: Bool?

    @ObservationIgnored private var toastTask: Task<Void, Never>?
    @ObservationIgnored private var hoistTask: Task<Void, Never>?
    @ObservationIgnored private var cheerTask: Task<Void, Never>?

    init(inside: Bool = false) {
        self.inside = inside
    }

    var selected: HouseItem? { selectedID.flatMap(HouseCatalog.item) }

    // MARK: Your things

    func pick(_ item: HouseItem, state: HouseState) {
        guard hoist == nil else { return }
        guard state.isUnlocked(item) else {
            selectedID = nil
            nudgedID = item.id
            nudges[item.id, default: 0] += 1
            Haptics.tap()
            return
        }
        nudgedID = nil
        if state.slot(of: item) != nil {
            openInfo(item)
            return
        }
        if selectedID == item.id {
            selectedID = nil
            return
        }
        selectedID = item.id
        inside = true
        toast = nil
        Haptics.tap()
        Speech.shared.say(item.spoken)
    }

    func openInfo(_ item: HouseItem) {
        guard hoist == nil else { return }
        selectedID = nil
        nudgedID = nil
        info = item
        Speech.shared.say(item.spoken)
    }

    // MARK: Placing

    func place(at slot: HouseSlot, store: HouseStore, state: HouseState, reduceMotion: Bool) {
        guard hoist == nil, let item = selected, item.kind == slot.kind, state.item(in: slot) == nil else { return }
        let before = state.score
        selectedID = nil
        nudgedID = nil
        if slot.needsHoist {
            startHoist(item, slot, store: store, before: before, reduceMotion: reduceMotion)
            return
        }
        landingSlotID = nil
        withAnimation(reduceMotion ? .easeOut(duration: 0.3) : .spring(response: 0.42, dampingFraction: 0.55)) {
            store.place(item.id, in: slot.id)
        }
        Haptics.tap()
        placed(item, in: slot, before: before, store: store)
    }

    private func placed(_ item: HouseItem, in slot: HouseSlot, before: Int, store: HouseStore) {
        show(.placed(item, room: slot.room), seconds: 2.8)
        Speech.shared.say(item.spoken)
        cheer(before: before, after: HouseState.score(store.placements))
    }

    /// De bank past niet op de trap: up along the facade, sway, swing in through the window, land.
    private func startHoist(_ item: HouseItem, _ slot: HouseSlot, store: HouseStore, before: Int, reduceMotion: Bool) {
        hoistTask?.cancel()
        toastTask?.cancel()
        toast = nil
        info = nil
        caption = "\(item.spokenCapitalized) past niet op de trap. Dus: via de hijsbalk!"
        Speech.shared.say("Via de hijsbalk!")
        let target = slot.rect

        if reduceMotion {
            // No flying furniture: it fades in where it belongs, the caption still explains why.
            landingSlotID = nil
            hoist = HouseHoist(item: item, slot: slot, left: target.minX, top: target.minY - HouseHoist.strap, swingingIn: true)
            hoistTask = Task { [weak self] in
                try? await Task.sleep(for: .milliseconds(1400))
                guard let self, !Task.isCancelled else { return }
                withAnimation(.easeInOut(duration: 0.5)) {
                    store.place(item.id, in: slot.id)
                    self.hoist = nil
                }
                self.finishHoist(item, slot, before: before, store: store, captionDelay: 1.2)
            }
            return
        }

        hoist = .start(item, slot)
        hoistTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(90))
            guard let self, !Task.isCancelled else { return }
            withAnimation(.timingCurve(0.45, 0.05, 0.35, 1, duration: 1.8)) {
                self.hoist?.top = target.minY - HouseHoist.strap
            }
            try? await Task.sleep(for: .milliseconds(1960))
            guard !Task.isCancelled else { return }
            withAnimation(.easeInOut(duration: 0.75)) {
                self.hoist?.left = target.minX
                self.hoist?.swingingIn = true
            }
            try? await Task.sleep(for: .milliseconds(820))
            guard !Task.isCancelled else { return }
            self.landingSlotID = slot.id
            withAnimation(.spring(response: 0.36, dampingFraction: 0.42)) {
                store.place(item.id, in: slot.id)
                self.hoist = nil
            }
            KlinkerAudio.shared.play(.tap)
            Haptics.thump()
            self.finishHoist(item, slot, before: before, store: store, captionDelay: 0)
        }
    }

    private func finishHoist(_ item: HouseItem, _ slot: HouseSlot, before: Int, store: HouseStore, captionDelay: Double) {
        Task { [weak self] in
            if captionDelay > 0 { try? await Task.sleep(for: .seconds(captionDelay)) }
            guard let self else { return }
            withAnimation(.easeOut(duration: 0.2)) { self.caption = nil }
            self.placed(item, in: slot, before: before, store: store)
        }
    }

    func sendBack(_ item: HouseItem, store: HouseStore) {
        withAnimation(.easeOut(duration: 0.25)) {
            store.remove(item.id)
        }
        info = nil
        selectedID = nil
        show(.back(item), seconds: 2)
    }

    private func cheer(before: Int, after: Int) {
        guard after >= 100, before < 100 else { return }
        cheerTask?.cancel()
        cheerTask = Task {
            try? await Task.sleep(for: .milliseconds(1200))
            guard !Task.isCancelled else { return }
            KlinkerAudio.shared.play(.applause)
            Speech.shared.say("Wat gezellig!", after: 0.6)
            Haptics.success()
        }
    }

    // MARK: Notes and taps around the house

    func show(_ toast: HouseToast, seconds: Double) {
        toastTask?.cancel()
        withAnimation(.easeOut(duration: 0.25)) { self.toast = toast }
        AccessibilityNotification.Announcement([toast.line, toast.sub].compactMap { $0 }.joined(separator: " ")).post()
        toastTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(seconds))
            guard let self, !Task.isCancelled else { return }
            withAnimation(.easeIn(duration: 0.2)) { self.toast = nil }
        }
    }

    func tapSteen() {
        show(.steen(), seconds: 4.2)
        Speech.shared.say("de gevelsteen. In de Kat.")
    }

    func tapHenk() {
        show(.henk(), seconds: 3.6)
        Speech.shared.say("Mooi huis, Noor!")
    }

    func tapTrap() {
        guard hoist == nil else { return }
        show(.trap(), seconds: 4.2)
        Speech.shared.say("de trap")
    }

    func toggleView() {
        guard hoist == nil else { return }
        if inside { selectedID = nil }
        inside.toggle()
        toast = nil
        nudgedID = nil
    }

    func startSharing() {
        guard hoist == nil else { return }
        selectedID = nil
        nudgedID = nil
        info = nil
        sharing = true
    }

    /// Leaving the screen: a hoist in progress still lands, so nothing gets lost on the street.
    func stop(store: HouseStore) {
        toastTask?.cancel()
        hoistTask?.cancel()
        cheerTask?.cancel()
        if let hoist {
            store.place(hoist.item.id, in: hoist.slot.id)
            self.hoist = nil
            caption = nil
        }
        Speech.shared.stop()
    }
}
