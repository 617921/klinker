import SwiftUI

/// People in and by the pool: someone drying off with a towel, swimmers (a lap swimmer with an
/// arrow there and back, a swimming lesson, a child standing in shallow water) and a floating
/// thermometer over warm, steaming water.
enum G4Swim {
    typealias Look = PalaceFigures.Look
    static let water: UInt32 = 0x5BAED0

    // MARK: Drying off

    /// A bather (56 × 118) rubbing their hair with a striped towel; drops fly off, a puddle below.
    static func towelDry(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 56, height: 118))
        let v = Look.at(p.variant ?? 2)
        f.oval(4, 108, 50, 8, 0x8FB6CF, 0.7)
        bather(f, x: 4, top: 4, v, suit: PropColor.named(p.tone, 0x3C3489))
        // A big striped towel over the head, hanging down both sides
        let towel = PalaceSVG.path("M5 22C4 2 48 2 47 22L49 66H37L35 26C33 15 19 15 17 26L15 66H3Z")
        f.fill(towel, 0xFFFDF6)
        f.stroke(towel, 0xB4B2A9, 1)
        f.svgLine("M8 12Q26 -2 44 12M4 50H16M36 50H48M4 56H16M36 56H48", 0x2F5BD3, 2.2)
        f.svgLine("M3 66V69M7 66V69M11 66V69M15 66V69M37 66V69M41 66V69M45 66V69M49 66V69", 0xB4B2A9, 1)
        // Both hands rub it, drops fly off
        f.svgLine("M15 50C9 44 9 34 12 26M37 50C43 44 43 34 40 26", v.skin, 4.4)
        f.dot(12, 24, 3.2, v.skin)
        f.dot(40, 24, 3.2, v.skin)
        f.svgLine("M2 18Q0 22 2 26M50 18Q52 22 50 26M5 8Q8 4 12 5M40 5Q44 4 47 8", 0x5E6B73, 1.1)
        for (x, y) in [(1.0, 34.0), (53.0, 32.0), (52.0, 2.0), (2.0, 0.0), (27.0, 76.0)] as [(CGFloat, CGFloat)] {
            f.svg("M\(x) \(y)Q\(x + 2) \(y + 3.5) \(x) \(y + 4.5)Q\(x - 2) \(y + 3.5) \(x) \(y)Z", 0x5BAED0)
        }
    }

    /// A standing person in swimwear (the 64 × 114 build, shifted by `x`, `top`), arms left to the caller.
    static func bather(_ f: PropPen, x: CGFloat, top: CGFloat, _ v: Look, suit: UInt32) {
        let t = top
        f.svgLine("M\(x + 17) \(t + 82)V\(t + 103)M\(x + 27) \(t + 82)V\(t + 103)", v.skin, 5)
        f.svg("M\(x + 12) \(t + 102)H\(x + 21)V\(t + 106)H\(x + 12)Z M\(x + 23) \(t + 102)H\(x + 32)V\(t + 106)H\(x + 23)Z", v.skin)
        f.svg("M\(x + 11) \(t + 46)C\(x + 11) \(t + 38) \(x + 15) \(t + 34) \(x + 22) \(t + 34)C\(x + 29) \(t + 34) \(x + 33) \(t + 38) \(x + 33) \(t + 46)V\(t + 52)H\(x + 11)Z", v.skin)
        f.svg("M\(x + 11) \(t + 50)Q\(x + 22) \(t + 46) \(x + 33) \(t + 50)L\(x + 34) \(t + 86)H\(x + 10)Z", suit)
        f.svgLine("M\(x + 15) \(t + 40)V\(t + 50)M\(x + 29) \(t + 40)V\(t + 50)", suit, 2)
        G4Draw.head(f, x + 22, t + 21, v)
    }

    // MARK: Swimmers

    /// Swimmers in the water. `accessory` "laps" (172 × 56: a crawl swimmer and a long white arrow
    /// there and back), "lesson" (128 × 64: a teacher waist-deep and two children with armbands and
    /// a float), "shallow" (110 × 64: a child standing in water only up to the knees, a depth tile `text`).
    static func swimmers(_ pen: PropPen, _ p: PalacePropParams) {
        switch p.accessory {
        case "lesson": lesson(pen.fitted(CGSize(width: 128, height: 64)))
        case "shallow": shallow(pen.fitted(CGSize(width: 110, height: 64)), depth: p.text)
        default: laps(pen.fitted(CGSize(width: 172, height: 56)))
        }
    }

    private static func laps(_ f: PropPen) {
        let v = Look.at(7)
        f.svgLine("M66 34L104 34", v.skin, 8)
        f.svgLine("M84 36L74 46", v.skin, 3.6)
        f.rect(80, 30, 16, 9, 0xC8261B, radius: 3)
        f.svgLine("M106 34Q118 10 138 26", v.skin, 4)
        f.dot(139, 27, 2.6, v.skin)
        f.dot(112, 28, 7.5, v.skin)
        f.svg("M104.5 27C104 21 108 19 112 19C116 19 120 21 119.5 27Z", 0xF2B33D)
        f.rect(113, 25.5, 7, 3.4, 0x232B3B, radius: 1.6)
        f.rect(46, 30, 128, 26, water, 0.55)
        f.svgLine("M98 30q4 -2 8 0M116 33q4 -2 8 0", 0xFFFDF6, 1.4)
        for (x, y, r) in [(58.0, 26.0, 4.0), (64, 22, 3.0), (52, 22, 2.6), (62, 30, 3.4)] as [(CGFloat, CGFloat, CGFloat)] {
            f.dot(x, y, r, 0xFFFDF6, 0.9)
        }
        f.svgLine("M146 22H160Q170 22 170 34Q170 46 160 46H22", 0xFFFDF6, 2.4)
        f.svgLine("M30 40L22 46L30 52M154 16L160 22L154 28", 0xFFFDF6, 2.4)
    }

    private static func lesson(_ f: PropPen) {
        let t = Look.at(1)
        // The teacher, waist-deep, holding a child's hands
        f.svg("M8 62L9 40C10 33 14 30 22 30C30 30 34 33 35 40L36 62Z", 0x0F6E56)
        f.svg("M17 30L22 36L27 30Z", 0xFFFDF6)
        f.svgLine("M22 36V44", 0x1E1E1C, 0.8)
        f.rect(20.5, 43, 3, 5, 0xFAC775, radius: 1)
        G4Draw.head(f, 22, 17, t)
        G4Draw.smile(f, 22, 17)
        f.svgLine("M32 40C40 46 46 50 54 52", 0x0F6E56, 5)
        f.dot(55, 52, 2.8, t.skin)
        // Child 1 swimming to her, orange armbands
        child(f, 64, 54, Look.at(3), bands: true, arms: "M60 56L56 52M68 56L58 54")
        // Child 2 on a float, kicking
        f.rect(84, 46, 24, 10, 0xF2B33D, radius: 4)
        child(f, 104, 56, Look.at(5), bands: false, arms: "M100 56L92 50M107 56L100 50")
        f.rect(0, 58, 128, 6, water, 0.55)
        for (x, y) in [(120.0, 56.0), (124, 60), (116, 60)] as [(CGFloat, CGFloat)] { f.dot(x, y, 2.6, 0xFFFDF6, 0.9) }
        f.svgLine("M4 58q4 -2 8 0t8 0t8 0t8 0M48 58q4 -2 8 0t8 0t8 0M90 58q4 -2 8 0t8 0", 0xFFFDF6, 1.2)
    }

    /// A child's head and shoulders above the water at (x, y).
    private static func child(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ v: Look, bands: Bool, arms: String) {
        f.svgLine(arms, v.skin, 3.4)
        if bands {
            f.rect(x - 9, y - 1, 6, 5, 0xF2711C, radius: 2)
            f.rect(x + 3, y - 1, 6, 5, 0xF2711C, radius: 2)
        }
        f.dot(x, y - 6, 7, v.skin)
        f.svg("M\(x - 7) \(y - 7)C\(x - 7) \(y - 12) \(x - 4) \(y - 14) \(x) \(y - 14)C\(x + 4) \(y - 14) \(x + 7) \(y - 12) \(x + 7) \(y - 7)C\(x + 5) \(y - 10) \(x - 5) \(y - 10) \(x - 7) \(y - 7)Z", v.hair)
        f.dot(x + 3, y - 6, 1, 0x2E2117)
        f.svgLine("M\(x + 1) \(y - 2)Q\(x + 3) \(y - 0.5) \(x + 5) \(y - 2)", 0x8C2A1E, 0.9)
    }

    private static func shallow(_ f: PropPen, depth: String?) {
        let v = Look.at(6)
        let kid = f.within(CGRect(x: 26, y: 2, width: 36, height: 62), unit: 0.56)
        bather(kid, x: 0, top: 0, v, suit: 0xF2B33D)
        kid.svgLine("M13 42L2 30M31 42L44 30", v.skin, 5)
        kid.dot(1, 29, 3.2, v.skin)
        kid.dot(45, 29, 3.2, v.skin)
        G4Draw.smile(kid, 22, 21)
        f.rect(0, 52, 110, 12, water, 0.55)
        f.svgLine("M28 52q4 -2.4 8 0t8 0t8 0", 0xFFFDF6, 1.4)
        // A rubber duck and the depth tile
        PalaceParkProps.duck(f, 62, 52, body: 0xF2B33D, head: 0xF2B33D, wing: 0xE0A030, left: false)
        f.rect(70, 10, 38, 24, 0xFFFDF6, radius: 3)
        f.stroke(Path(roundedRect: CGRect(x: 70, y: 10, width: 38, height: 24), cornerRadius: 3), 0x2F6E9E, 1.4)
        f.text(depth ?? "", PropFont.heavy(11), 0x1F3A6B, at: CGPoint(x: 89, y: 19), maxWidth: 34)
        f.svgLine("M74 28q3 -2 6 0t6 0t6 0t6 0t6 0", 0x2F6E9E, 1.2)
    }

    // MARK: Warm water

    /// A floating thermometer (100 × 64) with its red column high and a `text` tag ("29°"), steam
    /// rising off the water, and a red heater coil under the surface warming it.
    static func poolThermometer(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 64))
        f.svgLine("M16 38Q10 30 16 22Q22 14 16 6M32 36Q26 28 32 20Q38 12 32 2M84 38Q78 30 84 22Q90 14 84 6", 0xFFFDF6, 2.2)
        f.rect(44, 4, 12, 44, 0xFFFDF6, radius: 6)
        f.stroke(Path(roundedRect: CGRect(x: 44, y: 4, width: 12, height: 44), cornerRadius: 6), 0x5E6B73, 1.2)
        f.rect(48, 10, 4, 36, 0xC8261B, radius: 2)
        f.dot(50, 46, 6, 0xC8261B)
        f.svgLine("M56 14H59M56 20H58M56 26H59", 0x5E6B73, 1)
        f.rect(40, 34, 20, 6, 0x2F5BD3, radius: 3)
        if let tag = p.text {
            f.rect(62, 6, 34, 18, 0xC8261B, radius: 3)
            f.svg("M62 12L57 16L62 18Z", 0xC8261B)
            f.text(tag, PropFont.heavy(12), 0xFFFDF6, at: CGPoint(x: 79, y: 15.5), maxWidth: 30)
        }
        f.rect(0, 38, 100, 26, water, 0.45)
        f.svgLine("M6 38q5 -2.6 10 0t10 0t10 0M62 38q5 -2.6 10 0t10 0t10 0", 0xFFFDF6, 1.3)
        f.svgLine("M8 60L14 55L20 60L26 55L32 60L38 55L44 60L50 55L56 60L62 55L68 60L74 55L80 60L86 55L92 60", 0xF2711C, 2.4)
        f.svgLine("M22 52Q19 49 22 45M70 52Q67 49 70 45M86 52Q83 49 86 45", 0xC8261B, 1.4)
    }
}
