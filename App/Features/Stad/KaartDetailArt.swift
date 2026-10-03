import SwiftUI

/// The kinds of details, each with its own little drawing.
nonisolated enum KaartDetailKind: String, Sendable {
    case kat
}

/// Draws one detail into a context scaled to world units, origin at the sprite's top-left,
/// facing right. `t` is the clock for little movements (a tail, wings, paddling).
nonisolated enum KaartDetailArt {
    static func draw(_ kind: KaartDetailKind, size: CGSize, t: Double, night: Bool, season: GevelSeason, in ctx: inout GraphicsContext) {
        switch kind {
        case .kat: kat(size: size, t: t, night: night, in: &ctx)
        }
    }

    /// A black cat sitting, tail swishing.
    private static func kat(size: CGSize, t: Double, night: Bool, in ctx: inout GraphicsContext) {
        let fur = StadInk.hex(night ? 0x0E0F14 : 0x1E1E1C)
        let w = size.width, h = size.height
        let swish = sin(t * 2.2) * 1.4
        var tail = Path()
        tail.move(to: CGPoint(x: w * 0.62, y: h * 0.92))
        tail.addQuadCurve(to: CGPoint(x: w * 0.98 + swish * 0.3, y: h * 0.35), control: CGPoint(x: w * 1.05, y: h * 0.95 + swish))
        ctx.stroke(tail, with: .color(fur), style: StrokeStyle(lineWidth: 1.3, lineCap: .round))
        ctx.fill(Path(ellipseIn: CGRect(x: w * 0.15, y: h * 0.4, width: w * 0.55, height: h * 0.6)), with: .color(fur))
        ctx.fill(Path(ellipseIn: CGRect(x: w * 0.08, y: h * 0.12, width: w * 0.42, height: h * 0.42)), with: .color(fur))
        ctx.fill(KaartPen.polygon([(w * 0.1, h * 0.25), (w * 0.12, 0), (w * 0.24, h * 0.16)]), with: .color(fur))
        ctx.fill(KaartPen.polygon([(w * 0.32, h * 0.16), (w * 0.44, 0), (w * 0.47, h * 0.26)]), with: .color(fur))
        let eye = StadInk.hex(0xF2C53D)
        ctx.fill(Path(ellipseIn: CGRect(x: w * 0.16, y: h * 0.27, width: w * 0.08, height: h * 0.09)), with: .color(eye))
        ctx.fill(Path(ellipseIn: CGRect(x: w * 0.31, y: h * 0.27, width: w * 0.08, height: h * 0.09)), with: .color(eye))
    }
}
