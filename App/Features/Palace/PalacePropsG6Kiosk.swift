import SwiftUI

/// Newspapers for the kiosk (and any place with papers): a tied bundle with a tag, a front page,
/// an open page with one article ringed, a new issue popping out of its box, and a paper that
/// stands on its own legs with its puppet strings cut.
enum G6Papers {
    static func paper(_ pen: PropPen, _ p: PalacePropParams) {
        switch p.accessory ?? "front" {
        case "stack": stack(pen, p)
        case "article": article(pen, p)
        case "fresh": fresh(pen, p)
        case "strings": strings(pen, p)
        default: front(pen, p)
        }
    }

    static let newsprint: UInt32 = 0xF4F1EA

    /// Grey column lines in a box, as text on newsprint.
    static func columns(_ f: PropPen, _ r: CGRect, cols: Int = 2, gap: CGFloat = 3, step: CGFloat = 3) {
        let w = (r.width - gap * CGFloat(cols - 1)) / CGFloat(cols)
        for c in 0..<cols {
            let x = r.minX + CGFloat(c) * (w + gap)
            var y = r.minY + 1
            while y < r.maxY {
                f.line(x, y, x + w - (Int(y) % 5 == 0 ? 3 : 0), y, 0xB4B2A9, 1)
                y += step
            }
        }
    }

    /// A masthead: a dark band with a pale squiggle where the paper's name would be.
    static func masthead(_ f: PropPen, _ r: CGRect) {
        f.rect(r, 0x1E1E1C)
        f.svgLine("M\(r.minX + 6) \(r.midY + 1)q3 -5 6 0t6 0t6 0t6 0t6 0", 0xF4F1EA, 1.4)
        f.line(r.maxX - 16, r.midY, r.maxX - 5, r.midY, 0xF4F1EA, 1)
    }

    // MARK: Front page

    /// A front page taped up (84 × 92): masthead, a red "1", headline `text`, a big photo of a
    /// bridge over a canal, columns; `caption` (date) under the masthead.
    static func front(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 92))
        f.rect(5, 4, 76, 88, 0x1E1E1C, radius: 1, 0.15)
        f.rect(3, 2, 76, 88, newsprint, radius: 1)
        masthead(f, CGRect(x: 7, y: 6, width: 68, height: 11))
        f.dot(70, 11.5, 6.5, 0xC8261B)
        f.text("1", PropFont.heavy(10), 0xFFFFFF, at: CGPoint(x: 70, y: 12))
        if let caption = p.caption { f.text(caption, PropFont.mono(6), 0x5F5E5A, at: CGPoint(x: 41, y: 21.5), maxWidth: 66) }
        f.line(7, 25, 75, 25, 0x1E1E1C, 0.8)
        if let text = p.text { f.text(text, PropFont.heavy(15), 0x1E1E1C, at: CGPoint(x: 41, y: 34), maxWidth: 68) }
        // photo: a bridge over the canal
        let photo = CGRect(x: 7, y: 43, width: 68, height: 28)
        f.rect(photo, 0xBCCDD6)
        f.rect(7, 61, 68, 10, 0x6FA3C7)
        f.svg("M7 60H75V64H66Q60 52 41 52Q22 52 16 64H7Z", 0x9A5238)
        f.svgLine("M10 57H72", 0x5E3A2A, 1)
        f.svg("M24 58L28 46H52L56 58Z", 0xD9CDB4, 0.35)
        columns(f, CGRect(x: 7, y: 74, width: 68, height: 13), cols: 3)
        // tape
        f.rect(-2, 0, 14, 6, 0xFAC775, radius: 0.5, 0.8)
        f.rect(70, 0, 14, 6, 0xFAC775, radius: 0.5, 0.8)
    }

    // MARK: Bundle

    /// A tied bundle of folded papers (76 × 50) with a tag (`text`) and a rising sun.
    static func stack(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        for i in 0..<5 {
            let y = 46 - CGFloat(i) * 5
            f.rect(4 + CGFloat(i % 2), y - 5, 52, 5.5, i % 2 == 0 ? newsprint : 0xE2DED3, radius: 0.8)
            f.line(6, y - 2.5, 54, y - 2.5, 0xD3D1C7, 0.8)
        }
        f.rect(4, 8, 52, 18, newsprint, radius: 0.8)
        masthead(f, CGRect(x: 7, y: 10, width: 46, height: 6))
        columns(f, CGRect(x: 7, y: 18, width: 46, height: 6), cols: 3)
        f.svgLine("M30 8V51M4 34H56", 0x8C5E38, 1.4)
        // sun rising behind the tag
        f.svg("M54 22A10 10 0 0 1 74 22Z", 0xFAC775)
        f.svgLine("M64 6V9M54 10L56 12M74 10L72 12", 0xF2B33D, 1.4)
        f.svgLine("M30 34Q40 36 48 32", 0x8C5E38, 0.9)
        guard let text = p.text else { return }
        f.svg("M48 24H76V40H48L44 32Z", 0xFAC775)
        f.stroke(PalaceSVG.path("M48 24H76V40H48L44 32Z"), 0xC8261B, 1)
        f.dot(48, 32, 1.5, 0x8C5E38)
        f.text(text, PropFont.heavy(8), 0xC8261B, at: CGPoint(x: 62, y: 32.5), maxWidth: 26)
    }

    // MARK: Article

    /// An open paper (84 × 58): two pages of columns; one article with a bold title (`text`) and a
    /// photo is ringed in red marker.
    static func article(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 58))
        f.svg("M2 8L42 5L82 8V56L42 53L2 56Z", newsprint)
        f.svgLine("M42 5V53", 0xD3D1C7, 1)
        f.rect(4, 56, 78, 2, 0x1E1E1C, 0.1)
        columns(f, CGRect(x: 6, y: 11, width: 32, height: 40), cols: 2)
        // the ringed article
        if let text = p.text { f.text(text, PropFont.heavy(7.5), 0x1E1E1C, at: CGPoint(x: 62, y: 15), maxWidth: 34) }
        f.rect(46, 20, 16, 11, 0x8E9AA0)
        f.dot(51, 25, 2.5, 0xFAC775)
        columns(f, CGRect(x: 64, y: 20, width: 14, height: 11), cols: 1)
        columns(f, CGRect(x: 46, y: 33, width: 32, height: 9), cols: 2)
        f.stroke(Path(ellipseIn: CGRect(x: 41, y: 7, width: 42, height: 39)), 0xC8261B, 2)
        columns(f, CGRect(x: 46, y: 47, width: 32, height: 5), cols: 2)
    }

    // MARK: New issue

    /// A cardboard box (76 × 50) with a new magazine springing out of it, motion lines and a
    /// starburst with `text`.
    static func fresh(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        // magazine popping out, tilted
        var m = f
        m.ctx.translateBy(x: 30, y: 22)
        m.ctx.rotate(by: .radians(-0.22))
        m.rect(-12, -20, 24, 32, 0xC8261B, radius: 1)
        m.rect(-10, -18, 20, 6, 0xFFFDF6)
        m.dot(0, -2, 6, 0xFAC775)
        m.rect(-10, 6, 20, 2, 0xFFFDF6)
        f.svgLine("M12 8L16 12M10 18H15M46 6L43 11", 0x5E6B73, 1.4)
        // box
        f.svg("M10 30H50V50H10Z", 0xC9A15B)
        f.svg("M10 30L2 24H42L50 30Z", 0xB98B5E)
        f.svg("M50 30L58 22V42L50 50Z", 0xA87B4F)
        f.svgLine("M18 38H42", 0x8C5E38, 1.2)
        guard let text = p.text else { return }
        var burst = ""
        for k in 0..<16 {
            let a = Double(k) * .pi / 8
            let r: Double = k % 2 == 0 ? 15 : 11
            burst += (k == 0 ? "M" : "L") + String(format: "%.1f %.1f", 62 + cos(a) * r, 16 + sin(a) * r)
        }
        f.svg(burst + "Z", 0xFAC775)
        f.text(text, PropFont.heavy(7.5), 0xC8261B, at: CGPoint(x: 62, y: 16.5), maxWidth: 22)
    }

    // MARK: On its own legs

    /// A newspaper standing on its own two legs (82 × 98), striding off; above it a puppeteer's
    /// cross whose strings are cut, scissors at one of them.
    static func strings(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 82, height: 98))
        // a hand from above holds the puppeteer's cross
        f.svgLine("M44 -8L40 2", 0x1F3A6B, 8)
        f.svg("M10 12L66 6L67 10L11 16Z", 0x8C5E38)
        f.svg("M36 0L42 0L41 24L35 24Z", 0x8C5E38)
        f.oval(33, 1, 14, 10, 0xE8C4A0)
        // cut strings: upper halves hang from the cross, lower halves curl loose over the paper
        for (x, top) in [(12.0, 15.0), (38, 24), (64, 10)] as [(CGFloat, CGFloat)] {
            f.line(x, top, x, 27, 0x3E4C55, 1.4)
            f.svgLine("M\(x) 34Q\(x + 4) 37 \(x) 40", 0x3E4C55, 1.4)
            f.svgLine("M\(x - 2) 28.5L\(x + 2) 31M\(x - 2) 32.5L\(x + 2) 30", 0xC8261B, 1)
        }
        // scissors snipping the middle string
        f.ring(54, 24, 3.6, 0xC8261B, 1.8)
        f.ring(54, 37, 3.6, 0xC8261B, 1.8)
        f.svgLine("M51.5 26.5L36 32M51.5 34.5L36 29", 0x8E9AA0, 2)
        // the paper, standing tall, on legs
        f.oval(16, 92, 52, 6, 0x1E1E1C, 0.14)
        f.svgLine("M33 82L28 94M47 82L54 93", 0x1E1E1C, 2.6)
        f.svg("M24 92H32V96H22Z M52 91H60V95H50Z", 0x1E1E1C)
        f.rect(18, 42, 46, 42, newsprint, radius: 1)
        f.stroke(Path(roundedRect: CGRect(x: 18, y: 42, width: 46, height: 42), cornerRadius: 1), 0xB4B2A9, 0.8)
        masthead(f, CGRect(x: 21, y: 45, width: 40, height: 7))
        f.line(21, 56, 61, 56, 0x1E1E1C, 2.4)
        columns(f, CGRect(x: 21, y: 60, width: 40, height: 21), cols: 3)
        // a proud face on the page
        f.dot(41, 66, 7, 0xFFFDF6)
        f.dot(38.5, 64.5, 1, 0x1E1E1C)
        f.dot(43.5, 64.5, 1, 0x1E1E1C)
        f.svgLine("M38 68Q41 71 44 68", 0x1E1E1C, 1)
    }
}
