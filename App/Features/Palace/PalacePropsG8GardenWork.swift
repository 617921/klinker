import SwiftUI

/// Allotment work: pulling weeds, a gardener with the harvest, laying a path, sowing, and a
/// seed packet pouring into a hand.
enum G8GardenWork {
    typealias Look = PalaceFigures.Look

    // MARK: Weeds

    /// A bed (96 × 72) overrun by dandelions and a thistle, two small lettuces lost between them,
    /// and a hand pulling one weed out, roots and all.
    static func weeds(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 72))
        G8Props.shadow(f, 0, 66, 96, 6)
        f.svg("M4 40Q4 34 12 34H84Q92 34 92 40L96 64Q96 70 88 70H8Q0 70 0 64Z", 0x8C5E38)
        f.dot(20, 60, 5, 0x95B36B)
        f.dot(66, 62, 4.6, 0x95B36B)
        for (x, y) in [(10.0, 54.0), (40, 60), (80, 52), (54, 48)] as [(CGFloat, CGFloat)] { rosette(f, x, y) }
        f.svgLine("M10 54Q8 40 12 30M40 60Q42 44 38 34M80 52Q82 40 78 28", 0x5E8C45, 1.4)
        f.dot(12, 29, 4.6, 0xF2B33D)
        f.dot(38, 33, 4.6, 0xF2B33D)
        f.dot(78, 27, 5.2, 0xFFFDF6, 0.9)
        f.svgLine("M78 27l3 -3M78 27l-3 -3M78 27l4 1M78 27l-4 1M78 27l0 -4", 0xD3D1C7, 0.8)
        f.svgLine("M28 64L30 36", 0x4E7A3A, 1.6)
        f.svg("M30 52L22 46L27 50L20 52L28 55Z M29 44L37 38L33 43L39 44L30 47Z", 0x4E7A3A)
        f.svg("M27 36Q30 28 33 36Z", 0x993556)
        f.svgLine("M26.5 30L28 34M30 28V33M33.5 30L32 34", 0x993556, 1.2)
        f.svgLine("M84 66l1 -6l1 6l1 -7l1 7M48 68l1 -5l1 5l1 -6l1 6", 0x5E8C45, 1.1)
        // The pulled weed, lifted out of the bed with its roots hanging.
        f.svgLine("M58 30V40M58 34L54 44M58 36L62 45M57 40L56 47", 0xE8D6A8, 1.2)
        f.dot(58, 41, 3, 0x6B4A2E, 0.8)
        rosette(f, 58, 28)
        f.svgLine("M58 27V14", 0x5E8C45, 1.4)
        f.dot(58, 12, 4.4, 0xF2B33D)
        f.svgLine("M96 -2L72 14", 0x5E6B73, 9)
        f.svg("M74 10C69 8 63 10 61 15C60 19 62 22 66 22C70 22 74 19 75 15Z", 0xE8C4A0)
        f.svgLine("M62 16H58", 0xE8C4A0, 3)
    }

    /// The jagged leaves of a dandelion, lying round the foot at (x, y).
    private static func rosette(_ f: PropPen, _ x: CGFloat, _ y: CGFloat) {
        f.svg("M\(x) \(y)L\(x - 12) \(y - 3)L\(x - 8) \(y - 1)L\(x - 11) \(y + 2)L\(x - 4) \(y + 1)Z M\(x) \(y)L\(x + 12) \(y - 4)L\(x + 8) \(y - 1)L\(x + 12) \(y + 2)L\(x + 4) \(y + 1)Z M\(x) \(y)L\(x - 4) \(y - 10)L\(x - 1) \(y - 7)L\(x + 3) \(y - 11)L\(x + 2) \(y - 3)Z", 0x4E7A3A)
    }

    // MARK: Gardener with the harvest

    /// A gardener in a straw hat (84 × 114) holding out a crate heaped with carrots, tomatoes and a
    /// lettuce; a label on the crate reads `text`.
    static func gardener(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 114))
        let v = Look.at(p.variant ?? 4)
        let shirt: UInt32 = 0x3F5A4A
        G8Props.shadow(f, 4, 107, 70)
        f.svgLine("M17 84V104M27 84V104", 0x3E4C55, 5)
        f.svg("M12 103H21V108H12Z M23 103H32V108H23Z", 0x2E2117)
        f.svg("M9 88L10.5 44C11.5 36 15.5 32 22 32C28.5 32 32.5 36 33.5 44L35 88Z", shirt)
        f.svg("M14 50H30V90H14Z", 0x2F5BD3)
        f.svgLine("M14 50L18 36M30 50L26 36", 0x2F5BD3, 2)
        f.svgLine("M13 42C11 50 14 58 20 62", PalaceInk.shade(shirt, 0.8), 6)
        f.dot(22, 19, 11, v.skin)
        f.svg("M11 18C10 12 14 9 22 9C30 9 34 12 33 18C31 14 27 13 22 13C17 13 13 14 11 18Z", v.hair)
        f.oval(4, 7, 36, 8, 0xE8C47A)
        f.svg("M12 10Q13 0 22 0Q31 0 32 10Z", 0xE8C47A)
        f.rect(12.5, 7, 19, 3, 0xC8261B)
        f.svgLine("M8 11H36", 0xC9A15B, 0.8)
        f.dot(28, 20, 1.3, 0x2E2117)
        f.svgLine("M26 25Q29 27.5 31.5 24.5", 0x8C5A3C, 1.3)
        // Crate held out in front, produce heaped on it.
        f.svg("M44 48L48 34L52 48Z M50 48L55 33L59 48Z M56 48L60 36L64 48Z", 0xF2711C)
        f.svgLine("M48 34L45 28M48 34L50 27M55 33L53 26M55 33L58 27M60 36L62 30", 0x5E8C45, 1.6)
        f.dot(68, 44, 6.5, 0x6E9C52)
        f.dot(68, 43, 3, 0x95B36B)
        for (x, y) in [(40.0, 46.0), (76, 47), (47, 50), (71, 51)] as [(CGFloat, CGFloat)] { f.dot(x, y, 4, 0xC8261B) }
        f.rect(34, 50, 48, 22, 0xC9965F, radius: 1.5)
        f.svgLine("M34 57H82M34 64H82", 0x9A6A42, 1.2)
        f.svgLine("M36 50V72M80 50V72", 0x9A6A42, 1.6)
        f.svgLine("M31 41C34 48 34 54 36 60", shirt, 6)
        f.dot(37, 61, 3.4, v.skin)
        f.dot(80, 60, 3.4, v.skin)
        if let text = p.text {
            let label = CGRect(x: 40, y: 58.5, width: 36, height: 11)
            f.rect(label, 0xFFFDF6, radius: 1.5)
            f.text(text, PropFont.heavy(7.5), 0x0F6E56, at: CGPoint(x: label.midX, y: label.midY + 0.5), maxWidth: label.width - 3)
        }
    }

    // MARK: Laying a path

    /// A garden path being laid (100 × 76): grey tiles set in sand, a string between two pegs
    /// marking where it goes next, a hand lowering the next tile, a stack of tiles and a barrow.
    static func layPath(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 76))
        G8Props.shadow(f, 0, 70, 100, 6)
        f.svg("M4 72L26 22H54L44 72Z", 0xE2D6BC)
        f.svgLine("M4 72L26 22M44 72L54 22", 0xCDBF9E, 1)
        for row in 0..<2 {
            for col in 0..<2 {
                let y0 = 72 - CGFloat(row) * 15, y1 = y0 - 14
                let l0 = 4 + CGFloat(row) * 6.6, l1 = l0 + 6.2
                let w0 = (44 - l0 + CGFloat(row) * (-2 + 6.6)) / 2, w1 = w0 - 0.8
                let x0 = l0 + CGFloat(col) * w0, x1 = l1 + CGFloat(col) * w1
                f.svg("M\(x0 + 0.8) \(y0 - 0.8)L\(x1 + 0.8) \(y1 + 0.8)H\(x1 + w1 - 0.8)L\(x0 + w0 - 0.8) \(y0 - 0.8)Z", 0x9A9A92)
            }
        }
        f.svgLine("M24 26L22 16M56 26L58 16", 0x9A6A42, 2.2)
        f.svgLine("M23 18H57", 0xC8261B, 0.9)
        f.svgLine("M17 41L14 34M50 41L51 34", 0x9A6A42, 2)
        f.svgLine("M15 36H51", 0xC8261B, 0.9)
        // The hand lowering the next tile.
        f.svg("M22 30L25 22H43L41 30Z", 0xB4B2A9)
        f.svgLine("M23.5 26H42", 0x9A9A92, 1)
        f.svgLine("M48 2L39 20", 0x2F5BD3, 7)
        f.svg("M36 18C33 18 31 21 32 24L35 26C38 26 41 24 41 21Z", 0xE8C4A0)
        // Stack of tiles and the barrow.
        for k in 0..<4 { f.rect(62, 64 - CGFloat(k) * 5, 22, 4.4, k % 2 == 0 ? 0x9A9A92 : 0xB4B2A9, radius: 0.6) }
        f.svg("M66 28H96L92 42H70Z", 0x2F4B3A)
        f.svg("M68 28Q81 20 94 28Z", 0xE2D6BC)
        f.dot(78, 46, 5, 0x1E1E1C)
        f.dot(78, 46, 1.8, 0x7D8A92)
        f.svgLine("M70 42L60 50M92 42L99 50M82 42L78 46", 0x3E4C55, 1.6)
    }

    // MARK: Sowing

    /// A hand scattering seeds (88 × 94): seeds trail from the fingers into a straight furrow,
    /// more seeds already lying in it at even steps.
    static func sowing(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 88, height: 94))
        G8Props.shadow(f, 0, 86, 88, 7)
        f.svg("M2 62Q2 54 12 54H76Q86 54 86 62L88 82Q88 90 78 90H10Q0 90 0 82Z", 0x8C5E38)
        f.svgLine("M6 76L82 68", 0x5A3E28, 4)
        f.svgLine("M6 74.6L82 66.6", 0xA87B4F, 1)
        for x in stride(from: 12.0, to: 80, by: 9) { seed(f, x, 76 - (x - 6) * 0.105) }
        f.svgLine("M-2 2L24 22", 0x5E6B73, 13)
        f.svgLine("M-2 2L22 20", 0x7D8A92, 4)
        f.svg("M22 16C28 14 38 18 42 24L46 32C47 35 44 37 41 35L38 31L40 37C40 40 36 41 35 38L31 31C27 30 21 27 20 22Z", 0xE8C4A0)
        f.svgLine("M33 24L44 33M30 27L38 36", 0xC99A74, 1)
        for (x, y) in [(42.0, 41.0), (45, 47), (44, 53), (48, 58), (46, 64)] as [(CGFloat, CGFloat)] { seed(f, x, y) }
    }

    /// One seed, a small pale oval with a dark rim.
    static func seed(_ f: PropPen, _ x: CGFloat, _ y: CGFloat) {
        f.oval(x - 2.2, y - 1.5, 4.4, 3, 0x9A6A42)
        f.oval(x - 1.6, y - 1.1, 3.2, 2.2, 0xE8D6A8)
    }

    // MARK: Seed packet

    /// A paper seed packet (66 × 96) with a picture of what grows from it (`icons`: none = a tomato),
    /// tipped so its seeds pour into a cupped hand heaped with seeds.
    static func seedPacket(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 66, height: 96))
        let t = G8Props.turned(f, CGPoint(x: 38, y: 30), -118)
        t.rect(-16, -24, 32, 50, 0x1E1E1C, radius: 1.5, 0.15)
        t.rect(-17, -25, 34, 50, 0xFFFDF6, radius: 1.5)
        t.rect(-17, 13, 34, 12, 0x0F6E56)
        t.svg("M-17 -25L-12 -21L-7 -25L-2 -21L3 -25L8 -21L13 -25L17 -22V-26H-17Z", 0xEFEBE2)
        t.dot(0, -3, 9.5, 0xC8261B)
        t.svg("M0 -12L2 -9L6 -10L3 -7L5 -4L0 -6L-5 -4L-3 -7L-6 -10L-2 -9Z", 0x4E7A3A)
        t.svgLine("M-10 19H10", 0xFFFDF6, 1.6)
        for (x, y) in [(16.0, 44.0), (19, 52), (15, 58), (21, 63), (17, 69)] as [(CGFloat, CGFloat)] { seed(f, x, y) }
        f.svgLine("M66 98L46 88", 0x993556, 12)
        f.svg("M2 78Q4 92 22 92H40Q50 92 52 86Q48 80 40 82L36 76Q20 72 2 78Z", 0xE8C4A0)
        f.svgLine("M6 80Q20 76 34 78", 0xC99A74, 1)
        for (x, y) in [(10.0, 79.0), (15, 77), (20, 76), (25, 77), (13, 74), (18, 73), (23, 74), (28, 78), (17, 70), (21, 71)] as [(CGFloat, CGFloat)] {
            seed(f, x, y)
        }
    }
}
