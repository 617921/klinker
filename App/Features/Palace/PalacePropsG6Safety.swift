import SwiftUI

/// Safety props: hazard signs and things (a jerrycan with a flame diamond, a skull warning sign,
/// a break-glass alarm with a flashing light), a smoke alarm, the emergency services in a row and
/// a green exit sign.
enum G6Safety {
    static func hazard(_ pen: PropPen, _ p: PalacePropParams) {
        switch p.accessory ?? "flammable" {
        case "skull": skullSign(pen.fitted(CGSize(width: 70, height: 102)), text: p.text)
        case "callPoint": callPoint(pen.fitted(CGSize(width: 48, height: 60)))
        default: jerrycan(pen.fitted(CGSize(width: 62, height: 86)))
        }
    }

    // MARK: Jerrycan

    /// A red jerrycan (62 × 86) with a white diamond showing a black flame.
    private static func jerrycan(_ f: PropPen) {
        f.oval(4, 80, 56, 6, 0x1E1E1C, 0.16)
        f.svg("M6 30Q6 24 12 24H54Q58 24 58 30V80Q58 84 54 84H10Q6 84 6 80Z", 0xC8261B)
        f.svg("M14 24V12Q14 8 18 8H40Q44 8 44 12V24H38V14H20V24Z", 0x9A1E15)
        f.svg("M46 24L50 10H58L56 24Z", 0x5E6B73)
        f.svgLine("M12 34L52 78M52 34L12 78", 0x9A1E15, 2, 0.6)
        // flame diamond
        f.svg("M32 36L50 54L32 72L14 54Z", 0xFFFDF6)
        f.stroke(PalaceSVG.path("M32 38.5L47.5 54L32 69.5L16.5 54Z"), 0xC8261B, 2)
        f.svg("M27 63C24 58 27 52 31 47C31 52 35 52 35 49C38 53 39 59 36 63Z", 0x1E1E1C)
        f.rect(24, 63, 16, 2.4, 0x1E1E1C)
    }

    // MARK: Skull sign

    /// A warning sign on a post (70 × 102): a yellow triangle with a skull and crossed bones,
    /// `text` on a plate under it.
    private static func skullSign(_ f: PropPen, text: String?) {
        f.oval(18, 96, 34, 6, 0x1E1E1C, 0.16)
        f.rect(32, 44, 6, 56, 0x8E9AA0)
        let tri = PalaceSVG.path("M35 2L68 60H2Z")
        f.fill(tri, 0xFAC775)
        f.stroke(PalaceSVG.path("M35 6L64.5 58H5.5Z"), 0x1E1E1C, 3.4)
        // crossed bones
        f.svgLine("M22 50L48 34M22 34L48 50", 0xFFFDF6, 4)
        f.svgLine("M22 50L48 34M22 34L48 50", 0x1E1E1C, 0.8)
        // skull
        f.svg("M26 34C24 24 30 19 35 19C40 19 46 24 44 34L42 36V40H28V36Z", 0xFFFDF6)
        f.stroke(PalaceSVG.path("M26 34C24 24 30 19 35 19C40 19 46 24 44 34L42 36V40H28V36Z"), 0x1E1E1C, 1.2)
        f.dot(31, 30, 3, 0x1E1E1C)
        f.dot(39, 30, 3, 0x1E1E1C)
        f.svg("M35 33L33 36H37Z", 0x1E1E1C)
        f.svgLine("M31 38V40M35 38V40M39 38V40", 0x1E1E1C, 0.9)
        guard let text, !text.isEmpty else { return }
        f.rect(8, 64, 54, 16, 0xFFFDF6, radius: 2)
        f.stroke(Path(roundedRect: CGRect(x: 8, y: 64, width: 54, height: 16), cornerRadius: 2), 0xC8261B, 1.4)
        f.text(text, PropFont.heavy(10), 0xC8261B, at: CGPoint(x: 35, y: 72.5), maxWidth: 50)
    }

    // MARK: Call point

    /// A red break-glass alarm box (48 × 60): a hand pressing the cracked glass, a flashing
    /// orange light on top.
    private static func callPoint(_ f: PropPen) {
        f.svgLine("M10 6L4 0M24 4V-2M38 6L44 0M6 14H0M42 14H48", 0xF2711C, 2)
        f.svg("M14 16Q14 6 24 6Q34 6 34 16Z", 0xF2711C)
        f.svg("M18 12Q20 9 24 9", 0xFFFDF6, 0.6)
        f.rect(12, 16, 24, 4, 0x5E6B73)
        f.rect(4, 20, 40, 40, 0xC8261B, radius: 4)
        f.rect(10, 26, 28, 28, 0xFFFDF6, radius: 1.5)
        f.svgLine("M24 40L17 33M24 40L32 31M24 40L22 51M24 40L34 46", 0x8E9AA0, 1)
        f.svg("M20 50L22 38Q24 34 26 38L27 44H33Q36 45 34 50Z", 0xE8C4A0)
        f.rect(19, 50, 16, 10, 0x1F3A6B)
    }

    // MARK: Smoke alarm

    /// A smoke alarm on the ceiling (78 × 44): smoke curls up into it, its red light is on and
    /// beeps ring out to both sides.
    static func smokeAlarm(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 78, height: 44), hanging: true)
        f.rect(0, 0, 78, 3, 0x1E1E1C, 0.25)
        f.svg("M23 3H55Q55 12 47 14H31Q23 12 23 3Z", 0xFFFDF6)
        f.stroke(PalaceSVG.path("M23 3H55Q55 12 47 14H31Q23 12 23 3Z"), 0xB4B2A9, 0.8)
        f.svgLine("M30 8H48", 0xD3D1C7, 1)
        f.dot(39, 12, 2.2, 0xC8261B)
        f.dot(39, 12, 4.5, 0xC8261B, 0.3)
        for (i, r) in [7.0, 12, 17].enumerated() {
            var left = Path(), right = Path()
            left.addArc(center: CGPoint(x: 22, y: 8), radius: r, startAngle: .degrees(140), endAngle: .degrees(220), clockwise: false)
            right.addArc(center: CGPoint(x: 56, y: 8), radius: r, startAngle: .degrees(-40), endAngle: .degrees(40), clockwise: false)
            f.stroke(left, 0xC8261B, 1.8 - CGFloat(i) * 0.3)
            f.stroke(right, 0xC8261B, 1.8 - CGFloat(i) * 0.3)
        }
        f.svgLine("M34 44C26 38 40 32 34 26C30 22 36 18 36 16M44 44C52 38 38 32 44 26C46 22 42 19 42 16", 0x5E6B73, 3, 0.7)
    }

    // MARK: Emergency services

    /// A police car, an ambulance and a small fire car in a row (150 × 58), blue lights flashing.
    static func responders(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 150, height: 58))
        f.oval(2, 52, 146, 6, 0x1E1E1C, 0.16)
        // police car: white with blue and orange bands
        let police = f.within(CGRect(x: 0, y: 30, width: 50, height: 22.9), unit: 50 / 140)
        G6Cars.body(police, 0xFFFDF6)
        police.rect(8, 34, 128, 6, 0x2F5BD3)
        police.rect(8, 40, 128, 3, 0xF2711C)
        light(f, 24, 28)
        // ambulance: a yellow van with a blue-green check band
        f.rect(52, 18, 46, 32, 0xF2C230, radius: 3)
        f.svg("M84 18H92Q98 20 98 30V34H84Z", 0xBFD9E6)
        for i in 0..<8 {
            f.rect(52 + CGFloat(i) * 5.5, 36, 5.5, 5, i % 2 == 0 ? 0x2F5BD3 : 0x1E9C8A)
        }
        f.dot(62, 50, 5, 0x2E2117)
        f.dot(88, 50, 5, 0x2E2117)
        f.dot(62, 50, 2, 0xB4B2A9)
        f.dot(88, 50, 2, 0xB4B2A9)
        light(f, 68, 16)
        // fire car
        let fire = f.within(CGRect(x: 100, y: 30, width: 50, height: 22.9), unit: 50 / 140)
        G6Cars.body(fire, 0xC8261B)
        fire.rect(8, 36, 128, 4, 0xF2C230)
        light(f, 124, 28)
    }

    private static func light(_ f: PropPen, _ x: CGFloat, _ y: CGFloat) {
        f.svgLine("M\(x - 9) \(y - 6)L\(x - 5) \(y - 3)M\(x) \(y - 10)V\(y - 6)M\(x + 9) \(y - 6)L\(x + 5) \(y - 3)", 0x2F5BD3, 1.4)
        f.rect(x - 4, y - 3, 8, 4, 0x2F5BD3, radius: 1.5)
    }

    // MARK: Exit sign

    /// A green exit sign (50 × 32): a white figure running into a doorway, an arrow.
    /// `mount` "hang" (two rods) or "wall".
    static func exitSign(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 50, height: 32), hanging: true)
        let hang = p.mount != "wall"
        if hang { f.svgLine("M12 0V5M38 0V5", 0x2E2117, 1.4) }
        let r = CGRect(x: 0, y: hang ? 4 : 0, width: 50, height: 28)
        f.rect(r, 0x1E7A4C, radius: 2)
        f.stroke(Path(roundedRect: r.insetBy(dx: 1.5, dy: 1.5), cornerRadius: 1.5), 0xFFFDF6, 0.8)
        let y = r.minY
        // doorway
        f.svgLine("M30 \(y + 23)V\(y + 5)H40V\(y + 23)", 0xFFFDF6, 1.8)
        // running figure
        f.dot(21, y + 7, 2.4, 0xFFFDF6)
        f.svgLine("M20 \(y + 10)L17 \(y + 17)M17 \(y + 17)L13 \(y + 23)M17 \(y + 17)L22 \(y + 19)L23 \(y + 24)M19 \(y + 12)L24 \(y + 14)L27 \(y + 12)M19 \(y + 12)L14 \(y + 14)", 0xFFFDF6, 2)
        // arrow
        f.svgLine("M4 \(y + 14)H10M7.5 \(y + 11)L10.5 \(y + 14)L7.5 \(y + 17)", 0xFFFDF6, 1.6)
        f.svgLine("M42 \(y + 14)H47M44.5 \(y + 11)L47.5 \(y + 14)L44.5 \(y + 17)", 0xFFFDF6, 1.6)
    }
}
