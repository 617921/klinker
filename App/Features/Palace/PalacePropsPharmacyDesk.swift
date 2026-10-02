import SwiftUI

/// Pharmacy props, part two: the insurance card, the money coming back, the open rack and the
/// empty breakfast plate.
extension PalacePharmacy {
    /// An insurance card held in a hand (76 × 54): an umbrella over a heart, a name (`text`) and a
    /// number (`caption`).
    static func insuranceCard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 54))
        f.oval(6, 50, 60, 4, 0x1E1E1C, 0.12)
        var c = f
        c.ctx.translateBy(x: 36, y: 26)
        c.ctx.rotate(by: .radians(-0.12))
        c.rect(-29, -17, 60, 36, 0x1E1E1C, radius: 3, 0.15)
        c.rect(-30, -19, 60, 36, 0xFFFDF6, radius: 3)
        c.rect(-30, -19, 60, 8, 0x1F3A6B, radius: 3)
        c.rect(-30, -14, 60, 3, 0x1F3A6B)
        c.svg("M-26 0A11 9 0 0 1 -4 0Q-6.75 -2.4 -9.5 0Q-12.25 -2.4 -15 0Q-17.75 -2.4 -20.5 0Q-23.25 -2.4 -26 0Z", 0x0F6E56)
        c.svgLine("M-15 -9V-11", 0x0F6E56, 1.4)
        c.svg("M-15 13C-21 8.5 -21 4 -18 3C-16.5 2.6 -15.5 3.5 -15 4.5C-14.5 3.5 -13.5 2.6 -12 3C-9 4 -9 8.5 -15 13Z", 0xC8261B)
        c.text(p.text ?? "", PropFont.demi(7), 0x1E1E1C, at: CGPoint(x: 0, y: 0), anchor: .leading, maxWidth: 28)
        c.text(p.caption ?? "", PropFont.mono(6), 0x5E6B73, at: CGPoint(x: 0, y: 8), anchor: .leading, maxWidth: 28)
        PalaceShopProps.reach(f, from: CGPoint(x: 80, y: 58), to: CGPoint(x: 62, y: 42), sleeve: 0x5E6B73)
        f.line(61, 41, 56, 37.5, 0xE8C4A0, 3.4)
    }

    /// A bill (`text`, the amount) with coins flying back along a green arrow into an open hand,
    /// `caption` over the arrow (84 × 56).
    static func refundSlip(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 56))
        f.rect(5, 6, 36, 46, 0x1E1E1C, radius: 1.5, 0.12)
        f.rect(3, 4, 36, 46, 0xFFFDF6, radius: 1.5)
        f.svg("M8 14A6 5 0 0 1 20 14Q17 12.5 14 14Q11 12.5 8 14Z", 0x0F6E56)
        f.svgLine("M24 10H35M24 14H32M8 22H34M8 27H30M8 32H34", 0xB4B2A9, 1.1)
        f.svgLine("M8 37.5H34", 0x3E4C55, 0.8)
        f.text(p.text ?? "€ 30,00", PropFont.heavy(8.5), 0x1E1E1C, at: CGPoint(x: 21, y: 43.5), maxWidth: 32)
        f.svgLine("M38 20C48 6 64 6 70 26", 0x1E7A4C, 2.6)
        f.svgLine("M65 23L70.5 28L73.5 21.5", 0x1E7A4C, 2.6)
        if let caption = p.caption {
            f.text(caption, PropFont.heavy(9), 0x1E7A4C, at: CGPoint(x: 55, y: 3.5), maxWidth: 30)
        }
        PalaceShopProps.reach(f, from: CGPoint(x: 90, y: 60), to: CGPoint(x: 70, y: 47), sleeve: 0x1F3A6B)
        f.svg("M58 46C58 42 64 41 72 42C76 42.5 78 44 76 46C72 48 62 48 58 46Z", 0xE8C4A0)
        PalaceShopProps.coin(f, 66, 41, 5)
        PalaceShopProps.coin(f, 72, 34, 4.5)
        PalaceShopProps.coin(f, 52, 12, 4)
    }

    /// An open rack with boxes (92 × 166), a sign on top (`text`, two lines) and a hand taking a box.
    static func otcRack(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 92, height: 166))
        f.oval(4, 160, 84, 6, 0x1E1E1C, 0.15)
        f.rect(12, 34, 66, 126, 0xEFEBE2)
        f.rect(8, 34, 5, 128, 0xD3D1C7)
        f.rect(77, 34, 5, 128, 0xD3D1C7)
        let colors: [UInt32] = [0xC8261B, 0x2F5BD3, 0x0F6E56, 0xF2711C, 0x3C3489, 0xFAC775]
        for (r, y) in [66.0, 102, 138].enumerated() {
            for i in 0..<5 where !(r == 1 && i == 4) {
                let h: CGFloat = [22, 18, 24, 20, 22][(i + r) % 5]
                let x = 15 + CGFloat(i) * 12.4
                f.rect(x, y - h, 11, h, 0xFFFDF6)
                f.rect(x, y - h + 3, 11, 5, colors[(i + r * 2) % colors.count])
            }
            f.rect(6, y, 78, 5, 0xB4B2A9)
            f.rect(6, y + 5, 78, 2, 0x1E1E1C, 0.1)
        }
        f.rect(6, 154, 78, 8, 0xB4B2A9)
        PalaceShopProps.reach(f, from: CGPoint(x: 98, y: 96), to: CGPoint(x: 84, y: 86), sleeve: 0xF2711C, skin: 0xC99A74)
        var box = f
        box.ctx.translateBy(x: 74, y: 84)
        box.ctx.rotate(by: .radians(0.18))
        box.rect(-8, -12, 16, 24, 0x1E1E1C, radius: 1, 0.15)
        box.rect(-9, -13, 16, 24, 0xFFFDF6, radius: 1)
        box.rect(-9, -9, 16, 6, 0xC8261B)
        box.svgLine("M-6 3H4M-6 6.5H2", 0xB4B2A9, 1)
        f.dot(83, 85, 3.8, 0xC99A74)
        f.line(80, 81, 77, 80, 0xC99A74, 2.6)
        f.rect(2, 4, 88, 30, 0x1E7A4C, radius: 3)
        f.stroke(Path(roundedRect: CGRect(x: 5, y: 7, width: 82, height: 24), cornerRadius: 2), 0xE1F5EE, 1)
        let words = (p.text ?? "").split(separator: " ").map(String.init)
        for (i, word) in words.prefix(2).enumerated() {
            f.text(word, PropFont.heavy(10.5), 0xFFFFFF,
                   at: CGPoint(x: 46, y: words.count > 1 ? 13.5 + CGFloat(i) * 11 : 19), maxWidth: 76)
        }
    }

    /// A small table with an empty plate, knife and fork, an alarm clock (`time`, "7:00") and a
    /// card with a crossed-out slice of bread (82 × 98).
    static func breakfastTable(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 82, height: 98))
        f.oval(18, 92, 46, 6, 0x1E1E1C, 0.16)
        f.oval(26, 89, 30, 6, 0x6B4A2E)
        f.rect(38, 56, 6, 35, 0x8C5E38)
        f.oval(2, 50, 78, 12, 0x8C5E38)
        f.oval(2, 48, 78, 12, 0xC9965F)
        f.oval(14, 46, 40, 11, 0xD3D1C7)
        f.oval(14, 45, 40, 10, 0xFFFDF6)
        f.oval(21, 47, 26, 6, 0xEFEBE2)
        f.svgLine("M9 56V47M7.5 47V44M9 47V44M10.5 47V44", 0x8E9AA0, 1.4)
        f.svgLine("M59 56V44", 0x8E9AA0, 2)
        f.dot(62, 33, 3, 0xC8261B)
        f.dot(76, 33, 3, 0xC8261B)
        f.svgLine("M64 48L62 52M74 48L76 52", 0x2E2117, 1.6)
        f.dot(69, 39, 10, 0xC8261B)
        f.dot(69, 39, 8, 0xFFFDF6)
        let (hour, minute) = PalaceFigures.parse(p.time ?? "7:00")
        let c = CGPoint(x: 69, y: 39)
        for (deg, len, width) in [((Double(hour % 12) + Double(minute) / 60) * 30, 4.6, 1.8), (Double(minute) * 6, 6.4, 1.3)] {
            let a = deg * .pi / 180
            f.line(c.x, c.y, c.x + sin(a) * len, c.y - cos(a) * len, 0x1E1E1C, width)
        }
        f.dot(c.x, c.y, 1.1, 0x1E1E1C)
        f.svg("M10 30L16 6H44L50 30Z", 0xFFFDF6)
        f.svgLine("M10 30L16 6H44L50 30Z", 0xD3D1C7, 1)
        f.svg("M22 27V16C22 12 25 10 28 10H32C35 10 38 12 38 16V27Z", 0xC98A45)
        f.svg("M24 26V16.5C24 13.5 26 12 28.5 12H31.5C34 12 36 13.5 36 16.5V26Z", 0xF3DFB4)
        f.ring(30, 18.5, 10, 0xC8261B, 2.2)
        f.line(23, 25.5, 37, 11.5, 0xC8261B, 2.2)
    }
}
