import SwiftUI

/// People of the offices and paperwork places, in the build and colours of `PalaceFigures.person`.
/// `variant` picks the look; `accessory` what they do:
/// "advisor" — a friendly advisor seen from the waist up behind a counter (58 × 88), lanyard in `tone`;
/// "objection" — someone frowning, holding up a letter with a struck-out amount (`text`) and a red
/// note (`caption`) (84 × 114).
enum G2People {
    typealias Look = PalaceFigures.Look

    static func person(_ pen: PropPen, _ p: PalacePropParams) {
        let v = Look.at(p.variant ?? 0)
        switch p.accessory {
        case "objection": objection(pen, p, v)
        default: advisor(pen, p, v)
        }
    }

    // MARK: Pieces

    /// A head centred at (cx, cy) facing right: skin, hair, an eye; `mood` "smile" | "frown" | "none".
    static func head(_ f: PropPen, _ v: Look, cx: CGFloat, cy: CGFloat, r: CGFloat = 11, mood: String = "smile") {
        f.dot(cx, cy, r, v.skin)
        let s = r / 11
        f.svg("M\(cx - 11 * s) \(cy - 1 * s)C\(cx - 12 * s) \(cy - 9 * s) \(cx - 7 * s) \(cy - 13 * s) \(cx) \(cy - 13 * s)C\(cx + 7 * s) \(cy - 13 * s) \(cx + 12 * s) \(cy - 9 * s) \(cx + 11 * s) \(cy - 1 * s)C\(cx + 9 * s) \(cy - 6 * s) \(cx + 5 * s) \(cy - 7.5 * s) \(cx) \(cy - 7.5 * s)C\(cx - 5 * s) \(cy - 7.5 * s) \(cx - 9 * s) \(cy - 6 * s) \(cx - 11 * s) \(cy - 1 * s)Z", v.hair)
        f.dot(cx + 6 * s, cy + 0.5 * s, 1.3 * s, 0x2E2117)
        switch mood {
        case "smile":
            f.svgLine("M\(cx + 4 * s) \(cy + 5.5 * s)Q\(cx + 7 * s) \(cy + 7.5 * s) \(cx + 9 * s) \(cy + 5 * s)", 0x8C5A3C, 1.1 * s)
        case "frown":
            f.svgLine("M\(cx + 3 * s) \(cy - 3.5 * s)L\(cx + 9 * s) \(cy - 1.5 * s)", 0x2E2117, 1.6 * s)
            f.svgLine("M\(cx + 4 * s) \(cy + 7 * s)Q\(cx + 6.5 * s) \(cy + 4.6 * s) \(cx + 9 * s) \(cy + 6.6 * s)", 0x8C5A3C, 1.2 * s)
        default:
            break
        }
    }

    /// A standing body (64 × 114 design, feet at 108) without the front arm.
    static func body(_ f: PropPen, _ v: Look) {
        let dark = PalaceInk.shade(v.coat, 0.78)
        f.oval(6, 106, 56, 6, 0x1E1E1C, 0.16)
        f.svgLine("M17 84V104M27 84V104", v.trousers, 5)
        f.svg("M12 103H21V108H12Z M23 103H32V108H23Z", 0x2E2117)
        f.svg("M9 88L10.5 44C11.5 36 15.5 32 22 32C28.5 32 32.5 36 33.5 44L35 88Z", v.coat)
        f.svgLine("M22 40V86", dark, 1.2)
        f.svg("M17 32L22 39L27 32Z", 0xEFEBE2)
        f.svgLine("M13 42C10 52 10 62 12 70", dark, 6)
        f.dot(12.5, 72, 3.1, v.skin)
    }

    // MARK: Advisor

    private static func advisor(_ pen: PropPen, _ p: PalacePropParams, _ v: Look) {
        let f = pen.fitted(CGSize(width: 58, height: 88))
        let tone = PropColor.named(p.tone, 0x1F3A6B)
        f.svg("M4 88V60C4 48 12 42 29 42C46 42 54 48 54 60V88Z", v.coat)
        f.svg("M22 42L29 52L36 42Z", 0xFFFDF6)
        f.svgLine("M23 43L27 66M35 43L31 66", tone, 1.8)
        f.rect(23, 64, 12, 14, 0xFFFDF6, radius: 1.5)
        f.rect(23, 64, 12, 4, tone, radius: 1.5)
        f.rect(25.5, 71, 7, 1.4, 0xB4B2A9)
        f.rect(25.5, 74, 5, 1.4, 0xB4B2A9)
        f.rect(24, 34, 10, 9, v.skin)
        head(f, v, cx: 29, cy: 24, r: 13)
        // A raised hand: hello.
        f.svgLine("M50 62C55 56 56 48 54 40", v.coat, 7)
        f.dot(54, 36, 4.4, v.skin)
        f.svgLine("M51 33V28M54 32V27M57 33V28.5", v.skin, 2)
    }

    // MARK: Objection

    private static func objection(_ pen: PropPen, _ p: PalacePropParams, _ v: Look) {
        let f = pen.fitted(CGSize(width: 84, height: 114))
        body(f, v)
        head(f, v, cx: 22, cy: 19, mood: "frown")
        var letterParams = p
        letterParams.accessory = "objection"
        G2Props.bill(f.within(CGRect(x: 34, y: 0, width: 50, height: 60)), letterParams)
        // The front arm holds the letter up by its corner.
        f.svgLine("M31 42C36 44 40 46 42 54", v.coat, 6)
        f.dot(42.5, 55, 3.4, v.skin)
    }
}
