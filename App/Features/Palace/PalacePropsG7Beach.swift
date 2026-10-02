import SwiftUI

/// Beach props: a curling wave, a bottle of sun cream, a beach pavilion, the lifeguards' chair,
/// a rip current, a jellyfish and the seafront promenade.
enum G7BeachProps {
    // MARK: Sea

    /// A big wave rising and curling over, with foam and spray (96 × 108).
    static func wave(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 108))
        f.svg("M0 108V84Q20 80 34 64Q46 30 72 22Q96 18 96 44V108Z", 0x5E8FB0)
        f.svg("M30 70Q42 36 70 28Q90 26 92 44Q84 34 72 38Q56 44 52 66Q50 84 64 96L96 92V108H0V88Q20 84 30 70Z", 0x7FA7C0)
        f.svg("M52 66Q56 46 72 40Q84 36 90 44Q80 42 74 48Q66 56 68 70Z", 0x3E6E8E)
        f.svg("M60 24Q80 14 94 24Q100 34 94 46Q92 34 82 30Q72 26 62 30Z", 0xFFFFFF)
        for (x, y, r) in [(58.0, 18.0, 3.0), (68, 12, 2.4), (80, 10, 2.8), (90, 14, 2.2), (50, 26, 2.2)] as [(CGFloat, CGFloat, CGFloat)] {
            f.dot(x, y, r, 0xFFFFFF, 0.9)
        }
        f.svgLine("M2 92Q14 88 22 92M10 100Q24 96 34 100M62 100Q72 96 84 100", 0xFFFFFF, 1.6, 0.8)
    }

    /// A rip current (140 × 84): bold arrows curving out to sea, swirls, and a beach ball being
    /// carried away.
    static func current(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 140, height: 84))
        f.svgLine("M20 74Q40 40 80 34Q104 30 120 14", 0x1F3A6B, 4.5)
        f.svg("M112 8L128 6L124 22Z", 0x1F3A6B)
        f.svgLine("M44 82Q66 58 98 54Q118 52 132 40", 0x1F3A6B, 3.5)
        f.svg("M126 34L140 36L130 48Z", 0x1F3A6B)
        f.svgLine("M30 52q4 -8 10 -4t2 10q-6 4 -10 -2M70 70q4 -8 10 -4t2 10q-6 4 -10 -2", 0xFFFFFF, 1.6)
        // Ball drifting out
        f.dot(96, 24, 9, 0xFFFDF6)
        f.svg("M96 15A9 9 0 0 1 105 24H96Z M96 33A9 9 0 0 1 87 24H96Z", 0xC8261B)
        f.svg("M105 24A9 9 0 0 1 96 33V24Z", 0x2F5BD3)
        f.svgLine("M84 34Q96 38 108 34", 0xFFFFFF, 1.4, 0.8)
    }

    /// A jellyfish washed up on the wet sand (66 × 52): a see-through dome with purple rings and
    /// wavy tentacles, a sheen of water round it.
    static func jellyfish(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 66, height: 52))
        f.oval(0, 30, 66, 20, 0xA9CBE0, 0.6)
        f.svgLine("M18 34Q14 40 18 44Q22 48 18 52M28 36Q26 42 30 46M38 36Q42 42 38 48M48 34Q52 40 48 46", 0xB9A6D6, 2)
        f.svg("M8 34Q8 6 33 6Q58 6 58 34Q46 40 33 38Q20 40 8 34Z", 0xD9CCEA, 0.95)
        f.svg("M14 30Q16 14 33 12Q50 14 52 30Q42 34 33 33Q24 34 14 30Z", 0xE8DFF2)
        for (x, y) in [(24.0, 22.0), (33, 18), (42, 22), (33, 28)] as [(CGFloat, CGFloat)] { f.ring(x, y, 3.6, 0x7F6FB0, 1.8) }
        f.svgLine("M18 12Q24 8 30 9", 0xFFFFFF, 1.6)
    }

    // MARK: Things on the sand

    /// A squeeze bottle of sun cream (48 × 86): a sun on the label, `text` (a factor), a blob of cream.
    static func sunscreen(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 48, height: 86))
        f.oval(4, 80, 40, 6, 0x1E1E1C, 0.15)
        f.svg("M8 82Q6 40 12 24H36Q42 40 40 82Z", 0xF2711C)
        f.rect(16, 10, 16, 16, 0xFFFDF6, radius: 2)
        f.rect(19, 2, 10, 10, 0xFFFDF6, radius: 2)
        f.svg("M24 2Q30 -2 32 4Q28 6 24 4Z", 0xFFFFFF)
        f.rect(11, 36, 26, 36, 0xFFFDF6, radius: 3)
        PalaceIcon.sun.draw(f, in: CGRect(x: 14, y: 38, width: 20, height: 20), color: 0xF2C04E, detail: 0xFFFDF6)
        if let text = p.text { f.text(text, PropFont.heavy(9), 0xC8261B, at: CGPoint(x: 24, y: 65), maxWidth: 24) }
        f.svgLine("M14 30Q18 28 20 32", 0xFFFFFF, 1.4, 0.6)
    }

    /// The lifeguards' tall white chair (76 × 144): a red over yellow flag, a red and white ring buoy,
    /// a lifeguard in red and yellow looking out through binoculars.
    static func lifeguard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 144))
        f.oval(6, 138, 64, 6, 0x1E1E1C, 0.15)
        f.svgLine("M16 140L24 70M60 140L52 70M20 110H56M18 124H58M22 96H54", 0xFFFDF6, 3.2)
        f.svgLine("M16 140L24 70M60 140L52 70", 0xD3D1C7, 1)
        f.rect(18, 64, 40, 8, 0xFFFDF6, radius: 1)
        // Flag
        f.rect(64, 6, 2.6, 134, 0x5E6B73)
        f.svg("M66.6 8H76V20H66.6Z", 0xC8261B)
        f.svg("M66.6 20H76V32H66.6Z", 0xFAC775)
        // Lifeguard on the seat
        f.svgLine("M30 64L28 80M40 64L42 80", 0xC8261B, 5)
        f.svg("M26 64L27 42C28 36 31 34 35 34C39 34 42 36 43 42L44 64Z", 0xFAC775)
        f.svg("M27 54H43V64H27Z", 0xC8261B)
        f.dot(35, 24, 9, 0xC99A74)
        f.svg("M26 22Q26 14 35 14Q44 14 44 22Z", 0xC8261B)
        f.svgLine("M40 42Q46 36 44 28", 0xFAC775, 4.5)
        f.rect(40, 20, 10, 7, 0x1E1E1C, radius: 2)
        // Ring buoy on the leg
        f.ring(20, 92, 8, 0xC8261B, 5)
        for k in 0..<4 {
            let a = Double(k) * .pi / 2 + .pi / 4
            f.line(20 + cos(a) * 5.5, 92 + sin(a) * 5.5, 20 + cos(a) * 10.5, 92 + sin(a) * 10.5, 0xFFFDF6, 2.4)
        }
    }

    /// A wooden beach pavilion on posts (124 × 94): big windows, a terrace with parasols and
    /// chairs, flags on the roof.
    static func beachCafe(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 124, height: 94))
        f.oval(2, 88, 120, 6, 0x1E1E1C, 0.12)
        f.svgLine("M10 66V92M40 66V92M70 66V92M100 66V92M118 66V92", 0x8A5C38, 3)
        f.rect(4, 60, 118, 7, 0xB07F4E)
        f.rect(8, 24, 68, 38, 0xEFEBE2)
        f.svgLine("M8 32H76M8 40H76M8 48H76M8 56H76", 0xD9CDB4, 1)
        f.rect(4, 18, 76, 7, 0x2F5BD3)
        f.rect(14, 32, 16, 20, 0x8FB6CF, radius: 1)
        f.rect(34, 32, 16, 20, 0x8FB6CF, radius: 1)
        f.rect(54, 32, 14, 28, 0x6B4A2E, radius: 1)
        for (x, c) in [(20.0, 0x2F5BD3), (50, 0xC8261B)] as [(CGFloat, UInt32)] {
            f.svgLine("M\(x) 18V8", 0x5E6B73, 1.4)
            f.svg("M\(x) 8H\(x + 10)L\(x + 8) 11L\(x + 10) 14H\(x)Z", c)
        }
        // Terrace: parasols, a table and chairs
        f.rect(80, 50, 42, 2, 0xFFFDF6)
        for (x, c) in [(92.0, 0xC8261B), (112, 0xFAC775)] as [(CGFloat, UInt32)] {
            f.svgLine("M\(x) 34V60", 0x5E6B73, 1.6)
            f.svg("M\(x - 12) 36Q\(x) 22 \(x + 12) 36Z", c)
            f.svgLine("M\(x - 12) 36Q\(x) 32 \(x + 12) 36", 0xFFFDF6, 1.2)
        }
        f.rect(86, 52, 14, 3, 0xFFFDF6)
        f.svgLine("M84 60V52M102 60V52M108 60V52", 0xFFFDF6, 1.6)
    }

    /// The seafront promenade (168 × 84): pastel flats behind, a paved walk with lamp posts and a
    /// white railing, a bench and a couple strolling, steps down to the dune.
    static func promenade(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 168, height: 84))
        let flats: [(CGFloat, CGFloat, UInt32)] = [(0, 16, 0xE3D6BC), (34, 4, 0xBCCDD6), (66, 20, 0xF2E4BE), (98, 10, 0xD9CDB4), (130, 22, 0xE8DCC8)]
        for (x, top, c) in flats {
            f.rect(x, top, 32, 52 - top, c)
            var y = top + 5
            while y < 46 {
                f.rect(x + 4, y, 24, 4, 0x8FB6CF)
                f.svgLine("M\(x + 4) \(y + 4)H\(x + 28)", 0xFFFDF6, 1)
                y += 9
            }
        }
        f.rect(0, 50, 168, 12, 0xC9C6BC)
        f.svgLine("M0 54H168", 0xB4B2A9, 1)
        f.rect(0, 62, 168, 6, 0x8E8A80)
        for x in stride(from: CGFloat(20), to: 168, by: 48) {
            f.rect(x - 1, 26, 2.4, 30, 0x2E2117)
            f.svg("M\(x - 4) 26H\(x + 5)L\(x + 3) 20H\(x - 2)Z", 0x2E2117)
            f.dot(x + 0.5, 24, 2.4, 0xFAC775)
        }
        f.svgLine("M0 52H168M0 57H168", 0xFFFDF6, 1.4)
        for x in stride(from: CGFloat(6), to: 168, by: 12) { f.svgLine("M\(x) 52V62", 0xFFFDF6, 1.2) }
        // Bench and strollers
        f.rect(52, 44, 18, 3, 0x9A6A42)
        f.svgLine("M54 47V51M68 47V51", 0x2E2117, 1.4)
        PalaceFigures.mini(f.within(CGRect(x: 96, y: 22, width: 15, height: 30), unit: 0.5), PalaceFigures.Look.at(0), walking: true, briefcase: false)
        PalaceFigures.mini(f.within(CGRect(x: 106, y: 22, width: 15, height: 30), unit: 0.5), PalaceFigures.Look.at(3), walking: true, briefcase: false)
        f.svg("M140 68L150 84H170V68Z", 0xC9C6BC, 0.9)
        f.svgLine("M144 72H158M148 76H162M152 80H166", 0x8E8A80, 1)
    }
}
