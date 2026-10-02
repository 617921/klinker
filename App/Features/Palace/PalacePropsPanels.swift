import SwiftUI

/// Flat props with lettering: departure board, sign, screen, route map and poster.
/// Each one fills the frame it gets, so the same prop works at different sizes.
enum PalacePanels {
    // MARK: Board

    /// A departure board: rows "time|destination|tag", the tag in a red box ("+10").
    static func board(_ pen: PropPen, _ p: PalacePropParams) {
        let panel = mount(pen, p, default: "hang")
        pen.rect(panel, 0x1E1E1C, radius: 3)
        let screen = panel.insetBy(dx: 3, dy: 3)
        pen.rect(screen, 0x1F3A6B, radius: 1)
        let rows = Array((p.lines ?? []).prefix(4))
        guard !rows.isEmpty else { return }
        let rowH = screen.height / CGFloat(rows.count)
        let timeW = pen.width(of: "00:00", PropFont.mono(10)) + 8
        for (i, row) in rows.enumerated() {
            let top = screen.minY + CGFloat(i) * rowH
            let mid = top + rowH / 2
            if i == p.highlight { pen.rect(screen.minX, top, screen.width, rowH, 0x2B4C86) }
            if i > 0 { pen.line(screen.minX + 3, top, screen.maxX - 3, top, 0x2B4C86, 1, round: false) }
            let cells = row.split(separator: "|", omittingEmptySubsequences: false).map { $0.trimmingCharacters(in: .whitespaces) }
            pen.text(cells[0], PropFont.mono(10), 0xF4F1EA, at: CGPoint(x: screen.minX + 4, y: mid), anchor: .leading)
            var right = screen.maxX - 4
            if cells.count > 2, !cells[2].isEmpty {
                let font = PropFont.heavy(10.5)
                let tagW = pen.width(of: cells[2], font) + 8
                let tag = CGRect(x: right - tagW, y: mid - 7.5, width: tagW, height: 15)
                pen.rect(tag, 0xC8261B, radius: 2)
                pen.text(cells[2], font, 0xFFFFFF, at: CGPoint(x: tag.midX, y: tag.midY))
                right = tag.minX - 3
            }
            if cells.count > 1 {
                let x = screen.minX + timeW
                pen.text(cells[1], PropFont.condensed(11), 0xF4F1EA, at: CGPoint(x: x, y: mid), anchor: .leading, maxWidth: max(10, right - x))
            }
        }
    }

    // MARK: Sign and screen

    /// A flat sign in a colour scheme (`tone`) with a thin inner border.
    static func sign(_ pen: PropPen, _ p: PalacePropParams) {
        let tone = PropTone.named(p.tone)
        let panel = mount(pen, p, default: "hang")
        pen.rect(panel, tone.back, radius: 3)
        pen.stroke(Path(roundedRect: panel.insetBy(dx: 2.5, dy: 2.5), cornerRadius: 2), tone.border, 1.4)
        content(pen, p, in: panel.insetBy(dx: 6, dy: 5), tone: tone)
    }

    /// A screen: dark bezel, glowing display.
    static func screen(_ pen: PropPen, _ p: PalacePropParams) {
        let tone = PropTone.named(p.tone ?? "dark")
        let panel = mount(pen, p, default: "hang")
        pen.rect(panel, 0x2E2117, radius: 5)
        let display = panel.insetBy(dx: 4, dy: 4)
        pen.rect(display, tone.back, radius: 2)
        pen.rect(display.minX, display.minY, display.width, display.height * 0.45, 0xFFFFFF, radius: 2, 0.05)
        content(pen, p, in: display.insetBy(dx: 5, dy: 4), tone: tone)
    }

    /// Caption on top, then a row of icons (with labels above them) or one big text.
    /// With icons, `text` is a short line under the row. The bottom edge stays plain: that's
    /// where a word strip's tape lands.
    static func content(_ pen: PropPen, _ p: PalacePropParams, in r: CGRect, tone: PropTone) {
        let icons = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:))
        let labels = p.labels ?? []
        let labelH: CGFloat = labels.contains { !$0.isEmpty } ? 12 : 0
        let lineH: CGFloat = !icons.isEmpty && p.text != nil ? 14 : 0
        var y = r.minY
        if let caption = p.caption {
            pen.text(caption, PropFont.demi(9.5), tone.ink, at: CGPoint(x: r.midX, y: y + 5), maxWidth: r.width)
            y += 12
        }
        let room = r.maxY - y - labelH - lineH
        if !icons.isEmpty {
            let n = CGFloat(icons.count)
            let side = max(8, min(room, (r.width - 6 * (n - 1)) / n))
            let gap = n > 1 ? min(side * 0.5, (r.width - side * n) / (n - 1)) : 0
            var x = r.midX - (side * n + gap * (n - 1)) / 2
            let top = y + labelH + (room - side) / 2
            for (i, icon) in icons.enumerated() {
                let (color, detail) = colors(icon, tone)
                icon.draw(pen, in: CGRect(x: x, y: top, width: side, height: side), color: color, detail: detail)
                if i < labels.count {
                    pen.text(labels[i], PropFont.mono(10), tone.ink, at: CGPoint(x: x + side / 2, y: top - 6), maxWidth: side + 2)
                }
                x += side + gap
            }
            if let text = p.text {
                pen.text(text, PropFont.heavy(10), tone.ink, at: CGPoint(x: r.midX, y: r.maxY - lineH / 2), maxWidth: r.width)
            }
        } else if let text = p.text {
            pen.text(text, PropFont.heavy(max(8, min(room * 0.95, 44))), tone.ink, at: CGPoint(x: r.midX, y: y + room / 2 + 1), maxWidth: r.width)
        }
    }

    /// Icon colours on a given sign: warnings stay yellow, a broken track gets a red break,
    /// a link is orange (the "connection").
    private static func colors(_ icon: PalaceIcon, _ tone: PropTone) -> (UInt32, UInt32) {
        switch icon {
        case .warning: tone.back == 0xFAC775 ? (0x1E1E1C, 0xFAC775) : (0xFAC775, 0x1E1E1C)
        case .brokenTrack: (tone.back == 0x232B3B ? 0xD3D1C7 : tone.ink, 0xC8261B)
        case .link: (0xF2711C, tone.detail)
        default: (tone.ink, tone.detail)
        }
    }

    // MARK: Route map

    /// A map on the wall with one bold straight route between two lettered stops, a train on it.
    static func routeMap(_ pen: PropPen, _ p: PalacePropParams) {
        let panel = mount(pen, p, default: "wall")
        pen.rect(panel, 0x2E2117, radius: 2)
        let map = panel.insetBy(dx: 3, dy: 3)
        pen.rect(map, 0xF4F1EA)
        var m = pen
        m.ctx.clip(to: Path(map))
        let (x, y, w, h) = (map.minX, map.minY, map.width, map.height)
        m.oval(x + w * 0.58, y + h * 0.5, w * 0.34, h * 0.7, 0xD5E3C3)
        var river = Path()
        river.move(to: CGPoint(x: x - 4, y: y + h * 0.2))
        river.addCurve(to: CGPoint(x: x + w + 4, y: y + h * 0.75),
                       control1: CGPoint(x: x + w * 0.35, y: y + h * 0.05), control2: CGPoint(x: x + w * 0.55, y: y + h * 1.05))
        m.stroke(river, 0xA9CBE0, 5)
        for k in 1..<4 {
            let fx = x + w * CGFloat(k) / 4
            m.line(fx, y, fx - 6, y + h, 0xE2DED3, 1.6)
        }
        m.line(x, y + h * 0.55, x + w, y + h * 0.45, 0xE2DED3, 1.6)
        let labels = p.labels ?? ["A", "B"]
        let a = CGPoint(x: x + 13, y: y + 12)
        let b = CGPoint(x: x + w - 13, y: y + h - 12)
        m.line(a.x, a.y, b.x, b.y, 0xC8261B, 4)
        let mid = CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
        m.dot(mid.x, mid.y, 8.5, 0xFFFDF6)
        m.ring(mid.x, mid.y, 8.5, 0xC8261B, 1.6)
        PalaceIcon.train.draw(m, in: CGRect(x: mid.x - 6, y: mid.y - 6.5, width: 12, height: 12), color: 0xC8261B, detail: 0xFFFDF6)
        for (point, label) in zip([a, b], labels) {
            m.dot(point.x, point.y, 8, 0x1E1E1C)
            m.text(label, PropFont.heavy(10), 0xFFFDF6, at: CGPoint(x: point.x, y: point.y + 0.5))
        }
    }

    // MARK: Poster

    /// A standing poster display on two legs: a picture (`icons`), a big `text`, a `caption`.
    static func poster(_ pen: PropPen, _ p: PalacePropParams) {
        let (w, h) = (pen.size.width, pen.size.height)
        let legs: CGFloat = 16
        pen.oval(2, h - 6, w - 4, 6, 0x1E1E1C, 0.14)
        pen.rect(w * 0.22 - 2, h - legs - 4, 4, legs + 1, 0x3E4C55)
        pen.rect(w * 0.78 - 2, h - legs - 4, 4, legs + 1, 0x3E4C55)
        let panel = CGRect(x: 0, y: 0, width: w, height: h - legs)
        pen.rect(panel, 0x3E4C55, radius: 3)
        let sheet = panel.insetBy(dx: 4, dy: 4)
        pen.rect(sheet, 0xFAC775)
        var y = sheet.minY + 4
        if let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first {
            let side = min(sheet.width - 6, sheet.height * 0.5)
            icon.draw(pen, in: CGRect(x: sheet.midX - side / 2, y: y, width: side, height: side), color: 0x0F6E56, detail: 0xFFFDF6)
            y += side + 2
        }
        if let text = p.text {
            pen.text(text, PropFont.heavy(17), 0xC8261B, at: CGPoint(x: sheet.midX, y: y + 9), maxWidth: sheet.width - 4)
            y += 20
        }
        if let caption = p.caption {
            pen.text(caption, PropFont.demi(10), 0x1E1E1C, at: CGPoint(x: sheet.midX, y: y + 6), maxWidth: sheet.width - 4)
        }
    }

    // MARK: Mounting

    /// Draws how a panel is fixed and returns the panel's rect: "hang" adds two rods from the
    /// ceiling, "wall" a soft shadow behind it.
    static func mount(_ pen: PropPen, _ p: PalacePropParams, default fallback: String) -> CGRect {
        let (w, h) = (pen.size.width, pen.size.height)
        switch p.mount ?? fallback {
        case "hang":
            pen.line(w * 0.2, 0, w * 0.2, 10, 0x2E2117, 2)
            pen.line(w * 0.8, 0, w * 0.8, 10, 0x2E2117, 2)
            return CGRect(x: 0, y: 8, width: w, height: h - 8)
        case "wall":
            pen.rect(1, 2.5, w - 1, h - 2, 0x1E1E1C, radius: 3, 0.14)
            return CGRect(x: 0, y: 0, width: w - 1, height: h - 2)
        default:
            return CGRect(origin: .zero, size: pen.size)
        }
    }
}
