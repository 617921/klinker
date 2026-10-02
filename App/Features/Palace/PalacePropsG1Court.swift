import SwiftUI

/// Courtroom things: level scales, a gavel coming down, thick law books, evidence, a prison
/// window, a case file of two people against each other, and a photo of someone riding through red.
enum G1Court {
    static let gold: UInt32 = 0xC9A15B

    // MARK: Scales

    /// Gold scales on a wooden plaque (98 × 70), both pans exactly level, a green tick on the post.
    static func scales(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 98, height: 70))
        f.oval(5, 3, 90, 66, 0x1E1E1C, 0.14)
        f.oval(3, 1, 90, 66, 0x6B4A2E)
        f.oval(7, 5, 82, 58, 0x8C5E38)
        f.rect(46, 14, 4, 40, gold, radius: 1)
        f.rect(34, 52, 28, 5, gold, radius: 2)
        f.rect(18, 17, 60, 3.4, gold, radius: 1.5)
        f.dot(48, 15, 4, gold)
        for x in [22.0, 74] as [CGFloat] {
            f.svgLine("M\(x) 19L\(x - 9) 38M\(x) 19L\(x + 9) 38", gold, 1.2)
            f.svg("M\(x - 11) 38H\(x + 11)Q\(x + 10) 45 \(x) 45Q\(x - 10) 45 \(x - 11) 38Z", gold)
        }
        f.svgLine("M10 38H86", 0xFFFDF6, 1, 0.5)
        G1Props.tick(f, 48, 32, 7)
    }

    // MARK: Gavel

    /// A gavel striking its block (60 × 56) with bang lines, a stamped verdict sheet under it.
    static func gavel(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 60, height: 56))
        f.svg("M2 40H40L44 54H6Z", 0xFFFDF6)
        f.svgLine("M8 44H30M9 48H26", 0xD3D1C7, 1.2)
        f.ring(34, 47, 5, 0xC8261B, 1.6)
        f.oval(16, 40, 30, 8, 0x4A3524)
        f.oval(16, 37, 30, 8, 0x7A5230)
        var g = f
        g.ctx.translateBy(x: 30, y: 30)
        g.ctx.rotate(by: .radians(-0.55))
        g.rect(-2, -30, 4, 30, 0x7A5230, radius: 2)
        g.rect(-11, -4, 22, 11, 0x5A3D25, radius: 3)
        g.rect(-11, -1, 22, 3, gold)
        f.svgLine("M12 30L4 26M14 22L8 14M48 30L56 26M46 22L52 14", 0xF2711C, 2)
    }

    // MARK: Law books

    /// Two thick books standing (50 × 50) with a big § on the front one.
    static func lawBook(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 50, height: 50))
        f.oval(2, 46, 46, 4, 0x1E1E1C, 0.15)
        f.rect(30, 4, 16, 44, 0x1F3A6B, radius: 1.5)
        f.svgLine("M33 10H43M33 40H43", gold, 1.6)
        f.rect(4, 8, 28, 40, 0x7A1E1E, radius: 1.5)
        f.rect(4, 8, 5, 40, 0x5E1515)
        f.text("§", PropFont.heavy(22), gold, at: CGPoint(x: 20.5, y: 27))
        f.svgLine("M12 13H28M12 43H28", gold, 1.4)
    }

    // MARK: Evidence

    /// A small table (100 × 96) with evidence: a sealed bag with a knife and a red tag (`text`),
    /// a card with a fingerprint and a magnifier over it.
    static func evidence(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 96))
        f.oval(4, 90, 92, 6, 0x1E1E1C, 0.15)
        f.svgLine("M14 58V92M86 58V92", 0x3E4C55, 3)
        f.rect(4, 52, 92, 7, 0x8C9499, radius: 1.5)
        // Bag with a knife
        f.rect(8, 14, 40, 40, 0xE9F1F4, radius: 2)
        f.stroke(Path(roundedRect: CGRect(x: 8, y: 14, width: 40, height: 40), cornerRadius: 2), 0xB4B2A9, 1)
        f.rect(8, 14, 40, 5, 0xC8261B)
        f.svg("M16 44L34 26L37 29L19 47Z", 0xB4B2A9)
        f.svg("M34 26L40 20L43 23L37 29Z", 0x2E2117)
        f.rect(30, 40, 16, 10, 0xFAC775, radius: 1)
        f.text(p.text ?? "A12", PropFont.heavy(7), 0x1E1E1C, at: CGPoint(x: 38, y: 45.5), maxWidth: 14)
        // Fingerprint card and magnifier
        f.rect(54, 24, 36, 28, 0xFFFDF6, radius: 1.5)
        for r in stride(from: 3.0, through: 11, by: 2.6) {
            f.stroke(Path(ellipseIn: CGRect(x: 72 - r * 0.8, y: 38 - r, width: r * 1.6, height: r * 2)), 0x2F5BD3, 1)
        }
        f.ring(78, 30, 11, 0x3E4C55, 3)
        f.dot(78, 30, 9.5, 0xBCCDD6, 0.4)
        f.svgLine("M86 38L96 48", 0x3E4C55, 4.4)
    }

    // MARK: Prison window

    /// A framed picture (96 × 72): a prisoner in stripes behind bars, tally marks on the cell wall.
    static func bars(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 72))
        let r = G1BankPosters.frame(f, 96, 72, border: 0x3E4C55)
        f.rect(r, 0xB4B2A9, radius: 1.5)
        f.svgLine("M\(r.minX + 6) \(r.minY + 8)V\(r.minY + 20)M\(r.minX + 10) \(r.minY + 8)V\(r.minY + 20)M\(r.minX + 14) \(r.minY + 8)V\(r.minY + 20)M\(r.minX + 18) \(r.minY + 8)V\(r.minY + 20)M\(r.minX + 4) \(r.minY + 18)L\(r.minX + 20) \(r.minY + 10)", 0x3E4C55, 1.4)
        let x = r.midX + 6, top = r.minY + 14
        f.svg("M\(x - 13) \(r.maxY)V\(top + 30)Q\(x - 13) \(top + 20) \(x) \(top + 20)Q\(x + 13) \(top + 20) \(x + 13) \(top + 30)V\(r.maxY)Z", 0xFFFDF6)
        f.svgLine("M\(x - 13) \(top + 30)H\(x + 13)M\(x - 13) \(top + 36)H\(x + 13)M\(x - 13) \(top + 42)H\(x + 13)", 0x1E1E1C, 2.4)
        f.dot(x, top + 10, 9, 0xE8C4A0)
        f.svgLine("M\(x - 4) \(top + 15)Q\(x) \(top + 12) \(x + 4) \(top + 15)", 0x8C5A3C, 1.2)
        f.dot(x - 3.5, top + 9, 1.1, 0x2E2117)
        f.dot(x + 3.5, top + 9, 1.1, 0x2E2117)
        var bars = ""
        for bx in stride(from: r.minX + 26, to: r.maxX - 2, by: 9) { bars += "M\(bx) \(r.minY)V\(r.maxY)" }
        f.svgLine(bars, 0x3E4C55, 3)
        f.svgLine("M\(r.minX + 24) \(r.minY + 3)H\(r.maxX)M\(r.minX + 24) \(r.maxY - 3)H\(r.maxX)", 0x3E4C55, 3)
    }

    // MARK: Case file

    /// A thick file on a lectern (98 × 66): on its cover two faces glare at each other across a
    /// lightning bolt, with the two names (`lines`).
    static func caseFile(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 98, height: 66))
        f.svg("M30 66L36 36H62L68 66Z", 0x5A3D25)
        f.svg("M6 36L14 6H86L92 36Z", 0x1E1E1C, 0.15)
        f.svg("M4 34L12 2H84L90 34Z", 0xE0A93A)
        f.svg("M4 34L12 2H84L90 34Z", 0xFFFFFF, 0.1)
        f.rect(4, 34, 86, 4, 0xB08A2E)
        f.svg("M22 0H40L42 4H20Z", 0xE0A93A)
        let left = PalaceFigures.Look.at(0), right = PalaceFigures.Look.at(3)
        f.dot(28, 16, 7, left.skin)
        f.svgLine("M30 13L34 15M24 13L28 15", 0x2E2117, 1.2)
        f.svgLine("M27 21H32", 0x8C5A3C, 1.2)
        f.dot(66, 16, 7, right.skin)
        f.svgLine("M64 15L68 13M60 15L64 13", 0x2E2117, 1.2)
        f.svgLine("M62 21H67", 0x8C5A3C, 1.2)
        f.svg("M49 4L43 17H48L45 28L54 13H49L52 4Z", 0xC8261B)
        let names = p.lines ?? ["Smit", "Jansen"]
        if names.count > 1 {
            f.text(names[0], PropFont.heavy(7), 0x412402, at: CGPoint(x: 26, y: 30), maxWidth: 30)
            f.text(names[1], PropFont.heavy(7), 0x412402, at: CGPoint(x: 68, y: 30), maxWidth: 30)
        }
    }

    // MARK: Through red

    /// A photo on an easel (100 × 96): a traffic light on red, a cyclist riding straight past it.
    static func redLight(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 96))
        f.svgLine("M22 96L36 54M78 96L64 54M50 60V96", 0x7A5230, 3)
        f.rect(4, 2, 92, 62, 0x1E1E1C, radius: 2, 0.15)
        f.rect(2, 0, 92, 62, 0xFFFDF6, radius: 2)
        f.rect(6, 4, 84, 54, 0xD3E0E6)
        f.rect(6, 44, 84, 14, 0x8C9499)
        f.svgLine("M10 51H22M32 51H44M54 51H66M76 51H88", 0xFFFDF6, 2)
        f.rect(16, 30, 3, 16, 0x3E4C55)
        f.rect(10, 6, 15, 28, 0x232B3B, radius: 3)
        f.dot(17.5, 12, 4, 0xE33B2E)
        f.dot(17.5, 12, 6.5, 0xE33B2E, 0.25)
        f.dot(17.5, 21, 3.4, 0x5E4A2A)
        f.dot(17.5, 29, 3.4, 0x2F4B3A)
        G1Police.bike(f, x: 38, y: 24, colour: 0x2F5BD3, dashed: false)
        let v = PalaceFigures.Look.at(3)
        f.svgLine("M58 30L64 18L70 22", v.coat, 5)
        f.svgLine("M59 30L56 38L62 40", v.trousers, 3.4)
        f.dot(66, 13, 4.6, v.skin)
        f.svg("M61.6 12C61.6 8 70.4 8 70.4 12C68 10.6 64 10.6 61.6 12Z", v.hair)
        f.svgLine("M28 26H36M26 32H35M30 38H36", 0x5E6B73, 1.4)
    }
}
