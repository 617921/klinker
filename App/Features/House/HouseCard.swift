import SwiftUI

/// The "Jouw huis" row in the Vandaag panel: Noor's klokgevel, the gezelligheidsmeter and how many of
/// your things are in the house. Tapping it opens `HouseView` full screen.
struct HouseCard: View {
    @Environment(ProgressStore.self) private var progress

    @State private var isOpen = false
    @State private var clockNight = HouseClock.isNight()
    private let store: HouseStore

    init(store: HouseStore = .shared) {
        self.store = store
    }

    var body: some View {
        let state = HouseState(store: store, completedSheets: progress.completedSheets)
        let newCount = state.newItems.count
        Button { isOpen = true } label: {
            VandaagRow {
                HouseFacadeMini(night: clockNight, lights: HouseLights(state: state))
                    .frame(width: 48, height: 70)
            } text: {
                HStack(spacing: 8) {
                    CourierLabel(text: "Jouw huis", size: 12)
                    Spacer(minLength: 0)
                    if newCount > 0 {
                        Text("\(newCount) nieuw")
                            .font(.system(size: 13, weight: .heavy))
                            .foregroundStyle(Theme.ink)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Theme.orange, in: Capsule())
                            .rotationEffect(.degrees(3))
                    }
                }
                Text("Bij Noor thuis")
                    .font(.system(size: 19, weight: .heavy))
                    .tracking(-0.3)
                    .foregroundStyle(Theme.ink)
                HouseMeterBar(fraction: Double(state.score) / 100, height: 6)
                    .padding(.vertical, 3)
                Text(subline(state))
                    .font(Fonts.body(13))
                    .foregroundStyle(Theme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText(state, newCount: newCount))
        .accessibilityHint("Open je huis.")
        .accessibilityAddTraits(.isButton)
        .houseCover(isPresented: $isOpen) {
            HouseView(store: store)
                .environment(progress)
        }
        .onAppear { clockNight = HouseClock.isNight() }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(60))
                clockNight = HouseClock.isNight()
            }
        }
    }

    private func subline(_ state: HouseState) -> String {
        let unlocked = state.unlocked.count
        if unlocked == 0 { return "Leer vel 1 en je krijgt je eerste spullen." }
        return "\(state.placedCount) van \(unlocked) spullen geplaatst"
    }

    private func accessibilityText(_ state: HouseState, newCount: Int) -> String {
        var text = "Jouw huis: bij Noor thuis. \(subline(state)). \(state.score) procent gezellig."
        if newCount > 0 { text += " \(newCount) nieuw." }
        return text
    }
}

/// Noor's klokgevel on a little patch of sky (night by the clock: lit windows in furnished rooms).
struct HouseFacadeMini: View {
    let night: Bool
    let lights: HouseLights

    var body: some View {
        Canvas { ctx, size in
            let box = CGRect(origin: .zero, size: size)
            ctx.fill(Path(box), with: .linearGradient(
                Gradient(colors: night ? [HouseInk.hex(0x141C33), HouseInk.hex(0x4A4A66)] : [HouseInk.hex(0xBCCDD6), HouseInk.hex(0xE8E2D2)]),
                startPoint: .zero, endPoint: CGPoint(x: 0, y: size.height)))
            if night {
                ctx.fill(Path(ellipseIn: CGRect(x: size.width - 17, y: 7, width: 10, height: 10)), with: .color(HouseInk.hex(0xF4F1EA)))
            }
            let street: CGFloat = 7
            let k = min((size.width - 8) / HouseStreet.noorSize.width, (size.height - street - 6) / HouseStreet.noorSize.height)
            var house = ctx
            house.translateBy(x: (size.width - HouseStreet.noorSize.width * k) / 2, y: size.height - street - HouseStreet.noorSize.height * k)
            house.scaleBy(x: k, y: k)
            HouseStreet.drawNoor(lights, night: night, in: &house)
            ctx.fill(Path(CGRect(x: 0, y: size.height - street, width: size.width, height: street)), with: .color(HouseInk.hex(0xA19E95)))
        }
        .clipShape(RoundedRectangle(cornerRadius: 3))
        .accessibilityHidden(true)
    }
}

extension View {
    /// Full screen on iPhone; a sheet where full-screen covers don't exist.
    @ViewBuilder
    func houseCover<Cover: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Cover) -> some View {
        #if os(iOS)
        fullScreenCover(isPresented: isPresented, content: content)
        #else
        sheet(isPresented: isPresented, content: content)
        #endif
    }
}
