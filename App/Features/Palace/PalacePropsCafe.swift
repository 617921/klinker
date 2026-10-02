import SwiftUI

/// Café things that mean their word: the terrace through the window, a tip jar, a 0,0 bottle,
/// a drink with a straw, a gramophone under warm lights, the card terminal with the bill.
enum PalaceCafeProps {
    // MARK: Terrace

    /// A café window (104 × 176): amber leaded panes on top, below them a sunny terrace with
    /// parasols, little tables and a guest, the houses across the street behind.
    static func terraceView(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 104, height: 176))
        f.rect(0, 0, 104, 176, 0x2F4B3A, radius: 2)
        let glass = CGRect(x: 5, y: 44, width: 94, height: 127)
        var g = f
        g.ctx.clip(to: Path(glass))
        g.rect(glass, 0xBCDCEB)
        g.dot(80, 58, 8, 0xFAC775)
        for k in 0..<8 {
            let a = Double(k) * .pi / 4
            g.line(80 + cos(a) * 10.5, 58 + sin(a) * 10.5, 80 + cos(a) * 14, 58 + sin(a) * 14, 0xFAC775, 1.6)
        }
        g.svg("M0 108V70L10 62L20 70V108Z", 0x9A5238)
        g.svg("M20 108V76H44V108Z", 0xD9CDB4)
        g.svg("M44 108V66L54 58L64 66V108Z", 0x5E6B73)
        for (x, y) in [(6.0, 76.0), (12, 76), (6, 90), (12, 90), (25, 82), (35, 82), (25, 94), (35, 94), (50, 72), (57, 72), (50, 86), (57, 86)] as [(CGFloat, CGFloat)] {
            g.rect(x, y, 4, 6, 0xFFFDF6, radius: 0.5)
        }
        g.rect(5, 106, 94, 65, 0xE2DED3)
        g.svgLine("M5 124H99M5 146H99M30 106V124M70 106V124M18 124V146M52 124V146M86 124V146", 0xCFCABD, 1)
        parasol(g, x: 30, top: 70, width: 46, colour: 0xC8261B)
        parasol(g, x: 78, top: 80, width: 38, colour: 0x0F6E56)
        // A guest at the first table with a drink
        g.svg("M14 140C14 128 18 124 23 124C28 124 31 128 31 140Z", 0x2F5BD3)
        g.dot(23, 117, 5.5, 0xC99A74)
        g.svg("M17.5 116C17.5 111 20 109 23 109C26 109 28.5 111 28.5 116C27 113.5 25 113 23 113C21 113 19 113.5 17.5 116Z", 0x2E2117)
        table(g, x: 30, y: 134)
        g.rect(34, 126, 4, 7, 0xF2B33D, radius: 0.8)
        g.rect(33.6, 125, 4.8, 2, 0xFFFDF6, radius: 1)
        table(g, x: 78, y: 140)
        chair(g, x: 64, y: 138)
        chair(g, x: 92, y: 138)
        g.rect(5, 160, 94, 11, 0x5E8C45)
        g.svg("M5 160Q12 152 20 160Q28 152 36 160Q44 152 52 160Q60 152 68 160Q76 152 84 160Q92 152 99 160Z", 0x6E9C52)
        g.svg("M14 171L40 44H54L28 171Z", 0xFFFFFF, 0.12)
        // Leaded amber panes on top, the frame bars
        for k in 0..<4 {
            let x = 5 + CGFloat(k) * 23.75
            f.rect(x + 1, 5, 21.75, 34, 0xF2B33D, radius: 1, 0.55)
            f.svgLine("M\(x + 1) 22H\(x + 22.75)M\(x + 11.9) 5V39", 0x8A6A3E, 0.8)
        }
        f.rect(-2, 172, 108, 4, 0x4A3524)
    }

    private static func parasol(_ g: PropPen, x: CGFloat, top: CGFloat, width w: CGFloat, colour: UInt32) {
        g.rect(x - 1, top, 2, 70, 0x5E6B73)
        let canopy = "M\(x - w / 2) \(top + 14)Q\(x) \(top - 6) \(x + w / 2) \(top + 14)Z"
        g.svg(canopy, colour)
        g.svg("M\(x - w / 6) \(top + 14)Q\(x - w / 10) \(top + 1) \(x) \(top + 3)Q\(x - w / 16) \(top + 6) \(x - w / 28) \(top + 14)Z M\(x + w / 6) \(top + 14)Q\(x + w / 10) \(top + 1) \(x + w * 0.06) \(top + 2)Q\(x + w / 8) \(top + 6) \(x + w / 4.5) \(top + 14)Z",
              0xFFFDF6, 0.85)
        g.svgLine("M\(x - w / 2) \(top + 14)H\(x + w / 2)", PalaceInk.shade(colour, 0.7), 1.4)
    }

    private static func table(_ g: PropPen, x: CGFloat, y: CGFloat) {
        g.oval(x - 11, y - 2, 22, 4, 0x3E4C55)
        g.rect(x - 1, y, 2, 14, 0x3E4C55)
        g.rect(x - 6, y + 13, 12, 1.6, 0x3E4C55)
    }

    private static func chair(_ g: PropPen, x: CGFloat, y: CGFloat) {
        g.svgLine("M\(x - 4) \(y - 8)V\(y + 14)M\(x + 4) \(y + 2)V\(y + 14)M\(x - 4) \(y + 2)H\(x + 4)", 0x7A5230, 1.6)
    }

    // MARK: Tip jar

    /// A glass jar full of coins with a label (`text`), one more coin dropping in (46 × 62).
    static func tipJar(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 46, height: 62))
        f.oval(4, 57, 38, 5, 0x1E1E1C, 0.16)
        let n = max(4, min(p.count ?? 9, 12))
        let spots: [(CGFloat, CGFloat)] = [(13, 54), (21, 55), (29, 54), (35, 52), (17, 50), (26, 50), (11, 48), (32, 47), (21, 46),
                                           (14, 44), (28, 43), (23, 41)]
        f.rect(6, 17, 34, 42, 0xD6E6EC, radius: 6)
        for (i, s) in spots.prefix(n).enumerated() {
            f.oval(s.0 - 4.5, s.1 - 2.2, 9, 4.6, i % 3 == 1 ? 0xB4B2A9 : 0xD9A440)
            f.oval(s.0 - 3, s.1 - 1.6, 6, 2, 0xFFFFFF, 0.35)
        }
        f.rect(6, 17, 34, 42, 0xFFFFFF, radius: 6, 0.15)
        f.rect(9, 11, 28, 8, 0xA9BCC6, radius: 2)
        f.rect(10, 9, 26, 4, 0xC9D6DC, radius: 2)
        f.rect(10, 20, 4, 30, 0xFFFFFF, radius: 2, 0.55)
        if let text = p.text {
            f.rect(6, 25, 34, 13, 0xFFFDF6, radius: 1)
            f.text(text, PropFont.demi(8.5), 0x993556, at: CGPoint(x: 23, y: 31.5), maxWidth: 30)
        }
        f.oval(17, -1, 11, 11, 0xD9A440)
        f.oval(19.5, 1.5, 6, 6, 0xF2C25A)
        f.svgLine("M14 1V5M31 1V5", 0x5F5E5A, 1)
    }

    // MARK: Bottle and glass

    /// A bottle with a round label (`text`, "0,0%") next to a full glass (60 × 80).
    static func bottleAndGlass(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 60, height: 80))
        let bottle: UInt32 = p.tone == "brown" ? 0x6B3F1C : 0x2F6B3A
        f.oval(2, 75, 56, 5, 0x1E1E1C, 0.16)
        f.rect(12, 2, 8, 6, 0xC8261B, radius: 1)
        f.svg("M12.5 7H19.5V20C19.5 24 28 26 28 34V76H4V34C4 26 12.5 24 12.5 20Z", bottle)
        f.rect(7, 30, 3, 40, 0xFFFFFF, radius: 1.5, 0.25)
        f.dot(16, 52, 12.5, 0xFFFDF6)
        f.ring(16, 52, 12.5, 0xC8261B, 1.4)
        f.text(p.text ?? "", PropFont.heavy(9.5), 0x1E1E1C, at: CGPoint(x: 16, y: 52.5), maxWidth: 22)
        f.svg("M33 30H56L53.5 76H35.5Z", 0xF2B33D)
        f.svg("M32.5 25H56.5Q57 30 53 31H36Q32 30 32.5 25Z", 0xFFFDF6)
        f.dot(36, 26, 3, 0xFFFDF6)
        f.dot(52, 26, 3.4, 0xFFFDF6)
        for (x, y) in [(40.0, 46.0), (46, 56), (42, 64), (49, 40)] as [(CGFloat, CGFloat)] { f.dot(x, y, 1, 0xFFF3C4) }
        f.svg("M36 32H39L38 74H37Z", 0xFFFFFF, 0.35)
    }

    // MARK: Drink

    /// A tall glass with ice, a straw and a slice of lemon on a coaster (48 × 64). `variant` colour.
    static func drinkGlass(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 48, height: 64))
        let drinks: [UInt32] = [0xF2711C, 0xC8261B, 0x5A2E14, 0x5DCAA5]
        let drink = drinks[((p.variant ?? 0) % drinks.count + drinks.count) % drinks.count]
        f.oval(4, 57, 40, 6, 0x7A5230)
        f.oval(4, 56, 40, 5, 0xC9965F)
        f.svgLine("M27 4L33 0", 0xC8261B, 2.6)
        f.svgLine("M21 30L27 4", 0xFFFDF6, 2.6)
        f.svgLine("M22 26L23 21M24 16L25 11", 0xC8261B, 2.6)
        f.svg("M11 18H37L35 58H13Z", 0xE9F1F4)
        f.svg("M11.6 26H36.4L35 58H13Z", drink)
        f.rect(16, 30, 8, 8, 0xFFFFFF, radius: 1.5, 0.55)
        f.rect(25, 36, 7, 7, 0xFFFFFF, radius: 1.5, 0.55)
        f.svg("M14 26H17L16 56H15Z", 0xFFFFFF, 0.35)
        f.svg("M30 18A9 9 0 0 1 44 12L37 20Z", 0xF6D27A)
        f.svgLine("M30 18A9 9 0 0 1 44 12", 0xE8B32C, 1.6)
    }

    // MARK: Gramophone

    /// A gramophone on a shelf playing notes, a string of warm bulbs above (100 × 104).
    static func gramophone(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 104))
        f.svgLine("M0 6Q50 34 100 6", 0x2E2117, 1.2)
        for k in 0..<7 {
            let t = CGFloat(k + 1) / 8
            let x = 100 * t, y = 6 + 28 * 2 * t * (1 - t)
            f.dot(x, y + 4, 7, 0xFAC775, 0.3)
            f.oval(x - 2.6, y + 1, 5.2, 7, 0xF6D27A)
            f.rect(x - 1.6, y - 1, 3.2, 3, 0x5E6B73)
        }
        f.rect(4, 98, 92, 6, 0x4A3524)
        f.rect(18, 76, 46, 22, 0x7A4A1E, radius: 2)
        f.rect(22, 80, 38, 14, 0x8C5E38, radius: 1.5)
        f.oval(16, 70, 50, 10, 0x1E1E1C)
        f.oval(36, 73, 10, 4, 0xC8261B)
        f.svgLine("M58 76L58 64Q58 56 64 50", 0xC9A15B, 3.2)
        f.svg("M62 52L70 40Q74 30 90 26Q96 34 94 48Q80 50 72 56Z", 0xC9A15B)
        f.svg("M90 26Q96 34 94 48Q88 40 90 26Z", 0x8C6A2E)
        f.svgLine("M48 74L54 66", 0x5E6B73, 1.6)
        PalaceHomeSound.note(f, 76, 30)
        PalaceHomeSound.note(f, 86, 50, color: 0x993556)
        PalaceHomeSound.note(f, 6, 54, color: 0x993556)
        PalaceHomeSound.note(f, 14, 40)
    }

    // MARK: Card terminal

    /// The bill on a saucer (total `text`) and the card terminal with a card held to it (66 × 62).
    static func payTerminal(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 66, height: 62))
        f.oval(0, 54, 34, 7, 0xD3D1C7)
        f.oval(2, 53, 30, 5, 0xFFFDF6)
        f.svg("M5 12H29V56L26 54L23 56L20 54L17 56L14 54L11 56L8 54L5 56Z", 0xFFFDF6)
        f.svgLine("M8 18H26M8 23H22M8 28H25M8 33H20", 0xD3D1C7, 1.4)
        f.svgLine("M8 40H26", 0x1E1E1C, 1)
        f.text(p.text ?? "", PropFont.heavy(8), 0x1E1E1C, at: CGPoint(x: 17, y: 46.5), maxWidth: 22)
        f.oval(32, 56, 30, 5, 0x1E1E1C, 0.16)
        f.rect(34, 14, 26, 44, 0x2E3438, radius: 4)
        f.rect(37, 18, 20, 12, 0xC9E6E2, radius: 1)
        f.svgLine("M40 24H50M40 27H46", 0x1E7A4C, 1.2)
        for r in 0..<3 {
            for c in 0..<3 { f.rect(38 + CGFloat(c) * 6.4, 34 + CGFloat(r) * 5.6, 4.6, 3.8, 0x8A8A82, radius: 0.8) }
        }
        f.rect(38, 51, 4.6, 3.8, 0xC8261B, radius: 0.8)
        f.rect(44.4, 51, 4.6, 3.8, 0xFAC775, radius: 0.8)
        f.rect(50.8, 51, 4.6, 3.8, 0x1E7A4C, radius: 0.8)
        let card = Path(roundedRect: CGRect(x: -9, y: -6, width: 18, height: 12), cornerRadius: 1.6)
            .applying(CGAffineTransform(rotationAngle: -0.3).concatenating(CGAffineTransform(translationX: 54, y: 10)))
        f.fill(card, 0x2F5BD3)
        f.svg("M58 6C61 2 66 3 66 8C66 12 62 15 58 14Z", 0xE8C4A0)
        f.svgLine("M44 6Q47 9 44 12M41 3Q46 9 41 15", 0x1E7A4C, 1.3)
    }
}
