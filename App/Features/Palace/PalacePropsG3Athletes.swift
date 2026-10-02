import SwiftUI

/// People in sportswear whose body tells the word (64 × 114 standing, facing right; "stiff" is
/// 92 × 114). `variant` look, `flip` faces left.
enum G3Athletes {
    typealias Look = PalaceFigures.Look

    /// `accessory`: "sore" (hands on aching muscles, red pain marks, a grimace), "injured" (on
    /// crutches, a bandaged knee lifted), "stiff" (bent over, the hands stop far above the toes),
    /// "scale" (on the bathroom scale holding out trousers far too wide; `text` on the readout).
    static func athlete(_ pen: PropPen, _ p: PalacePropParams) {
        let stiff = p.accessory == "stiff"
        let f = pen.fitted(CGSize(width: stiff ? 92 : 64, height: 114)).mirrored(p.flip == true)
        let v = Look.at(p.variant ?? 0)
        switch p.accessory {
        case "sore": sore(f, v)
        case "injured": injured(f, v)
        case "stiff": bentOver(f, v)
        case "scale": scale(f, v, p.text)
        default:
            G3Body.shadow(f)
            legs(f, v)
            shortsAndTop(f, v)
            G3Body.head(f, skin: v.skin, hair: v.hair)
        }
    }

    private static func legs(_ f: PropPen, _ v: Look) {
        f.svgLine("M17 80V102M27 80V102", v.skin, 5)
        shoes(f, "M11 101H21V107H11Z M23 101H33V107H23Z")
    }

    private static func shoes(_ f: PropPen, _ d: String) {
        f.svg(d, 0xFFFDF6)
        f.stroke(PalaceSVG.path(d), 0x2F5BD3, 1)
    }

    private static func shortsAndTop(_ f: PropPen, _ v: Look) {
        f.svg("M10 64H34L35 82H24.5L22 74L19.5 82H9Z", v.trousers)
        f.svg("M11 66L12 44C12.5 37 16 33 22 33C28 33 31.5 37 32 44L33 66Z", v.coat)
        f.svg("M17 33L22 38L27 33Z", v.skin)
    }

    /// A red throb on a muscle.
    private static func throb(_ f: PropPen, _ x: CGFloat, _ y: CGFloat) {
        f.dot(x, y, 5, 0xE06A5A, 0.45)
        f.svgLine("M\(x + 5) \(y - 6)L\(x + 8) \(y - 9)L\(x + 9) \(y - 4)L\(x + 12) \(y - 7)", 0xC8261B, 1.4)
    }

    private static func sore(_ f: PropPen, _ v: Look) {
        G3Body.shadow(f)
        f.svgLine("M17 80L15 102M27 80L29 102", v.skin, 5)
        shoes(f, "M9 101H19V107H9Z M25 101H35V107H25Z")
        f.svgLine("M13 42C10 52 12 62 16 72", v.skin, 4.6)
        f.dot(16.5, 74, 3, v.skin)
        shortsAndTop(f, v)
        throb(f, 26, 88)
        throb(f, 14, 90)
        G3Body.head(f, skin: v.skin, hair: v.hair, eye: false)
        f.svgLine("M26 18.5L30 20M26 21L30 20", 0x2E2117, 1.1)
        f.rect(24, 24, 7, 3.2, 0xFFFDF6, radius: 1)
        f.stroke(Path(roundedRect: CGRect(x: 24, y: 24, width: 7, height: 3.2), cornerRadius: 1), 0x8C5A3C, 0.8)
        f.svgLine("M26.3 24V27.2M28.6 24V27.2", 0x8C5A3C, 0.6)
        // The front hand grips the aching shoulder of the back arm
        f.svgLine("M31 42C36 48 30 50 20 43", v.skin, 4.6)
        f.dot(18.5, 42.5, 3, v.skin)
        throb(f, 12, 42)
        G3Body.sweat(f, 37, 10, 5)
    }

    private static func injured(_ f: PropPen, _ v: Look) {
        G3Body.shadow(f, width: 56)
        // Crutches
        f.svgLine("M9 46L3 108M35 46L42 108", 0x9A9890, 2.4)
        f.svgLine("M5 70H10M37 70H42", 0x5E6B73, 2.6)
        f.rect(5, 43, 9, 4, 0x5E6B73, radius: 2)
        f.rect(31, 43, 9, 4, 0x5E6B73, radius: 2)
        // Standing leg, and the hurt leg lifted with a bandaged knee
        f.svgLine("M18 80V102", v.skin, 5)
        shoes(f, "M12 101H22V107H12Z")
        f.svgLine("M26 80L30 90L23 98", v.skin, 5)
        f.svg("M19 96H25V101H18Z", 0xFFFDF6)
        f.rect(25.5, 84, 9, 10, 0xFFFDF6, radius: 2.5)
        f.stroke(Path(roundedRect: CGRect(x: 25.5, y: 84, width: 9, height: 10), cornerRadius: 2.5), 0xB4B2A9, 1)
        f.svgLine("M26 87.5H34M26 91H34", 0xB4B2A9, 0.8)
        shortsAndTop(f, v)
        f.svgLine("M13 42C9 52 8 62 8 69", v.skin, 4.6)
        f.dot(7.5, 70, 3, v.skin)
        f.svgLine("M31 42C35 52 37 62 39 69", v.skin, 4.6)
        f.dot(39.5, 70, 3, v.skin)
        G3Body.head(f, skin: v.skin, hair: v.hair)
        f.svgLine("M25.5 26Q27.5 24.4 29.5 26", 0x8C5A3C, 1.1)
    }

    private static func bentOver(_ f: PropPen, _ v: Look) {
        f.oval(6, 106, 66, 6, 0x1E1E1C, 0.16)
        // Straight, locked legs with stiff marks beside them
        f.svgLine("M20 62V102M28 62V102", v.skin, 5)
        shoes(f, "M14 101H24V107H14Z M23 101H35V107H23Z")
        f.svgLine("M10 70V96M7 74V92", 0x9A9890, 1.6)
        f.svg("M12 50H34L36 70H26L24 63L22 70H11Z", v.trousers)
        // Torso folded forward from the hips, arms hanging, far from the toes
        f.svg("M20 54Q22 46 32 44L58 50Q64 53 61 59L56 62L26 62Z", v.coat)
        f.svgLine("M54 56C55 64 56 72 56 78", v.skin, 4.6)
        f.dot(56.5, 80, 3, v.skin)
        f.dot(68, 60, 10, v.skin)
        f.svg("M60 54C64 48 72 48 76 53C77 57 76 61 74 64C72 58 67 55 60 54Z", v.hair)
        f.dot(70, 66, 1.2, 0x2E2117)
        f.svgLine("M66 69L70 70", 0x8C5A3C, 1.1)
        G3Body.sweat(f, 80, 66, 5)
        // The gap to the toes
        f.svgLine("M58 86V100", 0xC8261B, 1.6)
        f.svg("M58 84L55.5 88.5H60.5Z M58 102L55.5 97.5H60.5Z", 0xC8261B)
        f.svgLine("M50 104H66", 0xC8261B, 1)
    }

    private static func scale(_ f: PropPen, _ v: Look, _ text: String?) {
        G3Body.shadow(f, width: 44)
        f.rect(3, 103, 42, 7, 0xEFEBE2, radius: 2)
        f.stroke(Path(roundedRect: CGRect(x: 3, y: 103, width: 42, height: 7), cornerRadius: 2), 0xB4B2A9, 1)
        f.svgLine("M18 80V101M27 80V101", v.skin, 4.6)
        f.svg("M13 99H22V104H13Z M24 99H33V104H24Z", 0xFFFDF6)
        // Thin body in trousers far too wide, held out at the waist
        f.svg("M15 64L16 45C16.5 38 19 34 22.5 34C26 34 28.5 38 29 45L30 64Z", v.coat)
        f.svg("M17 34L22.5 38L28 34Z", v.skin)
        f.svg("M1 58H44L41 92H28L23 72L18 92H5Z", v.trousers)
        f.svg("M5 59Q22.5 68 40 59Z", PalaceInk.shade(v.trousers, 0.6))
        f.svgLine("M1 58H44", PalaceInk.shade(v.trousers, 0.8), 2)
        f.svgLine("M17 43C12 47 5 50 2 56", v.skin, 4.4)
        f.dot(1.5, 57.5, 3, v.skin)
        f.svgLine("M28 43C33 47 40 50 43 56", v.skin, 4.4)
        f.dot(43.5, 57.5, 3, v.skin)
        f.dot(22.5, 21, 10, v.skin)
        f.svg("M12.5 20C12 12 17 9 22.5 9C28 9 33 12 32.5 20C30.5 15.5 27 14.5 22.5 14.5C18 14.5 14.5 15.5 12.5 20Z", v.hair)
        f.dot(28, 21.5, 1.2, 0x2E2117)
        f.svgLine("M25 26.5Q27.5 29 30 26.5", 0x8C5A3C, 1.2)
        // The readout
        f.svgLine("M38 104L50 84", 0xB4B2A9, 1)
        f.rect(36, 66, 28, 18, 0x232B3B, radius: 3)
        if let text {
            f.text(text, PropFont.heavy(8), 0x5DCAA5, at: CGPoint(x: 50, y: 75.4), maxWidth: 25)
        }
        f.svgLine("M58 46V60", 0x1E7A4C, 2.4)
        f.svg("M58 64L53 57H63Z", 0x1E7A4C)
    }
}
