import SwiftUI

/// Bank pictures that tell a money story: a loan (money out now, small coins back over time), a
/// finance chart, interest (coin stacks growing) and a pile of unpaid bills.
enum G1BankPosters {
    /// A framed white poster filling `size`, returning its inner rect.
    static func frame(_ f: PropPen, _ w: CGFloat, _ h: CGFloat, border: UInt32 = 0x1F3A6B) -> CGRect {
        f.rect(1.5, 2.5, w - 1.5, h - 2.5, 0x1E1E1C, radius: 3, 0.14)
        f.rect(0, 0, w - 1.5, h - 2.5, border, radius: 3)
        let inner = CGRect(x: 3, y: 3, width: w - 7.5, height: h - 8.5)
        f.rect(inner, 0xFFFDF6, radius: 1.5)
        return inner
    }

    // MARK: Loan

    /// A loan (112 × 58): a bundle of notes (`text`) flies from the bank to a car (`accessory`
    /// "house": a house), and little coins go back along a dashed arrow underneath.
    static func loan(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 58))
        _ = frame(f, 112, 58)
        PalaceIcon.townHall.draw(f, in: CGRect(x: 6, y: 9, width: 26, height: 26), color: 0x1F3A6B, detail: 0xFFFDF6)
        if p.accessory == "house" {
            G1Props.house(f, 80, 34, w: 24, 0xD9AE7A)
        } else {
            car(f, x: 76, y: 14)
        }
        f.svgLine("M34 22H70", 0x1E7A4C, 2.6)
        f.svg("M68 17L76 22L68 27Z", 0x1E7A4C)
        G1Props.note(f, 50, 15, w: 22, angle: -0.08, 0x5E8C45)
        G1Props.note(f, 53, 17, w: 22, angle: 0.06, 0x5E8C45)
        f.text(p.text ?? "€ 15.000", PropFont.heavy(8), 0x1E1E1C, at: CGPoint(x: 52, y: 31), maxWidth: 36)
        f.svgLine("M94 44H24", 0xC8261B, 1.8)
        f.svg("M26 40L18 44L26 48Z", 0xC8261B)
        for x in stride(from: 34.0, through: 86, by: 13) { G1Props.coin(f, CGFloat(x), 44, 3.6) }
    }

    /// A small red car seen from the side, its top-left at (x, y), about 30 × 20.
    static func car(_ f: PropPen, x: CGFloat, y: CGFloat) {
        f.svg("M\(x) \(y + 14)V\(y + 10)Q\(x) \(y + 7) \(x + 4) \(y + 7)L\(x + 9) \(y)H\(x + 21)L\(x + 26) \(y + 7)Q\(x + 31) \(y + 7) \(x + 31) \(y + 11)V\(y + 14)Z", 0xC8261B)
        f.svg("M\(x + 10) \(y + 2)H\(x + 15)V\(y + 7)H\(x + 7.5)Z M\(x + 17) \(y + 2)H\(x + 20.5)L\(x + 23.5) \(y + 7)H\(x + 17)Z", 0xBCCDD6)
        f.dot(x + 7, y + 15, 3.6, 0x1E1E1C)
        f.dot(x + 24, y + 15, 3.6, 0x1E1E1C)
        f.dot(x + 7, y + 15, 1.4, 0xB4B2A9)
        f.dot(x + 24, y + 15, 1.4, 0xB4B2A9)
    }

    // MARK: Finance chart

    /// A wall chart (96 × 66): a pie chart with a euro in the middle, rising bars, a calculator.
    static func finance(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 66))
        let r = frame(f, 96, 66, border: 0x3E4C55)
        let c = CGPoint(x: r.minX + 22, y: r.minY + 24)
        let slices: [(Double, Double, UInt32)] = [(0, 0.45, 0x2F5BD3), (0.45, 0.75, 0xF2711C), (0.75, 1, 0x1E7A4C)]
        for (a, b, colour) in slices {
            var slice = Path()
            slice.move(to: c)
            slice.addArc(center: c, radius: 17, startAngle: .radians(a * 2 * .pi - .pi / 2), endAngle: .radians(b * 2 * .pi - .pi / 2), clockwise: false)
            slice.closeSubpath()
            f.fill(slice, colour)
        }
        f.dot(c.x, c.y, 7.5, 0xFFFDF6)
        f.text("€", PropFont.heavy(10), 0x1E1E1C, at: CGPoint(x: c.x, y: c.y + 0.5))
        for (i, h) in [10.0, 17, 24, 31].enumerated() {
            f.rect(r.minX + 48 + CGFloat(i) * 9, r.minY + 42 - CGFloat(h), 6.5, CGFloat(h), [0xB4B2A9, 0x8C9499, 0x2F5BD3, 0x1E7A4C][i], radius: 1)
        }
        f.line(r.minX + 46, r.minY + 42.5, r.maxX - 4, r.minY + 42.5, 0x3E4C55, 1.2)
        // Calculator in front
        f.rect(r.minX + 6, r.maxY - 13, 26, 14, 0x3E4C55, radius: 2)
        f.rect(r.minX + 8, r.maxY - 11, 22, 4, 0xC9E6E2, radius: 0.8)
        for k in 0..<4 { f.rect(r.minX + 8.5 + CGFloat(k) * 5.6, r.maxY - 5.5, 4, 3, 0xD3D1C7, radius: 0.6) }
        G1Props.coin(f, r.minX + 44, r.maxY - 6, 4.4)
        G1Props.coin(f, r.minX + 54, r.maxY - 6, 4.4)
        G1Props.coin(f, r.minX + 49, r.maxY - 9, 4.4)
    }

    // MARK: Interest

    /// A standing poster (76 × 126) on two legs: three coin stacks growing along a curved arrow,
    /// a big red `text` ("2,5 %") and a `caption` ("per jaar") under it.
    static func growth(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 126))
        f.oval(4, 120, 68, 6, 0x1E1E1C, 0.14)
        f.rect(14, 96, 4, 26, 0x3E4C55)
        f.rect(58, 96, 4, 26, 0x3E4C55)
        f.rect(0, 0, 76, 100, 0x3E4C55, radius: 3)
        f.rect(4, 4, 68, 92, 0xFAC775)
        for (i, n) in [2, 4, 6].enumerated() {
            let x = 18 + CGFloat(i) * 20
            for k in 0..<n {
                let y = 52 - CGFloat(k) * 4.2
                f.oval(x - 7, y - 2.4, 14, 5.6, 0xA3780A)
                f.oval(x - 7, y - 3.6, 14, 5.6, 0xE0B94A)
            }
        }
        f.svgLine("M10 34Q30 30 50 16", 0x1E7A4C, 2.6)
        f.svg("M46 12L56 12L52 21Z", 0x1E7A4C)
        f.text(p.text ?? "2,5 %", PropFont.heavy(17), 0xC8261B, at: CGPoint(x: 38, y: 70), maxWidth: 64)
        if let caption = p.caption {
            f.text(caption, PropFont.demi(10), 0x1E1E1C, at: CGPoint(x: 38, y: 86), maxWidth: 64)
        }
    }

    // MARK: Bills

    /// Someone on a chair with their head in their hands (96 × 120) beside a pile of bills with
    /// red stamps; the top bill leans against the pile with a red `text` ("– € 3.200").
    static func bills(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 120))
        let v = PalaceFigures.Look.at(p.variant ?? 4)
        f.oval(2, 113, 92, 6, 0x1E1E1C, 0.15)
        // Chair and the seated person: one hand to the forehead, a sweat drop, a bill in the other hand
        f.svgLine("M8 84V116M38 84V116M8 100H38", 0x2E2117, 2.4)
        f.rect(4, 80, 36, 5, 0x1F3A6B, radius: 1)
        f.svg("M10 82L12 54C13 47 17 44 23 44C29 44 32 47 33 54L36 82Z", v.coat)
        f.svg("M14 76H44Q47 76 47 80V84H14Z", v.trousers)
        f.svgLine("M42 82V110", v.trousers, 6)
        f.svg("M37 108H48Q50 108 50 111V113H37Z", 0x2E2117)
        G1People.head(f, v, mood: "sad", cx: 25, cy: 32)
        f.svgLine("M27 28H34", 0x5E6B73, 1.2)
        f.svgLine("M16 52C14 42 20 30 28 24", PalaceInk.shade(v.coat, 0.82), 5.5)
        f.dot(29, 23, 3.6, v.skin)
        f.svg("M38 20Q41 25 38 28Q35 25 38 20Z", 0x5DCAA5)
        f.svgLine("M30 54C34 62 38 66 44 68", v.coat, 5.5)
        f.dot(45, 68, 3.2, v.skin)
        f.rect(44, 60, 12, 15, 0xFFFDF6, radius: 0.8)
        f.rect(44, 60, 12, 3.5, 0xC8261B)
        // Pile of bills
        for (i, a) in [0.06, -0.05, 0.1, -0.08, 0.04, -0.02].enumerated() {
            var s = f
            s.ctx.translateBy(x: 72, y: 110 - CGFloat(i) * 7)
            s.ctx.rotate(by: .radians(a))
            s.rect(-20, -5, 40, 8, i % 2 == 0 ? 0xFFFDF6 : 0xF4F1EA, radius: 0.8)
            s.stroke(Path(roundedRect: CGRect(x: -20, y: -5, width: 40, height: 8), cornerRadius: 0.8), 0xD3D1C7, 0.6)
            s.rect(-17, -3, 10, 4, 0xC8261B, radius: 0.5, 0.8)
        }
        var top = f
        top.ctx.translateBy(x: 72, y: 50)
        top.ctx.rotate(by: .radians(0.08))
        top.rect(-21, -24, 44, 50, 0x1E1E1C, radius: 1, 0.14)
        top.rect(-22, -26, 44, 50, 0xFFFDF6, radius: 1)
        top.rect(-22, -26, 44, 9, 0xC8261B, radius: 1)
        top.svgLine("M-16 -9H14M-16 -4H8", 0xD3D1C7, 1.2)
        top.text(p.text ?? "– € 3.200", PropFont.heavy(9.5), 0xC8261B, at: CGPoint(x: 0, y: 6), maxWidth: 40)
        top.ring(9, 16, 6.5, 0xC8261B, 1.4)
        top.text("!", PropFont.heavy(9), 0xC8261B, at: CGPoint(x: 9, y: 16.5))
    }
}
