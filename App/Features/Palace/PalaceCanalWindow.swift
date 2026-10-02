import SwiftUI

/// One canal house as seen through a window: its spec, its paths and where it stands.
nonisolated struct PalaceWindowHouse: Sendable {
    let spec: PalaceHouse
    let shape: PalaceGevelShape
    let x: CGFloat
    let y: CGFloat
}

/// The view outside a tall window: sky, canal houses (gevelkit, scaled 0.42), quay and water.
/// Drawn in the window's own 84 × 180 coordinates, exactly like the prototype's window div.
nonisolated enum PalaceCanal {
    static let scale: CGFloat = 0.42
    static let size = CGSize(width: 84, height: 180)

    /// Lays houses side by side from x = -8, standing on the quay at y = 136.
    static func row(_ specs: [PalaceHouse]) -> [PalaceWindowHouse] {
        var hx: CGFloat = -8
        return specs.map { spec in
            let shape = PalaceGevel.gevel(spec)
            let left = hx
            hx += (shape.size.width - 2) * scale
            return PalaceWindowHouse(spec: spec, shape: shape, x: left, y: 136 - shape.size.height * scale)
        }
    }

    /// The prototype's four houses outside the Gemeentehuis.
    static let gemeentehuis: [PalaceHouse] = [
        PalaceHouse(type: .trap, width: 62, floors: 3, cols: 2, doorLeft: true, shop: false, flowers: true,
                    color: 0x7B3F2E, door: 0x2F4B3A, awning: 0xC8261B),
        PalaceHouse(type: .klok, width: 62, floors: 3, cols: 2, doorLeft: false, shop: true, flowers: false,
                    color: 0xD9CDB4, door: 0x1F3A6B, awning: 0xC8261B),
        PalaceHouse(type: .hals, width: 62, floors: 3, cols: 2, doorLeft: true, shop: false, flowers: true,
                    color: 0x5E6B73, door: 0x7A1E1E, awning: 0x2F4B3A),
        PalaceHouse(type: .lijst, width: 96, floors: 3, cols: 4, doorLeft: false, shop: false, flowers: true,
                    color: 0x9A5238, door: 0x24533F, awning: 0x1F3A6B),
    ]
}

/// The canal seen through a window (84 × 180 points), with a drifting boat and shimmering water.
struct PalaceCanalWindow: View, Equatable {
    let houses: [PalaceWindowHouse]

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    static func == (a: Self, b: Self) -> Bool {
        a.houses.map(\.spec) == b.houses.map(\.spec)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Canvas { ctx, _ in
                PalaceCanalWindow.paint(houses, in: &ctx)
            }
            .frame(width: PalaceCanal.size.width, height: PalaceCanal.size.height)
            PalaceShimmer(delay: 3).frame(width: 30, height: 1.5).palaceAt(6, 152)
            PalaceShimmer(delay: 4).frame(width: 26, height: 1.5).palaceAt(48, 170)
            PalaceBoat(still: reduceMotion).palaceAt(0, 152)
        }
        .frame(width: PalaceCanal.size.width, height: PalaceCanal.size.height, alignment: .topLeading)
        .clipped()
        .accessibilityHidden(true)
    }

    nonisolated static func paint(_ houses: [PalaceWindowHouse], in ctx: inout GraphicsContext) {
        let full = CGRect(origin: .zero, size: PalaceCanal.size)
        ctx.fill(Path(full), with: .linearGradient(
            Gradient(stops: [
                .init(color: PalaceInk.hex(0xBCCDD6), location: 0),
                .init(color: PalaceInk.hex(0xD9DED9), location: 0.5),
                .init(color: PalaceInk.hex(0xE8E2D2), location: 0.78),
            ]),
            startPoint: .zero, endPoint: CGPoint(x: 0, y: full.height)
        ))
        ctx.fill(Path(roundedRect: CGRect(x: 48, y: 14, width: 28, height: 9), cornerRadius: 5), with: .color(.white.opacity(0.75)))
        ctx.fill(Path(roundedRect: CGRect(x: 6, y: 24, width: 18, height: 7), cornerRadius: 4), with: .color(.white.opacity(0.6)))
        for house in houses {
            var c = ctx
            c.translateBy(x: house.x, y: house.y)
            c.scaleBy(x: PalaceCanal.scale, y: PalaceCanal.scale)
            PalaceGevel.draw(house.shape, house.spec, in: &c)
        }
        ctx.fill(Path(CGRect(x: 0, y: 136, width: 84, height: 6)), with: .color(PalaceInk.hex(0xA19E95)))
        for x in [9.0, 36, 66] {
            ctx.fill(Path(roundedRect: CGRect(x: x, y: 133, width: 3, height: 6), cornerRadius: 1.2), with: .color(PalaceInk.hex(0x5A2A20)))
        }
        ctx.fill(Path(CGRect(x: 0, y: 142, width: 84, height: 3)), with: .color(PalaceInk.hex(0x6E6B64)))
        ctx.fill(Path(CGRect(x: 0, y: 145, width: 84, height: 35)), with: .linearGradient(
            Gradient(colors: [PalaceInk.hex(0x8FB6CF), PalaceInk.hex(0xA9CBE0)]),
            startPoint: CGPoint(x: 0, y: 145), endPoint: CGPoint(x: 0, y: 180)
        ))
    }
}

/// A white glint on the water that slowly brightens and fades.
private struct PalaceShimmer: View {
    let delay: Double
    @State private var bright = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Rectangle()
            .fill(Color.white)
            .opacity(bright ? 0.75 : 0.35)
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.easeInOut(duration: delay / 2).repeatForever(autoreverses: true)) { bright = true }
            }
    }
}

/// The little rowing boat with two people that drifts past the window.
private struct PalaceBoat: View {
    let still: Bool
    @State private var across = false

    static let marks: [PalaceMark] = [
        .dot(12, 4, 2.6, 0xE8C4A0),
        .f("M9 10V8a3 3 0 0 1 6 0v2z", 0xF2711C),
        .dot(20, 4, 2.6, 0x8C5A3C),
        .f("M17 10V8a3 3 0 0 1 6 0v2z", 0x2F5BD3),
        .f("M2 9H32L28 15H6Z", 0x6B4A2E),
        .s("M4 11H30", 0xF4F1EA, 1.2),
    ]

    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 34, height: 16)
            .offset(x: still ? 30 : (across ? 96 : -46))
            .onAppear {
                guard !still else { return }
                withAnimation(.linear(duration: 16).repeatForever(autoreverses: false)) { across = true }
            }
    }
}
