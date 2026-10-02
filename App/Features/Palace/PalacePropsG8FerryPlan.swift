import SwiftUI

/// Planning a trip: a moment on the clock and the day, a board of what it depends on, a map with
/// the long way round, an agenda being filled in, a date moved to later, and a phone that says
/// you will make it.
enum G8FerryPlan {
    // MARK: Moment

    /// A board on legs (90 × 86): a clock showing `time` over a day line (0–24) with a red pin at
    /// that very moment and the time written under it.
    static func moment(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 90, height: 86))
        let time = p.time ?? "23:30"
        let (h, m) = PalaceFigures.parse(time)
        G8Props.shadow(f, 8, 81, 74, 5)
        f.rect(14, 60, 4, 24, 0x5E6B73)
        f.rect(72, 60, 4, 24, 0x5E6B73)
        f.rect(0, 0, 90, 66, 0x1F3A6B, radius: 3)
        f.rect(3, 3, 84, 60, 0xFFFDF6, radius: 2)
        let c = CGPoint(x: 45, y: 22)
        f.dot(c.x, c.y, 16, 0x2E2117)
        f.dot(c.x, c.y, 13.4, 0xFFFDF6)
        for k in 0..<12 {
            let a = Double(k) * .pi / 6
            f.line(c.x + sin(a) * 10.5, c.y - cos(a) * 10.5, c.x + sin(a) * 12.4, c.y - cos(a) * 12.4, 0x2E2117, 1.2)
        }
        let ha = (Double(h % 12) + Double(m) / 60) * .pi / 6, ma = Double(m) * .pi / 30
        f.line(c.x, c.y, c.x + sin(ha) * 7, c.y - cos(ha) * 7, 0x1E1E1C, 2.6)
        f.line(c.x, c.y, c.x + sin(ma) * 10.5, c.y - cos(ma) * 10.5, 0x1E1E1C, 1.8)
        f.dot(c.x, c.y, 1.8, 0x2E2117)
        f.rect(8, 46, 74, 4, 0xD3D1C7, radius: 2)
        for (k, label) in ["0", "6", "12", "18", "24"].enumerated() {
            let x = 8 + CGFloat(k) * 18.5
            f.rect(x - 0.6, 44, 1.2, 8, 0x5E6B73)
            f.text(label, PropFont.mono(6), 0x5E6B73, at: CGPoint(x: x, y: 57))
        }
        let x = 8 + 74 * CGFloat((Double(h) + Double(m) / 60) / 24)
        var dash = Path()
        dash.move(to: CGPoint(x: c.x, y: c.y + 16))
        dash.addLine(to: CGPoint(x: x, y: 40))
        f.ctx.stroke(dash, with: .color(PalaceInk.hex(0xC8261B)), style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
        f.svg("M\(x) 48L\(x - 4) 40A4.4 4.4 0 1 1 \(x + 4) 40Z", 0xC8261B)
        f.dot(x, 38.6, 1.6, 0xFFFDF6)
        let tag = CGRect(x: 58, y: 8, width: 28, height: 12)
        f.rect(tag, 0xC8261B, radius: 2)
        f.text(time, PropFont.heavy(8), 0xFFFDF6, at: CGPoint(x: tag.midX, y: tag.midY + 0.5), maxWidth: tag.width - 3)
    }

    // MARK: Depends on

    /// A board on legs (104 × 84) with two rows: sun → ferry with a green tick, storm → ferry with
    /// a red cross. `icons` [good weather, bad weather, transport].
    static func depends(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 104, height: 84))
        let icons = (p.icons ?? ["sun", "g8Storm", "g8Ferry"]).compactMap(PalaceIcon.init(rawValue:))
        G8Props.shadow(f, 8, 79, 88, 5)
        f.rect(16, 58, 4, 24, 0x5E6B73)
        f.rect(84, 58, 4, 24, 0x5E6B73)
        f.rect(0, 0, 104, 64, 0x1F3A6B, radius: 3)
        f.rect(3, 3, 98, 58, 0xFFFDF6, radius: 2)
        f.rect(8, 31.5, 88, 1, 0xD3D1C7)
        for row in 0..<2 {
            let y = 6 + CGFloat(row) * 28
            if icons.count > row { icons[row].draw(f, in: CGRect(x: 8, y: y, width: 22, height: 22), color: row == 0 ? 0xF2B33D : 0x3E4C55, detail: 0xFFFDF6) }
            G8Props.arrow(f, CGPoint(x: 34, y: y + 11), CGPoint(x: 50, y: y + 11), 0x1E1E1C, 1.8, head: 5)
            if icons.count > 2 { icons[2].draw(f, in: CGRect(x: 54, y: y, width: 22, height: 22), color: 0x1F3A6B, detail: 0xFFFDF6) }
            G8Props.badge(f, 88, y + 11, 7.5, ok: row == 0)
        }
    }

    // MARK: The long way round

    /// A folded paper map (96 × 68): a river between A and B; the short way over a broken bridge
    /// is crossed out red, a long red route goes round by a bridge far upstream.
    static func detourMap(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 68))
        f.rect(2, 2, 96, 66, 0x1E1E1C, radius: 1.5, 0.15)
        f.rect(0, 0, 96, 66, 0xEFE6D2, radius: 1.5)
        f.svgLine("M32 0V66M64 0V66M0 33H96", 0xD9CDB4, 1)
        f.svg("M42 0H54Q50 33 56 66H44Q38 33 42 0Z", 0x8FB6CF)
        f.rect(42, 8, 14, 4, 0x6B4A2E)
        f.svgLine("M16 44H40M58 44H80", 0x9A968C, 2)
        f.svgLine("M41 44H57", 0x9A968C, 2)
        f.svgLine("M44 39L54 49M54 39L44 49", 0xC8261B, 2.6)
        f.svgLine("M16 44C16 14 26 10 49 10C72 10 80 14 80 36", 0xC8261B, 2.4)
        G8Props.head(f, tip: CGPoint(x: 80, y: 42), dx: 0, dy: 1, 7, 0xC8261B)
        let labels = p.labels ?? ["A", "B"]
        for (point, label) in zip([CGPoint(x: 14, y: 50), CGPoint(x: 82, y: 50)], labels) {
            f.dot(point.x, point.y, 7, 0x1E1E1C)
            f.text(label, PropFont.heavy(8.5), 0xFFFDF6, at: CGPoint(x: point.x, y: point.y + 0.5))
        }
    }

    // MARK: Agenda

    /// An open agenda (120 × 58): hours down the right page, a hand writing a new block (with the
    /// first of `icons`) into the empty hour after the one already filled.
    static func agenda(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 120, height: 58))
        let icon = (p.icons ?? ["g8Ferry"]).compactMap(PalaceIcon.init(rawValue:)).first
        f.rect(2, 6, 104, 50, 0x1E1E1C, radius: 2, 0.15)
        f.rect(0, 4, 104, 50, 0x3C3489, radius: 2)
        f.rect(3, 6, 48, 46, 0xFFFDF6)
        f.rect(53, 6, 48, 46, 0xFFFDF6)
        f.svgLine("M8 14H44M8 22H40M8 30H44M8 38H36M8 46H42", 0xD3D1C7, 1.2)
        for (i, hour) in ["8", "9", "10", "11"].enumerated() {
            let y = 9 + CGFloat(i) * 11
            f.text(hour, PropFont.mono(7), 0x5E6B73, at: CGPoint(x: 60, y: y + 4))
            f.rect(66, y + 10, 32, 0.8, 0xD3D1C7)
        }
        f.rect(67, 9.5, 31, 9, 0x2F5BD3, radius: 1.5)
        f.rect(67, 20.5, 26, 9, 0xF2711C, radius: 1.5)
        if let icon { icon.draw(f, in: CGRect(x: 68, y: 20.6, width: 8.8, height: 8.8), color: 0xFFFDF6, detail: 0xF2711C) }
        f.svgLine("M80 25H90", 0xFFFDF6, 1.4)
        f.svgLine("M93 26L112 6", 0x1E1E1C, 3)
        f.svgLine("M93 26L95.5 23", 0xC9A15B, 3)
        f.svg("M104 10C106 6 112 6 114 10L118 18C116 22 110 22 106 18Z", 0xE8C4A0)
        f.svgLine("M114 18L122 28", 0x0F6E56, 8)
    }

    // MARK: Postponed

    /// Two calendar sheets (120 × 58): the first date (`labels`[0]) crossed out red, a curved
    /// arrow to a later date (`labels`[1]) ringed in green; a storm mark under the first one.
    static func postpone(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 120, height: 58))
        let labels = p.labels ?? ["12", "19"]
        for (i, x) in [2.0, 74].enumerated() {
            f.rect(x + 1.5, 6, 44, 50, 0x1E1E1C, radius: 2, 0.15)
            f.rect(x, 4, 44, 50, 0xFFFDF6, radius: 2)
            f.rect(x, 4, 44, 11, 0xC8261B, radius: 2)
            f.dot(x + 12, 4, 2, 0x5E6B73)
            f.dot(x + 32, 4, 2, 0x5E6B73)
            if i < labels.count {
                f.text(labels[i], PropFont.heavy(20), 0x1E1E1C, at: CGPoint(x: x + 22, y: 32), maxWidth: 40)
            }
        }
        f.svgLine("M10 22L40 46M40 22L10 46", 0xC8261B, 3)
        PalaceIcon.g8Storm.draw(f, in: CGRect(x: 18, y: 41, width: 13, height: 13), color: 0x3E4C55, detail: 0xFFFDF6)
        f.ring(96, 32, 15, 0x1E7A4C, 2.4)
        f.svgLine("M48 22Q60 8 70 20", 0x1E1E1C, 2)
        G8Props.head(f, tip: CGPoint(x: 72, y: 23), dx: 0.6, dy: 1, 6, 0x1E1E1C)
    }

    // MARK: Phone in a hand

    /// A phone held sideways in a hand (116 × 60); its dark screen shows `icons` with `labels`
    /// over them and `text`, like a sign.
    static func handPhone(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 116, height: 60))
        f.svgLine("M-4 62L12 46", 0x993556, 12)
        f.oval(4, 34, 22, 20, 0xE8C4A0)
        f.rect(12, 2, 98, 52, 0x1E1E1C, radius: 7)
        f.rect(16, 6, 90, 44, 0x232B3B, radius: 3)
        PalacePanels.content(f, p, in: CGRect(x: 20, y: 8, width: 82, height: 40), tone: .named("dark"))
        f.svg("M14 34C10 30 10 24 14 22L20 24V36Z", 0xE8C4A0)
    }
}
