import SwiftUI

/// News on screens and in the air: a phone with a silly made-up headline, a transmitter mast
/// sending to a TV and a radio, a news reader on TV, one phone spreading a message to many,
/// and a "just in" ticker.
enum G6Screens {
    // MARK: Hoax

    /// A phone (84 × 58) showing an absurd headline (`text`) over a moon made of cheese; a long
    /// wooden nose grows from the phone and a red question mark stamps it.
    static func hoax(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 58))
        f.rect(16, 0, 38, 58, 0x1E1E1C, radius: 6)
        f.rect(19, 5, 32, 48, 0xFFFDF6, radius: 1.5)
        if let text = p.text {
            f.text(text, PropFont.heavy(6.5), 0x1E1E1C, at: CGPoint(x: 35, y: 11), maxWidth: 30)
        }
        f.rect(21, 16, 28, 24, 0x232B3B)
        f.dot(35, 28, 9, 0xF6D27A)
        for (x, y, r) in [(31.0, 25.0, 2.2), (38, 31, 2.6), (37, 23, 1.4), (31, 32, 1.2)] as [(CGFloat, CGFloat, CGFloat)] {
            f.dot(x, y, r, 0xE0B04A)
        }
        f.dot(25, 20, 0.8, 0xFFFDF6)
        f.dot(45, 36, 0.8, 0xFFFDF6)
        f.line(22, 44, 48, 44, 0xB4B2A9, 1.2)
        f.line(22, 47.5, 43, 47.5, 0xB4B2A9, 1.2)
        // long nose
        f.svg("M54 30L80 26L80 29L54 36Z", 0xC99A74)
        f.dot(80, 27.5, 2, 0xB98B5E)
        // red question mark stamp
        f.dot(10, 16, 10, 0xC8261B)
        f.text("?", PropFont.heavy(15), 0xFFFFFF, at: CGPoint(x: 10, y: 16.5))
    }

    // MARK: Broadcast

    /// A lattice mast (76 × 50) with a red light, waves going out to a television and a radio.
    static func broadcast(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        f.svgLine("M6 50L14 6L22 50M8 40H20M10 28H18M12 16H16M8 40L18 28M20 40L10 28M10 28L16 16M18 28L12 16", 0xC8261B, 1.4)
        f.svgLine("M14 6V1", 0x5E6B73, 1.2)
        f.dot(14, 1.5, 2, 0xC8261B)
        for r in [8.0, 14, 20] as [CGFloat] {
            var arc = Path()
            arc.addArc(center: CGPoint(x: 16, y: 8), radius: r, startAngle: .degrees(-35), endAngle: .degrees(35), clockwise: false)
            f.stroke(arc, 0x2F5BD3, 1.6)
        }
        // television
        f.rect(38, 12, 34, 24, 0x3E4C55, radius: 3)
        f.rect(41, 15, 28, 18, 0x6FA3C7, radius: 1)
        f.dot(55, 21, 3, 0xF1D3B8)
        f.rect(50, 25, 10, 8, 0x1F3A6B, radius: 2)
        f.svgLine("M48 12L44 4M62 12L66 4", 0x3E4C55, 1)
        f.rect(48, 36, 14, 2, 0x3E4C55)
        // radio
        f.rect(36, 40, 30, 10, 0xC9A15B, radius: 2.5)
        f.dot(43, 45, 3.4, 0x7A5230)
        f.svgLine("M50 43H62M50 46H62", 0x7A5230, 1)
        f.svgLine("M64 40L70 32", 0x5E6B73, 1)
    }

    // MARK: News on TV

    /// A television (76 × 50): a news reader at a desk talks; an inset shows what happened
    /// (`icons` first); a red tag with `caption`.
    static func newsTV(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        f.rect(6, 44, 64, 4, 0x3E4C55, radius: 1)
        f.rect(2, 0, 72, 46, 0x2E2117, radius: 4)
        f.rect(5, 3, 66, 40, 0x1F3A6B, radius: 1.5)
        f.rect(5, 3, 66, 18, 0x2B4C86)
        // reader
        f.svg("M12 43V36C12 31 16 29 22 29C28 29 32 31 32 36V43Z", 0xC8261B)
        f.dot(22, 22, 6.5, 0xC99A74)
        f.svg("M15.5 21C15 15 18 13.5 22 13.5C26 13.5 29 15 28.5 21C27 18 25 17 22 17C19 17 17 18 15.5 21Z", 0x2E2117)
        f.svgLine("M24 25.5Q26 26.5 27.5 25", 0x7A2A20, 1)
        f.rect(5, 37, 66, 6, 0xEFEBE2)
        // speech lines toward the inset
        f.svgLine("M33 18Q35 16 33 14M36 20Q39 16 36 12", 0xFFFDF6, 1)
        // inset
        f.rect(40, 7, 28, 22, 0xFFFDF6, radius: 1)
        if let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first {
            icon.draw(f, in: CGRect(x: 45, y: 8, width: 18, height: 18), color: 0xC8261B, detail: 0xFFFDF6)
        }
        if let caption = p.caption {
            f.rect(7, 30, 22, 7, 0xC8261B, radius: 1)
            f.text(caption, PropFont.heavy(5.5), 0xFFFFFF, at: CGPoint(x: 18, y: 33.6), maxWidth: 20)
        }
    }

    // MARK: Spread

    /// One phone in the middle (84 × 58) sends its message along arrows to five phones around it.
    static func spread(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 58))
        let centre = CGPoint(x: 42, y: 30)
        let around: [CGPoint] = [CGPoint(x: 10, y: 10), CGPoint(x: 74, y: 10), CGPoint(x: 8, y: 46), CGPoint(x: 76, y: 46), CGPoint(x: 42, y: 4)]
        for q in around {
            let dx = q.x - centre.x, dy = q.y - centre.y
            let len = sqrt(dx * dx + dy * dy)
            let a = CGPoint(x: centre.x + dx / len * 12, y: centre.y + dy / len * 12)
            let b = CGPoint(x: q.x - dx / len * 9, y: q.y - dy / len * 9)
            G6Props.arrow(f, a, b, 0xF2711C, 1.6)
        }
        for q in around { phone(f, q, scale: 0.55, bubble: true) }
        phone(f, centre, scale: 1, bubble: true)
    }

    private static func phone(_ f: PropPen, _ c: CGPoint, scale s: CGFloat, bubble: Bool) {
        f.rect(c.x - 7 * s, c.y - 12 * s, 14 * s, 24 * s, 0x1E1E1C, radius: 2.5 * s)
        f.rect(c.x - 5.5 * s, c.y - 9.5 * s, 11 * s, 18 * s, 0xFFFDF6, radius: 1)
        if bubble {
            f.rect(c.x - 4 * s, c.y - 6 * s, 8 * s, 5 * s, 0x5DCAA5, radius: 1.5 * s)
            f.rect(c.x - 4 * s, c.y + 1 * s, 6 * s, 1.5 * s, 0xB4B2A9)
        }
        f.dot(c.x + 6 * s, c.y - 11 * s, 3 * s, 0xC8261B)
    }

    // MARK: Ticker

    /// A dark screen (76 × 50): a red live dot and `caption` on top, then rows `lines`
    /// "10:42|headline" with the newest first.
    static func ticker(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        f.rect(0, 0, 76, 50, 0x2E2117, radius: 3)
        f.rect(3, 3, 70, 44, 0x232B3B, radius: 1.5)
        f.dot(10, 10, 3, 0xC8261B)
        f.dot(10, 10, 5, 0xC8261B, 0.3)
        if let caption = p.caption {
            f.text(caption, PropFont.heavy(8), 0xFAC775, at: CGPoint(x: 17, y: 10.5), anchor: .leading, maxWidth: 54)
        }
        for (i, line) in (p.lines ?? []).prefix(3).enumerated() {
            let y = 21 + CGFloat(i) * 9.5
            let cells = line.split(separator: "|", omittingEmptySubsequences: false).map(String.init)
            if i == 0 { f.rect(4, y - 4.5, 68, 9, 0x2B4C86, radius: 1) }
            f.text(cells[0], PropFont.mono(6.5), 0xFAC775, at: CGPoint(x: 6, y: y), anchor: .leading)
            if cells.count > 1 {
                f.text(cells[1], PropFont.condensed(7), 0xF4F1EA, at: CGPoint(x: 26, y: y), anchor: .leading, maxWidth: 45)
            }
        }
    }
}

