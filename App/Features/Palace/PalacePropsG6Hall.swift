import SwiftUI

/// Concert hall props: a ticket poster with prices, the audience (clapping, singing along, or
/// one singer out of tune), a music stand with repeat signs, a composer's bust and the stage
/// front with steps and a spotlight.
enum G6Hall {
    // MARK: Ticket

    /// A poster (70 × 100) with a ticket: `caption` on top, a calendar page, price rows `lines`
    /// "label|price"; the `highlight` row is ringed, the others are struck through.
    static func ticket(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 70, height: 100))
        f.rect(2, 3, 68, 97, 0x1E1E1C, radius: 2, 0.18)
        f.rect(0, 0, 68, 96, 0xFFFDF6, radius: 2)
        f.rect(0, 0, 68, 18, 0x3C3489, radius: 2)
        if let caption = p.caption { f.text(caption, PropFont.heavy(10), 0xFAC775, at: CGPoint(x: 34, y: 9.5), maxWidth: 62) }
        // calendar page with the early day ticked
        f.rect(6, 22, 24, 24, 0xFFFDF6, radius: 2)
        f.stroke(Path(roundedRect: CGRect(x: 6, y: 22, width: 24, height: 24), cornerRadius: 2), 0xB4B2A9, 1)
        f.rect(6, 22, 24, 7, 0xC8261B, radius: 2)
        PalaceIcon.check.draw(f, in: CGRect(x: 10, y: 30, width: 16, height: 14), color: 0x1E7A4C, detail: 0xFFFDF6)
        // ticket stub
        let t = CGRect(x: 34, y: 24, width: 30, height: 20)
        f.svg("M\(t.minX) \(t.minY)H\(t.maxX)V\(t.midY - 3)A3 3 0 0 0 \(t.maxX) \(t.midY + 3)V\(t.maxY)H\(t.minX)V\(t.midY + 3)A3 3 0 0 0 \(t.minX) \(t.midY - 3)Z", 0xFAC775)
        f.svgLine("M\(t.minX + 9) \(t.minY + 2)V\(t.maxY - 2)", 0xC9A15B, 1)
        G6Props.note(f, t.minX + 20, t.midY + 4, 0x3C3489, scale: 0.8)
        for (i, row) in (p.lines ?? []).prefix(3).enumerated() {
            let y = 58 + CGFloat(i) * 17
            let cells = row.split(separator: "|", omittingEmptySubsequences: false).map(String.init)
            let on = i == (p.highlight ?? 0)
            f.text(cells[0], PropFont.demi(8), 0x5F5E5A, at: CGPoint(x: 6, y: y), anchor: .leading, maxWidth: 34)
            if cells.count > 1 {
                f.text(cells[1], PropFont.heavy(on ? 12 : 10), on ? 0x1E7A4C : 0x8E9AA0, at: CGPoint(x: 52, y: y), maxWidth: 28)
                if on {
                    f.stroke(Path(ellipseIn: CGRect(x: 36, y: y - 9, width: 32, height: 18)), 0xC8261B, 1.6)
                } else {
                    f.line(40, y, 64, y - 1, 0xC8261B, 1.4)
                }
            }
        }
    }

    // MARK: Audience

    /// Three people in the stalls seen from behind (120 × 136), red seat backs in front.
    /// `accessory` "clap" (hands up clapping, a bubble with `text`), "sing" (arms linked,
    /// notes rising, a bubble with `text`), "offkey" (the middle one sends up crooked red notes,
    /// the neighbour turns round holding their ears).
    static func crowd(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 120, height: 136))
        let mode = p.accessory ?? "clap"
        let xs: [CGFloat] = [22, 60, 98]
        for (i, x) in xs.enumerated() {
            let v = PalaceFigures.Look.at(i * 2 + (mode == "sing" ? 1 : mode == "offkey" ? 4 : 0))
            f.svg("M\(x - 17) 136V112Q\(x - 17) 92 \(x) 92Q\(x + 17) 92 \(x + 17) 112V136Z", v.coat)
            let turned = mode == "offkey" && i == 2
            f.dot(x, 80, 13, v.skin)
            if turned {
                f.svg("M\(x - 13) 78C\(x - 13) 64 \(x + 13) 64 \(x + 13) 78C\(x + 8) 72 \(x - 8) 72 \(x - 13) 78Z", v.hair)
                f.svgLine("M\(x - 7) 80L\(x - 3) 82M\(x + 7) 80L\(x + 3) 82", 0x2E2117, 1.4)
                f.svgLine("M\(x - 5) 88L\(x - 2) 86L\(x + 1) 88L\(x + 4) 86", 0x7A2A20, 1.2)
                f.svgLine("M\(x - 16) 98L\(x - 15) 82M\(x + 16) 98L\(x + 15) 82", v.coat, 5)
                f.dot(x - 14, 80, 3.4, v.skin)
                f.dot(x + 14, 80, 3.4, v.skin)
                f.text("?!", PropFont.heavy(11), 0xC8261B, at: CGPoint(x: x + 8, y: 58))
            } else {
                f.svg("M\(x - 13) 81C\(x - 14) 64 \(x + 14) 64 \(x + 13) 81C\(x + 13) 90 \(x - 13) 90 \(x - 13) 81Z", v.hair)
            }
            switch mode {
            case "clap":
                f.svgLine("M\(x - 12) 96L\(x - 6) 62M\(x + 12) 96L\(x + 6) 62", v.coat, 5)
                f.svg("M\(x - 8) 60L\(x - 1) 54L\(x) 62Z M\(x + 8) 60L\(x + 1) 54L\(x) 62Z", v.skin)
                f.svgLine("M\(x - 8) 50L\(x - 11) 46M\(x) 48V43M\(x + 8) 50L\(x + 11) 46", 0xFAC775, 1.4)
            case "sing":
                if i < 2 { f.svgLine("M\(x + 12) 100Q\(x + 19) 96 \(x + 26) 100", v.coat, 5) }
                G6Props.note(f, x + 6, 58 - CGFloat(i % 2) * 8, [0x2F5BD3, 0x1E7A4C, 0xF2711C][i])
            default:
                if i == 1 {
                    G6Props.note(f, x - 4, 56, 0xC8261B, crooked: true)
                    G6Props.note(f, x + 10, 44, 0xC8261B, scale: 0.9, crooked: true)
                    f.svgLine("M\(x - 10) 66L\(x - 6) 62L\(x - 2) 67L\(x + 2) 61L\(x + 6) 66", 0xC8261B, 1.6)
                }
            }
        }
        if let text = p.text, mode != "offkey" {
            G6Props.bubble(f, CGRect(x: 18, y: 0, width: 84, height: 24), tail: CGPoint(x: 44, y: 36), lines: [text], size: 12,
                           ink: mode == "clap" ? 0xC8261B : 0x2F5BD3)
        }
    }

    // MARK: Score

    /// A music stand (58 × 86) with a page of notes between big repeat signs, a pencil, and a
    /// bubble with `text`.
    static func score(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 58, height: 86))
        f.svgLine("M29 50V80M29 80L18 86M29 80L40 86", 0x1E1E1C, 1.8)
        f.svg("M6 30L52 30L48 54L10 54Z", 0x1E1E1C)
        f.rect(9, 26, 40, 26, 0xFFFDF6, radius: 1)
        for y in [31.0, 35, 39, 43, 47] as [CGFloat] { f.line(11, y, 47, y, 0xB4B2A9, 0.6) }
        // repeat signs
        f.svgLine("M13 30V48M15.5 30V48", 0x1E1E1C, 1.2)
        f.dot(18, 36.5, 1, 0x1E1E1C)
        f.dot(18, 41.5, 1, 0x1E1E1C)
        f.svgLine("M42.5 30V48M45 30V48", 0x1E1E1C, 1.2)
        f.dot(40, 36.5, 1, 0x1E1E1C)
        f.dot(40, 41.5, 1, 0x1E1E1C)
        for (x, y) in [(23.0, 43.0), (29, 39), (35, 41)] as [(CGFloat, CGFloat)] { G6Props.note(f, x, y, 0x1E1E1C, scale: 0.55) }
        f.svgLine("M44 58L54 46", 0xF2B33D, 2.4)
        f.svgLine("M43 59L44.5 57", 0x1E1E1C, 1.6)
        guard let text = p.text else { return }
        G6Props.bubble(f, CGRect(x: 0, y: 0, width: 58, height: 18), tail: CGPoint(x: 22, y: 26), lines: [text], size: 8)
    }

    // MARK: Bust

    /// A white bust of a composer with a curled wig (58 × 100) on a column, notes around it.
    static func bust(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 58, height: 100))
        let marble: UInt32 = 0xF4F1EA, shade: UInt32 = 0xD3D1C7
        f.rect(16, 62, 26, 34, marble)
        f.rect(12, 58, 34, 6, shade, radius: 1)
        f.rect(12, 94, 34, 6, shade, radius: 1)
        f.svgLine("M22 66V92M29 66V92M36 66V92", shade, 1.2)
        f.svg("M10 58C10 46 18 42 29 42C40 42 48 46 48 58Z", marble)
        f.dot(29, 28, 11, marble)
        for (x, y) in [(17.0, 22.0), (17, 30), (18, 38), (41, 22), (41, 30), (40, 38)] as [(CGFloat, CGFloat)] {
            f.dot(x, y, 4.2, shade)
        }
        f.svg("M19 22C19 12 39 12 39 22C35 17 23 17 19 22Z", shade)
        f.svgLine("M25 28H27M31 28H33M27 35Q29 36 31 35", 0xB4B2A9, 1)
        G6Props.note(f, 6, 14, 0xC9A15B)
        G6Props.note(f, 50, 8, 0xC9A15B, scale: 0.8)
    }

    // MARK: Stage front

    /// The corner of the stage (74 × 140): a spotlight beam onto an empty microphone stand at the
    /// edge, the dark front of the stage and three steps up from the hall.
    static func podium(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 74, height: 140))
        f.svg("M40 0L20 96H70Z", 0xFAC775, 0.35)
        f.oval(18, 90, 54, 12, 0xFAC775, 0.6)
        f.rect(34, 0, 12, 8, 0x1E1E1C, radius: 2)
        f.svgLine("M45 96V62M38 96H52", 0x1E1E1C, 1.8)
        f.svgLine("M45 62L50 56", 0x1E1E1C, 1.8)
        f.dot(51, 55, 3, 0x3E4C55)
        // stage edge and steps
        f.rect(0, 102, 74, 4, 0xC98B5E)
        for (i, y) in [106.0, 117, 128].enumerated() {
            let x = CGFloat(2 - i) * 10
            f.rect(x, y, 74 - x, 11, i % 2 == 0 ? 0x5E3A2A : 0x6B4A2E)
            f.rect(x, y, 74 - x, 2, 0xC98B5E)
        }
    }
}
