import SwiftUI

/// Supermarket props, part two: the bottle-return machine, a full trolley and packs.
extension PalaceGrocer {
    /// The bottle-return machine (92 × 166): a bottle pushed into the round hole, the money on its
    /// screen (`text`), a ticket coming out and a crate of empties at its foot.
    static func bottleReturn(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 92, height: 166))
        f.oval(2, 160, 88, 6, 0x1E1E1C, 0.15)
        f.rect(8, 4, 72, 158, 0xDCE3DF, radius: 4)
        f.rect(8, 4, 3, 158, 0xEFF3F1)
        f.rect(8, 4, 72, 14, 0x0F6E56, radius: 4)
        f.rect(8, 14, 72, 4, 0x0F6E56)
        f.rect(8, 150, 72, 12, 0x5E6B73, radius: 2)
        f.rect(17, 26, 54, 32, 0x232B3B, radius: 3)
        f.text(p.text ?? "€ 0,25", PropFont.mono(12), 0x5DCAA5, at: CGPoint(x: 44, y: 36), maxWidth: 48)
        f.svgLine("M36 49A8 5 0 0 1 52 49M52 49A8 5 0 0 1 36 49", 0x5DCAA5, 1.6)
        f.svgLine("M49.5 46.5L52.5 49L55 46.5M38.5 51.5L36 49L33.5 51.5", 0x5DCAA5, 1.4)
        f.dot(44, 84, 17, 0x8E9AA0)
        f.dot(44, 84, 12.5, 0x1E1E1C)
        f.svg("M48 79.5H56C58 76 62 75 66 75H90V93H66C62 93 58 92 56 88.5H48Z", 0x1E7A4C, 0.9)
        f.svg("M66 77H88V81H66Z", 0xFFFFFF, 0.25)
        f.rect(72, 79, 12, 10, 0xFAC775, radius: 1)
        PalaceShopProps.reach(f, from: CGPoint(x: 96, y: 112), to: CGPoint(x: 82, y: 94), sleeve: 0xC8261B)
        f.rect(26, 112, 36, 4, 0x3E4C55, radius: 1)
        f.svg("M31 115H57V134L54 136L51 134L48 136L45 134L42 136L39 134L36 136L33 134L31 136Z", 0xFFFDF6)
        f.svgLine("M35 121H53M35 125H49", 0xB4B2A9, 1)
        PalaceShopProps.coin(f, 51, 129, 3.6)
        f.rect(10, 140, 46, 22, 0xC8261B, radius: 2)
        for x in [16.0, 26, 36, 46] {
            f.rect(x - 2.5, 128, 5, 14, 0x1E7A4C, 0.85)
            f.rect(x - 1.5, 125, 3, 4, 0x3E4C55)
        }
        f.rect(10, 140, 46, 22, 0xC8261B, radius: 2)
        f.rect(16, 146, 34, 4, 0x8C1A12, radius: 2)
    }

    /// A shopping trolley piled with groceries (76 × 76).
    static func shoppingCart(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 76))
        f.oval(8, 71, 62, 5, 0x1E1E1C, 0.15)
        f.svgLine("M18 34L30 4", 0xD9A05B, 6.5)
        f.svgLine("M21 26l4 -2M24 18l4 -2M27 11l3.5 -2", 0xE8C98E, 1.2)
        f.svgLine("M46 34L56 8", 0xEFEBE2, 5)
        f.svgLine("M54 13L59 0M56 14L64 4", 0x4E7A3A, 4)
        f.rect(31, 12, 13, 22, 0xFFFDF6)
        f.svg("M31 12L34 7H41L44 12Z", 0xEFEBE2)
        f.rect(31, 18, 13, 7, 0x2F5BD3)
        f.rect(57, 14, 14, 20, 0xC8261B)
        f.rect(59, 20, 10, 6, 0xFAC775)
        PalaceGrocer.produce(f, "apple", 15, 30, 5)
        PalaceGrocer.produce(f, "orange", 47, 31, 4.5)
        f.svg("M6 22H74L66 52H14Z", 0x8E9AA0, 0.28)
        var grid = ""
        for i in 1..<6 {
            let t = CGFloat(i) / 6
            grid += "M\(6 + 68 * t) 22L\(14 + 52 * t) 52"
        }
        grid += "M8 30H72M10.5 38H70M12.5 45H68"
        f.svgLine(grid, 0x8E9AA0, 1)
        f.svgLine("M6 22H74L66 52H14Z", 0x5E6B73, 2)
        f.svgLine("M6 22L2 14", 0x5E6B73, 2)
        f.svgLine("M0 13H8", 0xC8261B, 4)
        f.svgLine("M16 52L18 64M64 52L62 64M14 64H66", 0x5E6B73, 2.2)
        f.dot(20, 68, 4, 0x1E1E1C)
        f.dot(60, 68, 4, 0x1E1E1C)
        f.dot(20, 68, 1.4, 0xB4B2A9)
        f.dot(60, 68, 1.4, 0xB4B2A9)
    }

    /// A milk carton and a loupe over its date (76 × 50): `caption` ("THT") above the circled
    /// date (`text`).
    static func datedPack(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        f.oval(2, 47, 40, 3, 0x1E1E1C, 0.14)
        f.svg("M6 16L11 6H29L34 16Z", 0xEFEBE2)
        f.rect(18, 2, 6, 5, 0xEFEBE2)
        f.rect(6, 16, 28, 34, 0xFFFDF6)
        f.rect(6, 21, 28, 10, 0x2F5BD3)
        f.svg("M20 23C17.5 26.5 17 28 20 29.5C23 28 22.5 26.5 20 23Z", 0xFFFDF6)
        f.rect(10, 38, 20, 7, 0xEFEBE2)
        f.svgLine("M12 41.5H27", 0x5E6B73, 1.4)
        f.svgLine("M30 38L41 30M30 45L44 38", 0xB4B2A9, 0.8)
        f.line(65, 34, 73, 46, 0x3E4C55, 5.5)
        f.dot(55, 21, 18, 0xFFFDF6)
        f.ring(55, 21, 18, 0x3E4C55, 3.5)
        f.text(p.caption ?? "", PropFont.demi(7), 0x5E6B73, at: CGPoint(x: 55, y: 13))
        f.text(p.text ?? "12-10", PropFont.heavy(10), 0x1E1E1C, at: CGPoint(x: 55, y: 24), maxWidth: 28)
        f.stroke(Path(ellipseIn: CGRect(x: 40, y: 17, width: 30, height: 14)), 0xC8261B, 1.8)
    }

    /// Far too much packaging (76 × 50): an open box, bubble wrap and a tray with one small biscuit.
    static func overPacked(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        f.oval(4, 46, 68, 4, 0x1E1E1C, 0.14)
        f.svg("M14 24L18 9H58L62 24Z", 0xA87A48)
        for (x, y) in [(20.0, 20.0), (29, 17), (38, 19), (47, 17), (56, 20), (24, 12), (34, 10), (43, 11), (52, 13)] as [(CGFloat, CGFloat)] {
            f.dot(x, y, 5.2, 0xCFE3EC)
            f.ring(x, y, 5.2, 0xA9CBE0, 0.8)
            f.dot(x - 1.6, y - 1.6, 1.4, 0xFFFFFF, 0.9)
        }
        f.svg("M27 8H49L47 13H29Z", 0xFFFDF6)
        f.svgLine("M27 8H49L47 13H29Z", 0xD3D1C7, 0.8)
        f.dot(38, 6.5, 4.5, 0xC98A45)
        f.dot(36.5, 5.5, 0.9, 0x4A3524)
        f.dot(39.5, 7.5, 0.9, 0x4A3524)
        f.svg("M10 24L0 31L4 36L10 29Z", 0xB98450)
        f.svg("M66 24L76 30L72 35L66 29Z", 0xB98450)
        f.rect(10, 24, 56, 26, 0xC9965F)
        f.rect(10, 24, 56, 3, 0xB98450)
        f.rect(33, 24, 10, 26, 0xE2C49A, 0.85)
        f.svgLine("M17 44V35M14 38L17 35L20 38M25 44V35M22 38L25 35L28 38", 0x7A5230, 1.3)
    }
}
