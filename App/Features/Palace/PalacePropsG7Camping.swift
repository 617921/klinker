import SwiftUI

/// Campsite props: a numbered pitch, a wash block, a sleeping bag, a tent peg being hammered in,
/// a campfire, a notice board on posts and an air mattress with its pump.
enum G7CampProps {
    // MARK: Pitch

    /// An empty pitch (116 × 84): a lawn edged by low hedges, a post with a number plate (`text`)
    /// and a hook-up box.
    static func pitch(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 116, height: 84))
        f.rect(10, 0, 96, 18, 0x3F6B33, radius: 8)
        f.rect(4, 6, 20, 14, 0x4E7A3A, radius: 7)
        f.svg("M18 18H98L114 78H2Z", 0xB5D18F)
        f.svgLine("M14 32H102M10 48H106M6 64H110", 0xA9C985, 3)
        var dash = Path()
        for (a, b) in [((18.0, 18.0), (98.0, 18.0)), ((98, 18), (114, 78)), ((114, 78), (2, 78)), ((2, 78), (18, 18))] {
            for k in stride(from: 0.0, to: 1, by: 0.12) {
                dash.move(to: CGPoint(x: a.0 + (b.0 - a.0) * k, y: a.1 + (b.1 - a.1) * k))
                dash.addLine(to: CGPoint(x: a.0 + (b.0 - a.0) * (k + 0.06), y: a.1 + (b.1 - a.1) * (k + 0.06)))
            }
        }
        f.stroke(dash, 0xFFFDF6, 2)
        f.rect(94, 6, 12, 18, 0x5E6B73, radius: 2)
        f.dot(100, 12, 2.4, 0x1E7A4C)
        // Number post
        f.rect(20, 50, 4, 32, 0x8A5C38)
        f.rect(8, 36, 28, 18, 0xFFFDF6, radius: 2)
        f.stroke(Path(roundedRect: CGRect(x: 8, y: 36, width: 28, height: 18), cornerRadius: 2), 0x0F6E56, 1.6)
        if let text = p.text { f.text(text, PropFont.heavy(12), 0x0F6E56, at: CGPoint(x: 22, y: 45.5), maxWidth: 24) }
    }

    // MARK: Wash block

    /// A small wash block (94 × 104): two doors under a toilet and a shower sign, a basin with a tap.
    static func washblock(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 94, height: 104))
        f.oval(2, 98, 90, 6, 0x1E1E1C, 0.14)
        f.rect(4, 30, 86, 70, 0xEFEBE2)
        f.svg("M0 32L47 10L94 32Z", 0x8C3A2E)
        f.rect(4, 32, 86, 3, 0x1E1E1C, radius: 0, 0.1)
        for (x, icon) in [(12.0, PalaceIcon.g7Toilet), (50, .g7Shower)] as [(CGFloat, PalaceIcon)] {
            f.rect(x, 38, 26, 22, 0x1F3A6B, radius: 2)
            icon.draw(f, in: CGRect(x: x + 4, y: 40, width: 18, height: 18), color: 0xFFFDF6, detail: 0x1F3A6B)
            f.rect(x + 2, 64, 22, 36, 0x0F6E56)
            f.dot(x + 20, 82, 1.4, 0xC9A15B)
        }
        f.rect(78, 62, 14, 6, 0xFFFDF6, radius: 2)
        f.svgLine("M84 62V56H88", 0x7D8A92, 1.6)
        f.svgLine("M88 58V62", 0x8FB6CF, 1.2)
    }

    // MARK: Sleeping bag

    /// A mummy sleeping bag lying open on a mat (84 × 56): hood, zip, quilted lines.
    static func sleepingBag(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 56))
        f.oval(2, 48, 80, 8, 0x1E1E1C, 0.12)
        f.svg("M4 40L76 26L82 40L10 54Z", 0x0F6E56)
        f.svg("M6 38Q4 26 16 24L62 18Q80 16 80 30Q80 42 64 42L18 48Q8 48 6 38Z", 0x2F5BD3)
        f.svgLine("M24 22L26 46M36 20L38 45M48 19L50 44", 0x21468B, 1.4)
        f.svg("M58 22Q72 16 78 26Q80 36 70 40Q60 40 58 32Z", 0xF2711C)
        f.svg("M62 26Q72 22 75 29Q75 35 69 36Q63 35 62 30Z", 0xC8561A)
        f.svgLine("M58 22L58 40", 0xFAC775, 1.4)
        f.svgLine("M20 30Q40 26 58 26", 0xFAC775, 1.2)
    }

    // MARK: Tent peg

    /// A tent peg being hammered into the grass (64 × 100): a hand with a rubber mallet, the
    /// guy line taut from the peg's hook, a little bang.
    static func tentPeg(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 64, height: 100))
        f.oval(4, 88, 56, 10, 0x8DB061)
        f.svgLine("M0 6L30 64", 0xF2711C, 1.8)
        f.svg("M28 60H36L33 92H31Z", 0xB4B2A9)
        f.svgLine("M28 60Q24 58 26 54", 0xB4B2A9, 2.6)
        f.svgLine("M30 62L30 90", 0xE3E1D8, 1)
        f.svgLine("M38 90l4 2M24 90l-4 2", 0x6E9C52, 1.4)
        // Mallet
        f.rect(24, 40, 22, 14, 0x1E1E1C, radius: 3)
        f.svgLine("M44 47L62 30", 0xC9965F, 4)
        f.dot(60, 30, 4.4, 0xC99A74)
        f.svgLine("M18 44L12 40M18 52L11 54M50 58L56 62", 0xF2C04E, 1.8)
    }

    // MARK: Campfire

    /// A campfire in a ring of stones (100 × 104): logs, flames, sparks and a marshmallow on a stick.
    static func campfire(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 104))
        f.oval(6, 84, 88, 18, 0x1E1E1C, 0.15)
        f.svgLine("M24 92L76 72M24 72L76 92", 0x6B4A2E, 8)
        f.svg("M30 86Q24 60 40 46Q38 60 46 62Q44 40 56 26Q56 46 66 52Q70 40 68 34Q82 54 70 86Z", 0xF2711C)
        f.svg("M38 86Q34 70 44 62Q46 72 52 74Q50 58 58 50Q62 66 66 70Q70 78 64 86Z", 0xFAC775)
        f.svg("M46 86Q46 78 50 74Q54 80 56 86Z", 0xFFFDF6)
        for (x, y) in [(36.0, 30.0), (62, 16), (74, 28), (48, 12)] as [(CGFloat, CGFloat)] { f.dot(x, y, 1.6, 0xFAC775) }
        for (x, y) in [(10.0, 92.0), (24, 98), (44, 101), (62, 100), (80, 96), (90, 88), (18, 84), (84, 80)] as [(CGFloat, CGFloat)] {
            f.oval(x - 7, y - 5, 14, 10, 0x8E8A80)
            f.oval(x - 6, y - 5, 10, 5, 0xA19E95)
        }
        f.svgLine("M98 50L66 42", 0x9A6A42, 2)
        f.oval(60, 38, 10, 8, 0xFFFDF6)
        f.oval(60, 38, 4, 8, 0xE0A93A, 0.6)
    }

    // MARK: Notice board

    /// A board on two wooden posts (64 × 104) with `caption`, `icons` (and `labels`), `text`;
    /// colours from `tone` (as for `sign`).
    static func postBoard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 64, height: 104))
        let tone = PropTone.named(p.tone)
        f.oval(4, 99, 56, 5, 0x1E1E1C, 0.15)
        f.rect(8, 40, 5, 62, 0x8A5C38)
        f.rect(51, 40, 5, 62, 0x8A5C38)
        let board = CGRect(x: 0, y: 0, width: 64, height: 60)
        f.rect(board, 0x6B4A2E, radius: 3)
        f.rect(board.insetBy(dx: 3, dy: 3), tone.back, radius: 2)
        PalacePanels.content(f, p, in: board.insetBy(dx: 6, dy: 5), tone: tone)
    }

    // MARK: Air bed

    /// An air mattress with a pillow end (108 × 66), a foot pump by its side with a hose and puffs.
    static func airBed(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 108, height: 66))
        f.oval(2, 38, 86, 10, 0x1E1E1C, 0.14)
        f.svg("M2 22Q0 12 10 10L74 4Q86 4 86 14Q88 26 76 28L10 36Q2 36 2 22Z", 0x2F9A8A)
        f.svgLine("M20 9L22 34M34 8L36 32M48 7L50 31M62 6L64 30", 0x217A6C, 2)
        f.svg("M66 6L74 4Q86 4 86 14Q88 26 76 28L68 29Z", 0x5DCAA5)
        f.svgLine("M12 14Q40 8 70 8", 0xFFFFFF, 1.4, 0.5)
        // Foot pump with its hose, a foot pressing it
        f.svgLine("M84 22Q96 30 88 46H82", 0x1E1E1C, 1.8)
        f.oval(64, 60, 40, 6, 0x1E1E1C, 0.14)
        f.svg("M64 50H96L94 64H66Z", 0xC8261B)
        f.svg("M66 50Q80 40 94 50Z", 0xE0604A)
        f.svg("M74 36H92Q98 36 98 42V44H74Z", 0x2E2117)
        f.svgLine("M100 52q4 -3 0 -6M104 54q6 -5 0 -10", 0xB4B2A9, 1.2)
    }
}
