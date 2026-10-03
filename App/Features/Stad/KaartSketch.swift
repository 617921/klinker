import SwiftUI

/// A place not reached yet, drawn in pencil on a pale wash: the very building it will become,
/// so learning a place colours it in. Graphite by day, chalk by night. Same frame as `KaartHouseCanvas`.
struct KaartSketchCanvas: View, Equatable {
    let n: Int
    let night: Bool
    let zoom: CGFloat
    /// Solid ground under the wash, so the sketch can cover a finished house (the "opened" party).
    var backing: Color? = nil

    var body: some View {
        let geo = KaartData.house(n)
        let pad = KaartHouseCanvas.pad
        let ink = KaartPencil(night: night)
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom, y: zoom)
            ctx.translateBy(x: pad, y: pad)
            ctx.scaleBy(x: geo.spriteSize.width / geo.viewBox.width, y: geo.spriteSize.height / geo.viewBox.height)
            ctx.translateBy(x: -geo.viewBox.minX, y: -geo.viewBox.minY)
            let g = geo.gevel

            var outline = Path()
            for part in [g.body, geo.side, geo.roof, geo.spA, geo.spB] { outline.addPath(part) }
            var details = Path()
            for part in [g.glass, g.lit, g.door, g.awning, geo.spC] { details.addPath(part) }
            if geo.side.isEmpty {
                // Market, park and tram stop: their posts and stripes are the drawing.
                details.addPath(g.trim)
                details.addPath(g.stripes)
            }

            if let backing { ctx.fill(outline, with: .color(backing)) }
            ctx.fill(outline, with: .color(ink.wash))
            Self.hatch(geo.side, in: &ctx, color: ink.ghost)

            let main = StrokeStyle(lineWidth: 3.6, lineCap: .round, lineJoin: .round)
            let fine = StrokeStyle(lineWidth: 2.2, lineCap: .round, lineJoin: .round)
            var echo = ctx
            echo.translateBy(x: 1.8, y: -1.2)
            echo.stroke(outline, with: .color(ink.ghost), style: main)
            ctx.stroke(outline, with: .color(ink.lead), style: main)
            ctx.stroke(details, with: .color(ink.lead), style: fine)

            let base = geo.viewBox.maxY - 6
            var ground = Path()
            ground.move(to: CGPoint(x: geo.viewBox.minX + 2, y: base + 1))
            ground.addLine(to: CGPoint(x: geo.viewBox.maxX - 4, y: base - 0.5))
            ctx.stroke(ground, with: .color(ink.lead), style: fine)
        }
        .frame(width: (geo.spriteSize.width + 2 * pad) * zoom, height: (geo.spriteSize.height + 2 * pad) * zoom)
        .allowsHitTesting(false)
    }

    /// Diagonal pencil hatching inside a shape (the shaded side wall).
    static func hatch(_ shape: Path, in ctx: inout GraphicsContext, color: Color, spacing: CGFloat = 7, width: CGFloat = 1.5) {
        guard !shape.isEmpty else { return }
        let box = shape.boundingRect
        var lines = Path()
        var x = box.minX - box.height
        while x < box.maxX {
            lines.move(to: CGPoint(x: x, y: box.maxY))
            lines.addLine(to: CGPoint(x: x + box.height, y: box.minY))
            x += spacing
        }
        var clipped = ctx
        clipped.clip(to: shape)
        clipped.stroke(lines, with: .color(color), lineWidth: width)
    }
}

/// The mill, tower, ring and boat plots in pencil: their outline, not a canal house.
struct KaartPlotSketch: View, Equatable {
    let outline: KaartOutline
    let night: Bool
    let zoom: CGFloat

    var body: some View {
        let ink = KaartPencil(night: night)
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom, y: zoom)
            let base = KaartArt.base(outline)
            let shape = KaartArt.outline(outline)
            ctx.fill(shape, with: .color(ink.wash))
            KaartSketchCanvas.hatch(base, in: &ctx, color: ink.ghost, spacing: 4, width: 0.8)
            var echo = ctx
            echo.translateBy(x: 0.7, y: -0.5)
            echo.stroke(shape, with: .color(ink.ghost), style: StrokeStyle(lineWidth: 1.2, lineCap: .round, lineJoin: .round))
            ctx.stroke(shape, with: .color(ink.lead), style: StrokeStyle(lineWidth: 1.2, lineCap: .round, lineJoin: .round))
            ctx.stroke(base, with: .color(ink.ghost), style: StrokeStyle(lineWidth: 0.9, lineCap: .round, lineJoin: .round))
        }
        .frame(width: 60 * zoom, height: 60 * zoom)
        .allowsHitTesting(false)
    }
}

/// Graphite on paper by day, chalk on the night map.
nonisolated struct KaartPencil: Sendable {
    let lead: Color
    let ghost: Color
    let wash: Color

    init(night: Bool) {
        lead = night ? StadInk.hex(0xC9D3EA, 0.6) : StadInk.hex(0x55534E, 0.8)
        ghost = night ? StadInk.hex(0xC9D3EA, 0.22) : StadInk.hex(0x55534E, 0.28)
        wash = night ? StadInk.hex(0x2A3146, 0.6) : StadInk.hex(0xFFFDF6, 0.6)
    }
}

/// Under a sketch: its number in pencil, or a note for the place that opens next.
struct KaartSketchLabel: View {
    let n: Int
    let next: Bool
    let night: Bool

    var body: some View {
        if next {
            Text("VEL \(n) · VOLGENDE")
                .font(Fonts.label(11))
                .foregroundStyle(night ? StadInk.hex(0xF6D27A) : Theme.orangeText)
                .padding(.horizontal, 5)
                .padding(.vertical, 1)
                .background(night ? StadInk.hex(0x2E3446) : Theme.note)
                .overlay(Rectangle().stroke(Theme.orange, style: StrokeStyle(lineWidth: 1.5, dash: [3, 2])))
                .fixedSize()
                .rotationEffect(.degrees(-1.5))
        } else {
            Text("\(n)")
                .font(.custom("Noteworthy-Bold", size: 12))
                .foregroundStyle(night ? StadInk.hex(0xC9D3EA, 0.7) : StadInk.hex(0x55534E, 0.85))
                .fixedSize()
                .rotationEffect(.degrees(-6))
        }
    }
}
