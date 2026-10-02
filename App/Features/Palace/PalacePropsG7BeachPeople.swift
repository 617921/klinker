import SwiftUI

/// People on the beach: rubbing in sun cream, paddling with trousers rolled up, lying sunburnt
/// on a towel, and sitting snug behind a windbreak.
enum G7BeachPeople {
    typealias Look = PalaceFigures.Look

    /// `accessory` "cream" | "paddle" | "burnt"; `variant` look.
    static func beachgoer(_ pen: PropPen, _ p: PalacePropParams) {
        let v = Look.at(p.variant ?? 0)
        switch p.accessory {
        case "paddle": paddle(pen.fitted(CGSize(width: 64, height: 114)), v)
        case "burnt": burnt(pen.fitted(CGSize(width: 104, height: 64)), v)
        default: cream(pen.fitted(CGSize(width: 64, height: 114)), v)
        }
    }

    /// Head, hair and eye of a standing beach figure (64 × 114 box).
    private static func head(_ f: PropPen, _ v: Look, skin: UInt32) {
        f.dot(24, 19, 11, skin)
        f.svg("M13 18C12 10 17 6 24 6C31 6 36 10 35 18C33 13 29 11.5 24 11.5C19 11.5 15 13 13 18Z", v.hair)
        f.dot(30, 19.5, 1.3, 0x2E2117)
    }

    /// Standing in a swimsuit, rubbing cream into one arm; the bottle waits on the sand.
    private static func cream(_ f: PropPen, _ v: Look) {
        let skin = v.skin
        f.oval(6, 106, 56, 6, 0x1E1E1C, 0.15)
        f.svgLine("M19 76V104M29 76V104", skin, 6)
        f.svgLine("M15 42C11 52 11 60 13 66", PalaceInk.shade(skin, 0.9), 6)
        f.svg("M13 76L14 46C15 38 19 34 24 34C29 34 33 38 34 46L35 76Q24 82 13 76Z", v.coat)
        f.svgLine("M18 34L19 40M30 34L29 40", v.coat, 2)
        f.svg("M17 34Q24 38 31 34L30 31H18Z", skin)
        head(f, v, skin: skin)
        // Front arm held out, the other hand rubbing cream into it
        f.svgLine("M32 42Q42 48 54 46", skin, 6)
        f.svgLine("M38 46Q44 49 50 47", 0xFFFFFF, 2.6)
        f.svgLine("M16 44Q26 52 42 48", PalaceInk.shade(skin, 0.92), 5.5)
        f.dot(43, 47.5, 3.4, PalaceInk.shade(skin, 0.92))
        f.svgLine("M40 36q4 -4 8 0M44 58q4 4 8 0", 0xB4B2A9, 1.4)
        f.svg("M50 34L52 30L54 34Z M54 58L56 62L52 61Z", 0xB4B2A9)
        // The bottle on the sand
        f.svg("M46 108Q45 92 48 86H58Q61 92 60 108Z", 0xF2711C)
        f.rect(50, 80, 6, 7, 0xFFFDF6, radius: 1)
        f.dot(53, 79, 2.4, 0xFFFFFF)
    }

    /// Trousers rolled up to the knee, shoes in hand, feet in the shallow sea.
    private static func paddle(_ f: PropPen, _ v: Look) {
        let skin = v.skin
        f.svgLine("M19 80V106M29 80V106", skin, 5)
        f.svg("M12 82L13 66H35L36 82Z", v.trousers)
        f.svg("M11 84H22V80H11Z M26 84H37V80H26Z", PalaceInk.shade(v.trousers, 1.25))
        f.svg("M11 70L12.5 44C13.5 36 17.5 32 24 32C30.5 32 34.5 36 35.5 44L37 70Z", v.coat)
        f.svgLine("M15 42C11 52 11 60 13 66", PalaceInk.shade(v.coat, 0.8), 6)
        f.dot(13.5, 68, 3.1, skin)
        head(f, v, skin: skin)
        f.svgLine("M33 42C38 48 42 52 46 50", v.coat, 6)
        f.dot(47, 50, 3.2, skin)
        f.svg("M44 52H52Q55 52 55 56V58H44Z M46 58H55Q58 58 58 62V64H46Z", 0x2E2117)
        // Shallow water round the ankles
        f.oval(4, 100, 48, 12, 0x7FA7C0)
        f.stroke(Path(ellipseIn: CGRect(x: 10, y: 99, width: 16, height: 5)), 0xFFFFFF, 1.4)
        f.stroke(Path(ellipseIn: CGRect(x: 22, y: 99, width: 16, height: 5)), 0xFFFFFF, 1.4)
        f.svgLine("M2 108Q10 105 18 108M38 108Q46 105 54 108", 0xFFFFFF, 1.4, 0.8)
    }

    /// Lying on a striped towel, red all over except the white strap marks, the sun beating down.
    private static func burnt(_ f: PropPen, _ v: Look) {
        let red: UInt32 = 0xE0604A
        f.svg("M6 46L94 40L100 60L10 64Z", 0xFFFDF6)
        f.svgLine("M24 45L26 63M44 44L46 62M64 43L66 61M84 41L86 59", 0x2F5BD3, 5)
        // Body lying along the towel, head on the right
        f.svgLine("M14 52H40", red, 7)
        f.svgLine("M14 48H40", red, 6)
        f.svg("M38 44H70Q76 44 76 50Q76 56 70 56H38Z", v.coat)
        f.svgLine("M48 44V56M62 44V56", 0xFFFFFF, 1.6)
        f.svgLine("M70 46L86 42", red, 5)
        f.dot(84, 48, 9, red)
        f.svg("M76 46Q78 38 86 39Q93 41 93 48Q90 43 86 43Q80 43 76 46Z", v.hair)
        f.rect(80, 46, 9, 3.4, 0x1E1E1C, radius: 1.5)
        f.svgLine("M4 46H14", red, 6)
        // Heat squiggles and the sun
        f.svgLine("M30 34q3 -4 0 -8t0 -8M50 32q3 -4 0 -8t0 -8M70 30q3 -4 0 -8t0 -8", 0xF2711C, 1.6)
        PalaceIcon.sun.draw(f, in: CGRect(x: 2, y: 0, width: 26, height: 26), color: 0xF2C04E, detail: 0xFFFDF6)
    }

    /// A striped windbreak on poles (120 × 92): gusts from the left stop at it; someone sits snug
    /// behind it in a beach chair with a book.
    static func windscreen(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 120, height: 92))
        let v = Look.at(p.variant ?? 5)
        f.oval(30, 84, 88, 8, 0x1E1E1C, 0.12)
        f.svgLine("M0 30Q10 26 20 32M0 46Q12 42 22 48M2 62Q12 58 20 64", 0xFFFDF6, 2.2)
        f.svg("M18 34L22 30M18 48L22 44", 0xFFFDF6, 1)
        // Windbreak panels
        let stripes: [UInt32] = [0x2F5BD3, 0xFFFDF6, 0xC8261B, 0xFFFDF6, 0x2F5BD3, 0xFFFDF6]
        for (i, c) in stripes.enumerated() {
            let x0 = 26 + CGFloat(i) * 6, x1 = x0 + 6
            f.svg("M\(x0) \(22 + CGFloat(i) * 1.6)L\(x1) \(22 + CGFloat(i + 1) * 1.6)V\(80)H\(x0)Z", c)
        }
        f.svgLine("M26 16V86M44 18V86M62 20V86", 0x8A5C38, 2.6)
        // Chair and sitter behind it
        f.svgLine("M74 86L82 60M104 86L96 62M78 74H102", 0x9A6A42, 2)
        f.svg("M76 58H104L100 76H80Z", 0x0F6E56)
        f.svg("M80 74L82 52C83 46 86 44 90 44C94 44 97 46 98 52L99 74Z", v.coat)
        f.dot(90, 34, 9, v.skin)
        f.svg("M81 33C80 26 84 23 90 23C96 23 100 26 99 33C97 29 94 28 90 28C86 28 83 29 81 33Z", v.hair)
        f.svgLine("M86 37Q90 39 94 37", 0x8C5A3C, 1.1)
        f.rect(82, 52, 18, 12, 0xFFFDF6, radius: 1)
        f.svgLine("M91 52V64", 0xC8261B, 1.2)
        f.svgLine("M96 74L108 78L110 86M84 74L96 80L98 86", v.skin, 4)
    }
}
