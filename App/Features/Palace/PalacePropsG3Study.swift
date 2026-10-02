import SwiftUI

/// Study things: a lecture in a lecture hall, a bound thesis, a failed paper with a second try, and
/// a staircase of language levels.
enum G3Study {
    typealias Look = PalaceFigures.Look

    // MARK: Lecture

    /// A lecture (132 × 100): a projection screen with a chart, the lecturer at a lectern pointing
    /// at it, `time` on a clock, and the first row of students seen from behind, some with laptops.
    static func lecture(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 132, height: 100))
        // Screen
        f.rect(2, 0, 92, 4, 0x3E4C55, radius: 2)
        f.rect(6, 5, 86, 58, 0x1E1E1C, radius: 1, 0.14)
        f.rect(4, 3, 86, 58, 0xFFFDF6)
        f.rect(10, 9, 44, 5, 0x1F3A6B, radius: 1)
        f.svgLine("M10 19H38M10 24H32", 0xD3D1C7, 1.6)
        for (i, h) in ([12.0, 20, 28, 36] as [CGFloat]).enumerated() {
            f.rect(46 + CGFloat(i) * 10, 56 - h, 7, h, [0x2F5BD3, 0x5DCAA5, 0xF2711C, 0xC8261B][i])
        }
        f.svgLine("M10 53L20 45L28 49L40 34", 0x3C3489, 1.8)
        f.svgLine("M8 56H88", 0x5E6B73, 1)
        if let time = p.time {
            f.rect(102, 0, 28, 13, 0x2E2117, radius: 2)
            f.text(time, PropFont.mono(8.5), 0xFAC775, at: CGPoint(x: 116, y: 6.8), maxWidth: 25)
        }
        // Lecturer at the lectern, pointing at the chart
        let v = Look.at(p.variant ?? 4)
        f.svg("M104 62L105 46C105.5 41 108 38 112 38C116 38 118.5 41 119 46L120 62Z", v.coat)
        f.dot(112, 29, 8, v.skin)
        f.svg("M104 28C104 22 107.5 20 112 20C116.5 20 120 22 120 27C117.5 24.5 115 24 112 24C108.5 24 106 25.5 104 28Z", v.hair)
        f.dot(108.5, 29.5, 1.1, 0x2E2117)
        f.svgLine("M106 44L96 36", v.coat, 5)
        f.dot(95, 35.5, 2.6, v.skin)
        f.svgLine("M94 35L70 27", 0x7A5230, 1.4)
        f.svg("M98 60H128L124 100H102Z", 0x9A6A42)
        f.rect(96, 57, 34, 5, 0xC9965F, radius: 1)
        f.rect(109, 72, 8, 8, 0xFAC775, radius: 1)
        // The first row of students, from behind
        f.rect(0, 92, 96, 8, 0xC9965F, radius: 1)
        for i in 0..<4 {
            let x = 13 + CGFloat(i) * 23
            let s = Look.at(i * 3 + 1)
            f.svg("M\(x - 10) 93Q\(x - 10) 78 \(x) 78Q\(x + 10) 78 \(x + 10) 93Z", s.coat)
            f.dot(x, 71, 7, s.hair)
            if i % 2 == 0 {
                f.rect(x - 7, 86, 14, 7, 0x3E4C55, radius: 1)
                f.rect(x - 5.5, 87.5, 11, 4, 0xA9CBE0, radius: 0.5)
            }
        }
    }

    // MARK: Thesis

    /// A thick bound thesis on a desk (92 × 72): `text` title and `caption` on the navy cover, a
    /// ring binding, a stack of pages, and behind it a draft with red corrections.
    static func thesis(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 92, height: 72))
        var draft = f
        draft.ctx.translateBy(x: 62, y: 30)
        draft.ctx.rotate(by: .degrees(8))
        draft.rect(-22, -30, 44, 56, 0xFFFDF6, radius: 1)
        draft.stroke(Path(CGRect(x: -22, y: -30, width: 44, height: 56)), 0xD3D1C7, 0.8)
        draft.svgLine("M-17 -22H16M-17 -16H14M-17 -10H17M-17 -4H10M-17 2H15", 0xD3D1C7, 1.3)
        draft.svgLine("M-18 -17Q-6 -13 6 -17M9 -6C14 -10 18 -4 13 -1M-15 8L-6 14M-6 8L-15 14", 0xC8261B, 1.2)
        // The bound copy: a stack of pages under a navy cover
        f.rect(8, 56, 62, 10, 0xEFEBE2, radius: 1)
        f.svgLine("M10 59H68M10 62H68", 0xD3D1C7, 0.8)
        f.rect(6, 12, 62, 46, 0x1E1E1C, radius: 2, 0.16)
        f.rect(4, 10, 62, 46, 0x1F3A6B, radius: 2)
        for y in stride(from: 13.0, through: 52, by: 5) { f.ring(7, CGFloat(y), 1.8, 0x9A9890, 1.2) }
        PalaceIcon.cap.draw(f, in: CGRect(x: 29, y: 13, width: 14, height: 14), color: 0xFAC775, detail: 0x1F3A6B)
        if let text = p.text {
            f.text(text, PropFont.heavy(8), 0xFFFDF6, at: CGPoint(x: 37, y: 35), maxWidth: 52)
        }
        if let caption = p.caption {
            f.text(caption, PropFont.demi(6), 0xA9CBE0, at: CGPoint(x: 37, y: 45), maxWidth: 52)
        }
        f.svgLine("M18 50H56", 0xFAC775, 0.8)
    }

    // MARK: Second try

    /// A failed paper with a red `text` grade and a cross, a curved arrow round to a fresh copy of
    /// the paper headed `caption` (a new date), a pencil on it (96 × 70).
    static func retry(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 70))
        var old = f
        old.ctx.translateBy(x: 24, y: 40)
        old.ctx.rotate(by: .degrees(-6))
        old.rect(-20, -27, 40, 52, 0xFFFDF6, radius: 1)
        old.stroke(Path(CGRect(x: -20, y: -27, width: 40, height: 52)), 0xD3D1C7, 0.8)
        old.svgLine("M-15 -19H5M-15 -12H10M-15 -5H8", 0xD3D1C7, 1.3)
        if let text = p.text {
            old.ring(2, 10, 11, 0xC8261B, 1.6)
            old.text(text, PropFont.heavy(10), 0xC8261B, at: CGPoint(x: 2, y: 10.5), maxWidth: 19)
        }
        old.svgLine("M10 -24L18 -16M18 -24L10 -16", 0xC8261B, 1.8)
        // The arrow round to the second go
        f.svgLine("M30 10C40 -2 56 -2 62 10", 0x1E7A4C, 2.2)
        f.svg("M66 14L57.5 11L64 5Z", 0x1E7A4C)
        f.rect(52, 18, 40, 50, 0x1E1E1C, radius: 1, 0.14)
        f.rect(50, 16, 40, 50, 0xFFFDF6, radius: 1)
        f.rect(50, 16, 40, 9, 0x1E7A4C, radius: 1)
        if let caption = p.caption {
            f.text(caption, PropFont.heavy(6.5), 0xFFFDF6, at: CGPoint(x: 70, y: 20.8), maxWidth: 36)
        }
        for k in 0..<4 {
            let y = 31 + CGFloat(k) * 8
            f.svgLine("M54 \(y)H76", 0xD3D1C7, 1.3)
            f.stroke(Path(CGRect(x: 80, y: y - 3, width: 6, height: 6)), 0x5E6B73, 0.8)
        }
        f.line(70, 64, 92, 46, 0xFAC775, 3.2)
        f.line(70, 64, 72.4, 62, 0xE8C4A0, 3.2)
        f.line(69, 64.8, 70.2, 63.8, 0x1E1E1C, 1.5)
    }

    // MARK: Levels

    /// A staircase of levels (104 × 82): one step per `labels` entry ("A1" … "C1"), a person
    /// standing on step `highlight` with a little flag.
    static func levels(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 104, height: 82))
        let labels = p.labels ?? ["A1", "A2", "B1", "B2", "C1"]
        let n = CGFloat(max(1, labels.count))
        let w = 100 / n, rise: CGFloat = 54 / n
        let colours: [UInt32] = [0xA9CBE0, 0x5DCAA5, 0xFAC775, 0xF2711C, 0xC8261B, 0x3C3489]
        f.oval(0, 77, 104, 5, 0x1E1E1C, 0.14)
        for (i, label) in labels.enumerated() {
            let x = 2 + CGFloat(i) * w, top = 78 - rise * CGFloat(i + 1)
            f.rect(x, top, w, 78 - top, colours[i % colours.count])
            f.rect(x, top, w, 3, PalaceInk.shade(colours[i % colours.count], 0.8))
            f.text(label, PropFont.heavy(9), 0x1E1E1C, at: CGPoint(x: x + w / 2, y: top + 11), maxWidth: w - 2)
        }
        guard let i = p.highlight, i < labels.count else { return }
        let x = 2 + CGFloat(i) * w + w / 2, top = 78 - rise * CGFloat(i + 1)
        let v = Look.at(p.variant ?? 5)
        let m = f.within(CGRect(x: x - 8, y: top - 30, width: 16, height: 30), unit: 0.5)
        PalaceFigures.mini(m, v, walking: false, briefcase: false)
        f.svgLine("M\(x + 6) \(top - 1)V\(top - 24)", 0x3E4C55, 1.2)
        f.svg("M\(x + 6) \(top - 24)L\(x + 15) \(top - 20.5)L\(x + 6) \(top - 17)Z", 0xC8261B)
    }
}
