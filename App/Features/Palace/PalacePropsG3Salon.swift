import SwiftUI

/// Hairdresser things: mannequin heads that each show one kind of hair, a customer in the salon
/// chair (blow-dried or trimmed), a poster of hairstyles, a lock of hair with its ends under a
/// magnifying glass, and a trolley with a bowl of dye.
enum G3Salon {
    typealias Look = PalaceFigures.Look

    // MARK: Mannequin head

    /// A head on a stand (44 × 66), seen from the front. `accessory` "straight" (long straight
    /// hair), "curly" (a big head of curls), "fringe" (a long fringe hanging over the eyes),
    /// "parting" (a clear parting, a comb drawing it). `tone` hair colour, `variant` skin.
    static func head(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 44, height: 66))
        let skin = Look.at(p.variant ?? 3).skin
        f.oval(6, 61, 32, 5, 0x1E1E1C, 0.16)
        f.rect(8, 58, 28, 5, 0x2E2117, radius: 2)
        f.rect(19.5, 46, 5, 13, 0x5E6B73)
        let style = p.accessory ?? "straight"
        let fallback: UInt32 = switch style {
        case "curly": 0xA3410A
        case "fringe": 0xC9A15B
        case "parting": 0x1E1E1C
        default: 0x4A3524
        }
        bust(f, cx: 22, cy: 24, skin: skin, hair: PropColor.named(p.tone, fallback), style: style)
    }

    /// A frontal head and neck centred at (`cx`, `cy`) with the hair `style`.
    static func bust(_ f: PropPen, cx: CGFloat, cy: CGFloat, skin: UInt32, hair: UInt32, style: String) {
        let shine = PalaceInk.shade(hair, 1.6)
        switch style {
        case "straight":
            f.svg("M\(cx - 13) \(cy - 2)C\(cx - 13) \(cy - 14) \(cx - 7) \(cy - 17) \(cx) \(cy - 17)C\(cx + 7) \(cy - 17) \(cx + 13) \(cy - 14) \(cx + 13) \(cy - 2)V\(cy + 26)H\(cx - 13)Z", hair)
        case "curly":
            for k in 0..<14 {
                let a = Double(k) / 14 * 2 * .pi - .pi / 2
                f.dot(cx + 15 * cos(a), cy - 2 + 14 * sin(a) * (sin(a) > 0.4 ? 0.7 : 1), 6, hair)
            }
        case "parting", "short":
            f.svg("M\(cx - 13) \(cy)C\(cx - 13) \(cy - 14) \(cx - 7) \(cy - 17) \(cx) \(cy - 17)C\(cx + 7) \(cy - 17) \(cx + 13) \(cy - 14) \(cx + 13) \(cy)V\(cy + (style == "short" ? 0 : 14))H\(cx - 13)Z", hair)
        default:
            f.svg("M\(cx - 13) \(cy)C\(cx - 13) \(cy - 14) \(cx - 7) \(cy - 17) \(cx) \(cy - 17)C\(cx + 7) \(cy - 17) \(cx + 13) \(cy - 14) \(cx + 13) \(cy)V\(cy + 10)H\(cx - 13)Z", hair)
        }
        f.rect(cx - 4, cy + 10, 8, 14, PalaceInk.shade(skin, 0.9))
        f.oval(cx - 10.5, cy - 12.5, 21, 25, skin)
        f.dot(cx - 4.2, cy + 1, 1.3, 0x2E2117)
        f.dot(cx + 4.2, cy + 1, 1.3, 0x2E2117)
        f.svgLine("M\(cx - 3) \(cy + 6.5)Q\(cx) \(cy + 8.5) \(cx + 3) \(cy + 6.5)", 0x8C5A3C, 1.1)
        switch style {
        case "straight":
            f.svg("M\(cx - 11) \(cy - 3)C\(cx - 11) \(cy - 12) \(cx - 6) \(cy - 15) \(cx) \(cy - 15)C\(cx + 6) \(cy - 15) \(cx + 11) \(cy - 12) \(cx + 11) \(cy - 3)C\(cx + 8) \(cy - 9) \(cx + 4) \(cy - 10) \(cx) \(cy - 10)C\(cx - 4) \(cy - 10) \(cx - 8) \(cy - 9) \(cx - 11) \(cy - 3)Z", hair)
            f.svgLine("M\(cx - 11) \(cy + 2)V\(cy + 24)M\(cx + 11) \(cy + 2)V\(cy + 24)", shine, 1.4)
            f.svgLine("M\(cx - 4) \(cy - 14)Q\(cx + 2) \(cy - 15) \(cx + 7) \(cy - 12)", shine, 1.4)
        case "curly":
            for k in 0..<7 {
                let a = Double(k) / 6 * .pi + .pi
                f.dot(cx + 10 * cos(a), cy - 8 + 7 * sin(a), 4.6, hair)
            }
            for (dx, dy) in [(-15.0, 0.0), (14.0, 4.0), (-8.0, -16.0), (9.0, -15.0)] as [(CGFloat, CGFloat)] {
                f.spiral(cx + dx, cy + dy, radius: 3, turns: 1.6, shine, 0.9)
            }
        case "fringe":
            f.svg("M\(cx - 12) \(cy + 4)C\(cx - 13) \(cy - 12) \(cx - 7) \(cy - 16) \(cx) \(cy - 16)C\(cx + 7) \(cy - 16) \(cx + 13) \(cy - 12) \(cx + 12) \(cy + 4)L\(cx + 9) \(cy + 1)L\(cx + 6) \(cy + 5)L\(cx + 3) \(cy + 1.5)L\(cx) \(cy + 5.5)L\(cx - 3) \(cy + 1.5)L\(cx - 6) \(cy + 5)L\(cx - 9) \(cy + 1)Z", hair)
            f.svgLine("M\(cx - 6) \(cy - 10)V\(cy + 1)M\(cx) \(cy - 11)V\(cy + 2)M\(cx + 6) \(cy - 10)V\(cy + 1)", shine, 1)
        case "parting":
            f.svg("M\(cx - 11) \(cy + 1)C\(cx - 12) \(cy - 11) \(cx - 8) \(cy - 15) \(cx - 4) \(cy - 15.5)C\(cx - 5) \(cy - 10) \(cx - 8) \(cy - 6) \(cx - 11) \(cy + 1)Z", hair)
            f.svg("M\(cx - 1.5) \(cy - 15.8)C\(cx + 6) \(cy - 16) \(cx + 12) \(cy - 12) \(cx + 11) \(cy + 1)C\(cx + 8) \(cy - 7) \(cx + 2) \(cy - 10) \(cx - 1.5) \(cy - 15.8)Z", hair)
            f.svgLine("M\(cx - 2.4) \(cy - 19)L\(cx - 3.8) \(cy - 10.5)", 0xFFF3E6, 3)
            // A tail comb drawing the parting
            f.svgLine("M\(cx - 3) \(cy - 18)L\(cx + 14) \(cy - 30)", 0x2F5BD3, 2.2)
            f.svgLine("M\(cx + 2) \(cy - 21)L\(cx + 0.6) \(cy - 23.2)M\(cx + 5) \(cy - 23)L\(cx + 3.6) \(cy - 25.2)M\(cx + 8) \(cy - 25)L\(cx + 6.6) \(cy - 27.2)", 0x2F5BD3, 1)
        case "short":
            f.svg("M\(cx - 11) \(cy - 4)C\(cx - 12) \(cy - 13) \(cx - 6) \(cy - 16) \(cx + 1) \(cy - 16)C\(cx + 8) \(cy - 16) \(cx + 12) \(cy - 12) \(cx + 11) \(cy - 4)C\(cx + 8) \(cy - 10) \(cx - 2) \(cy - 12) \(cx - 11) \(cy - 4)Z", hair)
        default:
            break
        }
    }

    // MARK: Salon chair

    /// A customer in a cape on a salon chair (96 × 140), facing right. `accessory` "dry": a hand
    /// from behind aims a hair dryer, warm air blows the hair back. "trim": a hand with scissors
    /// snips at the back of the head, a comb in the other, bits of hair falling. `variant` look.
    static func chair(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 140)).mirrored(p.flip == true)
        let v = Look.at(p.variant ?? 3)
        let dry = p.accessory == "dry"
        let seat: UInt32 = 0x2E2117
        f.oval(18, 132, 66, 7, 0x1E1E1C, 0.16)
        f.oval(28, 128, 46, 8, 0x9A9890)
        f.rect(48, 100, 6, 30, 0x9A9890)
        f.rect(26, 92, 52, 12, seat, radius: 5)
        f.rect(22, 48, 14, 52, seat, radius: 6)
        f.svgLine("M68 104V114M76 96L82 102", 0x9A9890, 2)
        // The customer under a cape
        f.svgLine("M64 98V120", v.trousers, 6)
        f.svg("M58 118H69Q72 118 72 122H58Z", 0x2E2117)
        let cape = PalaceSVG.path("M38 52C42 46 52 44 58 50L72 104H28Z")
        f.fill(cape, 0x5E6B73)
        f.svgLine("M46 60L40 102M56 60L58 102", 0x4A5560, 1)
        f.rect(46, 44, 10, 8, v.skin)
        f.dot(52, 32, 13, v.skin)
        f.dot(58, 32, 1.5, 0x2E2117)
        f.svgLine("M56 39Q58.5 41 61 39", 0x8C5A3C, 1.2)
        if dry {
            // Long hair blown back
            f.svg("M39 32C38 20 44 16 52 16C60 16 66 20 65 28C61 23 56 22 50 23C46 30 44 44 38 52C36 44 37 36 39 32Z", v.hair)
            f.svgLine("M38 34C30 34 26 40 20 38M40 42C32 44 28 50 22 50M40 26C32 24 28 28 22 24", v.hair, 2.4)
            // Dryer and hand from behind, waves of warm air
            f.svgLine("M0 6C6 10 10 14 14 18", 0xEFEBE2, 7)
            f.dot(15.5, 19.5, 3.6, 0xC99A74)
            f.svg("M13 10H30Q34 10 34 14V18Q34 22 30 22H13Z", 0xC8261B)
            f.rect(14, 20, 6, 12, 0xC8261B, radius: 2)
            f.rect(30, 11, 4, 10, 0x2E2117, radius: 1)
            f.svgLine("M36 12Q40 9 44 12T52 12M36 16Q40 13 44 16T52 16M36 20Q40 17 44 20T52 20", 0xF2711C, 1.2)
        } else {
            // Short hair, scissors at the nape, bits falling on the cape
            f.svg("M39 30C38 20 44 17 52 17C60 17 66 20 65 28C61 24 56 23 51 23C46 23 42 26 40 34Z", v.hair)
            f.svg("M39 30C38 36 40 42 44 44C42 38 41 34 40 30Z", v.hair)
            f.svgLine("M0 36C8 38 14 42 18 46", 0xEFEBE2, 7)
            f.dot(20, 47, 3.8, 0xC99A74)
            f.ring(22, 42, 3.4, 0x3E4C55, 1.8)
            f.ring(26, 49, 3.4, 0x3E4C55, 1.8)
            f.svgLine("M25 41L41 30M28.5 47L42 35", 0x9A9890, 2.6)
            f.svgLine("M38 24L41 20M44 22L46 17M34 28L31 25", 0xC8261B, 1.2)
            for (x, y) in [(42.0, 56.0), (36.0, 64.0), (46.0, 70.0), (38.0, 80.0), (44.0, 88.0)] as [(CGFloat, CGFloat)] {
                f.svgLine("M\(x) \(y)l2.4 1.2", v.hair, 1.4)
            }
        }
    }

    // MARK: Style poster

    /// A poster (100 × 84) of three hairstyles side by side; style `highlight` gets a star.
    static func stylePoster(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 84))
        f.rect(2, 3, 98, 81, 0x1E1E1C, radius: 2, 0.14)
        f.rect(0, 0, 98, 80, 0x2E2117, radius: 2)
        f.rect(4, 4, 90, 72, 0xF4E4D8)
        let styles: [(String, UInt32, Int)] = [("short", 0x4A3524, 1), ("fringe", 0x1E1E1C, 3), ("curly", 0xC9A15B, 5)]
        for (i, s) in styles.enumerated() {
            let cx = 19 + CGFloat(i) * 30
            f.rect(cx - 13, 10, 26, 54, i == p.highlight ? 0xFFFDF6 : 0xEAD3C4, radius: 2)
            bust(f, cx: cx, cy: 32, skin: Look.at(s.2).skin, hair: s.1, style: s.0)
            f.svg("M\(cx - 13) 64Q\(cx) 50 \(cx + 13) 64Z", Look.at(s.2).coat)
            if i == p.highlight {
                f.stroke(Path(roundedRect: CGRect(x: cx - 13, y: 10, width: 26, height: 54), cornerRadius: 2), 0xC8261B, 1.4)
                PalaceCarePeople.star(f, cx + 11, 12, 6)
            }
        }
    }

    // MARK: Lock of hair

    /// A card (84 × 72): a long lock of hair, its ends split into wisps, a magnifying glass over the
    /// ends. `tone` hair colour.
    static func hairLock(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 72))
        let hair = PropColor.named(p.tone, 0x7A5230)
        f.rect(2, 3, 82, 69, 0x1E1E1C, radius: 3, 0.14)
        f.rect(0, 0, 82, 68, 0xFFFDF6, radius: 3)
        f.rect(6, 4, 12, 8, 0xC8261B, radius: 2)
        f.svg("M8 10C20 12 26 22 30 34C33 44 38 50 46 52L46 58C34 58 26 50 22 38C18 26 14 18 6 16Z", hair)
        f.svgLine("M10 13C20 16 24 26 27 36C30 46 36 52 44 55", PalaceInk.shade(hair, 1.4), 1)
        // Split ends, big under the glass
        let c = CGPoint(x: 58, y: 50)
        f.dot(c.x, c.y, 15, 0xEFF4F6)
        var g = f
        g.ctx.clip(to: Path(ellipseIn: CGRect(x: c.x - 15, y: c.y - 15, width: 30, height: 30)))
        g.svgLine("M42 48H56M56 48L68 40M56 48L68 46M42 54H58M58 54L70 56M58 54L69 62", hair, 2.4)
        f.ring(c.x, c.y, 15, 0x3E4C55, 3)
        f.svgLine("M69 61L79 71", 0x3E4C55, 5)
    }

    // MARK: Dye trolley

    /// A small trolley (72 × 104): on top a bowl of red dye with a tinting brush in it and a fan of
    /// hair-colour swatches; a bottle and a towel below.
    static func dyeBowl(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 72, height: 104))
        f.oval(6, 98, 60, 5, 0x1E1E1C, 0.15)
        f.svgLine("M10 54V96M62 54V96", 0x9A9890, 2.4)
        f.rect(4, 52, 64, 5, 0x3E4C55, radius: 1.5)
        f.rect(4, 84, 64, 5, 0x3E4C55, radius: 1.5)
        f.dot(10, 99, 2.6, 0x2E2117)
        f.dot(62, 99, 2.6, 0x2E2117)
        f.rect(12, 66, 10, 18, 0xFFFDF6, radius: 2)
        f.rect(14, 62, 6, 5, 0xC8261B, radius: 1)
        f.rect(34, 74, 26, 10, 0xED93B1, radius: 2)
        // Swatch fan
        let colours: [UInt32] = [0xF4D58D, 0xC9A15B, 0xA3410A, 0x4A3524, 0x3C3489, 0xC8261B]
        for (i, colour) in colours.enumerated() {
            let a = Angle.degrees(-62 + Double(i) * 14)
            var s = f
            s.ctx.translateBy(x: 54, y: 50)
            s.ctx.rotate(by: a)
            s.rect(-3, -40, 6, 38, colour, radius: 2)
        }
        f.dot(54, 50, 2.2, 0x5E6B73)
        // Bowl of dye with the brush
        f.svg("M6 36H40Q38 52 23 52Q8 52 6 36Z", 0x1E1E1C)
        f.svg("M8 36Q23 28 38 36Z", 0xC8261B)
        f.svgLine("M20 34L4 10", 0x1E1E1C, 3)
        f.svgLine("M20 34L24 39", 0xC8261B, 4)
        f.svgLine("M11 31Q14 28 17 31", 0xE06A5A, 1)
    }
}
