import SwiftUI

/// Temp-agency desk things: a laptop sending a résumé to a company, a welcome card with a
/// handshake, and a puzzle piece that fits.
enum G1JobsDesk {
    // MARK: Applying

    /// A laptop (104 × 74): on its screen a letter with a résumé (a photo and lines) clipped to it
    /// and a send arrow; a paper plane flies along a dotted line to a company building.
    static func apply(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 104, height: 74))
        f.svg("M6 66H76L82 72H0Z", 0x8C9499)
        f.rect(10, 22, 62, 44, 0x3E4C55, radius: 3)
        f.rect(13, 25, 56, 38, 0xFFFDF6, radius: 1)
        f.rect(13, 25, 56, 7, 0x2F5BD3, radius: 1)
        f.svgLine("M17 37H40M17 41H36", 0xB4B2A9, 1.2)
        f.rect(17, 45, 18, 15, 0xF4F1EA, radius: 1)
        f.stroke(Path(roundedRect: CGRect(x: 17, y: 45, width: 18, height: 15), cornerRadius: 1), 0xB4B2A9, 0.8)
        f.rect(19, 47, 5, 6, 0x8C9499)
        f.svgLine("M26 48H33M26 51H31M19 56H33", 0xB4B2A9, 1)
        f.rect(46, 50, 18, 9, 0x1E7A4C, radius: 2)
        f.svg("M51 51.5L60 54.5L51 57.5L52.5 54.5Z", 0xFFFDF6)
        // On its way to the company
        var dots = ""
        for k in 0..<5 { dots += String(format: "M%.1f %.1fa1.1 1.1 0 1 0 0.01 0Z", 66 + Double(k) * 4, 44 - Double(k) * 5.5) }
        f.svg(dots, 0x2F5BD3)
        f.svg("M74 18L92 10L84 24L82 19Z", 0xFFFDF6)
        f.svgLine("M74 18L92 10L84 24L82 19Z", 0x2F5BD3, 1)
        PalaceIcon.company.draw(f, in: CGRect(x: 82, y: 0, width: 22, height: 22), color: 0x5E6B73, detail: 0xFFFDF6)
    }

    // MARK: Welcome card

    /// A card standing on the desk (104 × 76): a big handshake, `text` ("Welkom!") and confetti.
    static func welcome(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 104, height: 76))
        f.oval(10, 70, 84, 6, 0x1E1E1C, 0.15)
        f.svg("M16 72L22 6H86L92 72Z", 0xD3D1C7)
        f.rect(18, 4, 68, 68, 0xFFFDF6, radius: 2)
        f.stroke(Path(roundedRect: CGRect(x: 21, y: 7, width: 62, height: 62), cornerRadius: 1.5), 0x1E7A4C, 1.4)
        // Two arms from either side, the hands clasped in the middle
        f.svgLine("M26 46L42 30", 0x2F5BD3, 9)
        f.svgLine("M78 46L62 30", 0xF2711C, 9)
        f.rect(24, 42, 8, 6, 0xFFFDF6, radius: 1)
        f.rect(36, 22, 20, 13, 0xE8C4A0, radius: 6)
        f.rect(47, 21, 21, 14, 0xA87B4F, radius: 6)
        f.svgLine("M44 23.5V30M48 23V29.5M52 23.5V30", 0xE8C4A0, 2.2)
        f.svgLine("M48 23.5H54", 0x8C5A3C, 1)
        f.svgLine("M36 14L33 9M52 11V5M68 14L71 9", 0xFAC775, 2)
        f.text(p.text ?? "Welkom!", PropFont.heavy(12), 0xC8261B, at: CGPoint(x: 52, y: 58), maxWidth: 58)
        let bits: [(CGFloat, CGFloat, UInt32)] = [(8, 12, 0xF2711C), (96, 16, 0x2F5BD3), (6, 40, 0xFAC775), (98, 44, 0xC8261B),
                                                  (12, 60, 0x1E7A4C), (94, 64, 0xF2711C), (30, 2, 0xC8261B), (76, 1, 0xFAC775)]
        for (i, (x, y, c)) in bits.enumerated() {
            if i % 2 == 0 { f.rect(x - 2, y - 3, 4, 6, c, radius: 1) } else { f.dot(x, y, 2.4, c) }
        }
    }

    // MARK: Puzzle

    /// A puzzle (60 × 84): a frame with one gap, the last piece sliding in exactly, a green tick.
    static func puzzle(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 60, height: 84))
        f.rect(2, 26, 56, 56, 0x1E1E1C, radius: 3, 0.15)
        f.rect(0, 24, 56, 56, 0x2F5BD3, radius: 3)
        f.svgLine("M28 24V80M0 52H56", 0x21468B, 1.4)
        let gap = piece(x: 28, y: 52)
        f.fill(gap, 0xFFFDF6)
        f.stroke(gap, 0x21468B, 1)
        var moving = f
        moving.ctx.translateBy(x: 6, y: -24)
        moving.fill(piece(x: 28, y: 52), 0xFAC775)
        moving.stroke(piece(x: 28, y: 52), 0xE0A93A, 1.2)
        f.svgLine("M44 14V22M48 18L44 23L40 18", 0x1E7A4C, 2)
        G1Props.tick(f, 50, 6, 6)
    }

    /// One square piece (28 × 28) at (x, y) with a knob on top and on the left.
    private static func piece(x: CGFloat, y: CGFloat) -> Path {
        PalaceSVG.path("M\(x) \(y)H\(x + 10)A4 4 0 1 1 \(x + 18) \(y)H\(x + 28)V\(y + 28)H\(x)V\(y + 18)A4 4 0 1 1 \(x) \(y + 10)Z")
    }
}
