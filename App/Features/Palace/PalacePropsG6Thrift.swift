import SwiftUI

/// Second-hand shop props on shelves and the counter: the shop's round sign, a bay of odds and
/// ends, a dinner set, a bargain, a chest with a condition tag and a cracked vase.
enum G6Thrift {
    // MARK: Sign

    /// A round sign on two strings (84 × 92): two arrows chase each other around a chair, a lamp
    /// and a shirt; `text` on a band below.
    static func cycleSign(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 92), hanging: true)
        let c = CGPoint(x: 42, y: 44)
        f.svgLine("M24 0L30 12M60 0L54 12", 0x2E2117, 1.2)
        f.dot(c.x + 1, c.y + 2, 36, 0x1E1E1C, 0.15)
        f.dot(c.x, c.y, 36, 0x0F6E56)
        f.dot(c.x, c.y, 32, 0xFFFDF6)
        for start in [-0.35, Double.pi - 0.35] {
            var arc = Path()
            arc.addArc(center: c, radius: 25, startAngle: .radians(start), endAngle: .radians(start + 2.45), clockwise: false)
            f.stroke(arc, 0x1E7A4C, 5)
            let end = start + 2.45
            let tip = CGPoint(x: c.x + cos(end + 0.2) * 25, y: c.y + sin(end + 0.2) * 25)
            let a = CGPoint(x: c.x + cos(end) * 31.5, y: c.y + sin(end) * 31.5)
            let b = CGPoint(x: c.x + cos(end) * 18.5, y: c.y + sin(end) * 18.5)
            var head = Path()
            head.move(to: tip)
            head.addLine(to: a)
            head.addLine(to: b)
            head.closeSubpath()
            f.fill(head, 0x1E7A4C)
        }
        // chair, lamp, shirt
        f.svg("M27 36H33V46H27Z", 0x8C5E38)
        f.svgLine("M26 46H35M27 46V55M34 46V55", 0x8C5E38, 2)
        f.svg("M38 34H48L50 41H36Z", 0xF2B33D)
        f.svgLine("M43 41V53M39 53.5H47", 0x5E6B73, 1.8)
        f.svg("M52 38L56 36H60L64 38L62 42L60 41V52H56V41L54 42Z", 0xC8261B)
        if let text = p.text {
            f.rect(14, 70, 56, 16, 0xC8261B, radius: 2)
            f.text(text, PropFont.heavy(11), 0xFFFDF6, at: CGPoint(x: 42, y: 78.5), maxWidth: 52)
        }
    }

    // MARK: Odds and ends

    /// A shelf bay (76 × 50) crammed with mixed old things.
    static func jumble(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        // books lying and standing
        f.rect(0, 40, 22, 5, 0x3C3489)
        f.rect(1, 35, 20, 5, 0x0F6E56)
        f.rect(2, 16, 5, 19, 0xC8261B)
        f.rect(7, 19, 5, 16, 0xFAC775)
        f.svg("M12 20L17 18L21 34L16 35Z", 0x2F5BD3)
        // mantel clock
        f.svg("M22 50V30Q30 18 38 30V50Z", 0x7A5230)
        f.dot(30, 35, 6, 0xFFFDF6)
        f.svgLine("M30 35V31M30 35L33 36.5", 0x1E1E1C, 1)
        // vase with a flower
        f.svg("M40 50C36 44 38 36 42 32V27H47V32C51 36 53 44 49 50Z", 0xA9CBE0)
        f.svgLine("M44.5 27Q44 18 47 12", 0x5E8C45, 1.3)
        f.dot(47.5, 11, 3, 0xF2711C)
        // teddy
        f.oval(53, 32, 16, 18, 0xB97A3E)
        f.dot(61, 27, 7, 0xB97A3E)
        f.dot(56, 21.5, 2.6, 0xB97A3E)
        f.dot(66, 21.5, 2.6, 0xB97A3E)
        f.dot(58.5, 26, 1, 0x2E2117)
        f.dot(63.5, 26, 1, 0x2E2117)
        f.oval(59, 28.5, 4, 3, 0xE2B47A)
        // radio peeking at the edge
        f.rect(66, 36, 10, 14, 0x5E6B73, radius: 1.5)
        f.dot(71, 42, 3, 0x3E4C55)
        f.svgLine("M68 36L64 26", 0x8E9AA0, 1)
    }

    // MARK: Dinner set

    /// A matching dinner set (76 × 50): a stack of plates, two cups on saucers and a teapot,
    /// all with the same band (`tone`: "blue" | "red" | "green").
    static func crockery(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        let band: UInt32 = switch p.tone { case "red": 0xC8261B; case "green": 0x0F6E56; default: 0x2F5BD3 }
        // plates on edge in a rack, then a stack
        for i in 0..<3 {
            let x = 2 + CGFloat(i) * 6
            f.oval(x, 10, 16, 36, 0xFFFDF6)
            f.stroke(Path(ellipseIn: CGRect(x: x, y: 10, width: 16, height: 36)), 0xB4B2A9, 0.8)
            f.stroke(Path(ellipseIn: CGRect(x: x + 3, y: 15, width: 10, height: 26)), band, 1.4)
        }
        for i in 0..<4 {
            let y = 46 - CGFloat(i) * 3.4
            f.oval(26, y - 2, 22, 5, 0xFFFDF6)
            f.svgLine("M27 \(y + 0.5)Q37 \(y + 3.5) 47 \(y + 0.5)", band, 1)
        }
        // cup on a saucer
        f.oval(26, 30, 22, 4, 0xFFFDF6)
        f.svg("M30 21H44L42 31H32Z", 0xFFFDF6)
        f.rect(30.5, 23, 13, 2.4, band)
        f.svgLine("M44 23Q49 24 43 29", 0xFFFDF6, 1.8)
        // teapot
        f.svg("M52 50C50 40 54 32 63 32C72 32 76 40 74 50Z", 0xFFFDF6)
        f.stroke(PalaceSVG.path("M52 50C50 40 54 32 63 32C72 32 76 40 74 50Z"), 0xB4B2A9, 0.8)
        f.rect(52, 40, 22, 3, band)
        f.svg("M52 42L45 34L47 33L54 39Z", 0xFFFDF6)
        f.svgLine("M73.5 37Q78 40 73 46", 0xFFFDF6, 2)
        f.oval(59, 28.5, 8, 4, 0xFFFDF6)
        f.dot(63, 28, 1.8, band)
    }

    // MARK: Bargain

    /// A fine gilt clock (76 × 50) with a tiny price tag (`text`) on a string, sparkles and a thumb up.
    static func bargain(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        f.svg("M8 50V24Q24 4 40 24V50Z", 0xC9A15B)
        f.svg("M11 50V25Q24 9 37 25V50Z", 0xE8CF8E)
        f.dot(24, 30, 9, 0xFFFDF6)
        f.ring(24, 30, 9, 0x7A5230, 1.2)
        f.svgLine("M24 30V24M24 30L28.5 32", 0x1E1E1C, 1.3)
        f.rect(5, 46, 38, 4, 0x7A5230, radius: 1)
        G6Props.sparkle(f, 6, 12, 4.5)
        G6Props.sparkle(f, 42, 8, 3.5)
        // tag on a string from the clock's top
        f.svgLine("M30 13Q40 14 44 20", 0x7A5230, 0.9)
        let tag = Path(roundedRect: CGRect(x: 0, y: 0, width: 30, height: 18), cornerRadius: 2)
            .applying(CGAffineTransform(rotationAngle: 0.18).concatenating(CGAffineTransform(translationX: 43, y: 17)))
        f.fill(tag, 0xFAC775)
        f.stroke(tag, 0xC8261B, 1)
        if let text = p.text {
            var t = f
            t.ctx.translateBy(x: 57, y: 28)
            t.ctx.rotate(by: .radians(0.18))
            t.text(text, PropFont.heavy(11), 0xC8261B, at: .zero, maxWidth: 26)
        }
        // thumb up
        f.svg("M56 50V42H60L63 34Q66 33 66 37L65 41H72Q75 42 73.5 45L71.5 50Z", 0xE8C4A0)
        f.rect(52, 41, 5, 9, 0x1F3A6B, radius: 1)
    }

    // MARK: Condition

    /// A chest of drawers (84 × 58) with a hanging tag: a gauge from red to green, the needle
    /// at `highlight` (0 bad, 1 fair, 2 good), `text` under it.
    static func condition(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 58))
        f.rect(4, 14, 48, 42, 0x9A6A42, radius: 2)
        f.rect(2, 11, 52, 5, 0x7A5230, radius: 1.5)
        for y in [19.0, 31, 43] as [CGFloat] {
            f.rect(8, y, 40, 10, 0xB27E52, radius: 1)
            f.dot(28, y + 5, 1.6, 0xE8CF8E)
        }
        f.svgLine("M44 13Q52 10 56 16", 0x5E6B73, 0.9)
        f.rect(52, 14, 32, 40, 0xFFFDF6, radius: 2)
        f.stroke(Path(roundedRect: CGRect(x: 52, y: 14, width: 32, height: 40), cornerRadius: 2), 0xB4B2A9, 0.8)
        let c = CGPoint(x: 68, y: 36)
        let colours: [UInt32] = [0xC8261B, 0xFAC775, 0x1E7A4C]
        for i in 0..<3 {
            var arc = Path()
            let a0 = Double.pi + Double(i) * .pi / 3
            arc.addArc(center: c, radius: 11, startAngle: .radians(a0 + 0.04), endAngle: .radians(a0 + .pi / 3 - 0.04), clockwise: false)
            f.stroke(arc, colours[i], 5, round: false)
        }
        let level = Double(max(0, min(2, p.highlight ?? 2)))
        let angle = Double.pi + (level + 0.5) * .pi / 3
        f.line(c.x, c.y, c.x + cos(angle) * 12, c.y + sin(angle) * 12, 0x1E1E1C, 1.8)
        f.dot(c.x, c.y, 2.2, 0x1E1E1C)
        if let text = p.text {
            f.text(text, PropFont.heavy(8.5), colours[Int(level)] == 0xFAC775 ? 0x7A5230 : colours[Int(level)],
                   at: CGPoint(x: 68, y: 46), maxWidth: 28)
        }
    }

    // MARK: Damaged

    /// A vase with a jagged crack and a chip out of its rim (76 × 50), and a plate broken in two.
    static func damaged(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        f.svg("M14 50C4 40 6 22 16 16V8H22L26 12L29 8H34V16C44 22 46 40 36 50Z", 0x6FA3C7)
        f.svg("M16 16H34V20H16Z", 0x2F5BD3)
        f.svgLine("M27 12L24 20L30 27L23 35L29 42L25 50", 0x1E1E1C, 1.6)
        f.svgLine("M30 27L36 30M23 35L16 37", 0x1E1E1C, 1)
        // broken plate
        f.svg("M44 50C44 40 50 34 58 34L56 40L60 44L57 50Z", 0xFFFDF6)
        f.svg("M61 50L64 44L60 40L62 34C70 35 76 41 76 50Z", 0xFFFDF6)
        f.svgLine("M58 34L56 40L60 44L57 50M62 34L60 40L64 44L61 50", 0xB4B2A9, 0.8)
        f.svgLine("M46.5 48Q48 40 55 37M73.5 48Q72 41 66 37.5", 0x2F5BD3, 1)
        // shards
        f.svg("M38 49L41 46L42 50Z M8 49L5 47L4 50Z", 0x6FA3C7)
    }
}
