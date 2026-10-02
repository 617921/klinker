import SwiftUI

/// A device with something on its screen. `mount`: "laptop" (default), "table" (a laptop on a
/// side table), "monitor" (on a stand), "tv" (a big screen on feet), "tablet" (held in two hands).
/// `accessory` picks the screen: "send" (a form and a green button `text`, the cursor on it),
/// "login" (a lock, a name and a password of dots, a key), "compare" (columns `lines`
/// "price|stars", the `highlight` one ticked), "ad" (a product with a starburst `text` and a
/// price `caption`), "replay" (a paused video, a big turn-back arrow, `text` under it),
/// "edit" (a video with a timeline of clips and scissors), "form" (a photo and filled-in fields
/// `lines` "label|value"), "home" (a video call with someone working at home, a cat and a house badge).
enum G2Screens {
    static func laptop(_ pen: PropPen, _ p: PalacePropParams) {
        let mount = p.mount ?? "laptop"
        let display: CGRect
        let f: PropPen
        switch mount {
        case "monitor":
            f = pen.fitted(CGSize(width: 110, height: 86))
            f.oval(28, 81, 54, 5, 0x1E1E1C, 0.15)
            f.rect(48, 60, 14, 18, 0x5E6B73)
            f.svg("M32 84Q34 78 42 78H68Q76 78 78 84Z", 0x3E4C55)
            f.rect(2, 2, 106, 62, 0x2E2117, radius: 4)
            display = CGRect(x: 6, y: 6, width: 98, height: 54)
        case "tv":
            f = pen.fitted(CGSize(width: 120, height: 92))
            f.oval(14, 87, 92, 5, 0x1E1E1C, 0.15)
            f.svgLine("M24 74L16 90M96 74L104 90", 0x2E2117, 3)
            f.rect(2, 2, 116, 74, 0x1E1E1C, radius: 3)
            display = CGRect(x: 6, y: 6, width: 108, height: 66)
        case "tablet":
            f = pen.fitted(CGSize(width: 96, height: 76))
            f.rect(8, 4, 80, 60, 0x1E1E1C, radius: 6)
            display = CGRect(x: 14, y: 9, width: 68, height: 50)
        default:
            let table = mount == "table"
            f = pen.fitted(CGSize(width: 110, height: table ? 120 : 72))
            if table {
                f.oval(10, 114, 90, 6, 0x1E1E1C, 0.15)
                f.svgLine("M18 74L12 116M92 74L98 116M15 98H95", 0x7A5230, 3.2)
                f.rect(4, 68, 102, 7, 0x9A6A42, radius: 1.5)
                f.rect(4, 74, 102, 2, 0x6B4A2E)
            } else {
                f.oval(4, 66, 102, 6, 0x1E1E1C, 0.15)
            }
            f.rect(14, 2, 82, 56, 0x3E4C55, radius: 4)
            f.svg("M10 58H100L108 66H2Z", 0xB4B2A9)
            f.rect(2, 66, 106, 3, 0x8C9499, radius: 1)
            f.rect(46, 61, 18, 3, 0x8C9499, radius: 1)
            display = CGRect(x: 18, y: 6, width: 74, height: 48)
        }
        var s = f.within(display)
        s.ctx.clip(to: Path(CGRect(origin: .zero, size: display.size)))
        screen(s, p)
        if mount == "tablet" { hands(f) }
    }

    private static func screen(_ s: PropPen, _ p: PalacePropParams) {
        let (w, h) = (s.size.width, s.size.height)
        switch p.accessory {
        case "send":
            s.rect(0, 0, w, h, 0xF4F1EA)
            s.rect(0, 0, w, 8, 0x1F3A6B)
            for k in 0..<2 {
                let y = 12 + CGFloat(k) * 10
                s.line(4, y + 3, 14, y + 3, 0xB4B2A9, 1.6)
                s.rect(17, y, w - 22, 7, 0xFFFFFF, radius: 1)
                s.svgLine("M20 \(y + 3.5)q1.6 -2 3.2 0t3.2 0t3.2 0t3.2 0", 0x2F5BD3, 1)
            }
            let button = CGRect(x: w * 0.2, y: h - 17, width: w * 0.6, height: 13)
            s.rect(button, 0x1E7A4C, radius: 3)
            s.text(p.text ?? "", PropFont.demi(7.5), 0xFFFFFF, at: CGPoint(x: button.midX - 4, y: button.midY), maxWidth: button.width - 14)
            s.svg("M\(button.maxX - 9) \(button.midY - 3.5)L\(button.maxX - 3) \(button.midY)L\(button.maxX - 9) \(button.midY + 3.5)Z", 0xFFFFFF)
            cursor(s, at: CGPoint(x: button.midX + 6, y: button.midY))
        case "compare":
            compare(s, p)
        case "ad":
            G2ScreenContent.ad(s, p)
        case "replay":
            G2ScreenContent.replay(s, p)
        case "edit":
            G2ScreenContent.edit(s, p)
        case "login":
            G2ScreenForms.login(s, p)
        case "form":
            G2ScreenForms.form(s, p)
        case "home":
            G2ScreenForms.home(s, p)
        default:
            s.rect(0, 0, w, h, 0x232B3B)
        }
    }

    /// Side-by-side offers: an umbrella, a price and a row of stars per column; the best one ticked.
    private static func compare(_ s: PropPen, _ p: PalacePropParams) {
        let (w, h) = (s.size.width, s.size.height)
        s.rect(0, 0, w, h, 0xE4ECEE)
        let rows = p.lines ?? []
        let colW = (w - 4) / CGFloat(max(1, rows.count))
        let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first ?? .g2Umbrella
        for (i, row) in rows.enumerated() {
            let cells = row.split(separator: "|").map(String.init)
            let best = i == p.highlight
            let card = CGRect(x: 2 + CGFloat(i) * colW + 1.5, y: 3, width: colW - 3, height: h - 6)
            s.rect(card, 0xFFFFFF, radius: 2)
            if best { s.stroke(Path(roundedRect: card, cornerRadius: 2), 0x1E7A4C, 2) }
            let side = min(card.width - 8, h * 0.3)
            icon.draw(s, in: CGRect(x: card.midX - side / 2, y: card.minY + 3, width: side, height: side),
                      color: best ? 0x1E7A4C : 0x8C9499, detail: 0xFFFFFF)
            s.text(cells.first ?? "", PropFont.heavy(9), 0x1E1E1C, at: CGPoint(x: card.midX, y: card.minY + side + 10), maxWidth: card.width - 3)
            let stars = cells.count > 1 ? Int(cells[1]) ?? 0 : 0
            let r: CGFloat = min(2.6, (card.width - 4) / 10)
            for k in 0..<5 {
                let cx = card.midX + (CGFloat(k) - 2) * r * 2.2
                s.svg(PalacePeople.star(cx: cx, cy: card.minY + side + 20, r: r), k < stars ? 0xE8B32C : 0xD3D1C7)
            }
            if best {
                s.dot(card.maxX - 5, card.maxY - 6, 5, 0x1E7A4C)
                s.svgLine("M\(card.maxX - 7.5) \(card.maxY - 6)L\(card.maxX - 5.5) \(card.maxY - 4)L\(card.maxX - 2.5) \(card.maxY - 8.5)", 0xFFFFFF, 1.4)
            }
        }
    }

    /// A white mouse pointer with its tip at `at`.
    static func cursor(_ s: PropPen, at t: CGPoint) {
        let d = "M\(t.x) \(t.y)V\(t.y + 12)L\(t.x + 3) \(t.y + 9)L\(t.x + 5.2) \(t.y + 13.6)L\(t.x + 7.4) \(t.y + 12.6)L\(t.x + 5.2) \(t.y + 8.2)H\(t.x + 9)Z"
        s.svg(d, 0xFFFFFF)
        s.svgLine(d, 0x1E1E1C, 1)
    }

    /// Two hands holding a tablet at its sides.
    private static func hands(_ f: PropPen) {
        f.svg("M0 76L2 54Q4 44 10 42L14 46Q12 52 12 60L14 76Z", 0xC99A74)
        f.svg("M96 76L94 54Q92 44 86 42L82 46Q84 52 84 60L82 76Z", 0xC99A74)
        f.rect(6, 36, 6, 10, 0xC99A74, radius: 3)
        f.rect(84, 36, 6, 10, 0xC99A74, radius: 3)
    }
}
