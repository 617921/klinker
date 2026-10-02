import SwiftUI

/// Groups of people (a guided tour, a choir, a community holding hands) and a wedding couple.
enum G5Groups {
    typealias Look = PalaceFigures.Look

    /// `accessory` "tour" (a guide holding up a flag and talking — `text` in a bubble — and a small
    /// group following), "choir" (two rows of singers in robes with folders, notes above; `tone` the
    /// robes), "circle" (young and old holding hands in a row under a heart).
    static func group(_ pen: PropPen, _ p: PalacePropParams) {
        switch p.accessory ?? "tour" {
        case "choir": choir(pen.fitted(CGSize(width: 120, height: 92)), PropColor.named(p.tone, 0x7A1E1E))
        case "circle": circle(pen.fitted(CGSize(width: 128, height: 84)))
        default: tour(pen.fitted(CGSize(width: 116, height: 128)), p)
        }
    }

    private static func tour(_ f: PropPen, _ p: PalacePropParams) {
        let flag = PropColor.named(p.tone, 0xF2711C)
        for (i, x) in [104.0, 86, 68].enumerated() {
            let v = Look.at(i * 2 + 1)
            let s: CGFloat = 1.55 - CGFloat(i) * 0.05
            let box = CGRect(x: x - 15 * s, y: 126 - 60 * s, width: 30 * s, height: 60 * s)
            PalaceFigures.mini(f.within(box, unit: s).mirrored(), v, walking: false, briefcase: false)
            f.oval(box.minX + 2, 123, box.width - 4, 4, 0x1E1E1C, 0.1)
        }
        let v = Look.at(p.variant ?? 6)
        let fig = f.within(CGRect(x: 0, y: 14, width: 64, height: 114))
        G5Body.standing(fig, v)
        fig.rect(17, 32, 10, 3, flag)
        G5Body.arm(fig, "M13 42C10 34 9 24 10 14", hand: CGPoint(x: 10, y: 12), sleeve: PalaceInk.shade(v.coat, 0.8), skin: v.skin)
        f.svgLine("M10 26V-2", 0x5E6B73, 1.4)
        f.svg("M10 -2H26L22 4L26 10H10Z", flag)
        G5Body.head(fig, v, 22, 19, face: .laugh)
        G5Body.arm(fig, "M31 42C38 44 44 40 48 36", hand: CGPoint(x: 48.5, y: 35.5), sleeve: v.coat, skin: v.skin)
        if let text = p.text {
            G5Props.bubble(f, CGRect(x: 36, y: 0, width: 78, height: 17), text, tail: CGPoint(x: 42, y: 26), size: 8.5)
        }
    }

    private static func choir(_ f: PropPen, _ robe: UInt32) {
        let rows: [[CGFloat]] = [[22, 50, 78, 106], [36, 64, 92]]
        for (r, xs) in rows.enumerated() {
            let top: CGFloat = r == 0 ? 22 : 40
            for (i, x) in xs.enumerated() {
                let v = Look.at(i * 3 + r * 2 + 1)
                f.svg("M\(x - 12) \(top + 52)L\(x - 10) \(top + 18)Q\(x) \(top + 12) \(x + 10) \(top + 18)L\(x + 12) \(top + 52)Z", PalaceInk.shade(robe, r == 0 ? 0.85 : 1))
                f.svg("M\(x - 6) \(top + 15)L\(x) \(top + 26)L\(x + 6) \(top + 15)Z", 0xFFFDF6)
                f.dot(x, top + 6, 9, v.skin)
                f.svg("M\(x - 9) \(top + 5)C\(x - 9) \(top - 4) \(x + 9) \(top - 4) \(x + 9) \(top + 5)C\(x + 6) \(top + 1) \(x - 6) \(top + 1) \(x - 9) \(top + 5)Z", v.hair)
                f.oval(x - 2.2, top + 8, 4.4, 5, 0x7A2A20)
                f.dot(x - 3.4, top + 4.5, 1, 0x2E2117)
                f.dot(x + 3.4, top + 4.5, 1, 0x2E2117)
                f.rect(x - 9, top + 26, 18, 12, 0x1E1E1C, radius: 1)
                f.line(x, top + 26, x, top + 38, 0x5E6B73, 0.8)
                f.dot(x - 9, top + 34, 2.6, v.skin)
                f.dot(x + 9, top + 34, 2.6, v.skin)
            }
        }
        G5Props.note(f, 14, 12, 0xC9A15B)
        G5Props.note(f, 64, 8, 0xC9A15B, scale: 0.9)
        G5Props.note(f, 112, 14, 0xC9A15B)
    }

    private static func circle(_ f: PropPen) {
        let people: [(x: CGFloat, s: CGFloat, look: Int)] = [(12, 1.15, 4), (34, 1.3, 1), (56, 0.85, 3), (76, 1.3, 2), (98, 1.2, 6), (118, 0.95, 0)]
        G5Props.heart(f, 64, 10, 8, 0xC8261B)
        var hands: [CGPoint] = []
        for person in people {
            let box = CGRect(x: person.x - 15 * person.s, y: 82 - 60 * person.s, width: 30 * person.s, height: 60 * person.s)
            PalaceFigures.mini(f.within(box, unit: person.s), Look.at(person.look), walking: false, briefcase: false)
            hands.append(CGPoint(x: person.x, y: 82 - 60 * person.s + 26 * person.s))
        }
        for (a, b) in zip(hands, hands.dropFirst()) {
            let mid = CGPoint(x: (a.x + b.x) / 2, y: max(a.y, b.y) + 6)
            f.svgLine("M\(a.x + 5) \(a.y)Q\(mid.x - 4) \(mid.y) \(mid.x) \(mid.y)Q\(mid.x + 4) \(mid.y) \(b.x - 5) \(b.y)", 0x5E6B73, 2.4)
            f.dot(mid.x, mid.y, 2.8, 0xC99A74)
        }
        f.svgLine("M\(people[0].x - 22) 54L\(people[0].x - 22) 82", 0x6B4A2E, 1.6)
    }

    // MARK: Couple

    /// A groom and a bride (96 × 118) facing each other; he slides a gold ring onto her finger,
    /// a heart above them. She wears a white dress and veil and holds flowers.
    static func couple(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 118))
        let he = Look.at(p.variant ?? 1), she = Look.at((p.variant ?? 1) + 2)
        let groom = f.within(CGRect(x: 2, y: 4, width: 64, height: 114))
        G5Body.standing(groom, he, coat: 0x2E2117, collar: 0xFFFDF6)
        groom.svg("M19 34.5L22 36.5L25 34.5V38.5L22 36.5L19 38.5Z", 0xC8261B)
        G5Body.arm(groom, "M13 42C10 52 10 62 12 70", hand: CGPoint(x: 12.5, y: 72), sleeve: 0x1E1E1C, skin: he.skin)
        G5Body.head(groom, he, 22, 19, face: .smile)
        G5Body.arm(groom, "M31 42C38 46 42 50 46 52", hand: CGPoint(x: 46.5, y: 52), sleeve: 0x2E2117, skin: he.skin)
        let bride = f.within(CGRect(x: 32, y: 4, width: 64, height: 114)).mirrored()
        bride.svg("M8 30C2 40 0 60 2 104H26C26 70 22 44 16 30Z", 0xFFFDF6, 0.75)
        bride.oval(6, 106, 52, 6, 0x1E1E1C, 0.16)
        bride.svg("M14 34C10 60 4 84 0 108H44C40 84 34 60 30 34Z", 0xFFFDF6)
        bride.stroke(PalaceSVG.path("M14 34C10 60 4 84 0 108H44C40 84 34 60 30 34Z"), 0xD3D1C7, 1)
        G5Body.arm(bride, "M15 42C12 50 12 56 14 62", hand: CGPoint(x: 14, y: 63), sleeve: 0xF4F1EA, skin: she.skin, width: 4.5)
        for (dx, dy, c) in [(10.0, 62.0, 0xE0607A), (16, 60, 0xFAC775), (13, 67, 0xE0607A), (17, 65, 0xFFFDF6)] as [(CGFloat, CGFloat, UInt32)] {
            bride.dot(dx, dy, 2.8, c)
        }
        G5Body.head(bride, she, 22, 19, face: .smile)
        bride.svg("M12 10C14 4 22 2 30 6L33 9Q24 8 12 12Z", 0xFFFDF6)
        G5Body.arm(bride, "M29 42C34 46 38 48 41 50", hand: CGPoint(x: 41.5, y: 50.5), sleeve: 0xF4F1EA, skin: she.skin, width: 4.5)
        f.ring(48, 52, 2.6, 0xC9A15B, 1.6)
        G5Props.sparkle(f, 52, 46, 3.4)
        G5Props.heart(f, 48, 10, 6.5, 0xE0607A)
    }
}
