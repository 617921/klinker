import SwiftUI

/// Which rooms have a light on at night (windows outside, warm walls inside).
struct HouseLights: Equatable {
    var keuken = false
    var woonkamer = false
    var slaapkamer = false
    var zolder = false

    init() {}

    init(state: HouseState) {
        keuken = state.isLit(.keuken)
        woonkamer = state.isLit(.woonkamer)
        slaapkamer = state.isLit(.slaapkamer)
        zolder = state.isLit(.zolder)
    }

    func isOn(_ room: HouseRoom) -> Bool {
        switch room {
        case .keuken: keuken
        case .woonkamer: woonkamer
        case .slaapkamer: slaapkamer
        case .zolder: zolder
        }
    }
}

/// Noor's klokgevel and her two neighbours, with the prototype's specs.
enum HouseStreet {
    static let scale: CGFloat = 1.75
    static let noorLeft: CGFloat = 85
    static let noorSize = CGSize(width: 126, height: 200)

    /// Windows from the top: gable (zolder), slaapkamer ×3, woonkamer ×3, keuken ×2.
    static func noor(_ lights: HouseLights) -> HouseSpec {
        let z = lights.zolder, s = lights.slaapkamer, w = lights.woonkamer, k = lights.keuken
        return HouseSpec(type: .klok, width: 120, floors: 2, cols: 3, doorLeft: false, shop: false, flowers: true,
                         lit: [z, s, s, s, w, w, w, k, k], color: 0x9A5238, door: 0x1F3A6B, awning: 0xC8261B)
    }

    struct Neighbour {
        let spec: HouseSpec
        let shape: GevelGeometry
        let left: CGFloat
    }

    static let neighbours: [Neighbour] = {
        var rnd = GevelRandom(seed: 14)
        var lit: [Bool] = []
        for _ in 0..<24 { lit.append(rnd.next() < 0.5) }
        let trap = HouseSpec(type: .trap, width: 100, floors: 2, cols: 3, doorLeft: true, shop: false, flowers: false,
                             lit: Array(lit[0..<12]), color: 0x5E6B73, door: 0x7A1E1E, awning: 0xC8261B)
        let hals = HouseSpec(type: .hals, width: 96, floors: 2, cols: 3, doorLeft: true, shop: true, flowers: true,
                             lit: Array(lit[12...]), color: 0xD9CDB4, door: 0x24533F, awning: 0xC8261B)
        return [
            Neighbour(spec: trap, shape: Gevelkit.gevel(trap), left: -89),
            Neighbour(spec: hals, shape: Gevelkit.gevel(hals), left: 294),
        ]
    }()

    // Noor's own marks, in her house's coordinates: de hijsbalk with its hook, and the gevelsteen "In de Kat".
    private static let beam = SVGPath.parse("M57.5 22.5h11l1.5 5h-14z")
    private static let hook = SVGPath.parse("M63 27.5v8M63 35.5c0 3.2-3.4 3.2-3.4 0.6")
    private static let stone = SVGPath.parse("M52 141.5h22v11H52z")
    private static let stoneEdge = SVGPath.parse("M52.6 142.1h20.8v9.8H52.6z")
    private static let stoneCat = SVGPath.parse(
        "M60.6 151.5c0-3.2 1.3-4.6 3-4.6s3 1.4 3 4.6z M61.9 145.3a1.7 1.7 0 1 0 3.4 0a1.7 1.7 0 1 0 -3.4 0z M62 144.4l0.4-2 1.1 1.2z M65.2 144.4l-0.4-2-1.1 1.2z M66.4 151.2c1.6 0 2.4-1 2.2-2.6l-0.7 0.1c0.1 1-0.3 1.6-1.5 1.6z"
    )

    /// Noor's house in its own 126 × 200 coordinates.
    static func drawNoor(_ lights: HouseLights, night: Bool, in ctx: inout GraphicsContext) {
        let spec = noor(lights)
        GevelPainter.draw(Gevelkit.gevel(spec), palette: .street(spec, night: night), in: &ctx)
        let deco = Ink.hex(0x2E2117)
        ctx.fill(beam, with: .color(deco))
        ctx.stroke(hook, with: .color(deco), lineWidth: 1)
        ctx.fill(stone, with: .color(Ink.hex(night ? 0xB9AE97 : 0xE3D6BC)))
        ctx.stroke(stoneEdge, with: .color(Ink.hex(0xC9A15B)), lineWidth: 0.8)
        ctx.fill(stoneCat, with: .color(deco))
    }
}

/// The sky behind the stage: day gradient with sun and clouds, or night with moon and stars.
struct HouseSky: View {
    let night: Bool
    var twinkle = true

    private static let stars: [(x: CGFloat, y: CGFloat, period: Double)] = {
        var rnd = GevelRandom(seed: 99)
        return (0..<18).map { _ in
            let x = (rnd.next() * 386).rounded()
            let y = (rnd.next() * 150).rounded()
            return (x, y, 2 + rnd.next() * 3)
        }
    }()

    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                stops: night
                    ? [.init(color: Ink.hex(0x141C33), location: 0), .init(color: Ink.hex(0x2E3556), location: 0.65),
                       .init(color: Ink.hex(0x4A4A66), location: 1)]
                    : [.init(color: Ink.hex(0xBCCDD6), location: 0), .init(color: Ink.hex(0xD9DED9), location: 0.55),
                       .init(color: Ink.hex(0xE8E2D2), location: 1)],
                startPoint: .top, endPoint: .bottom
            )
            if night {
                TimelineView(.animation(minimumInterval: 0.1, paused: !twinkle)) { timeline in
                    let t = timeline.date.timeIntervalSinceReferenceDate
                    Canvas { ctx, _ in
                        for star in Self.stars {
                            var c = ctx
                            c.opacity = twinkle ? 0.6 + 0.3 * cos(2 * .pi * t / star.period) : 0.9
                            c.fill(Path(CGRect(x: star.x, y: star.y, width: 2, height: 2)), with: .color(.white))
                        }
                    }
                }
            }
            Canvas { ctx, _ in
                let orb = CGRect(x: 334, y: 14, width: 32, height: 32)
                if night {
                    ctx.fill(Path(ellipseIn: orb), with: .color(Ink.hex(0xD9D4C4)))
                    var c = ctx
                    c.clip(to: Path(ellipseIn: orb))
                    c.fill(Path(ellipseIn: orb.offsetBy(dx: -8, dy: -3)), with: .color(Ink.hex(0xF4F1EA)))
                } else {
                    ctx.fill(Path(ellipseIn: orb), with: .color(Ink.hex(0xF6D27A)))
                    ctx.fill(Path(roundedRect: CGRect(x: 232, y: 34, width: 96, height: 20), cornerRadius: 10), with: .color(.white.opacity(0.75)))
                    ctx.fill(Path(roundedRect: CGRect(x: 256, y: 22, width: 46, height: 26), cornerRadius: 13), with: .color(.white.opacity(0.75)))
                }
            }
        }
        .frame(width: 390, height: 440)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// Outside: Noor's klokgevel between two neighbours, the street, buurman Henk, a lantern and a bike.
struct HouseOutside: View {
    let night: Bool
    let lights: HouseLights
    let onSteen: () -> Void
    let onHenk: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            Canvas { ctx, _ in Self.paint(&ctx, night: night, lights: lights) }
                .frame(width: 390, height: 440)
                .accessibilityHidden(true)

            Text("682")
                .font(Fonts.label(11))
                .foregroundStyle(Ink.hex(0xF6D27A))
                .frame(width: 39, height: 13)
                .houseAt(240, 318)
                .accessibilityHidden(true)
            Text("Noor")
                .font(Fonts.label(11))
                .foregroundStyle(Ink.hex(0x2E2117))
                .frame(width: 33, height: 15)
                .background(Ink.hex(0xC9A15B), in: RoundedRectangle(cornerRadius: 2))
                .houseAt(243, 352)
                .accessibilityLabel("Naambordje: Noor")

            Button(action: onHenk) {
                HouseHenk()
                    .frame(width: 28, height: 60)
                    .frame(width: 44, height: 64, alignment: .bottom)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Buurman Henk")
            .houseAt(14, 334)

            Button(action: onSteen) {
                Color.clear.frame(width: 48, height: 44).contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Gevelsteen: In de Kat")
            .houseAt(171, 277)
        }
        .frame(width: 390, height: 440, alignment: .topLeading)
    }

    private static let pavementLines = SVGPath.parse("M0 16H390M0 32H390")
    private static let pavementJoints = SVGPath.parse(
        "M30 0V16M90 0V16M150 0V16M210 0V16M270 0V16M330 0V16M60 16V32M120 16V32M180 16V32M240 16V32M300 16V32M360 16V32M30 32V48M90 32V48M150 32V48M210 32V48M270 32V48M330 32V48"
    )
    private static let lanternPost = SVGPath.parse("M11 30h2v66h-2z M8 92h8v4H8z")
    private static let lanternGlass = SVGPath.parse("M6 10h12l-2 18H8z")
    private static let lanternCap = SVGPath.parse("M5 8h14l-3-5H8z M8 28h8v3H8z")
    private static let lanternRing = SVGPath.parse("M12 0v3")
    private static let bikeWheels = SVGPath.parse("M2 26a11 11 0 1 0 22 0a11 11 0 1 0 -22 0z M40 26a11 11 0 1 0 22 0a11 11 0 1 0 -22 0z")
    private static let bikeFrame = SVGPath.parse("M13 26L29 26L24 9Z M24 9L44 9L29 26 M44 9L51 26 M18 7H28 M44 9L45 2H51")

    static func paint(_ ctx: inout GraphicsContext, night: Bool, lights: HouseLights) {
        let s = HouseStreet.scale
        for n in HouseStreet.neighbours {
            var c = ctx
            c.translateBy(x: n.left, y: (392 - n.shape.size.height * s).rounded())
            c.scaleBy(x: s, y: s)
            GevelPainter.draw(n.shape, palette: .street(n.spec, night: night), in: &c)
        }
        var noor = ctx
        noor.translateBy(x: HouseStreet.noorLeft, y: (392 - HouseStreet.noorSize.height * s).rounded())
        noor.scaleBy(x: s, y: s)
        HouseStreet.drawNoor(lights, night: night, in: &noor)

        // Street with brick joints and the little posts (Amsterdammertjes).
        let joint = Ink.hex(0x8E8B83)
        ctx.fill(Path(CGRect(x: 0, y: 392, width: 390, height: 48)), with: .color(Ink.hex(0xA19E95)))
        var street = ctx
        street.translateBy(x: 0, y: 392)
        street.stroke(pavementLines, with: .color(joint), lineWidth: 1.5)
        street.stroke(pavementJoints, with: .color(joint), lineWidth: 1.2)
        for x in stride(from: 14.0, through: 374, by: 60) {
            ctx.fill(Path(roundedRect: CGRect(x: x, y: 426, width: 7, height: 14),
                          cornerRadii: RectangleCornerRadii(topLeading: 3, topTrailing: 3)),
                     with: .color(Ink.hex(0x5A2A20)))
        }

        // Lantern (with a warm glow at night).
        if night {
            ctx.fill(Path(ellipseIn: CGRect(x: 26, y: 267, width: 100, height: 100)), with: .radialGradient(
                Gradient(colors: [Ink.hex(0xF6D27A, 0.55), Ink.hex(0xF6D27A, 0)]),
                center: CGPoint(x: 76, y: 317), startRadius: 0, endRadius: 50))
        }
        var lantern = ctx
        lantern.translateBy(x: 64, y: 298)
        let lanternInk = Ink.hex(0x2B3A33)
        lantern.fill(lanternPost, with: .color(lanternInk))
        lantern.fill(lanternGlass, with: .color(Ink.hex(night ? 0xF6D27A : 0xDDE6E8)))
        lantern.stroke(lanternGlass, with: .color(lanternInk), lineWidth: 1.5)
        lantern.fill(lanternCap, with: .color(lanternInk))
        lantern.stroke(lanternRing, with: .color(lanternInk), lineWidth: 2)

        // Noor's bike.
        var bike = ctx
        bike.translateBy(x: 150, y: 356)
        bike.stroke(bikeWheels, with: .color(Ink.hex(0x1E1E1C)), lineWidth: 2.5)
        bike.stroke(bikeFrame, with: .color(Ink.hex(0x2F5BD3)), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
    }
}

/// Buurman Henk, in his green cap (28 × 60).
struct HouseHenk: View {
    private static let torso = SVGPath.parse("M5 60V30a9 9 0 0 1 18 0v30z")
    private static let cap = SVGPath.parse("M6.5 11a7.5 7.5 0 0 1 15 0h5v2.5h-20z")

    var body: some View {
        Canvas { ctx, _ in
            ctx.fill(Self.torso, with: .color(Ink.hex(0x8A5A32)))
            ctx.fill(Path(ellipseIn: CGRect(x: 7, y: 6, width: 14, height: 14)), with: .color(Ink.hex(0xE8C4A0)))
            ctx.fill(Self.cap, with: .color(Ink.hex(0x3F5A4A)))
            ctx.fill(Path(ellipseIn: CGRect(x: 11.1, y: 14.1, width: 1.8, height: 1.8)), with: .color(Ink.hex(0x1E1E1C)))
            ctx.fill(Path(ellipseIn: CGRect(x: 15.1, y: 14.1, width: 1.8, height: 1.8)), with: .color(Ink.hex(0x1E1E1C)))
        }
        .accessibilityHidden(true)
    }
}

extension View {
    /// Places a view with its top-left corner at (x, y) of the 390 × 440 scene.
    func houseAt(_ x: CGFloat, _ y: CGFloat) -> some View {
        offset(x: x, y: y)
    }
}
