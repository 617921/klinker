import SwiftUI

/// Scene coordinates of the street (prototype units, 1280 wide). The phone card shows the window
/// `viewTop...viewBottom`, scaled to the card height.
nonisolated enum StraatMetrics {
    static let width: CGFloat = 1280
    static let viewTop: CGFloat = 96
    static let viewBottom: CGFloat = 610
    static var viewHeight: CGFloat { viewBottom - viewTop }
    static let rowBottom: CGFloat = 452
    static let quayTop: CGFloat = 500
    static let waterTop: CGFloat = 510
    static let streetLayerTop: CGFloat = 340

    static let lamps: [CGFloat] = [150, 410, 690, 960, 1210]
    static let trees: [CGFloat] = [40, 300, 560, 820, 1080]
    static let bikes: [(x: CGFloat, color: UInt32)] = [(200, 0x2F5BD3), (640, 0xC8261B), (1000, 0x1E1E1C)]
    static let posts: [CGFloat] = Array(stride(from: CGFloat(20), to: 1280, by: 64))

    /// Water shimmer lines: x, y below the water line, width, period.
    static let shimmer: [(x: CGFloat, y: CGFloat, w: CGFloat, period: Double)] = [
        (60, 22, 220, 3), (420, 62, 160, 4), (760, 40, 260, 3.5), (1080, 80, 140, 5),
    ]

    /// Stars and snowflakes from `rng(99)`, in the prototype's draw order.
    static let sky: (stars: [(x: CGFloat, y: CGFloat, period: Double)], flakes: [(x: CGFloat, period: Double, delay: Double)]) = {
        var rnd = GevelRandom(seed: 99)
        var stars: [(x: CGFloat, y: CGFloat, period: Double)] = []
        for _ in 0..<40 {
            let x = Gevelkit.jsRound(rnd.next() * 1280)
            let y = Gevelkit.jsRound(rnd.next() * 200)
            // The card crops the top of the sky, so stars sit in the visible band.
            stars.append((x, viewTop + y * 0.6, 2 + rnd.next() * 3))
        }
        var flakes: [(x: CGFloat, period: Double, delay: Double)] = []
        for _ in 0..<46 {
            let x = Gevelkit.jsRound(rnd.next() * 1280)
            flakes.append((x, 6 + rnd.next() * 6, rnd.next() * 10))
        }
        return (stars, flakes)
    }()
}

/// Fixed drawings from the prototype's inline SVGs.
nonisolated enum StraatArt {
    static let lampPost = StadSVG.path("M11 30h2v66h-2z M8 92h8v4H8z")
    static let lampGlass = StadSVG.path("M6 10h12l-2 18H8z")
    static let lampCap = StadSVG.path("M5 8h14l-3-5H8z M8 28h8v3H8z")
    static let lampFinial = StadSVG.path("M12 0v3")

    static let treeBranches = StadSVG.path("M56 150V80l-4-14M64 150V78l6-16M60 96L40 70M60 90l22-26M60 110L34 92")
    /// (cx, cy, r, colour index)
    static let treeCrowns: [(CGFloat, CGFloat, CGFloat, Int)] = [(60, 56, 34, 0), (34, 72, 26, 1), (88, 70, 27, 1), (62, 84, 24, 0), (74, 42, 18, 2)]

    static let bikeWheels = StadSVG.path("M2 26a11 11 0 1 0 22 0a11 11 0 1 0-22 0Z M40 26a11 11 0 1 0 22 0a11 11 0 1 0-22 0Z")
    static let bikeFrame = StadSVG.path("M13 26L29 26L24 9Z M24 9L44 9L29 26 M44 9L51 26 M18 7H28 M44 9L45 2H51")

    static let riderWheels = StadSVG.path("M4 50a10 10 0 1 0 20 0a10 10 0 1 0-20 0Z M44 50a10 10 0 1 0 20 0a10 10 0 1 0-20 0Z")
    static let riderFrame = StadSVG.path("M14 50h18l-5-16zM27 34h20l-15 16M47 34l7 16M44 34l2-6h6")
    static let riderBody = StadSVG.path("M30 32l6-16M35 18l12 10M33 32l6 12")
    static let riderHead = StadSVG.path("M31 10a6 6 0 1 0 12 0a6 6 0 1 0-12 0Z")
    static let riderHat = StadSVG.path("M31 8a6 6 0 0 1 12 0z")

    static let boatMast = StadSVG.path("M150 22V2")
    static let boatHull = StadSVG.path("M14 36h172l-14 22H30z")
    static let boatStripe = StadSVG.path("M18 40h166")
    static let boatCooler = StadSVG.path("M90 26h18v8H90z")
    /// (head cx, head cy, skin, body path, body colour)
    static let boatPeople: [(CGFloat, CGFloat, UInt32, Path, UInt32)] = [
        (52, 22, 0xE8C4A0, StadSVG.path("M44 40v-10a8 8 0 0 1 16 0v10z"), 0xF2711C),
        (84, 20, 0x8C5A3C, StadSVG.path("M76 40v-10a8 8 0 0 1 16 0v10z"), 0x2F5BD3),
        (116, 22, 0xE8C4A0, StadSVG.path("M108 40v-10a8 8 0 0 1 16 0v10z"), 0x5DCAA5),
    ]

    static let skaterHat = StadSVG.path("M22 6h16l-2-6h-12z")
    static let skaterLimbs = StadSVG.path("M30 17l-10 22M30 17l12 18M24 30l-8 26M28 30l14 24")
    static let skaterBlades = StadSVG.path("M8 58h16M34 56h16")

    static let cobbleLines: Path = {
        var p = Path()
        let top = StraatMetrics.rowBottom
        for y in [top + 16, top + 32] {
            p.move(to: CGPoint(x: 0, y: y))
            p.addLine(to: CGPoint(x: 1280, y: y))
        }
        return p
    }()

    static let cobbleJoints: Path = {
        var p = Path()
        let top = StraatMetrics.rowBottom
        for row in 0..<3 {
            let start: CGFloat = row == 1 ? 60 : 30
            for x in stride(from: start, through: 1260, by: 60) {
                p.move(to: CGPoint(x: x, y: top + CGFloat(row) * 16))
                p.addLine(to: CGPoint(x: x, y: top + CGFloat(row + 1) * 16))
            }
        }
        return p
    }()
}

private extension GraphicsContext {
    func circle(_ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat) -> Path {
        Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: 2 * r, height: 2 * r))
    }
}

/// One house in the row, with its scene x position.
struct StraatHouse: Identifiable {
    let id: Int
    let spec: HouseSpec
    let geometry: GevelGeometry
    let x: CGFloat
}

enum StraatLayout {
    static func houses(seed: Int) -> [StraatHouse] {
        var x: CGFloat = 0
        var out: [StraatHouse] = []
        for (i, spec) in Gevelkit.street(seed: seed).enumerated() {
            out.append(StraatHouse(id: i, spec: spec, geometry: GevelCache.geometry(for: spec), x: x))
            x += spec.width + 4
        }
        return out
    }

    static let initial = houses(seed: 682)
}

// MARK: - Static layers (drawn once per seed / day-night / season)

/// Sky gradient, sun or moon, clouds.
struct StraatSkyLayer: View, Equatable {
    let night: Bool
    let winter: Bool
    let scale: CGFloat

    var body: some View {
        let top = StraatMetrics.viewTop
        let bottom = StraatMetrics.rowBottom + 8
        Canvas { ctx, _ in
            ctx.scaleBy(x: scale, y: scale)
            ctx.translateBy(x: 0, y: -top)
            let stops: [Gradient.Stop] = night
                ? [.init(color: StadInk.hex(0x141C33), location: 0), .init(color: StadInk.hex(0x2E3556), location: 0.6), .init(color: StadInk.hex(0x4A4A66), location: 1)]
                : winter
                ? [.init(color: StadInk.hex(0xC9D3DA), location: 0), .init(color: StadInk.hex(0xE3E6E6), location: 0.6), .init(color: StadInk.hex(0xEDEBE6), location: 1)]
                : [.init(color: StadInk.hex(0xBCCDD6), location: 0), .init(color: StadInk.hex(0xD9DED9), location: 0.45), .init(color: StadInk.hex(0xE8E2D2), location: 1)]
            ctx.fill(
                Path(CGRect(x: 0, y: top, width: StraatMetrics.width, height: bottom - top)),
                with: .linearGradient(Gradient(stops: stops), startPoint: .zero, endPoint: CGPoint(x: 0, y: 720))
            )
            let orb = Path(ellipseIn: CGRect(x: 1060, y: 108, width: 64, height: 64))
            if night {
                ctx.drawLayer { moon in
                    moon.clip(to: orb)
                    moon.fill(orb, with: .color(StadInk.hex(0xD9D4C4)))
                    moon.fill(Path(ellipseIn: CGRect(x: 1046, y: 102, width: 64, height: 64)), with: .color(StadInk.hex(0xF4F1EA)))
                }
            } else {
                ctx.fill(orb, with: .color(StadInk.hex(winter ? 0xF6F3EA : 0xF6D27A)))
                let clouds: [(CGRect, Double)] = [
                    (CGRect(x: 520, y: 120, width: 150, height: 26), 0.75),
                    (CGRect(x: 556, y: 104, width: 70, height: 34), 0.75),
                    (CGRect(x: 980, y: 150, width: 120, height: 22), 0.6),
                ]
                for (rect, opacity) in clouds {
                    ctx.fill(Path(roundedRect: rect, cornerRadius: rect.height / 2), with: .color(.white.opacity(opacity)))
                }
            }
        }
        .frame(width: StraatMetrics.width * scale, height: (bottom - top) * scale)
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }
}

/// Cobbles, lamps, trees, parked bikes, quay, water and the mirrored houses.
struct StraatStreetLayer: View, Equatable {
    let seed: Int
    let houses: [StraatHouse]
    let night: Bool
    let season: GevelSeason
    let scale: CGFloat

    static func == (a: Self, b: Self) -> Bool {
        a.seed == b.seed && a.night == b.night && a.season == b.season && a.scale == b.scale && a.houses.count == b.houses.count
    }

    var body: some View {
        let top = StraatMetrics.streetLayerTop
        let bottom = StraatMetrics.viewBottom
        let palettes = houses.map { GevelPalette.street($0.spec, night: night, season: season) }
        Canvas { ctx, _ in
            ctx.scaleBy(x: scale, y: scale)
            ctx.translateBy(x: 0, y: -top)
            Self.drawStreet(&ctx, night: night, season: season)
            Self.drawWater(&ctx, houses: houses, palettes: palettes, night: night, winter: season == .winter, bottom: bottom)
        }
        .frame(width: StraatMetrics.width * scale, height: (bottom - top) * scale)
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }

    private static func drawStreet(_ ctx: inout GraphicsContext, night: Bool, season: GevelSeason) {
        let row = StraatMetrics.rowBottom
        let ink = StadInk.hex(0x1E1E1C)
        ctx.fill(Path(CGRect(x: 0, y: row, width: 1280, height: 48)), with: .color(StadInk.hex(0xA19E95)))
        ctx.stroke(StraatArt.cobbleLines, with: .color(StadInk.hex(0x8E8B83)), lineWidth: 1.5)
        ctx.stroke(StraatArt.cobbleJoints, with: .color(StadInk.hex(0x8E8B83)), lineWidth: 1.2)

        let lampGreen = StadInk.hex(0x2B3A33)
        for x in StraatMetrics.lamps {
            if night {
                let glow = Gradient(colors: [StadInk.hex(0xF6D27A, 0.55), StadInk.hex(0xF6D27A, 0)])
                let center = CGPoint(x: x - 38 + 50, y: 376 + 50)
                ctx.fill(
                    Path(ellipseIn: CGRect(x: center.x - 50, y: center.y - 50, width: 100, height: 100)),
                    with: .radialGradient(glow, center: center, startRadius: 0, endRadius: 49.5)
                )
            }
            var lamp = ctx
            lamp.translateBy(x: x, y: 404)
            lamp.fill(StraatArt.lampPost, with: .color(lampGreen))
            lamp.fill(StraatArt.lampGlass, with: .color(StadInk.hex(night ? 0xF6D27A : 0xDDE6E8)))
            lamp.stroke(StraatArt.lampGlass, with: .color(lampGreen), lineWidth: 1.5)
            lamp.fill(StraatArt.lampCap, with: .color(lampGreen))
            lamp.stroke(StraatArt.lampFinial, with: .color(lampGreen), lineWidth: 2)
        }

        for x in StraatMetrics.trees {
            var tree = ctx
            tree.translateBy(x: x, y: 350)
            tree.stroke(StraatArt.treeBranches, with: .color(StadInk.hex(0x4A3524)), style: StrokeStyle(lineWidth: 6, lineCap: .round))
            if let crowns = season.crowns {
                for (cx, cy, r, i) in StraatArt.treeCrowns {
                    tree.fill(tree.circle(cx, cy, r), with: .color(StadInk.hex(crowns[i])))
                }
            }
        }

        for bike in StraatMetrics.bikes {
            var b = ctx
            b.translateBy(x: bike.x, y: 456)
            b.stroke(StraatArt.bikeWheels, with: .color(ink), lineWidth: 2.5)
            b.stroke(StraatArt.bikeFrame, with: .color(StadInk.hex(bike.color)), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
        }

        ctx.fill(Path(CGRect(x: 0, y: StraatMetrics.quayTop, width: 1280, height: 10)), with: .color(StadInk.hex(0x6E6B64)))
    }

    private static func drawWater(_ ctx: inout GraphicsContext, houses: [StraatHouse], palettes: [GevelPalette], night: Bool, winter: Bool, bottom: CGFloat) {
        let top = StraatMetrics.waterTop
        let water = Path(CGRect(x: 0, y: top, width: 1280, height: bottom - top))
        let colors: [UInt32] = winter ? [0xDCE6EA, 0xEAF0F2] : night ? [0x1D2A44, 0x2B3A58] : [0x8FB6CF, 0xA9CBE0]
        ctx.fill(water, with: .linearGradient(
            Gradient(colors: colors.map { StadInk.hex($0) }),
            startPoint: CGPoint(x: 0, y: top), endPoint: CGPoint(x: 0, y: 720)
        ))
        var reflection = ctx
        reflection.opacity = winter ? 0.12 : night ? 0.4 : 0.22
        reflection.drawLayer { layer in
            layer.clip(to: water)
            for (house, palette) in zip(houses, palettes) {
                var h = layer
                h.translateBy(x: house.x, y: top + house.geometry.size.height)
                h.scaleBy(x: 1, y: -1)
                GevelPainter.drawReflection(house.geometry, palette: palette, in: &h)
            }
        }
    }
}

/// The Amsterdammertjes along the quay edge (drawn above the passing cyclist).
struct StraatBollards: View, Equatable {
    let scale: CGFloat

    var body: some View {
        Canvas { ctx, _ in
            ctx.scaleBy(x: scale, y: scale)
            for x in StraatMetrics.posts {
                let post = Path(roundedRect: CGRect(x: x, y: 0, width: 7, height: 16), cornerRadii: RectangleCornerRadii(topLeading: 3, topTrailing: 3))
                ctx.fill(post, with: .color(StadInk.hex(0x5A2A20)))
            }
        }
        .frame(width: StraatMetrics.width * scale, height: 16 * scale)
        .offset(y: (488 - StraatMetrics.viewTop) * scale)
    }
}

// MARK: - Sprites (fixed drawings, moved by the motion layer)

struct StraatCyclistSprite: View, Equatable {
    let scale: CGFloat

    var body: some View {
        Canvas { ctx, _ in
            ctx.scaleBy(x: scale, y: scale)
            // The prototype mirrors this svg so the rider faces left.
            ctx.translateBy(x: 70, y: 0)
            ctx.scaleBy(x: -1, y: 1)
            let round = StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
            ctx.stroke(StraatArt.riderWheels, with: .color(StadInk.hex(0x1E1E1C)), lineWidth: 2.5)
            ctx.stroke(StraatArt.riderFrame, with: .color(StadInk.hex(0xC8261B)), style: round)
            ctx.stroke(StraatArt.riderBody, with: .color(StadInk.hex(0x2F5BD3)), style: StrokeStyle(lineWidth: 5, lineCap: .round))
            ctx.fill(StraatArt.riderHead, with: .color(StadInk.hex(0xE8C4A0)))
            ctx.fill(StraatArt.riderHat, with: .color(StadInk.hex(0xF2711C)))
        }
        .frame(width: 70 * scale, height: 62 * scale)
    }
}

struct StraatBoatSprite: View, Equatable {
    let scale: CGFloat

    var body: some View {
        Canvas { ctx, _ in
            ctx.scaleBy(x: scale, y: scale)
            ctx.stroke(StraatArt.boatMast, with: .color(StadInk.hex(0x4A3524)), lineWidth: 2)
            ctx.fill(Path(CGRect(x: 151, y: 3, width: 20, height: 5)), with: .color(StadInk.hex(0xAE1C28)))
            ctx.fill(Path(CGRect(x: 151, y: 8, width: 20, height: 5)), with: .color(.white))
            ctx.fill(Path(CGRect(x: 151, y: 13, width: 20, height: 5)), with: .color(StadInk.hex(0x21468B)))
            for (hx, hy, skin, bodyPath, coat) in StraatArt.boatPeople {
                ctx.fill(Path(ellipseIn: CGRect(x: hx - 7, y: hy - 7, width: 14, height: 14)), with: .color(StadInk.hex(skin)))
                ctx.fill(bodyPath, with: .color(StadInk.hex(coat)))
            }
            ctx.fill(StraatArt.boatCooler, with: .color(StadInk.hex(0xFAC775)))
            ctx.fill(StraatArt.boatHull, with: .color(StadInk.hex(0x6B4A2E)))
            ctx.stroke(StraatArt.boatStripe, with: .color(StadInk.hex(0xF4F1EA)), lineWidth: 3)
        }
        .frame(width: 200 * scale, height: 70 * scale)
    }
}

struct StraatSkaterSprite: View, Equatable {
    let scale: CGFloat
    let skin: UInt32
    let hat: UInt32
    let coat: UInt32

    var body: some View {
        Canvas { ctx, _ in
            ctx.scaleBy(x: scale, y: scale)
            ctx.fill(Path(ellipseIn: CGRect(x: 23, y: 3, width: 14, height: 14)), with: .color(StadInk.hex(skin)))
            ctx.fill(StraatArt.skaterHat, with: .color(StadInk.hex(hat)))
            ctx.stroke(StraatArt.skaterLimbs, with: .color(StadInk.hex(coat)), style: StrokeStyle(lineWidth: 5, lineCap: .round))
            ctx.stroke(StraatArt.skaterBlades, with: .color(StadInk.hex(0x1E1E1C)), style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
        }
        .frame(width: 60 * scale, height: 70 * scale)
    }
}
