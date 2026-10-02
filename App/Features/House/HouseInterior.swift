import SwiftUI

/// The cutaway's fixed drawing: the klokgevel shell, four rooms, the steep stairs, the kitchen
/// counter, the pendant lamps and de hijsbalk with its pulley. Paths are the prototype's, verbatim.
struct HouseInteriorDrawing: View {
    let night: Bool
    let lights: HouseLights
    /// The rope hangs from the pulley unless a hoist is using it.
    var ropeVisible = true

    var body: some View {
        Canvas { ctx, _ in
            HouseInteriorPainter.paint(&ctx, night: night, lights: lights, rope: ropeVisible)
        }
        .frame(width: 390, height: 440)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

enum HouseInteriorPainter {
    private static func p(_ d: String) -> Path { HouseSVG.path(d) }

    static let shellOutline = "M24 134C51 130 80.7 120 80.7 94C80.7 26 237.3 26 237.3 94C237.3 120 267 130 294 134"
    static let shell = p("M24 416V134C51 130 80.7 120 80.7 94C80.7 26 237.3 26 237.3 94C237.3 120 267 130 294 134V416Z")
    static let edge = p(shellOutline)
    static let rooms: [(HouseRoom, Path)] = [
        (.keuken, p("M30 330h256v80H30z")),
        (.woonkamer, p("M30 236h256v88H30z")),
        (.slaapkamer, p("M30 144h256v86H30z")),
        (.zolder, p("M30 138C55.8 134.2 86.7 124.6 86.7 99.6C86.7 34.3 231.3 34.3 231.3 99.6C231.3 124.6 262.2 134.2 288 138Z")),
    ]
    static let tiles = p("M72 356h70v20H72z")
    static let tileGrid = p("M72 366h70M82 356v20M92 356v20M102 356v20M112 356v20M122 356v20M132 356v20")
    static let tileDots: Path = {
        var path = Path()
        for i in 0..<7 {
            for j in 0..<2 {
                let x = 77 + 10 * Double(i), y = 358.5 + 10 * Double(j)
                path.move(to: CGPoint(x: x, y: y))
                path.addLine(to: CGPoint(x: x + 2.5, y: y + 2.5))
                path.addLine(to: CGPoint(x: x, y: y + 5))
                path.addLine(to: CGPoint(x: x - 2.5, y: y + 2.5))
                path.closeSubpath()
            }
        }
        return path
    }()
    /// Woonkamer wallpaper stripes.
    static let stripes: Path = {
        var path = Path()
        for x in stride(from: 78.0, to: 282, by: 14) { path.addRect(CGRect(x: x, y: 236, width: 5, height: 83)) }
        return path
    }()
    /// Slaapkamer wallpaper dots.
    static let dots: Path = {
        var path = Path()
        for row in 0..<4 {
            let y = 158 + Double(row) * 18
            for x in stride(from: 80.0 + Double(row % 2) * 10, to: 284, by: 20) {
                path.addEllipse(in: CGRect(x: x - 1.4, y: y - 1.4, width: 2.8, height: 2.8))
            }
        }
        return path
    }()
    static let rafters = p("M96 138L150 52M222 138L168 52M96 100H222")
    static let plinth = p("M30 405h256v5H30z M30 319h256v5H30z M30 225h256v5H30z")
    static let slabs = p("M70 324h216v6H70z M70 230h216v6H70z M70 138h216v6H70z M24 410h270v6H24z")
    static let hole = p("M30 324h40v6H30z M30 230h40v6H30z M30 138h40v6H30z")
    static let stairs = p("M34 410V397.7H38.9V385.4H43.7V373.1H48.6V360.9H53.4V348.6H58.3V336.3H63.1V324H68V336L42 410Z M34 324V310.6H38.9V297.1H43.7V283.7H48.6V270.3H53.4V256.9H58.3V243.4H63.1V230H68V242L42 324Z M34 230V216.9H38.9V203.7H43.7V190.6H48.6V177.4H53.4V164.3H58.3V151.1H63.1V138H68V150L42 230Z")
    static let banister = p("M32 388L66 302M32 302L66 208M32 208L58 136")
    static let cabinet = p("M72 380h70v30H72z")
    static let counter = p("M70 376h74v4H70z")
    static let handles = p("M101 392h3v3h-3z M110 392h3v3h-3z M106.5 382h1v26h-1z")
    static let shelf = p("M76 292h52v4H76z M82 296h3v7h-3z M119 296h3v7h-3z")
    static let windows: [(HouseRoom, Path)] = [
        (.keuken, p("M286 338h8v18h-8z")),
        (.woonkamer, p("M286 250h8v50h-8z")),
        (.slaapkamer, p("M286 158h8v48h-8z")),
    ]
    static let sideDoor = p("M286 364h8v46h-8z")
    static let sills = p("M283 356h14v3h-14z M283 300h14v3h-14z M283 206h14v3h-14z M283 361h14v3h-14z")
    static let dormerFrame = p("M190 68h26v28H190z")
    static let dormerGlass = p("M193 71h20v22h-20z")
    static let dormerBars = p("M202.2 71h1.6v22h-1.6z M193 81h20v1.6h-20z")
    static let cords = p("M190 330v8M252 236v6M190 144v6")
    static let shades = p("M182 338h16l3 7h-22z M244 242h16l3 7h-22z M182 150h16l3 7h-22z")
    static let bulbs: [(HouseRoom, Path)] = [
        (.keuken, p("M187 345a3 3 0 0 0 6 0z")),
        (.woonkamer, p("M249 249a3 3 0 0 0 6 0z")),
        (.slaapkamer, p("M187 157a3 3 0 0 0 6 0z")),
    ]
    static let beam = p("M206 57h146v7H206z M231 82L250 64H258L233 86Z")
    static let pulley = p("M338 70a6 6 0 1 0 12 0a6 6 0 1 0 -12 0z")
    static let axle = p("M342.5 70a1.5 1.5 0 1 0 3 0a1.5 1.5 0 1 0 -3 0z")
    static let rope = p("M344 76v40M344 116c0 6-7 6-7 1")
    static let pavement = p("M0 12H390M30 0V12M90 0V12M150 0V12M210 0V12M270 0V12M330 0V12M60 12V24M120 12V24M180 12V24M240 12V24M300 12V24M360 12V24")

    /// Where each room's pendant lamp hangs, and the room's box (for the warm glow at night).
    static let lamps: [(HouseRoom, CGPoint, CGRect)] = [
        (.keuken, CGPoint(x: 190, y: 348), CGRect(x: 30, y: 330, width: 256, height: 80)),
        (.woonkamer, CGPoint(x: 252, y: 252), CGRect(x: 30, y: 236, width: 256, height: 88)),
        (.slaapkamer, CGPoint(x: 190, y: 160), CGRect(x: 30, y: 144, width: 256, height: 86)),
    ]

    private static let day: [HouseRoom: UInt32] = [.keuken: 0xEDE6D3, .woonkamer: 0xF2DCC8, .slaapkamer: 0xD7E2E3, .zolder: 0xE3D6BC]
    private static let warm: [HouseRoom: UInt32] = [.keuken: 0xEAD7AE, .woonkamer: 0xEFC9A2, .slaapkamer: 0xD9CDAE, .zolder: 0xE2C796]

    static func paint(_ ctx: inout GraphicsContext, night: Bool, lights: HouseLights, rope: Bool) {
        func c(_ hex: UInt32) -> GraphicsContext.Shading { .color(HouseInk.hex(hex)) }
        func nf(_ hex: UInt32, _ f: Double) -> GraphicsContext.Shading { c(night ? HouseInk.shade(hex, f) : hex) }
        func room(_ r: HouseRoom) -> UInt32 {
            let base = day[r] ?? 0xEDE6D3
            if !night { return base }
            return lights.isOn(r) ? (warm[r] ?? base) : HouseInk.shade(base, 0.38)
        }
        let trim: UInt32 = night ? 0xB9B4A8 : 0xEFEBE2
        func glass(_ on: Bool) -> GraphicsContext.Shading { c(night ? (on ? 0xF6D27A : 0x232B3B) : 0x3E4C55) }

        // The pavement in front.
        ctx.fill(Path(CGRect(x: 0, y: 416, width: 390, height: 24)), with: c(0xA19E95))
        var street = ctx
        street.translateBy(x: 0, y: 416)
        street.stroke(pavement, with: c(0x8E8B83), lineWidth: 1.2)

        ctx.fill(shell, with: nf(0x9A5238, 0.62))
        for (r, path) in rooms { ctx.fill(path, with: c(room(r))) }
        ctx.fill(tiles, with: c(!night ? 0xFFFFFF : lights.keuken ? 0xF3E7CB : HouseInk.shade(0xFFFFFF, 0.4)))
        ctx.stroke(tileGrid, with: c(0xCFCAB9), lineWidth: 0.8)
        ctx.fill(tileDots, with: c(night && !lights.keuken ? HouseInk.shade(0x2F5BD3, 0.5) : 0x2F5BD3))
        ctx.fill(stripes, with: c(HouseInk.shade(room(.woonkamer), 0.94)))
        ctx.fill(dots, with: c(HouseInk.shade(room(.slaapkamer), 0.86)))
        ctx.stroke(rafters, with: c(HouseInk.shade(room(.zolder), 0.8)), style: StrokeStyle(lineWidth: 4, lineCap: .round))
        ctx.fill(plinth, with: nf(0xB79A78, 0.6))
        ctx.fill(slabs, with: nf(0x4A3524, 0.75))
        ctx.fill(hole, with: nf(0x2E2117, 0.8))
        ctx.fill(stairs, with: nf(0x8A5A32, 0.75))
        ctx.stroke(banister, with: c(0x2E2117), style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
        ctx.fill(cabinet, with: nf(0x3F5A4A, 0.75))
        ctx.fill(counter, with: nf(0xE3D6BC, 0.75))
        ctx.fill(handles, with: c(0xC9A15B))
        ctx.fill(shelf, with: nf(0x4A3524, 0.75))
        for (r, path) in windows { ctx.fill(path, with: glass(lights.isOn(r))) }
        ctx.fill(sideDoor, with: nf(0x24533F, 0.7))
        ctx.fill(sills, with: c(trim))
        ctx.fill(dormerFrame, with: c(trim))
        ctx.fill(dormerGlass, with: glass(lights.zolder))
        ctx.fill(dormerBars, with: c(trim))
        ctx.stroke(edge, with: c(trim), style: StrokeStyle(lineWidth: 3, lineJoin: .round))
        ctx.stroke(cords, with: c(0x2E2117), lineWidth: 1.5)
        ctx.fill(shades, with: c(0x2F4B3A))
        for (r, path) in bulbs { ctx.fill(path, with: c(night && lights.isOn(r) ? 0xF6D27A : 0xEFEBE2)) }
        ctx.fill(beam, with: nf(0x4A3524, 0.7))
        ctx.fill(pulley, with: c(0x2E2117))
        ctx.fill(axle, with: c(0xC9A15B))
        if rope {
            ctx.stroke(self.rope, with: c(0x2E2117), style: StrokeStyle(lineWidth: 2, lineCap: .round))
        }

        // Warm light from the pendant lamps of lit rooms.
        if night {
            for (r, center, box) in lamps where lights.isOn(r) {
                var g = ctx
                g.clip(to: Path(box))
                g.fill(Path(box), with: .radialGradient(
                    Gradient(colors: [HouseInk.hex(0xF6D27A, 0.55), HouseInk.hex(0xF6D27A, 0)]),
                    center: center, startRadius: 0, endRadius: 120))
            }
        }
    }
}

/// A Courier name tag with blue tape, like "de keuken" in the cutaway.
struct HouseTag: View {
    let text: String
    var tilt: Double = 0
    var size: CGFloat = 11

    var body: some View {
        Text(text)
            .font(Fonts.label(size))
            .foregroundStyle(Theme.ink)
            .lineLimit(1)
            .fixedSize()
            .padding(.horizontal, 6)
            .padding(.vertical, 1)
            .background(Color.white)
            .overlay(alignment: .topLeading) {
                Rectangle()
                    .fill(Theme.tapeDe.opacity(0.9))
                    .frame(width: 18, height: 7)
                    .rotationEffect(.degrees(-9))
                    .offset(x: 4, y: -5)
            }
            .rotationEffect(.degrees(tilt))
    }
}

/// The room names on the cutaway (not interactive).
struct HouseRoomTags: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            HouseTag(text: "de keuken", tilt: -2).houseAt(74, 333)
            HouseTag(text: "de woonkamer", tilt: 1.5).houseAt(74, 239)
            HouseTag(text: "de slaapkamer", tilt: -1.5).houseAt(74, 147)
            HouseTag(text: "de zolder", tilt: -3).houseAt(6, 98)
        }
        .frame(width: 390, height: 440, alignment: .topLeading)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
