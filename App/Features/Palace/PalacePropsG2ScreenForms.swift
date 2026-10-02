import SwiftUI

/// Screens with forms and calls (drawn in the display's own size): a login with a hidden
/// password, a form of personal details, and a video call from someone at home.
enum G2ScreenForms {
    /// A login: a lock, a filled-in name, a password of dots with a key beside it, a button.
    static func login(_ s: PropPen, _ p: PalacePropParams) {
        let (w, h) = (s.size.width, s.size.height)
        s.rect(0, 0, w, h, 0xE4ECEE)
        let side = h * 0.34
        PalaceIcon.g2Lock.draw(s, in: CGRect(x: w / 2 - side / 2, y: 2, width: side, height: side), color: 0x1F3A6B, detail: 0xE4ECEE)
        let fieldW = w * 0.62, x = w * 0.12
        let y1 = h * 0.42, fh = h * 0.17
        s.rect(x, y1, fieldW, fh, 0xFFFFFF, radius: 1.5)
        s.text(p.text ?? "", PropFont.demi(fh * 0.7), 0x2F5BD3, at: CGPoint(x: x + 3, y: y1 + fh / 2), anchor: .leading, maxWidth: fieldW - 4)
        let y2 = y1 + fh + 3
        s.rect(x, y2, fieldW, fh, 0xFFFFFF, radius: 1.5)
        s.stroke(Path(roundedRect: CGRect(x: x, y: y2, width: fieldW, height: fh), cornerRadius: 1.5), 0x2F5BD3, 1)
        for k in 0..<6 { s.dot(x + 5 + CGFloat(k) * fieldW * 0.13, y2 + fh / 2, fh * 0.2, 0x1E1E1C) }
        // A key beside the password
        let kx = x + fieldW + 4, ky = y2 + fh / 2
        s.ring(kx + 3, ky, fh * 0.3, 0xC9A15B, 1.6)
        s.svgLine("M\(kx + 3 + fh * 0.3) \(ky)H\(w - 3)M\(w - 6) \(ky)V\(ky + 3)", 0xC9A15B, 1.6)
        s.rect(w * 0.3, h - fh - 2, w * 0.4, fh, 0x1E7A4C, radius: 2)
        s.svgLine("M\(w * 0.46) \(h - fh / 2 - 2)L\(w * 0.5) \(h - 4)L\(w * 0.56) \(h - fh)", 0xFFFFFF, 1.2)
    }

    /// Personal details: a photo on the left, labelled fields `lines` "label|value" on the right.
    static func form(_ s: PropPen, _ p: PalacePropParams) {
        let (w, h) = (s.size.width, s.size.height)
        s.rect(0, 0, w, h, 0xFFFDF6)
        s.rect(0, 0, w, h * 0.14, 0x1F3A6B)
        let photo = CGRect(x: 4, y: h * 0.24, width: w * 0.26, height: h * 0.62)
        s.rect(photo, 0xD3E0E6, radius: 2)
        s.dot(photo.midX, photo.minY + photo.height * 0.38, photo.width * 0.22, 0x8C5A3C)
        s.svg("M\(photo.minX + 4) \(photo.maxY)Q\(photo.midX) \(photo.minY + photo.height * 0.55) \(photo.maxX - 4) \(photo.maxY)Z", 0x993556)
        let rows = Array((p.lines ?? []).prefix(3))
        let left = photo.maxX + 5, rowH = (h * 0.8) / CGFloat(max(3, rows.count))
        for (i, row) in rows.enumerated() {
            let cells = row.split(separator: "|", omittingEmptySubsequences: false).map(String.init)
            let y = h * 0.2 + CGFloat(i) * rowH
            s.text(cells.first ?? "", PropFont.mono(rowH * 0.3), 0x8C9499, at: CGPoint(x: left, y: y + rowH * 0.2), anchor: .leading)
            s.line(left, y + rowH * 0.9, w - 4, y + rowH * 0.9, 0xB4B2A9, 0.8)
            if cells.count > 1 {
                s.text(cells[1], PropFont.demi(rowH * 0.42), 0x2F5BD3, at: CGPoint(x: left, y: y + rowH * 0.62), anchor: .leading, maxWidth: w - left - 4)
            }
        }
    }

    /// A video call from home: a colleague in a hoodie at the kitchen table with a mug, a cat walking
    /// past, a plant and a picture behind; a house badge in the corner and a red hang-up button.
    static func home(_ s: PropPen, _ p: PalacePropParams) {
        let (w, h) = (s.size.width, s.size.height)
        s.rect(0, 0, w, h, 0xF1E2C4)
        s.rect(w * 0.62, h * 0.12, w * 0.22, h * 0.32, 0xBCCDD6)
        s.svgLine("M\(w * 0.73) \(h * 0.12)V\(h * 0.44)M\(w * 0.62) \(h * 0.28)H\(w * 0.84)", 0xFFFDF6, 1.4)
        s.rect(w * 0.08, h * 0.16, w * 0.16, h * 0.22, 0x9A6A42, radius: 1)
        s.rect(w * 0.1, h * 0.19, w * 0.12, h * 0.16, 0x5E8C45)
        let u = h / 60
        let me = s.within(CGRect(x: w / 2 - 22 * u, y: 8 * u, width: 44 * u, height: 52 * u), unit: u)
        me.svg("M4 52V40C4 32 12 28 22 28C32 28 40 32 40 40V52Z", 0x5E8C45)
        me.svg("M12 30Q22 20 32 30L28 34Q22 30 16 34Z", 0x4E7A3A)
        me.dot(22, 16, 9, 0xC99A74)
        me.svg("M13 15C12 8 16 5 22 5C28 5 32 8 31 15C29 11 26 10 22 10C18 10 15 11 13 15Z", 0x4A3524)
        me.dot(19, 16, 1, 0x2E2117)
        me.dot(25, 16, 1, 0x2E2117)
        me.svgLine("M19 21Q22 23 25 21", 0x8C5A3C, 1)
        s.rect(0, h * 0.82, w, h * 0.18, 0xC9965F)
        s.rect(w * 0.14, h * 0.68, w * 0.09, h * 0.16, 0xFFFDF6, radius: 1)
        // The cat
        s.oval(w * 0.66, h * 0.7, w * 0.2, h * 0.14, 0x3E4C55)
        s.dot(w * 0.86, h * 0.7, h * 0.08, 0x3E4C55)
        s.svg("M\(w * 0.83) \(h * 0.66)L\(w * 0.84) \(h * 0.58)L\(w * 0.87) \(h * 0.64)Z M\(w * 0.88) \(h * 0.64)L\(w * 0.91) \(h * 0.58)L\(w * 0.91) \(h * 0.68)Z", 0x3E4C55)
        s.svgLine("M\(w * 0.66) \(h * 0.76)Q\(w * 0.58) \(h * 0.7) \(w * 0.62) \(h * 0.6)", 0x3E4C55, 1.6)
        // House badge and hang-up button
        s.dot(h * 0.14 + 2, h * 0.14 + 2, h * 0.14, 0x1E7A4C)
        PalaceIcon.house.draw(s, in: CGRect(x: 2 + h * 0.04, y: 2 + h * 0.04, width: h * 0.2, height: h * 0.2), color: 0xFFFFFF, detail: 0x1E7A4C)
        s.rect(w / 2 - 7, h - 8, 14, 6, 0xC8261B, radius: 3)
    }
}
