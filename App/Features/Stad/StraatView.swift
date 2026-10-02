import SwiftUI

/// The canal street: a horizontally scrolling scene (gevelkit houses on a quay, water with
/// reflections, boat or skaters) with season, day/night and "Nieuwe straat" controls.
struct StraatView: View {
    @Binding var night: Bool
    /// Whether the card is on screen; the animation clock only runs while it is.
    var active = true

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var seed = 682
    @State private var houses = StraatLayout.initial
    @State private var season = GevelSeason.of(.now)
    @State private var selected: Int?
    @State private var appeared = false

    static let sceneHeight: CGFloat = 300

    private var scale: CGFloat { Self.sceneHeight / StraatMetrics.viewHeight }

    private var selectedHouse: StraatHouse? {
        guard let selected else { return nil }
        return houses.first { $0.id == selected }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                scene
            }
            .frame(height: Self.sceneHeight)
            .background(Ink.hex(0xBCCDD6))
            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Jouw straat. Tik op een huis.")

            StraatControls(season: $season, night: $night, newStreet: newStreet)

            StraatInfoCard(house: selectedHouse)
                .animation(.easeOut(duration: 0.25), value: selected)
        }
        .onAppear { appeared = true }
        .onDisappear { appeared = false }
    }

    private var scene: some View {
        let s = scale
        let running = active && appeared
        return ZStack(alignment: .topLeading) {
            StraatSkyLayer(night: night, winter: season == .winter, scale: s)
                .equatable()
            if night {
                StraatStarsLayer(scale: s, active: running, reduceMotion: reduceMotion)
            }
            houseRow(scale: s)
            StraatStreetLayer(seed: seed, houses: houses, night: night, season: season, scale: s)
                .equatable()
                .offset(y: (StraatMetrics.streetLayerTop - StraatMetrics.viewTop) * s)
            StraatMotionLayer(scale: s, season: season, active: running, reduceMotion: reduceMotion)
            if let house = selectedHouse {
                tag(for: house, scale: s)
            }
        }
        .frame(width: StraatMetrics.width * s, height: StraatMetrics.viewHeight * s, alignment: .topLeading)
        .clipped()
    }

    private func houseRow(scale s: CGFloat) -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(houses) { house in
                let size = house.geometry.size
                let lift: CGFloat = selected == house.id ? 6 : 0
                Button {
                    pick(house)
                } label: {
                    CanalHouseView(spec: house.spec, night: night, season: season)
                        .frame(width: size.width * s, height: size.height * s)
                        .contentShape(Rectangle())
                }
                .buttonStyle(StraatHouseButtonStyle())
                .offset(
                    x: house.x * s,
                    y: (StraatMetrics.rowBottom - size.height - StraatMetrics.viewTop - lift) * s
                )
                .accessibilityLabel("Huis met een \(house.spec.type.word)")
                .accessibilityAddTraits(selected == house.id ? .isSelected : [])
            }
        }
        .animation(reduceMotion ? nil : .easeOut(duration: 0.25), value: selected)
    }

    private func tag(for house: StraatHouse, scale s: CGFloat) -> some View {
        let g = house.geometry
        let top = StraatMetrics.rowBottom - g.size.height - 6 + g.topY - StraatMetrics.viewTop
        return Text(house.spec.type.name)
            .font(Fonts.label(12))
            .foregroundStyle(Theme.onInk)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Theme.ink)
            .fixedSize()
            .rotationEffect(.degrees(-3))
            .position(x: (house.x + g.size.width / 2) * s, y: top * s - 14)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }

    private func pick(_ house: StraatHouse) {
        selected = house.id
        Speech.shared.say("de \(house.spec.type.word)")
        Haptics.tap()
    }

    private func newStreet() {
        Haptics.thump()
        let next = Int.random(in: 0..<100_000)
        seed = next
        houses = StraatLayout.houses(seed: next)
        selected = nil
    }
}

private struct StraatHouseButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .brightness(configuration.isPressed ? -0.06 : 0)
    }
}

/// Season pills, day/night switch and the "Nieuwe straat" button.
private struct StraatControls: View {
    @Binding var season: GevelSeason
    @Binding var night: Bool
    let newStreet: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                ForEach(GevelSeason.allCases) { option in
                    Button(option.label) {
                        withAnimation(.easeInOut(duration: 0.3)) { season = option }
                        Haptics.tap()
                    }
                    .buttonStyle(StadPillStyle(selected: season == option))
                    .accessibilityAddTraits(season == option ? .isSelected : [])
                }
            }
            HStack(spacing: 8) {
                StadDayNightToggle(night: $night)
                    .fixedSize()
                    .layoutPriority(1)
                Spacer(minLength: 0)
                Button(action: newStreet) {
                    Label("Nieuwe straat", systemImage: "arrow.clockwise")
                }
                .buttonStyle(StadInkPillStyle())
            }
        }
    }
}

/// The note under the street: what you tapped, or how it works.
private struct StraatInfoCard: View {
    let house: StraatHouse?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let house {
                details(house.spec)
            } else {
                CourierLabel(text: "De 682-gevelkit", size: 12)
                Text("Tik op een huis.")
                    .font(.system(size: 16, weight: .heavy))
                Text("Vijf echte Amsterdamse geveltypes, steeds anders gecombineerd. Elk huis heeft een gevelsteen met een woord.")
                    .font(Fonts.body(14))
                    .foregroundStyle(Theme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.note, in: RoundedRectangle(cornerRadius: 3))
        .rotationEffect(.degrees(-0.6))
    }

    @ViewBuilder
    private func details(_ spec: HouseSpec) -> some View {
        let type = spec.type
        let stone = spec.stoneWord
        HStack(alignment: .center, spacing: 10) {
            StripView(text: type.word, style: 1, size: 26, tape: .de)
                .rotationEffect(.degrees(-1.5))
                .accessibilityLabel("de \(type.word)")
            Spacer(minLength: 0)
            CircleIconButton(systemName: "speaker.wave.2.fill", label: "Luister", dark: true) {
                Speech.shared.say("de \(type.word). \(stone.nl)")
            }
        }
        .padding(.top, 6)
        Text("\(type.name): \(type.fact)")
            .font(Fonts.body(15))
            .foregroundStyle(Theme.ink)
            .fixedSize(horizontal: false, vertical: true)
        Text(type.factEnglish)
            .font(Fonts.body(13))
            .foregroundStyle(Theme.muted)
            .fixedSize(horizontal: false, vertical: true)
        Line()
            .stroke(Ink.hex(0xD3D1C7), style: StrokeStyle(lineWidth: 2, dash: [2, 3]))
            .frame(height: 2)
        Button {
            Speech.shared.say(stone.nl)
        } label: {
            HStack(spacing: 8) {
                CourierLabel(text: "Gevelsteen", size: 12)
                Text(stone.nl)
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundStyle(Theme.ink)
                Text("· \(stone.en)")
                    .font(Fonts.body(14))
                    .foregroundStyle(Theme.muted)
            }
            .frame(minHeight: 32)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Gevelsteen: \(stone.nl), \(stone.en). Luister.")
    }
}
