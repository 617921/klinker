import SwiftUI

/// People and papers on the town hall square: a march, the mayor, a polling card in a hand, a
/// ballot being filled in, someone speaking up for another, and an "equal" poster.
enum G8SquarePeople {
    typealias Look = PalaceFigures.Look

    // MARK: March

    /// Five people marching to the right (136 × 92): the two in front carry a long banner with
    /// the first two `icons`, two behind hold up placards with the others.
    static func march(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 136, height: 92))
        let icons = (p.icons ?? ["heart", "globe", "house"]).compactMap(PalaceIcon.init(rawValue:))
        G8Props.shadow(f, 2, 86, 132)
        for (i, x) in [18.0, 46, 100].enumerated() {
            let s: CGFloat = 1.08
            let feet: CGFloat = 84
            if i < 2 {
                f.svgLine("M\(x + 8) \(feet - 34)V14", 0x9A6A42, 1.6)
                f.rect(x - 4, 6, 24, 18, 0xFFFDF6, radius: 1)
                f.stroke(Path(roundedRect: CGRect(x: x - 4, y: 6, width: 24, height: 18), cornerRadius: 1), 0x1E1E1C, 0.8)
                if icons.count > 2 + i {
                    icons[2 + i].draw(f, in: CGRect(x: x + 1, y: 8, width: 14, height: 14), color: i == 0 ? 0xC8261B : 0x0F6E56, detail: 0xFFFDF6)
                }
            }
            let box = CGRect(x: x - 15 * s, y: feet - 60 * s, width: 30 * s, height: 60 * s)
            PalaceFigures.mini(f.within(box, unit: s), Look.at(i * 2 + 1), walking: true, briefcase: false)
            if i < 2 { f.svgLine("M\(x + 3) \(feet - 44)L\(x + 8) \(feet - 34)", Look.at(i * 2 + 1).coat, 3.4) }
        }
        // The banner, carried by the two in front.
        let cloth = CGRect(x: 62, y: 28, width: 62, height: 24)
        f.svgLine("M62 26V64M124 26V64", 0x9A6A42, 1.8)
        f.rect(cloth, 0xFFFDF6)
        f.stroke(Path(cloth.insetBy(dx: 1.5, dy: 1.5)), 0xC8261B, 1.2)
        for (k, icon) in icons.prefix(2).enumerated() {
            icon.draw(f, in: CGRect(x: cloth.minX + 10 + CGFloat(k) * 26, y: cloth.minY + 3, width: 18, height: 18),
                      color: k == 0 ? 0xC8261B : 0x2F5BD3, detail: 0xFFFDF6)
        }
        for (i, x) in [72.0, 118].enumerated() {
            let s: CGFloat = 1.2
            let box = CGRect(x: x - 15 * s, y: 90 - 60 * s, width: 30 * s, height: 60 * s)
            PalaceFigures.mini(f.within(box, unit: s), Look.at(i * 3 + 4), walking: true, briefcase: false)
            f.svgLine("M\(x - 2) \(90 - 44 * s)L\(x - 10 + CGFloat(i) * 16) 58", Look.at(i * 3 + 4).coat, 3.6)
            f.dot(x - 10 + CGFloat(i) * 16, 58, 2.2, Look.at(i * 3 + 4).skin)
        }
    }

    // MARK: Mayor

    /// The mayor (64 × 114): dark suit, the gold chain of office over the shoulders with a big
    /// medallion, grey hair, waving. `variant` the skin.
    static func mayor(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 64, height: 114))
        let v = Look.at(p.variant ?? 0)
        let suit: UInt32 = 0x232B3B, gold: UInt32 = 0xC9A15B
        f.oval(6, 106, 56, 6, 0x1E1E1C, 0.16)
        f.svgLine("M17 84V104M27 84V104", suit, 5)
        f.svg("M12 103H21V108H12Z M23 103H32V108H23Z", 0x1E1E1C)
        f.svg("M9 88L10.5 44C11.5 36 15.5 32 22 32C28.5 32 32.5 36 33.5 44L35 88Z", suit)
        f.svg("M17 32L22 42L27 32Z", 0xFFFDF6)
        f.svg("M21 34H23L23.8 44L22 46.5L20.2 44Z", 0x7A1E1E)
        f.svgLine("M13 42C10 52 10 62 12 70", 0x1A2130, 6)
        f.dot(12.5, 72, 3.1, v.skin)
        f.svgLine("M11 37Q22 70 33 37", gold, 2.6)
        f.svgLine("M14.5 34.5Q22 54 29.5 34.5", gold, 1.8)
        var links = ""
        for t in stride(from: 0.1, through: 0.9, by: 0.1) {
            let x = 11 + 22 * t
            let y = 37 + 4 * 16.5 * t * (1 - t) * 1.0
            links += "M\(x - 1.1) \(y)a1.1 1.1 0 1 0 2.2 0a1.1 1.1 0 1 0 -2.2 0Z"
        }
        f.svg(links, 0xE8C47A)
        f.dot(22, 57, 6, gold)
        f.dot(22, 57, 4, 0xE8C47A)
        f.svg("M19.6 54.6H24.4V57.6Q24.4 60 22 60.8Q19.6 60 19.6 57.6Z", 0xC8261B)
        f.dot(22, 19, 11, v.skin)
        f.svg("M11 18C10 10 15 6 22 6C29 6 34 10 33 18C31 13 27 11.5 22 11.5C17 11.5 13 13 11 18Z", 0xB4B2A9)
        f.dot(28, 19.5, 1.3, 0x2E2117)
        f.svgLine("M25.5 24.5Q28.5 27 31.5 24", 0x8C5A3C, 1.3)
        f.svgLine("M31 41C37 37 40 31 41 23", suit, 6)
        f.svg("M38 22C37 17 39 13 42 13C45 13 46 16 45 20L44 24H39Z", v.skin)
        f.svgLine("M39 15V11M41.4 14V9.6M43.8 14.6V10.6", v.skin, 1.8)
    }

    // MARK: Polling card

    /// A card held in a hand (86 × 72): a coloured header (`tone`, default orange) with `icons`
    /// and `caption`, printed `lines`, a barcode.
    static func pollCard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 86, height: 72))
        let band = PalaceLivingProps.tone(p.tone ?? "orange")
        f.svgLine("M92 80L70 58", 0x2F5BD3, 12)
        f.oval(56, 42, 20, 15, 0xE8C4A0)
        f.rect(5, 9, 66, 46, 0x1E1E1C, radius: 3, 0.16)
        f.rect(3, 6, 66, 46, 0xFFFDF6, radius: 3)
        f.svg("M6 6H66Q69 6 69 9V19H3V9Q3 6 6 6Z", band)
        if let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first {
            icon.draw(f, in: CGRect(x: 6, y: 7, width: 11, height: 11), color: 0xFFFDF6, detail: band)
        }
        if let caption = p.caption {
            f.text(caption, PropFont.heavy(8), 0xFFFDF6, at: CGPoint(x: 20, y: 12.8), anchor: .leading, maxWidth: 46)
        }
        for (i, line) in (p.lines ?? []).prefix(2).enumerated() {
            f.text(line, PropFont.demi(8), 0x1E1E1C, at: CGPoint(x: 7, y: 27 + CGFloat(i) * 10), anchor: .leading, maxWidth: 58)
        }
        var bars = ""
        for (k, w) in [1.2, 0.6, 1.6, 0.6, 1, 1.8, 0.6, 1.2, 0.8, 1.6, 0.6, 1.2].enumerated() {
            let x = 8 + Double(k) * 2.6
            bars += "M\(x) 42h\(w)v7h-\(w)Z"
        }
        f.svg(bars, 0x1E1E1C)
        f.svgLine("M64 52L59 45", 0xE8C4A0, 4.4)
    }

    // MARK: Ballot

    /// A ballot paper (104 × 82): three numbered lists with a column of boxes each, a hand
    /// colouring box `highlight` (default 7) red with a red pencil.
    static func ballot(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 104, height: 82))
        f.rect(4, 7, 86, 74, 0x1E1E1C, radius: 1, 0.15)
        f.rect(2, 4, 86, 74, 0xFFFDF6, radius: 1)
        let chosen = p.highlight ?? 7
        var target = CGPoint.zero
        for col in 0..<3 {
            let x = 6 + CGFloat(col) * 27.5
            f.rect(x, 8, 24, 10, 0x1E1E1C)
            f.text("\(col + 1)", PropFont.heavy(7.5), 0xFFFDF6, at: CGPoint(x: x + 12, y: 13.4))
            for row in 0..<5 {
                let y = 23 + CGFloat(row) * 10.6
                let box = CGRect(x: x + 1, y: y, width: 7, height: 7)
                let hit = col * 5 + row == chosen
                f.rect(box, hit ? 0xC8261B : 0xFFFDF6)
                f.stroke(Path(box), 0x1E1E1C, 0.8)
                f.rect(x + 10, y + 2.4, 13 - CGFloat((row + col) % 3) * 2, 2, 0xB4B2A9)
                if hit { target = CGPoint(x: box.midX, y: box.midY) }
            }
        }
        let tip = CGPoint(x: target.x + 2, y: target.y - 1)
        let end = CGPoint(x: tip.x + 34, y: tip.y - 30)
        f.line(tip.x + 6, tip.y - 5.3, end.x, end.y, 0xC8261B, 4.6, round: false)
        f.svg("M\(tip.x) \(tip.y)L\(tip.x + 4.4) \(tip.y - 7.4)L\(tip.x + 7.6) \(tip.y - 3.2)Z", 0xE8D6A8)
        f.svg("M\(tip.x) \(tip.y)L\(tip.x + 1.6) \(tip.y - 2.7)L\(tip.x + 2.8) \(tip.y - 1.2)Z", 0x1E1E1C)
        f.svgLine("M\(end.x + 14) \(end.y - 16)L\(end.x + 2) \(end.y - 2)", 0x0F6E56, 11)
        f.svg("M\(end.x - 10) \(end.y + 4)C\(end.x - 12) \(end.y - 2) \(end.x - 6) \(end.y - 8) \(end.x) \(end.y - 7)L\(end.x + 6) \(end.y - 2)C\(end.x + 6) \(end.y + 4) \(end.x) \(end.y + 9) \(end.x - 5) \(end.y + 8)Z", 0xE8C4A0)
    }

    // MARK: Speaking up for someone

    /// Someone standing up for another person (96 × 114): one arm held out in front of a
    /// smaller person behind them, the other hand holding a megaphone, sound coming out.
    static func megaphone(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 114))
        let v = Look.at(p.variant ?? 1)
        G8Props.shadow(f, 0, 106, 70)
        let s: CGFloat = 0.92
        PalaceFigures.mini(f.within(CGRect(x: 16 - 15 * s, y: 110 - 60 * s, width: 30 * s, height: 60 * s), unit: s),
                           Look.at(5), walking: false, briefcase: false)
        let dark = PalaceInk.shade(v.coat, 0.78)
        f.svgLine("M45 84V104M55 84V104", v.trousers, 5)
        f.svg("M40 103H49V108H40Z M51 103H60V108H51Z", 0x2E2117)
        f.svg("M37 88L38.5 44C39.5 36 43.5 32 50 32C56.5 32 60.5 36 61.5 44L63 88Z", v.coat)
        f.svgLine("M50 40V86", dark, 1.2)
        f.svg("M45 32L50 39L55 32Z", 0xEFEBE2)
        f.svgLine("M41 43C37 56 32 70 27 78", dark, 6)
        f.svg("M28 73C24 72 21 74 21 78C21 82 24 84 28 83Z", v.skin)
        f.svgLine("M22 74.6H18M21.4 77.4H17M22 80.2H18", v.skin, 1.8)
        f.dot(50, 19, 11, v.skin)
        f.svg("M39 18C38 10 43 6 50 6C57 6 62 10 61 18C59 13 55 11.5 50 11.5C45 11.5 41 13 39 18Z", v.hair)
        f.dot(56, 18.5, 1.3, 0x2E2117)
        f.svgLine("M59 41C64 40 66 36 66 31", v.coat, 6)
        f.dot(66, 30, 3.4, v.skin)
        f.svg("M59 18L82 8V38L59 28Z", 0xF4F1EA)
        f.svg("M77 10.2L82 8V38L77 35.8Z", 0xC8261B)
        f.rect(56.5, 18.5, 4, 9, 0xD3D1C7, radius: 1)
        f.svgLine("M86 15Q91 23 86 31M90 9Q98 23 90 37", 0xF2711C, 2)
    }

    // MARK: Equal

    /// A notice board on a post (86 × 100) with a poster: two different people of the same size
    /// side by side on one line, a big red equals sign between them.
    static func equal(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 86, height: 100))
        G8Props.shadow(f, 26, 95, 34, 5)
        f.rect(40, 66, 6, 32, 0x5E6B73)
        f.rect(3, 4, 82, 66, 0x1E1E1C, radius: 2, 0.15)
        f.rect(2, 2, 82, 66, 0x6B4A2E, radius: 2)
        f.rect(7, 7, 72, 56, 0xFFFDF6)
        f.rect(11, 56, 64, 2, 0xB4B2A9)
        f.svg("M14 56V41Q14 33 23 33Q32 33 32 41V56Z", 0x0F6E56)
        f.dot(23, 24, 7, 0x8C5A3C)
        f.svg("M15.5 25C14 16 18 13.5 23 13.5C28 13.5 32 16 30.5 25C30 30 32 33 32.5 34C28 32 29 23 23 20C17 23 18 32 13.5 34C14 33 16 30 15.5 25Z", 0x1E1E1C)
        f.svg("M54 56V41Q54 33 63 33Q72 33 72 41V56Z", 0x2F5BD3)
        f.dot(63, 24, 7, 0xF1D3B8)
        f.svg("M56 23C55.5 17 58.5 15 63 15C67.5 15 70.5 17 70 23C68.5 20 66 19.2 63 19.2C60 19.2 57.5 20 56 23Z", 0xC9A15B)
        f.rect(36, 34, 14, 4.4, 0xC8261B, radius: 1)
        f.rect(36, 42, 14, 4.4, 0xC8261B, radius: 1)
    }
}
