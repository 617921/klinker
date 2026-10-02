import SwiftUI

/// Gym things: a row of lockers, a treadmill and a spinning bike with their riders, a card of
/// weeks ticked off on the wall, and a pass card cut in two.
enum G3Gym {
    typealias Look = PalaceFigures.Look

    // MARK: Lockers

    /// Lockers in two rows (92 × 150), `count` doors (default 6), numbered from 21. Door
    /// `highlight` stands open: a sports bag inside, the key on an orange band in the lock.
    static func lockers(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 92, height: 150))
        let n = max(2, min(p.count ?? 6, 8))
        let cols = (n + 1) / 2
        let steel: UInt32 = 0x4F7393
        let w = (84 - CGFloat(cols - 1) * 2) / CGFloat(cols), h: CGFloat = 64
        f.rect(2, 2, 88, 142, 0x1E1E1C, radius: 2, 0.14)
        f.rect(0, 0, 88, 140, 0x3E4C55, radius: 2)
        f.rect(0, 140, 88, 8, 0x2E2117, radius: 1)
        for i in 0..<n {
            let x = 2 + CGFloat(i % cols) * (w + 2), y = 3 + CGFloat(i / cols) * (h + 3)
            let open = i == p.highlight
            if open {
                f.rect(x, y, w, h, 0x232B3B)
                f.rect(x + 3, y + 30, w - 6, 26, 0xF2711C, radius: 5)
                f.svgLine("M\(x + 8) \(y + 31)Q\(x + w / 2) \(y + 20) \(x + w - 8) \(y + 31)", 0x2E2117, 1.6)
                f.svgLine("M\(x + 4) \(y + 42)H\(x + w - 4)", PalaceInk.shade(0xF2711C, 0.8), 1.2)
                // The door swung open on the right, the key hanging from its lock
                let door = "M\(x + w) \(y)L\(x + w + 9) \(y + 5)V\(y + h + 2)L\(x + w) \(y + h)Z"
                f.svg(door, PalaceInk.shade(steel, 1.15))
                f.svgLine("M\(x + w + 5.5) \(y + 26)V\(y + 36)", 0x1E1E1C, 1.4)
                f.svgLine("M\(x + w + 5.5) \(y + 36)L\(x + w + 3) \(y + 44)", 0xC9A15B, 1.6)
                f.ring(x + w + 4, y + 50, 4.6, 0xF2711C, 2)
            } else {
                f.rect(x, y, w, h, steel)
                f.svgLine("M\(x + 5) \(y + 7)H\(x + w - 5)M\(x + 5) \(y + 11)H\(x + w - 5)M\(x + 5) \(y + 15)H\(x + w - 5)", PalaceInk.shade(steel, 0.75), 1.2)
                f.rect(x + w / 2 - 6, y + 21, 12, 8, 0xFFFDF6, radius: 1)
                f.text("\(21 + i)", PropFont.heavy(6.5), 0x1E1E1C, at: CGPoint(x: x + w / 2, y: y + 25.2))
                f.dot(x + w - 6, y + 38, 2.2, 0xD3D1C7)
                f.svgLine("M\(x + w - 6) \(y + 37)V\(y + 39.5)", 0x1E1E1C, 0.9)
            }
        }
        if let open = p.highlight, open < n {
            let x = 2 + CGFloat(open % cols) * (w + 2), y = 3 + CGFloat(open / cols) * (h + 3)
            f.rect(x + w / 2 - 6, y + 4, 12, 8, 0xFFFDF6, radius: 1)
            f.text("\(21 + open)", PropFont.heavy(6.5), 0x1E1E1C, at: CGPoint(x: x + w / 2, y: y + 8.2))
        }
    }

    // MARK: Treadmill

    /// A runner on a treadmill (104 × 128); the console shows a heart and `text` ("45:00").
    static func treadmill(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 104, height: 128))
        f.oval(2, 120, 100, 7, 0x1E1E1C, 0.15)
        // Uprights, handrail and console
        f.svgLine("M86 118L80 54", 0x3E4C55, 4)
        f.svgLine("M80 62H58", 0x5E6B73, 3)
        f.rect(66, 36, 36, 22, 0x2E2117, radius: 4)
        f.rect(69, 39, 30, 15, 0x232B3B, radius: 1.5)
        PalaceIcon.heart.draw(f, in: CGRect(x: 71, y: 41, width: 10, height: 10), color: 0xC8261B, detail: 0x232B3B)
        if let text = p.text {
            f.text(text, PropFont.mono(8.5), 0x5DCAA5, at: CGPoint(x: 90.5, y: 46.5), maxWidth: 17)
        }
        // Deck and belt
        f.svg("M4 112H92Q98 112 98 118V122H4Z", 0x3E4C55)
        f.rect(8, 108, 82, 6, 0x232B3B, radius: 3)
        f.svgLine("M14 111H24M38 111H48M62 111H72", 0x5E6B73, 1.2)
        PalaceParkPeople.runner(f.within(CGRect(x: 10, y: 0, width: 62, height: 110)), PalacePropParams(variant: p.variant ?? 6))
    }

    // MARK: Spinning bike

    /// A rider bent over a spinning bike (96 × 124), red in the face, sweat flying; the display
    /// shows a heart and `text` ("180") in red. `variant` look.
    static func bike(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 124))
        let v = Look.at(p.variant ?? 3)
        f.oval(6, 116, 86, 7, 0x1E1E1C, 0.15)
        // Bike
        f.rect(14, 112, 74, 6, 0x3E4C55, radius: 2)
        f.svgLine("M30 112L42 74M42 74L70 96M42 74L68 70M68 70L70 96", 0x5E6B73, 4.5)
        f.dot(72, 96, 15, 0x3E4C55)
        f.ring(72, 96, 10, 0x5E6B73, 1.6)
        f.dot(72, 96, 3, 0xB4B2A9)
        f.svgLine("M42 74L38 58", 0x5E6B73, 3.5)
        f.rect(28, 54, 20, 5, 0x1E1E1C, radius: 2.5)
        f.svgLine("M68 70L72 50M66 47H82", 0x5E6B73, 3)
        f.rect(70, 30, 24, 15, 0x2E2117, radius: 3)
        f.rect(72, 32, 20, 11, 0x232B3B, radius: 1)
        PalaceIcon.heart.draw(f, in: CGRect(x: 73, y: 33, width: 8, height: 8), color: 0xC8261B, detail: 0x232B3B)
        if let text = p.text {
            f.text(text, PropFont.mono(8), 0xF2711C, at: CGPoint(x: 87, y: 37.8), maxWidth: 11)
        }
        // Rider: far leg, body bent forward, near leg pushing down
        f.svgLine("M40 56L56 66L52 88", PalaceInk.shade(v.skin, 0.8), 5)
        f.svg("M32 50H48L50 62H34Z", v.trousers)
        f.svg("M34 54L50 30C53 26 58 25 61 28C64 31 63 35 60 38L44 58Z", v.coat)
        f.svgLine("M58 32L72 46", v.skin, 4.6)
        f.dot(73, 47, 3, v.skin)
        f.svgLine("M44 58L60 72L66 92", v.skin, 5.5)
        f.svg("M62 90H72V95H60Z", 0xFFFDF6)
        f.dot(66, 21, 9.5, v.skin)
        f.svg("M57 19C57 12 61 10 66 10C71 10 75 13 75 18C72 15 69 14.5 66 14.5C62 14.5 59 16 57 19Z", v.hair)
        f.svgLine("M57.4 17Q66 12.6 75 16", 0xC8261B, 2.6)
        f.dot(68, 25, 2.6, 0xE06A5A, 0.7)
        f.dot(71, 21, 1.2, 0x2E2117)
        f.oval(71, 25.5, 3.4, 3, 0x8C5A3C)
        for (x, y, s) in [(80.0, 6.0, 6.0), (84.0, 17.0, 5.0), (52.0, 6.0, 5.5), (48.0, 18.0, 4.5)] as [(CGFloat, CGFloat, CGFloat)] {
            G3Body.sweat(f, x, y, s)
        }
        f.svgLine("M77 12L81 10M46 13L42 11", 0x8FB6CF, 1.2)
    }

    // MARK: Streak card

    /// A card on the wall (92 × 84): columns for the day `labels` ("ma", "wo", "vr"), six weeks
    /// down; the first `count` weeks have a green tick every day, a gold cup waits at the end.
    static func streak(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 92, height: 84))
        f.rect(2, 3, 90, 81, 0x1E1E1C, radius: 3, 0.14)
        f.rect(0, 0, 90, 80, 0xFFFDF6, radius: 3)
        f.rect(0, 0, 90, 13, 0x1E7A4C, radius: 3)
        let days = p.labels ?? ["ma", "wo", "vr"]
        let cols = CGFloat(max(1, days.count))
        let cw = 54 / cols
        for (i, day) in days.enumerated() {
            f.text(day, PropFont.heavy(7.5), 0xFFFDF6, at: CGPoint(x: 18 + cw * (CGFloat(i) + 0.5), y: 6.8), maxWidth: cw)
        }
        let weeks = 6, done = max(0, min(p.count ?? 5, weeks))
        for r in 0..<weeks {
            let y = 16 + CGFloat(r) * 7.7
            f.text("\(r + 1)", PropFont.mono(6), 0x5E6B73, at: CGPoint(x: 9, y: y + 3.4))
            for c in 0..<days.count {
                let cx = 18 + cw * (CGFloat(c) + 0.5)
                if r < done {
                    f.svgLine("M\(cx - 3) \(y + 3.4)L\(cx - 0.8) \(y + 5.6)L\(cx + 3.4) \(y + 0.8)", 0x1E7A4C, 1.6)
                } else {
                    f.stroke(Path(CGRect(x: cx - 2.6, y: y + 0.6, width: 5.2, height: 5.2)), 0xB4B2A9, 0.8)
                }
            }
        }
        // The cup at the end of the weeks
        f.svg("M74 34H86V40Q86 47 80 47Q74 47 74 40Z", 0xD9A440)
        f.svgLine("M74 36Q70 36 71 40Q72 43 75 43M86 36Q90 36 89 40Q88 43 85 43", 0xD9A440, 1.4)
        f.rect(78.5, 47, 3, 5, 0xD9A440)
        f.rect(75, 52, 10, 3.4, 0x7A5230, radius: 1)
        f.svgLine("M80 30V20M80 20L76 23M80 20L84 23", 0x1E7A4C, 1.6)
    }

    // MARK: Cut card

    /// A pass card (`caption` on its band) cut in two by a pair of scissors, the halves
    /// drifting apart, a letter behind it (94 × 76).
    static func cutCard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 94, height: 76))
        let look = Look.at(p.variant ?? 1)
        // The letter
        f.rect(4, 4, 46, 60, 0x1E1E1C, radius: 1, 0.14)
        f.rect(2, 2, 46, 60, 0xFFFDF6, radius: 1)
        f.rect(2, 2, 46, 8, 0xC8261B, radius: 1)
        f.svgLine("M7 16H40M7 21H43M7 26H36M7 31H41", 0xD3D1C7, 1.3)
        f.svgLine("M8 44C11 38 13 47 16 41C18 38 19 45 23 43", 0x2F5BD3, 1.2)
        // The two halves of the card
        let card = CGRect(x: 26, y: 30, width: 56, height: 36)
        for (half, dx, dy, turn) in [(0, -3.0, 2.0, -5.0), (1, 4.0, -2.0, 6.0)] as [(Int, CGFloat, CGFloat, Double)] {
            var piece = f
            piece.ctx.translateBy(x: card.midX + dx, y: card.midY + dy)
            piece.ctx.rotate(by: .degrees(turn))
            piece.ctx.translateBy(x: -card.midX, y: -card.midY)
            let cut = half == 0 ? "M20 20H57L51 80H20Z" : "M57 20H90V80H51Z"
            piece.ctx.clip(to: PalaceSVG.path(cut))
            piece.rect(card.offsetBy(dx: 1.5, dy: 2), 0x1E1E1C, radius: 3, 0.16)
            piece.rect(card, 0xFFFDF6, radius: 3)
            piece.rect(card.minX, card.minY, card.width, 9, 0xF2711C, radius: 3)
            if let caption = p.caption {
                piece.text(caption, PropFont.heavy(7), 0xFFFDF6, at: CGPoint(x: card.midX, y: card.minY + 4.8), maxWidth: 46)
            }
            piece.rect(card.minX + 5, card.minY + 13, 13, 17, 0xD3E0E6, radius: 1)
            piece.dot(card.minX + 11.5, card.minY + 19, 3.6, look.skin)
            piece.svg("M\(card.minX + 6) \(card.minY + 30)Q\(card.minX + 6) \(card.minY + 24) \(card.minX + 11.5) \(card.minY + 24)Q\(card.minX + 17) \(card.minY + 24) \(card.minX + 17) \(card.minY + 30)Z", look.coat)
            piece.svgLine("M\(card.minX + 22) \(card.minY + 16)H\(card.maxX - 6)M\(card.minX + 22) \(card.minY + 22)H\(card.maxX - 14)M\(card.minX + 22) \(card.minY + 28)H\(card.maxX - 10)", 0xB4B2A9, 1.6)
        }
        // Scissors closing on the cut
        f.svgLine("M62 22L55 42M62 22L60 44", 0x9A9890, 2.4)
        f.svgLine("M62 22L66 13M62 22L70 17", 0xC8261B, 2.2)
        f.ring(67, 9, 4.4, 0xC8261B, 2.4)
        f.ring(74, 15, 4.4, 0xC8261B, 2.4)
        f.dot(62, 22, 1.4, 0x5E6B73)
    }
}
