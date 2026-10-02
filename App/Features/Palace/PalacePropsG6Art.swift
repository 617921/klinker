import SwiftUI

/// Pictures for the gallery (and any museum or living room): a framed painting of several kinds,
/// one tree painted in three styles, one loud red picture among grey ones, and a hand picking
/// one of three pictures.
enum G6Art {
    // MARK: Painting

    /// A framed picture filling its frame. `accessory` "portrait" (a girl with a blue headscarf and
    /// a pearl), "abstract" (circle, triangle, square and lines), "landscape" (fields and a mill) or
    /// "empty" (the frame alone, ornate); `tone` frame "gold" | "black" | "white".
    static func painting(_ pen: PropPen, _ p: PalacePropParams) {
        let (w, h) = (pen.size.width, pen.size.height)
        let kind = p.accessory ?? "landscape"
        let empty = kind == "empty"
        let tone = p.tone ?? (empty || kind == "portrait" ? "gold" : "black")
        let frame: UInt32 = switch tone { case "white": 0xFFFDF6; case "black": 0x1E1E1C; default: 0xC9A15B }
        let border: CGFloat = empty ? min(w, h) * 0.16 : min(w, h) * 0.08
        pen.rect(3, 4, w - 3, h - 3, 0x1E1E1C, radius: 1, 0.15)
        pen.rect(0, 0, w - 3, h - 4, frame, radius: 1)
        let inner = CGRect(x: border, y: border, width: w - 3 - 2 * border, height: h - 4 - 2 * border)
        if empty {
            ornate(pen, CGRect(x: 0, y: 0, width: w - 3, height: h - 4), inner: inner)
            return
        }
        pen.stroke(Path(inner.insetBy(dx: -1.5, dy: -1.5)), PalaceInk.shade(frame, 0.75), 1.5)
        var c = pen.within(inner, unit: inner.width / 60)
        c.ctx.clip(to: Path(CGRect(x: 0, y: 0, width: 60, height: inner.height * 60 / inner.width)))
        let ch = inner.height * 60 / inner.width
        switch kind {
        case "portrait": portrait(c, ch)
        case "abstract": abstract(c, ch)
        default: landscape(c, ch)
        }
    }

    /// Corner curls and beads on a wide gold frame; the wall shows through the middle.
    private static func ornate(_ f: PropPen, _ outer: CGRect, inner: CGRect) {
        f.rect(inner, 0xF4F1EA)
        f.stroke(Path(inner.insetBy(dx: -2, dy: -2)), 0x8C6A2E, 2)
        f.stroke(Path(outer.insetBy(dx: 2.5, dy: 2.5)), 0xE8CF8E, 1.5)
        let b = inner.minX
        for (x, y) in [(outer.minX, outer.minY), (outer.maxX, outer.minY), (outer.minX, outer.maxY), (outer.maxX, outer.maxY)] {
            f.dot(x + (x == outer.minX ? b / 2 : -b / 2), y + (y == outer.minY ? b / 2 : -b / 2), b * 0.42, 0xE8CF8E)
            f.ring(x + (x == outer.minX ? b / 2 : -b / 2), y + (y == outer.minY ? b / 2 : -b / 2), b * 0.25, 0x8C6A2E, 1.2)
        }
        for t in stride(from: 0.25, through: 0.75, by: 0.25) {
            f.dot(outer.minX + outer.width * t, b / 2, b * 0.18, 0xE8CF8E)
            f.dot(outer.minX + outer.width * t, outer.maxY - b / 2, b * 0.18, 0xE8CF8E)
            f.dot(b / 2, outer.minY + outer.height * t, b * 0.18, 0xE8CF8E)
            f.dot(outer.maxX - b / 2, outer.minY + outer.height * t, b * 0.18, 0xE8CF8E)
        }
        f.dot(inner.midX, outer.minY - 2, 2, 0x5E6B73)
    }

    /// A girl looking over her shoulder (60 wide).
    private static func portrait(_ c: PropPen, _ h: CGFloat) {
        c.rect(0, 0, 60, h, 0x24302A)
        c.svg("M8 \(h)C10 \(h - 18) 18 \(h - 24) 30 \(h - 24)C44 \(h - 24) 52 \(h - 18) 54 \(h)Z", 0xC9A15B)
        c.svg("M24 \(h - 22)L30 \(h - 30)L36 \(h - 22)Z", 0xFFFDF6)
        let fy = h * 0.42
        c.oval(19, fy - 13, 22, 28, 0xF1D3B8)
        c.svg("M17 \(fy - 2)C14 \(fy - 20) 26 \(fy - 26) 36 \(fy - 20)C42 \(fy - 16) 42 \(fy - 10) 40 \(fy - 6)C34 \(fy - 12) 24 \(fy - 12) 17 \(fy - 2)Z", 0x2F5BD3)
        c.svg("M38 \(fy - 18)C46 \(fy - 18) 48 \(fy - 8) 44 \(fy + 6)L40 \(fy)Z", 0xF2C230)
        c.dot(26, fy + 1, 1.5, 0x2E2117)
        c.dot(35, fy + 1, 1.5, 0x2E2117)
        c.svgLine("M27 \(fy + 9)Q30.5 \(fy + 10.5) 34 \(fy + 9)", 0xC0546B, 1.6)
        c.dot(19, fy + 8, 2.4, 0xFFFFFF)
    }

    private static func abstract(_ c: PropPen, _ h: CGFloat) {
        c.rect(0, 0, 60, h, 0xFFFDF6)
        c.dot(22, h * 0.38, h * 0.26, 0xC8261B)
        c.svg("M30 \(h - 4)L46 \(h * 0.3)L58 \(h - 4)Z", 0x2F5BD3)
        c.rect(4, h * 0.62, 16, 16, 0xF2C230)
        c.svgLine("M2 \(h * 0.12)L56 \(h * 0.22)M40 2L36 \(h * 0.5)", 0x1E1E1C, 2.2)
        c.svgLine("M4 \(h - 8)Q14 \(h - 18) 24 \(h - 8)T44 \(h - 8)", 0x1E1E1C, 1.6)
    }

    private static func landscape(_ c: PropPen, _ h: CGFloat) {
        c.rect(0, 0, 60, h, 0xBCCDD6)
        c.dot(46, h * 0.25, 6, 0xFAC775)
        c.rect(0, h * 0.6, 60, h * 0.4, 0x5E8C45)
        c.svgLine("M0 \(h * 0.75)L60 \(h * 0.7)M0 \(h * 0.9)L60 \(h * 0.84)", 0x4E7A3A, 1.6)
        c.svg("M14 \(h * 0.6)L17 \(h * 0.36)H21L24 \(h * 0.6)Z", 0x7A5230)
        c.svgLine("M19 \(h * 0.38)L9 \(h * 0.2)M19 \(h * 0.38)L31 \(h * 0.24)M19 \(h * 0.38)L23 \(h * 0.56)M19 \(h * 0.38)L13 \(h * 0.5)", 0xFFFDF6, 2)
    }

    // MARK: Styles

    /// The same tree painted three ways (132 × 84): true to life, in hard blocks, in dots.
    static func styles(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 132, height: 84))
        for i in 0..<3 {
            let x = CGFloat(i) * 44
            f.rect(x + 2, 4, 40, 54, 0x1E1E1C, radius: 1, 0.15)
            f.rect(x, 2, 40, 54, 0x8C6A4A, radius: 1)
            let c = f.within(CGRect(x: x + 3, y: 5, width: 34, height: 48))
            switch i {
            case 0:
                c.rect(0, 0, 34, 48, 0xBCCDD6)
                c.rect(0, 36, 34, 12, 0x8EB35E)
                c.rect(15, 24, 4, 14, 0x6B4A2E)
                c.dot(17, 18, 11, 0x5E8C45)
                c.dot(13, 15, 5, 0x6E9C52)
            case 1:
                c.rect(0, 0, 34, 48, 0xFAC775)
                c.rect(0, 36, 34, 12, 0x2F5BD3)
                c.rect(14, 24, 6, 14, 0x1E1E1C)
                c.svg("M5 26L17 4L29 26Z", 0x0F6E56)
                c.svg("M9 18H25V26H9Z", 0x1E9C8A)
                c.svgLine("M5 26L17 4L29 26M17 4V26", 0x1E1E1C, 1.2)
            default:
                c.rect(0, 0, 34, 48, 0xFFFDF6)
                for k in 0..<60 {
                    let a = Double(k) * 2.4, r = sqrt(Double(k)) * 1.45
                    c.dot(17 + cos(a) * r, 18 + sin(a) * r, 1.3, k % 3 == 0 ? 0x8EB35E : 0x3F8A4A)
                }
                for y in stride(from: 26.0, to: 38, by: 3) { c.dot(16, y, 1.2, 0x7A5230); c.dot(18.5, y + 1.5, 1.2, 0x7A5230) }
                for x in stride(from: 1.0, to: 34, by: 3.2) { c.dot(x, 42, 1.2, 0x5E8C45); c.dot(x + 1.6, 45, 1.2, 0xF2C230) }
            }
        }
        f.svgLine("M10 70H122", 0xB4B2A9, 1)
        for x in [20.0, 64, 108] as [CGFloat] { f.dot(x, 70, 2.4, 0xB4B2A9) }
    }

    // MARK: Standout

    /// Four small dull grey pictures and one big bright red one, with rays around it (122 × 84).
    static func standout(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 122, height: 84))
        for (x, y) in [(2.0, 14.0), (2, 50), (96, 14), (96, 50)] as [(CGFloat, CGFloat)] {
            f.rect(x, y, 24, 28, 0x8E9AA0, radius: 1)
            f.rect(x + 3, y + 3, 18, 22, 0xC9C4B8)
            f.svgLine("M\(x + 6) \(y + 18)L\(x + 12) \(y + 10)L\(x + 18) \(y + 18)", 0xA8A398, 1.2)
        }
        f.svgLine("M61 0V6M42 6L46 11M80 6L76 11M34 42H40M82 42H88M42 78L46 73M80 78L76 73", 0xF2711C, 2.2)
        f.rect(41, 13, 40, 58, 0xFAC775, radius: 1)
        f.rect(45, 17, 32, 50, 0xC8261B)
        f.dot(61, 36, 9, 0xF2711C)
        f.svg("M48 64L61 46L74 64Z", 0x9A1E15)
    }

    // MARK: Choose

    /// Three small framed pictures on a table (84 × 100); a hand points at the middle one, which
    /// gets a green tick.
    static func choose(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 100))
        f.rect(0, 62, 84, 6, 0x8C6A4A, radius: 1)
        f.rect(6, 68, 5, 32, 0x6B4A2E)
        f.rect(73, 68, 5, 32, 0x6B4A2E)
        let pictures: [(CGFloat, UInt32, UInt32)] = [(2, 0xBCCDD6, 0xFAC775), (30, 0xF4C0D1, 0xC8261B), (58, 0x8EB35E, 0xFFFDF6)]
        for (i, pic) in pictures.enumerated() {
            let lift: CGFloat = i == 1 ? -6 : 0
            f.rect(pic.0, 34 + lift, 24, 28, 0x1E1E1C, radius: 1)
            f.rect(pic.0 + 3, 37 + lift, 18, 22, pic.1)
            f.dot(pic.0 + 12, 48 + lift, 5, pic.2)
        }
        f.dot(56, 26, 7, 0x1E7A4C)
        f.svgLine("M52.5 26L55 28.5L59.5 23.5", 0xFFFDF6, 1.8)
        // pointing hand from above
        f.svgLine("M40 0L42 10", 0x2F5BD3, 8)
        f.svg("M36 12Q36 8 42 8Q48 9 47 14L44 18L43 24Q42 27 40.5 24L40 18Z", 0xE8C4A0)
    }
}
