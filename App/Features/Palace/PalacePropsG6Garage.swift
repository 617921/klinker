import SwiftUI

/// Garage props: a Dutch yellow licence plate, a car battery, an inspection report with a stamp,
/// a sign of stars and a handshake, and a round inspection seal.
enum G6Garage {
    // MARK: Licence plate

    /// A yellow plate with a blue band and `text`. `mount` "screen": on a monitor on a little desk
    /// (64 × 120), else the plate alone, filling its frame.
    static func plate(_ pen: PropPen, _ p: PalacePropParams) {
        guard p.mount == "screen" else {
            let f = pen.fitted(CGSize(width: 104, height: 24))
            plateFace(f, CGRect(x: 0, y: 0, width: 104, height: 24), text: p.text ?? "")
            return
        }
        let f = pen.fitted(CGSize(width: 64, height: 120))
        f.oval(2, 114, 60, 6, 0x1E1E1C, 0.14)
        // desk
        f.rect(0, 66, 64, 6, 0x8C5E38, radius: 1)
        f.rect(4, 72, 5, 46, 0x6B4A2E)
        f.rect(55, 72, 5, 46, 0x6B4A2E)
        f.rect(36, 72, 22, 30, 0x9A6A42, radius: 1)
        f.svgLine("M42 84H52", 0xC9A15B, 2)
        // monitor
        f.rect(28, 52, 8, 14, 0x3E4C55)
        f.rect(20, 62, 24, 4, 0x3E4C55, radius: 1)
        f.rect(0, 6, 64, 48, 0x1E1E1C, radius: 3)
        f.rect(3, 9, 58, 42, 0xE4ECEE, radius: 1)
        plateFace(f, CGRect(x: 6, y: 14, width: 52, height: 14), text: p.text ?? "")
        f.svgLine("M8 35H44M8 40H38M8 45H48", 0xB4B2A9, 1.6)
        f.rect(46, 36, 10, 8, 0x1E7A4C, radius: 1.5)
        // keyboard and a hand typing
        f.rect(6, 60, 22, 5, 0xD3D1C7, radius: 1)
        f.dot(17, 59, 3, 0xC99A74)
    }

    private static func plateFace(_ f: PropPen, _ r: CGRect, text: String) {
        f.rect(r, 0xF2C230, radius: r.height * 0.14)
        f.stroke(Path(roundedRect: r.insetBy(dx: 0.8, dy: 0.8), cornerRadius: r.height * 0.12), 0x1E1E1C, r.height * 0.05)
        let band = CGRect(x: r.minX, y: r.minY, width: r.height * 0.55, height: r.height)
        f.rect(band, 0x2F5BD3, radius: r.height * 0.14)
        f.ring(band.midX, band.minY + r.height * 0.32, r.height * 0.16, 0xFAC775, r.height * 0.05)
        f.text("NL", PropFont.heavy(r.height * 0.28), 0xFFFFFF, at: CGPoint(x: band.midX, y: band.minY + r.height * 0.75))
        f.text(text, PropFont.heavy(r.height * 0.72), 0x1E1E1C, at: CGPoint(x: band.maxX + (r.maxX - band.maxX) / 2, y: r.midY + 0.5),
               maxWidth: r.maxX - band.maxX - r.height * 0.3)
    }

    // MARK: Battery

    /// A car battery (70 × 74): + and − posts with red and black jump leads clipped on, a
    /// lightning bolt and a charge mark with one red bar left.
    static func battery(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 70, height: 74))
        f.oval(2, 68, 66, 6, 0x1E1E1C, 0.18)
        f.rect(4, 30, 62, 42, 0x2E3A42, radius: 3)
        f.rect(4, 26, 62, 8, 0x3E4C55, radius: 2)
        f.rect(12, 20, 10, 7, 0xC8261B, radius: 1)
        f.rect(48, 20, 10, 7, 0x1E1E1C, radius: 1)
        f.text("+", PropFont.heavy(12), 0xC8261B, at: CGPoint(x: 17, y: 40))
        f.text("−", PropFont.heavy(12), 0xF4F1EA, at: CGPoint(x: 53, y: 40))
        // jump leads
        f.svgLine("M17 20C14 6 4 4 0 8", 0xC8261B, 2.6)
        f.svgLine("M53 20C56 6 66 4 70 8", 0x1E1E1C, 2.6)
        f.svg("M12 18L22 18L20 23H14Z", 0xC8261B)
        f.svg("M48 18L58 18L56 23H50Z", 0x3E4C55)
        // charge mark: almost empty
        f.rect(20, 50, 26, 13, 0xFFFDF6, radius: 2)
        f.rect(46, 54, 3, 5, 0xFFFDF6, radius: 0.8)
        f.rect(22.5, 52.5, 5, 8, 0xC8261B, radius: 0.8)
        f.svg("M37 47L31 57H36L33 66L42 54H37L40 47Z", 0xFAC775)
    }

    // MARK: Verdict

    /// An inspection report on a clipboard (70 × 78): rows "item|ok" (green tick) or "item|no"
    /// (red cross), then a big stamp — `accessory` "reject" (red cross) or "pass" (green tick).
    static func verdict(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 70, height: 78))
        f.rect(4, 6, 64, 72, 0x1E1E1C, radius: 3, 0.14)
        f.rect(2, 4, 64, 72, 0x8C5E38, radius: 3)
        f.rect(6, 12, 56, 60, 0xFFFDF6)
        f.rect(24, 1, 20, 8, 0x8A8A82, radius: 2)
        f.rect(8, 14, 52, 7, 0x1F3A6B, radius: 1)
        for (i, row) in (p.lines ?? []).prefix(4).enumerated() {
            let y = 28 + CGFloat(i) * 10
            let cells = row.split(separator: "|", omittingEmptySubsequences: false).map(String.init)
            f.text(cells[0], PropFont.demi(7.5), 0x1E1E1C, at: CGPoint(x: 10, y: y), anchor: .leading, maxWidth: 34)
            if cells.count > 1, cells[1] == "no" {
                f.svgLine("M50 \(y - 3)L56 \(y + 3)M56 \(y - 3)L50 \(y + 3)", 0xC8261B, 1.8)
            } else {
                f.svgLine("M49 \(y)L52 \(y + 3)L57 \(y - 3)", 0x1E7A4C, 1.8)
            }
        }
        let pass = p.accessory == "pass"
        let ink: UInt32 = pass ? 0x1E7A4C : 0xC8261B
        var stamp = f
        stamp.ctx.translateBy(x: 40, y: 58)
        stamp.ctx.rotate(by: .radians(-0.25))
        stamp.ctx.opacity = 0.9
        stamp.ring(0, 0, 15, ink, 2.6)
        if pass {
            stamp.svgLine("M-8 0L-2 6L9 -7", ink, 4)
        } else {
            stamp.svgLine("M-8 -8L8 8M8 -8L-8 8", ink, 4)
        }
    }

    // MARK: Rating sign

    /// A sign (120 × 54): a picture (`icons` first) in a circle, `count` stars, `text` in big
    /// letters and `caption` under it.
    static func rating(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 120, height: 54))
        f.rect(2, 3, 118, 51, 0x1E1E1C, radius: 4, 0.15)
        f.rect(0, 0, 118, 50, 0x24533F, radius: 4)
        f.stroke(Path(roundedRect: CGRect(x: 3, y: 3, width: 112, height: 44), cornerRadius: 3), 0xFAC775, 1)
        f.dot(25, 25, 17, 0xFFFDF6)
        if let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first {
            icon.draw(f, in: CGRect(x: 12, y: 12, width: 26, height: 26), color: 0x24533F, detail: 0xFFFDF6)
        }
        let n = max(0, min(5, p.count ?? 5))
        for i in 0..<5 {
            G6Props.star(f, 54 + CGFloat(i) * 13, 15, 6, i < n ? 0xFAC775 : 0x5E8C72)
        }
        if let text = p.text { f.text(text, PropFont.heavy(11), 0xFFFDF6, at: CGPoint(x: 80, y: 31), maxWidth: 70) }
        if let caption = p.caption { f.text(caption, PropFont.demi(8), 0xFAC775, at: CGPoint(x: 80, y: 42), maxWidth: 70) }
    }

    // MARK: Inspection seal

    /// A round seal (70 × 78): a car with a green tick on a blue disc, two ribbons and a band
    /// with `text`.
    static func badge(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 70, height: 78))
        f.svg("M20 44L12 76L24 70L30 78L34 50Z M50 44L58 76L46 70L40 78L36 50Z", 0xC8261B)
        var edge = ""
        for k in 0..<24 {
            let a = Double(k) * .pi / 12
            let r: Double = k % 2 == 0 ? 33 : 29.5
            edge += (k == 0 ? "M" : "L") + String(format: "%.1f %.1f", 35 + cos(a) * r, 34 + sin(a) * r)
        }
        f.svg(edge + "Z", 0xFAC775)
        f.dot(35, 34, 26, 0x1F3A6B)
        f.ring(35, 34, 23, 0xFFFDF6, 1)
        G6Cars.body(f.within(CGRect(x: 15, y: 22, width: 40, height: 18.3), unit: 40 / 140), 0xFFFDF6)
        f.dot(48, 22, 7, 0x1E7A4C)
        f.svgLine("M44.5 22L47 24.5L51.5 19.5", 0xFFFDF6, 1.8)
        guard let text = p.text else { return }
        f.rect(6, 46, 58, 14, 0xFFFDF6, radius: 2)
        f.stroke(Path(roundedRect: CGRect(x: 6, y: 46, width: 58, height: 14), cornerRadius: 2), 0x1F3A6B, 1)
        f.text(text, PropFont.heavy(9), 0x1F3A6B, at: CGPoint(x: 35, y: 53.5), maxWidth: 54)
    }
}
