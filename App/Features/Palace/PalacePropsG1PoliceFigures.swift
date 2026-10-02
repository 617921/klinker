import SwiftUI

/// People at the police desk (`g1Person` accessories): "officer" (navy uniform, peaked cap with a
/// gold star; `mount` "bike" rides a bicycle and waves), "witness" (points, a bubble with an eye
/// and `text`), "victim" (bandaged head, an arm in a sling, a sad face) and "suspect" (hat pulled
/// down, dark glasses, collar up, glancing sideways).
enum G1PoliceFigures {
    typealias Look = PalaceFigures.Look

    static let navy: UInt32 = 0x1F3A6B

    static func draw(_ pen: PropPen, _ p: PalacePropParams) {
        let v = Look.at(p.variant ?? 0)
        switch p.accessory {
        case "officer":
            if p.mount == "bike" { return bikeOfficer(pen, v) }
            let f = pen.fitted(CGSize(width: 64, height: 114)).mirrored(p.flip == true)
            officer(f, v)
        case "witness":
            witness(pen.fitted(CGSize(width: 100, height: 114)), v, p.text ?? "Ik zag het!")
        case "victim":
            victim(pen.fitted(CGSize(width: 64, height: 114)).mirrored(p.flip == true), v)
        default:
            suspect(pen.fitted(CGSize(width: 64, height: 114)).mirrored(p.flip == true), v)
        }
    }

    // MARK: Officer

    /// Cap with a gold star, navy jacket with a star badge; the arms are left to the caller.
    static func uniformTop(_ f: PropPen, _ v: Look) {
        f.svg("M9 88L10.5 44C11.5 36 15.5 32 22 32C28.5 32 32.5 36 33.5 44L35 88Z", navy)
        f.svg("M17 32L22 39L27 32Z", 0xA9CBE0)
        f.svgLine("M22 40V86", PalaceInk.shade(navy, 0.75), 1.2)
        f.svg(PalacePeople.star(cx: 27.5, cy: 50, r: 4), 0xE0A93A)
        G1People.head(f, v, mood: "smile", hair: false)
        f.svg("M10 12C10 5 15 2 22 2C29 2 34 5 34 12Z", navy)
        f.svg("M9 11H38Q39 14 35 14H9Z", 0x1E1E1C)
        f.svg(PalacePeople.star(cx: 22, cy: 7.5, r: 3), 0xE0A93A)
    }

    static func officer(_ f: PropPen, _ v: Look) {
        f.oval(6, 106, 52, 6, 0x1E1E1C, 0.16)
        f.svgLine("M17 84V104M27 84V104", 0x1E1E1C, 5)
        f.svg("M12 103H21V108H12Z M23 103H32V108H23Z", 0x1E1E1C)
        uniformTop(f, v)
        f.svgLine("M13 42C10 52 10 62 12 70", PalaceInk.shade(navy, 0.78), 6)
        f.dot(12.5, 72, 3.1, v.skin)
        f.svgLine("M31 42C34 52 34 62 32 70", navy, 6)
        f.dot(32, 72, 3.1, v.skin)
    }

    /// The officer on a bicycle (104 × 132), one hand on the handlebar, the other waving.
    static func bikeOfficer(_ pen: PropPen, _ v: Look) {
        let f = pen.fitted(CGSize(width: 104, height: 132))
        f.oval(6, 125, 94, 6, 0x1E1E1C, 0.16)
        for cx in [22.0, 82.0] as [CGFloat] {
            f.ring(cx, 110, 15, 0x1E1E1C, 3.4)
            f.ring(cx, 110, 2, 0x8C9499, 1.6)
        }
        f.svgLine("M22 110L40 82H72L82 110M40 82L50 110L72 82M50 110H58M38 76H46M72 82L70 66H78", 0x2F4B3A, 3)
        f.rect(28, 92, 14, 6, 0x1F3A6B, radius: 1)
        // Rider: legs to the pedal, body, the near arm to the handlebar, the far arm waving
        let me = f.within(CGRect(x: 22, y: 6, width: 64, height: 114))
        me.svgLine("M18 72L26 92L30 102M26 72L36 88L38 98", 0x1E1E1C, 5)
        me.svgLine("M11 30C4 22 2 12 6 4", PalaceInk.shade(navy, 0.78), 5.5)
        me.dot(6.5, 2, 3.4, v.skin)
        me.svgLine("M2 0L-2 -4M8 -2L10 -7", 0xF2711C, 1.4)
        me.svg("M10 76L11 44C12 36 16 32 22 32C28 32 32 36 33 44L34 76Z", navy)
        me.svg("M17 32L22 39L27 32Z", 0xA9CBE0)
        me.svg(PalacePeople.star(cx: 27, cy: 50, r: 4), 0xE0A93A)
        me.svgLine("M31 42C38 50 44 56 48 60", navy, 6)
        me.dot(48.5, 61, 3.2, v.skin)
        G1People.head(me, v, mood: "smile", hair: false)
        me.svg("M10 12C10 5 15 2 22 2C29 2 34 5 34 12Z", navy)
        me.svg("M9 11H38Q39 14 35 14H9Z", 0x1E1E1C)
        me.svg(PalacePeople.star(cx: 22, cy: 7.5, r: 3), 0xE0A93A)
    }

    // MARK: Witness

    /// Someone pointing to the right (100 × 114) with a bubble: a big eye and `text`.
    static func witness(_ f: PropPen, _ v: Look, _ text: String) {
        G1People.body(f, v, coat: v.coat)
        G1People.head(f, v, mood: "open")
        f.svgLine("M31 42C38 42 46 38 52 36", v.coat, 6)
        f.dot(53, 35.5, 3.2, v.skin)
        f.svgLine("M55 35L62 33", v.skin, 2.4)
        let b = CGRect(x: 36, y: 0, width: 64, height: 26)
        f.rect(b.offsetBy(dx: 1, dy: 1.5), 0x1E1E1C, radius: 9, 0.12)
        f.svg("M44 24L34 30L50 24Z", 0xFFFDF6)
        f.rect(b, 0xFFFDF6, radius: 9)
        f.stroke(Path(roundedRect: b, cornerRadius: 9), 0xB4B2A9, 0.8)
        f.svg("M40 13Q47 5 54 13Q47 21 40 13Z", 0xFFFDF6)
        f.svgLine("M40 13Q47 5 54 13Q47 21 40 13Z", 0x1E1E1C, 1.2)
        f.dot(47, 13, 3, 0x2F5BD3)
        f.dot(47, 13, 1.2, 0x1E1E1C)
        f.text(text, PropFont.heavy(8.5), 0x1E1E1C, at: CGPoint(x: 77, y: 13.5), maxWidth: 40)
    }

    // MARK: Victim

    /// A hurt person: a bandage round the head with a red spot, a plaster, one arm in a sling.
    static func victim(_ f: PropPen, _ v: Look) {
        G1People.body(f, v, coat: v.coat)
        G1People.head(f, v, mood: "sad")
        f.svg("M11 12C11 9 33 9 33 12V17C33 14 11 14 11 17Z", 0xFFFDF6)
        f.rect(11, 11, 22, 5, 0xFFFDF6, radius: 2)
        f.dot(16, 13.5, 2, 0xC8261B, 0.8)
        f.rect(25, 21, 7, 3, 0xF2C59A, radius: 1)
        f.svg("M30 22L31 26L29 26Z", 0x5DCAA5)
        // The arm in a white sling
        f.svgLine("M31 42C34 50 32 58 26 60", v.coat, 6)
        f.svg("M14 36L34 58L18 64Z", 0xFFFDF6)
        f.svgLine("M14 36L34 58", 0xD3D1C7, 1)
        f.dot(24, 60, 3, v.skin)
    }

    // MARK: Suspect

    /// Hat pulled down, dark glasses, collar up, glancing over the shoulder, question marks.
    static func suspect(_ f: PropPen, _ v: Look) {
        G1People.body(f, v, coat: 0x5E5A4E)
        f.svg("M15 30L22 44L29 30L31 24H13Z", 0x4A463C)
        G1People.head(f, v, mood: "flat", hair: false)
        f.svg("M10 12C10 4 15 1 22 1C29 1 34 4 34 12Z", 0x2E2117)
        f.svg("M5 11H39Q40 15 36 15H8Q4 15 5 11Z", 0x1E1E1C)
        f.rect(23, 16, 11, 5, 0x1E1E1C, radius: 2)
        f.svgLine("M31 42C34 52 34 62 32 70", 0x5E5A4E, 6)
        f.dot(32, 72, 3.1, v.skin)
        f.text("?", PropFont.heavy(12), 0xC8261B, at: CGPoint(x: 44, y: 8))
        f.text("?", PropFont.heavy(9), 0xC8261B, at: CGPoint(x: 52, y: 18))
    }
}
