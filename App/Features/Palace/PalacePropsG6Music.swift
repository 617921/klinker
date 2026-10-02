import SwiftUI

/// Music props: a whole orchestra on its chairs, a conductor and a soloist, and a heap of
/// instruments without players.
enum G6Music {
    static let wood: UInt32 = 0xA0522D
    static let brass: UInt32 = 0xE0B04A

    // MARK: Orchestra

    /// Two rows of seated players in black (178 × 96): horns and a kettle drum at the back,
    /// violins and cellos in front, little music stands between them.
    static func orchestra(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 178, height: 96))
        for (i, x) in [30.0, 58, 86, 114, 142].enumerated() {
            player(f, x, top: 6, scale: 0.8, look: i + 1)
            horn(f, x + 7, 30)
        }
        f.oval(152, 34, 24, 10, 0xB87333)
        f.svg("M152 39Q164 60 176 39Z", 0xB87333)
        f.svgLine("M158 30L166 36M170 30L164 36", 0x5E3A2A, 1.2)
        for (i, x) in [18.0, 52, 86, 120, 154].enumerated() {
            player(f, x, top: 40, scale: 1, look: i + 3)
            if i == 1 || i == 3 { cello(f, x + 6, 62) } else { violin(f, x + 2, 52) }
            f.svgLine("M\(x + 20) 96V76", 0x1E1E1C, 1)
            f.rect(x + 14, 70, 12, 7, 0xFFFDF6, radius: 0.5)
        }
    }

    /// A seated player in concert black: head, white collar, shoulders down to a chair.
    private static func player(_ f: PropPen, _ x: CGFloat, top: CGFloat, scale s: CGFloat, look: Int) {
        let v = PalaceFigures.Look.at(look)
        f.rect(x - 11 * s, top + 22 * s, 22 * s, 34 * s, 0x1E1E1C, radius: 7 * s)
        f.svg("M\(x - 4 * s) \(top + 22 * s)L\(x) \(top + 28 * s)L\(x + 4 * s) \(top + 22 * s)Z", 0xFFFDF6)
        f.dot(x, top + 13 * s, 9 * s, v.skin)
        f.svg("M\(x - 9 * s) \(top + 12 * s)C\(x - 9 * s) \(top + 2 * s) \(x + 9 * s) \(top + 2 * s) \(x + 9 * s) \(top + 12 * s)C\(x + 5 * s) \(top + 7 * s) \(x - 5 * s) \(top + 7 * s) \(x - 9 * s) \(top + 12 * s)Z", v.hair)
    }

    static func violin(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, angle: Double = -0.5, scale s: CGFloat = 1) {
        var g = f
        g.ctx.translateBy(x: x, y: y)
        g.ctx.rotate(by: .radians(angle))
        g.ctx.scaleBy(x: s, y: s)
        g.svg("M-4 -6C-7 -6 -7 -2 -5 0C-7 2 -7 6 -4 6C-1 6 0 4 0 4C0 4 1 6 4 6C7 6 7 2 5 0C7 -2 7 -6 4 -6C1 -6 0 -4 0 -4C0 -4 -1 -6 -4 -6Z", wood)
        g.rect(-0.8, -15, 1.6, 10, 0x2E2117)
        g.dot(0, -15.5, 1.4, 0x2E2117)
        g.svgLine("M-10 8L12 -10", 0x8C7A66, 0.9)
    }

    private static func cello(_ f: PropPen, _ x: CGFloat, _ y: CGFloat) {
        f.svg("M\(x - 8) \(y - 10)C\(x - 12) \(y - 6) \(x - 10) \(y) \(x - 8) \(y + 2)C\(x - 12) \(y + 6) \(x - 11) \(y + 16) \(x) \(y + 16)C\(x + 11) \(y + 16) \(x + 12) \(y + 6) \(x + 8) \(y + 2)C\(x + 10) \(y) \(x + 12) \(y - 6) \(x + 8) \(y - 10)C\(x + 4) \(y - 13) \(x - 4) \(y - 13) \(x - 8) \(y - 10)Z", wood)
        f.rect(x - 1, y - 28, 2, 20, 0x2E2117)
        f.svgLine("M\(x) \(y + 16)V\(y + 22)", 0x8E9AA0, 1)
        f.svgLine("M\(x - 16) \(y + 4)L\(x + 14) \(y + 2)", 0x8C7A66, 0.9)
    }

    private static func horn(_ f: PropPen, _ x: CGFloat, _ y: CGFloat) {
        f.ring(x, y, 4, brass, 2)
        f.svg("M\(x + 3) \(y - 2)L\(x + 10) \(y - 6)V\(y + 2)Z", brass)
    }

    // MARK: Musicians

    /// `accessory` "baton": a conductor from behind on a little box, both arms up, a white baton
    /// (52 × 106). Otherwise a soloist (64 × 116) playing the violin, notes rising; `variant`.
    static func musician(_ pen: PropPen, _ p: PalacePropParams) {
        if p.accessory == "baton" { return conductor(pen.fitted(CGSize(width: 52, height: 106))) }
        let f = pen.fitted(CGSize(width: 64, height: 116)).mirrored(p.flip == true)
        let v = PalaceFigures.Look.at(p.variant ?? 3)
        let gown: UInt32 = 0x3C3489
        f.oval(6, 108, 52, 6, 0x1E1E1C, 0.16)
        f.svg("M10 108L14 44C15 36 18 33 24 33C30 33 33 36 34 44L40 108Z", gown)
        f.svg("M19 33L24 40L29 33Z", v.skin)
        f.dot(24, 20, 10.5, v.skin)
        f.svg("M13 22C11 8 20 6 25 6C32 6 37 10 35 22C33 15 29 12 24 13C19 13 15 16 13 22Z", v.hair)
        f.dot(14, 30, 4, v.hair)
        f.dot(30, 21, 1.2, 0x2E2117)
        // violin under the chin, bow arm
        violin(f, 30, 36, angle: -0.9, scale: 1.5)
        f.svgLine("M16 42C12 48 18 52 26 46", PalaceInk.shade(gown, 0.8), 5)
        f.svgLine("M33 42C40 46 44 40 48 32", gown, 5)
        f.dot(48.5, 31, 2.8, v.skin)
        f.svgLine("M54 20L36 54", 0x8C7A66, 1.2)
        G6Props.note(f, 48, 12, 0x2F5BD3)
        G6Props.note(f, 58, 4, 0x2F5BD3, scale: 0.8)
    }

    /// From behind: tails, white hair, arms raised, baton up; standing on a low box.
    private static func conductor(_ f: PropPen) {
        f.oval(2, 100, 48, 6, 0x1E1E1C, 0.18)
        f.rect(4, 86, 44, 18, 0x5E3A2A, radius: 1.5)
        f.rect(4, 86, 44, 4, 0x7A5230, radius: 1.5)
        f.svgLine("M21 70V86M31 70V86", 0x1E1E1C, 5)
        f.svg("M12 72L14 40C15 34 19 31 26 31C33 31 37 34 38 40L40 72L34 70L33 80L26 76L19 80L18 70Z", 0x1E1E1C)
        f.svgLine("M26 34V74", 0x3E4C55, 1)
        f.svgLine("M15 38C8 30 8 22 10 14", 0x1E1E1C, 5.5)
        f.svgLine("M37 38C44 30 44 22 42 14", 0x1E1E1C, 5.5)
        f.dot(10, 12, 2.8, 0xE8C4A0)
        f.dot(42, 12, 2.8, 0xE8C4A0)
        f.svgLine("M42 12L50 0", 0xFFFDF6, 1.8)
        f.dot(26, 22, 9, 0xE8C4A0)
        f.svg("M17 22C16 13 21 11 26 11C31 11 36 13 35 22C35 26 32 30 26 30C20 30 17 26 17 22Z", 0xEFEBE2)
        f.rect(20, 30, 12, 3, 0xFFFDF6)
    }

    // MARK: Instruments

    /// A violin with its bow, a trumpet, a flute and a small drum lying together (68 × 72).
    static func instruments(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 68, height: 72))
        f.oval(2, 64, 64, 8, 0x1E1E1C, 0.16)
        // drum
        f.rect(36, 44, 30, 22, 0xC8261B, radius: 2)
        f.oval(36, 40, 30, 9, 0xEFEBE2)
        f.svgLine("M38 50L44 64L50 50L56 64L62 50", 0xFAC775, 1.2)
        f.svgLine("M44 36L58 24M50 38L64 30", 0x8C5E38, 1.6)
        // violin standing up with its bow
        violin(f, 16, 40, angle: 0.25, scale: 2.2)
        f.svgLine("M30 8L22 66", 0x8C7A66, 1.2)
        // trumpet
        f.svgLine("M6 58H34", brass, 3)
        f.svg("M30 58L40 52V64Z", brass)
        f.ring(14, 58, 4, brass, 1.6)
        f.svgLine("M12 54V50M16 54V50M20 54V50", brass, 1.6)
        // flute
        f.svgLine("M2 70L50 66", 0xD3D1C7, 2.4)
        for x in [16.0, 24, 32, 40] as [CGFloat] { f.dot(x, 69 - (x - 2) / 12, 0.9, 0x5E6B73) }
    }
}
