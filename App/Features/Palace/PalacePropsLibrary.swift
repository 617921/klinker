import SwiftUI

/// Named colours for props (`tone` in anchors.json), shared by the learning-place props.
enum PropColor {
    static func named(_ name: String?, _ fallback: UInt32) -> UInt32 {
        switch name {
        case "red": 0xC8261B
        case "blue": 0x1F3A6B
        case "green": 0x0F6E56
        case "teal": 0x1E7A4C
        case "yellow": 0xFAC775
        case "orange": 0xF2711C
        case "purple": 0x3C3489
        case "brown": 0x7A5230
        case "gold": 0xC9A15B
        case "grey": 0x5E6B73
        case "pink": 0x993556
        default: fallback
        }
    }
}

/// Library props: a pass card with a photo, a date slip with a coin, a book (on a stand or on a
/// shelf with a name band) and a rack of magazines.
enum PalaceLibraryProps {
    // MARK: Pass card

    /// A pass card (70 × 54): coloured header with `caption`, a photo, name lines (or `text`),
    /// a barcode. `tone` header colour, `variant` the face, `accessory` "hand" holds it up.
    static func card(_ pen: PropPen, _ p: PalacePropParams) {
        let hand = p.accessory == "hand"
        let f = pen.fitted(CGSize(width: 70, height: hand ? 54 : 46))
        let tone = PropColor.named(p.tone, 0x0F6E56)
        let look = PalaceFigures.Look.at(p.variant ?? 3)
        f.rect(5, 5, 60, 40, 0x1E1E1C, radius: 4, 0.16)
        f.rect(3, 2, 60, 40, 0xFFFDF6, radius: 4)
        f.stroke(Path(roundedRect: CGRect(x: 3, y: 2, width: 60, height: 40), cornerRadius: 4), 0xD3D1C7, 1)
        f.svg("M7 2H59Q63 2 63 6V12H3V6Q3 2 7 2Z", tone)
        if let caption = p.caption {
            f.text(caption, PropFont.heavy(8), 0xFFFDF6, at: CGPoint(x: 33, y: 7.2), maxWidth: 52)
        }
        f.rect(8, 16, 17, 21, 0xD3E0E6, radius: 1.5)
        var photo = f
        photo.ctx.clip(to: Path(roundedRect: CGRect(x: 8, y: 16, width: 17, height: 21), cornerRadius: 1.5))
        photo.svg("M9 38Q9 30 16.5 30Q24 30 24 38Z", look.coat)
        photo.dot(16.5, 24.5, 4.6, look.skin)
        photo.svg("M11.8 24C11.6 20.6 13.8 19 16.5 19C19.4 19 21.4 20.6 21.2 24C20 22 18.6 21.4 16.5 21.4C14.4 21.4 13 22 11.8 24Z", look.hair)
        if let name = p.text {
            f.text(name, PropFont.demi(7.5), 0x1E1E1C, at: CGPoint(x: 29, y: 19.5), anchor: .leading, maxWidth: 31)
        } else {
            f.line(29, 18.5, 56, 18.5, 0xB4B2A9, 2)
        }
        f.line(29, 24, 50, 24, 0xB4B2A9, 2)
        var x: CGFloat = 29
        for (i, w) in [1.2, 0.6, 1.8, 0.6, 1.2, 0.6, 0.6, 1.8, 1.2, 0.6, 1.8, 0.6, 1.2].enumerated() {
            if i % 2 == 0 || w > 1 { f.rect(x, 28.5, w, 9, 0x1E1E1C) }
            x += w + 1
        }
        if hand {
            // Fingers behind the card's lower edge, a thumb in front, a sleeve.
            f.svg("M42 41H60Q65 41 65 46V49H42Z", look.skin)
            f.svgLine("M47.5 42V46M52.5 42V46M57.5 42V46", PalaceInk.shade(look.skin, 0.82), 1)
            f.svg("M57 31C59.5 30 63 31 64 34.5L65.5 42.5H57.5Z", look.skin)
            f.svgLine("M58.5 33L58.8 40", PalaceInk.shade(look.skin, 0.82), 1)
            f.svg("M41 48H66L69 54H38Z", look.coat)
        }
    }

    // MARK: Date slip with a coin

    /// A date slip (62 × 56): stamped `lines` (the `highlight` one red), a red `caption` stamp across,
    /// and a coin with `text` on it ("€ 0,50").
    static func dueSlip(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 62, height: 56))
        f.rect(4, 3, 38, 50, 0x1E1E1C, radius: 1, 0.14)
        f.rect(2, 1, 38, 50, 0xFFFDF6, radius: 1)
        f.rect(2, 1, 38, 7, 0xC9A15B)
        f.line(21, 10, 21, 49, 0xE2DED3, 1)
        let lines = Array((p.lines ?? []).prefix(3))
        for (i, line) in lines.enumerated() {
            let y = 14 + CGFloat(i) * 9.5
            f.line(5, y + 4.5, 37, y + 4.5, 0xE2DED3, 0.8)
            let late = i == p.highlight
            if late { f.rect(4, y - 4, 34, 8.5, 0xFDECEA, radius: 1) }
            f.text(line, PropFont.mono(7.5), late ? 0xC8261B : 0x3C3489, at: CGPoint(x: 21, y: y), maxWidth: 32)
        }
        if let stamp = p.caption {
            var s = f
            s.ctx.translateBy(x: 20, y: 44)
            s.ctx.rotate(by: .degrees(-14))
            let w = max(24, f.width(of: stamp, PropFont.heavy(8)) + 6)
            s.stroke(Path(roundedRect: CGRect(x: -w / 2, y: -6, width: w, height: 12), cornerRadius: 1.5), 0xC8261B, 1.4)
            s.text(stamp, PropFont.heavy(8), 0xC8261B, at: .zero)
        }
        if let amount = p.text {
            f.dot(49.5, 27.5, 12.5, 0x1E1E1C, 0.16)
            f.dot(48, 26, 12.5, 0xD9A440)
            f.ring(48, 26, 10.2, 0xC9A15B, 1.4)
            f.text(amount, PropFont.heavy(8), 0x6B4A2E, at: CGPoint(x: 48, y: 26.5), maxWidth: 18.5)
        }
    }

    // MARK: Book

    /// A book. `accessory` "stand": a novel on a display easel (66 × 100) with a night-scene cover,
    /// title `text`, author `caption` and a ribbon. "shelf": a book on a shelf between others
    /// (74 × 78) with a paper band around it reading `text` (a name) and `caption` (a date).
    static func book(_ pen: PropPen, _ p: PalacePropParams) {
        let tone = PropColor.named(p.tone, 0x1F3A6B)
        if p.accessory == "shelf" {
            shelfBook(pen.fitted(CGSize(width: 74, height: 78)), p, tone)
            return
        }
        let f = pen.fitted(CGSize(width: 66, height: 100))
        f.oval(6, 95, 54, 5, 0x1E1E1C, 0.14)
        f.svgLine("M15 98L27 22M51 98L39 22M33 24V98", 0x6B4A2E, 3)
        f.rect(26, 18, 14, 6, 0x6B4A2E, radius: 2)
        cover(f, CGRect(x: 10, y: 10, width: 46, height: 62), tone, title: p.text, author: p.caption)
        f.rect(6, 71, 54, 6, 0x7A5230, radius: 1.5)
        f.rect(6, 76, 54, 2, 0x4A3524)
        f.svg("M43 72V86L46 82.5L49 86V72Z", 0xC8261B)
    }

    /// A front cover with a moon over a house on a hill: a story.
    private static func cover(_ f: PropPen, _ r: CGRect, _ tone: UInt32, title: String?, author: String?) {
        f.rect(r.minX + 2, r.minY + 2, r.width, r.height, 0x1E1E1C, radius: 2, 0.18)
        f.rect(r.maxX - 1, r.minY + 2, 4, r.height - 3, 0xEFEBE2, radius: 1)
        f.rect(r, tone, radius: 2)
        f.rect(r.minX, r.minY, 5, r.height, PalaceInk.shade(tone, 0.7), radius: 2)
        var c = f
        c.ctx.clip(to: Path(roundedRect: r, cornerRadius: 2))
        let (x, y, w, h) = (r.minX, r.minY, r.width, r.height)
        c.dot(x + w * 0.74, y + h * 0.36, 6.5, 0xFAC775)
        c.dot(x + w * 0.80, y + h * 0.32, 5.6, tone)
        for (sx, sy) in [(0.3, 0.3), (0.5, 0.24), (0.42, 0.42), (0.88, 0.5)] {
            c.dot(x + w * sx, y + h * sy, 0.9, 0xFFFDF6)
        }
        c.svg("M\(x) \(y + h * 0.86)Q\(x + w * 0.5) \(y + h * 0.66) \(x + w) \(y + h * 0.8)V\(y + h)H\(x)Z", 0x0F6E56)
        let hx = x + w * 0.24, hy = y + h * 0.78
        c.svg("M\(hx) \(hy)V\(hy - 10)L\(hx + 8) \(hy - 17)L\(hx + 16) \(hy - 10)V\(hy)Z", 0x2E2117)
        c.rect(hx + 5.5, hy - 9, 5, 5, 0xFAC775)
        if let title {
            c.text(title, PropFont.heavy(8.5), 0xFFFDF6, at: CGPoint(x: x + w / 2 + 2, y: y + 8), maxWidth: w - 10)
        }
        if let author {
            c.text(author, PropFont.demi(6.5), 0xFAC775, at: CGPoint(x: x + w / 2 + 2, y: y + h - 6), maxWidth: w - 10)
        }
    }

    private static func shelfBook(_ f: PropPen, _ p: PalacePropParams, _ tone: UInt32) {
        f.rect(0, 70, 74, 6, 0x7A5230)
        f.rect(0, 76, 74, 2, 0x4A3524)
        f.rect(2, 26, 9, 44, 0x5E7A68, radius: 1)
        f.rect(11, 32, 8, 38, 0x8C5E38, radius: 1)
        f.svg("M58 70L66 30L74 32L66 70Z", 0x3E4C55)
        f.rect(20, 10, 38, 60, 0x1E1E1C, radius: 2, 0.15)
        f.rect(19, 8, 38, 61, tone, radius: 2)
        f.rect(19, 8, 4.5, 61, PalaceInk.shade(tone, 0.7), radius: 2)
        f.svgLine("M30 15H50M33 20H47", 0xFFFDF6, 1.8)
        f.rect(16, 30, 44, 22, 0x1E1E1C, radius: 1, 0.12)
        f.rect(15, 28, 44, 22, 0xFFFDF6, radius: 1)
        f.line(15, 28, 59, 28, 0xD3D1C7, 1)
        if let name = p.text {
            f.text(name, PropFont.heavy(10.5), 0x1E1E1C, at: CGPoint(x: 37, y: 36), maxWidth: 40)
        }
        if let date = p.caption {
            f.text(date, PropFont.mono(7), 0xC8261B, at: CGPoint(x: 37, y: 45), maxWidth: 40)
        }
        f.svg("M49 4H57V20L53 16.5L49 20Z", 0xF2711C)
    }

    // MARK: Magazines

    /// A wall rack (108 × 76) of `count` magazines with mastheads `labels`: a face, a plant, a cake.
    static func magazines(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 108, height: 76))
        let n = max(2, min(p.count ?? 3, 3))
        let labels = p.labels ?? ["STAD", "TUIN", "KOK"]
        f.rect(2, 4, 106, 72, 0x1E1E1C, radius: 3, 0.12)
        f.rect(0, 2, 106, 72, 0x9A6A42, radius: 3)
        f.rect(4, 6, 98, 64, 0x7A5230, radius: 2)
        let backs: [UInt32] = [0xC8261B, 0x0F6E56, 0xFAC775]
        let mast: [UInt32] = [0xFFFDF6, 0xFAC775, 0xC8261B]
        let w: CGFloat = 30, gap = (98 - w * CGFloat(n)) / CGFloat(n + 1)
        for i in 0..<n {
            let x = 4 + gap + CGFloat(i) * (w + gap)
            let r = CGRect(x: x, y: 11, width: w, height: 52)
            f.rect(r.offsetBy(dx: 1.5, dy: 1.5), 0x1E1E1C, radius: 1, 0.2)
            f.rect(r, backs[i], radius: 1)
            f.text(i < labels.count ? labels[i] : "", PropFont.heavy(9), mast[i], at: CGPoint(x: r.midX, y: r.minY + 7), maxWidth: w - 4)
            var c = f
            c.ctx.clip(to: Path(r))
            switch i {
            case 0:
                c.svg("M\(x + 3) \(r.maxY)Q\(x + 3) \(r.minY + 34) \(x + 15) \(r.minY + 34)Q\(x + 27) \(r.minY + 34) \(x + 27) \(r.maxY)Z", 0xFFFDF6)
                c.dot(x + 15, r.minY + 26, 8, 0xC99A74)
                c.svg("M\(x + 6.5) \(r.minY + 26)C\(x + 6) \(r.minY + 15) \(x + 24) \(r.minY + 15) \(x + 23.5) \(r.minY + 26)C\(x + 21) \(r.minY + 20) \(x + 9) \(r.minY + 20) \(x + 6.5) \(r.minY + 26)Z", 0x2E2117)
                c.svgLine("M\(x + 11.5) \(r.minY + 30)Q\(x + 15) \(r.minY + 32.5) \(x + 18.5) \(r.minY + 30)", 0x8C5A3C, 1.2)
            case 1:
                c.svg("M\(x + 15) \(r.maxY - 6)C\(x + 4) \(r.minY + 30) \(x + 10) \(r.minY + 18) \(x + 15) \(r.minY + 16)C\(x + 20) \(r.minY + 18) \(x + 26) \(r.minY + 30) \(x + 15) \(r.maxY - 6)Z", 0x6E9C52)
                c.dot(x + 15, r.minY + 26, 4, 0xF2711C)
                c.rect(x + 10, r.maxY - 8, 10, 8, 0xA3410A)
            default:
                c.rect(x + 6, r.minY + 26, 18, 14, 0xFFFDF6, radius: 1.5)
                c.rect(x + 6, r.minY + 26, 18, 4, 0x993556, radius: 1.5)
                c.dot(x + 15, r.minY + 22, 2.5, 0xC8261B)
            }
            c.svgLine("M\(x + 4) \(r.maxY - 7)H\(x + 16)M\(x + 4) \(r.maxY - 3.5)H\(x + 12)", mast[i] == 0xC8261B ? 0x1E1E1C : 0xFFFDF6, 1.4)
            c.svg("M\(x + 18) \(r.minY)H\(x + 24)L\(x + 8) \(r.maxY)H\(x + 2)Z", 0xFFFFFF, 0.12)
        }
        f.rect(4, 48, 98, 5, 0xC9A15B, radius: 1)
        f.rect(4, 53, 98, 1.5, 0x6B4A2E)
    }
}
