import SwiftUI
import UIKit

/// The old-map finish: paper grain, a double rule round the world, district names set along
/// the canal ring, italic names for the countryside and a title cartouche over the lake.
enum KaartOldMap {
    /// A tile of paper grain (specks and a few fibres), made once and tiled over the map.
    static let paperTile: Image = {
        let size = CGSize(width: 180, height: 180)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 2
        format.opaque = false
        let image = UIGraphicsImageRenderer(size: size, format: format).image { ctx in
            var rnd = GevelRandom(seed: 682)
            let cg = ctx.cgContext
            for _ in 0..<1500 {
                let r = 0.25 + rnd.next() * 0.8
                cg.setFillColor(UIColor(red: 0.29, green: 0.21, blue: 0.14, alpha: 0.03 + rnd.next() * 0.09).cgColor)
                cg.fillEllipse(in: CGRect(x: rnd.next() * size.width, y: rnd.next() * size.height, width: r, height: r))
            }
            cg.setLineWidth(0.5)
            cg.setLineCap(.round)
            for _ in 0..<26 {
                let x = rnd.next() * size.width, y = rnd.next() * size.height
                let a = rnd.next() * .pi * 2, l = 6 + rnd.next() * 12
                cg.setStrokeColor(UIColor(red: 0.35, green: 0.27, blue: 0.18, alpha: 0.07).cgColor)
                cg.move(to: CGPoint(x: x, y: y))
                cg.addQuadCurve(
                    to: CGPoint(x: x + cos(a) * l, y: y + sin(a) * l),
                    control: CGPoint(x: x + cos(a + 0.6) * l / 2, y: y + sin(a + 0.6) * l / 2)
                )
                cg.strokePath()
            }
        }
        return Image(uiImage: image)
    }()

    // MARK: Drawn into the map canvas (world units)

    /// Two thin rules round the whole world, like the border of a printed map.
    static func drawFrame(_ ctx: inout GraphicsContext, night: Bool) {
        let ink = StadInk.hex(night ? 0x8A90A2 : 0x2E2117, night ? 0.5 : 0.55)
        let top = -KaartData.north
        ctx.stroke(Path(CGRect(x: 5, y: top + 5, width: 990, height: KaartData.contentHeight - 10)), with: .color(ink), lineWidth: 1.8)
        ctx.stroke(Path(CGRect(x: 10, y: top + 10, width: 980, height: KaartData.contentHeight - 20)), with: .color(ink), lineWidth: 0.6)
    }

    /// District names set letter by letter along the outer band of the ring.
    static func drawDistricts(_ ctx: inout GraphicsContext, night: Bool) {
        let color = StadInk.hex(night ? 0xB9C2D6 : 0x2E2117, night ? 0.55 : 0.6)
        // Between the radial streets and inside the world's edge.
        arcText("DE JORDAAN", radius: 610, center: 134.5, in: &ctx, color: color)
        arcText("GRACHTENGORDEL", radius: 610, center: 45, in: &ctx, color: color)
    }

    /// Italic names for the open country, with a paper halo so they read over fields and water.
    static func drawCountryNames(_ ctx: inout GraphicsContext, night: Bool, paper: Color) {
        let ink = StadInk.hex(night ? 0xB9C2D6 : 0x2E2117, night ? 0.75 : 0.8)
        var c = ctx
        c.addFilter(.shadow(color: paper.opacity(night ? 0.6 : 0.95), radius: 2.5))
        for (name, x, y, size) in [("De Polder", 800.0, 1008.0, 20.0), ("het Strand", 150, 1094, 17), ("de Weide", 846, 742, 16)] {
            c.draw(Text(name).font(Fonts.readingItalic(size)).foregroundStyle(ink), at: CGPoint(x: x, y: y), anchor: .bottomLeading)
        }
    }

    /// "Klinkerstad" on a curled paper scroll over the lake, with the scale 1 : 682.
    static func drawCartouche(_ ctx: inout GraphicsContext, night: Bool) {
        let box = CGRect(x: 30, y: 1124, width: 230, height: 64)
        let paper = StadInk.hex(night ? 0x2E3446 : 0xFFFDF6)
        let ink = StadInk.hex(night ? 0xC9D3EA : 0x2E2117)
        let curl = StadInk.hex(night ? 0x252A3A : 0xEDE4CF)
        ctx.fill(Path(roundedRect: box.offsetBy(dx: 2, dy: 3), cornerRadius: 3), with: .color(StadInk.hex(0x1E1E1C, 0.16)))
        for x in [box.minX, box.maxX] {
            let roll = CGRect(x: x - 7, y: box.minY - 3, width: 14, height: box.height + 6)
            ctx.fill(Path(roundedRect: roll, cornerRadius: 7), with: .color(curl))
            ctx.stroke(Path(roundedRect: roll, cornerRadius: 7), with: .color(ink.opacity(0.7)), lineWidth: 1)
        }
        ctx.fill(Path(box), with: .color(paper))
        ctx.stroke(Path(box), with: .color(ink.opacity(0.8)), lineWidth: 1.4)
        ctx.stroke(Path(box.insetBy(dx: 4, dy: 4)), with: .color(ink.opacity(0.5)), lineWidth: 0.6)
        ctx.draw(
            Text("KLINKERSTAD").font(.custom("Baskerville-SemiBold", size: 19)).tracking(3).foregroundStyle(ink),
            at: CGPoint(x: box.midX, y: box.minY + 23), anchor: .center
        )
        ctx.draw(
            Text("62 plekken · 682 woorden").font(Fonts.readingItalic(11)).foregroundStyle(ink.opacity(0.85)),
            at: CGPoint(x: box.midX, y: box.minY + 40), anchor: .center
        )
        // Scale bar: alternate filled and open blocks, "schaal 1 : 682".
        let barY = box.minY + 51
        for i in 0..<4 {
            let cell = CGRect(x: box.minX + 28 + Double(i) * 18, y: barY, width: 18, height: 4)
            if i % 2 == 0 { ctx.fill(Path(cell), with: .color(ink)) }
            ctx.stroke(Path(cell), with: .color(ink), lineWidth: 0.7)
        }
        ctx.draw(
            Text("schaal 1 : 682").font(Fonts.label(9)).foregroundStyle(ink),
            at: CGPoint(x: box.minX + 108, y: barY + 2), anchor: .leading
        )
    }

    /// Lays `text` along the lower half of a circle round the ring's centre, reading left to right.
    private static func arcText(_ text: String, radius: Double, center: Double, in ctx: inout GraphicsContext, color: Color) {
        let font = Font.custom("Baskerville-SemiBold", size: 13)
        let tracking = 3.5
        let letters = text.map { ctx.resolve(Text(String($0)).font(font).foregroundStyle(color)) }
        let widths = letters.map { Double($0.measure(in: CGSize(width: 100, height: 100)).width) + tracking }
        let total = widths.reduce(0, +) - tracking
        // Angles grow clockwise on screen; text runs from the larger angle to the smaller one.
        var angle = center + total / 2 / radius * 180 / .pi
        for (letter, width) in zip(letters, widths) {
            let mid = angle - width / 2 / radius * 180 / .pi
            let a = mid * .pi / 180
            var c = ctx
            c.translateBy(x: 500 + radius * cos(a), y: 96 + radius * sin(a))
            c.rotate(by: .degrees(mid - 90))
            c.draw(letter, at: .zero, anchor: .center)
            angle -= width / radius * 180 / .pi
        }
    }
}
