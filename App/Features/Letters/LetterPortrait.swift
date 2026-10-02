import SwiftUI

/// A flat head-and-shoulders portrait of a suspect on a coloured photo backdrop:
/// Henk with his cap, Ria with her post cap, Sanne with long hair, the clerk with glasses.
struct LetterPortrait: View {
    let suspectID: String

    var body: some View {
        Canvas { ctx, size in
            ctx.fill(Path(CGRect(origin: .zero, size: size)), with: .color(LetterInk.hex(Self.backdrop(suspectID))))
            let k = min(size.width / 60, size.height / 56)
            ctx.translateBy(x: (size.width - 60 * k) / 2, y: size.height - 56 * k)
            ctx.scaleBy(x: k, y: k)
            LetterPortraitArt.draw(suspectID, in: &ctx)
        }
        .accessibilityHidden(true)
    }

    nonisolated static func backdrop(_ id: String) -> UInt32 {
        switch id {
        case "henk": 0xF4C0D1
        case "ria": 0xC9E6E2
        case "sanne": 0xFAC775
        case "loket4": 0xD9D6CC
        default: 0xE2DED3
        }
    }
}

/// The drawings, in a 60 × 56 box.
nonisolated enum LetterPortraitArt {
    private struct Look {
        var skin: UInt32
        var clothes: UInt32
    }

    static func draw(_ id: String, in ctx: inout GraphicsContext) {
        let look: Look = switch id {
        case "henk": Look(skin: 0xE2B48C, clothes: 0x7A5230)
        case "ria": Look(skin: 0xC99A74, clothes: 0xF2711C)
        case "sanne": Look(skin: 0x8D5B3E, clothes: 0x0F6E56)
        case "loket4": Look(skin: 0xF0C8A0, clothes: 0x5F5E5A)
        default: Look(skin: 0xC99A74, clothes: 0x3C3489)
        }
        if id == "sanne" { sanneHairBack(&ctx) }
        if id == "ria" { fill(&ctx, Path(ellipseIn: CGRect(x: 37, y: 18, width: 10, height: 13)), 0x4B2E1C) }
        fill(&ctx, Path(CGRect(x: 26, y: 29, width: 8, height: 11)), look.skin)
        fill(&ctx, shoulders(), look.clothes)
        switch id {
        case "henk":
            fill(&ctx, polygon([(24, 39), (30, 46), (36, 39)]), 0xF6EBD9)
        case "ria":
            var band = ctx
            band.clip(to: shoulders())
            band.fill(Path(CGRect(x: 0, y: 47, width: 60, height: 3)), with: .color(LetterInk.hex(0xF4F1EA)))
        case "loket4":
            fill(&ctx, polygon([(24, 38.5), (36, 38.5), (30, 48)]), 0xFFFFFF)
            fill(&ctx, polygon([(30, 39.5), (28, 42.5), (30, 55), (32, 42.5)]), 0xC8261B)
        default:
            break
        }
        if id == "henk" {
            fill(&ctx, Path(ellipseIn: CGRect(x: 18, y: 13, width: 6, height: 11)), 0xB4B2A9)
            fill(&ctx, Path(ellipseIn: CGRect(x: 36, y: 13, width: 6, height: 11)), 0xB4B2A9)
        }
        fill(&ctx, Path(ellipseIn: CGRect(x: 18.5, y: 18, width: 4, height: 6)), look.skin)
        fill(&ctx, Path(ellipseIn: CGRect(x: 37.5, y: 18, width: 4, height: 6)), look.skin)
        fill(&ctx, Path(ellipseIn: CGRect(x: 20, y: 9.5, width: 20, height: 23)), look.skin)
        switch id {
        case "henk": henk(&ctx)
        case "ria": ria(&ctx)
        case "sanne": sanne(&ctx)
        case "loket4": clerk(&ctx)
        default: break
        }
    }

    // MARK: - People

    private static func henk(_ ctx: inout GraphicsContext) {
        var cap = Path()
        cap.move(to: CGPoint(x: 19, y: 16.5))
        cap.addCurve(to: CGPoint(x: 41, y: 16.5), control1: CGPoint(x: 19, y: 7), control2: CGPoint(x: 41, y: 7))
        cap.closeSubpath()
        fill(&ctx, cap, 0x3C4A5C)
        var brim = Path()
        brim.move(to: CGPoint(x: 17.5, y: 16)); brim.addLine(to: CGPoint(x: 45, y: 16))
        brim.addQuadCurve(to: CGPoint(x: 41, y: 19.5), control: CGPoint(x: 45, y: 19))
        brim.addLine(to: CGPoint(x: 17.5, y: 19.5)); brim.closeSubpath()
        fill(&ctx, brim, 0x2A3442)
        stroke(&ctx, line((23.5, 20.5), (28, 21.5)), 0x6B6A64, 1.6)
        stroke(&ctx, line((32, 21.5), (36.5, 20.5)), 0x6B6A64, 1.6)
        eyes(&ctx, y: 23.5)
        fill(&ctx, Path(ellipseIn: CGRect(x: 25.5, y: 26.5, width: 9, height: 3.2)), 0x8F8B80)
        stroke(&ctx, line((28, 30.2), (32, 30.2)), 0x7A3B2E, 1)
    }

    private static func ria(_ ctx: inout GraphicsContext) {
        fill(&ctx, Path(ellipseIn: CGRect(x: 20, y: 12, width: 20, height: 8)), 0x4B2E1C)
        var crown = Path()
        crown.move(to: CGPoint(x: 19.5, y: 15))
        crown.addCurve(to: CGPoint(x: 40.5, y: 15), control1: CGPoint(x: 20, y: 6), control2: CGPoint(x: 40, y: 6))
        crown.closeSubpath()
        fill(&ctx, crown, 0xF2711C)
        fill(&ctx, Path(CGRect(x: 19.5, y: 13, width: 21, height: 2.4)), 0xC8261B)
        var visor = Path()
        visor.move(to: CGPoint(x: 18.5, y: 15)); visor.addLine(to: CGPoint(x: 41.5, y: 15))
        visor.addLine(to: CGPoint(x: 43.5, y: 18)); visor.addLine(to: CGPoint(x: 18.5, y: 18)); visor.closeSubpath()
        fill(&ctx, visor, 0x1E1E1C)
        eyes(&ctx, y: 22.5)
        smile(&ctx)
    }

    private static func sanneHairBack(_ ctx: inout GraphicsContext) {
        var hair = Path()
        hair.move(to: CGPoint(x: 17, y: 22))
        hair.addCurve(to: CGPoint(x: 43, y: 22), control1: CGPoint(x: 16, y: 6), control2: CGPoint(x: 44, y: 6))
        hair.addLine(to: CGPoint(x: 43, y: 37))
        hair.addQuadCurve(to: CGPoint(x: 36, y: 35), control: CGPoint(x: 39, y: 39))
        hair.addLine(to: CGPoint(x: 24, y: 35))
        hair.addQuadCurve(to: CGPoint(x: 17, y: 37), control: CGPoint(x: 21, y: 39))
        hair.closeSubpath()
        fill(&ctx, hair, 0x2E2117)
    }

    private static func sanne(_ ctx: inout GraphicsContext) {
        var fringe = Path()
        fringe.move(to: CGPoint(x: 19.5, y: 18))
        fringe.addCurve(to: CGPoint(x: 40.5, y: 18), control1: CGPoint(x: 20, y: 6.5), control2: CGPoint(x: 40, y: 6.5))
        fringe.addQuadCurve(to: CGPoint(x: 27, y: 14), control: CGPoint(x: 34, y: 12))
        fringe.addQuadCurve(to: CGPoint(x: 19.5, y: 18), control: CGPoint(x: 22, y: 15))
        fill(&ctx, fringe, 0x2E2117)
        fill(&ctx, Path(ellipseIn: CGRect(x: 18.3, y: 25.5, width: 2.6, height: 2.6)), 0xEF9F27)
        fill(&ctx, Path(ellipseIn: CGRect(x: 39.1, y: 25.5, width: 2.6, height: 2.6)), 0xEF9F27)
        eyes(&ctx, y: 22, color: 0x1E1E1C)
        smile(&ctx)
    }

    private static func clerk(_ ctx: inout GraphicsContext) {
        fill(&ctx, Path(ellipseIn: CGRect(x: 18.5, y: 13, width: 5, height: 9)), 0x6B5A4A)
        fill(&ctx, Path(ellipseIn: CGRect(x: 36.5, y: 13, width: 5, height: 9)), 0x6B5A4A)
        var strands = Path()
        strands.move(to: CGPoint(x: 24, y: 12)); strands.addQuadCurve(to: CGPoint(x: 36, y: 12), control: CGPoint(x: 30, y: 9.5))
        stroke(&ctx, strands, 0x6B5A4A, 1.2)
        eyes(&ctx, y: 22)
        for cx in [25.8, 34.2] {
            ctx.stroke(Path(ellipseIn: CGRect(x: cx - 3.4, y: 18.6, width: 6.8, height: 6.8)),
                       with: .color(LetterInk.hex(0x1E1E1C)), lineWidth: 1.2)
        }
        stroke(&ctx, line((29.2, 22), (30.8, 22)), 0x1E1E1C, 1.2)
        stroke(&ctx, line((27.5, 28.5), (32.5, 28.5)), 0x7A3B2E, 1)
    }

    // MARK: - Bits

    private static func shoulders() -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 6, y: 56))
        p.addCurve(to: CGPoint(x: 30, y: 37.5), control1: CGPoint(x: 6, y: 44), control2: CGPoint(x: 16, y: 37.5))
        p.addCurve(to: CGPoint(x: 54, y: 56), control1: CGPoint(x: 44, y: 37.5), control2: CGPoint(x: 54, y: 44))
        p.closeSubpath()
        return p
    }

    private static func eyes(_ ctx: inout GraphicsContext, y: CGFloat, color: UInt32 = 0x2E2117) {
        fill(&ctx, Path(ellipseIn: CGRect(x: 24.8, y: y - 1.2, width: 2.4, height: 2.4)), color)
        fill(&ctx, Path(ellipseIn: CGRect(x: 32.8, y: y - 1.2, width: 2.4, height: 2.4)), color)
    }

    private static func smile(_ ctx: inout GraphicsContext) {
        var p = Path()
        p.move(to: CGPoint(x: 27, y: 27.5)); p.addQuadCurve(to: CGPoint(x: 33, y: 27.5), control: CGPoint(x: 30, y: 30.5))
        stroke(&ctx, p, 0x7A3B2E, 1.1)
    }

    private static func polygon(_ points: [(CGFloat, CGFloat)]) -> Path {
        var p = Path()
        guard let first = points.first else { return p }
        p.move(to: CGPoint(x: first.0, y: first.1))
        for point in points.dropFirst() { p.addLine(to: CGPoint(x: point.0, y: point.1)) }
        p.closeSubpath()
        return p
    }

    private static func line(_ a: (CGFloat, CGFloat), _ b: (CGFloat, CGFloat)) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: a.0, y: a.1))
        p.addLine(to: CGPoint(x: b.0, y: b.1))
        return p
    }

    private static func fill(_ ctx: inout GraphicsContext, _ path: Path, _ hex: UInt32) {
        ctx.fill(path, with: .color(LetterInk.hex(hex)))
    }

    private static func stroke(_ ctx: inout GraphicsContext, _ path: Path, _ hex: UInt32, _ width: CGFloat) {
        ctx.stroke(path, with: .color(LetterInk.hex(hex)), style: StrokeStyle(lineWidth: width, lineCap: .round))
    }
}
