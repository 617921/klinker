import SwiftUI

/// The countryside south of the canal ring: striped polder fields (tulips in spring, wheat in
/// summer, ploughed soil in autumn, frost in winter), cows, sheep on the dike, a windmill,
/// parasols on the beach in summer, and skate marks on frozen canals. World units.
nonisolated enum KaartSouth {
    /// The decorative mill in the meadow east of the ring; its sails turn in the life layer.
    static let millHub = CGPoint(x: 958, y: 617)

    // MARK: Fields

    static func drawFields(_ ctx: inout GraphicsContext, rects: [CGRect], colors c: KaartColors) {
        guard !c.fields.isEmpty else { return }
        for (i, rect) in rects.enumerated() {
            let look = c.fields[(i * 5 + 2) % c.fields.count]
            ctx.fill(Path(rect), with: .color(look.soil))
            var rows = Path()
            let vertical = i % 3 == 1
            let span = vertical ? rect.width : rect.height
            var at: CGFloat = 1.4
            while at + 4.4 <= span {
                rows.addRect(vertical
                    ? CGRect(x: rect.minX + at, y: rect.minY, width: 4.4, height: rect.height)
                    : CGRect(x: rect.minX, y: rect.minY + at, width: rect.width, height: 4.4))
                at += 7.3
            }
            ctx.fill(rows, with: .color(look.row))
        }
    }

    // MARK: Ice

    /// Frozen canals: white skate marks along the rings.
    static func drawIce(_ ctx: inout GraphicsContext, night: Bool) {
        var marks = Path()
        for (R, from, to) in [(150.0, 30.0, 70.0), (150, 110, 150), (290, 20, 55), (290, 95, 140), (430, 40, 80), (430, 120, 160), (570, 60, 120)] {
            for offset in [-3.0, 2.5] {
                let r = R + offset
                marks.addArc(center: CGPoint(x: 500, y: 96), radius: r, startAngle: .degrees(from + offset), endAngle: .degrees(to - offset), clockwise: false)
            }
        }
        ctx.stroke(marks, with: .color(.white.opacity(night ? 0.25 : 0.8)), style: StrokeStyle(lineWidth: 1.2, lineCap: .round, dash: [14, 6]))
    }

    // MARK: Countryside

    static func drawCountryside(_ ctx: inout GraphicsContext, night: Bool, season: GevelSeason) {
        drawMill(&ctx, night: night)
        guard season != .winter else { return }
        for (x, y, left) in [(214.0, 992.0, false), (238, 1001, true), (262, 987, false), (918, 684, true), (942, 697, false)] {
            drawCow(&ctx, at: CGPoint(x: x, y: y), facingLeft: left, night: night)
        }
        for (x, y) in [(584.0, 1056.0), (600, 1064), (614, 1051), (630, 1067), (646, 1056)] {
            drawSheep(&ctx, at: CGPoint(x: x, y: y), night: night)
        }
        if season == .zomer && !night {
            for (x, y, color) in [(92.0, 1070.0, 0xD8342C as UInt32), (134, 1084, 0x2F5BD3), (188, 1068, 0xF2C53D), (404, 1080, 0xF2711C), (452, 1066, 0x0F6E56)] {
                drawParasol(&ctx, at: CGPoint(x: x, y: y), color: color)
            }
        }
    }

    private static func shade(_ hex: UInt32, _ night: Bool) -> Color {
        StadInk.hex(Gevelkit.shade(hex, night ? 0.45 : 1))
    }

    private static func drawMill(_ ctx: inout GraphicsContext, night: Bool) {
        let x = millHub.x
        ctx.fill(Path(ellipseIn: CGRect(x: x - 16, y: 646, width: 36, height: 8)), with: .color(StadInk.hex(0x1E1E1C, 0.15)))
        var tower = Path()
        tower.move(to: CGPoint(x: x - 10, y: 650))
        tower.addLine(to: CGPoint(x: x - 6, y: 620))
        tower.addLine(to: CGPoint(x: x + 6, y: 620))
        tower.addLine(to: CGPoint(x: x + 10, y: 650))
        tower.closeSubpath()
        ctx.fill(tower, with: .color(shade(0x3F5A4A, night)))
        var lit = ctx
        lit.clip(to: tower)
        lit.fill(Path(CGRect(x: x + 3, y: 618, width: 10, height: 34)), with: .color(shade(0x2F4B3A, night)))
        ctx.fill(Path(CGRect(x: x - 14, y: 634, width: 28, height: 2.5)), with: .color(shade(0x2E2117, night)))
        var cap = Path()
        cap.move(to: CGPoint(x: x - 8, y: 621))
        cap.addQuadCurve(to: CGPoint(x: x + 8, y: 621), control: CGPoint(x: x, y: 606))
        cap.closeSubpath()
        ctx.fill(cap, with: .color(shade(0x2C2C2A, night)))
        ctx.fill(Path(roundedRect: CGRect(x: x - 3, y: 642, width: 6, height: 8), cornerRadius: 2), with: .color(shade(0x2E2117, night)))
        ctx.fill(Path(ellipseIn: CGRect(x: x - 2, y: 626, width: 4, height: 4)), with: .color(StadInk.hex(night ? 0xF6D27A : 0xEFEBE2)))
    }

    private static func drawCow(_ ctx: inout GraphicsContext, at p: CGPoint, facingLeft: Bool, night: Bool) {
        var c = ctx
        c.translateBy(x: p.x, y: p.y)
        if facingLeft { c.scaleBy(x: -1, y: 1) }
        let dark = shade(0x1E1E1C, night)
        var legs = Path()
        for lx in [-5.0, -2.5, 3.0, 5.5] {
            legs.move(to: CGPoint(x: lx, y: 2))
            legs.addLine(to: CGPoint(x: lx, y: 6))
        }
        c.stroke(legs, with: .color(dark), lineWidth: 1.3)
        c.fill(Path(roundedRect: CGRect(x: -7, y: -3.5, width: 14, height: 7), cornerRadius: 3.5), with: .color(shade(0xF7F5EF, night)))
        c.fill(Path(ellipseIn: CGRect(x: -4.5, y: -3.2, width: 5, height: 4)), with: .color(dark))
        c.fill(Path(ellipseIn: CGRect(x: 2, y: -1, width: 3.5, height: 3)), with: .color(dark))
        c.fill(Path(roundedRect: CGRect(x: 6, y: -4.5, width: 4.5, height: 4.5), cornerRadius: 1.5), with: .color(dark))
        c.fill(Path(ellipseIn: CGRect(x: 8.4, y: -2, width: 2.6, height: 2.2)), with: .color(shade(0xE8A9A0, night)))
    }

    private static func drawSheep(_ ctx: inout GraphicsContext, at p: CGPoint, night: Bool) {
        let wool = shade(0xF4F1EA, night)
        for (dx, dy) in [(-3.0, 0.0), (0, -1.5), (3, 0), (0, 1)] {
            ctx.fill(Path(ellipseIn: CGRect(x: p.x + dx - 3, y: p.y + dy - 3, width: 6, height: 6)), with: .color(wool))
        }
        ctx.fill(Path(ellipseIn: CGRect(x: p.x + 4.5, y: p.y - 3.5, width: 3.5, height: 3)), with: .color(shade(0x2C2C2A, night)))
    }

    private static func drawParasol(_ ctx: inout GraphicsContext, at p: CGPoint, color: UInt32) {
        ctx.fill(Path(ellipseIn: CGRect(x: p.x - 7, y: p.y + 4, width: 16, height: 4)), with: .color(StadInk.hex(0x1E1E1C, 0.12)))
        ctx.stroke(Path { $0.move(to: CGPoint(x: p.x, y: p.y)); $0.addLine(to: CGPoint(x: p.x, y: p.y + 7)) }, with: .color(StadInk.hex(0x6B4A2E)), lineWidth: 1)
        var top = Path()
        top.move(to: CGPoint(x: p.x - 8, y: p.y + 1))
        top.addQuadCurve(to: CGPoint(x: p.x + 8, y: p.y + 1), control: CGPoint(x: p.x, y: p.y - 9))
        top.closeSubpath()
        ctx.fill(top, with: .color(StadInk.hex(color)))
        var stripe = ctx
        stripe.clip(to: top)
        stripe.fill(Path(CGRect(x: p.x - 2, y: p.y - 9, width: 4, height: 10)), with: .color(.white.opacity(0.85)))
    }
}
