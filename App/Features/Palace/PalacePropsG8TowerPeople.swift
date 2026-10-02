import SwiftUI

/// The finale's feelings and plans: a thought bubble with the diploma you expect, a smiling sun
/// breaking through with a rainbow, someone looking back along the road they came, a notebook of
/// New Year plans, someone proud with a medal, and stairs climbed to a flag at the top.
enum G8TowerPeople {
    typealias Look = PalaceFigures.Look

    // MARK: Thought bubble

    /// A thought bubble (112 × 88) whose little circles trail down to the person under it, with a
    /// diploma showing `text` (the level) and a green tick inside.
    static func thoughtBubble(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 88), hanging: true)
        var cloud = Path()
        for (x, y, r) in [(30.0, 30.0, 20.0), (56, 22, 22), (82, 30, 20), (44, 46, 18), (72, 46, 18)] as [(CGFloat, CGFloat, CGFloat)] {
            cloud.addEllipse(in: CGRect(x: x - r, y: y - r, width: 2 * r, height: 2 * r))
        }
        f.ctx.fill(cloud, with: .color(PalaceInk.hex(0x1E1E1C, 0.12)))
        var shadowed = f
        shadowed.ctx.translateBy(x: -1.5, y: -2)
        shadowed.ctx.fill(cloud, with: .color(PalaceInk.hex(0xFFFDF6)))
        f.dot(52, 72, 5, 0xFFFDF6)
        f.dot(56, 82, 3, 0xFFFDF6)
        let paper = CGRect(x: 34, y: 14, width: 38, height: 30)
        f.rect(paper, 0xFAF3E0, radius: 1)
        f.stroke(Path(paper.insetBy(dx: 2, dy: 2)), 0xC9A15B, 1)
        f.text(p.text ?? "B1", PropFont.heavy(11), 0x1F3A6B, at: CGPoint(x: paper.midX - 3, y: paper.midY - 2), maxWidth: 26)
        f.svgLine("M\(paper.minX + 6) \(paper.maxY - 6)H\(paper.midX)", 0xB4B2A9, 1)
        f.svg("M66 40L63 50L67 47L69 51L70 41Z", 0xC8261B)
        f.dot(68, 40, 4.6, 0xC8261B)
        G8Props.badge(f, 84, 30, 8, ok: true)
    }

    // MARK: Sun through the clouds

    /// A rainbow (136 × 98) behind a grey cloud, and a smiling sun breaking out over it.
    static func sunrise(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 136, height: 98))
        let colours: [UInt32] = [0xC8261B, 0xF2711C, 0xFAC775, 0x5E8C45, 0x2F5BD3]
        for (i, c) in colours.enumerated() {
            let r = 62 - CGFloat(i) * 5
            var arc = Path()
            arc.addArc(center: CGPoint(x: 70, y: 96), radius: r, startAngle: .degrees(180), endAngle: .degrees(360), clockwise: false)
            f.stroke(arc, c, 5, round: false)
        }
        let s = CGPoint(x: 92, y: 38)
        for k in 0..<10 {
            let a = Double(k) * .pi / 5
            f.line(s.x + cos(a) * 24, s.y + sin(a) * 24, s.x + cos(a) * 31, s.y + sin(a) * 31, 0xF2B33D, 3)
        }
        f.dot(s.x, s.y, 20, 0xF2B33D)
        f.dot(s.x, s.y, 16, 0xFAC775)
        f.svgLine("M\(s.x - 8) \(s.y - 4)q2 -3 4 0M\(s.x + 4) \(s.y - 4)q2 -3 4 0", 0x7A3F2E, 1.6)
        f.svgLine("M\(s.x - 8) \(s.y + 4)Q\(s.x) \(s.y + 12) \(s.x + 8) \(s.y + 4)", 0x7A3F2E, 2)
        f.dot(s.x - 11, s.y + 3, 2.4, 0xF2711C, 0.5)
        f.dot(s.x + 11, s.y + 3, 2.4, 0xF2711C, 0.5)
        f.dot(28, 66, 16, 0xB4B2A9)
        f.dot(50, 58, 20, 0xB4B2A9)
        f.dot(74, 70, 14, 0xB4B2A9)
        f.rect(12, 66, 76, 18, 0xB4B2A9, radius: 9)
        f.dot(46, 54, 10, 0xD3D1C7)
    }

    // MARK: Looking back

    /// Someone on their way (92 × 114) who turns their head to look back along the dotted road
    /// behind them, past pins of the places they came by (`icons`).
    static func lookBack(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 92, height: 114))
        let v = Look.at(p.variant ?? 5)
        let icons = (p.icons ?? ["train", "house", "book"]).compactMap(PalaceIcon.init(rawValue:))
        var road = Path()
        road.move(to: CGPoint(x: 48, y: 108))
        road.addCurve(to: CGPoint(x: 12, y: 8), control1: CGPoint(x: 0, y: 96), control2: CGPoint(x: 40, y: 40))
        f.ctx.stroke(road, with: .color(PalaceInk.hex(0x7A5230)), style: StrokeStyle(lineWidth: 2.2, lineCap: .round, dash: [1, 6]))
        for (i, spot) in [CGPoint(x: 20, y: 86), CGPoint(x: 26, y: 50), CGPoint(x: 16, y: 18)].enumerated() where i < icons.count {
            f.dot(spot.x, spot.y, 9, 0xFFFDF6)
            f.ring(spot.x, spot.y, 9, 0xC8261B, 1.6)
            icons[i].draw(f, in: CGRect(x: spot.x - 6, y: spot.y - 6, width: 12, height: 12), color: 0x1F3A6B, detail: 0xFFFDF6)
        }
        let b = f.within(CGRect(x: 30, y: 0, width: 62, height: 114))
        b.oval(6, 106, 52, 6, 0x1E1E1C, 0.15)
        PalaceParkPeople.walker(b, x: 6, v, hair: v.hair, hat: false)
        b.svgLine("M41 42C45 52 46 60 47 66", v.coat, 6)
        b.dot(47, 68, 3.1, v.skin)
        b.dot(30, 19, 11, v.skin)
        b.svg("M19 18C18 10 23 6 30 6C37 6 42 10 41 18C39 13 35 11.5 30 11.5C25 11.5 21 13 19 18Z", v.hair)
        b.svg("M38 12C42 14 43 20 41 26L37 24Z", v.hair)
        b.dot(23, 19.5, 1.4, 0x2E2117)
        b.svgLine("M19.5 21L18 23.5L20 24", PalaceInk.shade(v.skin, 0.82), 1.4)
        b.svgLine("M16 13Q11 15 9 20", 0x7A5230, 1.4)
        G8Props.head(b, tip: CGPoint(x: 8, y: 23), dx: -0.3, dy: 1, 4, 0x7A5230)
    }

    // MARK: Plans for the new year

    /// A notebook on a lectern (72 × 104): `caption` ("1 jan") in red with a little firework, and
    /// a list of plans, each a picture (`icons`) with an empty tick box.
    static func resolutions(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 72, height: 104))
        let icons = (p.icons ?? ["book", "bike", "talk"]).compactMap(PalaceIcon.init(rawValue:))
        G8Props.shadow(f, 18, 99, 36, 4)
        f.svgLine("M36 62V98M24 98L36 84L48 98", 0x6B4A2E, 3)
        f.svg("M2 64L8 6H64L70 64Z", 0x1E1E1C, 0.15)
        f.svg("M4 62L9 4H63L68 62Z", 0x3C3489)
        f.svg("M8 59L12 7H60L64 59Z", 0xFFFDF6)
        f.text(p.caption ?? "1 jan", PropFont.heavy(10), 0xC8261B, at: CGPoint(x: 30, y: 15), maxWidth: 36)
        let c = CGPoint(x: 54, y: 14)
        for k in 0..<8 {
            let a = Double(k) * .pi / 4
            f.line(c.x + cos(a) * 2.4, c.y + sin(a) * 2.4, c.x + cos(a) * 6, c.y + sin(a) * 6, k % 2 == 0 ? 0xF2711C : 0x2F5BD3, 1.2)
        }
        for (i, icon) in icons.prefix(3).enumerated() {
            let y = 24 + CGFloat(i) * 11.5
            f.rect(14, y, 7, 7, 0xFFFDF6)
            f.stroke(Path(CGRect(x: 14, y: y, width: 7, height: 7)), 0x1E1E1C, 0.9)
            icon.draw(f, in: CGRect(x: 24, y: y - 1, width: 9, height: 9), color: 0x1F3A6B, detail: 0xFFFDF6)
            f.rect(36, y + 2.5, 20 - CGFloat(i % 2) * 5, 2, 0xB4B2A9)
        }
    }

    // MARK: Proud

    /// Someone proud (64 × 114): chin up, eyes closed with pleasure, hands on the hips, a gold
    /// medal on a ribbon, little sparkles round them. `variant` the look.
    static func proud(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 64, height: 114))
        let v = Look.at(p.variant ?? 1)
        let dark = PalaceInk.shade(v.coat, 0.78)
        f.oval(4, 106, 56, 6, 0x1E1E1C, 0.16)
        f.svgLine("M25 84L22 104M37 84L40 104", v.trousers, 5)
        f.svg("M17 103H26V108H17Z M36 103H45V108H36Z", 0x2E2117)
        f.svg("M17 64L14 42C15 36 19 33 31 33C43 33 47 36 48 42L45 64L46 88H16Z", v.coat)
        f.svgLine("M17 40L8 54L18 64M45 40L54 54L44 64", v.coat, 6)
        f.dot(18, 64, 3.2, v.skin)
        f.dot(44, 64, 3.2, v.skin)
        f.svgLine("M17 40L8 54L18 64", dark, 1)
        f.svgLine("M26 33L31 48L36 33", 0xC8261B, 2.4)
        f.svgLine("M26 33L31 48L36 33", 0x2F5BD3, 1)
        f.dot(31, 52, 6, 0xC9A15B)
        f.dot(31, 52, 4.2, 0xE8C47A)
        G8Props.star(f, 31, 52, 3, 0xC9A15B)
        f.dot(31, 19, 11, v.skin)
        f.svg("M20 16C20 8 25 5 31 5C38 5 43 9 42 17C40 12 36 10 31 10C26 10 22 12 20 16Z", v.hair)
        f.svgLine("M33 17q2 -2.4 4 0M24.5 17q2 -2.4 4 0", 0x2E2117, 1.3)
        f.svgLine("M26 23Q31 28 36 23", 0x8C5A3C, 1.6)
        for (x, y, r) in [(6.0, 22.0, 3.6), (56, 16, 4.2), (58, 40, 2.8), (4, 40, 2.4)] as [(CGFloat, CGFloat, CGFloat)] {
            f.svg("M\(x) \(y - r)L\(x + r * 0.3) \(y - r * 0.3)L\(x + r) \(y)L\(x + r * 0.3) \(y + r * 0.3)L\(x) \(y + r)L\(x - r * 0.3) \(y + r * 0.3)L\(x - r) \(y)L\(x - r * 0.3) \(y - r * 0.3)Z", 0xF2B33D)
        }
    }

    // MARK: Reached the top

    /// Stairs climbing up to the left (84 × 102) to a flag planted on the top step, with a burst
    /// of little stars round it.
    static func summit(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 102))
        G8Props.shadow(f, 2, 96, 80, 5)
        for k in 0..<5 {
            let x = 4 + CGFloat(k) * 16, top = 34 + CGFloat(k) * 12
            f.rect(x, top, 16, 99 - top, k % 2 == 0 ? 0xB4B2A9 : 0xA19E95)
            f.rect(x, top, 16, 3.4, 0xEFEBE2)
            f.rect(x + 13, top, 3, 12, 0x1E1E1C, 0.12)
        }
        f.svgLine("M8 22L84 70", 0x7A5230, 2.2)
        f.svgLine("M8 22V34M46 46V58M84 70V82", 0x7A5230, 1.6)
        f.rect(10, 2, 2.6, 33, 0x3E4C55)
        f.svg("M12.6 3Q22 0 30 5T46 6V20Q38 23 30 18T12.6 18Z", 0xC8261B)
        G8Props.star(f, 29, 12, 4, 0xFFFDF6)
        for (x, y, r) in [(6.0, 10.0, 3.6), (48, 30, 3), (8, 26, 2.4), (62, 4, 2.6)] as [(CGFloat, CGFloat, CGFloat)] {
            f.svg("M\(x) \(y - r)L\(x + r * 0.3) \(y - r * 0.3)L\(x + r) \(y)L\(x + r * 0.3) \(y + r * 0.3)L\(x) \(y + r)L\(x - r * 0.3) \(y + r * 0.3)L\(x - r) \(y)L\(x - r * 0.3) \(y - r * 0.3)Z", 0xF2B33D)
        }
    }
}
