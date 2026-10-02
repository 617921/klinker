import SwiftUI

/// People who show their word by what they wear and hold (64 × 114, facing right; `flip` faces
/// left). `mount` "desk" cuts the figure at a desk top (64 × 84).
enum G3Workers {
    typealias Look = PalaceFigures.Look

    /// `accessory`: "nurse" (light-blue tunic, fob watch, a chart), "surgeon" (green cap and mask,
    /// gloved hands up with a scalpel, the theatre lamp above), "hairdresser" (black apron, scissors
    /// up, a comb), "professor" (black gown with a white collar and a cap, a thick book), "waiter"
    /// (a student with a backpack and an apron carrying coffee), "graduate" (cap with a tassel, a
    /// diploma roll held high, flowers, confetti), "beard" (a full beard he strokes). `variant` look.
    static func worker(_ pen: PropPen, _ p: PalacePropParams) {
        let desk = p.mount == "desk"
        // The surgeon's lamp hangs above the head: room for it on top.
        let top: CGFloat = p.accessory == "surgeon" ? 16 : 0
        let base = pen.fitted(CGSize(width: 64, height: (desk ? 84 : 114) + top))
        var f = base.mirrored(p.flip == true).within(CGRect(x: 0, y: top, width: 64, height: 114))
        if desk { f.ctx.clip(to: Path(CGRect(x: -20, y: -20, width: 104, height: 104))) }
        let v = Look.at(p.variant ?? 0)
        if !desk { G3Body.shadow(f) }
        switch p.accessory {
        case "nurse": nurse(f, v)
        case "surgeon": surgeon(f, v)
        case "hairdresser": hairdresser(f, v)
        case "professor": professor(f, v)
        case "waiter": waiter(f, v)
        case "graduate": graduate(f, v)
        case "beard": beard(f, v)
        default:
            G3Body.legs(f, v.trousers)
            G3Body.torso(f, v.coat)
            G3Body.head(f, skin: v.skin, hair: v.hair)
        }
    }

    private static func nurse(_ f: PropPen, _ v: Look) {
        let tunic: UInt32 = 0x9CC3DE, dark: UInt32 = 0x6F9CC0
        G3Body.legs(f, dark, shoes: 0xEFEBE2)
        G3Body.shortSleeve(f, upper: "M13 42C11.5 46 11 49 11 52", fore: "M11 52C10.5 58 11 64 12.5 70", PalaceInk.shade(tunic, 0.9), hand: CGPoint(x: 12.5, y: 72), skin: v.skin)
        G3Body.torso(f, tunic, hem: 76)
        f.svg("M17 32L22 41L27 32Z", dark)
        f.svgLine("M10.6 70H34.4", dark, 1.4)
        f.rect(12, 58, 8, 8, PalaceInk.shade(tunic, 0.9), radius: 1)
        f.svgLine("M14 55V59M17 54.5V59", 0x2F5BD3, 1.1)
        f.svgLine("M27 43V46", 0x5E6B73, 1)
        f.dot(27, 49, 3.4, 0xFFFDF6)
        f.ring(27, 49, 3.4, 0x1F3A6B, 1)
        f.svgLine("M27 47V49L28.5 50", 0x1F3A6B, 0.8)
        G3Body.head(f, skin: v.skin, hair: v.hair)
        f.dot(11.5, 12, 4.6, v.hair)
        G3Body.smile(f)
        // A chart held against the chest
        f.rect(35, 46, 17, 23, 0x9A6A42, radius: 2)
        f.rect(37, 50, 13, 17, 0xFFFDF6)
        f.svgLine("M39 54H48M39 58H48M39 62H45", 0xB4B2A9, 1)
        f.rect(40, 44, 7, 4, 0x5E6B73, radius: 1)
        G3Body.shortSleeve(f, upper: "M31 42C33.5 46 34 49 34 52", fore: "M34 52C35 58 37 63 40 65", tunic, hand: CGPoint(x: 41, y: 65), skin: v.skin)
    }

    private static func surgeon(_ f: PropPen, _ v: Look) {
        let gown: UInt32 = 0x3F8A70, glove: UInt32 = 0x8FB6CF
        // The theatre lamp overhead, its light falling on the hands
        f.svg("M30 2Q46 -6 62 2Z", 0xB4B2A9)
        f.svgLine("M46 -2V-12", 0x5E6B73, 2)
        f.svg("M33 2L26 40H66L59 2Z", 0xFAC775, 0.22)
        f.dot(40, 3, 2, 0xFFFDF6)
        f.dot(46, 3.5, 2, 0xFFFDF6)
        f.dot(52, 3, 2, 0xFFFDF6)
        G3Body.legs(f, gown)
        G3Body.torso(f, gown, hem: 92)
        f.svg("M17 32L22 39L27 32Z", PalaceInk.shade(gown, 0.8))
        // Back hand raised, gloved
        f.svgLine("M13 42C7 46 6 40 7 32", gown, 6)
        f.dot(7, 29.5, 3.4, glove)
        G3Body.head(f, skin: v.skin, hair: nil, eye: false)
        f.svg("M10.5 18C10 9 15 5.5 22 5.5C29 5.5 34 9 33.5 18Z", gown)
        f.svgLine("M11 15.5H33", PalaceInk.shade(gown, 0.8), 1)
        f.dot(28, 18.5, 1.3, 0x2E2117)
        f.svgLine("M25.5 16L30 15.4", 0x2E2117, 0.9)
        f.svg("M19 21H33Q34 26 30 29H21Q18 26 19 21Z", 0xA9CBE0)
        f.svgLine("M19 22L12 19M19 26L12.5 24", 0xA9CBE0, 0.9)
        // Front hand up with a scalpel
        f.svgLine("M31 42C37 46 40 40 40 32", gown, 6)
        f.dot(40.5, 29.5, 3.4, glove)
        f.svgLine("M41.5 28L48 18", 0x5E6B73, 2.2)
        f.svg("M48 18L52.5 10L50.5 18.8Z", 0xD3D1C7)
    }

    private static func hairdresser(_ f: PropPen, _ v: Look) {
        let shirt: UInt32 = 0xEFEBE2, apron: UInt32 = 0x2E2117
        G3Body.legs(f, 0x3E4C55)
        f.svgLine("M13 42C10 52 10 62 12 70", PalaceInk.shade(shirt, 0.85), 6)
        f.dot(12.5, 72, 3.1, v.skin)
        G3Body.torso(f, shirt, hem: 70)
        f.svg("M13 46H31L35 92H9Z", apron)
        f.svgLine("M15 46L19 33M29 46L25 33", apron, 1.6)
        f.rect(12, 62, 11, 9, 0x1E1E1C, radius: 1)
        f.rect(13, 58, 9, 4.5, 0xC8261B, radius: 1)
        f.svgLine("M14.5 58V56.8M16.5 58V56.8M18.5 58V56.8M20.5 58V56.8", 0xC8261B, 0.9)
        G3Body.head(f, skin: v.skin, hair: nil)
        f.svg("M11 18C9 10 13 3 21 3C29 2 35 6 34 14C31 9 26 9.5 22 10.5C17 11.5 13 13 11 18Z", v.hair)
        G3Body.smile(f)
        // Scissors held up, open, a comb in the same hand
        f.svgLine("M31 42C37 42 40 36 41 29", shirt, 6)
        f.svgLine("M38.5 36L41 29", v.skin, 4)
        f.dot(41.5, 27, 3.1, v.skin)
        f.ring(40, 31, 2.4, 0x5E6B73, 1.4)
        f.ring(44.5, 30, 2.4, 0x5E6B73, 1.4)
        f.svgLine("M42 28.5L50 14M43.5 28L54 18", 0x9A9890, 2)
        f.rect(26, 20, 3, 12, 0x1E1E1C, radius: 1)
    }

    private static func professor(_ f: PropPen, _ v: Look) {
        let gown: UInt32 = 0x232B3B
        f.svg("M12 103H21V108H12Z M23 103H32V108H23Z", 0x2E2117)
        f.svgLine("M13 42C8 54 7 66 9 76", gown, 9)
        f.dot(10, 78, 3.1, v.skin)
        G3Body.torso(f, gown, hem: 104)
        f.svgLine("M19.5 38L18.5 102M24.5 38L25.5 102", 0x1E1E1C, 3)
        f.svg("M19.5 31H24.5L24 41H20Z", 0xFFFDF6)
        f.svgLine("M22 32V41", 0xD3D1C7, 0.8)
        G3Body.head(f, skin: v.skin, hair: 0xD3D1C7)
        f.svg("M9.5 12Q9 4 22 3.5Q35 4 34.5 12Q22 8.5 9.5 12Z", 0x1E1E1C)
        f.svgLine("M10 11.5Q22 8 34 11.5", 0x3E4C55, 1.2)
        f.ring(28.2, 19.5, 2.9, 0x2E2117, 1.1)
        f.svgLine("M25.3 19.2H23", 0x2E2117, 1.1)
        f.svgLine("M25.5 25.5Q27.5 26.5 29.5 25.5", 0x8C5A3C, 1.1)
        // A thick book held in front
        f.rect(31, 50, 17, 22, 0x7A5230, radius: 1.5)
        f.rect(31, 52, 3, 18, 0xEFEBE2)
        f.rect(37, 56, 8, 3, 0xC9A15B)
        f.svgLine("M31 42C37 48 38 56 36 62", gown, 9)
        f.dot(37, 63, 3.1, v.skin)
    }

    private static func waiter(_ f: PropPen, _ v: Look) {
        f.rect(2, 38, 11, 28, v.bag, radius: 4)
        f.rect(3, 34, 5, 6, 0x2F5BD3, radius: 1)
        f.rect(7.5, 35, 4, 5, 0xFAC775, radius: 1)
        G3Body.legs(f, v.trousers)
        G3Body.torso(f, v.coat, hem: 86)
        f.svg("M10 62H34L35 90H9Z", 0x2E2117)
        f.svgLine("M10 62H34", 0x1E1E1C, 1.4)
        f.svgLine("M17 34L13 46", 0x1E1E1C, 2.2)
        G3Body.head(f, skin: v.skin, hair: v.hair)
        G3Body.smile(f)
        // A tray with two coffees held up at the shoulder
        f.rect(33, 32, 27, 3, 0x9A9890, radius: 1)
        for x in [37.0, 48] as [CGFloat] {
            f.rect(x, 24, 7, 8, 0xFFFDF6, radius: 1.5)
            f.rect(x, 24, 7, 2, 0x6B4A2E, radius: 1)
            f.svgLine("M\(x + 2) 21Q\(x + 4) 18.5 \(x + 2) 16", 0xB4B2A9, 0.9)
        }
        f.svgLine("M31 42C38 46 43 44 45 37", v.coat, 6)
        f.dot(45.5, 35, 3.1, v.skin)
    }

    private static func graduate(_ f: PropPen, _ v: Look) {
        for (x, y, c) in [(4.0, 6.0, 0xC8261B), (38.0, 2.0, 0x2F5BD3), (8.0, 30.0, 0xFAC775), (40.0, 14.0, 0x5DCAA5), (2.0, 20.0, 0xF2711C), (54.0, 8.0, 0xED93B1)] as [(CGFloat, CGFloat, UInt32)] {
            f.rect(x, y, 3.4, 2.2, c, radius: 0.5)
        }
        G3Body.legs(f, v.trousers)
        G3Body.torso(f, v.coat)
        f.svg("M17 32L22 39L27 32Z", 0xEFEBE2)
        // Flowers in the back arm
        f.svgLine("M13 42C9 50 9 58 12 62", PalaceInk.shade(v.coat, 0.8), 6)
        f.svg("M6 58H16L12.5 72H9.5Z", 0x5E8C45)
        for (x, y, c) in [(7.5, 55.5, 0xC8261B), (11.5, 53.5, 0xFAC775), (15, 56, 0xED93B1)] as [(CGFloat, CGFloat, UInt32)] {
            f.dot(x, y, 3, c)
        }
        f.dot(12.5, 63, 3.1, v.skin)
        G3Body.head(f, skin: v.skin, hair: v.hair)
        G3Body.smile(f)
        f.svg("M14 10V14Q22 17 30 14V10Z", 0x1E1E1C)
        f.svg("M8 9L22 3L36 9L22 15Z", 0x1E1E1C)
        f.svgLine("M22 9L34 11V19", 0xFAC775, 1.2)
        f.dot(34, 20, 1.6, 0xFAC775)
        // The diploma roll held high
        f.svgLine("M31 42C37 38 39 30 39 22", v.coat, 6)
        f.svgLine("M33 25L48 6", 0xFFFDF6, 6)
        f.svgLine("M33 25L48 6", 0xD3D1C7, 0.6)
        f.svgLine("M39.3 17L41.7 14", 0xC8261B, 6.4)
        f.dot(39.5, 20, 3.1, v.skin)
    }

    private static func beard(_ f: PropPen, _ v: Look) {
        let hair: UInt32 = 0x7A5230
        G3Body.legs(f, v.trousers)
        f.svgLine("M13 42C10 52 10 62 12 70", PalaceInk.shade(v.coat, 0.78), 6)
        f.dot(12.5, 72, 3.1, v.skin)
        G3Body.torso(f, v.coat)
        G3Body.head(f, skin: v.skin, hair: hair)
        f.svg("M11.5 19C11 31 15 42 23 42C31 42 34.5 31 33.5 19C31 24 28 25.5 23 25.5C18 25.5 14 24 11.5 19Z", hair)
        f.svg("M22 24Q27 20.5 32.5 23.5Q28 26 22 24Z", PalaceInk.shade(hair, 0.8))
        f.svgLine("M16 30Q18 34 17 38M21 31Q22 35 21 40M27 31Q28 35 26.5 39", PalaceInk.shade(hair, 0.8), 1)
        // Stroking the beard
        f.svgLine("M31 44C37 46 37 40 33 36", v.coat, 6)
        f.dot(32, 35, 3.2, v.skin)
    }
}
