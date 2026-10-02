import SwiftUI

/// Bank things you can hold or use: the cash machine, a piggy bank, a bank card in a hand and the
/// note counter. Each draws at a design size and scales to its frame.
enum G1Bank {
    // MARK: Cash machine

    /// A cash machine set in the wall (94 × 170): a banknote sign on top, the screen (`text`), the
    /// keys, and notes sliding out of the slot into a hand, a green arrow pointing out.
    static func atm(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 94, height: 170))
        f.rect(0, 0, 94, 150, 0x8C9499, radius: 3)
        f.rect(4, 4, 86, 142, 0xB4B2A9, radius: 2)
        f.rect(4, 4, 86, 22, 0x1F3A6B, radius: 2)
        PalaceIcon.banknote.draw(f, in: CGRect(x: 35, y: 3, width: 24, height: 24), color: 0xFFFDF6, detail: 0x1F3A6B)
        f.rect(10, 30, 74, 112, 0x3E4C55, radius: 4)
        f.rect(16, 36, 62, 34, 0x1E1E1C, radius: 2)
        f.rect(18, 38, 58, 30, 0x232B3B, radius: 1.5)
        f.text(p.text ?? "€ 50", PropFont.heavy(14), 0x5DCAA5, at: CGPoint(x: 47, y: 50), maxWidth: 52)
        f.rect(26, 60, 42, 4, 0x5DCAA5, radius: 2, 0.5)
        for r in 0..<4 {
            for c in 0..<3 {
                f.rect(20 + CGFloat(c) * 11, 76 + CGFloat(r) * 7, 9, 5, r == 3 && c == 2 ? 0x1E7A4C : 0xD3D1C7, radius: 1)
            }
        }
        f.rect(58, 78, 20, 4, 0x1E1E1C, radius: 1)
        f.rect(61, 74, 14, 5, 0x2F5BD3, radius: 1)
        // Cash slot with notes coming out
        f.rect(18, 112, 58, 8, 0x1E1E1C, radius: 2)
        G1Props.note(f, 44, 124, w: 36, angle: 0.08, 0x2F7FC1)
        G1Props.note(f, 50, 128, w: 36, angle: 0.18, 0xF2A65A)
        G1Props.arm(f, from: CGPoint(x: 96, y: 160), to: CGPoint(x: 72, y: 138), sleeve: 0x0F6E56, width: 9)
        f.svg("M62 132C66 128 74 130 76 134L74 140C70 141 65 139 62 136Z", G1Props.skin)
        f.svgLine("M8 128V160M3 152L8 160L13 152", 0x1E7A4C, 3)
    }

    // MARK: Piggy bank

    /// A pink piggy bank (96 × 106) on a low stand, a coin dropping into the slot on its back.
    static func piggyBank(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 106))
        let pink: UInt32 = 0xF2A7BE, dark: UInt32 = 0xD9849E
        f.oval(10, 98, 76, 8, 0x1E1E1C, 0.16)
        f.rect(14, 92, 68, 8, 0x8C5E38, radius: 2)
        f.svgLine("M28 78V92M40 80V92M58 80V92M70 78V92", dark, 7)
        f.oval(12, 46, 72, 44, pink)
        f.oval(18, 50, 30, 14, 0xFFFFFF, 0.25)
        f.svg("M30 52L26 38L42 47Z", dark)
        f.oval(78, 60, 14, 16, dark)
        f.dot(83, 66, 1.8, 0x7A2A44)
        f.dot(88, 70, 1.8, 0x7A2A44)
        f.dot(68, 60, 2.2, 0x2E2117)
        f.svgLine("M12 64C6 62 6 56 10 56C13 56 12 61 8 60", dark, 2)
        f.rect(38, 46, 22, 4, 0x7A2A44, radius: 2)
        // Coin on its way in
        f.svgLine("M38 30L35 26M56 30L59 26M47 34V38", 0xC9A15B, 1.6)
        f.ring(49, 22, 9, 0xF2711C, 1)
        G1Props.coin(f, 49, 18, 9)
        f.svg("M45 6L49 0L53 6Z", 0xF2711C)
    }

    // MARK: Bank card

    /// A bank card held up in a hand (78 × 60): chip, contactless waves, `text` number, `tone`.
    static func bankCard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 78, height: 60))
        let colour = PropColor.named(p.tone, 0x2F5BD3)
        var c = f
        c.ctx.translateBy(x: 38, y: 26)
        c.ctx.rotate(by: .radians(-0.12))
        c.rect(-33, -21, 68, 44, 0x1E1E1C, radius: 5, 0.16)
        c.rect(-35, -23, 68, 44, colour, radius: 5)
        c.rect(-35, -23, 68, 10, PalaceInk.shade(colour, 0.82), radius: 5)
        c.rect(-35, -16, 68, 3, PalaceInk.shade(colour, 0.82))
        c.rect(-28, -8, 13, 10, 0xE0B94A, radius: 2)
        c.svgLine("M-28 -3H-15M-21.5 -8V2", 0xB08A2E, 0.9)
        c.svgLine("M-8 -6Q-5 -3 -8 0M-4 -8Q0 -3 -4 2M0 -10Q5 -3 0 4", 0xFFFDF6, 1.4)
        c.text(p.text ?? "•••• 4821", PropFont.mono(8.5), 0xFFFDF6, at: CGPoint(x: -28, y: 11), anchor: .leading, maxWidth: 56)
        c.dot(22, 12, 4, 0xC8261B, 0.9)
        c.dot(27, 12, 4, 0xFAC775, 0.9)
        // The hand holding it at its right edge
        f.svg("M58 60L62 46H76L78 60Z", 0x0F6E56)
        f.svg("M56 48C54 40 58 35 64 35C70 35 74 40 72 47L68 50H60Z", G1Props.skin)
        f.svg("M58 38C55 33 57 29 61 30L64 34Z", G1Props.skin)
        f.svgLine("M59 41H67M59 45H67", PalaceInk.shade(G1Props.skin, 0.85), 1)
    }

    // MARK: Note counter

    /// A note-counting machine (82 × 60): notes fan through the top, a neat stack lands in the
    /// tray, the total `text` big on the green display.
    static func moneyCounter(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 82, height: 60))
        f.oval(4, 55, 74, 5, 0x1E1E1C, 0.15)
        f.svg("M10 24H72L76 56H6Z", 0x5E6B73)
        f.svg("M10 24H72L73 30H9Z", 0x8C9499)
        for (i, a) in [-0.5, -0.32, -0.14].enumerated() {
            G1Props.note(f, 30 + CGFloat(i) * 9, 14, w: 30, angle: CGFloat(a), [0xF2A65A, 0x2F7FC1, 0xF2A65A][i])
        }
        f.svgLine("M58 6L64 2M60 12L67 10M60 18L66 19", 0x8C9499, 1.4)
        f.rect(14, 34, 54, 16, 0x1E1E1C, radius: 2)
        f.rect(16, 36, 50, 12, 0x0F3D30, radius: 1)
        f.text(p.text ?? "€ 500", PropFont.mono(11), 0x7FE0B5, at: CGPoint(x: 41, y: 42.5), maxWidth: 46)
        G1Props.note(f, 64, 50, w: 18, angle: 0, 0xF2A65A)
        G1Props.note(f, 64, 47.5, w: 18, angle: 0, 0xF2A65A)
    }
}
