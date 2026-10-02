import SwiftUI

/// Children and a teacher in the classroom. Figures face right; `flip` makes them face left.
enum PalacePupils {
    typealias Look = PalaceFigures.Look

    // MARK: Pupil

    /// A school child. `accessory`: "bag" (school bag and a round badge with `text`, 60 × 104),
    /// "cheer" (jumps with a paper with a big green tick held high, 56 × 116), "slump" (at a desk,
    /// head on the arms, a paper with a big red cross and a rain cloud, 88 × 88). `variant` look.
    static func pupil(_ pen: PropPen, _ p: PalacePropParams) {
        let v = Look.at(p.variant ?? 2)
        switch p.accessory {
        case "cheer": cheer(pen.fitted(CGSize(width: 56, height: 116)).mirrored(p.flip == true), v)
        case "slump": slump(pen.fitted(CGSize(width: 88, height: 88)).mirrored(p.flip == true), v)
        default:
            let base = pen.fitted(CGSize(width: 60, height: 104))
            bag(base.mirrored(p.flip == true), v)
            if let badge = p.text {
                let x: CGFloat = p.flip == true ? 15 : 45
                base.dot(x + 1, 21, 14, 0x1E1E1C, 0.14)
                base.dot(x, 20, 14, 0xFFFDF6)
                base.ring(x, 20, 12, 0xC8261B, 2.4)
                base.text(badge, PropFont.heavy(9), 0x1E1E1C, at: CGPoint(x: x, y: 20.5), maxWidth: 20)
            }
        }
    }

    /// The standing child's body with its feet at `feet` and head centre returned.
    private static func body(_ f: PropPen, _ v: Look, top: CGFloat, legs: String? = nil) -> CGPoint {
        let t = top
        f.svgLine(legs ?? "M21 \(t + 74)V\(t + 94)M30 \(t + 74)V\(t + 94)", v.trousers, 5)
        if legs == nil { f.svg("M16 \(t + 93)H25V\(t + 98)H16Z M26 \(t + 93)H35V\(t + 98)H26Z", 0x2E2117) }
        f.svg("M14 \(t + 77)L15 \(t + 50)C16 \(t + 44) 20 \(t + 41) 25.5 \(t + 41)C31 \(t + 41) 35 \(t + 44) 36 \(t + 50)L37 \(t + 77)Z", v.coat)
        f.svg("M21 \(t + 41)L25.5 \(t + 46)L30 \(t + 41)Z", 0xEFEBE2)
        let head = CGPoint(x: 25.5, y: t + 27)
        f.dot(head.x, head.y, 11.5, v.skin)
        f.svg("M14 \(t + 26)C13 \(t + 17) 18 \(t + 13) 25.5 \(t + 13)C33 \(t + 13) 38 \(t + 17) 37 \(t + 26)C35 \(t + 20) 31 \(t + 19) 25.5 \(t + 19)C20 \(t + 19) 16 \(t + 20) 14 \(t + 26)Z", v.hair)
        return head
    }

    private static func bag(_ f: PropPen, _ v: Look) {
        f.oval(8, 99, 40, 5, 0x1E1E1C, 0.16)
        f.rect(4, 46, 13, 28, v.bag, radius: 4)
        f.rect(4, 52, 13, 3, PalaceInk.shade(v.bag, 0.75))
        let head = body(f, v, top: 0)
        f.svgLine("M17 44L22 54", 0x2E2117, 2)
        f.svgLine("M31 50C34 58 34 66 32 72", PalaceInk.shade(v.coat, 0.85), 5.5)
        f.dot(32, 74, 3, v.skin)
        f.dot(head.x + 5.5, head.y + 0.5, 1.3, 0x2E2117)
        f.svgLine("M\(head.x + 3) \(head.y + 6)Q\(head.x + 5.5) \(head.y + 8) \(head.x + 8) \(head.y + 6)", 0x8C5A3C, 1.1)
    }

    private static func cheer(_ f: PropPen, _ v: Look) {
        f.svgLine("M14 112H22M30 112H38", 0xB4B2A9, 1.4)
        let head = body(f, v, top: 12, legs: "M21 86L16 100M30 86L36 99")
        f.svg("M11 98H19V103H11Z M33 97H41V102H33Z", 0x2E2117)
        f.svgLine("M18 58L11 34M33 58L40 34", v.coat, 5.5)
        f.dot(11, 32, 3, v.skin)
        f.dot(40, 32, 3, v.skin)
        f.rect(5, 6, 42, 28, 0x1E1E1C, radius: 1, 0.14)
        f.rect(4, 4, 42, 28, 0xFFFDF6, radius: 1)
        f.svgLine("M13 18L22 26L38 9", 0x1E7A4C, 4)
        f.svgLine("M\(head.x + 3.5) \(head.y - 1)Q\(head.x + 5.5) \(head.y - 3) \(head.x + 7.5) \(head.y - 1)", 0x2E2117, 1.2)
        f.svg("M\(head.x + 2) \(head.y + 4.5)H\(head.x + 9)Q\(head.x + 8.5) \(head.y + 9.5) \(head.x + 5.5) \(head.y + 9.5)Q\(head.x + 2.5) \(head.y + 9.5) \(head.x + 2) \(head.y + 4.5)Z", 0x8C2A1E)
        for (x, y, c) in [(2.0, 40.0, 0xF2711C), (50.0, 44.0, 0x2F5BD3), (6.0, 60.0, 0xFAC775), (49.0, 62.0, 0xC8261B)] as [(CGFloat, CGFloat, UInt32)] {
            f.rect(x, y, 4, 4, c, radius: 0.8)
        }
    }

    private static func slump(_ f: PropPen, _ v: Look) {
        f.oval(6, 82, 78, 5, 0x1E1E1C, 0.14)
        // Chair and desk
        f.rect(3, 40, 4, 26, 0xC8261B, radius: 1)
        f.rect(3, 62, 24, 4, 0xC8261B, radius: 1)
        f.svgLine("M6 66V85M24 66V85", 0x5E6B73, 2)
        f.svgLine("M34 58V86M82 58V86", 0x5E6B73, 2.4)
        // The child, folded over the desk
        f.svgLine("M22 64H30V84", v.trousers, 5.5)
        f.svg("M26 82H35V86H26Z", 0x2E2117)
        f.svg("M10 66L12 46C14 38 20 34 28 36L44 44L36 66Z", v.coat)
        f.rect(28, 52, 58, 6, 0xC9965F, radius: 1.5)
        f.rect(28, 58, 58, 2, 0x9A6A42)
        f.svg("M30 52C30 47 36 45 46 46L56 47C58 48 58 52 56 52Z", PalaceInk.shade(v.coat, 0.85))
        // Face down on the arms: we see the back of the head, an ear and the neck.
        f.svgLine("M28 36L33 40", v.skin, 5)
        f.dot(42, 41, 10.5, v.hair)
        f.svg("M33 35Q38 30 46 31", PalaceInk.shade(v.hair, 1.4), 1.2)
        f.dot(35, 44, 2.6, v.skin)
        // The paper with a red cross, tilted up
        f.svg("M54 50L60 24H86L82 50Z", 0x1E1E1C, 0.12)
        f.svg("M52 49L58 22H84L80 49Z", 0xFFFDF6)
        f.svgLine("M62 29L76 43M77 28L63 44", 0xC8261B, 3.6)
        // Rain cloud
        f.dot(30, 13, 6, 0x9A9890)
        f.dot(38, 9, 7.5, 0x9A9890)
        f.dot(46, 13, 6, 0x9A9890)
        f.rect(26, 13, 24, 6, 0x9A9890, radius: 3)
        f.svgLine("M30 23L28.5 27M38 23L36.5 27M46 23L44.5 27", 0x2F5BD3, 1.4)
    }

    // MARK: Teacher

    /// A strict teacher (66 × 124): frown, glasses, hair in a bun, one arm across the waist and a
    /// raised finger with warning lines. `variant` look.
    static func teacher(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 66, height: 124)).mirrored(p.flip == true)
        let v = Look.at(p.variant ?? 5)
        let dark = PalaceInk.shade(v.coat, 0.8)
        f.oval(8, 117, 50, 6, 0x1E1E1C, 0.16)
        f.svgLine("M23 98V116M33 98V116", 0x2E2117, 4.5)
        f.svg("M17 115H26V120H17Z M28 115H37V120H28Z", 0x1E1E1C)
        f.svg("M12 100L15 54C16 46 20 42 28 42C36 42 40 46 41 54L44 100Z", v.coat)
        f.svg("M23 42L28 50L33 42Z", 0xEFEBE2)
        // Arm across the waist
        f.svgLine("M17 54C13 64 16 72 38 70", dark, 6.5)
        f.dot(39, 69.5, 3.3, v.skin)
        // Raised arm, finger up, warning lines
        f.svgLine("M38 54L49 46L51 30", dark, 6.5)
        f.dot(51, 28, 3.6, v.skin)
        f.svgLine("M51.5 25V15", v.skin, 2.6)
        f.svgLine("M45 16L41.5 12.5M58 16L61.5 12.5M51.5 9V4.5", 0xC8261B, 1.6)
        // Head
        f.dot(28, 28, 11, v.skin)
        f.dot(19, 15, 5.5, 0x4A3524)
        f.svg("M17 26C16 18 21 15 28 15C35 15 40 18 39 26C37 21 33 20 28 20C23 20 19 21 17 26Z", 0x4A3524)
        f.ring(33.6, 28.5, 3, 0x2E2117, 1.1)
        f.svgLine("M30.6 28.2H28.5", 0x2E2117, 1.1)
        f.dot(34.2, 28.8, 1.1, 0x2E2117)
        f.svgLine("M30 22.5L37 24.8", 0x2E2117, 1.8)
        f.svgLine("M30.5 35.5Q33 33.6 35.5 35.5", 0x8C2A1E, 1.3)
    }
}
