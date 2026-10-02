import SwiftUI

/// Little children at day care, front-facing with big heads: a toddler walking with a teddy, a
/// shy child peeking round a door, a proud child on a potty with a star chart, a child asleep in
/// a cot. Plus a shelf of nappies, the changing table and a toy box.
enum G4Kids {
    typealias Look = PalaceFigures.Look

    // MARK: Child

    /// A small child (see `PalacePropKind.g4Child`).
    static func child(_ pen: PropPen, _ p: PalacePropParams) {
        let v = Look.at(p.variant ?? 0)
        switch p.accessory {
        case "shy": shy(pen.fitted(CGSize(width: 64, height: 104)), v)
        case "potty": potty(pen.fitted(CGSize(width: 84, height: 100)), v)
        case "sleep": sleep(pen.fitted(CGSize(width: 108, height: 92)), v)
        default: toddle(pen.fitted(CGSize(width: 64, height: 104)), v, badge: p.text)
        }
    }

    /// A front-facing toddler, 40 × 64, its feet at y 64 of the pen.
    static func toddler(_ f: PropPen, _ v: Look, romper: UInt32, eyes: String = "open", arms: String? = "M11 40L3 34M29 40L37 34") {
        f.svgLine("M15 50V61M25 50V61", v.skin, 6)
        f.oval(9.5, 59, 10, 5, 0xC8261B)
        f.oval(20.5, 59, 10, 5, 0xC8261B)
        if let arms {
            f.svgLine(arms, v.skin, 4.6)
        }
        f.svg("M8 54C7 41 12 32 20 32C28 32 33 41 32 54Z", romper)
        f.rect(14, 38, 12, 9, PalaceInk.shade(romper, 1.2), radius: 2)
        f.dot(20, 19, 12.5, v.skin)
        f.svg("M9 15C10 7 16 5 20 5C25 5 30 7 31 15C28 11 24 10 20 10C16 10 12 11 9 15Z", v.hair)
        f.svgLine("M20 5Q22 1 25 2", v.hair, 1.6)
        f.dot(14.5, 23, 2.2, 0xE06A5A, 0.4)
        f.dot(25.5, 23, 2.2, 0xE06A5A, 0.4)
        switch eyes {
        case "closed": f.svgLine("M13.5 19Q15.5 21 17.5 19M22.5 19Q24.5 21 26.5 19", 0x2E2117, 1.1)
        case "down": f.svgLine("M13.8 20.5H17M23 20.5H26.2", 0x2E2117, 1.3)
        default:
            f.dot(15.6, 19, 1.4, 0x2E2117)
            f.dot(24.4, 19, 1.4, 0x2E2117)
        }
    }

    private static func toddle(_ f: PropPen, _ v: Look, badge: String?) {
        f.oval(10, 98, 44, 6, 0x1E1E1C, 0.14)
        let t = f.within(CGRect(x: 6, y: 18, width: 52, height: 83.2), unit: 1.3)
        toddler(t, v, romper: 0x5DCAA5, arms: "M11 40L2 33M29 40L36 46")
        t.svgLine("M17.5 27Q20 29 22.5 27", 0x8C2A1E, 1)
        // The teddy in the low hand
        t.dot(39, 46, 4.5, 0xA3713F)
        t.dot(39, 53, 5.5, 0xA3713F)
        t.dot(35.6, 42.6, 1.8, 0xA3713F)
        t.dot(42.4, 42.6, 1.8, 0xA3713F)
        t.dot(39, 47, 1.4, 0x6B4A2E)
        // Wobble lines
        f.svgLine("M2 70Q0 76 2 82M60 64Q62 70 60 76", 0x5E6B73, 1.2)
        if let badge {
            f.dot(51, 13, 12, 0x1E1E1C, 0.14)
            f.dot(50, 12, 12, 0xFFFDF6)
            f.ring(50, 12, 10.5, 0xF2711C, 2.2)
            f.text(badge, PropFont.heavy(7.5), 0x1E1E1C, at: CGPoint(x: 50, y: 12.5), maxWidth: 18)
        }
    }

    private static func shy(_ f: PropPen, _ v: Look) {
        let t = f.within(CGRect(x: 16, y: 20, width: 52, height: 83.2), unit: 1.3)
        toddler(t, v, romper: 0xF2711C, eyes: "down", arms: "M11 40L3 46")
        t.svgLine("M29 40C33 34 30 28 23 27", v.skin, 4.6)
        t.dot(22.5, 26.8, 2.4, v.skin)
        t.dot(14.5, 23, 2.8, 0xE06A5A, 0.75)
        t.dot(25.5, 23, 2.8, 0xE06A5A, 0.75)
        t.svgLine("M9 10L6 7M11 7L10 3", 0xE06A5A, 1)
        // The door leaf they hide behind
        f.rect(0, 0, 30, 104, 0x5DCAA5)
        f.rect(4, 6, 22, 40, 0x4FB894)
        f.rect(4, 54, 22, 44, 0x4FB894)
        f.rect(28, 0, 3, 104, 0x3F9C7C)
        f.svgLine("M30 44H34", 0xC9A15B, 2.4)
        f.svgLine("M28 66C32 62 34 66 33 70", v.skin, 3.6)
    }

    private static func potty(_ f: PropPen, _ v: Look) {
        // The star chart on the wall
        f.rect(44, 4, 38, 46, 0xFFFDF6, radius: 2)
        f.stroke(Path(roundedRect: CGRect(x: 44, y: 4, width: 38, height: 46), cornerRadius: 2), 0xB4B2A9, 1)
        f.dot(63, 4, 2, 0xC8261B)
        for r in 0..<3 {
            for c in 0..<3 {
                let x = 51 + CGFloat(c) * 12, y = 14 + CGFloat(r) * 11
                if r < 2 || c < 2 { f.svg(PalacePeople.star(cx: x, cy: y, r: 4.6), 0xF2B33D) }
            }
        }
        f.svgLine("M70 36L73.5 40L79 32", 0x1E7A4C, 2.4)
        // The child on the potty, arms up
        f.oval(6, 94, 50, 5, 0x1E1E1C, 0.14)
        f.svg("M10 80H48L44 96H14Z", 0x2F5BD3)
        f.rect(8, 76, 42, 6, 0x5B85E0, radius: 3)
        let t = f.within(CGRect(x: 10, y: 20, width: 40, height: 64), unit: 1)
        t.svgLine("M13 54L8 62M27 54L32 62", v.skin, 6)
        toddler(t, v, romper: 0xC8261B, eyes: "closed", arms: "M11 40L3 26M29 40L37 26")
        t.svg("M15 25H25Q24.5 30 20 30Q15.5 30 15 25Z", 0x8C2A1E)
        t.dot(2.5, 24, 2.6, v.skin)
        t.dot(37.5, 24, 2.6, v.skin)
    }

    private static func sleep(_ f: PropPen, _ v: Look) {
        f.oval(4, 86, 100, 6, 0x1E1E1C, 0.14)
        f.svgLine("M8 22V90M100 22V90", 0xC9965F, 4)
        f.rect(8, 20, 92, 5, 0xC9965F, radius: 2)
        f.rect(10, 64, 88, 8, 0xFFFDF6, radius: 2)
        // The child under a blanket, head on the pillow
        f.rect(16, 52, 26, 12, 0xFFFDF6, radius: 5)
        f.dot(30, 50, 10, v.skin)
        f.svg("M20 47C21 40 26 38 30 38C35 38 39 40 40 47C37 43 34 42 30 42C26 42 23 43 20 47Z", v.hair)
        f.svgLine("M25 51Q27 53 29 51M31 51Q33 53 35 51", 0x2E2117, 1.1)
        f.dot(27, 55, 2, 0xE06A5A, 0.4)
        f.svg("M38 50Q60 42 96 52V68H38Z", 0x8FB6CF)
        f.svgLine("M44 56H92M44 62H92", 0xFFFDF6, 1, 0.7)
        var bars = ""
        for x in stride(from: 16.0, through: 92, by: 9) { bars += "M\(x) 25V64" }
        f.svgLine(bars, 0xC9965F, 2)
        f.svgLine("M8 72H100", 0xC9965F, 3)
        f.text("z", PropFont.heavy(10), 0x3C3489, at: CGPoint(x: 46, y: 34))
        f.text("z", PropFont.heavy(13), 0x3C3489, at: CGPoint(x: 56, y: 22))
        f.text("Z", PropFont.heavy(16), 0x3C3489, at: CGPoint(x: 70, y: 8))
    }

    // MARK: Nappies

    /// A shelf (96 × 50) with a stack of folded nappies, a pack with a baby on it, and one open
    /// nappy with its tabs.
    static func nappies(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 50))
        f.rect(0, 44, 96, 5, 0x9A6A42, radius: 1)
        f.svg("M10 49H14L12 52Z M82 49H86L84 52Z", 0x6B4A2E)
        for k in 0..<4 {
            let y = 34 - CGFloat(k) * 9
            f.rect(4, y, 26, 9, 0xFFFDF6, radius: 3)
            f.svgLine("M7 \(y + 4.5)H27", 0xA9CBE0, 1.2)
        }
        // The pack
        f.rect(34, 6, 26, 38, 0x8FB6CF, radius: 3)
        f.dot(47, 20, 7, 0xF1D3B8)
        f.svgLine("M44.5 19.5H45.5M48.5 19.5H49.5", 0x2E2117, 1.2)
        f.svgLine("M45 23Q47 24.5 49 23", 0x8C2A1E, 0.9)
        f.svgLine("M44 13Q47 11 50 13", 0xC9A15B, 1.4)
        f.rect(38, 32, 18, 6, 0xFFFDF6, radius: 2)
        // One nappy open, tabs out
        f.svg("M64 20H92L88 32Q86 42 78 42Q70 42 68 32Z", 0xFFFDF6)
        f.stroke(PalaceSVG.path("M64 20H92L88 32Q86 42 78 42Q70 42 68 32Z"), 0xB4B2A9, 1)
        f.rect(60, 19, 8, 5, 0x5DCAA5, radius: 1.5)
        f.rect(88, 19, 8, 5, 0x5DCAA5, radius: 1.5)
        f.svgLine("M70 26Q78 30 86 26", 0xA9CBE0, 1.2)
        f.dot(78, 34, 2, 0xF2B33D)
    }
}
