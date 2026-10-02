import SwiftUI

/// People for the g1 places, all on the same 64 × 114 build as `PalaceFigures.person` and facing
/// right (`flip` faces left). `accessory` says who they are:
/// "clerk" (behind a counter, seen from the front, cut at the counter top; `tone` coat, `mount`
/// "cap" a peaked cap), "courier" (cap and a stack of parcels), "worker" (hard hat, hi-vis vest,
/// a crate; "temp": the same with two companies and a back-and-forth arrow over the head), "eager" (both fists up, sparks, `text` in a bubble), "caller" (a phone to the ear,
/// `text` in a bubble), "tenant" (at their own front door with the key: `text` house number,
/// `caption` a slip on the door); police and court people are
/// drawn in their own files ("witness", "victim", "suspect", "officer", "judge", "lawyer", "guilty").
enum G1People {
    typealias Look = PalaceFigures.Look

    static func person(_ pen: PropPen, _ p: PalacePropParams) {
        switch p.accessory ?? "none" {
        case "clerk": return clerk(pen, p)
        case "tenant": return tenant(pen, p)
        case "temp": return temp(pen, p)
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
        case "caller": caller(f, v, p.text)
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
        // Both arms forward round a stack of two parcels
        f.svgLine("M15 44C15 56 20 64 26 68", PalaceInk.shade(jacket, 0.8), 6)
        G1Props.parcel(f, CGRect(x: 24, y: 64, width: 30, height: 20))
        G1Props.parcel(f, CGRect(x: 27, y: 50, width: 24, height: 12), 0xD9AE7A)
        f.rect(28, 70, 12, 8, 0xFFFDF6, radius: 0.8)
        f.svgLine("M30 42C38 48 50 56 56 66", jacket, 6)
        f.dot(25, 76, 3.4, v.skin)
        f.dot(56, 70, 3.4, v.skin)
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

    /// Someone on the phone (96 × 114), the phone at the ear, telling something (`text` in a bubble).
    static func caller(_ f: PropPen, _ v: Look, _ text: String?) {
        body(f, v, coat: v.coat)
        head(f, v, mood: "open")
        f.svgLine("M31 42C40 44 40 32 32 26", v.coat, 6)
        f.rect(26, 10, 7, 17, 0x1E1E1C, radius: 2)
        f.dot(31.5, 26, 3.4, v.skin)
        f.svgLine("M36 8Q40 12 36 16M40 5Q46 12 40 19", 0xF2711C, 1.4)
        if let text {
            G1Props.bubble(f, CGRect(x: 38, y: 22, width: 58, height: 22), text, tail: CGPoint(x: 32, y: 34), font: PropFont.heavy(9.5))
        }
    }

    /// A tenant at their own front door (84 × 128): the door with its number (`text`) and a slip
    /// (`caption`), and the person in front of it holding up the key.
    static func tenant(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 128))
        let v = Look.at(p.variant ?? 6)
        f.rect(34, 6, 50, 118, 0xEFEBE2)
        f.rect(38, 10, 42, 114, 0x2F4B3A)
        f.rect(44, 16, 30, 22, 0xBCCDD6, radius: 1)
        f.svg("M48 36L58 18H62L52 36Z", 0xFFFFFF, 0.3)
        f.rect(49, 44, 20, 11, 0xFFFDF6, radius: 1.5)
        f.text(p.text ?? "12B", PropFont.heavy(8), 0x1E1E1C, at: CGPoint(x: 59, y: 49.5), maxWidth: 18)
        if let caption = p.caption {
            f.rect(46, 60, 28, 16, 0xFAC775, radius: 1)
            f.dot(60, 61.5, 1.4, 0xC8261B)
            f.text(caption, PropFont.heavy(7.5), 0x412402, at: CGPoint(x: 60, y: 69), maxWidth: 25)
        }
        f.rect(50, 92, 20, 4, 0xC9A15B, radius: 1)
        f.dot(74, 74, 2, 0xC9A15B)
        f.rect(30, 122, 54, 6, 0xB4B2A9)
        let me = f.within(CGRect(x: -4, y: 14, width: 64, height: 114))
        body(me, v, coat: v.coat)
        head(me, v)
        me.svgLine("M31 42C38 42 42 36 44 28", v.coat, 6)
        me.dot(44.5, 26, 3.4, v.skin)
        me.ring(46, 17, 4, 0xC9A15B, 2)
        me.rect(45, 20, 2.4, 12, 0xC9A15B)
        me.rect(47, 27, 3, 2, 0xC9A15B)
        me.svg("M50 14L56 9L62 14V22H50Z", 0xC8261B)
    }

    /// A temp worker (74 × 142): the hi-vis worker, and over the head two companies with an arrow
    /// going back and forth between them (here this week, there the next).
    static func temp(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 74, height: 142))
        PalaceIcon.company.draw(f, in: CGRect(x: 0, y: 2, width: 20, height: 20), color: 0x5E6B73, detail: 0xFFFDF6)
        PalaceIcon.company.draw(f, in: CGRect(x: 52, y: 2, width: 20, height: 20), color: 0x2F5BD3, detail: 0xFFFDF6)
        f.svgLine("M22 8Q36 0 50 8", 0xF2711C, 2)
        f.svg("M47 4L53 10L45 11Z", 0xF2711C)
        f.svgLine("M50 18Q36 26 22 18", 0xF2711C, 2)
        f.svg("M25 22L19 16L27 15Z", 0xF2711C)
        worker(f.within(CGRect(x: 6, y: 28, width: 64, height: 114)), Look.at(p.variant ?? 1))
    }
}
