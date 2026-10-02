import SwiftUI

/// Things that stand on the town hall square: a polling station's open door, an election poster
/// board, a party's campaign stand, a monument with an open birdcage and a hanging banner.
enum G8Square {
    // MARK: Polling station

    /// A brick front (110 × 96) with its double door open: inside two voting booths (someone in
    /// one) and a ballot box on a table; a ballot-box sign over the door, an A-board pointing in.
    static func pollingStation(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 110, height: 96))
        G8Props.shadow(f, 0, 90, 110)
        f.rect(0, 8, 104, 84, 0x9A5238)
        var bricks = ""
        for (r, y) in stride(from: 14.0, to: 92, by: 6).enumerated() {
            bricks += "M0 \(y)H104"
            for x in stride(from: r % 2 == 0 ? 6.0 : 12, to: 104, by: 12) { bricks += "M\(x) \(y)V\(y + 6)" }
        }
        f.svgLine(bricks, 0x7A3F2E, 0.8)
        f.rect(0, 4, 104, 6, 0xD9CDB4)
        f.rect(18, 30, 64, 62, 0xEFEBE2)
        f.rect(18, 80, 64, 12, 0xD9D3C4)
        for x in [22.0, 46] {
            f.rect(x, 40, 20, 42, 0xFFFDF6)
            f.rect(x, 40, 3, 42, 0xD3D1C7)
            f.rect(x + 17, 40, 3, 42, 0xD3D1C7)
            f.rect(x, 38, 20, 3, 0x9A9A92)
            f.rect(x + 3, 60, 14, 2.4, 0x9A9A92)
        }
        // A voter in the second booth, seen from behind.
        f.svgLine("M53 78V90M59 78V90", 0x3E4C55, 3)
        f.svg("M49 80L50 58C50.5 53 53 51 56 51C59 51 61.5 53 62 58L63 80Z", 0x0F6E56)
        f.dot(56, 46, 5.4, 0x2E2117)
        // Ballot box on a little table.
        f.svgLine("M68 92V74M80 92V74", 0x6B4A2E, 1.6)
        f.rect(65, 72, 18, 3, 0x9A6A42)
        f.rect(66, 58, 16, 14, 0xF2711C, radius: 1.5)
        f.rect(70, 59.5, 8, 1.8, 0x7A3F2E)
        f.rect(71.5, 52, 5, 8, 0xFFFDF6)
        // Doors folded open, the sign over the doorway.
        f.rect(12, 30, 6, 62, 0x2F4B3A)
        f.rect(82, 30, 6, 62, 0x2F4B3A)
        let plate = CGRect(x: 36, y: 12, width: 28, height: 16)
        f.rect(plate, 0xFFFDF6, radius: 2)
        f.stroke(Path(roundedRect: plate.insetBy(dx: 1.2, dy: 1.2), cornerRadius: 1.5), 0x1F3A6B, 1)
        PalaceIcon.g8BallotBox.draw(f, in: CGRect(x: 43, y: 13.5, width: 13, height: 13), color: 0xF2711C, detail: 0xFFFDF6)
        // A-board on the pavement, its arrow pointing inside.
        f.svg("M89 92L93 58H105L109 92Z", 0x3E4C55)
        f.rect(93, 60, 12, 22, 0xFFFDF6, radius: 1)
        PalaceIcon.g8BallotBox.draw(f, in: CGRect(x: 94, y: 61, width: 10, height: 10), color: 0xF2711C, detail: 0xFFFDF6)
        G8Props.arrow(f, CGPoint(x: 103, y: 77), CGPoint(x: 94.5, y: 77), 0x1F3A6B, 1.6, head: 4)
    }

    // MARK: Election board

    /// The election poster board (110 × 88): green wooden board on two posts, a date (`text`)
    /// on top and `count` (8) numbered spaces, each with a different poster.
    static func electionBoard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 110, height: 88))
        G8Props.shadow(f, 4, 82, 102)
        f.rect(14, 40, 5, 46, 0x6B4A2E)
        f.rect(91, 40, 5, 46, 0x6B4A2E)
        f.rect(2, 4, 106, 66, 0x3F5A4A, radius: 2)
        f.rect(6, 7, 98, 12, 0xFFFDF6, radius: 1)
        f.text(p.text ?? "", PropFont.heavy(9), 0x1E1E1C, at: CGPoint(x: 55, y: 13.5), maxWidth: 92)
        let colours: [UInt32] = [0xC8261B, 0x2F5BD3, 0x0F6E56, 0xF2711C, 0x3C3489, 0xFAC775, 0x5E6B73, 0x5E8C45]
        let n = max(1, min(p.count ?? 8, 8))
        for i in 0..<8 {
            let x = 6 + CGFloat(i % 4) * 24.6, y = 21 + CGFloat(i / 4) * 24.4
            let cell = CGRect(x: x, y: y, width: 23, height: 23)
            f.rect(cell, 0x2F4337)
            guard i < n else { continue }
            let c = colours[i % colours.count]
            f.rect(cell.insetBy(dx: 1, dy: 1), c)
            if i % 3 == 2 {
                f.dot(cell.midX, cell.midY + 1, 6.5, 0xFFFDF6)
                G8Props.star(f, cell.midX, cell.midY + 1, 4.6, c)
            } else {
                let look = PalaceFigures.Look.at(i + 2)
                f.svg("M\(cell.minX + 5) \(cell.maxY - 1)Q\(cell.midX) \(cell.maxY - 12) \(cell.maxX - 5) \(cell.maxY - 1)Z", PalaceInk.shade(c, 0.7))
                f.dot(cell.midX, cell.midY - 0.5, 5, look.skin)
                f.svg("M\(cell.midX - 5) \(cell.midY - 1)C\(cell.midX - 5) \(cell.midY - 7) \(cell.midX + 5) \(cell.midY - 7) \(cell.midX + 5) \(cell.midY - 1)C\(cell.midX + 3) \(cell.midY - 4) \(cell.midX - 3) \(cell.midY - 4) \(cell.midX - 5) \(cell.midY - 1)Z", look.hair)
            }
            f.rect(cell.minX + 1, cell.minY + 1, 8, 8, 0xFFFDF6)
            f.text("\(i + 1)", PropFont.heavy(6.5), 0x1E1E1C, at: CGPoint(x: cell.minX + 5, y: cell.minY + 5.2))
        }
    }

    // MARK: Party stand

    /// A campaign stand (112 × 100): a parasol and a table cloth in the party colour (`tone`,
    /// default purple) with the party's star and `text` ("Lijst 4"), someone handing out a flyer,
    /// balloons on strings.
    static func partyStand(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 100))
        let c = PalaceLivingProps.tone(p.tone ?? "purple")
        G8Props.shadow(f, 4, 93, 104, 7)
        f.rect(50, 8, 3, 62, 0x5E6B73)
        f.svg("M6 30Q51 -4 96 30Z", c)
        f.svg("M51 4L40 30H62Z", PalaceInk.shade(c, 1.25), 0.5)
        f.svgLine("M6 30H96", PalaceInk.shade(c, 0.7), 1.4)
        PalaceFigures.mini(f.within(CGRect(x: 18, y: 26, width: 28, height: 56), unit: 28.0 / 30), PalaceFigures.Look.at(3), walking: false, briefcase: false)
        f.svgLine("M38 46L50 54", PalaceFigures.Look.at(3).coat, 4)
        f.rect(48, 47, 9, 12, 0xFFFDF6, radius: 0.8)
        G8Props.star(f, 52.5, 52, 3, c)
        f.rect(8, 60, 80, 6, 0xEFEBE2)
        f.rect(62, 55, 10, 6, 0xFFFDF6)
        f.rect(64, 53, 10, 6, 0xF4F1EA)
        f.rect(10, 66, 76, 28, c)
        f.svgLine("M10 66H86", PalaceInk.shade(c, 0.7), 1.2)
        f.dot(24, 80, 8, 0xFFFDF6)
        G8Props.star(f, 24, 80.5, 6, 0xFAC775)
        f.text(p.text ?? "", PropFont.heavy(13), 0xFFFDF6, at: CGPoint(x: 56, y: 80.5), maxWidth: 46)
        for (i, (x, y)) in [(96.0, 16.0), (106, 30), (92, 40)].enumerated() {
            f.svgLine("M\(x) \(y + 8)Q\(x - 4) \(y + 30) 86 66", 0x5E6B73, 0.8)
            f.oval(x - 7, y - 8, 14, 16, i == 1 ? 0xFAC775 : c)
            f.svg("M\(x - 1.5) \(y + 8)H\(x + 1.5)L\(x) \(y + 10)Z", i == 1 ? 0xFAC775 : c)
            if i != 1 { G8Props.star(f, x, y, 3.4, 0xFAC775) }
            f.oval(x - 4, y - 5, 3, 4, 0xFFFFFF, 0.4)
        }
    }

    // MARK: Monument with an open cage

    /// A stone plinth (74 × 110) with a golden birdcage whose door hangs open, and a bird
    /// flying up and away from it.
    static func cage(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 74, height: 110))
        G8Props.shadow(f, 4, 104, 66)
        f.rect(8, 102, 58, 6, 0x9A9A92)
        f.rect(14, 80, 46, 23, 0xB4B2A9)
        f.rect(10, 76, 54, 6, 0xD3D1C7)
        f.svgLine("M22 88H52M22 94H46", 0x9A9A92, 1.2)
        let gold: UInt32 = 0xC9A15B
        f.svgLine("M18 72V44Q18 26 37 24Q56 26 56 44V72", gold, 2.2)
        f.svgLine("M24 72V40Q26 30 37 28M50 72V40Q48 30 37 28M30 72V58M44 72V58", gold, 1.4)
        f.svgLine("M30 42V36Q32 30 37 29M44 42V36Q42 30 37 29", gold, 1.4)
        f.svgLine("M18 50H30M44 50H56", gold, 1.2)
        f.ring(37, 20, 3.4, gold, 1.6)
        f.rect(16, 71, 42, 5, gold)
        // The door, swung open to the left, and the empty doorway.
        f.svgLine("M30 58V42H44V58", PalaceInk.shade(gold, 0.8), 1)
        f.svg("M30 58L14 62V46L30 42Z", gold, 0.25)
        f.svgLine("M30 58L14 62V46L30 42M19 60.8V44.8M24.5 59.4V43.4", gold, 1.4)
        // The bird flying out, with its path.
        f.svgLine("M40 54Q46 46 52 44", 0xF2B33D, 1.4)
        f.svgLine("M42 60Q50 52 56 50", 0xF2B33D, 1)
        let b = G8Props.turned(f, CGPoint(x: 61, y: 38), -16)
        b.svg("M-9 2C-7 -4 1 -6 7 -3L12 -6L10 -1C10 5 4 9 -3 8C-7 8 -9 5 -9 2Z", 0xF2B33D)
        b.svg("M-4 -1C-8 -10 -4 -17 4 -19C3 -12 2 -6 0 -1Z", 0xE8A93A)
        b.svg("M-8 3L-16 0L-13 8Z", 0xF2B33D)
        b.svg("M12 -6L16 -4L11.5 -2.6Z", 0xF2711C)
        b.dot(7, -2.4, 1.1, 0x1E1E1C)
    }

    // MARK: Banner

    /// A cloth banner (40 × 84) hanging from a rod, swallow-tailed, with the first of `icons`
    /// big on it. `tone` the cloth (default blue).
    static func banner(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 40, height: 84), hanging: true)
        let cloth: UInt32 = p.tone.map { PalaceLivingProps.tone($0) } ?? 0x2F5BD3
        f.svg("M3 3H37V82L20 72L3 82Z", 0x1E1E1C, 0.15)
        f.svg("M3 2H37V80L20 70L3 80Z", cloth)
        f.svgLine("M6 6H34V75L20 66.5L6 75Z", 0xFFFDF6, 1)
        f.rect(0, 0, 40, 3.4, 0x4A3524, radius: 1.5)
        f.dot(1.5, 1.7, 2.2, 0xC9A15B)
        f.dot(38.5, 1.7, 2.2, 0xC9A15B)
        if let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first {
            icon.draw(f, in: CGRect(x: 5, y: 20, width: 30, height: 30), color: 0xFFFDF6, detail: cloth)
        }
    }
}
