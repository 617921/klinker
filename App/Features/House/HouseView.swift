import SwiftUI

/// "Jouw huis", full screen: Noor's canal house that furnishes itself as you learn. Outside you see
/// the facade on its street; inside, a cutaway with four rooms where you put the things you earned.
struct HouseView: View {
    @Environment(ProgressStore.self) private var progress
    @Environment(\.dismiss) private var dismiss

    @State private var play: HousePlay
    @State private var clockNight = NightClock.isNight()
    private let store: HouseStore

    init(store: HouseStore = .shared, play: HousePlay? = nil) {
        self.store = store
        _play = State(initialValue: play ?? HousePlay(inside: !store.placements.isEmpty))
    }

    var body: some View {
        let state = HouseState(store: store, completedSheets: progress.completedSheets)
        let night = play.nightOverride ?? clockNight
        GeometryReader { geo in
            ScrollView(.vertical) {
                HouseScreen(state: state, play: play, store: store, night: night, clockNight: clockNight,
                            scale: HouseScreen.stageScale(for: geo.size)) { dismiss() }
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .background(Theme.paper.ignoresSafeArea())
        .sheet(item: $play.info) { item in
            HouseItemSheet(item: item, room: state.slot(of: item)?.room) {
                play.sendBack(item, store: store)
            }
        }
        .sheet(isPresented: $play.sharing) {
            HouseShareSheet(state: state, night: night)
        }
        .onAppear {
            store.prune(keeping: state.unlocked)
            clockNight = NightClock.isNight()
        }
        .onDisappear { play.stop(store: store) }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(60))
                clockNight = NightClock.isNight()
            }
        }
    }
}

/// The house screen's content, top to bottom: header, stage, meter, your things, hint, share.
struct HouseScreen: View {
    let state: HouseState
    let play: HousePlay
    let store: HouseStore
    let night: Bool
    let clockNight: Bool
    let scale: CGFloat
    let onClose: () -> Void

    /// Height taken by everything except the stage (header, meter, tray, hint, share button).
    private static let chrome: CGFloat = 382

    /// The stage fills the width, but shrinks so the whole screen fits on shorter phones.
    static func stageScale(for size: CGSize) -> CGFloat {
        min(size.width / 390, max(0.72, (size.height - chrome) / 440))
    }

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, 16)
                .padding(.top, 4)
            HouseStage(state: state, play: play, store: store, night: night, scale: scale)
                .frame(maxWidth: .infinity)
                .padding(.top, 6)
            HouseMeter(state: state)
                .padding(.horizontal, 16)
                .padding(.top, 10)
            trayHeader
                .padding(.horizontal, 16)
                .padding(.top, 10)
            HouseTray(state: state, play: play)
            Text(hint)
                .font(.system(size: 13))
                .foregroundStyle(Theme.muted)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 32)
                .padding(.horizontal, 20)
                .accessibilityAddTraits(.updatesFrequently)
            Button { play.startSharing() } label: {
                Label("Deel je huis", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(HouseShareButtonStyle())
            .disabled(play.hoist != nil)
            .padding(.horizontal, 16)
            .padding(.top, 4)
        }
        .padding(.bottom, 6)
    }

    // MARK: Parts

    private var header: some View {
        HStack(alignment: .center, spacing: 8) {
            VStack(alignment: .leading, spacing: 3) {
                Text("JOUW HUIS")
                    .font(Fonts.cta(22))
                    .foregroundStyle(Theme.onInk)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 2)
                    .background(Theme.ink)
                    .rotationEffect(.degrees(-2))
                    .accessibilityAddTraits(.isHeader)
                CourierLabel(text: "Plek 3 / \(ContentStore.totalSheets) · van Noor", size: 12)
            }
            Spacer(minLength: 4)
            Button {
                play.nightOverride = night ? (clockNight ? false : nil) : (clockNight ? nil : true)
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: night ? "sun.max" : "moon")
                        .font(.system(size: 16, weight: .semibold))
                    Text(night ? "Dag" : "Nacht")
                        .font(.system(size: 14, weight: .heavy))
                }
                .foregroundStyle(night ? Theme.onInk : Theme.ink)
                .padding(.horizontal, 14)
                .frame(minHeight: 44)
                .background(night ? Theme.ink : Color.clear, in: Capsule())
                .overlay(Capsule().strokeBorder(Theme.ink, lineWidth: 2))
                .contentShape(Capsule())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(night ? "Zet het huis op dag" : "Zet het huis op nacht")
            CircleIconButton(systemName: "xmark", label: "Sluiten", action: onClose)
        }
    }

    private var trayHeader: some View {
        HStack {
            Text("JOUW SPULLEN · \(state.unlocked.count) VAN \(HouseCatalog.items.count)")
                .foregroundStyle(Theme.label)
            Spacer(minLength: 8)
            Text("\(state.placedCount) IN HUIS")
                .foregroundStyle(Theme.muted)
        }
        .font(Fonts.label(12))
        .accessibilityElement(children: .combine)
    }

    private var hint: String {
        if let hoist = play.hoist {
            return "Even geduld… \(hoist.item.spoken) gaat omhoog."
        }
        if let id = play.nudgedID, let item = HouseCatalog.item(id) {
            return "Leer vel \(item.unlockSheet) (\(PlaceCatalog.name(item.unlockSheet))) om dit te krijgen."
        }
        if let selected = play.selected {
            return state.hasFreeSlot(for: selected.kind)
                ? "Tik op een gloeiende plek voor \(selected.spoken)."
                : "Geen plek meer voor \(selected.spoken). Een grachtenhuis is smal: haal eerst iets terug."
        }
        if !play.inside {
            return "Tik op de gevelsteen of op buurman Henk. Of ga naar binnen."
        }
        if state.unlocked.isEmpty {
            return "Nog heel kaal! Leer vel 1 en je krijgt je eerste spullen."
        }
        if state.score >= 100 {
            return "Je huis is af. Deel het met je buren!"
        }
        if night, !state.isLit(.zolder), state.unlocked.contains("lamp") {
            return "Het is nacht. De zolder is nog donker: zet de lamp daar neer."
        }
        return "Kies iets uit je spullen en zet het in een kamer."
    }
}

/// The black strip CTA, a little lower than `InkButtonStyle` so the house gets more room.
struct HouseShareButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Fonts.cta(18))
            .textCase(.uppercase)
            .foregroundStyle(Theme.onInk)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(Theme.ink, in: RoundedRectangle(cornerRadius: 3))
            .rotationEffect(.degrees(-0.8))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
