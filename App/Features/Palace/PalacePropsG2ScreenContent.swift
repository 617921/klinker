import SwiftUI

/// What the g2 screens show (drawn in the display's own size): an advert, a programme to watch
/// again, a video being edited.
enum G2ScreenContent {
    /// An advert: a bright background, a fizzy bottle, a starburst with `text` and a price `caption`.
    static func ad(_ s: PropPen, _ p: PalacePropParams) {
        let (w, h) = (s.size.width, s.size.height)
        s.rect(0, 0, w, h, 0x5DCAA5)
        s.svg("M0 \(h)L\(w * 0.45) 0H\(w * 0.7)L\(w * 0.2) \(h)Z", 0xFFFFFF, 0.18)
        // The bottle
        let b = s.within(CGRect(x: w * 0.08, y: h * 0.1, width: h * 0.42, height: h * 0.84), unit: h * 0.84 / 60)
        b.svg("M9 0H17V8Q24 13 24 22V58Q24 60 22 60H4Q2 60 2 58V22Q2 13 9 8Z", 0xC8261B)
        b.rect(2, 26, 22, 16, 0xFFFDF6)
        b.svg(PalacePeople.star(cx: 13, cy: 34, r: 6), 0xF2711C)
        b.rect(8.5, -3, 9, 5, 0x3E4C55, radius: 1)
        for (x, y) in [(28.0, 8.0), (32, 16), (27, 22)] as [(CGFloat, CGFloat)] { b.ring(x, y, 2, 0xFFFFFF, 1) }
        // Starburst with the slogan
        let c = CGPoint(x: w * 0.68, y: h * 0.38), r = min(w * 0.3, h * 0.36)
        var star = ""
        for k in 0..<24 {
            let a = Double(k) * .pi / 12
            let rr = k % 2 == 0 ? r : r * 0.78
            star += (k == 0 ? "M" : "L") + String(format: "%.1f %.1f", c.x + cos(a) * rr, c.y + sin(a) * rr)
        }
        s.svg(star + "Z", 0xFAC775)
        s.text(p.text ?? "", PropFont.heavy(r * 0.5), 0xC8261B, at: c, maxWidth: r * 1.5)
        if let caption = p.caption {
            s.rect(w * 0.48, h * 0.76, w * 0.42, h * 0.2, 0x1E1E1C, radius: 2)
            s.text(caption, PropFont.heavy(h * 0.15), 0xFFFFFF, at: CGPoint(x: w * 0.69, y: h * 0.86), maxWidth: w * 0.4)
        }
    }

    /// Watch again: a paused programme, a big turn-back arrow round a play button, a progress bar,
    /// and `text` (when it was on) in the corner.
    static func replay(_ s: PropPen, _ p: PalacePropParams) {
        let (w, h) = (s.size.width, s.size.height)
        s.rect(0, 0, w, h, 0x5E8C9A)
        s.svg("M0 \(h * 0.7)Q\(w * 0.3) \(h * 0.5) \(w * 0.6) \(h * 0.65)T\(w) \(h * 0.6)V\(h)H0Z", 0x5E8C45)
        s.rect(0, 0, w, h, 0x1E1E1C, 0.35)
        let c = CGPoint(x: w / 2, y: h * 0.45), r = h * 0.27
        var arc = Path()
        arc.addArc(center: c, radius: r, startAngle: .degrees(-60), endAngle: .degrees(200), clockwise: false)
        s.stroke(arc, 0xFFFFFF, r * 0.22)
        let tip = CGPoint(x: c.x + r * CGFloat(cos(-60.0 * .pi / 180)), y: c.y + r * CGFloat(sin(-60.0 * .pi / 180)))
        s.svg("M\(tip.x - r * 0.45) \(tip.y - r * 0.15)L\(tip.x + r * 0.2) \(tip.y - r * 0.35)L\(tip.x + r * 0.05) \(tip.y + r * 0.35)Z", 0xFFFFFF)
        s.svg("M\(c.x - r * 0.3) \(c.y - r * 0.4)L\(c.x + r * 0.45) \(c.y)L\(c.x - r * 0.3) \(c.y + r * 0.4)Z", 0xFFFFFF)
        s.rect(w * 0.06, h * 0.86, w * 0.88, 3, 0xFFFFFF, radius: 1.5, 0.5)
        s.rect(w * 0.06, h * 0.86, w * 0.5, 3, 0xC8261B, radius: 1.5)
        s.dot(w * 0.56, h * 0.86 + 1.5, 3.4, 0xC8261B)
        if let text = p.text {
            let font = PropFont.heavy(min(9, h * 0.16))
            let tw = min(w * 0.8, s.width(of: text, font) + 8)
            s.rect(3, 3, tw, h * 0.2, 0x1E1E1C, radius: 2, 0.8)
            s.text(text, font, 0xFAC775, at: CGPoint(x: 3 + tw / 2, y: 3 + h * 0.1), maxWidth: tw - 4)
        }
    }

    /// Editing: a preview of the clip on top, a timeline with coloured clips below, a red playhead
    /// and a pair of scissors cutting one clip in two.
    static func edit(_ s: PropPen, _ p: PalacePropParams) {
        let (w, h) = (s.size.width, s.size.height)
        s.rect(0, 0, w, h, 0x232B3B)
        let preview = CGRect(x: w * 0.22, y: 3, width: w * 0.56, height: h * 0.42)
        s.rect(preview, 0x5E8C9A)
        s.svg("M\(preview.minX) \(preview.maxY)L\(preview.minX + preview.width * 0.35) \(preview.minY + preview.height * 0.45)L\(preview.minX + preview.width * 0.6) \(preview.maxY)Z", 0x5E8C45)
        s.dot(preview.maxX - 8, preview.minY + 7, 4, 0xFAC775)
        let rows: [[(CGFloat, CGFloat, UInt32)]] = [
            [(0.04, 0.3, 0xF2711C), (0.36, 0.28, 0x2F5BD3), (0.66, 0.3, 0xF2711C)],
            [(0.04, 0.5, 0x5DCAA5), (0.58, 0.38, 0x5DCAA5)],
        ]
        for (r, row) in rows.enumerated() {
            let y = h * 0.56 + CGFloat(r) * h * 0.18
            for (x, cw, c) in row { s.rect(w * x, y, w * cw - 1.5, h * 0.14, c, radius: 1.5) }
        }
        s.line(w * 0.5, h * 0.5, w * 0.5, h * 0.96, 0xC8261B, 1.6)
        // Scissors cutting the top clip
        let cx = w * 0.36, cy = h * 0.6
        s.ring(cx - 7, cy - 8, 3, 0xFFFFFF, 1.4)
        s.ring(cx - 7, cy + 8, 3, 0xFFFFFF, 1.4)
        s.svgLine("M\(cx - 4.5) \(cy - 6.5)L\(cx + 8) \(cy + 3)M\(cx - 4.5) \(cy + 6.5)L\(cx + 8) \(cy - 3)", 0xFFFFFF, 1.6)
    }
}
