import SwiftUI

/// g6 people: one standing figure (same build as `PalaceFigures.person`) whose clothes, hands and
/// face show what they do: a mechanic, an inspector, a journalist, someone carrying a box of old
/// things, an amazed visitor, someone explaining with a speech bubble.
enum G6People {
    typealias Look = PalaceFigures.Look

    static func figure(_ pen: PropPen, _ p: PalacePropParams) {
        let item = p.accessory ?? "wow"
        let v = Look.at(p.variant ?? 0)
        switch item {
        case "talk":
            // Wider: room for the bubble above the pointing hand.
            let full = pen.fitted(CGSize(width: 92, height: 140)).mirrored(p.flip == true)
            talk(full, v, lines: p.lines ?? [])
        case "box":
            carrying(pen.fitted(CGSize(width: 72, height: 114)).mirrored(p.flip == true), v)
        default:
            let f = pen.fitted(CGSize(width: 64, height: 114)).mirrored(p.flip == true)
            switch item {
            case "wrench": mechanic(f, v)
            case "inspect": inspector(f, v)
            case "press": journalist(f, v, ask: p.text)
            default: amazed(f, v)
            }
        }
    }

    // MARK: Body

    /// Shadow, legs, shoes, body, collar, back arm (unless `backArm` is false) and head with hair.
    static func body(_ f: PropPen, coat: UInt32, trousers: UInt32, v: Look, backArm: Bool = true, walking: Bool = false) {
        let dark = PalaceInk.shade(coat, 0.78)
        f.oval(6, 106, 56, 6, 0x1E1E1C, 0.16)
        f.svgLine(walking ? "M17 84L12 104M27 84L32 104" : "M17 84V104M27 84V104", trousers, 5)
        f.svg(walking ? "M7 103H16V108H7Z M28 103H37V108H28Z" : "M12 103H21V108H12Z M23 103H32V108H23Z", 0x2E2117)
        f.svg("M9 88L10.5 44C11.5 36 15.5 32 22 32C28.5 32 32.5 36 33.5 44L35 88Z", coat)
        f.svgLine("M22 40V86", dark, 1.2)
        if backArm {
            f.svgLine("M13 42C10 52 10 62 12 70", dark, 6)
            f.dot(12.5, 72, 3.1, v.skin)
        }
        head(f, v)
    }

    static func head(_ f: PropPen, _ v: Look) {
        f.dot(22, 19, 11, v.skin)
        f.svg("M11 18C10 10 15 6 22 6C29 6 34 10 33 18C31 13 27 11.5 22 11.5C17 11.5 13 13 11 18Z", v.hair)
        f.dot(28, 19.5, 1.3, 0x2E2117)
    }

    // MARK: Poses

    /// Blue overalls, a cap, an oil smudge, a rag in the pocket and a big spanner held up.
    private static func mechanic(_ f: PropPen, _ v: Look) {
        let suit: UInt32 = 0x2F5BD3
        body(f, coat: suit, trousers: suit, v: v)
        f.svg("M15 44H29V58H15Z", PalaceInk.shade(suit, 0.85))
        f.svgLine("M16 34L17 46M28 34L27 46", PalaceInk.shade(suit, 0.7), 2)
        f.svg("M8 74L13 70L15 82L9 84Z", 0xC8261B)
        f.svg("M10.5 14C11 7 16 4.5 22 4.5C28 4.5 33 7 33.5 13.5L40 15L10.5 16Z", 0x1F3A6B)
        f.oval(15, 21, 6, 3, 0x3E4C55, 0.45)
        f.svgLine("M31 42C38 42 42 36 43 28", suit, 6)
        f.dot(43.5, 26.5, 3.4, v.skin)
        f.svgLine("M43.5 33L45 6", 0x8E9AA0, 3.6)
        f.svg("M40 6C40 0 50 0 50 6L48 8L46 3H44L42 8Z", 0x8E9AA0)
        f.dot(45, 33, 2.4, 0x8E9AA0)
    }

    /// A grey coat, a clipboard with ticks against the chest and a magnifier held to the eye.
    private static func inspector(_ f: PropPen, _ v: Look) {
        body(f, coat: 0x5E6B73, trousers: 0x2E2117, v: v, backArm: false)
        f.svg("M17 32L22 39L27 32Z", 0xEFEBE2)
        f.svgLine("M13 42C12 52 14 58 19 60", 0x4A555C, 6)
        f.rect(14, 48, 18, 24, 0x8C5E38, radius: 1.5)
        f.rect(16, 52, 14, 18, 0xFFFDF6)
        f.rect(19, 46.5, 8, 3.5, 0xB4B2A9, radius: 1)
        for y in [56.0, 61, 66] as [CGFloat] {
            f.svgLine("M17.5 \(y)L19 \(y + 1.5)L21.5 \(y - 1.5)", 0x1E7A4C, 1.2)
            f.line(23, y, 28.5, y, 0xB4B2A9, 1)
        }
        f.dot(19.5, 61, 3, v.skin)
        f.svgLine("M31 42C38 44 42 36 41 30", 0x5E6B73, 6)
        f.dot(40.5, 28, 3.2, v.skin)
        f.svgLine("M40 27L37 22", 0x2E2117, 2.6)
        f.dot(34, 18, 7, 0xBFD9E6, 0.7)
        f.ring(34, 18, 7, 0x2E2117, 2)
        f.svg("M30 15Q33 12.5 36 13.5", 0xFFFFFF, 0.8)
    }

    /// A journalist: notepad up, pen writing, a press card on a lanyard, a question bubble.
    private static func journalist(_ f: PropPen, _ v: Look, ask: String?) {
        body(f, coat: v.coat, trousers: v.trousers, v: v, backArm: false)
        f.svg("M17 32L22 39L27 32Z", 0xEFEBE2)
        f.svgLine("M17.5 33L20.5 50M26.5 33L23.5 50", 0xC8261B, 1.4)
        f.rect(15.5, 49, 13, 10, 0xFFFDF6, radius: 1.2)
        f.rect(15.5, 49, 13, 3.5, 0xC8261B, radius: 1.2)
        f.text("PERS", PropFont.heavy(4.2), 0x1E1E1C, at: CGPoint(x: 22, y: 55.8), maxWidth: 11)
        let dark = PalaceInk.shade(v.coat, 0.78)
        f.svgLine("M13 42C12 50 18 52 31 46", dark, 6)
        f.svg("M30 30L44 27L46 45L32 48Z", 0xFFFDF6)
        f.svg("M30 30L44 27L44.5 30L30.5 33Z", 0x8C5E38)
        f.svgLine("M33 37L42 35M33.5 40.5L42.5 38.5M34 44L40 42.8", 0x2F5BD3, 1)
        f.dot(31.5, 46, 3.1, v.skin)
        f.svgLine("M31 42C37 50 44 50 49 45", v.coat, 6)
        f.dot(49.5, 44, 3.1, v.skin)
        f.svgLine("M49 44L43 37", 0x1E1E1C, 1.8)
        if let ask {
            G6Props.bubble(f, CGRect(x: 38, y: 0, width: 24, height: 18), tail: CGPoint(x: 34, y: 16), lines: [ask], size: 13, ink: 0xC8261B)
        }
    }

    /// Hands to the cheeks, round eyes, an open mouth and sparkles: impressed.
    private static func amazed(_ f: PropPen, _ v: Look) {
        body(f, coat: v.coat, trousers: v.trousers, v: v, backArm: false)
        f.svg("M17 32L22 39L27 32Z", 0xEFEBE2)
        let dark = PalaceInk.shade(v.coat, 0.78)
        f.svgLine("M13 42C9 36 11 28 14 25", dark, 6)
        f.dot(14.5, 24, 3.2, v.skin)
        f.svgLine("M31 42C36 36 34 28 31 25", v.coat, 6)
        f.dot(30.5, 24, 3.2, v.skin)
        f.dot(28, 18, 2, 0xFFFFFF)
        f.dot(28.4, 18.2, 1.1, 0x2E2117)
        f.oval(25.5, 22.5, 4, 5, 0x7A2A20)
        f.svgLine("M25.5 13.5Q28 12 30.5 13.5", 0x2E2117, 1)
        G6Props.sparkle(f, 44, 8, 5)
        G6Props.sparkle(f, 52, 22, 3.5, 0xF2711C)
        G6Props.sparkle(f, 40, 32, 3)
    }

    /// Walking with a box of old things held out in front: a lamp, a teddy, a book.
    static func carrying(_ f: PropPen, _ v: Look) {
        body(f, coat: v.coat, trousers: v.trousers, v: v, backArm: false, walking: true)
        f.svg("M17 32L22 39L27 32Z", 0xEFEBE2)
        let dark = PalaceInk.shade(v.coat, 0.78)
        f.svgLine("M13 42C14 52 22 58 30 58", dark, 6)
        // what sticks out of the box
        f.svg("M36 30L44 30L47 40H33Z", 0xF2D7A0)
        f.svgLine("M40 40V50", 0x7A5230, 1.6)
        f.dot(56, 42, 6, 0xB97A3E)
        f.dot(52, 37, 2.4, 0xB97A3E)
        f.dot(60, 37, 2.4, 0xB97A3E)
        f.dot(54, 41.5, 0.9, 0x2E2117)
        f.dot(58, 41.5, 0.9, 0x2E2117)
        f.rect(44, 40, 6, 14, 0x2F5BD3, radius: 0.8)
        f.svg("M28 48H68L65 74H31Z", 0xC9A15B)
        f.svg("M28 48H68L66 53H30Z", 0x8C5E38)
        f.svgLine("M38 60H58", 0x8C5E38, 1.2)
        f.dot(30, 58, 3.2, v.skin)
        f.svgLine("M31 42C38 50 48 56 60 58", v.coat, 6)
        f.dot(61, 58, 3.2, v.skin)
    }

    /// Pointing ahead and explaining: a speech bubble with up to three short lines.
    private static func talk(_ full: PropPen, _ v: Look, lines: [String]) {
        let f = full.within(CGRect(x: 0, y: 26, width: 64, height: 114))
        body(f, coat: v.coat, trousers: v.trousers, v: v)
        f.svg("M17 32L22 39L27 32Z", 0xEFEBE2)
        f.svgLine("M27 25Q29.5 27 31.5 24.5", 0x7A2A20, 1.2)
        f.svgLine("M31 42C40 40 48 36 56 32", v.coat, 6)
        f.dot(57, 31.5, 3.2, v.skin)
        f.line(58, 31, 63, 29, v.skin, 2)
        let n = CGFloat(max(1, min(3, lines.count)))
        G6Props.bubble(full, CGRect(x: 28, y: 0, width: 64, height: 8 + 12 * n), tail: CGPoint(x: 36, y: 8 + 12 * n + 12), lines: lines)
    }
}
