import SwiftUI

/// Energy props: the meter cupboard with its counter, twelve months each with a coin, a chart
/// (bars per month or a price that goes up and down), power going from the company to a house.
enum G2EnergyProps {
    // MARK: Meter

    /// A meter cupboard (80 × 110) with its door open: the meter's counter shows `text` (digits, the
    /// last one red) above `caption` (the unit), a blinking light, a row of fuses and a gas pipe.
    static func meter(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 80, height: 110))
        f.oval(6, 104, 70, 6, 0x1E1E1C, 0.15)
        f.rect(10, 4, 66, 104, 0xEFEBE2, radius: 2)
        f.rect(14, 8, 58, 96, 0xC9C4B8)
        f.svg("M10 4L0 10V102L10 108Z", 0xF4F1EA)
        f.svgLine("M10 4L0 10V102L10 108", 0xB4B2A9, 1)
        f.dot(4, 56, 1.6, 0x8C9499)
        // The meter
        f.rect(18, 14, 50, 46, 0xFFFDF6, radius: 3)
        f.stroke(Path(roundedRect: CGRect(x: 18, y: 14, width: 50, height: 46), cornerRadius: 3), 0x8C9499, 1)
        let digits = Array(p.text ?? "00000").map(String.init)
        let cell: CGFloat = min(8.4, 44 / CGFloat(max(1, digits.count)))
        var x = 43 - cell * CGFloat(digits.count) / 2
        f.rect(x - 2, 20, cell * CGFloat(digits.count) + 4, 15, 0x1E1E1C, radius: 1.5)
        for (i, d) in digits.enumerated() {
            let last = i == digits.count - 1
            f.rect(x + 0.6, 21.5, cell - 1.2, 12, last ? 0xC8261B : 0x2E2117, radius: 0.8)
            f.text(d, PropFont.mono(10.5), 0xFFFFFF, at: CGPoint(x: x + cell / 2, y: 27.8))
            x += cell
        }
        if let caption = p.caption {
            f.text(caption, PropFont.heavy(8), 0x1E1E1C, at: CGPoint(x: 43, y: 43), maxWidth: 40)
        }
        f.dot(26, 52, 2.4, 0xC8261B)
        f.dot(26, 52, 4.4, 0xC8261B, 0.25)
        f.rect(34, 50, 26, 4, 0xD3D1C7, radius: 1)
        // Fuses and the gas pipe
        f.rect(18, 66, 50, 16, 0xFFFDF6, radius: 2)
        for k in 0..<5 { f.rect(21 + CGFloat(k) * 9.4, 69, 6, 10, k == 4 ? 0xC8261B : 0x3E4C55, radius: 1) }
        f.svgLine("M24 108V94H60V86", 0xE8B32C, 4)
        f.rect(54, 82, 12, 8, 0xE8B32C, radius: 1.5)
    }

    // MARK: Instalments

    /// A card (100 × 80): twelve little calendar pages in two rows, each with a coin, and under
    /// them the amount `text` in an orange tag with `caption`.
    static func instalments(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 80))
        f.rect(1.5, 3, 98, 77, 0x1E1E1C, radius: 4, 0.14)
        f.rect(0, 0, 98, 76, 0xFFFDF6, radius: 4)
        for i in 0..<12 {
            let x = 6 + CGFloat(i % 6) * 14.6, y = 5 + CGFloat(i / 6) * 19
            f.rect(x, y, 12.6, 16, 0xFFFFFF, radius: 1.2)
            f.stroke(Path(roundedRect: CGRect(x: x, y: y, width: 12.6, height: 16), cornerRadius: 1.2), 0xB4B2A9, 0.8)
            f.rect(x, y, 12.6, 4, 0xC8261B, radius: 1.2)
            f.dot(x + 6.3, y + 10, 4, G2Props.coin)
            f.ring(x + 6.3, y + 10, 2.6, 0xC9A15B, 0.9)
        }
        if let text = p.text {
            let font = PropFont.heavy(12)
            let w = min(80, f.width(of: text, font) + 12)
            f.rect(49 - w / 2, 45, w, 17, 0xF2711C, radius: 4)
            f.text(text, font, 0xFFFFFF, at: CGPoint(x: 49, y: 54), maxWidth: w - 6)
        }
        if let caption = p.caption {
            f.text(caption, PropFont.demi(9.5), 0x5F5E5A, at: CGPoint(x: 49, y: 69.5), maxWidth: 90)
        }
    }

    // MARK: Chart

    /// A chart (100 × 80). `accessory` "bars": a card with twelve monthly bars, high in winter and
    /// low in summer; `icons` [corner mark, over the high bars, over the low bars]; `caption` under.
    /// "zigzag": a dark screen with a price line going up and down, up and down arrows, the latest
    /// price `text` in a tag and `caption` (the unit) in the corner.
    static func chart(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 80))
        let icons = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:))
        if p.accessory == "zigzag" {
            f.rect(0, 0, 100, 78, 0x2E2117, radius: 4)
            f.rect(4, 4, 92, 70, 0x232B3B, radius: 2)
            f.svgLine("M10 24H90M10 44H90M10 64H90", 0x3E4C55, 0.8)
            f.svgLine("M10 50L20 38L28 56L38 30L46 48L56 22L64 52L72 34L80 44", 0xFAC775, 2.2)
            f.svgLine("M88 12V24M84 16L88 11L92 16", 0x5DCAA5, 2)
            f.svgLine("M88 32V44M84 40L88 45L92 40", 0xF27D6A, 2)
            if let caption = p.caption {
                f.text(caption, PropFont.demi(8), 0xD3D1C7, at: CGPoint(x: 10, y: 12), anchor: .leading, maxWidth: 60)
            }
            if let text = p.text {
                let font = PropFont.heavy(9.5)
                let w = min(44, f.width(of: text, font) + 8)
                f.rect(80 - w / 2 - 6, 60, w, 13, 0xFAC775, radius: 3)
                f.text(text, font, 0x1E1E1C, at: CGPoint(x: 74, y: 66.5), maxWidth: w - 4)
            }
            return
        }
        f.rect(1.5, 3, 98, 77, 0x1E1E1C, radius: 4, 0.14)
        f.rect(0, 0, 98, 76, 0xFFFDF6, radius: 4)
        let heights: [CGFloat] = [40, 36, 30, 20, 12, 8, 7, 8, 14, 22, 32, 40]
        for (i, h) in heights.enumerated() {
            let x = 10 + CGFloat(i) * 7
            f.rect(x, 62 - h, 5.2, h, h > 25 ? 0x2F5BD3 : 0xF2B33D, radius: 1)
        }
        f.svgLine("M7 62H93", 0x5F5E5A, 1.4)
        if icons.count > 1 {
            icons[1].draw(f, in: CGRect(x: 10, y: 4, width: 13, height: 13), color: 0x2F5BD3, detail: 0xFFFDF6)
            icons[1].draw(f, in: CGRect(x: 80, y: 4, width: 13, height: 13), color: 0x2F5BD3, detail: 0xFFFDF6)
        }
        if icons.count > 2 { icons[2].draw(f, in: CGRect(x: 42, y: 34, width: 15, height: 15), color: 0xF2711C, detail: 0xFFFDF6) }
        let caption = p.caption ?? ""
        let font = PropFont.demi(9)
        let mark: CGFloat = icons.isEmpty ? 0 : 12
        let cw = min(84 - mark, f.width(of: caption, font))
        let left = 49 - (cw + mark) / 2
        if let corner = icons.first { corner.draw(f, in: CGRect(x: left, y: 64, width: 10, height: 10), color: 0xF2711C, detail: 0xFFFDF6) }
        f.text(caption, font, 0x5F5E5A, at: CGPoint(x: left + mark, y: 69.5), anchor: .leading, maxWidth: 84 - mark)
    }

    // MARK: Supply

    /// Power on its way (110 × 80): a power station with a lightning sign, a pylon, and the
    /// cables to a house whose window lights up; little bolts travel along.
    static func supply(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 110, height: 80))
        f.rect(1.5, 3, 108, 77, 0x1E1E1C, radius: 4, 0.14)
        f.rect(0, 0, 108, 76, 0xE4ECEE, radius: 4)
        f.rect(0, 64, 108, 12, 0xB9C9A8, radius: 2)
        // The company: a hall with a chimney and a big bolt sign
        f.rect(4, 36, 34, 30, 0x5E6B73)
        f.svg("M4 36L14 28L24 36L34 28L38 31V36Z", 0x5E6B73)
        f.rect(28, 16, 6, 16, 0x3E4C55)
        for k in 0..<3 { f.rect(8 + CGFloat(k) * 10, 46, 6, 7, 0xFAC775) }
        f.dot(19, 22, 8.5, 0xF2711C)
        PalaceIcon.g2Bolt.draw(f, in: CGRect(x: 12, y: 15, width: 14, height: 14), color: 0xFFFFFF, detail: 0xF2711C)
        // Pylon
        f.svgLine("M56 66L62 22L68 66M58 52H66M59 40H65M62 22V16M54 26H70M56 34H68", 0x3E4C55, 1.4)
        // House
        f.svg("M78 46L92 34L106 46Z", 0x9A5238)
        f.rect(80, 46, 24, 20, 0xE9DFC9)
        f.rect(85, 51, 7, 7, 0xFAC775)
        f.rect(95, 54, 5, 12, 0x1F3A6B)
        f.dot(88.5, 54.5, 7, 0xFAC775, 0.35)
        // Cables and travelling bolts
        f.svgLine("M38 38Q47 32 55 26M69 26Q78 30 90 40", 0x1E1E1C, 1.1)
        PalaceIcon.g2Bolt.draw(f, in: CGRect(x: 41, y: 22, width: 9, height: 9), color: 0xF2B33D, detail: 0xFFFFFF)
        PalaceIcon.g2Bolt.draw(f, in: CGRect(x: 74, y: 22, width: 9, height: 9), color: 0xF2B33D, detail: 0xFFFFFF)
    }
}
