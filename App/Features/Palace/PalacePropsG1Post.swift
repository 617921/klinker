import SwiftUI

/// Post-office things: a parcel in four ways (with its address label, fragile, going back, on
/// the scale), a sheet of stamps, the back of an envelope with the sender on the flap, a price list,
/// a registered letter being signed for, and a parcel handed across the counter.
enum G1Post {
    // MARK: Parcel

    /// A parcel standing on the floor (96 × 84). `accessory` "label" (an address label with
    /// `lines` and a barcode, string round it), "fragile" (a big label with a cracked glass,
    /// `text` under it), "return" (open, shoes inside, a big U-turn arrow, `text` on a tag).
    static func parcel(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 84))
        f.oval(6, 78, 84, 6, 0x1E1E1C, 0.15)
        switch p.accessory ?? "label" {
        case "fragile":
            G1Props.parcel(f, CGRect(x: 10, y: 26, width: 66, height: 54))
            f.rect(18, 32, 50, 42, 0xFFFDF6, radius: 2)
            f.stroke(Path(roundedRect: CGRect(x: 20, y: 34, width: 46, height: 38), cornerRadius: 1.5), 0xC8261B, 2)
            glass(f, x: 43, y: 36, cracked: true)
            if let text = p.text { f.text(text, PropFont.heavy(8), 0xC8261B, at: CGPoint(x: 43, y: 67), maxWidth: 44) }
            f.svgLine("M80 12L86 6M84 22L92 20M76 4L77 -2", 0xC8261B, 2)
        case "return":
            G1Props.parcel(f, CGRect(x: 8, y: 44, width: 62, height: 36))
            f.svg("M8 44L-2 30L20 30L30 44Z", 0xD9AE7A)
            f.svg("M70 44L82 32L58 32L48 44Z", 0xB98652)
            shoe(f, x: 18, y: 40)
            shoe(f, x: 38, y: 36)
            f.svgLine("M66 30C80 22 84 6 66 4C52 2 40 6 34 18", 0xF2711C, 5)
            f.svg("M24 14L33 26L42 16Z", 0xF2711C)
            if let text = p.text {
                f.rect(18, 56, 40, 14, 0xFFFDF6, radius: 1.5)
                f.text(text, PropFont.heavy(8.5), 0xF2711C, at: CGPoint(x: 38, y: 63), maxWidth: 36)
            }
        default:
            G1Props.parcel(f, CGRect(x: 10, y: 26, width: 66, height: 54))
            f.svgLine("M10 54H76M24 26L34 16", 0x8C5E38, 1.6)
            f.rect(32, 34, 40, 30, 0xFFFDF6, radius: 1.5)
            var y: CGFloat = 40
            for line in (p.lines ?? ["Noor", "Gracht 12"]).prefix(2) {
                f.text(line, PropFont.mono(7), 0x1E1E1C, at: CGPoint(x: 35, y: y), anchor: .leading, maxWidth: 34)
                y += 8
            }
            var bars = ""
            for (i, w) in [1.2, 0.6, 1.6, 0.8, 0.6, 1.4, 0.8, 1.2, 0.6, 1.6, 0.8].enumerated() { bars += "M\(36 + CGFloat(i) * 3) 56v6h\(w)v-6Z" }
            f.svg(bars, 0x1E1E1C)
            f.rect(14, 32, 12, 14, 0xF2711C, radius: 1)
            f.rect(16, 34, 8, 10, 0xFAC775, radius: 0.5)
        }
    }

    /// A wine glass (about 20 × 26) standing on (x, y + 26); `cracked` adds a zigzag crack.
    static func glass(_ f: PropPen, x: CGFloat, y: CGFloat, cracked: Bool) {
        f.svg("M\(x - 8) \(y)H\(x + 8)Q\(x + 8) \(y + 13) \(x) \(y + 14)Q\(x - 8) \(y + 13) \(x - 8) \(y)Z", 0xC8261B)
        f.line(x, y + 14, x, y + 22, 0xC8261B, 2.2)
        f.line(x - 6, y + 23, x + 6, y + 23, 0xC8261B, 2.4)
        if cracked { f.svgLine("M\(x - 2) \(y)L\(x + 2) \(y + 4)L\(x - 1) \(y + 7)L\(x + 2) \(y + 11)", 0xFFFDF6, 1.4) }
    }

    /// A trainer seen from the side, its toe pointing right, top-left at (x, y).
    private static func shoe(_ f: PropPen, x: CGFloat, y: CGFloat) {
        f.svg("M\(x) \(y + 10)V\(y)H\(x + 8)L\(x + 12) \(y + 5)L\(x + 20) \(y + 7)Q\(x + 24) \(y + 8) \(x + 24) \(y + 12)H\(x)Z", 0x2F5BD3)
        f.rect(x, y + 10, 24, 3, 0xFFFDF6, radius: 1)
        f.svgLine("M\(x + 9) \(y + 3)L\(x + 13) \(y + 6)", 0xFFFDF6, 1)
    }

    // MARK: Scale

    /// A parcel on a flat post scale (82 × 60), the weight (`text`) big on its display.
    static func scale(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 82, height: 60))
        f.oval(2, 55, 78, 5, 0x1E1E1C, 0.15)
        f.svg("M2 50H58L56 57H4Z", 0x5E6B73)
        f.rect(0, 46, 60, 5, 0xB4B2A9, radius: 1.5)
        G1Props.parcel(f, CGRect(x: 10, y: 24, width: 34, height: 22), 0xC9965F)
        f.svgLine("M58 50H64V24", 0x3E4C55, 2.4)
        f.rect(52, 6, 30, 22, 0x3E4C55, radius: 3)
        f.rect(55, 9, 24, 16, 0xC9E6E2, radius: 1.5)
        f.text(p.text ?? "2,4 kg", PropFont.heavy(9.5), 0x04342C, at: CGPoint(x: 67, y: 17.5), maxWidth: 22)
        f.svgLine("M48 30L52 26", 0x8C9499, 1.2)
        f.svgLine("M20 18V12M27 16V10M34 18V12", 0x1E1E1C, 1.4)
        f.svg("M17 12L20 8L23 12Z M24 10L27 6L30 10Z M31 12L34 8L37 12Z", 0x1E1E1C)
    }

    // MARK: Stamps

    /// A sheet of six stamps (112 × 58) with perforated edges, a tulip and the value `text`; the
    /// last one is peeling off.
    static func stamps(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 58))
        f.rect(1.5, 2.5, 106, 54, 0x1E1E1C, radius: 2, 0.14)
        f.rect(0, 0, 106, 54, 0xF4F1EA, radius: 2)
        for i in 0..<6 {
            let x = 5 + CGFloat(i % 3) * 32, y = 4 + CGFloat(i / 3) * 24
            if i == 5 {
                var s = f
                s.ctx.translateBy(x: x + 20, y: y + 8)
                s.ctx.rotate(by: .radians(0.32))
                stamp(s, x: -14, y: -10, value: p.text ?? "1")
                f.rect(x, y, 28, 21, 0xE2DED3, radius: 1)
            } else {
                stamp(f, x: x, y: y, value: p.text ?? "1")
            }
        }
    }

    private static func stamp(_ f: PropPen, x: CGFloat, y: CGFloat, value: String) {
        f.rect(x + 0.6, y + 1, 28, 21, 0x1E1E1C, radius: 0, 0.12)
        f.rect(x, y, 28, 21, 0xFFFDF6)
        for k in 0..<7 {
            f.dot(x + 2 + CGFloat(k) * 4, y, 1.1, 0xF4F1EA)
            f.dot(x + 2 + CGFloat(k) * 4, y + 21, 1.1, 0xF4F1EA)
        }
        f.rect(x + 2.5, y + 2.5, 23, 16, 0xF2711C)
        f.svgLine("M\(x + 11) \(y + 17)Q\(x + 12) \(y + 11) \(x + 11) \(y + 8)", 0x0F6E56, 1.4)
        f.svg("M\(x + 7.5) \(y + 5)L\(x + 9.5) \(y + 8)L\(x + 11) \(y + 4.5)L\(x + 12.5) \(y + 8)L\(x + 14.5) \(y + 5)V\(y + 9)Q\(x + 11) \(y + 12) \(x + 7.5) \(y + 9)Z", 0xC8261B)
        f.text(value, PropFont.heavy(9), 0xFFFDF6, at: CGPoint(x: x + 20.5, y: y + 8))
    }

    // MARK: Envelope back

    /// The back of an envelope (112 × 58): the flap, and on it the sender's little house, a person
    /// and the name and street (`lines`) in blue handwriting, ringed in orange.
    static func envelopeBack(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 58))
        f.rect(1.5, 2.5, 108, 54, 0x1E1E1C, radius: 2, 0.15)
        f.rect(0, 0, 108, 54, 0xF6F3EA, radius: 2)
        f.svgLine("M1 53L44 26M107 53L64 26", 0xE2DED3, 1.2)
        f.svg("M0 1H108L54 34Z", 0xE9E4D6)
        f.svgLine("M1 1L54 34L107 1", 0xD3D1C7, 1.2)
        let box = CGRect(x: 28, y: 4, width: 52, height: 22)
        f.rect(box, 0xFFFDF6, radius: 2)
        f.stroke(Path(roundedRect: box.insetBy(dx: -2, dy: -2), cornerRadius: 4), 0xF2711C, 2)
        G1Props.house(f, 31, 23, w: 9, 0x2F5BD3, roof: 0x2F5BD3)
        var y: CGFloat = 10
        for line in (p.lines ?? ["Noor", "Gracht 12"]).prefix(2) {
            f.text(line, PropFont.demi(8), 0x2F5BD3, at: CGPoint(x: 44, y: y), anchor: .leading, maxWidth: 34)
            y += 9
        }
        f.svgLine("M84 15H100", 0xF2711C, 2.2)
        f.svg("M98 10L106 15L98 20Z", 0xF2711C)
    }

    // MARK: Price list

    /// A price list (96 × 66): a header with a delivery van and `caption`, then rows `lines`
    /// "letter|€ 1,15", "box|…", "bigBox|…" with a little picture each.
    static func rateBoard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 66))
        let r = G1BankPosters.frame(f, 96, 66, border: 0x9A3A2A)
        f.rect(r.minX, r.minY, r.width, 13, 0x9A3A2A)
        van(f, x: r.minX + 4, y: r.minY + 2)
        if let caption = p.caption { f.text(caption, PropFont.heavy(8), 0xFFFDF6, at: CGPoint(x: r.midX + 10, y: r.minY + 6.5), maxWidth: 52) }
        var y = r.minY + 16
        for row in (p.lines ?? []).prefix(3) {
            let cells = row.split(separator: "|", omittingEmptySubsequences: false).map(String.init)
            switch cells[0] {
            case "letter":
                f.rect(r.minX + 6, y + 3, 16, 10, 0xF6F3EA)
                f.svgLine("M\(r.minX + 6) \(y + 3)L\(r.minX + 14) \(y + 9)L\(r.minX + 22) \(y + 3)", 0xB4B2A9, 1)
                f.stroke(Path(CGRect(x: r.minX + 6, y: y + 3, width: 16, height: 10)), 0xB4B2A9, 0.8)
            case "bigBox": G1Props.parcel(f, CGRect(x: r.minX + 5, y: y + 3, width: 17, height: 11))
            default: G1Props.parcel(f, CGRect(x: r.minX + 8, y: y + 6, width: 11, height: 8))
            }
            if cells.count > 1 {
                f.text(cells[1], PropFont.heavy(10), 0x1E1E1C, at: CGPoint(x: r.maxX - 4, y: y + 8.5), anchor: .trailing, maxWidth: 48)
            }
            f.line(r.minX + 4, y + 16, r.maxX - 4, y + 16, 0xE2DED3, 1)
            y += 15.5
        }
    }

    /// A little delivery van (about 22 × 10), top-left at (x, y).
    static func van(_ f: PropPen, x: CGFloat, y: CGFloat) {
        f.rect(x, y, 14, 8, 0xFFFDF6, radius: 1)
        f.svg("M\(x + 14) \(y + 2)H\(x + 18)L\(x + 21) \(y + 5)V\(y + 8)H\(x + 14)Z", 0xFFFDF6)
        f.dot(x + 4, y + 8.5, 1.8, 0x1E1E1C)
        f.dot(x + 17, y + 8.5, 1.8, 0x1E1E1C)
    }
}
