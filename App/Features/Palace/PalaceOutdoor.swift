import SwiftUI

/// Shared pieces of the outdoor rooms (markt, park, tramhalte and later haven, plein, dijk …):
/// the canal-window sky with clouds, a row of gevelkit canal houses standing on a baseline,
/// and ground marks (cobbles, grass tufts, trees, bunting). Backdrops compose these.
nonisolated enum PalaceOutdoor {
    /// Houses laid side by side from `x`, scaled, standing on `baseline` (a street seen from across).
    static func row(_ specs: [PalaceHouse], scale: CGFloat, baseline: CGFloat, from x: CGFloat = -6) -> [PalaceWindowHouse] {
        var hx = x
        return specs.map { spec in
            let shape = PalaceGevel.gevel(spec)
            let left = hx
            hx += (shape.size.width - 2) * scale
            return PalaceWindowHouse(spec: spec, shape: shape, x: left, y: baseline - shape.size.height * scale)
        }
    }

    /// A varied canal street: the gevelkit's gables and colours, repeated as far as needed.
    static func street(count: Int, floors: [Int] = [3, 2, 3, 4], shops: Set<Int> = []) -> [PalaceHouse] {
        let gables: [PalaceGable] = [.trap, .klok, .hals, .lijst, .tuit, .trap, .hals, .klok, .lijst]
        let colors: [UInt32] = [0x7B3F2E, 0xD9CDB4, 0x5E6B73, 0x9A5238, 0x3F5A4A, 0xE3D6BC, 0x8C4A3A, 0xC9A15B, 0x2C2C2A]
        let doors: [UInt32] = [0x2F4B3A, 0x1F3A6B, 0x7A1E1E, 0x24533F, 0x7A1E1E, 0x1F3A6B, 0x2F4B3A, 0x1F3A6B, 0x7A1E1E]
        let awnings: [UInt32] = [0xC8261B, 0x2F4B3A, 0x1F3A6B, 0xC8261B]
        return (0..<count).map { i in
            let gable = gables[i % gables.count]
            let wide = gable == .lijst
            return PalaceHouse(type: gable, width: wide ? 92 : 62, floors: floors[i % floors.count], cols: wide ? 4 : 2,
                               doorLeft: i % 2 == 0, shop: shops.contains(i), flowers: i % 3 != 1,
                               color: colors[i % colors.count], door: doors[i % doors.count], awning: awnings[i % awnings.count])
        }
    }

    // MARK: Painting

    /// The open sky (the canal window's colours) down to `height`, with soft clouds.
    static func paintSky(_ ctx: inout GraphicsContext, height: CGFloat, clouds: [CGRect]) {
        ctx.fill(Path(CGRect(x: 0, y: 0, width: 370, height: height)), with: .linearGradient(
            Gradient(stops: [
                .init(color: PalaceInk.hex(0xBCCDD6), location: 0),
                .init(color: PalaceInk.hex(0xD9DED9), location: 0.62),
                .init(color: PalaceInk.hex(0xE8E2D2), location: 1),
            ]),
            startPoint: .zero, endPoint: CGPoint(x: 0, y: height)
        ))
        for cloud in clouds {
            ctx.fill(Path(roundedRect: cloud, cornerRadius: cloud.height / 2), with: .color(.white.opacity(0.7)))
            let puff = CGRect(x: cloud.minX + cloud.width * 0.22, y: cloud.minY - cloud.height * 0.45,
                              width: cloud.width * 0.42, height: cloud.height * 1.1)
            ctx.fill(Path(ellipseIn: puff), with: .color(.white.opacity(0.7)))
        }
    }

    /// Paints houses laid out by `row`.
    static func paintHouses(_ houses: [PalaceWindowHouse], scale: CGFloat, in ctx: inout GraphicsContext) {
        for house in houses {
            var c = ctx
            c.translateBy(x: house.x, y: house.y)
            c.scaleBy(x: scale, y: scale)
            PalaceGevel.draw(house.shape, house.spec, in: &c)
        }
    }

    // MARK: Ground marks

    /// Cobbles in rows that grow toward the viewer, between `top` and `bottom`.
    static func cobbles(top: CGFloat, bottom: CGFloat, base: UInt32, stone: UInt32) -> [PalaceMark] {
        var stones = Path()
        var y = top + 2
        var row = 0
        while y < bottom {
            let t = (y - top) / max(1, bottom - top)
            let h = 4 + t * 7, w = 9 + t * 13
            var x = row % 2 == 0 ? -w / 2 : 0
            while x < 370 {
                stones.addRoundedRect(in: CGRect(x: x + 1, y: y, width: w - 2.5, height: h - 1.5), cornerSize: CGSize(width: h * 0.35, height: h * 0.35))
                x += w
            }
            y += h + 1
            row += 1
        }
        return [.f("M0 \(top)H370V\(bottom)H0Z", base), PalaceMark(path: stones, paint: .fill(PalaceInk.hex(stone), evenOdd: false))]
    }

    /// A round-crowned tree standing at `x`, foot at `y`, crown radius `r`.
    static func tree(_ x: CGFloat, _ y: CGFloat, _ r: CGFloat, dark: Bool = false) -> [PalaceMark] {
        let crown: UInt32 = dark ? 0x4E7A3A : 0x5E8C45
        return [
            .oval(x - r * 0.7, y - 3, r * 1.4, 6, 0x1E1E1C, 0.12),
            .f("M\(x - 3) \(y)L\(x - 2) \(y - r * 1.2)H\(x + 2)L\(x + 3) \(y)Z", 0x6B4A2E),
            .dot(x, y - r * 1.55, r, crown),
            .dot(x - r * 0.55, y - r * 1.3, r * 0.7, crown),
            .dot(x + r * 0.55, y - r * 1.25, r * 0.72, crown),
            .dot(x - r * 0.25, y - r * 1.85, r * 0.45, 0x6E9C52, 0.8),
        ]
    }

    /// Little triangular flags on a sagging line from (x0, y0) to (x1, y0).
    static func bunting(_ x0: CGFloat, _ x1: CGFloat, _ y0: CGFloat, sag: CGFloat) -> [PalaceMark] {
        let colors: [UInt32] = [0xC8261B, 0xFAC775, 0x2F5BD3, 0xF2711C, 0x0F6E56]
        var marks: [PalaceMark] = [.s("M\(x0) \(y0)Q\((x0 + x1) / 2) \(y0 + sag * 2) \(x1) \(y0)", 0x2E2117, 1)]
        let n = Int((x1 - x0) / 15)
        for i in 1..<max(2, n) {
            let t = CGFloat(i) / CGFloat(n)
            let x = x0 + (x1 - x0) * t
            let y = y0 + sag * 4 * t * (1 - t)
            marks.append(.f("M\(x - 4.5) \(y)H\(x + 4.5)L\(x) \(y + 9)Z", colors[i % colors.count]))
        }
        return marks
    }
}

/// An outdoor backdrop: the sky, a row of canal houses, then the room's own marks on top.
struct PalaceOutdoorBackdrop: View {
    let houses: [PalaceWindowHouse]
    let scale: CGFloat
    let skyHeight: CGFloat
    var clouds: [CGRect] = []
    let marks: [PalaceMark]

    var body: some View {
        Canvas { ctx, _ in
            PalaceOutdoor.paintSky(&ctx, height: skyHeight, clouds: clouds)
            PalaceOutdoor.paintHouses(houses, scale: scale, in: &ctx)
            PalaceMark.draw(marks, in: &ctx)
        }
        .frame(width: 370, height: 408)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
