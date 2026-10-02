import SwiftUI

/// The big things of a pool: the water slide, the diving board with someone jumping, the
/// lifeguard's high chair, a changing cubicle and a swimsuit on a hanger.
enum G4PoolProps {
    // MARK: Slide

    /// A water slide (100 × 206): a ladder up to a platform, a yellow chute curving down into the
    /// water with a child sliding, arms up, and a splash at the bottom (water from y 192).
    static func slide(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 206))
        f.svgLine("M10 34V188M28 34V188", 0x9A9890, 3)
        var rungs = ""
        for y in stride(from: 48.0, to: 186, by: 14) { rungs += "M10 \(y)H28" }
        f.svgLine(rungs, 0x9A9890, 2)
        f.svgLine("M6 30V12M42 30V14M6 14Q24 6 42 14", 0x5E6B73, 2.2)
        f.rect(4, 28, 40, 6, 0x3E4C55, radius: 1.5)
        let chute = "M38 34Q52 34 58 52L78 156Q84 184 98 192"
        f.svgLine("M64 92L64 188M76 150L76 188", 0x9A9890, 2.4)
        f.svgLine(chute, 0xF2711C, 15)
        f.svgLine(chute, 0xF2B33D, 9)
        f.svgLine("M40 31Q53 31 59 48L62 62", 0xFFFDF6, 1.4)
        // The child, sliding down feet first with arms up
        f.svgLine("M58 58L66 72", 0xE8C4A0, 4)
        f.svg("M50 46L60 44L62 58L54 60Z", 0x2F5BD3)
        f.svgLine("M52 46L46 32M58 44L60 30", 0xE8C4A0, 3)
        f.dot(46, 31, 2.2, 0xE8C4A0)
        f.dot(60, 29, 2.2, 0xE8C4A0)
        f.dot(53, 39, 6.5, 0xE8C4A0)
        f.svg("M46.5 38C46 33 49 31 53 31C57 31 60 33 59.5 38C58 35 56 34.5 53 34.5C50 34.5 48 35 46.5 38Z", 0xC9A15B)
        f.svgLine("M54 43Q56 44.5 58 43", 0x8C2A1E, 1)
        // Splash
        f.svg("M76 196Q78 184 84 190Q88 176 92 188Q98 180 98 194Z", 0xFFFDF6, 0.9)
        f.svgLine("M74 186L70 180M86 180L86 172M98 184L102 178", 0xFFFDF6, 1.6)
    }

    // MARK: Diving board

    /// A diving board (92 × 200): a ladder tower on the right, the board reaching left, a swimmer
    /// in the air above its tip with arms up, a dotted arc, and the splash below (deck at y 172).
    static func divingBoard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 92, height: 200))
        f.svgLine("M78 98V174M90 98V174", 0x9A9890, 3)
        var rungs = ""
        for y in stride(from: 110.0, to: 172, by: 12) { rungs += "M78 \(y)H90" }
        f.svgLine(rungs, 0x9A9890, 2)
        f.svgLine("M78 98Q78 84 70 84M90 98Q90 80 80 78", 0x5E6B73, 2)
        f.svg("M64 101H82V112H70Z", 0x5E6B73)
        f.rect(4, 96, 84, 6, 0x2F5BD3, radius: 2)
        f.rect(4, 96, 84, 2, 0x8FB6CF, radius: 1)
        f.svgLine("M8 92Q14 70 22 64", 0x5E6B73, 1.2)
        f.svgLine("M10 88L6 84M14 90L12 84", 0x5E6B73, 1)
        // The jumper, stretched out with arms up
        let v = PalaceFigures.Look.at(6)
        f.svgLine("M24 64L22 88M28 64L28 88", v.skin, 4)
        f.svg("M19 42H33L32 64H20Z", 0xC8261B)
        f.svgLine("M20 42L14 20M32 42L36 20", v.skin, 3.6)
        f.dot(14, 18, 2.4, v.skin)
        f.dot(36, 18, 2.4, v.skin)
        f.dot(26, 32, 7.5, v.skin)
        f.svg("M18.6 31C18 25 22 23 26 23C30 23 34 25 33.4 31C31.5 28 29 27.5 26 27.5C23 27.5 20.5 28 18.6 31Z", v.hair)
        f.svgLine("M27 36Q29.5 38 32 36", 0x8C2A1E, 1.1)
        f.svgLine("M10 20L6 16M40 20L44 16M26 10V5", 0xF2B33D, 1.6)
        // Splash in the water under the tip
        f.svg("M6 196Q8 182 14 188Q18 172 24 186Q30 176 34 196Z", 0xFFFDF6, 0.9)
        f.svgLine("M4 184L0 178M38 184L42 178", 0xFFFDF6, 1.6)
    }

    // MARK: Lifeguard

    /// A lifeguard's high chair (60 × 156): white legs and rungs, the lifeguard on top in a red
    /// shirt with a whistle (sound lines), a red and white ring hanging on the chair.
    static func lifeguardChair(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 60, height: 156))
        let v = PalaceFigures.Look.at(p.variant ?? 1)
        f.oval(4, 150, 54, 6, 0x1E1E1C, 0.14)
        f.svgLine("M8 154L18 70M52 154L42 70", 0xFFFDF6, 4)
        f.svgLine("M8 154L18 70M52 154L42 70", 0xB4B2A9, 1)
        f.svgLine("M12 124H48M14.6 102H45.4", 0xFFFDF6, 3)
        f.rect(12, 66, 36, 7, 0xC8261B, radius: 2)
        // Legs dangling, shorts, shirt
        f.svgLine("M24 72V96M33 72V96", v.skin, 4.4)
        f.svg("M20 95H28V99H20Z M30 95H38V99H30Z", 0x2E2117)
        f.rect(19, 60, 22, 12, 0xF2B33D, radius: 3)
        f.svg("M17 62L18 40C19 34 23 32 30 32C37 32 41 34 42 40L43 62Z", 0xC8261B)
        f.svgLine("M19 40C15 48 16 56 20 58", v.skin, 4)
        f.svgLine("M41 40C46 34 46 28 42 24", v.skin, 4)
        f.dot(41, 23, 2.6, v.skin)
        G4Draw.head(f, 30, 20, v)
        f.svg("M19 15C19 9 24 7 30 7C36 7 41 9 41 15H44V17H19Z", 0xC8261B)
        // The whistle and its sound
        f.rect(36, 23, 8, 4, 0xFAC775, radius: 1.5)
        f.svgLine("M30 31Q34 36 40 27", 0x1E1E1C, 0.8)
        f.svgLine("M48 18L54 14M49 24H56M48 30L54 33", 0x1F3A6B, 1.6)
        // The ring
        f.ring(14, 112, 8, 0xC8261B, 4.4)
        for a in [0.4, 2.0, 3.6, 5.2] {
            let x = 14 + cos(a) * 8, y = 112 + sin(a) * 8
            f.line(x - cos(a) * 2.2, y - sin(a) * 2.2, x + cos(a) * 2.2, y + sin(a) * 2.2, 0xFFFDF6, 3)
        }
    }

    // MARK: Cubicle

    /// A changing cubicle (60 × 146): a blue door with a sign (a shirt, an arrow, a swimsuit), a
    /// red T-shirt flung over the top, and under the door bare feet stepping out of trousers.
    static func cubicle(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 60, height: 146))
        f.rect(1, 2, 58, 144, 0xEFEBE2, radius: 2)
        f.rect(4, 6, 52, 136, 0xC4D8DC)
        f.rect(6, 14, 48, 106, 0x2F5BD3, radius: 1.5)
        f.rect(6, 14, 48, 3, 0x1F3A6B)
        f.dot(48, 70, 2, 0xD3D1C7)
        // The sign: shirt → swimsuit
        f.rect(11, 34, 38, 18, 0xFFFDF6, radius: 2)
        f.svg("M15 39L18 37H21L24 39L23 42H21.5V49H17.5V42H16Z", 0xC8261B)
        f.svgLine("M26 44H33M31 41.5L33.5 44L31 46.5", 0x1E1E1C, 1.2)
        f.svg("M37 37H39L40.5 41H42.5L44 37H46L45 43L46 49H37L38 43Z", 0x1F3A6B)
        // T-shirt over the top
        f.svg("M12 8L18 4H26L32 8L30 14L28 13V24H16V13L14 14Z", 0xC8261B)
        f.svg("M16 13V24H28V13Z", 0xA81E15, 0.4)
        // Feet under the door, trousers dropped round one ankle
        f.svgLine("M22 128V138M36 124L38 134", 0xE8C4A0, 4)
        f.svg("M17 137H25V141H17Z", 0xE8C4A0)
        f.svg("M35 133H43V137H35Z", 0xE8C4A0)
        f.svg("M12 136Q14 128 22 130Q30 128 32 136Q30 142 22 141Q14 142 12 136Z", 0x3E5A86)
    }

    // MARK: Swimsuit

    /// A swimsuit on a hanger on a hook (56 × 74): navy with white dots.
    static func swimsuit(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 56, height: 74))
        let suit = PropColor.named(p.tone, 0x1F3A6B)
        f.rect(22, 2, 12, 6, 0x9A9890, radius: 2)
        f.svgLine("M28 6V12Q28 16 31 16", 0x5E6B73, 1.6)
        f.svgLine("M28 16L8 26H48Z", 0x5E6B73, 1.6)
        f.svg("M15 24H19L23 34H33L37 24H41L40 44Q38 56 42 66L36 72H20L14 66Q18 56 16 44Z", suit)
        f.svg("M20 72L28 62L36 72Z", PalaceInk.shade(suit, 1.5))
        for (x, y) in [(22.0, 42.0), (30, 46), (36, 40), (26, 54), (34, 58), (20, 62)] as [(CGFloat, CGFloat)] {
            f.dot(x, y, 1.6, 0xFFFDF6)
        }
        f.svgLine("M17 27Q28 36 39 27", PalaceInk.shade(suit, 0.75), 1)
    }
}
