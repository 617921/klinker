import SwiftUI

/// Things at the GP: a fever card with a thermometer, a letter (from a printer, with pills, in an
/// envelope or pinned), a hand writing on a pad, and the examination couch.
enum PalaceDoctorProps {
    // MARK: Fever card

    /// A wall card (100 × 76): a thermometer with its red column high up, the reading `text`
    /// ("39,5°") in red and a hot, flushed face.
    static func thermometer(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 76))
        f.rect(2, 3, 98, 73, 0x1E1E1C, radius: 4, 0.14)
        f.rect(0, 0, 98, 73, 0xFFFDF6, radius: 4)
        f.stroke(Path(roundedRect: CGRect(x: 2.5, y: 2.5, width: 93, height: 68), cornerRadius: 3), 0xC8261B, 1.4)
        // The thermometer
        f.rect(17, 7, 13, 52, 0xFFFFFF, radius: 6.5)
        f.stroke(Path(roundedRect: CGRect(x: 17, y: 7, width: 13, height: 52), cornerRadius: 6.5), 0x5E6B73, 1.4)
        f.rect(20.5, 14, 6, 46, 0xC8261B, radius: 3)
        f.dot(23.5, 61, 8, 0xC8261B)
        f.dot(21, 58.5, 2, 0xFFFFFF, 0.5)
        for k in 0..<6 {
            let y = 18 + CGFloat(k) * 7
            f.line(31, y, k % 2 == 0 ? 36 : 34, y, 0x5E6B73, 1)
        }
        f.text("40", PropFont.mono(7), 0x5E6B73, at: CGPoint(x: 42, y: 18))
        f.text("37", PropFont.mono(7), 0x5E6B73, at: CGPoint(x: 42, y: 46))
        f.svgLine("M8 16Q5 20 8 24Q11 28 8 32M10 38Q7 42 10 46", 0xF2711C, 1.6)
        if let reading = p.text {
            f.rect(50, 8, 42, 20, 0xC8261B, radius: 3)
            f.text(reading, PropFont.heavy(13), 0xFFFDF6, at: CGPoint(x: 71, y: 18.5), maxWidth: 38)
        }
        // A hot face
        let c = CGPoint(x: 71, y: 50)
        f.dot(c.x, c.y, 14, 0xE8C4A0)
        f.dot(c.x - 7, c.y + 4, 3.6, 0xE06A5A, 0.65)
        f.dot(c.x + 7, c.y + 4, 3.6, 0xE06A5A, 0.65)
        f.svgLine("M\(c.x - 7) \(c.y - 2)Q\(c.x - 4.5) \(c.y + 0.5) \(c.x - 2) \(c.y - 2)M\(c.x + 2) \(c.y - 2)Q\(c.x + 4.5) \(c.y + 0.5) \(c.x + 7) \(c.y - 2)", 0x2E2117, 1.3)
        f.svgLine("M\(c.x - 3) \(c.y + 7)Q\(c.x) \(c.y + 5) \(c.x + 3) \(c.y + 7)", 0x8C5A3C, 1.3)
        f.svg("M\(c.x + 11) \(c.y - 12)Q\(c.x + 14) \(c.y - 6.5) \(c.x + 11) \(c.y - 4.5)Q\(c.x + 8) \(c.y - 6.5) \(c.x + 11) \(c.y - 12)Z", 0xA9CBE0)
        f.svg("M\(c.x - 12) \(c.y - 6)C\(c.x - 12) \(c.y - 14) \(c.x - 6) \(c.y - 15) \(c.x) \(c.y - 15)C\(c.x + 6) \(c.y - 15) \(c.x + 12) \(c.y - 14) \(c.x + 12) \(c.y - 6)C\(c.x + 8) \(c.y - 10) \(c.x - 8) \(c.y - 10) \(c.x - 12) \(c.y - 6)Z", 0x4A3524)
    }

    // MARK: Letter

    /// A letter (72 × 84): a coloured header (`tone`) with `caption`, a row of `icons`, text lines,
    /// a signature. `accessory` "printer" (coming out of a printer), "pills" (a pill box beside it),
    /// "envelope" (half out of an envelope), otherwise pinned to the wall.
    static func letter(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 72, height: 84))
        let tone = PropColor.named(p.tone, 0x1F3A6B)
        let paper: CGRect
        switch p.accessory {
        case "printer":
            paper = CGRect(x: 11, y: 2, width: 50, height: 62)
        case "pills":
            paper = CGRect(x: 2, y: 14, width: 50, height: 66)
        case "envelope":
            paper = CGRect(x: 12, y: 2, width: 48, height: 60)
        default:
            paper = CGRect(x: 10, y: 6, width: 52, height: 72)
        }
        if p.accessory == "envelope" {
            f.rect(5, 44, 62, 38, 0x1E1E1C, radius: 2, 0.14)
        } else {
            f.rect(paper.offsetBy(dx: 2, dy: 2), 0x1E1E1C, radius: 1, 0.14)
        }
        f.rect(paper, 0xFFFDF6, radius: 1)
        f.rect(paper.minX, paper.minY, paper.width, 8, tone, radius: 1)
        if let caption = p.caption {
            f.text(caption, PropFont.heavy(6.5), 0xFFFDF6, at: CGPoint(x: paper.midX, y: paper.minY + 4.2), maxWidth: paper.width - 6)
        }
        let icons = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:))
        let n = CGFloat(icons.count)
        let side: CGFloat = n >= 3 ? 13 : (n == 2 ? 15 : 20)
        var x = paper.midX - (side * n + 2 * (n - 1)) / 2
        for icon in icons {
            let colour: UInt32 = icon == .hospital ? 0xC8261B : (icon == .arrow ? 0x5E6B73 : tone)
            icon.draw(f, in: CGRect(x: x, y: paper.minY + 11, width: side, height: side), color: colour, detail: 0xFFFDF6)
            x += side + 2
        }
        let top = paper.minY + 13 + max(side, 13)
        for k in 0..<3 {
            let y = top + CGFloat(k) * 5
            f.line(paper.minX + 5, y, paper.maxX - (k == 2 ? 16 : 5), y, 0xD3D1C7, 1.4)
        }
        let sig = f.within(CGRect(x: paper.minX + 6, y: top + 13, width: 30, height: 8))
        sig.svgLine("M0 6C3 0 5 8 8 3C10 0 11 7 14 4C16 2 17 6 20 5", 0x2F5BD3, 1.2)
        f.ring(paper.maxX - 10, top + 17, 5.5, 0x1E7A4C, 1.2)
        switch p.accessory {
        case "printer":
            f.rect(0, 50, 72, 30, 0x5E6B73, radius: 4)
            f.rect(0, 50, 72, 6, 0x7D8A92, radius: 3)
            f.rect(8, 54, 56, 4, 0x2E2117, radius: 2)
            f.rect(paper.minX, 46, paper.width, 10, 0xFFFDF6)
            f.rect(52, 66, 12, 4, 0x3E4C55, radius: 1)
            f.dot(12, 68, 2, 0x5DCAA5)
            f.rect(4, 80, 64, 4, 0x2E2117, radius: 1)
        case "pills":
            f.rect(44, 46, 26, 36, 0x1E1E1C, radius: 2, 0.14)
            f.rect(42, 44, 26, 36, 0xFFFDF6, radius: 2)
            f.stroke(Path(roundedRect: CGRect(x: 42, y: 44, width: 26, height: 36), cornerRadius: 2), 0xB4B2A9, 1)
            f.rect(42, 52, 26, 8, 0x1E7A4C)
            PalaceIcon.pill.draw(f, in: CGRect(x: 47, y: 62, width: 16, height: 16), color: 0xC8261B, detail: 0xFFFDF6)
            f.svgLine("M46 48H60", 0xB4B2A9, 1.2)
        case "envelope":
            f.svg("M4 44H68V82H4Z", 0xE9DFC9)
            f.svg("M4 44L36 66L68 44", 0xD9CDB4)
            f.svgLine("M4 82L30 62M68 82L42 62", 0xD9CDB4, 1.2)
        default:
            f.dot(36, 7, 3.2, 0xC8261B)
            f.dot(35, 6, 1, 0xFFFFFF, 0.6)
        }
    }

    // MARK: Writing pad

    /// A hand writing on a pad (66 × 42): the pad shows the first of `icons` being written and
    /// lines of handwriting; the sleeve (`tone`, default a white coat) comes in from the right.
    static func writingPad(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 66, height: 42))
        let sleeve = PropColor.named(p.tone, 0xFFFDF6)
        f.svg("M7 12H45L50 38H2Z", 0x1E1E1C, 0.16)
        f.svg("M6 9H44L49 35H1Z", 0xFFFDF6)
        f.svg("M6 9H44L44.6 12.5H5.4Z", 0x0F6E56)
        f.svgLine("M6 19H41M5 24H42M4 29H33", 0xD3D1C7, 1)
        f.svgLine("M7 19q1.6 -2.2 3.2 0t3.2 0t3.2 0t3.2 0M6 24q1.6 -2.2 3.2 0t3.2 0t3.2 0", 0x2F5BD3, 1.1)
        if let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first {
            icon.draw(f, in: CGRect(x: 22, y: 20, width: 13, height: 13), color: 0x2F5BD3, detail: 0xFFFDF6)
        }
        f.svgLine("M34 31L36.5 26M38 33L40 28.5", 0x5E6B73, 1)
        f.line(33, 30, 46, 14, 0x1E1E1C, 2.6)
        f.line(33, 30, 35, 27.6, 0xC9A15B, 1.6)
        f.svg("M38 22C38 17.5 44 15 49 17.5L54 21C55 25 52 29 47 29.5C42 30 38 27 38 22Z", 0xC99A74)
        f.svgLine("M41 21.5Q43.5 19.5 46 20.5", PalaceInk.shade(0xC99A74, 0.82), 1)
        f.svg("M50 15L66 10V30L52 29Z", sleeve)
        f.svgLine("M50 15L66 10M52 29L66 30", 0xB4B2A9, 1)
        f.svgLine("M51 15.5L52.5 28.5", 0xB4B2A9, 1.2)
    }

    // MARK: Examination couch

    /// The examination couch (150 × 104): paper on it, a patient sitting with a cuff round the arm,
    /// a tube to a monitor showing `text` ("120/80"), and a lamp on an arm.
    static func examCouch(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 150, height: 104))
        let v = PalaceFigures.Look.at(p.variant ?? 6)
        f.oval(14, 97, 126, 7, 0x1E1E1C, 0.14)
        // Lamp on an arm
        f.svgLine("M146 100V8L118 2", 0x5E6B73, 2.2)
        f.svg("M108 0H128L124 9H112Z", 0x3E4C55)
        f.svg("M112 9H124L130 26H106Z", 0xFAC775, 0.25)
        f.rect(138, 96, 16, 4, 0x3E4C55, radius: 1)
        // Couch
        f.svgLine("M30 70V98M118 70V98", 0x5E6B73, 3)
        f.svgLine("M30 92H118", 0x5E6B73, 2)
        f.rect(22, 58, 108, 13, 0x5E7A68, radius: 4)
        f.svg("M104 58L128 44Q132 42 132 47V58Z", 0x5E7A68)
        f.rect(36, 55, 70, 4, 0xFFFDF6, radius: 1)
        f.rect(22, 68, 108, 3, 0x3F5A4A, radius: 1)
        // Monitor with the reading
        f.rect(0, 22, 30, 24, 0x2E2117, radius: 3)
        f.rect(3, 25, 24, 13, 0x232B3B, radius: 1)
        if let reading = p.text {
            f.text(reading, PropFont.mono(8), 0x5DCAA5, at: CGPoint(x: 15, y: 31.8), maxWidth: 22)
        }
        f.dot(8, 42, 1.6, 0xC8261B)
        f.dot(14, 42, 1.6, 0x5DCAA5)
        f.svgLine("M15 46V58", 0x3E4C55, 2)
        f.rect(8, 56, 14, 4, 0x3E4C55, radius: 1)
        // Patient on the couch
        f.svgLine("M64 70V92M70 70V92", v.trousers, 5.5)
        f.svg("M60 91H68V95H60Z M66 91H74V95H66Z", 0x2E2117)
        f.svg("M48 64H68Q72 64 72 68V72H48Z", v.trousers)
        f.svg("M46 60L47 34C48 27 52 24 58 24C64 24 68 27 69 34L70 60Z", v.coat)
        f.svg("M53 24L58 30L63 24Z", 0xEFEBE2)
        f.dot(58, 12, 10, v.skin)
        f.svg("M48 11C47 4 52 1 58 1C64 1 69 4 68 11C66 7 62 6 58 6C54 6 50 7 48 11Z", v.hair)
        f.dot(63, 12.5, 1.2, 0x2E2117)
        f.svgLine("M52 34L42 46L30 40", v.skin, 5.5)
        f.svgLine("M52 34L47.5 39.5", v.coat, 6.5)
        f.rect(39, 39, 9, 9, 0x2F5BD3, radius: 2)
        f.svgLine("M42 48Q34 56 22 46", 0x3E4C55, 1.6)
        f.svgLine("M66 34C70 44 72 52 70 58", PalaceInk.shade(v.coat, 0.86), 5.5)
    }
}
