import SwiftUI

/// Tax-office props: the yearly form with a calculator, a little house bank that the government
/// tops up, an envelope with money coming back, and a big amount before tax next to a small one.
enum G2TaxProps {
    // MARK: Tax return

    /// A long form (100 × 84) headed with the year (`text`), rows of boxes filled in, a calculator
    /// and a yellow sticky note with the deadline (`caption`, "vóór 1 mei": first word small).
    static func taxReturn(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 84))
        let tone = PropColor.named(p.tone, 0x1F3A6B)
        f.rect(5.5, 10, 62, 74, 0x1E1E1C, radius: 1.5, 0.15)
        f.rect(4, 8, 62, 74, 0xFFFDF6, radius: 1.5)
        f.rect(4, 8, 62, 15, tone, radius: 1.5)
        f.text(p.text ?? "", PropFont.heavy(11), 0xFFFDF6, at: CGPoint(x: 8, y: 15.5), anchor: .leading, maxWidth: 34)
        for r in 0..<5 {
            let y = 28 + CGFloat(r) * 10
            f.line(8, y + 3.5, 24, y + 3.5, 0xB4B2A9, 1.6)
            f.rect(28, y, 34, 8, 0xFFFFFF, radius: 1)
            f.stroke(Path(roundedRect: CGRect(x: 28, y: y, width: 34, height: 8), cornerRadius: 1), 0x8C9499, 0.9)
            if r < 4 {
                f.svgLine("M\(31) \(y + 4.5)q1.6 -2 3.2 0t3.2 0t3.2 0\(r % 2 == 0 ? "t3.2 0t3.2 0" : "")", 0x2F5BD3, 1)
            }
        }
        // Calculator
        f.rect(70, 38, 28, 44, 0x1E1E1C, radius: 3.5, 0.18)
        f.rect(68, 36, 28, 44, 0x3E4C55, radius: 3.5)
        f.rect(71, 40, 22, 9, 0xC9E6E2, radius: 1)
        f.svgLine("M78 44.5H91", 0x1E1E1C, 2)
        for r in 0..<4 {
            for c in 0..<3 {
                let key: UInt32 = r == 3 && c == 2 ? 0xF2711C : 0xD3D1C7
                f.rect(71.5 + CGFloat(c) * 7.4, 52.5 + CGFloat(r) * 6.6, 5.6, 4.6, key, radius: 1)
            }
        }
        // Sticky note with the deadline
        guard let caption = p.caption else { return }
        var s = f
        s.ctx.translateBy(x: 76, y: 16)
        s.ctx.rotate(by: .degrees(6))
        s.rect(-21, -14.5, 44, 31, 0x1E1E1C, radius: 1, 0.12)
        s.rect(-22, -16, 44, 31, 0xFAC775, radius: 1)
        s.dot(0, -13.5, 2, 0xC8261B)
        let parts = caption.split(separator: " ", maxSplits: 1).map(String.init)
        s.text(parts[0], PropFont.demi(8), 0x412402, at: CGPoint(x: 0, y: -5), maxWidth: 40)
        if parts.count > 1 {
            s.text(parts[1], PropFont.heavy(11), 0xC8261B, at: CGPoint(x: 0, y: 6), maxWidth: 40)
        }
    }

    // MARK: Top-up

    /// A little house-shaped money box (84 × 90) with a tag (`text`) on its front; a hand in an
    /// official navy sleeve (a town-hall badge on the cuff) drops a green coin with a plus into the
    /// slot in its roof.
    static func topUp(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 90))
        f.oval(8, 84, 64, 6, 0x1E1E1C, 0.15)
        f.rect(14, 50, 52, 37, 0xE9DFC9)
        f.rect(14, 50, 52, 4, 0x1E1E1C, 0.08)
        f.svg("M6 52L40 26L74 52Z", 0x9A5238)
        f.svgLine("M33 37.5L47 37.5", 0x2E2117, 3)
        f.rect(33, 66, 13, 21, 0x1F3A6B, radius: 1)
        f.dot(43.5, 77, 1.1, 0xC9A15B)
        f.rect(19, 58, 9, 9, 0xBCCDD6)
        f.rect(52, 58, 9, 9, 0xBCCDD6)
        if let text = p.text {
            f.svgLine("M57 70L61 64", 0x5F5E5A, 0.9)
            f.rect(50, 70, 22, 12, 0xFFFDF6, radius: 1.5)
            f.text(text, PropFont.heavy(7.5), 0x1E1E1C, at: CGPoint(x: 61, y: 76), maxWidth: 20)
        }
        // The green coin falling into the slot
        f.svgLine("M40 30V33M36 29L35 32M44 29L45 32", 0x1E7A4C, 1.2)
        f.dot(40, 18, 9.5, 0x1E7A4C)
        f.ring(40, 18, 7.2, 0x5DCAA5, 1.2)
        f.svgLine("M40 13.5V22.5M35.5 18H44.5", 0xFFFFFF, 2.6)
        // The hand that lets it go, coming from the top right
        f.svg("M84 0V18L70 16Q64 15 60 11Q56 8 58 5Q60 2 66 3L72 0Z", 0x1F3A6B)
        f.svg("M62 4Q55 2 51 6Q49 9 51.5 11L56 13Q60 14 63 12Z", 0xC99A74)
        f.svgLine("M52 7.5L48.5 9.5M53.5 10.5L50 13", 0xC99A74, 2.6)
        PalaceIcon.townHall.draw(f, in: CGRect(x: 72, y: 4, width: 10, height: 10), color: 0xFAC775, detail: 0x1F3A6B)
    }

    // MARK: Refund

    /// Money coming back (72 × 80): an envelope in the `tone` colour opened, three banknotes
    /// springing out, a green arrow turning back and a green tag (`text`).
    static func refund(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 72, height: 80))
        let tone = PropColor.named(p.tone, 0x1F3A6B)
        f.oval(4, 75, 60, 5, 0x1E1E1C, 0.15)
        f.svg("M6 48L34 34L62 48Z", PalaceInk.shade(tone, 0.72))
        for (dx, angle) in [(-14.0, -0.35), (0.0, 0.0), (14.0, 0.35)] as [(CGFloat, Double)] {
            var n = f
            n.ctx.translateBy(x: 34 + dx, y: 44)
            n.ctx.rotate(by: .radians(angle))
            PalaceIcon.banknote.draw(n, in: CGRect(x: -11, y: -24, width: 22, height: 22), color: 0x5E8C45, detail: 0xFFFDF6)
        }
        f.rect(6, 48, 56, 28, tone, radius: 2)
        f.svgLine("M7 49L34 64L61 49", PalaceInk.shade(tone, 0.72), 1.4)
        // An arrow turning back, from the envelope up and round to the left
        f.svgLine("M64 50Q72 30 60 22Q52 17 44 20", 0x1E7A4C, 3)
        f.svgLine("M49 14L43 20.5L50 25", 0x1E7A4C, 3)
        if let text = p.text {
            let font = PropFont.heavy(10)
            let w = min(60, f.width(of: text, font) + 10)
            f.rect(2, 2, w, 15, 0x1E7A4C, radius: 3.5)
            f.text(text, font, 0xFFFFFF, at: CGPoint(x: 2 + w / 2, y: 9.5), maxWidth: w - 4)
        }
    }

    // MARK: Gross

    /// A card (100 × 80): a big money bag with the first of `lines` under it, circled; an arrow
    /// with a red `caption` (what comes off) to a small bag with the second line, greyed.
    static func gross(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 80))
        let lines = p.lines ?? []
        f.rect(1.5, 3, 98, 77, 0x1E1E1C, radius: 4, 0.14)
        f.rect(0, 0, 98, 76, 0xFFFDF6, radius: 4)
        f.stroke(Path(roundedRect: CGRect(x: 4, y: 4, width: 50, height: 66), cornerRadius: 10), 0xF2711C, 2.6)
        bag(f, cx: 29, bottom: 48, size: 1, colour: 0xC9A15B)
        bag(f, cx: 82, bottom: 48, size: 0.62, colour: 0xD9CDB4)
        f.svgLine("M60 40H72M68 35.5L73 40L68 44.5", 0x8C9499, 2.4)
        if let caption = p.caption {
            f.text(caption, PropFont.heavy(9), 0xC8261B, at: CGPoint(x: 67, y: 29), maxWidth: 22)
        }
        if let big = lines.first {
            f.text(big, PropFont.heavy(12), 0x1E1E1C, at: CGPoint(x: 29, y: 59), maxWidth: 44)
        }
        if lines.count > 1 {
            f.text(lines[1], PropFont.demi(9), 0x8C9499, at: CGPoint(x: 82, y: 59), maxWidth: 30)
        }
    }

    /// A money bag standing on `bottom`, tied at the neck, with a euro sign.
    private static func bag(_ f: PropPen, cx: CGFloat, bottom: CGFloat, size s: CGFloat, colour: UInt32) {
        let w = 34 * s, h = 36 * s
        f.svg("M\(cx - w * 0.22) \(bottom - h)L\(cx - w * 0.32) \(bottom - h - 7 * s)H\(cx + w * 0.32)L\(cx + w * 0.22) \(bottom - h)Z", colour)
        f.svg("M\(cx - w * 0.2) \(bottom - h)Q\(cx - w * 0.6) \(bottom - h * 0.55) \(cx - w * 0.5) \(bottom - 4 * s)Q\(cx - w * 0.45) \(bottom) \(cx) \(bottom)Q\(cx + w * 0.45) \(bottom) \(cx + w * 0.5) \(bottom - 4 * s)Q\(cx + w * 0.6) \(bottom - h * 0.55) \(cx + w * 0.2) \(bottom - h)Z", colour)
        f.svgLine("M\(cx - w * 0.24) \(bottom - h + 1)H\(cx + w * 0.24)", PalaceInk.shade(colour, 0.6), 2.2 * s)
        PalaceIcon.euro.draw(f, in: CGRect(x: cx - 8 * s, y: bottom - h * 0.62, width: 16 * s, height: 16 * s),
                             color: PalaceInk.shade(colour, 0.55), detail: colour)
    }
}
