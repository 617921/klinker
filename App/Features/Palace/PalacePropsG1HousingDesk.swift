import SwiftUI

/// Housing-office things, part two: an objection to a decision letter, neighbours holding hands
/// under one roof, and a screen with a long queue and its waiting time.
enum G1HousingDesk {
    // MARK: Objection

    /// A decision letter (82 × 60) with its red line (`text`, "+ 6 %"), and a hand raised against
    /// it with a speech bubble (`caption`, "Niet eens!").
    static func objection(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 82, height: 60))
        var l = f
        l.ctx.translateBy(x: 24, y: 34)
        l.ctx.rotate(by: .radians(-0.08))
        l.rect(-19, -22, 40, 50, 0x1E1E1C, radius: 1.5, 0.15)
        l.rect(-21, -24, 40, 50, 0xFFFDF6, radius: 1.5)
        l.rect(-21, -24, 40, 9, 0x1F3A6B, radius: 1.5)
        PalaceIcon.house.draw(l, in: CGRect(x: -18, y: -23, width: 7, height: 7), color: 0xFFFDF6, detail: 0x1F3A6B)
        l.svgLine("M-16 -9H14M-16 -4H10M-16 14H12M-16 19H6", 0xD3D1C7, 1.2)
        l.rect(-18, 0, 34, 10, 0xF8E5E3, radius: 1)
        l.text(p.text ?? "+ 6 %", PropFont.heavy(8.5), 0xC8261B, at: CGPoint(x: -1, y: 5.5), maxWidth: 32)
        // The raised hand, palm out
        let skin: UInt32 = 0xC99A74
        f.svg("M58 60L60 44H74L76 60Z", 0x993556)
        f.rect(56, 28, 20, 18, skin, radius: 5)
        for (i, h) in [11.0, 13, 12, 9].enumerated() { f.rect(56.5 + CGFloat(i) * 5, 28 - CGFloat(h) + 3, 4.4, CGFloat(h), skin, radius: 2.2) }
        f.svg("M57 38Q51 34 52 30Q54 28 58 32Z", skin)
        f.svgLine("M60 40H72", PalaceInk.shade(skin, 0.85), 1)
        G1Props.bubble(f, CGRect(x: 30, y: 0, width: 52, height: 13), p.caption ?? "Niet eens!", tail: CGPoint(x: 54, y: 17),
                       font: PropFont.heavy(7.5), ink: 0xC8261B)
    }

    // MARK: Community

    /// A framed poster (96 × 66): four neighbours of all sorts holding hands under one roof, a
    /// heart in the gable.
    static func community(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 66))
        let r = G1BankPosters.frame(f, 96, 66, border: 0x0F6E56)
        f.svgLine("M\(r.minX + 6) \(r.minY + 26)L\(r.midX) \(r.minY + 4)L\(r.maxX - 6) \(r.minY + 26)", 0x0F6E56, 3.4)
        f.svg(heart(cx: r.midX, cy: r.minY + 17, s: 9), 0xC8261B)
        let xs: [CGFloat] = [r.minX + 14, r.minX + 34, r.maxX - 34, r.maxX - 14]
        f.svgLine("M\(xs[0]) \(r.minY + 42)H\(xs[3])", 0x5E6B73, 2.6)
        for (i, x) in xs.enumerated() {
            let v = PalaceFigures.Look.at([0, 1, 3, 6][i])
            let small = i == 2
            let top = r.minY + (small ? 34 : 28)
            f.dot(x, top, small ? 4.4 : 5.4, v.skin)
            f.svg("M\(x - 5.4) \(top - 1)C\(x - 5.4) \(top - 6) \(x + 5.4) \(top - 6) \(x + 5.4) \(top - 1)C\(x + 3) \(top - 3.4) \(x - 3) \(top - 3.4) \(x - 5.4) \(top - 1)Z", v.hair)
            f.svg("M\(x - 6) \(r.maxY - 4)V\(top + 12)Q\(x - 6) \(top + 6) \(x) \(top + 6)Q\(x + 6) \(top + 6) \(x + 6) \(top + 12)V\(r.maxY - 4)Z", v.coat)
        }
    }

    /// A heart path centred on (cx, cy), `s` wide.
    static func heart(cx: CGFloat, cy: CGFloat, s: CGFloat) -> String {
        let h = s / 2
        return "M\(cx) \(cy + h)C\(cx - s) \(cy - h * 0.2) \(cx - h * 0.8) \(cy - h * 1.3) \(cx) \(cy - h * 0.5)C\(cx + h * 0.8) \(cy - h * 1.3) \(cx + s) \(cy - h * 0.2) \(cx) \(cy + h)Z"
    }

    // MARK: Waiting time

    /// A hanging screen (112 × 58): a long queue of little people, the last one lit, a clock and
    /// the waiting time (`text`, "± 8 jaar").
    static func queueScreen(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 58))
        f.line(24, 0, 24, 6, 0x2E2117, 2)
        f.line(88, 0, 88, 6, 0x2E2117, 2)
        f.rect(0, 4, 112, 54, 0x2E2117, radius: 5)
        f.rect(4, 8, 104, 46, 0x232B3B, radius: 2)
        for i in 0..<9 {
            let x = 12 + CGFloat(i) * 10.5
            let last = i == 8
            let c: UInt32 = last ? 0xF2711C : 0x8C9499
            f.dot(x, 15, 3, c)
            f.svg("M\(x - 4) \(28)V\(22)Q\(x - 4) \(19) \(x) \(19)Q\(x + 4) \(19) \(x + 4) \(22)V\(28)Z", c)
        }
        f.svgLine("M10 31H104", 0x3E4C55, 1)
        PalaceIcon.clock.draw(f, in: CGRect(x: 14, y: 34, width: 16, height: 16), color: 0xFAC775, detail: 0x232B3B)
        f.text(p.text ?? "± 8 jaar", PropFont.heavy(13), 0xFAC775, at: CGPoint(x: 66, y: 42.5), maxWidth: 70)
    }
}
