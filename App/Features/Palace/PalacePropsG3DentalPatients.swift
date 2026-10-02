import SwiftUI

/// Patients at the dentist, drawn with a big head so the mouth reads at phone size (facing right).
enum G3DentalPatients {
    typealias Look = PalaceFigures.Look

    /// `accessory` "numb": standing (72 × 120), a swollen cheek ringed with dots, a crooked mouth
    /// that dribbles, a hand feeling the cheek. "cold": seated (84 × 104) with an ice cream at the
    /// mouth, one eye squeezed shut, a red zigzag of pain. "braces": seated, a big grin with a wire
    /// and brackets over the teeth and a sparkle. `variant` look.
    static func patient(_ pen: PropPen, _ p: PalacePropParams) {
        let v = Look.at(p.variant ?? 0)
        switch p.accessory {
        case "numb": numb(pen.fitted(CGSize(width: 72, height: 120)), v)
        case "cold": seated(pen.fitted(CGSize(width: 84, height: 104)), v, cold: true)
        default: seated(pen.fitted(CGSize(width: 84, height: 104)), v, cold: false)
        }
    }

    private static func head(_ f: PropPen, _ v: Look, cx: CGFloat, cy: CGFloat, long: Bool = false) {
        if long {
            f.svg("M\(cx - 14) \(cy)C\(cx - 14) \(cy - 12) \(cx - 8) \(cy - 15) \(cx) \(cy - 15)C\(cx + 8) \(cy - 15) \(cx + 14) \(cy - 12) \(cx + 13) \(cy - 2)L\(cx - 6) \(cy + 4)L\(cx - 8) \(cy + 18)H\(cx - 15)Z", v.hair)
        }
        f.dot(cx, cy, 13, v.skin)
        f.svg("M\(cx - 13) \(cy - 1)C\(cx - 14) \(cy - 10) \(cx - 8) \(cy - 15) \(cx) \(cy - 15)C\(cx + 8) \(cy - 15) \(cx + 14) \(cy - 10) \(cx + 13) \(cy - 1)C\(cx + 10) \(cy - 7) \(cx + 6) \(cy - 8.5) \(cx) \(cy - 8.5)C\(cx - 6) \(cy - 8.5) \(cx - 10) \(cy - 7) \(cx - 13) \(cy - 1)Z", v.hair)
    }

    private static func numb(_ f: PropPen, _ v: Look) {
        f.oval(6, 113, 54, 6, 0x1E1E1C, 0.16)
        f.svgLine("M18 90V110M28 90V110", v.trousers, 5)
        f.svg("M13 109H22V114H13Z M24 109H33V114H24Z", 0x2E2117)
        f.svgLine("M14 48C11 58 11 68 13 76", PalaceInk.shade(v.coat, 0.78), 6)
        f.dot(13.5, 78, 3.1, v.skin)
        f.svg("M10 94L11.5 50C12.5 42 16.5 38 23 38C29.5 38 33.5 42 34.5 50L36 94Z", v.coat)
        f.svg("M18 38L23 45L28 38Z", 0xEFEBE2)
        head(f, v, cx: 23, cy: 22)
        f.dot(29.5, 20, 1.4, 0x2E2117)
        // The swollen, numb cheek ringed with dots, a crooked mouth that dribbles
        f.oval(25, 21, 15, 13, PalaceInk.shade(v.skin, 0.95))
        f.dot(32, 26, 3.5, 0xE06A5A, 0.4)
        for k in 0..<12 {
            let a = Double(k) / 12 * 2 * .pi
            f.dot(32 + 11 * cos(a), 27 + 10 * sin(a), 1.1, 0x2F5BD3)
        }
        f.svgLine("M24 32Q28 31 31 34", 0x8C5A3C, 1.3)
        f.svg("M24.5 33Q26.5 37 24.5 39Q22.5 37 24.5 33Z", 0x8FB6CF)
        // A hand feeling the cheek
        f.svgLine("M32 48C40 48 44 40 44 32", v.coat, 6)
        f.dot(44, 29.5, 3.4, v.skin)
        f.svgLine("M42.5 27L41 24.5", v.skin, 2)
    }

    private static func seated(_ f: PropPen, _ v: Look, cold: Bool) {
        f.oval(4, 98, 56, 5, 0x1E1E1C, 0.14)
        f.svgLine("M8 80V100M41 80V100", 0x2E2117, 2.4)
        f.svgLine("M8 92H41", 0x2E2117, 1.6)
        f.svg("M5 48H10V80H5Z", 0x1F3A6B)
        f.svg("M5 74H44V80H5Z", 0x2B4C86)
        f.svg("M11 76L12 52C13 45 17 42 23 42C29 42 33 45 34 52L35 76Z", v.coat)
        f.svg("M18 42L23 48L28 42Z", 0xEFEBE2)
        f.svg("M15 68H47Q51 68 51 72V77H15Z", v.trousers)
        f.svgLine("M41 76V97", PalaceInk.shade(v.trousers, 0.8), 5.5)
        f.svgLine("M47 74V97", v.trousers, 6)
        f.svg("M38 96H47Q50 96 50 99V101H38Z M44 96H53Q56 96 56 99V101H44Z", 0x2E2117)
        head(f, v, cx: 24, cy: 26, long: !cold)
        let arm = PalaceInk.shade(v.coat, 0.86)
        if cold {
            // Wincing at an ice cream, a red zigzag of pain
            f.svgLine("M28 23L32 24.5M28 26L32 24.5", 0x2E2117, 1.2)
            f.svgLine("M27 32L29 31L31 32.4L33 31L35 32", 0x8C5A3C, 1.2)
            f.svgLine("M40 12L45 8L44 14L50 11", 0xC8261B, 1.8)
            f.svgLine("M38 18L43 17", 0xC8261B, 1.4)
            f.svgLine("M29 50C35 52 40 50 42 44", arm, 6)
            f.dot(42.5, 42, 3.2, v.skin)
            f.svg("M38 40H48L43 54Z", 0xD9A440)
            f.svgLine("M40 43L45 48M46 43L41.5 48", 0xA87B2E, 0.8)
            f.dot(43, 37, 5.4, 0xED93B1)
            f.dot(41, 32.5, 4.2, 0xFFFDF6)
            f.ring(41, 32.5, 4.2, 0xD3D1C7, 0.6)
        } else {
            // A big grin with braces, a sparkle
            f.dot(30, 22, 1.4, 0x2E2117)
            f.svg("M24 28H37Q37 35 30.5 35Q24 35 24 28Z", 0x5A1F1B)
            f.rect(24.5, 28, 12, 4.4, 0xFFFDF6, radius: 1)
            f.svgLine("M24.5 30.2H36.5", 0x5E6B73, 0.9)
            for x in [26.0, 29, 32, 35] as [CGFloat] { f.rect(x - 0.9, 29.3, 1.8, 1.8, 0x3E4C55, radius: 0.3) }
            PalaceCarePeople.star(f, 43, 24, 4.5)
            f.svgLine("M29 50C33 58 38 62 44 64", arm, 6)
            f.dot(45, 64.5, 3.2, v.skin)
            f.svgLine("M45 62V57", v.skin, 2.4)
        }
    }
}
