import SwiftUI

/// People in a neighbourhood centre: a volunteer pouring coffee, someone stepping forward with a
/// bright idea, someone working hard carrying chairs, an old man alone at a table, and a group
/// someone runs to join.
enum G4Neighbours {
    typealias Look = PalaceFigures.Look

    /// One neighbour (see `PalacePropKind.g4Neighbour`).
    static func neighbour(_ pen: PropPen, _ p: PalacePropParams) {
        let v = Look.at(p.variant ?? 0)
        switch p.accessory {
        case "idea": idea(pen.fitted(CGSize(width: 60, height: 138)), v)
        case "chairs": chairs(pen.fitted(CGSize(width: 84, height: 120)), v)
        case "lonely": lonely(pen.fitted(CGSize(width: 112, height: 108)), v)
        default: volunteer(pen.fitted(CGSize(width: 100, height: 104)), v)
        }
    }

    /// Behind a counter (y 94): a green bodywarmer with a heart badge, pouring coffee into a cup.
    private static func volunteer(_ f: PropPen, _ v: Look) {
        let p = f.within(CGRect(x: 6, y: 0, width: 64, height: 114))
        G4Draw.adult(p, v, coat: 0xF4F1EA, shadow: false)
        p.svg("M10 88L11 46C12 39 15 35 18 34L20 60H24L26 34C29 35 32 39 33 46L35 88Z", 0x0F6E56)
        p.dot(28, 52, 6, 0xFFFDF6)
        G4Draw.heart(p, 28, 52.5, 4.2, 0xC8261B)
        G4Draw.smile(p, 22, 19)
        // Near arm with the pot, pouring
        p.svgLine("M31 42C36 52 44 54 52 50", 0xF4F1EA, 6)
        p.dot(53, 50, 3.2, v.skin)
        p.svg("M54 38H68L70 54Q70 60 64 60H58Q52 60 52 54Z", 0xD3E0E6, 0.9)
        p.svg("M53 48H69L70 54Q70 60 64 60H58Q52 60 52 54Z", 0x6B3A1E)
        p.svgLine("M50 44Q46 50 52 54", 0x1E1E1C, 2)
        p.svgLine("M70 44L76 62", 0x6B3A1E, 1.6)
        // Cups on the counter
        f.rect(76, 82, 14, 12, 0xFFFDF6, radius: 2)
        f.ring(91, 87, 3, 0xFFFDF6, 1.6)
        f.rect(56, 84, 12, 10, 0xFFFDF6, radius: 2)
        f.svgLine("M80 78Q78 74 80 70M86 78Q84 74 86 70", 0xB4B2A9, 1)
        f.rect(0, 94, 100, 10, 0x9A6A42)
        f.rect(0, 102, 100, 2, 0x6B4A2E)
    }

    /// Stepping forward, one hand up high, a lit bulb over the head, an arrow ahead.
    private static func idea(_ f: PropPen, _ v: Look) {
        let p = f.within(CGRect(x: -6, y: 24, width: 64, height: 114))
        PalaceParkPeople.walker(p, x: 0, v, hair: v.hair, hat: false)
        p.svgLine("M33 42L40 26L42 8", v.coat, 6)
        p.dot(42, 6, 3.4, v.skin)
        G4Draw.smile(p, 24, 19)
        f.svgLine("M2 132H40M34 127L40 132L34 137", 0x1E7A4C, 2.4)
        // The bulb
        f.dot(20, 13, 9, 0xFAC775)
        f.rect(16, 21, 8, 6, 0x9A9890, radius: 1.5)
        f.svgLine("M17 23H23M17 25H23", 0x5E6B73, 0.8)
        f.svgLine("M17 14Q20 9 23 14", 0xF2711C, 1.2)
        for k in 0..<7 {
            let a = Double(k) * .pi / 6 + .pi
            f.line(20 + cos(a) * 12, 13 + sin(a) * 12, 20 + cos(a) * 16, 13 + sin(a) * 16, 0xF2B33D, 1.6)
        }
    }

    /// Walking bent under a tall stack of chairs, sleeves rolled up, sweat flying.
    private static func chairs(_ f: PropPen, _ v: Look) {
        let p = f.within(CGRect(x: 0, y: 6, width: 64, height: 114))
        PalaceParkPeople.walker(p, x: 0, v, hair: v.hair, hat: false)
        p.svgLine("M\(24 + 2) 26Q\(28) 28 \(30) 26", 0x8C2A1E, 1.2)
        p.svgLine("M23 13L28 15", 0x2E2117, 1.4)
        G4Draw.heart(p, 22, 56, 3.4, 0xC8261B)
        // The stack of chairs held against the chest, arms round it
        for k in 0..<5 {
            let y = 16 + CGFloat(k) * 9
            f.svg("M28 \(y)H60L58 \(y + 6)H30Z", 0x2F5BD3)
            f.svgLine("M30 \(y + 6)L28 \(y + 12)M58 \(y + 6)L60 \(y + 12)", 0x5E6B73, 1.4)
        }
        f.svgLine("M30 61L26 92M58 61L62 92", 0x5E6B73, 1.6)
        f.svgLine("M16 50C22 58 34 58 44 50", PalaceInk.shade(v.coat, 0.78), 5.5)
        f.dot(45, 49, 3.2, v.skin)
        f.svgLine("M31 46C36 40 42 38 50 38", v.coat, 6)
        f.dot(51, 38, 3.2, v.skin)
        // Sweat
        for (x, y) in [(10.0, 8.0), (4.0, 18.0), (36.0, 4.0)] as [(CGFloat, CGFloat)] {
            f.svg("M\(x) \(y)Q\(x + 2.4) \(y + 4) \(x) \(y + 5)Q\(x - 2.4) \(y + 4) \(x) \(y)Z", 0x8FB6CF)
        }
        f.svgLine("M2 60H12M0 70H10", 0xB4B2A9, 1.6)
    }

    /// An old man alone at a café table by the window: one cup, an empty chair, a grey cloud.
    private static func lonely(_ f: PropPen, _ v: Look) {
        f.oval(4, 102, 104, 6, 0x1E1E1C, 0.14)
        // Empty chair across
        f.svgLine("M92 52V102M108 60V102M90 80H108", 0x6B4A2E, 2.6)
        f.rect(88, 50, 6, 32, 0x8C5E38, radius: 2)
        // The man, seated, hunched
        f.svgLine("M14 74V102M40 74V102", 0x6B4A2E, 2.6)
        f.rect(10, 70, 34, 6, 0x8C5E38, radius: 2)
        f.svgLine("M30 72H46V100", 0x3E4C55, 6)
        f.svg("M42 98H52V102H42Z", 0x2E2117)
        f.svg("M14 74L16 46C18 38 24 35 30 37L42 46L38 74Z", 0x5E6B73)
        f.svgLine("M24 40V72", PalaceInk.shade(0x5E6B73, 0.8), 1)
        let head = CGPoint(x: 34, y: 30)
        f.dot(head.x, head.y, 10, 0xE8C4A0)
        f.svg("M24 28C24 21 28 19 34 19C38 19 42 21 43 25C40 23 37 23 34 23.5C30 24 27 25 24 28Z", 0xD3D1C7)
        f.svgLine("M37 30.5H40.5", 0x2E2117, 1.2)
        f.svgLine("M37 37Q39 35.5 41 37", 0x8C5A3C, 1.1)
        // Table with one cup, hands round it
        f.rect(46, 60, 46, 6, 0xC9965F, radius: 2)
        f.svgLine("M69 66V102M60 102H78", 0x5E6B73, 2.4)
        f.svgLine("M32 52C38 58 46 58 54 56", 0x5E6B73, 5.5)
        f.rect(55, 50, 10, 10, 0xFFFDF6, radius: 1.5)
        f.dot(53, 56, 3, 0xE8C4A0)
        G4Draw.rainCloud(f, 22, 0, 30)
    }

    // MARK: Joining in

    /// A yoga group (132 × 96): three people in the same pose on mats, one waves; a fourth runs in
    /// from the right with a rolled mat under the arm to join them.
    static func joinIn(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 132, height: 96))
        let mats: [UInt32] = [0x5DCAA5, 0xC8261B, 0x2F5BD3]
        for i in 0..<3 {
            let x = 4 + CGFloat(i) * 28
            f.rect(x - 2, 88, 30, 5, mats[i], radius: 2)
            let v = Look.at(i * 2 + 1)
            let m = f.within(CGRect(x: x, y: 28, width: 26, height: 60), unit: 0.87)
            PalaceFigures.mini(m, v, walking: false, briefcase: false)
            if i == 2 {
                m.svgLine("M9 24L1 6M21 24L32 18L36 8", v.coat, 4)
                m.dot(36, 7, 2.4, v.skin)
                m.svgLine("M39 4L42 1M40 9L44 9", 0x5E6B73, 1)
            } else {
                m.svgLine("M9 24L1 6M21 24L29 6", v.coat, 4)
            }
            m.dot(1, 5, 2.4, v.skin)
            if i != 2 { m.dot(29, 5, 2.4, v.skin) }
        }
        // The newcomer, hurrying in with a mat
        let n = f.within(CGRect(x: 92, y: 4, width: 41, height: 73), unit: 0.64)
        let v = Look.at(6)
        PalaceParkPeople.walker(n.mirrored(), x: 0, v, hair: v.hair, hat: false)
        n.mirrored().svgLine("M33 42C40 48 44 50 50 48", v.coat, 6)
        n.rect(2, 44, 30, 10, 0xF2B33D, radius: 5)
        n.ring(5, 49, 4, 0xE0A030, 1.2)
        G4Draw.smile(n.mirrored(), 24, 19)
        f.svgLine("M124 30H132M122 40H130M124 50H130", 0xB4B2A9, 1.6)
        f.svgLine("M120 88H98M104 83L98 88L104 93", 0x1E7A4C, 2)
    }
}
