import SwiftUI

/// The church: a calendar page, a memorial with a wreath, a stand of candles, a coffin with
/// flowers and a wedding cake. Kept quiet and plain, in the room's muted colours.
enum G5ChurchProps {
    // MARK: Calendar page

    /// A calendar (fills its frame). `accessory` "tearoff": a tear-off page with a red band
    /// `caption` (month), a big red `text` (the day) and the first of `icons` below it.
    /// "countdown": a month grid with the first days crossed off and one day ringed with the first of
    /// `icons`; `text` a line under the grid.
    static func datePage(_ pen: PropPen, _ p: PalacePropParams) {
        let (w, h) = (pen.size.width, pen.size.height)
        let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first
        pen.rect(2, 3, w - 2, h - 3, 0x1E1E1C, radius: 2, 0.15)
        pen.rect(0, 0, w - 2, h - 3, 0xFFFDF6, radius: 2)
        pen.rect(0, 0, w - 2, 14, 0xC8261B, radius: 2)
        pen.rect(0, 9, w - 2, 5, 0xC8261B)
        pen.text(p.caption ?? "", PropFont.heavy(8), 0xFFFDF6, at: CGPoint(x: w / 2 - 1, y: 7.5), maxWidth: w - 8)
        if p.accessory == "countdown" {
            let cols = 7, rows = 4
            let cell = min((w - 10) / CGFloat(cols), (h - 34) / CGFloat(rows))
            let x0 = (w - 2 - cell * CGFloat(cols)) / 2, y0: CGFloat = 18
            let target = 17
            for k in 0..<(cols * rows) {
                let x = x0 + CGFloat(k % cols) * cell, y = y0 + CGFloat(k / cols) * cell
                pen.rect(x + 1, y + 1, cell - 2, cell - 2, k == target ? 0xFAC775 : 0xEFEBE2, radius: 1)
                if k < target - 3 {
                    pen.svgLine("M\(x + 2.5) \(y + 2.5)L\(x + cell - 2.5) \(y + cell - 2.5)M\(x + cell - 2.5) \(y + 2.5)L\(x + 2.5) \(y + cell - 2.5)", 0xC8261B, 1.2)
                }
                if k == target {
                    pen.ring(x + cell / 2, y + cell / 2, cell * 0.72, 0xC8261B, 1.6)
                    icon?.draw(pen, in: CGRect(x: x + 1.5, y: y + 1.5, width: cell - 3, height: cell - 3), color: 0x2E2117, detail: 0xFAC775)
                }
            }
            if let text = p.text {
                pen.text(text, PropFont.heavy(8.5), 0xC8261B, at: CGPoint(x: w / 2 - 1, y: y0 + cell * CGFloat(rows) + 7), maxWidth: w - 8)
            }
            return
        }
        pen.rect(0, 14, w - 2, 3, 0x2E2117)
        let big = min(h * 0.42, w * 0.5)
        pen.text(p.text ?? "", PropFont.heavy(big), 0xC8261B, at: CGPoint(x: w / 2 - 1, y: 18 + big * 0.6), maxWidth: w - 8)
        if let icon {
            let side = min(h - big - 30, w * 0.4)
            icon.draw(pen, in: CGRect(x: w / 2 - 1 - side / 2, y: h - side - 7, width: side, height: side), color: 0x0F6E56, detail: 0xFFFDF6)
        }
        pen.svg("M\(w - 14) \(h - 3)L\(w - 2) \(h - 15)V\(h - 3)Z", 0xE2DED3)
    }

    // MARK: Memorial

    /// A stone plaque (90 × 120) with `lines` cut in it, a wreath of red and white flowers with
    /// a ribbon (`caption`) leaning below it, and two small candles.
    static func memorial(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 90, height: 120))
        f.rect(8, 2, 74, 50, 0x6B6B66, radius: 2)
        f.rect(11, 5, 68, 44, 0x9A9A92, radius: 1)
        f.svgLine("M30 12Q45 7 60 12", 0x6B6B66, 1.2)
        for (i, line) in (p.lines ?? []).prefix(2).enumerated() {
            f.text(line, PropFont.heavy(i == 0 ? 11 : 8), 0x3E3E3A, at: CGPoint(x: 45, y: 23 + CGFloat(i) * 14), maxWidth: 62)
        }
        let c = CGPoint(x: 45, y: 82)
        f.ring(c.x, c.y, 21, 0x3F6B3A, 9)
        for k in 0..<12 {
            let a = Double(k) * .pi / 6
            f.dot(c.x + cos(a) * 21, c.y + sin(a) * 21, 3.4, k % 2 == 0 ? 0xC8261B : 0xFFFDF6)
        }
        f.svg("M37 98L32 118L38 114L41 100Z M53 98L58 118L52 114L49 100Z", 0xC8261B)
        f.svg("M38 96H52V104H38Z", 0xFFFDF6)
        f.svg("M38 101H52V104H38Z", 0x1F3A6B)
        if let caption = p.caption {
            f.text(caption, PropFont.heavy(5.5), 0xC8261B, at: CGPoint(x: 45, y: 98.6), maxWidth: 13)
        }
        for x in [8.0, 82] as [CGFloat] {
            f.rect(x - 4, 104, 8, 14, 0xFFFDF6, radius: 1)
            f.svg("M\(x) 96Q\(x + 3) 100 \(x) 103Q\(x - 3) 100 \(x) 96Z", 0xF2B33D)
            f.dot(x, 100, 6, 0xFAC775, 0.25)
        }
    }

    // MARK: Candles

    /// An iron stand of small candles in three tiers (80 × 110), most of them lit, and a hand lighting
    /// one more with a long match.
    static func candles(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 80, height: 110))
        f.svgLine("M14 108L22 80M66 108L58 80M40 80V108", 0x3E3A36, 2.4)
        let tiers: [(y: CGFloat, x0: CGFloat, n: Int)] = [(46, 28, 3), (62, 18, 5), (78, 8, 7)]
        for (t, tier) in tiers.enumerated() {
            f.rect(tier.x0 - 4, tier.y, CGFloat(tier.n) * 10 + 4, 3, 0x3E3A36, radius: 1)
            for i in 0..<tier.n {
                let x = tier.x0 + CGFloat(i) * 10 + 1
                f.rect(x - 3.4, tier.y - 6, 6.8, 6, 0xFFFDF6, radius: 1)
                let lit = (i + t) % 5 != 3
                if lit {
                    f.dot(x, tier.y - 11, 5.5, 0xFAC775, 0.22)
                    f.svg("M\(x) \(tier.y - 15)Q\(x + 2.6) \(tier.y - 10.5) \(x) \(tier.y - 7.5)Q\(x - 2.6) \(tier.y - 10.5) \(x) \(tier.y - 15)Z", 0xF2B33D)
                }
            }
        }
        f.svgLine("M76 20L50 36", 0xC9965F, 1.6)
        f.svg("M48.6 32.6Q52 35 49.6 39.6Q46 37 48.6 32.6Z", 0xF2711C)
        f.svg("M70 14Q78 12 80 20L79 26Q74 27 70 22Z", 0xE8C4A0)
    }

    // MARK: Coffin

    /// A wooden coffin on a draped stand (110 × 80) under a spray of white flowers, a framed photo
    /// on a small easel and a tall candle beside it.
    static func coffin(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 110, height: 80))
        f.oval(4, 74, 100, 6, 0x1E1E1C, 0.12)
        f.svgLine("M20 58V77M78 58V77", 0x3E3A36, 3)
        f.rect(14, 54, 72, 8, 0x5E4A6B)
        f.svg("M10 30L18 24H80L88 30V52L80 56H18L10 52Z", 0x7A5230)
        f.svg("M10 30L18 24H80L88 30Z", 0x8C6440)
        f.svgLine("M10 38H88", 0x5E3E24, 1)
        f.rect(40, 42, 6, 3, 0xC9A15B, radius: 1)
        f.rect(56, 42, 6, 3, 0xC9A15B, radius: 1)
        f.svg("M28 24Q30 14 40 16Q48 10 56 16Q66 14 70 24Z", 0x5E8C45)
        for (x, y) in [(36.0, 17.0), (44, 13), (52, 14), (60, 18), (48, 19), (40, 21), (57, 22)] as [(CGFloat, CGFloat)] {
            f.dot(x, y, 3.4, 0xFFFDF6)
            f.dot(x, y, 1.1, 0xFAC775)
        }
        f.svgLine("M98 40L94 76M98 40L104 76", 0x6B4A2E, 1.6)
        f.rect(90, 24, 16, 20, 0x2E2117, radius: 1)
        f.rect(92, 26, 12, 16, 0xD3E0E6)
        f.dot(98, 32, 3, 0xC99A74)
        f.svg("M93 42Q98 34 103 42Z", 0x5E6B73)
        f.rect(1, 36, 6, 40, 0xFFFDF6, radius: 1)
        f.svg("M4 27Q7 31 4 35Q1 31 4 27Z", 0xF2B33D)
        f.dot(4, 31, 6, 0xFAC775, 0.25)
    }

    // MARK: Wedding cake

    /// A three-tier wedding cake (90 × 100) with a tiny couple on top, on a table with a white cloth,
    /// two glasses clinking and confetti.
    static func cake(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 90, height: 100))
        for (x, y, c) in [(6.0, 14.0, 0xE0607A), (82, 10, 0xFAC775), (12, 40, 0x5DCAA5), (78, 34, 0xE0607A), (24, 6, 0x2F5BD3), (66, 4, 0x5DCAA5)] as [(CGFloat, CGFloat, UInt32)] {
            f.rect(x, y, 3.4, 3.4, c, radius: 0.8)
        }
        f.svg("M4 66H86L82 98H8Z", 0xFFFDF6)
        f.svg("M4 66H86V72Q75 76 64 72Q54 76 45 72Q36 76 26 72Q15 76 4 72Z", 0xEFEBE2)
        f.rect(22, 48, 40, 18, 0xFFFDF6, radius: 2)
        f.rect(27, 34, 30, 15, 0xFFFDF6, radius: 2)
        f.rect(32, 22, 20, 13, 0xFFFDF6, radius: 2)
        for (y, x0, x1) in [(48.0, 22.0, 62.0), (34, 27, 57), (22, 32, 52)] as [(CGFloat, CGFloat, CGFloat)] {
            f.stroke(Path(roundedRect: CGRect(x: x0, y: y, width: x1 - x0, height: 4), cornerRadius: 2), 0xF4C0D1, 1.6)
        }
        f.dot(38, 10, 3, 0xE8C4A0)
        f.svg("M35 22L36 13H40L41 22Z", 0x2E2117)
        f.dot(46, 10, 3, 0xC99A74)
        f.svg("M43 22L44.5 13H47.5L49 22Z", 0xFFFDF6)
        f.stroke(PalaceSVG.path("M43 22L44.5 13H47.5L49 22Z"), 0xD3D1C7, 0.8)
        for (x, a) in [(70.0, -0.2), (80, 0.2)] as [(CGFloat, Double)] {
            var g = f.within(CGRect(x: x, y: 44, width: 10, height: 22))
            g.ctx.rotate(by: .radians(a))
            g.svg("M0 0H8L6 8H2Z", 0xFAC775, 0.9)
            g.stroke(PalaceSVG.path("M0 0H8L6 8H2Z"), 0xB4B2A9, 0.8)
            g.line(4, 8, 4, 18, 0xB4B2A9, 1.2)
            g.line(1, 18, 7, 18, 0xB4B2A9, 1.4)
        }
        G5Props.sparkle(f, 78, 38, 4)
    }
}
