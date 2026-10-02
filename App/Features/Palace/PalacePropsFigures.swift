import SwiftUI

/// Figurative props: people, a clock on a pole with a crowd, a card reader, a packed train window.
/// Each is drawn at a fixed design size and scaled to fit its frame, standing on the bottom edge.
enum PalaceFigures {
    /// Clothes and colouring for drawn people (never Noor's purple coat).
    struct Look {
        let coat: UInt32
        let trousers: UInt32
        let skin: UInt32
        let hair: UInt32
        let bag: UInt32

        static let all: [Look] = [
            Look(coat: 0x1F3A6B, trousers: 0x3E4C55, skin: 0xE8C4A0, hair: 0x4A3524, bag: 0xC8261B),
            Look(coat: 0x0F6E56, trousers: 0x2E2117, skin: 0x8C5A3C, hair: 0x1E1E1C, bag: 0xF2711C),
            Look(coat: 0xC9A15B, trousers: 0x3C3489, skin: 0xC99A74, hair: 0x2E2117, bag: 0x2F5BD3),
            Look(coat: 0xC8261B, trousers: 0x1E1E1C, skin: 0xF1D3B8, hair: 0xC9A15B, bag: 0x0F6E56),
            Look(coat: 0x5E6B73, trousers: 0x2E2117, skin: 0xA87B4F, hair: 0x2E2117, bag: 0xFAC775),
            Look(coat: 0x3C3489, trousers: 0x5E6B73, skin: 0xE8C4A0, hair: 0x7A5230, bag: 0xC8261B),
            Look(coat: 0xF2711C, trousers: 0x3E4C55, skin: 0x8C5A3C, hair: 0x1E1E1C, bag: 0x1F3A6B),
            Look(coat: 0x2F5BD3, trousers: 0x2E2117, skin: 0xC99A74, hair: 0x4A3524, bag: 0xC9A15B),
        ]

        static func at(_ i: Int) -> Look { all[((i % all.count) + all.count) % all.count] }
    }

    // MARK: Person

    /// A standing traveller (64 × 114), facing right like Noor. `accessory`: "suitcase", "backpack", "none".
    static func person(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 64, height: 114))
        let v = Look.at(p.variant ?? 0)
        let accessory = p.accessory ?? "suitcase"
        let dark = PalaceInk.shade(v.coat, 0.78)
        f.oval(6, 106, 56, 6, 0x1E1E1C, 0.16)
        if accessory == "backpack" { f.rect(4, 40, 12, 30, v.bag, radius: 4) }
        f.svgLine("M17 84V104M27 84V104", v.trousers, 5)
        f.svg("M12 103H21V108H12Z M23 103H32V108H23Z", 0x2E2117)
        f.svg("M9 88L10.5 44C11.5 36 15.5 32 22 32C28.5 32 32.5 36 33.5 44L35 88Z", v.coat)
        f.svgLine("M22 40V86", dark, 1.2)
        f.dot(24.5, 52, 1.3, dark)
        f.dot(24.5, 64, 1.3, dark)
        f.svg("M17 32L22 39L27 32Z", 0xEFEBE2)
        f.svgLine("M13 42C10 52 10 62 12 70", dark, 6)
        f.dot(12.5, 72, 3.1, v.skin)
        f.dot(22, 19, 11, v.skin)
        f.svg("M11 18C10 10 15 6 22 6C29 6 34 10 33 18C31 13 27 11.5 22 11.5C17 11.5 13 13 11 18Z", v.hair)
        f.dot(28, 19.5, 1.3, 0x2E2117)
        if accessory == "backpack" { f.svgLine("M16 34L13 46", 0x2E2117, 2) }
        if accessory == "suitcase" {
            f.svgLine("M47.5 55V73M55.5 55V73", 0x3E4C55, 1.8)
            f.svgLine("M46 54H57", 0x1E1E1C, 2.6)
            f.rect(40, 72, 23, 32, v.bag, radius: 3)
            f.svgLine("M46 76V100M57 76V100", PalaceInk.shade(v.bag, 0.75), 1.4)
            f.dot(44.5, 106, 2.4, 0x1E1E1C)
            f.dot(58.5, 106, 2.4, 0x1E1E1C)
            f.svgLine("M31 41C37 46 44 51 50 54", v.coat, 6)
            f.dot(51, 54.5, 3.2, v.skin)
        } else {
            f.svgLine("M31 42C34 52 34 62 32 70", v.coat, 6)
            f.dot(32, 72, 3.1, v.skin)
        }
    }

    /// A small person for crowds, centred on x = 15, feet at y = 60 (30 × 60).
    static func mini(_ f: PropPen, _ v: Look, walking: Bool, briefcase: Bool) {
        f.svgLine(walking ? "M12 44L8 59M18 44L22 59" : "M12 44V59M18 44V59", v.trousers, 3.6)
        f.svg("M7 46L8 22C9 17 12 15 15 15C18 15 21 17 22 22L23 46Z", v.coat)
        if briefcase {
            f.svgLine("M23 26L25 40", PalaceInk.shade(v.coat, 0.78), 3.4)
            f.rect(21, 40, 9, 7, 0x4A3524, radius: 1)
        }
        f.dot(15, 9, 6.4, v.skin)
        f.svg("M8.8 8.5C8.5 3.5 11.5 1.5 15 1.5C19 1.5 21.6 4 21.2 8.5C19.5 6 17.5 5.4 15 5.4C12.4 5.4 10.4 6.2 8.8 8.5Z", v.hair)
    }

    // MARK: Clock

    /// A station clock on a pole (92 × 182) showing `time`, with `count` people crowding at its foot.
    static func clock(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 92, height: 182))
        let crowd = max(0, min(p.count ?? 0, 7))
        let spots: [(x: CGFloat, back: Bool)] = [(16, true), (46, true), (76, true), (6, false), (31, false), (60, false), (86, false)]
        f.oval(2, 175, 88, 7, 0x1E1E1C, 0.14)
        let people = spots.prefix(crowd).enumerated().map { (i: $0.offset, spot: $0.element) }
        for person in people where person.spot.back { crowdPerson(f, person.spot.x, feet: 168, scale: 0.86, i: person.i) }
        f.rect(43.5, 44, 5, 132, 0x3F5A4A)
        f.rect(43.5, 44, 1.6, 132, 0x5E7A68)
        f.rect(37, 174, 18, 4, 0x2E2117, radius: 1)
        for person in people where !person.spot.back { crowdPerson(f, person.spot.x, feet: 180, scale: 1, i: person.i) }
        f.rect(40.5, 38, 11, 9, 0x3F5A4A, radius: 1.5)
        let c = CGPoint(x: 46, y: 21)
        f.dot(c.x, c.y, 21, 0x2E2117)
        f.dot(c.x, c.y, 17.6, 0xFFFDF6)
        var ticks = Path()
        for k in 0..<12 {
            let a = Double(k) * .pi / 6
            let inner = k % 3 == 0 ? 12.5 : 14.5
            ticks.move(to: CGPoint(x: c.x + sin(a) * inner, y: c.y - cos(a) * inner))
            ticks.addLine(to: CGPoint(x: c.x + sin(a) * 16.2, y: c.y - cos(a) * 16.2))
        }
        f.stroke(ticks, 0x2E2117, 1.6)
        let (hour, minute) = parse(p.time ?? "8:15")
        hand(f, c, angle: (Double(hour % 12) + Double(minute) / 60) * 30, length: 9.5, width: 3.4)
        hand(f, c, angle: Double(minute) * 6, length: 14, width: 2.4)
        f.dot(c.x, c.y, 2.3, 0x2E2117)
    }

    private static func crowdPerson(_ f: PropPen, _ x: CGFloat, feet: CGFloat, scale s: CGFloat, i: Int) {
        let box = CGRect(x: x - 15 * s, y: feet - 60 * s, width: 30 * s, height: 60 * s)
        mini(f.within(box, unit: s), Look.at(i + 2), walking: i % 2 == 1, briefcase: i == 4)
    }

    private static func hand(_ f: PropPen, _ c: CGPoint, angle degrees: Double, length: CGFloat, width: CGFloat) {
        let a = degrees * .pi / 180
        f.line(c.x, c.y, c.x + sin(a) * length, c.y - cos(a) * length, 0x1E1E1C, width)
    }

    /// "8:15" → (8, 15); anything else → (8, 15).
    static func parse(_ time: String) -> (Int, Int) {
        let parts = time.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2, (0..<24).contains(parts[0]), (0..<60).contains(parts[1]) else { return (8, 15) }
        return (parts[0], parts[1])
    }

    // MARK: Card reader

    /// The check-in pole (50 × 106): green light and a tick, a card held to it, a beep.
    static func reader(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 50, height: 106))
        f.oval(10, 100, 30, 6, 0x1E1E1C, 0.16)
        f.rect(23, 50, 8, 50, 0x5E6B73)
        f.rect(23, 50, 2.4, 50, 0x7D8A92)
        f.rect(17, 99, 20, 4, 0x3E4C55, radius: 1)
        f.dot(27, 14, 13, 0x1E7A4C, 0.16)
        f.rect(9, 6, 36, 48, 0x5E6B73, radius: 8)
        f.rect(11, 8, 32, 44, 0xF4F1EA, radius: 6.5)
        f.rect(15, 11, 24, 5, 0x1E7A4C, radius: 2.5)
        f.rect(15, 19, 24, 11, 0x232B3B, radius: 1.5)
        PalaceIcon.check.draw(f, in: CGRect(x: 22, y: 19.5, width: 10, height: 10), color: 0x5DCAA5, detail: 0x232B3B)
        f.svgLine("M22 36Q25 40 22 44M26 34Q30.5 40 26 46M30 32Q36 40 30 48", 0xB4B2A9, 1.4)
        let card = Path(roundedRect: CGRect(x: -12, y: -7.5, width: 24, height: 15), cornerRadius: 2)
            .applying(CGAffineTransform(rotationAngle: -0.18).concatenating(CGAffineTransform(translationX: 31, y: 40)))
        f.fill(card, 0x2F5BD3)
        f.stroke(card, 0x21468B, 1)
        f.svgLine("M21 39.8L39 36.6", 0xFFFDF6, 1.6)
        f.svg("M37 37C40 33.5 46 33.5 47.5 37.5C49 42 45 46 39.5 45.2Z", 0xE8C4A0)
        f.svg("M45 34H50V47H45Z", 0x3F5A4A)
        f.svgLine("M5.5 9Q2.5 13.5 5.5 18M2.5 6Q-2 13.5 2.5 21", 0x1E7A4C, 1.6)
    }

    // MARK: Crowded window

    /// A train window (84 × 58) packed with heads and shoulders, a hand pressed to the glass.
    static func crowdedWindow(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 58))
        f.rect(0, 0, 84, 58, 0xEFEBE2, radius: 4)
        f.rect(3, 3, 78, 52, 0x3E4C55, radius: 8)
        let glass = CGRect(x: 6, y: 6, width: 72, height: 46)
        var g = f
        g.ctx.clip(to: Path(roundedRect: glass, cornerRadius: 6))
        g.rect(glass, 0xE9E4D6)
        g.line(6, 10, 78, 10, 0xB4B2A9, 1.6)
        let heads: [(x: CGFloat, y: CGFloat, r: CGFloat)] = [
            (14, 22, 7.5), (30, 18, 8), (47, 21, 7.5), (63, 17, 8), (76, 23, 7.5),
            (10, 40, 9), (27, 36, 9.5), (44, 39, 9), (61, 35, 9.5), (77, 41, 9),
        ]
        let n = max(3, min(p.count ?? heads.count, heads.count))
        for (i, h) in heads.prefix(n).enumerated() {
            let v = Look.at(i * 3 + 1)
            let front = i >= 5
            g.rect(h.x - h.r - 3, h.y + h.r - 2, 2 * h.r + 6, 30, v.coat, radius: 6)
            g.dot(h.x, h.y, h.r, v.skin)
            g.svg(String(format: "M%.1f %.1fA%.1f %.1f 0 0 1 %.1f %.1fC%.1f %.1f %.1f %.1f %.1f %.1fZ",
                         h.x - h.r, h.y - 1, h.r, h.r, h.x + h.r, h.y - 1,
                         h.x + h.r * 0.4, h.y - h.r * 0.55, h.x - h.r * 0.4, h.y - h.r * 0.55, h.x - h.r, h.y - 1), v.hair)
            if front {
                g.dot(h.x - h.r * 0.35, h.y + 1.5, 1.1, 0x2E2117)
                g.dot(h.x + h.r * 0.35, h.y + 1.5, 1.1, 0x2E2117)
            }
        }
        g.svg("M66 24C66 20 72 19 73 23L73.5 30C72 33 67 33 66 30Z", 0xE8C4A0, 0.95)
        g.svgLine("M67.5 23V19.5M69.6 22.5V18.5M71.6 23V19.6", 0xE8C4A0, 1.8)
        g.svg("M12 52L34 6H44L22 52Z", 0xFFFFFF, 0.14)
    }
}
