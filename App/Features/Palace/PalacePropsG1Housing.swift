import SwiftUI

/// Housing-office things: an open window letting air through, mould in a corner, a pipe being
/// fixed, a home advert being answered, two homes compared on price, an objection to a letter,
/// neighbours under one roof and a waiting-time screen.
enum G1Housing {
    // MARK: Open window

    /// A window in the wall (94 × 92), its right half swung open, blue air streaming in and out.
    static func openWindow(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 94, height: 92))
        f.rect(10, 4, 74, 80, 0xFFFDF6, radius: 2)
        f.rect(14, 8, 66, 72, 0xBCCDD6)
        f.rect(14, 56, 66, 24, 0xD3E0E6)
        f.oval(50, 50, 30, 18, 0x7FA35B)
        f.rect(14, 8, 33, 72, 0xA9C0CC)
        f.svg("M18 76L32 12H38L24 76Z", 0xFFFFFF, 0.35)
        f.rect(45, 8, 4, 72, 0xFFFDF6)
        // The open half, swung into the room
        f.svg("M49 8L76 2V88L49 80Z", 0xFFFDF6)
        f.svg("M53 13L72 9V81L53 76Z", 0xC9DCE4)
        f.svg("M56 70L66 14H70L60 72Z", 0xFFFFFF, 0.4)
        f.rect(4, 84, 86, 6, 0xEFEBE2, radius: 1)
        // Air
        f.svgLine("M0 26Q10 20 20 26T40 26", 0x2F7FC1, 2.4)
        f.svg("M38 21L46 26L38 31Z", 0x2F7FC1)
        f.svgLine("M2 44Q12 38 22 44T42 44", 0x2F7FC1, 2.4)
        f.svg("M40 39L48 44L40 49Z", 0x2F7FC1)
        f.svgLine("M94 60Q86 54 78 60", 0x8C9499, 2)
        f.svg("M80 55L72 60L80 65Z", 0x8C9499)
    }

    // MARK: Mould

    /// A tiled corner (94 × 66) with a damp stain and black and green spots spreading from it.
    static func mould(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 94, height: 66))
        f.rect(0, 0, 94, 66, 0xF4F1EA, radius: 2)
        var grid = ""
        for x in stride(from: 15.6, to: 94, by: 15.6) { grid += "M\(x) 0V66" }
        for y in stride(from: 16.5, to: 66, by: 16.5) { grid += "M0 \(y)H94" }
        f.svgLine(grid, 0xD3D1C7, 1)
        f.svg("M0 0H70C66 12 58 18 46 22C34 26 26 36 22 50C18 58 8 62 0 64Z", 0xD9D2B4, 0.75)
        let spots: [(CGFloat, CGFloat, CGFloat, UInt32)] = [
            (6, 6, 5, 0x2E2117), (16, 4, 3.6, 0x3E4C55), (10, 16, 4.4, 0x4F5B3A), (24, 10, 3, 0x2E2117),
            (4, 28, 3.6, 0x2E2117), (20, 22, 2.6, 0x4F5B3A), (34, 6, 2.8, 0x3E4C55), (14, 34, 2.4, 0x2E2117),
            (30, 18, 2, 0x2E2117), (42, 10, 2, 0x4F5B3A), (6, 42, 2.4, 0x3E4C55), (26, 30, 1.8, 0x2E2117),
            (50, 6, 1.6, 0x2E2117), (12, 50, 1.8, 0x4F5B3A), (38, 22, 1.4, 0x3E4C55), (2, 18, 2.6, 0x4F5B3A),
        ]
        for (x, y, r, c) in spots {
            f.dot(x, y, r, c, 0.85)
            f.dot(x + r * 0.9, y + r * 0.5, r * 0.55, c, 0.7)
        }
    }

    // MARK: Repair

    /// A sink with a dripping pipe (96 × 100): a wrench turns the nut, a spark of "fixed", a
    /// toolbox on the floor.
    static func repair(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 100))
        f.oval(4, 94, 88, 6, 0x1E1E1C, 0.15)
        f.svg("M8 20H80L74 38H14Z", 0xF4F1EA)
        f.rect(6, 16, 76, 6, 0xFFFDF6, radius: 2)
        f.svgLine("M60 16V6H50", 0xB4B2A9, 3.4)
        f.svgLine("M44 38V54Q44 62 52 62H58Q64 62 64 70V94", 0xB4B2A9, 6)
        f.rect(38, 46, 12, 8, 0x8C9499, radius: 1.5)
        f.svg("M46 58Q49 63 46 66Q43 63 46 58Z", 0x2F7FC1)
        // The wrench on the nut
        var w = f
        w.ctx.translateBy(x: 44, y: 50)
        w.ctx.rotate(by: .radians(-0.5))
        w.rect(4, -3, 34, 6, 0xC8261B, radius: 3)
        w.svg("M-8 -8H4V-3H0V3H4V8H-8Z", 0x5E6B73)
        f.svg(PalacePeople.star(cx: 30, cy: 46, r: 5), 0xFAC775)
        // Toolbox
        f.rect(8, 72, 40, 22, 0xC8261B, radius: 2)
        f.rect(8, 72, 40, 6, 0xA3200F, radius: 2)
        f.svgLine("M20 72V66H36V72", 0x3E4C55, 2.4)
        f.rect(25, 80, 6, 5, 0xC9A15B, radius: 1)
    }

    // MARK: Home advert

    /// A screen (110 × 74, hanging) with a home for rent: a picture of a house, the details
    /// (`lines`), and a hand pointer clicking the green button with a tick and `text`.
    /// `accessory` "compare": two homes side by side instead, the dear one (`lines[0]`) crossed
    /// out in red, the cheap one (`lines[1]`) ticked green (a framed poster).
    static func homeAd(_ pen: PropPen, _ p: PalacePropParams) {
        if p.accessory == "compare" { return compare(pen, p) }
        let f = pen.fitted(CGSize(width: 110, height: 74))
        f.line(22, 0, 22, 8, 0x2E2117, 2)
        f.line(88, 0, 88, 8, 0x2E2117, 2)
        f.rect(0, 6, 110, 68, 0x2E2117, radius: 5)
        f.rect(4, 10, 102, 60, 0xFFFDF6, radius: 2)
        f.rect(8, 14, 40, 32, 0xBCCDD6, radius: 1.5)
        f.rect(8, 38, 40, 8, 0x7FA35B)
        G1Props.house(f, 15, 42, w: 26, 0xD9AE7A)
        var y: CGFloat = 19
        for line in (p.lines ?? []).prefix(2) {
            f.text(line, PropFont.heavy(9.5), 0x1E1E1C, at: CGPoint(x: 53, y: y), anchor: .leading, maxWidth: 50)
            y += 13
        }
        f.rect(52, 48, 50, 16, 0x1E7A4C, radius: 4)
        G1Props.tick(f, 61, 56, 5, 0x0F5A44)
        f.text(p.text ?? "Ja!", PropFont.heavy(9.5), 0xFFFDF6, at: CGPoint(x: 82, y: 56.5), maxWidth: 30)
        // Hand pointer clicking
        f.svg("M84 60V72Q84 76 88 76H96Q100 76 100 72V66Q100 63 97 63H94V58Q94 55 91 55Q88 55 88 58V60Z", 0xFFFDF6)
        f.svgLine("M84 60V72Q84 76 88 76H96Q100 76 100 72V66Q100 63 97 63H94V58Q94 55 91 55Q88 55 88 58V64", 0x1E1E1C, 1.2)
        f.svgLine("M80 50L77 47M86 48V44M92 50L95 47", 0xF2711C, 1.4)
    }

    private static func compare(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 58))
        _ = G1BankPosters.frame(f, 112, 58, border: 0x0F6E56)
        let prices = p.lines ?? ["€ 1.850", "€ 640"]
        for (i, x) in [8.0, 60].enumerated() {
            let good = i == 1
            f.rect(x, 7, 44, 42, good ? 0xE6F2EC : 0xF8E5E3, radius: 2)
            if good {
                G1Props.house(f, x + 10, 30, w: 22, 0xD9AE7A)
            } else {
                G1Props.house(f, x + 4, 30, w: 34, 0xB4B2A9, roof: 0x3E4C55)
                f.rect(x + 18, 4, 4, 8, 0x3E4C55)
            }
            if i < prices.count {
                f.text(prices[i], PropFont.heavy(10), good ? 0x1E7A4C : 0xC8261B, at: CGPoint(x: x + 22, y: 40), maxWidth: 40)
            }
            if good {
                G1Props.tick(f, x + 39, 12, 6.5)
            } else {
                f.line(x + 4, 40, x + 40, 40, 0xC8261B, 1.8)
                G1Props.cross(f, x + 38, 12, 4.5)
            }
        }
    }
}
