import SwiftUI

/// Language-school things: a treasure chest of words, a chart of mouth shapes, a board of tangled
/// grammar, a calendar counting down to a circled day, and people talking.
enum G3Language {
    typealias Look = PalaceFigures.Look

    // MARK: Chest of words

    /// An open treasure chest (104 × 84) heaped with word cards (`labels`), coins and sparkles.
    static func chest(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 104, height: 84))
        let gold: UInt32 = 0xD9A440
        f.oval(8, 78, 88, 6, 0x1E1E1C, 0.15)
        f.svg("M16 44L20 16H84L88 44Z", 0x4A3524)
        f.svg("M22 20H82L84 40H20Z", 0x2E2117)
        f.svgLine("M20 16H84", gold, 2.4)
        for (x, y) in [(30.0, 40.0), (44, 36), (60, 38), (74, 40), (52, 42), (36, 44)] as [(CGFloat, CGFloat)] {
            f.dot(x, y, 4.2, gold)
            f.ring(x, y, 2.6, PalaceInk.shade(gold, 0.8), 0.8)
        }
        let words = Array((p.labels ?? []).prefix(4))
        let spots: [(CGFloat, CGFloat, Double)] = [(30, 24, -16), (52, 18, -4), (74, 24, 12), (44, 34, 8)]
        for (word, spot) in zip(words, spots) {
            var c = f
            c.ctx.translateBy(x: spot.0, y: spot.1)
            c.ctx.rotate(by: .degrees(spot.2))
            c.rect(-15, -7, 30, 14, 0x1E1E1C, radius: 1.5, 0.15)
            c.rect(-16, -8, 30, 14, 0xFFFDF6, radius: 1.5)
            c.text(word, PropFont.heavy(7.5), 0x1F3A6B, at: CGPoint(x: -1, y: -1), maxWidth: 27)
        }
        f.rect(12, 44, 80, 36, 0x7A5230, radius: 3)
        f.rect(12, 44, 80, 5, 0x9A6A42, radius: 2)
        f.rect(22, 44, 6, 36, gold)
        f.rect(76, 44, 6, 36, gold)
        f.rect(46, 50, 12, 14, gold, radius: 2)
        f.svg("M50.5 55A1.5 1.5 0 1 1 53.5 55L53 60H51Z", 0x2E2117)
        for (x, y, r) in [(10.0, 20.0, 4.0), (94, 14, 5), (96, 36, 3.4), (6, 40, 3)] as [(CGFloat, CGFloat, CGFloat)] {
            PalaceCarePeople.star(f, x, y, r)
        }
    }

    // MARK: Mouth chart

    /// A wall chart (100 × 80): a mouth shape for each sound in `labels` ("ui", "eu", "oe"), from a
    /// wide open mouth to small round lips, with the sound under it.
    static func mouthChart(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 80))
        f.rect(2, 3, 98, 77, 0x1E1E1C, radius: 3, 0.14)
        f.rect(0, 0, 98, 76, 0xFFFDF6, radius: 3)
        f.rect(0, 0, 98, 12, 0x3C3489, radius: 3)
        f.svgLine("M8 6H14M11 3.5V8.5", 0xFFFDF6, 1.2)
        f.svgLine("M80 3.5Q83 6 80 8.5M84 2Q88 6 84 10M88 0.5Q93 6 88 11.5", 0xFFFDF6, 1)
        let sounds = Array((p.labels ?? ["ui", "eu", "oe"]).prefix(3))
        let shapes: [(CGFloat, CGFloat, CGFloat)] = [(12, 8, 4.4), (9, 9, 4.6), (6, 7, 3)]
        for (i, sound) in sounds.enumerated() {
            let cx = 17 + CGFloat(i) * 32, cy: CGFloat = 34
            let (rx, ry, inner) = shapes[i % shapes.count]
            f.dot(cx, cy - 2, 14, 0xF1D3B8)
            f.oval(cx - rx, cy - ry, 2 * rx, 2 * ry, 0xD9776E)
            f.oval(cx - rx + 2.6, cy - inner, 2 * (rx - 2.6), 2 * inner, 0x5A1F1B)
            f.rect(cx - rx + 4, cy - inner, 2 * (rx - 4), 2.2, 0xFFFDF6, radius: 0.8)
            f.text(sound, PropFont.heavy(13), 0x3C3489, at: CGPoint(x: cx, y: 61), maxWidth: 28)
        }
    }

    // MARK: Tangled board

    /// A chalkboard (140 × 92) where words (`labels`) are tied together by arrows that cross and
    /// loop back, with a big question mark.
    static func tangle(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 140, height: 92))
        f.rect(2, 2, 138, 84, 0x1E1E1C, radius: 3, 0.14)
        f.rect(0, 0, 138, 84, 0x7A5230, radius: 3)
        f.rect(4, 4, 130, 76, 0x2F4B3A, radius: 1)
        f.rect(6, 84, 126, 5, 0x9A6A42, radius: 1)
        f.rect(30, 82, 8, 3, 0xFFFDF6, radius: 1)
        let words = Array((p.labels ?? []).prefix(6))
        let spots: [CGPoint] = [CGPoint(x: 24, y: 16), CGPoint(x: 84, y: 14), CGPoint(x: 52, y: 40),
                                CGPoint(x: 20, y: 66), CGPoint(x: 92, y: 66), CGPoint(x: 112, y: 40)]
        f.svgLine("M30 22C70 70 100 10 86 60M86 20C40 30 10 80 60 46C90 30 30 10 26 58M58 46C80 80 120 70 108 46", 0xFAC775, 1.4)
        f.svgLine("M96 70C70 50 60 90 30 70M112 46C80 20 120 10 90 22M20 24C0 40 40 60 50 40", 0xED93B1, 1.4)
        for (a, b) in [(CGPoint(x: 86, y: 60), CGPoint(x: 84, y: 54)), (CGPoint(x: 26, y: 58), CGPoint(x: 27, y: 52)),
                       (CGPoint(x: 108, y: 46), CGPoint(x: 112, y: 52)), (CGPoint(x: 30, y: 70), CGPoint(x: 36, y: 72))] {
            let d = CGPoint(x: a.x - b.x, y: a.y - b.y)
            f.svg("M\(a.x) \(a.y)L\(b.x - d.y * 0.6) \(b.y + d.x * 0.6)L\(b.x + d.y * 0.6) \(b.y - d.x * 0.6)Z", 0xF4F1EA)
        }
        for (word, spot) in zip(words, spots) {
            let w = f.width(of: word, PropFont.heavy(9)) + 6
            f.rect(spot.x - w / 2, spot.y - 6, w, 12, 0x2F4B3A, radius: 2)
            f.text(word, PropFont.heavy(9), 0xF4F1EA, at: spot, maxWidth: 34)
        }
        f.text("?", PropFont.heavy(30), 0xFAC775, at: CGPoint(x: 122, y: 20))
        f.text("?", PropFont.heavy(16), 0xED93B1, at: CGPoint(x: 66, y: 66))
    }

    // MARK: Countdown

    /// A calendar (92 × 82): `caption` month, the days crossed off one by one up to a red ring
    /// round the big day (`count`, default 17) with a star; a note says `text` ("nog 3 dagen").
    /// `mount` "desk" stands it on a desk.
    static func countdown(_ pen: PropPen, _ p: PalacePropParams) {
        let f = onDesk(pen, p, CGSize(width: 92, height: 82))
        f.rect(2, 3, 84, 76, 0x1E1E1C, radius: 2, 0.14)
        f.rect(0, 0, 84, 74, 0xFFFDF6, radius: 2)
        f.rect(0, 0, 84, 13, 0xC8261B, radius: 2)
        f.dot(20, 1, 2.2, 0x3E4C55)
        f.dot(64, 1, 2.2, 0x3E4C55)
        if let caption = p.caption {
            f.text(caption, PropFont.heavy(8), 0xFFFDF6, at: CGPoint(x: 42, y: 7.4), maxWidth: 60)
        }
        let big = max(2, min(p.count ?? 17, 28))
        let today = big - 3
        for d in 1...28 {
            let col = (d - 1) % 7, row = (d - 1) / 7
            let x = 4 + CGFloat(col) * 11 + 5.5, y = 19 + CGFloat(row) * 13 + 5
            if d == big {
                f.ring(x, y, 5.6, 0xC8261B, 1.6)
                PalaceCarePeople.star(f, x + 5, y - 5, 3.4)
            }
            f.text("\(d)", PropFont.demi(6), d < today ? 0xB4B2A9 : 0x1E1E1C, at: CGPoint(x: x, y: y))
            if d < today {
                f.svgLine("M\(x - 3.6) \(y - 3.6)L\(x + 3.6) \(y + 3.6)M\(x + 3.6) \(y - 3.6)L\(x - 3.6) \(y + 3.6)", 0x5E6B73, 1.1)
            }
        }
        if let text = p.text {
            var n = f
            n.ctx.translateBy(x: 70, y: 66)
            n.ctx.rotate(by: .degrees(-6))
            n.rect(-20, -9, 42, 18, 0x1E1E1C, radius: 1, 0.14)
            n.rect(-21, -10, 42, 18, 0xFAC775, radius: 1)
            n.text(text, PropFont.heavy(7), 0x1E1E1C, at: CGPoint(x: 0, y: -1), maxWidth: 38)
        }
    }

    /// A small desk under a drawing that is `size` big (`mount` "desk"); returns the pen to draw on it.
    private static func onDesk(_ pen: PropPen, _ p: PalacePropParams, _ size: CGSize) -> PropPen {
        guard p.mount == "desk" else { return pen.fitted(size) }
        let total = CGSize(width: size.width, height: size.height + 30)
        let f = pen.fitted(total)
        f.oval(4, total.height - 5, size.width - 8, 5, 0x1E1E1C, 0.14)
        f.svgLine("M10 \(size.height + 2)V\(total.height - 2)M\(size.width - 10) \(size.height + 2)V\(total.height - 2)", 0x5E6B73, 2.6)
        f.rect(0, size.height - 4, size.width, 6, 0xC9965F, radius: 1.5)
        f.rect(0, size.height + 2, size.width, 2, 0x9A6A42)
        return f
    }

    // MARK: Speaker

    /// Someone talking (88 × 124, facing right). `accessory` "slow": a teacher points at her wide
    /// open mouth, the bubble spells out `text` with sound waves. "flow": the words pour out as one
    /// smooth wave ending in a green tick. "home": a mother holds her child's hand and says `text`,
    /// with a heart. "hand": a student puts a hand up and says `text`. `variant` look.
    static func speaker(_ pen: PropPen, _ p: PalacePropParams) {
        let base = pen.fitted(CGSize(width: 88, height: 124))
        let f = base.within(CGRect(x: 0, y: 10, width: 64, height: 114))
        let v = Look.at(p.variant ?? 1)
        G3Body.shadow(f)
        G3Body.legs(f, v.trousers)
        let style = p.accessory ?? "slow"
        if style == "home" {
            home(base, f, v, p.text)
            return
        }
        f.svgLine("M13 42C10 52 10 62 12 70", PalaceInk.shade(v.coat, 0.78), 6)
        f.dot(12.5, 72, 3.1, v.skin)
        G3Body.torso(f, v.coat)
        f.svg("M17 32L22 39L27 32Z", 0xEFEBE2)
        G3Body.head(f, skin: v.skin, hair: v.hair)
        switch style {
        case "slow":
            f.oval(26, 23, 5, 5, 0x5A1F1B)
            f.svgLine("M31 42C37 44 38 36 33 30", v.coat, 6)
            f.dot(32.5, 28.5, 3, v.skin)
            f.svgLine("M33 27L31 25.5", v.skin, 2)
            base.svgLine("M38 30Q41 33 38 36M42 28Q46 33 42 38", 0x3C3489, 1.3)
            if let text = p.text { G3Body.bubble(base, CGRect(x: 30, y: 0, width: 58, height: 20), text, tail: CGPoint(x: 34, y: 29), size: 10) }
        case "flow":
            G3Body.smile(f)
            f.svgLine("M31 42C34 52 34 62 32 70", v.coat, 6)
            f.dot(32, 72, 3.1, v.skin)
            let r = CGRect(x: 30, y: 0, width: 58, height: 22)
            G3Body.bubble(base, r, "", tail: CGPoint(x: 34, y: 32))
            base.svgLine("M36 11C40 5 44 5 48 11S56 17 60 11S68 5 72 11", 0x2F5BD3, 2.2)
            base.svgLine("M76 11L79 14L84 7", 0x1E7A4C, 2)
        case "hand":
            G3Body.smile(f)
            f.svgLine("M31 42C36 36 38 24 37 10", v.coat, 6)
            f.dot(37, 7, 3.4, v.skin)
            f.svgLine("M35.5 4.5V1M38.5 4.5V0.5", v.skin, 1.6)
            if let text = p.text { G3Body.bubble(base, CGRect(x: 50, y: 18, width: 38, height: 20), text, tail: CGPoint(x: 31, y: 38), size: 10) }
        default:
            break
        }
    }

    /// A mother and her child hand in hand.
    private static func home(_ base: PropPen, _ f: PropPen, _ v: Look, _ text: String?) {
        G3Body.torso(f, v.coat)
        f.svgLine("M13 42C10 52 10 62 12 70", PalaceInk.shade(v.coat, 0.78), 6)
        f.dot(12.5, 72, 3.1, v.skin)
        G3Body.head(f, skin: v.skin, hair: v.hair)
        f.dot(11.5, 13, 4.4, v.hair)
        G3Body.smile(f)
        f.svgLine("M31 42C36 52 40 60 44 66", v.coat, 6)
        f.dot(45, 67, 3.1, v.skin)
        // The child
        let c = Look.at(6)
        let k = base.within(CGRect(x: 44, y: 66, width: 34, height: 58), unit: 0.55)
        k.svgLine("M20 84V104M30 84V104", c.trousers, 6)
        k.svg("M14 103H25V108H14Z M26 103H37V108H26Z", 0x2E2117)
        k.svg("M12 88L13.5 46C14.5 38 18.5 34 25 34C31.5 34 35.5 38 36.5 46L38 88Z", c.coat)
        k.svgLine("M16 46C10 52 4 56 0 56", c.coat, 7)
        k.dot(25, 20, 12, c.skin)
        k.svg("M13 19C12 10 17 6 25 6C33 6 38 10 37 19C35 14 30 12.5 25 12.5C20 12.5 15 14 13 19Z", c.hair)
        k.dot(19, 21, 1.6, 0x2E2117)
        k.svgLine("M17 27Q19.5 29 22 27", 0x8C5A3C, 1.4)
        if let text { G3Body.bubble(base, CGRect(x: 30, y: 0, width: 56, height: 18), text, tail: CGPoint(x: 30, y: 30), size: 9.5) }
        PalaceIcon.heart.draw(base, in: CGRect(x: 62, y: 40, width: 13, height: 13), color: 0xC8261B, detail: 0xC8261B)
    }
}
