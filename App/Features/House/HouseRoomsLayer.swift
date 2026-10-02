import SwiftUI

/// The interactive part of the cutaway: placed objects (tap for the word), glowing empty spots for the
/// selected object, "de trap", and the hoist.
struct HouseRoomsLayer: View {
    let state: HouseState
    let play: HousePlay
    let store: HouseStore
    let night: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack(alignment: .topLeading) {
            HouseLampGlows(state: state, night: night)

            Button { play.tapTrap() } label: {
                HouseTag(text: "de trap", tilt: -4)
                    .frame(width: 58, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("De trap")
            .accessibilityHint("Waarom gaan grote spullen via de hijsbalk?")
            .houseAt(24, 372)

            ForEach(HouseCatalog.slots) { slot in
                spot(slot)
            }

            if let hoist = play.hoist, !reduceMotion {
                HouseHoistView(hoist: hoist)
                    .transition(.identity)
            }
        }
        .frame(width: 390, height: 440, alignment: .topLeading)
    }

    @ViewBuilder
    private func spot(_ slot: HouseSlot) -> some View {
        let r = slot.rect
        let hit = CGSize(width: max(44, r.width), height: max(44, r.height))
        if let item = state.item(in: slot) {
            Button { play.openInfo(item) } label: {
                HousePlacedArt(item: item, slot: slot)
                    .frame(width: hit.width, height: hit.height)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(item.spoken), \(slot.room.prep)")
            .accessibilityHint("Tik voor het woord.")
            .houseAt(r.midX - hit.width / 2, r.midY - hit.height / 2)
            .id("\(slot.id)-\(item.id)")
            .transition(arrival(slot))
        } else if let selected = play.selected, play.hoist == nil, selected.kind == slot.kind {
            Button { play.place(at: slot, store: store, state: state, reduceMotion: reduceMotion) } label: {
                HouseGlowSpot(size: r.size, animated: !reduceMotion)
                    .frame(width: hit.width, height: hit.height)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Zet \(selected.spoken) hier, \(slot.room.prep)")
            .houseAt(r.midX - hit.width / 2, r.midY - hit.height / 2)
            .transition(.opacity)
        }
    }

    /// Dropped objects fall in with a little bounce; hoisted ones land with a squash.
    private func arrival(_ slot: HouseSlot) -> AnyTransition {
        if reduceMotion { return .opacity }
        if play.landingSlotID == slot.id {
            return .asymmetric(
                insertion: .modifier(active: HouseSquash(x: 1.08, y: 0.86), identity: HouseSquash(x: 1, y: 1)),
                removal: .opacity
            )
        }
        return .asymmetric(insertion: .offset(y: -42).combined(with: .opacity), removal: .opacity)
    }
}

struct HouseSquash: ViewModifier {
    let x: CGFloat
    let y: CGFloat

    func body(content: Content) -> some View {
        content.scaleEffect(x: x, y: y, anchor: .bottom)
    }
}

/// An empty spot that fits the selected object: dashed orange, softly pulsing.
struct HouseGlowSpot: View {
    let size: CGSize
    var animated = true

    var body: some View {
        TimelineView(.animation(paused: !animated)) { timeline in
            let p = animated ? (1 - cos(2 * .pi * timeline.date.timeIntervalSinceReferenceDate / 1.2)) / 2 : 0.3
            RoundedRectangle(cornerRadius: 4)
                .fill(Theme.orange.opacity(0.18))
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(Theme.orange, style: StrokeStyle(lineWidth: 2, dash: [5, 3]))
                }
                .overlay {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .heavy))
                        .foregroundStyle(Theme.orangeText)
                }
                .background {
                    RoundedRectangle(cornerRadius: 4 + 7 * p)
                        .fill(Theme.orange.opacity(0.6 * (1 - p)))
                        .padding(-7 * p)
                }
                .frame(width: size.width, height: size.height)
        }
    }
}

/// At night de lamp and de kroonluchter throw a warm circle of light.
struct HouseLampGlows: View {
    let state: HouseState
    let night: Bool

    var body: some View {
        let lights: [(CGPoint, Path)] = night ? state.placements.compactMap { entry in
            guard entry.value == "lamp" || entry.value == "kroonluchter", let slot = HouseCatalog.slot(entry.key),
                  let room = HouseInteriorPainter.rooms.first(where: { $0.0 == slot.room })?.1 else { return nil }
            return (CGPoint(x: slot.rect.midX, y: slot.rect.minY + 10), room)
        } : []
        Canvas { ctx, _ in
            for (center, room) in lights {
                var c = ctx
                c.clip(to: room)
                c.fill(Path(CGRect(x: center.x - 70, y: center.y - 34, width: 140, height: 120)), with: .radialGradient(
                    Gradient(colors: [HouseInk.hex(0xF6D27A, 0.75), HouseInk.hex(0xF6D27A, 0)]),
                    center: center, startRadius: 0, endRadius: 64))
            }
        }
        .frame(width: 390, height: 440)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// The object on the rope: straps, a gentle sway, then it swings in through the window.
struct HouseHoistView: View {
    let hoist: HouseHoist

    var body: some View {
        let r = hoist.slot.rect
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(HouseInk.hex(0x2E2117))
                .frame(width: 2, height: max(0, hoist.top - HouseHoist.ropeTop))
                .opacity(hoist.swingingIn ? 0 : 1)
                .houseAt(HouseHoist.ropeX - 1, HouseHoist.ropeTop)

            TimelineView(.animation(paused: hoist.swingingIn)) { timeline in
                let angle = hoist.swingingIn ? 0 : 3 * sin(2 * .pi * timeline.date.timeIntervalSinceReferenceDate / 1.3)
                VStack(spacing: 0) {
                    HouseStraps()
                        .frame(width: r.width, height: HouseHoist.strap)
                        .opacity(hoist.swingingIn ? 0 : 1)
                    HouseItemArt(item: hoist.item, onFloor: true)
                        .frame(width: r.width, height: r.height)
                }
                .rotationEffect(.degrees(angle), anchor: .top)
            }
            .frame(width: r.width, height: r.height + HouseHoist.strap)
            .houseAt(hoist.left, hoist.top)
        }
        .frame(width: 390, height: 440, alignment: .topLeading)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

struct HouseStraps: View {
    var body: some View {
        Canvas { ctx, size in
            var path = Path()
            path.move(to: CGPoint(x: size.width / 2, y: 0))
            path.addLine(to: CGPoint(x: 6, y: size.height))
            path.move(to: CGPoint(x: size.width / 2, y: 0))
            path.addLine(to: CGPoint(x: size.width - 6, y: size.height))
            ctx.stroke(path, with: .color(HouseInk.hex(0x2E2117)), lineWidth: 1.5)
        }
    }
}
