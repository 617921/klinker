import SwiftUI

/// Market props: a stall, a scale, a season wheel, a quality rosette, a punnet, ripening fruit,
/// a cash box with coins, two hands giving money back, a haggling talk and a crate to pick from.
/// Each is drawn at a design size and scaled to fit its frame (see `PropPen.fitted`).
enum PalaceMarketProps {
    // MARK: Stall

    /// A whole market stall (120 × 110): striped awning with scallops, poles, a table with goods.
    /// `variant` awning colour (0 green, 1 red, 2 blue, 3 orange); `accessory` "cheese" | "flowers".
    static func stall(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 120, height: 110))
        let tones: [UInt32] = [0x0F6E56, 0xC8261B, 0x1F3A6B, 0xF2711C]
        let tone = tones[((p.variant ?? 0) % tones.count + tones.count) % tones.count]
        f.oval(2, 103, 116, 7, 0x1E1E1C, 0.14)
        f.rect(10, 34, 100, 32, 0x1E1E1C, 0.1)
        f.rect(9, 26, 4, 80, 0x5E6B73)
        f.rect(107, 26, 4, 80, 0x5E6B73)
        f.svg("M4 22L16 6H104L116 22Z", 0xFFFDF6)
        for i in stride(from: 0, to: 11, by: 2) {
            let x = 4 + CGFloat(i) * 10.2, top = 16 + CGFloat(i) * 8.2
            f.svg("M\(x) 22L\(top) 6H\(top + 8.2)L\(x + 10.2) 22Z", tone)
        }
        f.rect(4, 22, 112, 12, 0xFFFDF6)
        for i in 0..<11 {
            let x = 4 + CGFloat(i) * 10.2
            let c: UInt32 = i % 2 == 0 ? tone : 0xFFFDF6
            f.rect(x, 22, 10.2, 12, c)
            f.svg("M\(x) 34A5.1 4.4 0 0 0 \(x + 10.2) 34Z", c)
        }
        f.rect(6, 64, 108, 6, 0xC9965F)
        f.rect(10, 70, 100, 30, 0x9A6A42)
        f.svgLine("M10 80H110M10 90H110", 0x8A5C38, 1.2)
        if p.accessory == "flowers" { flowers(f) } else { cheese(f) }
    }

    private static func cheese(_ f: PropPen) {
        for (x, y) in [(14.0, 52.0), (14.0, 40.0), (44.0, 52.0)] as [(CGFloat, CGFloat)] {
            f.rect(x, y + 3, 28, 9, 0xE0A93A)
            f.oval(x, y + 7, 28, 9, 0xE0A93A)
            f.oval(x, y - 1, 28, 9, 0xF6D27A)
        }
        f.svg("M76 64L104 64L104 52Q90 46 76 52Z", 0xE0A93A)
        f.svg("M76 52Q90 44 104 52L90 56Z", 0xF6D27A)
        f.rect(90, 52, 14, 12, 0xF6D27A)
        f.dot(96, 59, 1.6, 0xE0A93A)
    }

    private static func flowers(_ f: PropPen) {
        let blooms: [UInt32] = [0xC8261B, 0xFAC775, 0xF2711C, 0xED93B1]
        for i in 0..<4 {
            let x = 16 + CGFloat(i) * 24
            f.svgLine("M\(x + 4) 54L\(x) 40M\(x + 8) 54V38M\(x + 12) 54L\(x + 16) 41", 0x3F5A4A, 1.4)
            for (k, dx) in [0.0, 8, 16].enumerated() { f.dot(x + dx, 40 - (k == 1 ? 2 : 0), 3.6, blooms[(i + k) % 4]) }
            f.svg("M\(x - 1) 52H\(x + 17)L\(x + 15) 64H\(x + 1)Z", 0x5E6B73)
        }
    }

    // MARK: Scale

    /// A shop scale (56 × 64) with a dish of cherries; `text` on its display ("500 g").
    static func scale(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 56, height: 64))
        f.oval(5, 59, 46, 5, 0x1E1E1C, 0.15)
        f.svg("M10 28H46L51 61H5Z", 0xEFEBE2)
        f.svgLine("M10 28H46L51 61H5Z", 0xB4B2A9, 1.2)
        f.rect(9, 36, 38, 17, 0x232B3B, radius: 2.5)
        f.text(p.text ?? "500 g", PropFont.mono(11.5), 0x5DCAA5, at: CGPoint(x: 28, y: 44.5), maxWidth: 34)
        f.rect(26, 20, 4, 9, 0x5E6B73)
        f.svg("M3 14H53Q51 24 28 24Q5 24 3 14Z", 0xD3D1C7)
        f.svgLine("M3 14H53", 0xB4B2A9, 1.6)
        for (x, y) in [(14.0, 11.0), (21.0, 9.0), (28.0, 11.0), (35.0, 8.5), (42.0, 11.0), (18.0, 4.0), (31.0, 3.5)] as [(CGFloat, CGFloat)] {
            f.svgLine("M\(x) \(y - 3)Q\(x + 2) \(y - 8) \(x + 5) \(y - 9)", 0x3F5A4A, 1)
            f.dot(x, y, 4, 0x9B1C1C)
            f.dot(x - 1.2, y - 1.3, 1.1, 0xFFFFFF, 0.5)
        }
    }

    // MARK: Season wheel

    /// A hanging round sign (62 × 64) split into the four seasons, a hand pointing at `highlight`
    /// (0 spring, 1 summer, 2 autumn, 3 winter).
    static func seasonWheel(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 62, height: 64), hanging: true)
        f.line(20, 0, 20, 9, 0x2E2117, 2)
        f.line(42, 0, 42, 9, 0x2E2117, 2)
        let c = CGPoint(x: 31, y: 37)
        f.dot(c.x, c.y, 27, 0x2E2117)
        let fills: [UInt32] = [0xD5E3C3, 0xFAC775, 0xE9B07A, 0xD3E0E6]
        for k in 0..<4 {
            var wedge = Path()
            wedge.move(to: c)
            wedge.addArc(center: c, radius: 24, startAngle: .degrees(Double(k) * 90 - 90), endAngle: .degrees(Double(k) * 90), clockwise: false)
            wedge.closeSubpath()
            f.fill(wedge, fills[k])
        }
        f.svgLine("M7 37H55M31 13V61", 0x2E2117, 1.6)
        let at = { (k: Int) -> CGPoint in
            let a = (Double(k) * 90 - 45) * .pi / 180
            return CGPoint(x: c.x + cos(a) * 14, y: c.y + sin(a) * 14)
        }
        PalaceSeasonIcons.flower(f, at(0))
        PalaceSeasonIcons.sun(f, at(1))
        PalaceSeasonIcons.leaf(f, at(2))
        PalaceSeasonIcons.snowflake(f, at(3))
        let k = ((p.highlight ?? 1) % 4 + 4) % 4
        var ring = Path()
        ring.addArc(center: c, radius: 24.5, startAngle: .degrees(Double(k) * 90 - 88), endAngle: .degrees(Double(k) * 90 - 2), clockwise: false)
        f.stroke(ring, 0xC8261B, 3.2)
    }

    // MARK: Rosette

    /// A prize rosette (56 × 66) hanging on a string: gold pleats, ribbon tails, `count` stars.
    static func rosette(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 56, height: 66), hanging: true)
        f.line(28, 0, 28, 8, 0x2E2117, 1.6)
        f.svg("M21 38L13 64L20 59.5L25.5 65L30 40Z", 0xC8261B)
        f.svg("M35 38L43 64L36 59.5L30.5 65L26 40Z", 0xA51E15)
        let c = CGPoint(x: 28, y: 29)
        for k in 0..<18 {
            let a = Double(k) * .pi / 9
            f.dot(c.x + cos(a) * 18, c.y + sin(a) * 18, 4.6, 0xC9A15B)
        }
        f.dot(c.x, c.y, 18, 0xE0A93A)
        f.dot(c.x, c.y, 13, 0xFFFDF6)
        let n = max(1, min(p.count ?? 3, 3))
        let spots: [(CGFloat, CGFloat, CGFloat)] = n == 1 ? [(0, 0, 8)] : n == 2 ? [(-5, 0, 5.5), (5, 0, 5.5)] : [(-7.5, 2, 4.4), (7.5, 2, 4.4), (0, -2, 6)]
        for (dx, dy, r) in spots { f.fill(star(CGPoint(x: c.x + dx, y: c.y + dy), r), 0xE0A93A) }
    }

    /// A five-pointed star centred on `c`.
    static func star(_ c: CGPoint, _ r: CGFloat) -> Path {
        var p = Path()
        for k in 0..<10 {
            let a = Double(k) * .pi / 5 - .pi / 2
            let rr = k % 2 == 0 ? r : r * 0.45
            let pt = CGPoint(x: c.x + cos(a) * rr, y: c.y + sin(a) * rr)
            if k == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        p.closeSubpath()
        return p
    }
}

/// Small season pictograms for the season wheel, centred on a point (about 12 points across).
enum PalaceSeasonIcons {
    static func flower(_ f: PropPen, _ c: CGPoint) {
        f.line(c.x, c.y + 1, c.x, c.y + 7, 0x3F5A4A, 1.4)
        for k in 0..<5 {
            let a = Double(k) * 2 * .pi / 5 - .pi / 2
            f.dot(c.x + cos(a) * 3.4, c.y - 2 + sin(a) * 3.4, 2.5, 0xC8261B)
        }
        f.dot(c.x, c.y - 2, 1.8, 0xFAC775)
    }

    static func sun(_ f: PropPen, _ c: CGPoint) {
        for k in 0..<8 {
            let a = Double(k) * .pi / 4
            f.line(c.x + cos(a) * 5.5, c.y + sin(a) * 5.5, c.x + cos(a) * 8, c.y + sin(a) * 8, 0xF2711C, 1.5)
        }
        f.dot(c.x, c.y, 4.2, 0xF2711C)
    }

    static func leaf(_ f: PropPen, _ c: CGPoint) {
        f.svg("M\(c.x - 6) \(c.y + 5)C\(c.x - 6) \(c.y - 3) \(c.x) \(c.y - 7) \(c.x + 6) \(c.y - 6)C\(c.x + 6) \(c.y + 1) \(c.x + 1) \(c.y + 6) \(c.x - 6) \(c.y + 5)Z", 0xA3410A)
        f.svgLine("M\(c.x - 6) \(c.y + 5)L\(c.x + 3) \(c.y - 3)", 0xE9B07A, 1)
    }

    static func snowflake(_ f: PropPen, _ c: CGPoint) {
        for k in 0..<3 {
            let a = Double(k) * .pi / 3
            f.line(c.x - cos(a) * 6, c.y - sin(a) * 6, c.x + cos(a) * 6, c.y + sin(a) * 6, 0x2F5BD3, 1.5)
        }
        f.dot(c.x, c.y, 1.5, 0x2F5BD3)
    }
}
