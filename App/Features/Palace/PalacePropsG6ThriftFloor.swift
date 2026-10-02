import SwiftUI

/// Bigger second-hand shop props: a chair being painted, an old-fashioned lamp and phone, someone
/// dropping a box of things into a donation bin, and where the money goes.
enum G6ThriftFloor {
    // MARK: Refurbish

    /// A wooden chair (74 × 118): its left half old, dull and scratched, its right half freshly
    /// painted and shining; a brush on the line between them and a paint pot with drips.
    static func refurbish(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 74, height: 118))
        let old: UInt32 = 0x8C7A66, fresh: UInt32 = 0x1E9C8A
        f.oval(4, 110, 66, 7, 0x1E1E1C, 0.14)
        func chair(_ g: PropPen, _ c: UInt32) {
            g.rect(10, 10, 6, 100, c, radius: 1.5)
            g.rect(52, 10, 6, 100, c, radius: 1.5)
            g.rect(10, 14, 48, 8, c, radius: 1.5)
            g.rect(10, 30, 48, 6, c, radius: 1.5)
            g.rect(6, 58, 58, 9, c, radius: 2)
            g.rect(8, 67, 6, 44, c, radius: 1.5)
            g.rect(56, 67, 6, 44, c, radius: 1.5)
            g.rect(14, 88, 44, 4, c)
        }
        var left = f
        left.ctx.clip(to: Path(CGRect(x: 0, y: 0, width: 34, height: 118)))
        chair(left, old)
        left.svgLine("M11 40L15 52M17 16L25 20M9 74L13 86M18 60L28 65M12 95L10 104M24 31L30 35", 0x4A3A2C, 1.3)
        left.svg("M6 58H12L9 63Z M10 10H14L12 14Z", 0xEFE4CF)
        var right = f
        right.ctx.clip(to: Path(CGRect(x: 34, y: 0, width: 40, height: 118)))
        chair(right, fresh)
        right.rect(36, 59, 26, 2.4, 0xFFFFFF, radius: 1, 0.45)
        right.rect(53.5, 12, 1.6, 96, 0xFFFFFF, radius: 0.8, 0.45)
        G6Props.sparkle(f, 66, 20, 5, 0xFFFDF6)
        G6Props.sparkle(f, 46, 48, 3.5, 0xFAC775)
        // brush on the line
        f.svgLine("M34 30L50 4", 0x8C5E38, 3.4)
        f.svg("M30 30L38 30L36 39L32 39Z", 0xB4B2A9)
        f.svg("M32 39H36L35 44H33Z", fresh)
        // paint pot
        f.svg("M44 96H66L64 114H46Z", 0xB4B2A9)
        f.oval(44, 93, 22, 6, fresh)
        f.svgLine("M47 98V104M58 98V102", fresh, 2)
        f.svgLine("M44 96Q55 84 66 96", 0x5E6B73, 1.2)
    }

    // MARK: Vintage

    /// An old-fashioned lamp with a fringed shade and a dial telephone on a doily (76 × 50).
    static func vintage(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        // doily
        f.oval(4, 44, 68, 7, 0xFFFDF6)
        var scallops = ""
        for x in stride(from: 6.0, to: 70, by: 6) { scallops += "M\(x) 48a3 2 0 1 0 6 0" }
        f.svgLine(scallops, 0xD3D1C7, 0.8)
        // lamp
        f.svg("M14 46Q14 40 20 39Q26 40 26 46Z", 0x7A5230)
        f.svgLine("M20 39V18", 0xC9A15B, 2)
        f.svg("M10 18L14 2H26L30 18Z", 0xC0546B)
        f.svgLine("M14 6H26M12 12H28", 0x8C3048, 1)
        var fringe = ""
        for x in stride(from: 10.5, through: 29.5, by: 2.4) { fringe += "M\(x) 18V23" }
        f.svgLine(fringe, 0xC9A15B, 1)
        // dial phone
        f.svg("M38 46L42 30H66L70 46Z", 0x1E1E1C)
        f.dot(54, 38, 7.5, 0xF4F1EA)
        for k in 0..<10 {
            let a = Double(k) * .pi / 6 - .pi / 2 - 0.4
            f.dot(54 + cos(a) * 5, 38 + sin(a) * 5, 1.2, 0x1E1E1C)
        }
        f.dot(54, 38, 2, 0xC8261B)
        f.svg("M36 28C36 22 40 21 44 22L64 22C68 21 72 22 72 28L68 29C67 26 66 26 64 26H44C42 26 41 26 40 29Z", 0x1E1E1C)
        f.svgLine("M70 44Q76 40 74 30", 0x1E1E1C, 1)
    }

    // MARK: Drop-off

    /// Someone (left) carries a box of old things to a donation bin with a down arrow and `text`
    /// on its sign (110 × 114).
    static func dropOff(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 110, height: 114))
        let v = PalaceFigures.Look.at(p.variant ?? 2)
        // bin
        f.oval(62, 106, 48, 6, 0x1E1E1C, 0.14)
        f.rect(66, 48, 42, 62, 0x0F6E56, radius: 3)
        f.rect(66, 48, 42, 8, 0x0C5A46, radius: 3)
        f.rect(72, 60, 30, 7, 0x1E1E1C)
        f.svg("M78 74H90V82H96L84 94L72 82H78Z", 0xFFFDF6)
        if let text = p.text {
            f.rect(64, 26, 46, 16, 0xFFFDF6, radius: 2)
            f.stroke(Path(roundedRect: CGRect(x: 64, y: 26, width: 46, height: 16), cornerRadius: 2), 0x0F6E56, 1.2)
            f.text(text, PropFont.heavy(10), 0x0F6E56, at: CGPoint(x: 87, y: 34.5), maxWidth: 42)
            f.svgLine("M74 42V48M100 42V48", 0x5E6B73, 1.4)
        }
        G6People.carrying(f.within(CGRect(x: 0, y: 0, width: 72, height: 114)), v)
    }

    // MARK: Proceeds

    /// Where the money goes (76 × 54): a cash box full of coins, an arrow to a heart over two
    /// little houses, `text` (the amount) on top.
    static func proceeds(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 54))
        if let text = p.text {
            f.rect(4, 0, 68, 15, 0xFFFDF6, radius: 2)
            f.stroke(Path(roundedRect: CGRect(x: 4, y: 0, width: 68, height: 15), cornerRadius: 2), 0x1E7A4C, 1)
            f.text(text, PropFont.heavy(10.5), 0x1E7A4C, at: CGPoint(x: 38, y: 8), maxWidth: 64)
        }
        // cash box with coins
        f.svg("M2 36L6 24H30L34 36Z", 0x5E6B73)
        f.rect(2, 36, 32, 16, 0x3E4C55, radius: 1.5)
        for (x, y) in [(10.0, 30.0), (18, 28), (26, 30), (14, 33), (23, 33)] as [(CGFloat, CGFloat)] {
            PalaceShopProps.coin(f, x, y, 3.6)
        }
        G6Props.arrow(f, CGPoint(x: 36, y: 38), CGPoint(x: 48, y: 38), 0x1E7A4C, 2.4)
        // heart over houses
        f.svg("M50 52V42L56 37L62 42V52Z", 0xC98B5E)
        f.svg("M60 52V40L67 34L74 40V52Z", 0x9A5238)
        f.rect(54, 46, 4, 6, 0x2F4B3A)
        f.rect(65, 44, 4, 8, 0x2F4B3A)
        G6Props.heart(f, 62, 26, 6)
    }
}
