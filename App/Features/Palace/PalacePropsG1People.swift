import SwiftUI

/// People for the g1 places, all on the same 64 × 114 build as `PalaceFigures.person` and facing
/// right (`flip` faces left). `accessory` says who they are:
/// "clerk" (behind a counter, seen from the front, cut at the counter top; `tone` coat, `mount`
/// "cap" a peaked cap), "courier" (cap and a stack of parcels), "worker" (hard hat, hi-vis vest,
/// a crate), "eager" (both fists up, sparks, `text` in a bubble); police and court people are
/// drawn in their own files ("witness", "victim", "suspect", "officer", "judge", "lawyer", "guilty").
enum G1People {
    typealias Look = PalaceFigures.Look

    static func person(_ pen: PropPen, _ p: PalacePropParams) {
        switch p.accessory ?? "none" {
        case "clerk": return clerk(pen, p)
        case "witness", "victim", "suspect", "officer": return G1PoliceFigures.draw(pen, p)
        case "judge", "lawyer", "guilty": return G1CourtFigures.draw(pen, p)
        default: break
        }
        let wide = p.text != nil
        let f = pen.fitted(CGSize(width: wide ? 96 : 64, height: 114)).mirrored(p.flip == true)
        let v = Look.at(p.variant ?? 0)
        switch p.accessory ?? "none" {
        case "courier": courier(f, v)
        case "worker": worker(f, v)
        case "eager": eager(f, v, p.text)
        default: body(f, v, coat: v.coat); head(f, v)
        }
    }

    // MARK: Building blocks

    /// Legs, shoes, coat and collar of a standing person; the back arm if `backArm`.
    static func body(_ f: PropPen, _ v: Look, coat: UInt32, backArm: Bool = true, collar: UInt32 = 0xEFEBE2) {
        f.oval(6, 106, 52, 6, 0x1E1E1C, 0.16)
        f.svgLine("M17 84V104M27 84V104", v.trousers, 5)
        f.svg("M12 103H21V108H12Z M23 103H32V108H23Z", 0x2E2117)
        f.svg("M9 88L10.5 44C11.5 36 15.5 32 22 32C28.5 32 32.5 36 33.5 44L35 88Z", coat)
        f.svg("M17 32L22 39L27 32Z", collar)
        if backArm {
            f.svgLine("M13 42C10 52 10 62 12 70", PalaceInk.shade(coat, 0.78), 6)
            f.dot(12.5, 72, 3.1, v.skin)
        }
    }

    /// Head with hair, an eye and a mouth: `mood` "smile", "sad", "open" (talking) or "flat".
    static func head(_ f: PropPen, _ v: Look, mood: String = "smile", hair: Bool = true, cx: CGFloat = 22, cy: CGFloat = 19) {
        f.dot(cx, cy, 11, v.skin)
        if hair {
            f.svg("M\(cx - 11) \(cy - 1)C\(cx - 12) \(cy - 9) \(cx - 7) \(cy - 13) \(cx) \(cy - 13)C\(cx + 7) \(cy - 13) \(cx + 12) \(cy - 9) \(cx + 11) \(cy - 1)C\(cx + 9) \(cy - 6) \(cx + 5) \(cy - 7.5) \(cx) \(cy - 7.5)C\(cx - 5) \(cy - 7.5) \(cx - 9) \(cy - 6) \(cx - 11) \(cy - 1)Z", v.hair)
        }
        f.dot(cx + 6, cy + 0.5, 1.3, 0x2E2117)
        switch mood {
        case "sad": f.svgLine("M\(cx + 4.5) \(cy + 7)Q\(cx + 7) \(cy + 5) \(cx + 9.5) \(cy + 6.5)", 0x8C5A3C, 1.2)
        case "open": f.oval(cx + 5, cy + 4.6, 4.6, 3.6, 0x7A2A2A)
        case "flat": f.svgLine("M\(cx + 5) \(cy + 6)H\(cx + 9)", 0x8C5A3C, 1.2)
        default: f.svgLine("M\(cx + 5) \(cy + 6)Q\(cx + 7.5) \(cy + 7) \(cx + 9) \(cy + 5.5)", 0x8C5A3C, 1.1)
        }
    }

    // MARK: Clerk

    /// A clerk behind the counter, seen from the front (64 × 84), hands resting on the counter top.
    static func clerk(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 64, height: 84))
        let v = Look.at(p.variant ?? 3)
        let coat = PropColor.named(p.tone, v.coat)
        f.svg("M6 84V60C6 47 17 41 32 41C47 41 58 47 58 60V84Z", coat)
        f.svg("M26 41L32 52L38 41Z", 0xFFFDF6)
        if p.mount == "cap" {
            f.dot(41, 58, 3.2, 0xE0A93A)
            f.svgLine("M18 50V84M46 50V84", PalaceInk.shade(coat, 0.8), 1.2)
        } else {
            f.svg("M30.5 45H33.5L35 60L32 64L29 60Z", 0xC8261B)
        }
        f.rect(29, 34, 6, 8, PalaceInk.shade(v.skin, 0.9))
        f.dot(32, 24, 12, v.skin)
        if p.mount == "cap" {
            f.svg("M19 20C19 11 24 8 32 8C40 8 45 11 45 20Z", coat)
            f.svg("M18 19H46Q47 23 42 23H22Q17 23 18 19Z", 0x1E1E1C)
            f.dot(32, 14, 2.6, 0xE0A93A)
        } else {
            f.svg("M20 24C18 13 24 10 32 10C40 10 46 13 44 24C42 17 38 16 32 16C26 16 22 17 20 24Z", v.hair)
        }
        f.dot(27.5, 25, 1.4, 0x2E2117)
        f.dot(36.5, 25, 1.4, 0x2E2117)
        f.svgLine("M28 30Q32 33 36 30", 0x8C5A3C, 1.2)
        // Forearms on the counter
        f.svgLine("M10 62C10 72 14 78 22 80", PalaceInk.shade(coat, 0.85), 7)
        f.svgLine("M54 62C54 72 50 78 42 80", PalaceInk.shade(coat, 0.85), 7)
        f.dot(24, 80, 3.6, v.skin)
        f.dot(40, 80, 3.6, v.skin)
    }

    // MARK: Standing people

    /// A delivery person: cap, jacket, a stack of three parcels carried in both arms, a scanner.
    static func courier(_ f: PropPen, _ v: Look) {
        let jacket: UInt32 = 0x3E4C55
        body(f, v, coat: jacket, backArm: false)
        f.svgLine("M10 60H34", 0xF2711C, 3)
        head(f, v)
        f.svg("M11 16C11 8 15 5 22 5C29 5 33 8 33 16Z", 0xF2711C)
        f.svg("M30 13H41Q42 16 38 16H30Z", 0xC8561B)
        // Parcels held in front
        G1Props.parcel(f, CGRect(x: 26, y: 70, width: 26, height: 18))
        G1Props.parcel(f, CGRect(x: 30, y: 54, width: 20, height: 14), 0xB98652)
        G1Props.parcel(f, CGRect(x: 28, y: 42, width: 16, height: 10), 0xD9AE7A)
        f.svgLine("M15 44C16 58 20 72 28 80", PalaceInk.shade(jacket, 0.8), 6)
        f.dot(29, 81, 3.2, v.skin)
        f.svgLine("M30 42C36 50 44 58 52 70", jacket, 6)
        f.dot(52.5, 72, 3.2, v.skin)
        f.rect(50, 60, 8, 14, 0x1E1E1C, radius: 2)
        f.rect(51.5, 62, 5, 5, 0x5DCAA5, radius: 1)
    }

    /// A temp worker: hard hat, orange hi-vis vest with silver stripes, a crate in the hands.
    static func worker(_ f: PropPen, _ v: Look) {
        body(f, v, coat: 0x3E4C55, backArm: false)
        f.svg("M11 46C12 38 16 34 22 34C28 34 32 38 33 46L34 82H10Z", 0xF2711C)
        f.svgLine("M10.5 64H33.5M10 74H34", 0xE8ECEE, 3)
        f.svgLine("M17 35L19 82M27 35L25 82", 0xE8ECEE, 2)
        head(f, v)
        f.svg("M9 17C9 7 14 3 22 3C30 3 35 7 35 17Z", 0xFAC775)
        f.svg("M6 16H38Q39 19 36 19H8Q5 19 6 16Z", 0xE0A93A)
        f.svgLine("M22 3V15", 0xE0A93A, 1.6)
        // A crate held out in front
        f.svgLine("M14 44C14 54 20 60 30 62", 0x3E4C55, 6)
        f.svgLine("M30 42C36 50 42 56 48 60", 0x3E4C55, 6)
        f.rect(28, 58, 30, 20, 0x2F5BD3, radius: 2)
        f.svgLine("M31 64H55M31 70H55", 0x21468B, 1.4)
        f.rect(36, 60, 14, 3, 0x21468B, radius: 1)
        f.dot(30, 62, 3.2, v.skin)
        f.dot(56, 61, 3.2, v.skin)
    }

    /// Someone who can't wait to start: both fists up, a big smile, sparks, a speech bubble.
    static func eager(_ f: PropPen, _ v: Look, _ text: String?) {
        body(f, v, coat: v.coat, backArm: false)
        f.svgLine("M13 42C8 36 8 28 10 22", PalaceInk.shade(v.coat, 0.78), 6)
        f.dot(10, 19.5, 3.6, v.skin)
        f.svgLine("M31 42C36 36 38 30 38 24", v.coat, 6)
        f.dot(38, 21, 3.6, v.skin)
        head(f, v, mood: "open")
        f.svgLine("M4 10L1 6M7 6L6 1M40 8L44 4M44 14L49 13", 0xF2711C, 1.8)
        f.svg(PalacePeople.star(cx: 48, cy: 30, r: 5), 0xFAC775)
        f.svg(PalacePeople.star(cx: 3, cy: 34, r: 3.6), 0xFAC775)
        if let text {
            G1Props.bubble(f, CGRect(x: 44, y: 40, width: 52, height: 22), text, tail: CGPoint(x: 36, y: 30), font: PropFont.heavy(9.5))
        }
    }
}
