import SwiftUI

/// Tents (going up, coming down, keeping out the rain) and a primitive outhouse with a hand pump.
enum G7CampTents {
    typealias Look = PalaceFigures.Look

    static let canvas: UInt32 = 0xF2711C
    static let shade: UInt32 = 0xC8561A

    /// `accessory` "up" | "down" | "rain".
    static func tent(_ pen: PropPen, _ p: PalacePropParams) {
        let v = Look.at(p.variant ?? 1)
        switch p.accessory {
        case "down": down(pen.fitted(CGSize(width: 126, height: 100)), v)
        case "rain": rain(pen.fitted(CGSize(width: 104, height: 140)))
        default: up(pen.fitted(CGSize(width: 116, height: 104)), v)
        }
    }

    /// A dome tent standing on the grass, door open, from `x` with its base at `y` (`w` wide).
    static func dome(_ f: PropPen, x: CGFloat, y: CGFloat, w: CGFloat, color: UInt32 = canvas) {
        let h = w * 0.55
        f.oval(x - 4, y - 4, w + 8, 8, 0x1E1E1C, 0.14)
        f.svg("M\(x) \(y)Q\(x + w * 0.04) \(y - h) \(x + w / 2) \(y - h)Q\(x + w * 0.96) \(y - h) \(x + w) \(y)Z", color)
        f.svg("M\(x + w * 0.3) \(y)Q\(x + w * 0.5) \(y - h * 0.8) \(x + w * 0.7) \(y)Z", 0x2E2117)
        f.svgLine("M\(x + w * 0.12) \(y - h * 0.6)Q\(x + w / 2) \(y - h * 1.12) \(x + w * 0.88) \(y - h * 0.6)", PalaceInk.shade(color, 0.8), 1.4)
        f.svgLine("M\(x) \(y)L\(x - 8) \(y + 2)M\(x + w) \(y)L\(x + w + 8) \(y + 2)", 0x7D8A92, 1)
    }

    /// Someone raising a tent: one side already up on a bent pole, a big arrow up.
    private static func up(_ f: PropPen, _ v: Look) {
        f.oval(20, 96, 92, 8, 0x1E1E1C, 0.14)
        f.svg("M24 98Q30 50 64 44Q78 44 84 52L110 98Z", canvas)
        f.svg("M84 52L110 98H96Q90 76 84 52Z", shade)
        f.svgLine("M24 98Q30 50 64 44Q78 44 84 52", 0x3E4C55, 2)
        f.svg("M48 98Q58 72 70 70Q78 82 80 98Z", 0x2E2117)
        // Person on the left pushing the pole up
        f.svgLine("M10 78V98M17 78V98", v.trousers, 4.5)
        f.svg("M6 80L8 50C9 45 12 42 15 42C18 42 21 45 22 50L24 80Z", v.coat)
        f.dot(15, 32, 8.5, v.skin)
        f.svg("M7 31C6 25 10 22 15 22C20 22 24 25 23 31C21 27 18 26 15 26C12 26 9 27 7 31Z", v.hair)
        f.svgLine("M21 50Q26 46 28 40", v.coat, 5)
        f.dot(28, 38, 3, v.skin)
        // Arrow up
        f.svgLine("M96 40V8", 0x1E7A4C, 4)
        f.svg("M86 14L96 0L106 14Z", 0x1E7A4C)
    }

    /// A tent coming down: the canvas sagging, poles out, a packed bag being rolled, a big arrow down.
    private static func down(_ f: PropPen, _ v: Look) {
        f.oval(4, 90, 118, 10, 0x1E1E1C, 0.14)
        f.svg("M4 94Q14 74 30 78Q42 64 58 76Q70 70 78 94Z", canvas)
        f.svgLine("M18 84Q30 76 40 82M46 78Q56 74 66 86", shade, 1.6)
        f.svgLine("M2 70L40 60M6 62L44 56", 0x3E4C55, 2)
        // Packed bag
        f.rect(84, 72, 34, 20, 0x0F6E56, radius: 10)
        f.svgLine("M92 72V92M110 72V92", 0x0A4F3E, 1.6)
        f.svgLine("M118 76L124 70", 0x1E1E1C, 1.4)
        // Arrow down
        f.svgLine("M58 4V40", 0xC8261B, 4)
        f.svg("M48 34L58 50L68 34Z", 0xC8261B)
        // Person kneeling, pulling a pole out
        f.svgLine("M92 60L100 70H112", v.trousers, 5)
        f.svg("M86 64L88 40C89 35 92 32 95 32C98 32 101 35 102 40L102 64Z", v.coat)
        f.dot(95, 22, 8.5, v.skin)
        f.svg("M87 21C86 15 90 12 95 12C100 12 104 15 103 21C101 17 98 16 95 16C92 16 89 17 87 21Z", v.hair)
        f.svgLine("M88 42Q80 50 74 56", v.coat, 5)
        f.dot(73, 57, 3, v.skin)
    }

    /// A tent in the rain: drops bounce off it, a camper smiles dry inside, a green tick.
    private static func rain(_ f: PropPen) {
        f.oval(18, 2, 34, 22, 0x8E8A80)
        f.oval(40, 0, 44, 28, 0x8E8A80)
        f.oval(4, 12, 92, 24, 0xA19E95)
        var drops = ""
        for (x, y) in [(14.0, 44.0), (28, 52), (44, 46), (60, 54), (76, 46), (90, 54), (22, 66), (84, 70), (52, 64)] {
            drops += "M\(x) \(y)l-2 6"
        }
        f.svgLine(drops, 0x2F5BD3, 2)
        dome(f, x: 6, y: 130, w: 92, color: 0x2F5BD3)
        f.svgLine("M26 84l-6 -4M26 84l2 -6M52 76l-4 -6M52 76l4 -6M78 84l6 -4M78 84l-2 -6", 0x8FB6CF, 1.6)
        // Camper in the door, dry and smiling
        f.dot(52, 118, 7, 0xC99A74)
        f.svg("M45 116C45 110 48 108 52 108C56 108 59 110 59 116C57 113 55 112 52 112C49 112 47 113 45 116Z", 0x2E2117)
        f.svgLine("M49 121Q52 123 55 121", 0x8C5A3C, 1.1)
        f.dot(86, 98, 9, 0x1E7A4C)
        f.svgLine("M81.5 98.5L85 102L91 94", 0xFFFFFF, 2.4)
    }

    /// A wooden outhouse with a heart in the door, and an old hand pump with a bucket (96 × 116).
    static func outhouse(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 116))
        f.oval(2, 110, 92, 6, 0x1E1E1C, 0.14)
        f.rect(6, 28, 46, 84, 0x9A6A42)
        f.svgLine("M15 28V112M24 28V112M33 28V112M42 28V112", 0x7A4E2E, 1.2)
        f.svg("M0 32L30 14L58 30L56 34L30 20L2 36Z", 0x5E6B73)
        f.svg("M2 36L30 20L56 34V28L30 12L0 30Z", 0x6B4A2E)
        f.rect(12, 44, 34, 66, 0x8A5C38, radius: 1)
        f.svg("M29 54C27 50 21 50 21 55C21 59 29 63 29 63C29 63 37 59 37 55C37 50 31 50 29 54Z", 0x2E2117)
        f.dot(40, 82, 1.6, 0x2E2117)
        // Hand pump
        f.rect(70, 56, 10, 52, 0x3F5A4A, radius: 2)
        f.rect(66, 50, 18, 10, 0x3F5A4A, radius: 2)
        f.svgLine("M84 54L96 42", 0x3F5A4A, 3)
        f.svgLine("M70 66H62V72", 0x3F5A4A, 4)
        f.svgLine("M62 74V82", 0x8FB6CF, 2)
        f.svg("M56 86H70L68 106H58Z", 0xB4B2A9)
        f.oval(56, 84, 14, 5, 0x8FB6CF)
    }
}
