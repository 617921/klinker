import SwiftUI

/// Windmill props: the sails, sheaves of grain, a monument plaque, a workbench, millstones
/// turning grain into flour, and wind (or no wind at all).
enum G7MillProps {
    // MARK: Sails

    /// Four lattice sails in a slanted cross round their hub (200 × 176, hub at (100, 84)).
    static func sails(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 200, height: 176))
        for angle in [24.0, 114, 204, 294] {
            var a = f
            a.ctx.translateBy(x: 100, y: 84)
            a.ctx.rotate(by: .degrees(angle))
            // Arm pointing up from the hub; the lattice on its right.
            a.rect(-2.5, -92, 5, 92, 0x4A3524)
            a.rect(2.5, -90, 18, 72, 0x2E2117, radius: 0, 0.18)
            var grid = ""
            for y in stride(from: -90.0, through: -18, by: 9) { grid += "M2.5 \(y)H20.5" }
            grid += "M8.5 -90V-18M14.5 -90V-18M20.5 -90V-18"
            a.svgLine(grid, 0xEFEBE2, 1.4)
            a.rect(-2.5, -92, 5, 14, 0xC8261B)
            a.rect(-2.5, -78, 5, 6, 0xFFFDF6)
        }
        f.dot(100, 84, 7, 0x2E2117)
        f.dot(100, 84, 3, 0x5E6B73)
    }

    // MARK: Grain

    /// Three sheaves of ripe grain on a stubble field, two big ears in front (96 × 92).
    static func wheat(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 92))
        f.oval(2, 72, 92, 18, 0xD9C08F)
        f.svgLine("M10 82V78M22 86V82M70 86V82M84 80V76M46 88V84", 0xB49A66, 1.4)
        for (x, s) in [(22.0, 0.86), (72, 0.86), (47, 1)] as [(CGFloat, CGFloat)] {
            sheaf(f.within(CGRect(x: x - 22 * s, y: 80 - 76 * s, width: 44 * s, height: 76 * s), unit: s))
        }
        for (x, tilt) in [(14.0, -14.0), (84, 12)] as [(CGFloat, Double)] {
            var e = f
            e.ctx.translateBy(x: x, y: 90)
            e.ctx.rotate(by: .degrees(tilt))
            e.svgLine("M0 0V-26", 0xC9A15B, 1.6)
            for k in 0..<5 {
                let y = -28 - CGFloat(k) * 4.4
                e.oval(-5.5, y, 5, 7, 0xE0A93A)
                e.oval(0.5, y, 5, 7, 0xE0A93A)
            }
            e.svgLine("M0 -50V-60M-3 -48L-6 -58M3 -48L6 -58", 0xC9A15B, 0.9)
        }
    }

    /// One sheaf in a 44 × 76 box: stalks fanning out above and below a tie, ears on top.
    private static func sheaf(_ f: PropPen) {
        f.svg("M10 76L18 40L4 14Q22 2 40 14L26 40L34 76Z", 0xE0A93A)
        f.svgLine("M18 40L14 74M22 40V76M26 40L30 74M18 40L10 18M22 40V8M26 40L34 18", 0xC9A15B, 1)
        for (x, y) in [(6.0, 12.0), (14, 6), (22, 3), (30, 6), (38, 12)] as [(CGFloat, CGFloat)] {
            f.oval(x - 3, y - 6, 6, 11, 0xF2C04E)
        }
        f.rect(15, 38, 14, 5, 0xB07F4E, radius: 1)
    }

    // MARK: Plaque

    /// A blue and white shield on an enamel plaque, `caption` and `text` under it (46 × 56).
    static func shield(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 46, height: 56))
        f.rect(1, 2, 44, 54, 0x1E1E1C, radius: 4, 0.18)
        f.rect(0, 0, 44, 53, 0xFFFDF6, radius: 4)
        f.stroke(Path(roundedRect: CGRect(x: 2, y: 2, width: 40, height: 49), cornerRadius: 3), 0x1F3A6B, 1.4)
        let shield = "M10 6H34V20Q34 30 22 35Q10 30 10 20Z"
        f.svg(shield, 0xFFFDF6)
        f.svg("M10 6H34L22 18Z", 0x1F3A6B)
        f.svg("M15 12H29V20Q29 26 22 30Q15 26 15 20Z", 0x1F3A6B)
        f.svgLine(shield, 0x1F3A6B, 1.2)
        if let caption = p.caption { f.text(caption, PropFont.demi(6.5), 0x1F3A6B, at: CGPoint(x: 22, y: 40), maxWidth: 38) }
        if let text = p.text { f.text(text, PropFont.heavy(8.5), 0x1F3A6B, at: CGPoint(x: 22, y: 47), maxWidth: 38) }
    }

    // MARK: Workbench

    /// A craftsman's bench (90 × 104): a wooden cogwheel half made, mallet and chisel, a saw and a
    /// plane, curls of wood on the floor.
    static func workbench(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 90, height: 104))
        f.oval(2, 98, 86, 6, 0x1E1E1C, 0.15)
        f.svgLine("M10 60V100M80 60V100M14 60L14 100M76 60V100", 0x8A5C38, 5)
        f.rect(8, 86, 74, 4, 0x8A5C38)
        f.rect(2, 54, 86, 8, 0xC9965F, radius: 1)
        f.rect(2, 60, 86, 3, 0x9A6A42)
        // Cogwheel with pegs
        f.dot(40, 30, 20, 0xB07F4E)
        for k in 0..<10 {
            let a = Double(k) * .pi / 5
            f.rect(40 + cos(a) * 21 - 2.5, 30 + sin(a) * 21 - 2.5, 5, 5, 0x8A5C38, radius: 1)
        }
        f.dot(40, 30, 13, 0xC9965F)
        f.svgLine("M40 17V43M27 30H53", 0x8A5C38, 3)
        f.dot(40, 30, 3.4, 0x4A3524)
        f.rect(30, 50, 20, 4, 0x8A5C38)
        // Mallet and chisel
        f.svgLine("M58 52L76 40", 0x9A6A42, 3)
        f.rect(72, 32, 14, 11, 0xB07F4E, radius: 2)
        f.svgLine("M62 50L72 36", 0x7D8A92, 2)
        f.svgLine("M58 54L64 46", 0xC8261B, 3.6)
        // Saw on the wall and wood curls
        f.svg("M2 8H22L22 16L2 22Z", 0xB4B2A9)
        f.rect(20, 6, 8, 12, 0x9A6A42, radius: 2)
        f.svgLine("M2 22L4 20L6 22L8 20L10 22L12 20L14 22L16 20L18 22", 0x7D8A92, 1)
        f.svgLine("M24 98Q20 94 24 92Q28 92 26 96M50 100Q46 95 51 93M64 98Q61 94 65 93", 0xE2C08F, 1.6)
    }

    // MARK: Millstones

    /// Two millstones (96 × 98): grain falls from a hopper into the top stone, which turns (arrow);
    /// white flour runs from a spout into a sack.
    static func millstones(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 98))
        f.oval(2, 90, 92, 8, 0x1E1E1C, 0.15)
        f.svg("M26 2H62L52 22H36Z", 0x9A6A42)
        f.svg("M29 4H59L56 10H32Z", 0xE0A93A)
        for (x, y) in [(42.0, 26.0), (46, 30), (44, 34), (40, 31)] as [(CGFloat, CGFloat)] { f.oval(x, y, 3, 4, 0xE0A93A) }
        // Bottom and top stones
        f.rect(6, 62, 76, 22, 0x8E8A80, radius: 4)
        f.oval(6, 56, 76, 14, 0xA19E95)
        f.rect(10, 44, 68, 18, 0xB4B2A9, radius: 4)
        f.oval(10, 38, 68, 13, 0xD3D1C7)
        f.oval(38, 41, 12, 6, 0x5E6B73)
        f.svgLine("M18 50H70M20 70H72", 0x8E8A80, 1)
        f.svgLine("M16 34Q44 24 72 34", 0xC8261B, 2.4)
        f.svg("M68 29L76 35L67 38Z", 0xC8261B)
        // Flour spout and sack
        f.svg("M80 66H88L90 74H82Z", 0x9A6A42)
        f.svgLine("M86 74V80", 0xFFFDF6, 3)
        f.svg("M74 98Q70 86 76 80H94Q98 86 96 98Z", 0xFFFDF6)
        f.oval(78, 80, 14, 4, 0xEFEBE2)
        f.svgLine("M80 90H90", 0xD3D1C7, 1)
    }

    // MARK: Wind

    /// Wind (120 × 100). `variant` 0: a tree bent over, leaves flying, a windsock straight out and
    /// gusts. 1: no wind: the tree upright and mirrored in still water, the windsock hanging limp.
    static func wind(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 120, height: 100))
        let still = (p.variant ?? 0) == 1
        f.oval(4, 90, 112, 8, 0x1E1E1C, 0.12)
        // Windsock on a pole
        f.rect(92, 16, 3, 76, 0x5E6B73)
        if still {
            f.svg("M94 18H100L99 46H95Z", 0xF2711C)
            f.svg("M94.4 26H99.6L99.4 32H94.6Z M94.8 38H99.2L99 44H95Z", 0xFFFDF6)
        } else {
            f.svg("M95 16L120 19V25L95 28Z", 0xF2711C)
            f.svg("M101 16.7H107V27.3H101Z M112 18H117V26H112Z", 0xFFFDF6)
        }
        if still {
            f.oval(0, 74, 84, 22, 0x8FB6CF)
            f.oval(6, 78, 72, 14, 0xA9CBE0)
            f.rect(40, 54, 5, 24, 0x6B4A2E)
            f.dot(42, 36, 20, 0x5E8C45)
            f.dot(30, 44, 12, 0x5E8C45)
            f.dot(55, 44, 12, 0x5E8C45)
            var m = f
            m.ctx.clip(to: Path(ellipseIn: CGRect(x: 6, y: 78, width: 72, height: 14)))
            m.rect(40, 78, 5, 6, 0x6B4A2E, 0.5)
            m.dot(42, 92, 12, 0x5E8C45, 0.45)
            m.svgLine("M14 84H30M52 88H66", 0xFFFFFF, 1, 0.8)
        } else {
            f.svg("M36 92Q40 70 52 56L56 58Q46 72 44 92Z", 0x6B4A2E)
            f.oval(44, 30, 62, 30, 0x5E8C45)
            f.oval(56, 22, 44, 20, 0x6E9C52)
            f.oval(40, 40, 30, 18, 0x4E7A3A)
            for (x, y, a) in [(84.0, 64.0, 20.0), (100, 52, -30), (110, 74, 40), (74, 80, -10)] as [(CGFloat, CGFloat, Double)] {
                var l = f
                l.ctx.translateBy(x: x, y: y)
                l.ctx.rotate(by: .degrees(a))
                l.oval(-4, -2, 8, 4, 0x6E9C52)
            }
            f.svgLine("M0 20Q20 14 36 22Q46 28 40 34Q34 36 34 30M4 50H34M0 66Q14 60 26 66", 0xFFFDF6, 2.2)
        }
    }
}

/// Windmill people and things: dancers in costume, hands holding a mill safe, and a typical
/// Dutch set of clogs, cheese and tulips.
enum G7MillPeople {
    /// A couple in traditional costume dancing hand in hand, music notes over them (112 × 114).
    static func dancers(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 114))
        f.oval(4, 106, 104, 7, 0x1E1E1C, 0.15)
        // Man: wide black trousers, dark jacket, red scarf, round cap, clogs
        f.svgLine("M18 82L12 102M28 82L34 102", 0x1E1E1C, 7)
        f.svg("M10 100H22L20 107H6Q4 104 10 100Z M30 100H42Q46 104 42 107H28Z", 0xF2C04E)
        f.svg("M10 84L12 46C13 38 17 34 23 34C29 34 33 38 34 46L36 84Z", 0x1E1E1C)
        f.svg("M12 66H34L36 86H10Z", 0x2E2117)
        f.svg("M17 34L23 42L29 34Z", 0xC8261B)
        f.dot(20, 50, 1.6, 0xC9A15B)
        f.dot(20, 58, 1.6, 0xC9A15B)
        f.dot(23, 21, 11, 0xE8C4A0)
        f.svg("M11 18Q11 8 23 8Q35 8 35 18Z", 0x1E1E1C)
        f.rect(9, 16, 28, 3, 0x1E1E1C, radius: 1.5)
        f.dot(29, 22, 1.3, 0x2E2117)
        f.svgLine("M13 44Q6 56 10 66", 0x1E1E1C, 6)
        f.svgLine("M33 44Q44 40 52 50", 0x1E1E1C, 6)
        // Woman: tall white lace cap, striped skirt, apron, clogs
        let x: CGFloat = 54
        f.svgLine("M\(x + 18) 96V104M\(x + 28) 96V104", 0x1E1E1C, 4)
        f.svg("M\(x + 12) 102H\(x + 24)Q\(x + 26) 106 \(x + 22) 108H\(x + 10)Z M\(x + 24) 102H\(x + 36)Q\(x + 38) 106 \(x + 34) 108H\(x + 22)Z", 0xF2C04E)
        f.svg("M\(x + 4) 98Q\(x + 6) 70 \(x + 14) 62H\(x + 34)Q\(x + 42) 70 \(x + 46) 98Z", 0xC8261B)
        f.svgLine("M\(x + 6) 88H\(x + 44)M\(x + 8) 78H\(x + 42)", 0x1E1E1C, 2.4)
        f.svg("M\(x + 16) 62H\(x + 32)L\(x + 34) 94H\(x + 14)Z", 0x2F5BD3)
        f.svg("M\(x + 14) 64L\(x + 15) 44C\(x + 16) 38 \(x + 19) 35 \(x + 24) 35C\(x + 29) 35 \(x + 32) 38 \(x + 33) 44L\(x + 34) 64Z", 0x1E1E1C)
        f.svg("M\(x + 17) 36H\(x + 31)L\(x + 28) 46H\(x + 20)Z", 0xFFFDF6)
        f.dot(x + 24, 23, 10, 0xF1D3B8)
        f.svg("M\(x + 12) 26Q\(x + 10) 4 \(x + 24) 0Q\(x + 38) 4 \(x + 36) 26Q\(x + 34) 14 \(x + 24) 13Q\(x + 14) 14 \(x + 12) 26Z", 0xFFFDF6)
        f.svg("M\(x + 12) 22L\(x + 4) 30L\(x + 12) 28Z M\(x + 36) 22L\(x + 44) 30L\(x + 36) 28Z", 0xFFFDF6)
        f.dot(x + 29, 24, 1.3, 0x2E2117)
        f.dot(x + 32, 28, 2, 0xE8A0A0, 0.6)
        f.svgLine("M\(x + 15) 44Q\(x + 6) 46 \(x - 2) 50", 0x1E1E1C, 6)
        f.dot(x - 2, 50, 3.4, 0xF1D3B8)
        f.svgLine("M\(x + 33) 44Q\(x + 42) 54 \(x + 44) 62", 0x1E1E1C, 6)
        // Music notes
        for (nx, ny) in [(40.0, 8.0), (90, 16), (100, 40)] as [(CGFloat, CGFloat)] {
            f.oval(nx - 4, ny + 8, 6.5, 5, 0xC9A15B)
            f.svgLine("M\(nx + 2) \(ny + 10)V\(ny)L\(nx + 7) \(ny + 2)", 0xC9A15B, 1.6)
        }
    }

    /// Two cupped hands holding a little windmill safe, a red heart over it (72 × 104).
    static func hands(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 72, height: 104))
        let skin: UInt32 = 0xC99A74
        f.svg("M36 20C33 14 24 14 24 21C24 27 36 34 36 34C36 34 48 27 48 21C48 14 39 14 36 20Z", 0xC8261B)
        // Little mill
        f.svg("M30 52H42L46 80H26Z", 0x6B6355)
        f.svg("M29 54Q30 46 36 45Q42 46 43 54Z", 0x3E4C55)
        f.rect(33, 70, 6, 10, 0x2F4B3A)
        for a in [30.0, 120, 210, 300] {
            var s = f
            s.ctx.translateBy(x: 36, y: 50)
            s.ctx.rotate(by: .degrees(a))
            s.rect(-1, -22, 2, 22, 0x4A3524)
            s.rect(1, -21, 6, 15, 0xEFEBE2, radius: 0, 0.9)
        }
        f.dot(36, 50, 2, 0x2E2117)
        // Hands: palms up, fingers curled round the mill's foot, thumbs on top
        let dark = PalaceInk.shade(skin, 0.85)
        f.svg("M2 104L6 84Q8 76 16 76L34 80Q37 84 34 88L20 92L18 104Z", skin)
        f.svg("M70 104L66 84Q64 76 56 76L38 80Q35 84 38 88L52 92L54 104Z", dark)
        for k in 0..<3 {
            let y = 80 + CGFloat(k) * 4
            f.rect(14, y - 4, 22, 4.4, skin, radius: 2.2)
            f.rect(36, y - 4, 22, 4.4, dark, radius: 2.2)
        }
        f.svgLine("M16 78Q22 70 30 72M56 78Q50 70 42 72", PalaceInk.shade(skin, 0.75), 4)
        f.rect(0, 96, 20, 8, 0x2F5BD3)
        f.rect(52, 96, 20, 8, 0x2F5BD3)
    }

    /// A pair of yellow clogs, a round cheese with a slice cut out, and red and yellow tulips (104 × 66).
    static func dutchSet(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 104, height: 66))
        f.oval(2, 58, 100, 8, 0x1E1E1C, 0.14)
        // Tulips in a little pot
        for (x, c, lean) in [(20.0, 0xC8261B, -6.0), (30, 0xFAC775, 0), (40, 0xC8261B, 6)] as [(CGFloat, UInt32, CGFloat)] {
            f.svgLine("M30 44Q\(x - lean / 2) 30 \(x) 16", 0x4E7A3A, 2)
            f.svg("M\(x - 6) 10Q\(x - 6) 22 \(x) 22Q\(x + 6) 22 \(x + 6) 10L\(x + 3) 14L\(x) 8L\(x - 3) 14Z", c)
        }
        f.svg("M24 36Q14 30 18 22Q26 30 28 40Z M36 36Q46 30 42 22Q34 30 32 40Z", 0x5E8C45)
        f.svg("M20 42H40L37 60H23Z", 0xB07F4E)
        // Cheese wheel
        f.oval(44, 30, 34, 28, 0xE0A93A)
        f.svg("M61 44L78 40Q78 48 76 52Z", 0xFAD98A)
        f.svgLine("M61 44L78 40M61 44L76 52", 0xC9A15B, 1)
        f.oval(48, 36, 4, 3, 0xF2C04E)
        // Clogs
        for (x, y) in [(66.0, 48.0), (80, 54)] as [(CGFloat, CGFloat)] {
            f.svg("M\(x) \(y)Q\(x) \(y - 10) \(x + 8) \(y - 10)H\(x + 18)Q\(x + 26) \(y - 8) \(x + 24) \(y + 2)Q\(x + 14) \(y + 6) \(x) \(y + 4)Z", 0xF2C04E)
            f.oval(x + 4, y - 8, 10, 6, 0x9A6A42)
            f.svgLine("M\(x + 16) \(y - 6)Q\(x + 19) \(y - 3) \(x + 22) \(y - 6)", 0xC8261B, 1.4)
        }
    }
}
