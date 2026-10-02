import SwiftUI

/// Bank screens and a year of months: an account overview, a transfer from one person to another,
/// and twelve month pages with the same coin on every first day.
enum G1BankScreens {
    // MARK: Banking app

    /// A banking screen (110 × 74). `mount` "hang" (rods from the ceiling, default) or "stand" (a
    /// tablet on a little stand). `accessory` "account": a header with a person and the account
    /// number (`caption`), then rows `lines` "label|+12,50" (+ green, else red); "transfer": two
    /// people, `lines` [from, to], a green arrow between them with a coin and `text`.
    static func app(_ pen: PropPen, _ p: PalacePropParams) {
        let stand = p.mount == "stand"
        let f = pen.fitted(CGSize(width: 110, height: stand ? 84 : 74))
        if stand {
            f.oval(30, 79, 50, 5, 0x1E1E1C, 0.15)
            f.svg("M48 62H62L66 80H44Z", 0x3E4C55)
        } else {
            f.line(22, 0, 22, 8, 0x2E2117, 2)
            f.line(88, 0, 88, 8, 0x2E2117, 2)
        }
        let top: CGFloat = stand ? 0 : 6
        f.rect(0, top, 110, 68, 0x2E2117, radius: 5)
        let screen = CGRect(x: 4, y: top + 4, width: 102, height: 60)
        f.rect(screen, 0xFFFDF6, radius: 2)
        if p.accessory == "transfer" { transfer(f, p, in: screen) } else { account(f, p, in: screen) }
    }

    private static func account(_ f: PropPen, _ p: PalacePropParams, in r: CGRect) {
        f.rect(r.minX, r.minY, r.width, 17, 0x1F3A6B, radius: 2)
        f.dot(r.minX + 9, r.minY + 6.5, 3.2, 0xFFFDF6)
        f.svg("M\(r.minX + 3.5) \(r.minY + 15)Q\(r.minX + 9) \(r.minY + 8) \(r.minX + 14.5) \(r.minY + 15)Z", 0xFFFDF6)
        f.text(p.caption ?? "NL12 BANK 0345 6789", PropFont.mono(8), 0xFFFDF6, at: CGPoint(x: r.minX + 19, y: r.minY + 8.5),
               anchor: .leading, maxWidth: r.width - 22)
        var y = r.minY + 21
        for row in (p.lines ?? []).prefix(2) {
            let cells = row.split(separator: "|", omittingEmptySubsequences: false).map(String.init)
            let amount = cells.count > 1 ? cells[1] : ""
            let plus = amount.hasPrefix("+")
            f.dot(r.minX + 6, y + 6, 2.4, plus ? 0x1E7A4C : 0xC8261B)
            f.text(cells[0], PropFont.demi(9), 0x1E1E1C, at: CGPoint(x: r.minX + 11, y: y + 6), anchor: .leading, maxWidth: 46)
            f.text(amount, PropFont.heavy(9.5), plus ? 0x1E7A4C : 0xC8261B, at: CGPoint(x: r.maxX - 4, y: y + 6), anchor: .trailing, maxWidth: 46)
            f.line(r.minX + 4, y + 13, r.maxX - 4, y + 13, 0xE2DED3, 1)
            y += 15
        }
    }

    private static func transfer(_ f: PropPen, _ p: PalacePropParams, in r: CGRect) {
        let names = p.lines ?? ["Noor", "Sam"]
        let looks = [PalaceFigures.Look.at(5), PalaceFigures.Look.at(1)]
        for (i, x) in [r.minX + 16, r.maxX - 16].enumerated() {
            let v = looks[i]
            f.dot(x, r.minY + 22, 13, i == 0 ? 0xE9E4F4 : 0xDDEFE9)
            f.svg("M\(x - 9) \(r.minY + 34)Q\(x) \(r.minY + 22) \(x + 9) \(r.minY + 34)Z", v.coat)
            f.dot(x, r.minY + 19, 5.2, v.skin)
            f.svg("M\(x - 5.4) \(r.minY + 18.5)C\(x - 5.4) \(r.minY + 13) \(x + 5.4) \(r.minY + 13) \(x + 5.4) \(r.minY + 18.5)C\(x + 3) \(r.minY + 16) \(x - 3) \(r.minY + 16) \(x - 5.4) \(r.minY + 18.5)Z", v.hair)
            if i < names.count {
                f.text(names[i], PropFont.heavy(9), 0x1E1E1C, at: CGPoint(x: x, y: r.maxY - 8), maxWidth: 30)
            }
        }
        f.svgLine("M\(r.minX + 32) \(r.minY + 24)H\(r.maxX - 36)", 0x1E7A4C, 3)
        f.svg("M\(r.maxX - 38) \(r.minY + 18)L\(r.maxX - 30) \(r.minY + 24)L\(r.maxX - 38) \(r.minY + 30)Z", 0x1E7A4C)
        G1Props.coin(f, r.midX, r.minY + 24, 7)
        f.text(p.text ?? "€ 50", PropFont.heavy(10), 0x1E7A4C, at: CGPoint(x: r.midX, y: r.minY + 42), maxWidth: 40)
    }

    // MARK: Months

    /// Twelve month pages in two rows (112 × 58), each with a gold coin on its first day; `caption`
    /// (a year) on a small tab above them.
    static func monthStrip(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 58))
        f.rect(1.5, 2, 112, 58, 0x1E1E1C, radius: 2, 0.14)
        f.rect(0, 0, 110, 56, 0xFFFDF6, radius: 2)
        if let caption = p.caption {
            f.rect(38, -1, 34, 10, 0x1F3A6B, radius: 2)
            f.text(caption, PropFont.heavy(7.5), 0xFFFDF6, at: CGPoint(x: 55, y: 4), maxWidth: 30)
        }
        for i in 0..<12 {
            let x = 4 + CGFloat(i % 6) * 17.5, y = 10 + CGFloat(i / 6) * 23
            f.rect(x, y, 15.5, 20, 0xF4F1EA, radius: 1)
            f.stroke(Path(roundedRect: CGRect(x: x, y: y, width: 15.5, height: 20), cornerRadius: 1), 0xD3D1C7, 0.8)
            f.rect(x, y, 15.5, 4.5, 0xC8261B, radius: 1)
            for r in 0..<3 {
                for c in 0..<3 where r + c > 0 { f.rect(x + 2 + CGFloat(c) * 4.4, y + 7 + CGFloat(r) * 4.2, 2.6, 2.4, 0xD3D1C7) }
            }
            G1Props.coin(f, x + 3.6, y + 8.6, 3.2)
        }
    }
}
