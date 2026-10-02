import SwiftUI

/// Notary props: a sealed scroll, an official deed, a hand signing with a fountain pen, the law
/// book with the scales, and spoken agreements going down onto paper.
enum G2NotaryProps {
    static let parchment: UInt32 = 0xF1E2C4

    // MARK: Scroll

    /// A parchment scroll (76 × 90) rolled at top and bottom: `text` as its heading in brown ink,
    /// lines of writing, a red wax seal with ribbons and a quill.
    static func scroll(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 90))
        f.rect(10, 12, 54, 66, 0x1E1E1C, radius: 1, 0.15)
        f.rect(8, 10, 54, 66, parchment)
        for y in [6.0, 74] as [CGFloat] {
            f.rect(4, y, 62, 9, 0xD9C29A, radius: 4.5)
            f.rect(4, y + 5.5, 62, 3.5, 0xB89B6B, radius: 1.7)
            f.dot(4, y + 4.5, 4.5, 0xB89B6B)
            f.dot(66, y + 4.5, 4.5, 0xB89B6B)
        }
        if let text = p.text {
            let words = text.split(separator: " ")
            let half = (words.count + 1) / 2
            let lines = [words.prefix(half).joined(separator: " "), words.dropFirst(half).joined(separator: " ")]
            for (i, line) in lines.enumerated() where !line.isEmpty {
                f.text(line, PropFont.heavy(9.5), 0x5A3E26, at: CGPoint(x: 35, y: 23 + CGFloat(i) * 11), maxWidth: 48)
            }
        }
        for k in 0..<4 {
            let y = 44 + CGFloat(k) * 5
            f.svgLine("M13 \(y)q2 -1.8 4 0t4 0t4 0t4 0t4 0t4 0\(k == 3 ? "" : "t4 0t4 0t4 0t4 0")", 0x7A5230, 0.9)
        }
        f.svgLine("M46 64L42 80M52 64L56 80", 0xC8261B, 3)
        f.dot(49, 63, 8, 0xA3201A)
        f.dot(49, 63, 5.5, 0xC8261B)
        f.svgLine("M46 61L52 65M52 61L46 65", 0xA3201A, 1.2)
        // Quill
        f.svg("M60 54Q66 30 76 12Q72 34 62 56Z", 0xFFFDF6)
        f.svgLine("M62 56L76 12", 0xB4B2A9, 0.9)
        f.svgLine("M60 54L57 62", 0x2E2117, 1.4)
    }

    // MARK: Deed

    /// An official paper (80 × 90) with a double border: the first of `icons` big at the top,
    /// lines, two signatures with `labels` under them; `accessory` "seal" adds a gold-and-red seal
    /// with ribbons and a round stamp.
    static func deed(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 80, height: 90))
        let tone = PropColor.named(p.tone, 0x1F3A6B)
        f.rect(6, 4, 70, 84, 0x1E1E1C, radius: 1, 0.15)
        f.rect(4, 2, 70, 84, 0xFFFDF6, radius: 1)
        f.stroke(Path(CGRect(x: 7, y: 5, width: 64, height: 78)), tone, 1.2)
        f.stroke(Path(CGRect(x: 9.5, y: 7.5, width: 59, height: 73)), tone, 0.6)
        if let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first {
            icon.draw(f, in: CGRect(x: 25, y: 11, width: 28, height: 28), color: tone, detail: 0xFFFDF6)
        }
        for k in 0..<3 {
            let y = 45 + CGFloat(k) * 5
            f.line(14, y, k == 2 ? 46 : 64, y, 0xD3D1C7, 1.3)
        }
        let labels = p.labels ?? []
        for (i, x) in ([13, 42] as [CGFloat]).enumerated() {
            let ink: UInt32 = i == 0 ? 0x2F5BD3 : 0xC8261B
            f.svgLine("M\(x + 1) 69C\(x + 4) 62 \(x + 6) 72 \(x + 9) 66C\(x + 11) 63 \(x + 12) 70 \(x + 22) 67", ink, 1.3)
            f.line(x, 72, x + 23, 72, 0x5F5E5A, 0.8)
            if i < labels.count {
                f.text(labels[i], PropFont.demi(6.5), 0x5F5E5A, at: CGPoint(x: x + 11.5, y: 77.5), maxWidth: 25)
            }
        }
        guard p.accessory == "seal" else { return }
        f.svgLine("M62 22L57 38M68 22L73 38", 0xC8261B, 3.4)
        f.dot(65, 18, 10, 0xC9A15B)
        for k in 0..<12 {
            let a = Double(k) * .pi / 6
            f.dot(65 + CGFloat(cos(a)) * 10, 18 + CGFloat(sin(a)) * 10, 2.2, 0xC9A15B)
        }
        f.ring(65, 18, 6.5, 0xA37E3B, 1.2)
        f.ring(60, 50, 7.5, tone, 1.2)
        f.ring(60, 50, 5, tone, 0.6)
    }

    // MARK: Signing

    /// A hand (70 × 80) with a fountain pen writing a signature on the line of a paper.
    static func signing(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 70, height: 80))
        f.svg("M4 40L58 30L66 76L12 80Z", 0x1E1E1C, 0.15)
        f.svg("M2 38L56 28L64 74L10 78Z", 0xFFFDF6)
        f.svgLine("M8 44L50 36.5M9 49L44 43", 0xD3D1C7, 1.3)
        f.svgLine("M12 66L58 58", 0x5F5E5A, 1)
        f.text("×", PropFont.heavy(8), 0x5F5E5A, at: CGPoint(x: 13, y: 61))
        f.svgLine("M18 64C21 54 24 66 27 58C29 53 31 63 34 58C36 55 37 61 40 58", 0x1F3A6B, 1.6)
        // Fountain pen held by the hand
        f.svg("M40 58L43 49L47 51Z", 0xC9A15B)
        f.svg("M43 49L58 16L64 19L47 51Z", 0x1E1E1C)
        f.rect(55, 22, 8, 3, 0xC9A15B)
        f.svg("M46 40Q44 30 52 26Q60 23 66 30L70 34V48L60 50Q50 50 46 40Z", 0xC99A74)
        f.svgLine("M48 40Q46 34 50 31M51 44Q48 38 52 34", PalaceInk.shade(0xC99A74, 0.82), 1)
        f.svg("M66 30L70 26V48L66 50Z", 0x1F3A6B)
    }

    // MARK: Law book

    /// A thick law book (84 × 84) standing on its cover with a gold § sign, and the scales of
    /// justice beside it.
    static func lawBook(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 84))
        let tone = PropColor.named(p.tone, 0x7A1E1E)
        f.oval(2, 78, 80, 6, 0x1E1E1C, 0.2)
        f.rect(6, 18, 44, 62, PalaceInk.shade(tone, 0.7), radius: 2)
        f.rect(4, 16, 42, 62, tone, radius: 2)
        f.rect(42, 18, 6, 58, 0xF1E2C4)
        f.svgLine("M43 22V74M45 22V74", 0xD9C29A, 0.7)
        f.rect(8, 24, 34, 3, 0xC9A15B)
        f.rect(8, 68, 34, 3, 0xC9A15B)
        f.text("§", PropFont.heavy(30), 0xC9A15B, at: CGPoint(x: 25, y: 47))
        PalaceIcon.g2Scales.draw(f, in: CGRect(x: 48, y: 30, width: 36, height: 50), color: 0xC9A15B, detail: 0x3A2A1C)
    }

    // MARK: Record

    /// A card (90 × 80): two speech bubbles (what two people agree) with arrows down onto a paper
    /// that is being written and pinned fast with a red pin.
    static func record(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 90, height: 80))
        f.rect(1.5, 3, 88, 77, 0x1E1E1C, radius: 4, 0.14)
        f.rect(0, 0, 88, 76, 0xE9DFC9, radius: 4)
        for (x, colour) in [(4.0, 0xFFFDF6), (48, 0xC9E6E2)] as [(CGFloat, UInt32)] {
            f.rect(x, 4, 36, 20, colour, radius: 6)
            f.svg(x < 20 ? "M\(x + 8) 23L\(x + 4) 30L\(x + 15) 23Z" : "M\(x + 28) 23L\(x + 32) 30L\(x + 21) 23Z", colour)
            for k in 0..<3 { f.dot(x + 11 + CGFloat(k) * 7, 14, 2.2, 0x5F5E5A) }
        }
        f.svgLine("M26 30L36 40M62 30L52 40", 0xF2711C, 2)
        f.svgLine("M31 41L37 41L36 35M57 41L51 41L52 35", 0xF2711C, 2)
        let paper = CGRect(x: 26, y: 42, width: 36, height: 30)
        f.rect(paper.offsetBy(dx: 1, dy: 1.5), 0x1E1E1C, radius: 1, 0.15)
        f.rect(paper, 0xFFFDF6, radius: 1)
        f.svgLine("M30 50q2 -2 4 0t4 0t4 0t4 0t4 0t4 0M30 56q2 -2 4 0t4 0t4 0t4 0t4 0M30 62q2 -2 4 0t4 0t4 0", 0x1F3A6B, 1)
        f.dot(44, 43, 3.4, 0xC8261B)
        f.dot(43, 42, 1, 0xFFFFFF, 0.7)
        f.svgLine("M52 66L60 52", 0x1E1E1C, 2.4)
        f.svgLine("M52 66L53.5 63.5", 0xC9A15B, 1.6)
    }
}
