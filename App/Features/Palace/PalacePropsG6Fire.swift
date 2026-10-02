import SwiftUI

/// Fire props: a house top ablaze, flames bursting out through a window, a firefighter hosing a
/// fire down, and a ladder rescue. Firefighters wear navy with yellow bands and a yellow helmet.
enum G6Fire {
    static func fire(_ pen: PropPen, _ p: PalacePropParams) {
        switch p.accessory ?? "blaze" {
        case "burst": burst(pen.fitted(CGSize(width: 60, height: 66)))
        case "hose": hose(pen.fitted(CGSize(width: 144, height: 112)))
        default: blaze(pen.fitted(CGSize(width: 152, height: 122)))
        }
    }

    // MARK: Pieces

    /// A flame standing on (x, base): red outside, orange, then yellow at the heart.
    static func flame(_ f: PropPen, _ x: CGFloat, _ base: CGFloat, _ w: CGFloat, _ h: CGFloat, lean: CGFloat = 0) {
        for (k, colour) in [(1.0, UInt32(0xC8261B)), (0.72, 0xF2711C), (0.42, 0xFAC775)] as [(CGFloat, UInt32)] {
            let hw = w / 2 * k, hh = h * k
            let tip = CGPoint(x: x + lean * k, y: base - hh)
            f.svg("M\(x - hw) \(base)C\(x - hw * 1.2) \(base - hh * 0.5) \(tip.x - hw * 0.2) \(base - hh * 0.6) \(tip.x) \(tip.y)C\(tip.x + hw * 0.6) \(base - hh * 0.55) \(x + hw * 1.2) \(base - hh * 0.45) \(x + hw) \(base)Z", colour)
        }
    }

    /// A puff of smoke made of overlapping circles.
    static func smoke(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ r: CGFloat, _ hex: UInt32 = 0x5E6B73, _ opacity: Double = 0.85) {
        f.dot(x, y, r, hex, opacity)
        f.dot(x - r * 0.8, y + r * 0.4, r * 0.7, hex, opacity)
        f.dot(x + r * 0.9, y + r * 0.3, r * 0.75, hex, opacity)
    }

    /// A firefighter standing at (x, feet) facing right, `s` times the 64 × 114 figure, front arm
    /// reaching to `hand` (in the figure's own points).
    static func firefighter(_ f: PropPen, at x: CGFloat, feet: CGFloat, scale s: CGFloat, hand: CGPoint) {
        let g = f.within(CGRect(x: x, y: feet - 114 * s, width: 64 * s, height: 114 * s), unit: s)
        let suit: UInt32 = 0x1F2A44, band: UInt32 = 0xF2C230
        g.oval(6, 106, 52, 6, 0x1E1E1C, 0.16)
        g.svgLine("M17 84V104M27 84V104", suit, 6)
        g.rect(13, 92, 9, 3, band)
        g.rect(23, 92, 9, 3, band)
        g.svg("M12 103H22V108H12Z M23 103H33V108H23Z", 0x1E1E1C)
        g.svg("M9 88L10.5 44C11.5 36 15.5 32 22 32C28.5 32 32.5 36 33.5 44L35 88Z", suit)
        g.rect(10, 62, 25, 4, band)
        g.rect(10.5, 74, 24.5, 4, band)
        g.dot(22, 19, 10.5, 0xE8C4A0)
        g.dot(28, 20, 1.3, 0x2E2117)
        g.svg("M9.5 18C9.5 7 15 3 22 3C29 3 34.5 7 34.5 18Z", band)
        g.svg("M7 17H38L37 20H7Z", PalaceInk.shade(band, 0.8))
        g.svgLine("M22 4V17", PalaceInk.shade(band, 0.8), 1.4)
        g.svgLine("M31 42C36 46 \(hand.x - 6) \(hand.y) \(hand.x) \(hand.y)", suit, 6.5)
        g.rect(hand.x - 10, hand.y - 3, 6, 6, band, radius: 1)
        g.dot(hand.x, hand.y, 3.6, 0x1E1E1C)
    }

    // MARK: Blaze

    /// The top of the house ablaze (152 × 122): flames from the two upper windows and over the
    /// gable, thick smoke rolling up.
    private static func blaze(_ f: PropPen) {
        smoke(f, 50, 14, 14, 0x3E4C55)
        smoke(f, 92, 10, 16, 0x5E6B73)
        smoke(f, 126, 22, 12, 0x3E4C55)
        flame(f, 76, 40, 64, 46, lean: -4)
        flame(f, 54, 44, 30, 32, lean: -6)
        flame(f, 100, 46, 32, 36, lean: 6)
        for x in [32.0, 120] as [CGFloat] {
            f.rect(x - 16, 76, 32, 38, 0x2E2A26)
            flame(f, x, 104, 28, 50, lean: x < 76 ? -5 : 5)
        }
        f.svgLine("M18 72Q14 60 20 50M136 70Q142 58 134 48", 0x3E4C55, 3, 0.6)
    }

    // MARK: Burst

    /// A window (60 × 66) whose glass breaks as flames shoot out: jagged glass, a burst of
    /// orange, shards flying.
    private static func burst(_ f: PropPen) {
        f.rect(4, 8, 52, 50, 0x2E2A26)
        f.svg("M4 8H56V58H4Z M10 14L22 22L16 32L28 36L22 50L36 44L44 54L46 38L52 30L42 24L48 12L34 18L26 10Z", 0xBFD9E6, 0.8)
        var burst = ""
        for k in 0..<14 {
            let a = Double(k) * .pi / 7
            let r: Double = k % 2 == 0 ? 30 : 16
            burst += (k == 0 ? "M" : "L") + String(format: "%.1f %.1f", 30 + cos(a) * r, 33 + sin(a) * r * 0.9)
        }
        f.svg(burst + "Z", 0xF2711C, 0.9)
        flame(f, 30, 50, 34, 44, lean: 2)
        f.svg("M0 4L6 8L2 12Z M58 2L54 8L60 10Z M2 58L8 56L4 64Z M56 60L60 54L60 66Z", 0xBFD9E6)
        f.stroke(Path(CGRect(x: 4, y: 8, width: 52, height: 50)), 0xEFE4CF, 3)
    }

    // MARK: Hose

    /// A firefighter (left) hosing a fan of water onto a burning bin (right) (144 × 112): the
    /// flames are small now and steam rises.
    private static func hose(_ f: PropPen) {
        // the bin and its dying fire
        f.rect(104, 74, 30, 34, 0x3E4C55, radius: 2)
        f.rect(102, 70, 34, 6, 0x5E6B73, radius: 2)
        flame(f, 112, 70, 12, 14, lean: -2)
        flame(f, 126, 70, 10, 10, lean: 2)
        smoke(f, 120, 44, 9, 0xEFEBE2, 0.9)
        smoke(f, 132, 28, 7, 0xEFEBE2, 0.7)
        // water
        for (k, end) in [CGPoint(x: 104, y: 60), CGPoint(x: 116, y: 64), CGPoint(x: 130, y: 62)].enumerated() {
            f.svgLine("M54 52Q\(80 + CGFloat(k) * 6) \(28 + CGFloat(k) * 4) \(end.x) \(end.y)", 0x6FA3C7, 3 - CGFloat(k) * 0.6)
        }
        for (x, y) in [(102.0, 66.0), (110, 58), (122, 60), (134, 66), (138, 58)] as [(CGFloat, CGFloat)] {
            f.dot(x, y, 1.6, 0xA9CBE0)
        }
        // hose on the ground
        f.svgLine("M0 108C16 112 28 96 36 74L46 56", 0xB98B5E, 4)
        f.rect(44, 48, 12, 7, 0x8E9AA0, radius: 2)
        firefighter(f, at: 2, feet: 112, scale: 0.92, hand: CGPoint(x: 46, y: 54))
    }

    // MARK: Rescue

    /// A ladder up to a smoky first-floor window (118 × 146); halfway down a firefighter carries
    /// a child in their arms.
    static func rescue(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 118, height: 146))
        // smoke from the window (the house's own window stays behind)
        smoke(f, 92, 10, 8, 0x5E6B73, 0.75)
        f.svgLine("M82 62Q78 44 86 30", 0x5E6B73, 4, 0.5)
        // ladder from the pavement to the sill
        f.svgLine("M30 146L70 62M44 146L84 62", 0xB4B2A9, 3)
        var rungs = ""
        for k in 1..<9 {
            let t = CGFloat(k) / 9
            rungs += "M\(30 + 40 * t) \(146 - 84 * t)L\(44 + 40 * t) \(146 - 84 * t)"
        }
        f.svgLine(rungs, 0x8E9AA0, 2)
        // firefighter halfway, a child held against the chest
        firefighter(f, at: 20, feet: 136, scale: 0.84, hand: CGPoint(x: 40, y: 50))
        let child = f.within(CGRect(x: 44, y: 76, width: 26, height: 34), unit: 1.3)
        child.dot(10, 5, 5, 0xC99A74)
        child.svg("M5 4C5 0 15 0 15 4C13 2 7 2 5 4Z", 0x4A3524)
        child.dot(12.5, 5, 0.9, 0x2E2117)
        child.rect(4, 9, 12, 12, 0xF2C230, radius: 3)
        child.svgLine("M5 12L0 8M15 12L18 6", 0xF2C230, 3)
        child.svgLine("M7 21L6 26M13 21L14 26", 0x2F5BD3, 2.6)
    }
}
