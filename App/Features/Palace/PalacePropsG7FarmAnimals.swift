import SwiftUI

/// Farm animals and the people who look after them: a cow, a sheep, a goat and a hen, a group of
/// livestock, someone milking a cow and a child feeding a goat.
enum G7FarmAnimals {
    static let dark: UInt32 = 0x1E1E1C
    static let pink: UInt32 = 0xF1B5B5

    // MARK: Animals

    /// A black and white cow seen from the side, facing right, in a 70 × 52 box.
    static func cow(_ f: PropPen, left: Bool = false) {
        var c = f
        if left {
            c.ctx.translateBy(x: 70, y: 0)
            c.ctx.scaleBy(x: -1, y: 1)
        }
        c.oval(4, 47, 62, 5, dark, 0.15)
        c.svgLine("M13 34V49M21 34V49M47 34V49M55 34V49", 0xFFFDF6, 5)
        c.svgLine("M13 48V50M21 48V50M47 48V50M55 48V50", dark, 5)
        c.svgLine("M6 14Q1 22 3 34", 0xFFFDF6, 2)
        c.dot(3, 35, 2.4, dark)
        c.rect(4, 10, 56, 28, 0xFFFDF6, radius: 11)
        c.svg("M14 12Q24 8 30 15Q27 26 17 24Q10 19 14 12Z M38 24Q48 18 54 26Q51 35 41 34Q36 30 38 24Z", dark)
        c.oval(14, 34, 13, 7, pink)
        c.svgLine("M17 40V43M21 40.5V44M25 40V43", pink, 1.8)
        c.svg("M54 6L47 3L52 11Z", 0xFFFDF6)
        c.svgLine("M58 4L57 0M66 4L68 0", 0xE8D6A8, 2)
        c.rect(54, 2, 16, 22, 0xFFFDF6, radius: 7)
        c.svg("M54 9Q54 2 61 2Q66 2 68 6Q62 6 58 12Z", dark)
        c.oval(55, 15, 15, 10, pink)
        c.dot(60, 19.5, 1, 0x8C4A3A)
        c.dot(65, 19.5, 1, 0x8C4A3A)
        c.dot(64, 9, 1.4, dark)
    }

    /// A cow's head seen from the front, centred on (x, y) (about 30 × 26).
    static func cowHead(_ f: PropPen, x: CGFloat, y: CGFloat, flip: Bool) {
        let s: CGFloat = flip ? -1 : 1
        f.svg("M\(x - 9) \(y - 7)L\(x - 17) \(y - 10)L\(x - 10) \(y - 2)Z M\(x + 9) \(y - 7)L\(x + 17) \(y - 10)L\(x + 10) \(y - 2)Z", 0xFFFDF6)
        f.svgLine("M\(x - 5) \(y - 12)L\(x - 8) \(y - 16)M\(x + 5) \(y - 12)L\(x + 8) \(y - 16)", 0xE8D6A8, 2)
        f.rect(x - 9, y - 13, 18, 24, 0xFFFDF6, radius: 7)
        f.svg("M\(x - 9 * s) \(y - 6)Q\(x - 9 * s) \(y - 13) \(x - 2 * s) \(y - 13)H\(x + 2 * s)Q\(x + 1 * s) \(y - 4) \(x - 9 * s) \(y - 1)Z", dark)
        f.oval(x - 9, y + 1, 18, 10, pink)
        f.dot(x - 3.5, y + 6, 1.1, 0x8C4A3A)
        f.dot(x + 3.5, y + 6, 1.1, 0x8C4A3A)
        f.dot(x - 4, y - 4, 1.3, dark)
        f.dot(x + 4, y - 4, 1.3, dark)
    }

    /// A woolly sheep with a dark face, facing right, in a 44 × 36 box.
    static func sheep(_ f: PropPen) {
        f.oval(4, 32, 36, 4, dark, 0.15)
        f.svgLine("M12 24V34M18 24V34M28 24V34M33 24V34", 0x2E2117, 3)
        for (x, y, r) in [(10.0, 14.0, 8.0), (18, 10, 8.5), (27, 11, 8.5), (32, 17, 7), (21, 20, 9), (12, 21, 7)] as [(CGFloat, CGFloat, CGFloat)] {
            f.dot(x, y, r, 0xF4F1EA)
        }
        f.svg("M36 8L44 12L42 20L36 21Z", 0x2E2117)
        f.svg("M35 9L30 7L34 13Z", 0x2E2117)
        f.dot(40, 13, 1, 0xFFFDF6)
        f.dot(36, 7, 4.4, 0xF4F1EA)
    }

    /// A goat with curved horns and a beard, facing left, in a 44 × 44 box.
    static func goat(_ f: PropPen) {
        f.oval(4, 40, 36, 4, dark, 0.15)
        f.svgLine("M14 28V42M19 28V42M32 28V42M37 28V42", 0xC9A15B, 3)
        f.svgLine("M40 16Q44 12 43 9", 0xE8DCC8, 2)
        f.rect(10, 14, 32, 18, 0xE8DCC8, radius: 8)
        f.svg("M26 15Q34 12 40 18Q36 26 28 24Z", 0xC9A15B)
        f.svgLine("M10 18L6 4", 0xE8DCC8, 6)
        f.svg("M0 8Q2 2 8 2Q12 4 12 10L8 14Q2 14 0 8Z", 0xE8DCC8)
        f.svgLine("M8 3Q12 -2 16 3", 0x8E8A80, 2)
        f.svg("M10 6L17 8L11 10Z", 0xE8DCC8)
        f.svg("M2 12L4 18L6 12Z", 0x9A9A92)
        f.dot(4, 6, 1.1, dark)
    }

    /// A small brown hen centred on (x, y), facing left.
    static func hen(_ f: PropPen, x: CGFloat, y: CGFloat) {
        f.svgLine("M\(x - 1) \(y + 5)V\(y + 10)M\(x + 3) \(y + 5)V\(y + 10)", 0xE0A93A, 1.2)
        f.svg("M\(x + 8) \(y - 6)Q\(x + 10) \(y + 2) \(x + 4) \(y + 6)H\(x - 4)Q\(x - 8) \(y + 2) \(x - 6) \(y - 4)Z", 0x9A5238)
        f.dot(x - 5, y - 6, 3.4, 0x9A5238)
        f.svg("M\(x - 7) \(y - 10)Q\(x - 5) \(y - 12) \(x - 3) \(y - 9)Z", 0xC8261B)
        f.svg("M\(x - 8.4) \(y - 6.5)L\(x - 11) \(y - 5.2)L\(x - 8.2) \(y - 4.4)Z", 0xE0A93A)
        f.dot(x - 6, y - 6.6, 0.8, dark)
        f.svgLine("M\(x - 1) \(y)Q\(x + 3) \(y + 2) \(x + 5) \(y - 2)", 0x7B3F2E, 1)
    }

    // MARK: Scenes

    /// A cow, a sheep and a goat together (116 × 96).
    static func livestock(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 116, height: 96))
        cow(f.within(CGRect(x: 26, y: 0, width: 84, height: 62), unit: 1.2))
        sheep(f.within(CGRect(x: 0, y: 46, width: 52, height: 43), unit: 1.18))
        goat(f.within(CGRect(x: 62, y: 44, width: 52, height: 52), unit: 1.18))
    }

    /// Someone on a stool milking a cow into a bucket (118 × 104).
    static func milking(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 118, height: 104))
        cow(f.within(CGRect(x: 20, y: 12, width: 98, height: 73), unit: 1.4))
        // Bucket under the udder, with milk
        f.svg("M42 84H60L58 102H44Z", 0xB4B2A9)
        f.oval(42, 81, 18, 6, 0xFFFDF6)
        f.svgLine("M46 72L48 82M52 72L52 82", 0xFFFDF6, 1.4)
        // Milker on a three-legged stool
        f.svgLine("M10 90L6 104M18 90L18 104M26 90L30 104", 0x8A5C38, 2.4)
        f.oval(4, 86, 26, 6, 0x9A6A42)
        f.svg("M8 88L10 66C11 60 14 56 19 56C24 56 27 60 28 66L28 88Z", 0x2F5BD3)
        f.svg("M12 62Q19 58 26 62L26 70H12Z", 0xC8261B)
        f.svgLine("M26 64Q36 66 44 70", 0x2F5BD3, 5)
        f.dot(45, 70, 2.8, 0xE8C4A0)
        f.svgLine("M28 88H40V100", 0x2F5BD3, 5)
        f.rect(36, 98, 10, 5, 0x2F4337, radius: 1)
        f.dot(19, 46, 9, 0xE8C4A0)
        f.svg("M10 44Q10 36 19 36Q27 36 29 42L33 44L28 45Z", 0x5E6B73)
        f.dot(24, 47, 1.1, dark)
    }

    /// A child holding out a bottle and a handful of hay to a goat (112 × 104).
    static func feeding(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 104))
        let v = PalaceFigures.Look.at(p.variant ?? 3)
        // Child
        f.oval(2, 98, 40, 5, dark, 0.15)
        f.svgLine("M14 78V98M22 78V98", v.trousers, 4.5)
        f.svg("M10 97H17V101H9Z M19 97H26V101H19Z", 0x2E2117)
        f.svg("M8 80L10 52C11 47 14 44 18 44C22 44 25 47 26 52L28 80Z", v.coat)
        f.svgLine("M11 54Q8 64 10 70", PalaceInk.shade(v.coat, 0.8), 5)
        f.dot(18, 33, 9.5, v.skin)
        f.svg("M9 32C8 25 12 22 18 22C24 22 28 25 27 32C25 28 22 27 18 27C14 27 11 28 9 32Z", v.hair)
        f.dot(23, 33, 1.2, 0x2E2117)
        f.svgLine("M24 54Q34 56 42 54", v.coat, 5)
        f.dot(43, 54, 3, v.skin)
        // Bottle with a teat, and a bit of hay
        f.rect(44, 50, 16, 8, 0xFFFDF6, radius: 3)
        f.svg("M60 51L66 53V55L60 57Z", 0xC9965F)
        f.svgLine("M46 54H56", 0xD3D1C7, 1)
        f.svgLine("M38 60L50 66M40 62L52 64M38 64L48 70", 0xE0A93A, 1.4)
        // Goat reaching up for it
        goat(f.within(CGRect(x: 64, y: 44, width: 48, height: 53), unit: 1.2))
    }
}
