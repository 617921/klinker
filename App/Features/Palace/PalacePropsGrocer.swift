import SwiftUI

/// Supermarket props: paying, weighing, offers and dates. Each draws at a design size and
/// scales to its frame, standing on the bottom edge.
enum PalaceGrocer {
    // MARK: Paying

    /// A card terminal (64 × 62): a bank card in its slot, the amount (`text`) on the screen and
    /// a finger on the green key.
    static func cardTerminal(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 64, height: 62))
        f.oval(10, 57, 44, 5, 0x1E1E1C, 0.14)
        f.svg("M22 59L26 50H38L42 59Z", 0x3E4C55)
        f.rect(22, 0, 20, 16, 0x2F5BD3, radius: 2)
        f.rect(25, 3, 5, 4, 0xC9A15B, radius: 1)
        f.svgLine("M25 11H38", 0xA9C0F0, 1.2)
        f.rect(15, 10, 34, 44, 0x2E3A42, radius: 6)
        f.rect(21, 9, 22, 3, 0x1E1E1C, radius: 1)
        f.rect(19, 15, 26, 13, 0xC9E6E2, radius: 1.5)
        f.text(p.text ?? "€ 12,50", PropFont.mono(8), 0x04342C, at: CGPoint(x: 32, y: 19.5), maxWidth: 24)
        f.text(p.caption ?? "* * * *", PropFont.mono(7), 0x04342C, at: CGPoint(x: 32, y: 25.5), maxWidth: 24)
        for r in 0..<3 {
            for c in 0..<3 { f.rect(19.5 + CGFloat(c) * 8.7, 31 + CGFloat(r) * 5, 7, 3.6, 0xB4B2A9, radius: 1) }
        }
        for (c, color) in [0xC8261B, 0xFAC775, 0x1E7A4C].enumerated() {
            f.rect(19.5 + CGFloat(c) * 8.7, 46.5, 7, 4.2, UInt32(color), radius: 1)
        }
        PalaceShopProps.reach(f, from: CGPoint(x: 66, y: 60), to: CGPoint(x: 47, y: 48), sleeve: 0x0F6E56)
        f.line(44, 48.5, 40, 48.5, 0xE8C4A0, 3)
    }

    /// A till with its receipt curling out (76 × 54): item `lines` "melk|1,15", a `caption` and a
    /// bold total (`text`), a zigzag torn edge.
    static func tillReceipt(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 54))
        f.oval(0, 50, 40, 4, 0x1E1E1C, 0.14)
        f.rect(2, 26, 34, 26, 0x5E6B73, radius: 3)
        f.rect(2, 44, 34, 8, 0x3E4C55, radius: 2)
        f.rect(6, 30, 18, 9, 0x232B3B, radius: 1)
        f.svgLine("M9 34.5H20", 0x5DCAA5, 2)
        for i in 0..<3 { f.rect(26, 29 + CGFloat(i) * 4.5, 7, 3, 0xD3D1C7, radius: 0.8) }
        f.svg("M12 26C12 10 20 3 34 3V10C26 10 21 15 21 26Z", 0xFFFDF6)
        var edge = "M32 2H74V48"
        var x: CGFloat = 74
        while x > 33 {
            edge += "L\(x - 2.5) 51L\(x - 5) 48"
            x -= 5
        }
        f.svg(edge + "L32 48Z", 0xFFFDF6)
        f.svgLine("M32 2H74V48", 0xD3D1C7, 0.8)
        let rows = Array((p.lines ?? ["melk|1,15", "brood|2,49", "kaas|4,99"]).prefix(4))
        for (i, row) in rows.enumerated() {
            let cells = row.split(separator: "|").map(String.init)
            let y = 9 + CGFloat(i) * 7
            f.text(cells.first ?? "", PropFont.mono(6), 0x3E4C55, at: CGPoint(x: 35, y: y), anchor: .leading, maxWidth: 22)
            if cells.count > 1 { f.text(cells[1], PropFont.mono(6), 0x3E4C55, at: CGPoint(x: 71, y: y), anchor: .trailing) }
        }
        let top = 9 + CGFloat(rows.count) * 7
        f.svgLine("M35 \(top - 2.5)H71", 0x3E4C55, 0.8)
        f.text(p.caption ?? "", PropFont.heavy(5.5), 0x1E1E1C, at: CGPoint(x: 35, y: top + 3), anchor: .leading, maxWidth: 13)
        f.text(p.text ?? "", PropFont.heavy(7.5), 0x1E1E1C, at: CGPoint(x: 71, y: top + 3), anchor: .trailing, maxWidth: 21)
    }

    // MARK: Weighing and produce

    /// A self-service scale (76 × 54): a bag of produce (`accessory`) on it, the weight (`text`)
    /// on its display.
    static func weighScale(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 54))
        f.oval(2, 50, 70, 4, 0x1E1E1C, 0.14)
        f.rect(4, 44, 56, 8, 0x8E9AA0, radius: 2)
        f.rect(2, 41, 60, 4, 0xD3D1C7, radius: 1.5)
        f.rect(60, 14, 5, 38, 0x5E6B73)
        f.rect(46, 2, 30, 17, 0x2E3A42, radius: 3)
        f.rect(49, 5, 24, 11, 0x232B3B, radius: 1)
        f.text(p.text ?? "0,8 kg", PropFont.mono(8), 0x5DCAA5, at: CGPoint(x: 61, y: 10.5), maxWidth: 22)
        f.svg("M10 41C6 31 10 20 16 16H40C46 20 50 31 46 41Z", 0xFFFFFF, 0.5)
        let kind = p.accessory ?? "tomato"
        for (x, y) in [(17.0, 34.0), (28, 35), (39, 34), (22, 25), (34, 25)] as [(CGFloat, CGFloat)] {
            produce(f, kind, x, y, 6)
        }
        f.svg("M10 41C6 31 10 20 16 16H40C46 20 50 31 46 41Z", 0xFFFFFF, 0.18)
        f.svgLine("M16 16C14 10 20 8 24 12M40 16C42 10 36 8 32 12", 0xFFFFFF, 1.3)
        f.svgLine("M13 22C11 28 11 34 13 39", 0xFFFFFF, 1.4)
    }

    /// One piece of produce centred at (x, y): "tomato", "apple", "carrot", "strawberry", "orange".
    static func produce(_ f: PropPen, _ kind: String, _ x: CGFloat, _ y: CGFloat, _ r: CGFloat) {
        switch kind {
        case "carrot":
            f.svgLine("M\(x - 1) \(y - r)L\(x - 4) \(y - r * 2.4)M\(x) \(y - r)L\(x) \(y - r * 2.6)M\(x + 1) \(y - r)L\(x + 4) \(y - r * 2.3)", 0x4E7A3A, 2)
            f.svg("M\(x - r * 0.8) \(y - r)H\(x + r * 0.8)L\(x) \(y + r * 1.4)Z", 0xF2711C)
            f.svgLine("M\(x - r * 0.5) \(y - r * 0.2)h\(r * 0.5)M\(x - r * 0.2) \(y + r * 0.5)h\(r * 0.4)", 0xC9580F, 1)
            f.dot(x + r * 0.3, y - r * 0.5, 0.9, 0x7A5230)
        case "strawberry":
            f.svg("M\(x - r) \(y - r * 0.5)C\(x - r) \(y + r * 0.6) \(x) \(y + r * 1.2) \(x) \(y + r * 1.2)C\(x) \(y + r * 1.2) \(x + r) \(y + r * 0.6) \(x + r) \(y - r * 0.5)Z", 0xD9381E)
            f.svg("M\(x - r * 0.9) \(y - r * 0.6)L\(x) \(y - r * 1.1)L\(x + r * 0.9) \(y - r * 0.6)L\(x) \(y - r * 0.2)Z", 0x4E7A3A)
            f.dot(x - r * 0.4, y + r * 0.1, 0.7, 0xFAC775)
            f.dot(x + r * 0.35, y + r * 0.2, 0.7, 0xFAC775)
        default:
            let body: UInt32 = kind == "apple" ? 0xC8261B : kind == "orange" ? 0xF2711C : 0xE0402A
            f.dot(x, y, r, body)
            f.dot(x - r * 0.35, y - r * 0.35, r * 0.28, 0xFFFFFF, 0.35)
            if kind == "apple" {
                f.svgLine("M\(x) \(y - r)L\(x + 1) \(y - r - 3)", 0x4A3524, 1.2)
                f.svg("M\(x + 1) \(y - r - 2)C\(x + 3) \(y - r - 5) \(x + 6) \(y - r - 4) \(x + 6) \(y - r - 3)C\(x + 4) \(y - r - 1) \(x + 2) \(y - r - 1) \(x + 1) \(y - r - 2)Z", 0x5E8C45)
            } else if kind != "orange" {
                f.svg("M\(x - 3) \(y - r + 0.5)L\(x) \(y - r - 2)L\(x + 3) \(y - r + 0.5)L\(x) \(y - r + 1.6)Z", 0x4E7A3A)
            }
        }
    }

    /// A wooden crate of produce (76 × 54): `accessory` the produce, `count` pieces (0 = empty, a
    /// few leaves left), `tone` "leaf" a green leaf badge on a stick, `text` a card on the crate.
    static func produceCrate(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 54))
        let kind = p.accessory ?? "carrot"
        let count = max(0, min(p.count ?? 7, 9))
        f.oval(2, 50, 72, 4, 0x1E1E1C, 0.14)
        f.svg("M6 24H70L68 52H8Z", 0x8C5E38)
        if count == 0 {
            f.svg("M9 26H67L66 40H10Z", 0x6B4A2E)
            f.svg("M30 38C32 33 37 33 38 37C35 39 32 39 30 38Z", 0x4E7A3A)
            f.svg("M44 39C45 35 49 35 50 38C48 40 46 40 44 39Z", 0x5E8C45)
        } else {
            let spots: [(CGFloat, CGFloat)] = [(14, 26), (26, 25), (38, 26), (50, 25), (62, 26), (20, 19), (32, 18), (44, 19), (56, 18)]
            for (x, y) in spots.prefix(count).reversed() { produce(f, kind, x, y, 6) }
        }
        f.rect(4, 30, 68, 8, 0xC9965F)
        f.rect(4, 42, 68, 8, 0xC9965F)
        f.svgLine("M4 38H72M4 50H72", 0x8C5E38, 1)
        f.rect(4, 28, 3, 24, 0xA0723F)
        f.rect(69, 28, 3, 24, 0xA0723F)
        if p.tone == "leaf" {
            f.rect(63, 8, 2.4, 26, 0x8C5E38)
            f.dot(64, 10, 10, 0x1E7A4C)
            f.ring(64, 10, 8.4, 0xFFFDF6, 1)
            f.svg("M58.5 15C58 8 63 4 70 4C70 11 66 15 58.5 15Z", 0xFFFDF6)
            f.svgLine("M58.5 15L66 8", 0x1E7A4C, 1.2)
        }
        if let text = p.text, count > 0 {
            let card = CGRect(x: 14, y: 31, width: 40, height: 15)
            f.rect(card, 0xFFFDF6, radius: 1.5)
            f.stroke(Path(roundedRect: card, cornerRadius: 1.5), 0x1E7A4C, 1)
            f.text(text, PropFont.heavy(8.5), 0x1E7A4C, at: CGPoint(x: card.midX, y: card.midY), maxWidth: 36)
        }
        if count == 0 {
            f.rect(36.8, 14, 2.4, 22, 0x8C5E38)
            let card = CGRect(x: 8, y: 0, width: 60, height: 20)
            f.rect(card.offsetBy(dx: 1, dy: 1.5), 0x1E1E1C, radius: 2, 0.15)
            f.rect(card, 0xFFFDF6, radius: 2)
            f.stroke(Path(roundedRect: card.insetBy(dx: 1.5, dy: 1.5), cornerRadius: 1.5), 0xC8261B, 1.4)
            produce(f, kind, 17, 10.5, 4.2)
            f.text(p.text ?? "", PropFont.heavy(9.5), 0xC8261B, at: CGPoint(x: 43, y: 10.5), maxWidth: 40)
            f.rect(54, 40, 14, 9, 0xFAC775, radius: 1)
            produce(f, kind, 61, 44.5, 3)
        }
    }

    // MARK: Offers

    /// Goods on a shelf with a red burst (`text` "-25%") and a price card: `lines` [old, new].
    static func priceTag(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        for i in 0..<3 {
            let x = 3 + CGFloat(i) * 13
            f.rect(x, 8, 12, 38, 0xFAC775)
            f.svg("M\(x) 8L\(x + 3) 2H\(x + 9)L\(x + 12) 8Z", 0xF2D49A)
            f.dot(x + 6, 24, 4, 0xF2711C)
            f.rect(x + 2, 34, 8, 3, 0xFFFDF6)
        }
        var burst = Path()
        for k in 0..<24 {
            let a = Double(k) * .pi / 12
            let r: Double = k % 2 == 0 ? 17 : 13
            let pt = CGPoint(x: 58 + cos(a) * r, y: 17 + sin(a) * r)
            if k == 0 { burst.move(to: pt) } else { burst.addLine(to: pt) }
        }
        burst.closeSubpath()
        f.fill(burst, 0xC8261B)
        f.text(p.text ?? "-25%", PropFont.heavy(10), 0xFFFFFF, at: CGPoint(x: 58, y: 17.5), maxWidth: 24)
        let prices = p.lines ?? ["2,49", "1,87"]
        f.rect(38, 34, 37, 14, 0xFFFDF6, radius: 1.5)
        f.rect(38, 34, 37, 3, 0xC8261B, radius: 1)
        if let old = prices.first {
            f.text(old, PropFont.demi(6.5), 0x7D8A92, at: CGPoint(x: 47, y: 42), maxWidth: 16)
            f.line(40.5, 43.5, 53.5, 40.5, 0xC8261B, 1.2)
        }
        if prices.count > 1 {
            f.text(prices[1], PropFont.heavy(8.5), 0x1E1E1C, at: CGPoint(x: 65, y: 41.5), maxWidth: 18)
        }
    }

    /// A poster taped to the glass (84 × 92): big red `text` ("1+1"), a red band with `caption`,
    /// and two of the product (`accessory`: "cheese" or a produce name).
    static func offerPoster(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 92), hanging: true)
        f.rect(4, 5, 76, 84, 0x1E1E1C, radius: 1, 0.12)
        f.rect(2, 2, 76, 84, 0xFAC775, radius: 1)
        f.stroke(Path(CGRect(x: 5, y: 5, width: 70, height: 78)), 0xC8261B, 1.6)
        f.text(p.text ?? "1+1", PropFont.heavy(27), 0xC8261B, at: CGPoint(x: 40, y: 24), maxWidth: 66)
        f.rect(5, 40, 70, 15, 0xC8261B)
        f.text(p.caption ?? "", PropFont.heavy(11), 0xFFFFFF, at: CGPoint(x: 40, y: 47.5), maxWidth: 64)
        for x in [12.0, 44] { cheese(f, x, 60) }
        f.text("+", PropFont.heavy(14), 0x1E1E1C, at: CGPoint(x: 40, y: 70))
        for (x, a) in [(2.0, -0.4), (66, 0.4)] as [(CGFloat, CGFloat)] {
            let tape = Path(CGRect(x: -7, y: -3, width: 14, height: 6))
                .applying(CGAffineTransform(rotationAngle: a).concatenating(CGAffineTransform(translationX: x + 6, y: 4)))
            f.fill(tape, 0xF4F1EA, 0.85)
        }
    }

    /// A wedge of cheese with holes (24 × 20) at (x, y).
    static func cheese(_ f: PropPen, _ x: CGFloat, _ y: CGFloat) {
        f.svg("M\(x) \(y + 8)L\(x + 24) \(y)V\(y + 20)H\(x)Z", 0xF6C744)
        f.svg("M\(x) \(y + 8)L\(x + 24) \(y)L\(x + 24) \(y + 4)L\(x) \(y + 11)Z", 0xE8A93A)
        f.dot(x + 7, y + 15, 2.2, 0xE8A93A)
        f.dot(x + 16, y + 11, 1.8, 0xE8A93A)
        f.dot(x + 19, y + 17, 1.4, 0xE8A93A)
    }
}
