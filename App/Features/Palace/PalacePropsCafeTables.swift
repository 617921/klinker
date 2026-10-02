import SwiftUI

/// Café tables that tell a little story: drinks and snacks at a high table, two friends
/// toasting by candlelight.
enum PalaceCafeTables {
    // MARK: High table

    /// A high table in a white stretch cover (96 × 122) with a plate of bitterballen,
    /// a dish of mustard and two beers.
    static func snackTable(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 122))
        f.oval(14, 116, 68, 6, 0x1E1E1C, 0.16)
        f.svg("M12 50Q48 58 84 50L56 84Q66 100 74 119H22Q30 100 40 84Z", 0xF4F1EA)
        f.svg("M48 56Q66 54 84 50L56 84Q62 96 68 110Q56 96 52 84Z", 0xD9D6CC)
        f.rect(38, 81, 20, 5, 0xC8261B, radius: 2)
        f.oval(10, 43, 76, 12, 0xD9D6CC)
        f.oval(10, 41, 76, 11, 0xFFFDF6)
        f.oval(14, 37, 44, 10, 0xD3D1C7)
        f.oval(15, 36, 42, 9, 0xFFFDF6)
        f.oval(44, 37, 11, 5, 0xE8B32C)
        for (x, y) in [(22.0, 39.5), (30, 41), (38, 39), (26, 36), (34, 35.5)] as [(CGFloat, CGFloat)] {
            f.line(x + 1, y - 3, x + 3, y - 10, 0xE8C99A, 1)
            f.dot(x, y, 4, 0x8A4E1C)
            f.dot(x - 1.2, y - 1.4, 1.4, 0xC9803A)
        }
        beer(f, x: 60, top: 14, bottom: 47)
        beer(f, x: 72, top: 19, bottom: 48)
    }

    private static func beer(_ f: PropPen, x: CGFloat, top: CGFloat, bottom: CGFloat) {
        f.svg("M\(x) \(top + 4)H\(x + 10)L\(x + 9) \(bottom)H\(x + 1)Z", 0xF2B33D)
        f.rect(x - 0.5, top, 11, 5, 0xFFFDF6, radius: 2.4)
        f.svg("M\(x + 1.5) \(top + 6)H\(x + 3)L\(x + 3) \(bottom - 2)H\(x + 2.4)Z", 0xFFFFFF, 0.4)
    }

    // MARK: Candle table

    /// Two friends at a small table with a rug on it (132 × 112), raising their glasses over a
    /// candle in a bottle, warm light around them.
    static func candleTable(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 132, height: 112))
        f.dot(66, 46, 40, 0xFAC775, 0.22)
        f.dot(66, 46, 24, 0xFAC775, 0.25)
        f.oval(18, 104, 96, 7, 0x1E1E1C, 0.16)
        friend(f, x: 20, facingRight: true, coat: 0x0F6E56, skin: 0xE8C4A0, hair: 0x7A5230, drink: 0xF2B33D)
        friend(f, x: 112, facingRight: false, coat: 0xC8261B, skin: 0x8C5A3C, hair: 0x1E1E1C, drink: 0xA3263A)
        // Table with a rug
        f.svg("M34 72H98L102 102H30Z", 0x993556)
        f.svgLine("M33 96H99", 0xF6D27A, 1.6)
        f.svgLine("M35 78L39 84L43 78L47 84L51 78L55 84L59 78L63 84L67 78L71 84L75 78L79 84L83 78L87 84L91 78L95 84", 0xF6D27A, 1.2)
        f.oval(32, 66, 68, 11, 0xB23C66)
        f.oval(40, 68, 52, 6, 0x993556)
        f.svgLine("M33 102V106M38 102V106M43 102V106M89 102V106M94 102V106M99 102V106", 0xF6D27A, 1)
        // Candle in a bottle
        f.svg("M62 52H70V58C74 60 75 64 75 70H57C57 64 58 60 62 58Z", 0x2F4B3A)
        f.rect(63.5, 42, 5, 11, 0xFFFDF6, radius: 1)
        f.svg("M62 52Q61 57 63 60Q64 56 65 53Z M69 52Q71 56 69.5 61Q68 57 67.5 53Z", 0xFFFDF6)
        f.svg("M66 30C68.5 34 69.5 37 69 39C68.4 41.5 63.6 41.5 63 39C62.5 37 63.5 34 66 30Z", 0xF2711C)
        f.svg("M66 34C67.2 36 67.6 37.5 67.2 38.6C66.8 39.6 65.2 39.6 64.8 38.6C64.4 37.5 64.8 36 66 34Z", 0xFAC775)
        // The clink
        f.svgLine("M60 4L58 0M66 3V-1M72 4L74 0", 0xF2711C, 1.4)
    }

    /// A seated friend raising a glass towards the middle of the table.
    private static func friend(_ f: PropPen, x: CGFloat, facingRight: Bool, coat: UInt32, skin: UInt32, hair: UInt32, drink: UInt32) {
        let s: CGFloat = facingRight ? 1 : -1
        func px(_ dx: CGFloat) -> CGFloat { x + s * dx }
        f.rect(min(px(-16), px(-10)), 52, 6, 52, 0x4A3524, radius: 1.5)
        f.svgLine("M\(px(-4)) 86L\(px(10)) 88L\(px(12)) 104", 0x3E4C55, 6)
        f.svg("M\(px(-12)) 90L\(px(-11)) 60C\(px(-10)) 52 \(px(-6)) 48 \(px(0)) 48C\(px(6)) 48 \(px(10)) 52 \(px(11)) 60L\(px(12)) 90Z", coat)
        f.dot(x, 36, 10.5, skin)
        f.svg("M\(px(-10.5)) 35C\(px(-11)) 27 \(px(-6)) 23.5 \(px(0)) 23.5C\(px(6)) 23.5 \(px(11)) 27 \(px(10.5)) 34C\(px(7)) 30 \(px(3)) 29 \(px(-2)) 29.5C\(px(-6)) 30 \(px(-9)) 32 \(px(-10.5)) 35Z", hair)
        f.svgLine("M\(px(2)) 35Q\(px(4)) 33 \(px(6)) 35", 0x2E2117, 1.3)
        f.svgLine("M\(px(1)) 40Q\(px(5)) 44 \(px(9)) 40", 0x2E2117, 1.4)
        f.svgLine("M\(px(7)) 56C\(px(18)) 50 \(px(26)) 36 \(px(30)) 22", coat, 6)
        f.dot(px(31), 20, 3.4, skin)
        let gx = px(34) - (facingRight ? 0 : 9)
        if drink == 0xF2B33D {
            f.svg("M\(gx) 2H\(gx + 9)L\(gx + 8) 22H\(gx + 1)Z", drink)
            f.rect(gx - 0.4, 0, 9.8, 4, 0xFFFDF6, radius: 1.8)
        } else {
            f.svg("M\(gx - 1) 1H\(gx + 10)Q\(gx + 10) 13 \(gx + 4.5) 13Q\(gx - 1) 13 \(gx - 1) 1Z", 0xE9F1F4)
            f.svg("M\(gx - 0.6) 5H\(gx + 9.6)Q\(gx + 9) 12.4 \(gx + 4.5) 12.4Q\(gx) 12.4 \(gx - 0.6) 5Z", drink)
            f.svgLine("M\(gx + 4.5) 13V21M\(gx + 1) 21.5H\(gx + 8)", 0xE9F1F4, 1.4)
        }
    }
}
