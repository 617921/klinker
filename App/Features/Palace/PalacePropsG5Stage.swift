import SwiftUI

/// Cinema and theatre: posters, a newspaper and a programme, the cloakroom, the film on the
/// screen and the crest above the stage.
enum G5Stage {
    // MARK: Poster

    /// A framed poster (fills its frame): `text` big on top, a picture, `caption` at the bottom.
    /// `accessory` the picture: "lead" (one big face with a gold star, two small faces below),
    /// "city" (canal houses with a red map pin), "play" (a king and a lady between curtains),
    /// "comedian" (on a stool at a microphone, "haha" around him). `tone` the background.
    static func poster(_ pen: PropPen, _ p: PalacePropParams) {
        let (w, h) = (pen.size.width, pen.size.height)
        pen.rect(1, 2, w - 1, h - 2, 0x1E1E1C, radius: 2, 0.18)
        pen.rect(0, 0, w - 1, h - 2, 0x2E2117, radius: 2)
        let sheet = CGRect(x: 3, y: 3, width: w - 7, height: h - 8)
        let back = PropColor.named(p.tone, 0x1F3A6B)
        pen.rect(sheet, back)
        let top: CGFloat = p.text == nil ? 0 : 13
        let bottom: CGFloat = p.caption == nil ? 0 : 11
        let pic = CGRect(x: sheet.minX + 2, y: sheet.minY + top + 1, width: sheet.width - 4, height: sheet.height - top - bottom - 2)
        var g = pen.within(pic)
        g.ctx.clip(to: Path(CGRect(origin: .zero, size: pic.size)))
        picture(g, p.accessory ?? "lead", pic.size, back)
        if let text = p.text {
            pen.text(text, PropFont.heavy(10), 0xFAC775, at: CGPoint(x: sheet.midX, y: sheet.minY + 7.5), maxWidth: sheet.width - 4)
        }
        if let caption = p.caption {
            pen.text(caption, PropFont.demi(8.5), 0xFFFDF6, at: CGPoint(x: sheet.midX, y: sheet.maxY - 6), maxWidth: sheet.width - 4)
        }
    }

    private static func picture(_ g: PropPen, _ kind: String, _ s: CGSize, _ back: UInt32) {
        let (w, h) = (s.width, s.height)
        let cx = w / 2
        switch kind {
        case "city":
            g.rect(0, 0, w, h, 0x3E4C55)
            g.dot(w * 0.78, h * 0.18, 4, 0xFFF6D8)
            var x: CGFloat = -2
            for (i, hh) in [0.5, 0.62, 0.46, 0.58].enumerated() {
                let bw = w / 3.6, top = h * (1 - hh)
                g.svg("M\(x) \(h)V\(top + 6)L\(x + bw / 2) \(top)L\(x + bw) \(top + 6)V\(h)Z", [0x7B3F2E, 0x9A5238, 0x5E6B73, 0x8C4A3A][i])
                g.rect(x + bw * 0.3, top + 10, bw * 0.4, 4, 0xFAC775, 0.8)
                x += bw - 1
            }
            g.rect(0, h - 6, w, 6, 0x1F3A6B)
            g.svg("M\(cx) \(h * 0.62)C\(cx - 3) \(h * 0.5) \(cx - 9) \(h * 0.42) \(cx - 9) \(h * 0.3)A9 9 0 0 1 \(cx + 9) \(h * 0.3)C\(cx + 9) \(h * 0.42) \(cx + 3) \(h * 0.5) \(cx) \(h * 0.62)Z", 0xC8261B)
            g.dot(cx, h * 0.3, 3.4, 0xFFFDF6)
        case "play":
            g.rect(0, 0, w, h, 0x2E2117)
            g.svg("M0 0H\(w * 0.22)Q\(w * 0.12) \(h * 0.5) \(w * 0.2) \(h)H0Z M\(w) 0H\(w * 0.78)Q\(w * 0.88) \(h * 0.5) \(w * 0.8) \(h)H\(w)Z", 0xC8261B)
            mini(g, x: w * 0.38, foot: h - 2, height: h * 0.72, coat: 0x3C3489, crown: true)
            mini(g, x: w * 0.62, foot: h - 2, height: h * 0.66, coat: 0x0F6E56, crown: false)
        case "comedian":
            g.rect(0, 0, w, h, back)
            g.dot(cx, h * 0.45, min(w, h) * 0.42, 0xFAC775, 0.25)
            g.svgLine("M\(cx - 4) \(h * 0.62)L\(cx - 8) \(h)M\(cx + 4) \(h * 0.62)L\(cx + 8) \(h)M\(cx - 7) \(h * 0.84)H\(cx + 7)", 0x8A8A82, 1.4)
            mini(g, x: cx, foot: h * 0.66, height: h * 0.5, coat: 0x2E2117, crown: false, laugh: true)
            g.svgLine("M\(cx + 6) \(h * 0.36)L\(cx + 4) \(h)", 0x5E6B73, 1)
            g.dot(cx + 6.5, h * 0.33, 2.2, 0x3E4C55)
            g.text("haha", PropFont.heavy(7), 0xFAC775, at: CGPoint(x: w * 0.2, y: h * 0.16))
            g.text("haha", PropFont.heavy(7), 0xFAC775, at: CGPoint(x: w * 0.8, y: h * 0.3))
        default:
            g.rect(0, 0, w, h, back)
            let r = min(w * 0.3, h * 0.26)
            let face = CGPoint(x: cx, y: h * 0.38)
            g.svg("M\(cx - r * 1.7) \(h * 0.38 + r * 2.6)Q\(cx - r * 1.6) \(face.y + r * 1.1) \(cx) \(face.y + r * 1.1)Q\(cx + r * 1.6) \(face.y + r * 1.1) \(cx + r * 1.7) \(face.y + r * 2.6)Z", 0x993556)
            g.dot(face.x, face.y, r, 0xE8C4A0)
            g.svg("M\(cx - r) \(face.y)C\(cx - r * 1.1) \(face.y - r * 1.2) \(cx + r * 1.1) \(face.y - r * 1.3) \(cx + r) \(face.y)C\(cx + r * 0.6) \(face.y - r * 0.5) \(cx - r * 0.6) \(face.y - r * 0.5) \(cx - r) \(face.y)Z M\(cx - r) \(face.y)Q\(cx - r * 1.3) \(face.y + r) \(cx - r * 0.8) \(face.y + r * 1.4)L\(cx - r * 0.85) \(face.y)Z", 0x4A3524)
            g.dot(cx - r * 0.35, face.y + r * 0.05, r * 0.11, 0x2E2117)
            g.dot(cx + r * 0.35, face.y + r * 0.05, r * 0.11, 0x2E2117)
            g.svgLine("M\(cx - r * 0.3) \(face.y + r * 0.45)Q\(cx) \(face.y + r * 0.62) \(cx + r * 0.3) \(face.y + r * 0.45)", 0x8C5A3C, max(0.8, r * 0.1))
            g.svg(PalacePeople.star(cx: w * 0.84, cy: h * 0.14, r: min(w, h) * 0.13), 0xFAC775)
            for (i, x) in [w * 0.22, w * 0.78].enumerated() {
                g.dot(x, h * 0.88, r * 0.42, [0xC99A74, 0x8C5A3C][i])
                g.svg("M\(x - r * 0.42) \(h * 0.88)A\(r * 0.42) \(r * 0.42) 0 0 1 \(x + r * 0.42) \(h * 0.88)Q\(x) \(h * 0.8) \(x - r * 0.42) \(h * 0.88)Z", 0x2E2117)
            }
        }
    }

    /// A small figure for pictures: coat, head, optional crown or laughing mouth.
    private static func mini(_ g: PropPen, x: CGFloat, foot: CGFloat, height hh: CGFloat, coat: UInt32, crown: Bool, laugh: Bool = false) {
        let r = hh * 0.16
        let headY = foot - hh + r
        g.svg("M\(x - r * 1.3) \(foot)L\(x - r * 1.1) \(headY + r * 1.4)Q\(x) \(headY + r) \(x + r * 1.1) \(headY + r * 1.4)L\(x + r * 1.3) \(foot)Z", coat)
        g.dot(x, headY, r, 0xE8C4A0)
        if crown { g.svg("M\(x - r) \(headY - r * 0.6)L\(x - r) \(headY - r * 1.7)L\(x - r * 0.4) \(headY - r * 1.1)L\(x) \(headY - r * 1.8)L\(x + r * 0.4) \(headY - r * 1.1)L\(x + r) \(headY - r * 1.7)L\(x + r) \(headY - r * 0.6)Z", 0xFAC775) }
        if laugh { g.svg("M\(x - r * 0.5) \(headY + r * 0.2)H\(x + r * 0.5)Q\(x) \(headY + r * 0.9) \(x - r * 0.5) \(headY + r * 0.2)Z", 0x7A2A20) }
    }

    // MARK: Newspaper and programme

    /// A printed page (fills its frame). `accessory` "news": a newspaper with masthead `caption`,
    /// headline `text`, `count` of five stars filled, columns and a photo. "booklet": a programme
    /// with a `tone` cover band (masks and `caption`) and rows `lines` "date|title".
    /// `mount` "stand" sets it on a small wooden stand.
    static func print(_ pen: PropPen, _ p: PalacePropParams) {
        if p.mount == "stand" {
            let (w, h) = (pen.size.width, pen.size.height)
            pen.svgLine("M\(w * 0.3) \(h * 0.6)L\(w * 0.18) \(h - 1)M\(w * 0.7) \(h * 0.6)L\(w * 0.82) \(h - 1)M\(w * 0.5) \(h * 0.7)V\(h - 1)", 0x6B4A2E, 2.4)
            var top = p
            top.mount = nil
            return print(pen.within(CGRect(x: 0, y: 0, width: w, height: h * 0.74)), top)
        }
        let (w, h) = (pen.size.width, pen.size.height)
        pen.rect(2, 3, w - 3, h - 3, 0x1E1E1C, radius: 1.5, 0.16)
        pen.rect(0, 0, w - 3, h - 3, 0xFFFDF6, radius: 1.5)
        let inner = CGRect(x: 4, y: 4, width: w - 11, height: h - 11)
        if p.accessory == "booklet" {
            let band = PropColor.named(p.tone, 0x7A1E1E)
            pen.rect(0, 0, w - 3, 20, band, radius: 1.5)
            PalaceIcon.g5Masks.draw(pen, in: CGRect(x: 4, y: 2, width: 16, height: 16), color: 0xFAC775, detail: band)
            pen.text(p.caption ?? "", PropFont.heavy(8), 0xFFFDF6, at: CGPoint(x: (w + 18) / 2, y: 10.5), maxWidth: w - 28)
            var y: CGFloat = 26
            for line in (p.lines ?? []).prefix(4) {
                let cells = line.split(separator: "|", omittingEmptySubsequences: false).map(String.init)
                pen.text(cells[0], PropFont.condensed(7.5), band, at: CGPoint(x: inner.minX, y: y), anchor: .leading, maxWidth: inner.width * 0.36)
                if cells.count > 1 {
                    pen.text(cells[1], PropFont.demi(7.5), 0x1E1E1C, at: CGPoint(x: inner.minX + inner.width * 0.4, y: y), anchor: .leading, maxWidth: inner.width * 0.6)
                }
                pen.line(inner.minX, y + 6, inner.maxX, y + 6, 0xE2DED3, 0.8)
                y += 13
            }
            return
        }
        pen.text(p.caption ?? "", PropFont.heavy(9.5), 0x1E1E1C, at: CGPoint(x: inner.midX, y: inner.minY + 5), maxWidth: inner.width)
        pen.line(inner.minX, inner.minY + 11, inner.maxX, inner.minY + 11, 0x1E1E1C, 1)
        pen.text(p.text ?? "", PropFont.heavy(9), 0x1E1E1C, at: CGPoint(x: inner.midX, y: inner.minY + 19), maxWidth: inner.width)
        let n = max(0, min(p.count ?? 5, 5))
        let r = min(6.5, inner.width / 12)
        for i in 0..<5 {
            let cx = inner.midX + (CGFloat(i) - 2) * r * 2.2
            pen.svg(PalacePeople.star(cx: cx, cy: inner.minY + 30, r: r), i < n ? 0xF2A51C : 0xD3D1C7)
        }
        let top = inner.minY + 39
        pen.rect(inner.minX, top, inner.width * 0.42, inner.maxY - top - 2, 0x8A9AA0)
        pen.dot(inner.minX + inner.width * 0.21, top + 7, 3.4, 0xD3D1C7)
        var y = top + 1
        while y < inner.maxY - 2 {
            pen.line(inner.minX + inner.width * 0.48, y, inner.maxX, y, 0xB4B2A9, 1.2)
            y += 4
        }
    }

    // MARK: Cloakroom

    /// A cloakroom (92 × 116): coats on a rail behind a counter, numbered tags on the hangers,
    /// and a hand putting a numbered token (`text`) on the counter.
    static func cloakroom(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 92, height: 116))
        f.rect(2, 4, 88, 66, 0x3A1A16, radius: 2)
        f.line(4, 14, 88, 14, 0xB4B2A9, 2.4)
        let coats: [UInt32] = [0x1F3A6B, 0xC9A15B, 0x2E2117, 0x0F6E56, 0x993556]
        for (i, c) in coats.enumerated() {
            let x = 10 + CGFloat(i) * 16
            f.svgLine("M\(x + 4) 14V18M\(x - 2) 22L\(x + 4) 18L\(x + 10) 22", 0x8A8A82, 1.2)
            f.svg("M\(x - 2) 22H\(x + 10)L\(x + 12) 60H\(x - 4)Z", c)
            f.svg("M\(x + 1) 22L\(x + 4) 32L\(x + 7) 22Z", PalaceInk.shade(c, 0.75))
            f.rect(x + 1, 26, 6, 7, 0xFAC775, radius: 1)
            f.text("\(12 + i)", PropFont.heavy(4.5), 0x412402, at: CGPoint(x: x + 4, y: 29.6))
        }
        f.rect(0, 70, 92, 6, 0xC9965F, radius: 1)
        f.rect(2, 76, 88, 40, 0x8C5E38)
        f.svgLine("M10 82H82V110H10Z", 0x6B4A2E, 1)
        f.dot(46, 66, 6.5, 0xFAC775)
        f.ring(46, 66, 6.5, 0x8C5E38, 1)
        f.text(p.text ?? "17", PropFont.heavy(7), 0x412402, at: CGPoint(x: 46, y: 66.5))
        f.svg("M52 64Q56 60 60 62L64 66Q60 70 54 69Z", 0xC99A74)
        f.svgLine("M64 66L82 60", 0x3C3489, 6)
    }

    // MARK: The film on the screen

    /// A cinema screen (fills its frame): a night scene by the canal with two people, and the
    /// subtitle `text` in white on a dark band at the bottom.
    static func screen(_ pen: PropPen, _ p: PalacePropParams) {
        let (w, h) = (pen.size.width, pen.size.height)
        pen.rect(0, 0, w, h, 0x1F3A6B)
        pen.rect(0, 0, w, h * 0.45, 0x2B4C86)
        pen.dot(w * 0.82, h * 0.2, h * 0.09, 0xFFF6D8)
        var x: CGFloat = -4
        var i = 0
        while x < w {
            let bw = h * 0.22, top = h * (0.34 + 0.06 * CGFloat(i % 3))
            pen.svg("M\(x) \(h * 0.78)V\(top + 6)L\(x + bw / 2) \(top - 2)L\(x + bw) \(top + 6)V\(h * 0.78)Z", [0x16294D, 0x1C3058, 0x132442][i % 3])
            pen.rect(x + bw * 0.3, top + 12, bw * 0.16, 5, 0xFAC775, 0.7)
            x += bw
            i += 1
        }
        pen.rect(0, h * 0.74, w, h * 0.26, 0x10203F)
        for (k, px) in [w * 0.4, w * 0.56].enumerated() {
            let foot = h * 0.78, r = h * 0.07
            pen.svg("M\(px - r * 1.4) \(foot)L\(px - r * 1.2) \(foot - r * 3.4)Q\(px) \(foot - r * 4.2) \(px + r * 1.2) \(foot - r * 3.4)L\(px + r * 1.4) \(foot)Z", [0x993556, 0x3E4C55][k])
            pen.dot(px + (k == 0 ? r * 0.3 : -r * 0.3), foot - r * 4.6, r, [0xE8C4A0, 0xC99A74][k])
            pen.svg("M\(px - r) \(foot - r * 4.8)A\(r) \(r) 0 0 1 \(px + r) \(foot - r * 4.8)Q\(px) \(foot - r * 5.3) \(px - r) \(foot - r * 4.8)Z", [0x4A3524, 0x1E1E1C][k])
        }
        if let text = p.text {
            let band = CGRect(x: w * 0.12, y: h * 0.8, width: w * 0.76, height: h * 0.15)
            pen.rect(band, 0x000000, radius: 2, 0.55)
            pen.text(text, PropFont.heavy(min(14, band.height * 0.75)), 0xFFFFFF, at: CGPoint(x: band.midX, y: band.midY + 0.5), maxWidth: band.width - 6)
        }
    }

    // MARK: Crest

    /// A gilded oval crest above a stage or screen (fills its frame): the first of `icons` and/or a
    /// big `text`. `tone` "dark" makes it a lit sign instead of gold.
    static func emblem(_ pen: PropPen, _ p: PalacePropParams) {
        let (w, h) = (pen.size.width, pen.size.height)
        let dark = p.tone == "dark"
        let face: UInt32 = dark ? 0x232B3B : 0xC9A15B
        let ink: UInt32 = dark ? 0xFAC775 : 0x7A1E1E
        if dark { pen.rect(0, 0, w, h, face, radius: 5) } else {
            pen.oval(0, 0, w, h, PalaceInk.shade(face, 0.75))
            pen.oval(2, 2, w - 4, h - 4, face)
            pen.stroke(Path(ellipseIn: CGRect(x: 5, y: 5, width: w - 10, height: h - 10)), PalaceInk.shade(face, 1.2), 1.2)
        }
        let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first
        let side = h * 0.7
        let total = (icon == nil ? 0 : side) + (p.text == nil ? 0 : pen.width(of: p.text ?? "", PropFont.heavy(h * 0.62)) + (icon == nil ? 0 : 4))
        var x = w / 2 - total / 2
        if let icon {
            icon.draw(pen, in: CGRect(x: x, y: (h - side) / 2, width: side, height: side), color: dark ? ink : 0xFFFDF6, detail: dark ? face : ink)
            x += side + 4
        }
        if let text = p.text {
            pen.text(text, PropFont.heavy(h * 0.62), ink, at: CGPoint(x: x, y: h / 2 + 1), anchor: .leading)
        }
    }
}
