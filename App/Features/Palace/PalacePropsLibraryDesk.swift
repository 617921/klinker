import SwiftUI

/// More library props: a return slot in the wall, a sign-up clipboard, a catalogue screen with
/// green and red dots, and a tablet with an e-book.
enum PalaceLibraryDeskProps {
    // MARK: Return slot

    /// A slot in the wall (100 × 70) with a book going in, pushed by a hand, a green arrow into it.
    /// `accessory` "letter" posts a letter instead of a book.
    static func returnSlot(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 70))
        f.rect(10, 3, 80, 44, 0x1E1E1C, radius: 5, 0.14)
        f.rect(8, 1, 80, 44, 0x5E6B73, radius: 5)
        f.rect(12, 5, 72, 36, 0x7D8A92, radius: 3)
        for (x, y) in [(14.0, 7.0), (82.0, 7.0), (14.0, 39.0), (82.0, 39.0)] { f.dot(x, y, 1.4, 0x3E4C55) }
        f.rect(22, 25, 52, 10, 0x1E1E1C, radius: 2)
        f.svg("M22 25H74L71 19H25Z", 0xB4B2A9)
        f.svg("M22 25H74L73.5 23H22.5Z", 0x3E4C55)
        PalaceIcon.book.draw(f, in: CGRect(x: 31, y: 4, width: 15, height: 15), color: 0xFFFDF6, detail: 0x7D8A92)
        f.svgLine("M52 8Q60 8 60 12Q60 16 52 16H49M51.5 13.5L49 16L51.5 18.5", 0xFFFDF6, 1.6)
        // The thing going in, half through the slot, pushed by a hand.
        if p.accessory == "letter" {
            f.svg("M32 32H62L64 54H34Z", 0xFFFDF6)
            f.svgLine("M34 32L47 42L62 32", 0xB4B2A9, 1.2)
        } else {
            f.svg("M30 32H64L67 54H33Z", 0xC8261B)
            f.svg("M30 32H33L36 54H33Z", 0x8A1B12)
            f.svg("M64 32H66.5L69.5 53H67Z", 0xEFEBE2)
            f.rect(40, 39, 18, 5, 0xFAC775, radius: 1)
        }
        f.svg("M38 52C38 49 44 48 50 49L60 50C64 51 64 55 60 56L42 58C39 58 38 55 38 52Z", 0xC99A74)
        f.svg("M36 70L39 56H61L64 70Z", 0x3C3489)
        f.svgLine("M88 62Q97 44 82 32", 0x1E7A4C, 3.2)
        f.svgLine("M80 39L82 31L89.5 34.5", 0x1E7A4C, 3.2)
    }

    // MARK: Clipboard

    /// A clipboard (70 × 80): `caption` on top, numbered names `lines`, a hand writing the last one.
    static func clipboard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 70, height: 80))
        let hand: Font = .custom("Noteworthy-Bold", fixedSize: 7.5)
        f.rect(8, 6, 56, 74, 0x1E1E1C, radius: 3, 0.14)
        f.rect(6, 4, 56, 74, 0x9A6A42, radius: 3)
        f.rect(10, 10, 48, 64, 0xFFFDF6)
        f.rect(22, 1, 24, 11, 0x5E6B73, radius: 2)
        f.rect(28, 3.5, 12, 3, 0x3E4C55, radius: 1.5)
        var y: CGFloat = 18
        if let caption = p.caption {
            f.text(caption, PropFont.heavy(7.5), 0x1F3A6B, at: CGPoint(x: 34, y: y), maxWidth: 44)
            f.line(14, y + 5, 54, y + 5, 0x1F3A6B, 1)
            y += 11
        }
        let lines = Array((p.lines ?? []).prefix(5))
        for (i, line) in lines.enumerated() {
            let ly = y + CGFloat(i) * 9.5
            f.line(14, ly + 4, 54, ly + 4, 0xD3D1C7, 0.8)
            f.text(line, hand, 0x2F5BD3, at: CGPoint(x: 14, y: ly), anchor: .leading, maxWidth: 40)
        }
        let end = y + CGFloat(max(lines.count - 1, 0)) * 9.5
        let lastW = lines.last.map { min(40, f.width(of: $0, hand)) } ?? 10
        let tip = CGPoint(x: 15 + lastW, y: end + 2)
        f.line(tip.x, tip.y, tip.x + 14, tip.y - 14, 0x1E1E1C, 2.4)
        f.line(tip.x, tip.y, tip.x + 2, tip.y - 2, 0xC9A15B, 1.6)
        f.svg("M\(tip.x + 6) \(tip.y - 4)C\(tip.x + 6) \(tip.y - 9) \(tip.x + 14) \(tip.y - 11) \(tip.x + 18) \(tip.y - 8)L\(tip.x + 22) \(tip.y - 2)C\(tip.x + 20) \(tip.y + 4) \(tip.x + 10) \(tip.y + 4) \(tip.x + 6) \(tip.y - 4)Z", 0xE8C4A0)
        f.svg("M\(tip.x + 17) \(tip.y - 7)L\(tip.x + 30) \(tip.y + 6)L\(tip.x + 24) \(tip.y + 12)L\(tip.x + 14) \(tip.y + 1)Z", 0x0F6E56)
    }

    // MARK: Catalogue screen

    /// A catalogue screen (92 × 62): a search bar and rows "title|ok" (green dot and tick) or
    /// "title|no" (red dot and cross); `highlight` row tinted. `mount` "hang" or a desk stand.
    static func catalog(_ pen: PropPen, _ p: PalacePropParams) {
        let hang = p.mount == "hang"
        let f = pen.fitted(CGSize(width: 92, height: 62), hanging: hang)
        if hang {
            f.line(20, 0, 20, 6, 0x2E2117, 2)
            f.line(72, 0, 72, 6, 0x2E2117, 2)
        } else {
            f.rect(34, 57, 24, 5, 0x2E2117, radius: 1.5)
            f.rect(43, 48, 6, 10, 0x3E4C55)
        }
        let top: CGFloat = hang ? 5 : 0
        f.rect(0, top, 92, 50, 0x2E2117, radius: 4)
        f.rect(3.5, top + 3.5, 85, 43, 0xFFFDF6, radius: 1.5)
        f.rect(7, top + 6.5, 78, 8, 0xE2DED3, radius: 4)
        f.ring(12, top + 10.1, 2.3, 0x5E6B73, 1.2)
        f.line(13.6, top + 11.7, 15.4, top + 13.5, 0x5E6B73, 1.2)
        let rows = Array((p.lines ?? []).prefix(2))
        let colours: [UInt32] = [0x2F5BD3, 0xA3410A]
        for (i, row) in rows.enumerated() {
            let cells = row.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
            let y = top + 17 + CGFloat(i) * 14
            let ok = cells.count > 1 && cells[1] == "ok"
            if i == p.highlight { f.rect(4.5, y, 83, 13, ok ? 0xE2F4EA : 0xFDECEA, radius: 1) }
            f.rect(8, y + 2, 7, 9.5, colours[i % 2], radius: 0.8)
            f.rect(8, y + 2, 1.6, 9.5, PalaceInk.shade(colours[i % 2], 0.7))
            f.text(cells.first ?? "", PropFont.demi(9), 0x1E1E1C, at: CGPoint(x: 18, y: y + 6.7), anchor: .leading, maxWidth: 50)
            f.dot(79, y + 6.5, 5.5, ok ? 0x1E7A4C : 0xC8261B)
            let mark = f.within(CGRect(x: 73, y: y + 0.5, width: 12, height: 12))
            mark.svgLine(ok ? "M3.2 6.2L5.2 8.2L8.6 4" : "M3.8 3.8L8.2 8.2M8.2 3.8L3.8 8.2", 0xFFFDF6, 1.6)
        }
    }

    // MARK: Tablet

    /// A tablet on a little table (72 × 104) with an e-book page, `text` on top of the screen, a
    /// progress bar, wifi waves and a few bits (0 1) floating up.
    static func tablet(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 72, height: 104))
        f.oval(12, 99, 48, 5, 0x1E1E1C, 0.14)
        f.rect(33, 86, 6, 14, 0x6B4A2E)
        f.rect(24, 98, 24, 3, 0x4A3524, radius: 1)
        f.rect(8, 82, 56, 5, 0xC9965F, radius: 2)
        f.svg("M24 82L36 74L48 82Z", 0x3E4C55)
        f.svg("M14 18Q14 14 18 14H54Q58 14 58 18V78Q58 82 54 82H18Q14 82 14 78Z", 0x2E2117)
        let s = CGRect(x: 18, y: 19, width: 36, height: 56)
        f.rect(s, 0xFFFDF6, radius: 1)
        f.rect(s.minX, s.minY, s.width, 8, 0x1F3A6B, radius: 1)
        if let label = p.text {
            f.text(label, PropFont.heavy(6.5), 0xFFFDF6, at: CGPoint(x: s.minX + 2.5, y: s.minY + 4), anchor: .leading, maxWidth: 24)
        }
        f.svgLine("M48.5 23.2Q50.3 21.6 52 23.2M47.2 21.8Q50.3 19 53.4 21.8", 0xFFFDF6, 0.9)
        f.dot(50.3, 24.4, 0.8, 0xFFFDF6)
        for k in 0..<7 {
            let y = s.minY + 13 + CGFloat(k) * 5.2
            f.line(s.minX + 4, y, s.maxX - (k == 6 ? 14 : 4), y, 0xB4B2A9, 1.6)
        }
        f.rect(s.minX + 4, s.maxY - 6, 28, 2, 0xE2DED3, radius: 1)
        f.rect(s.minX + 4, s.maxY - 6, 11, 2, 0x2F5BD3, radius: 1)
        f.dot(36, 79, 1.2, 0x5E6B73)
        // Wifi and bits floating up.
        f.svgLine("M26 9Q36 1 46 9M30 12Q36 7 42 12", 0x2F5BD3, 2)
        f.dot(36, 14.5, 1.8, 0x2F5BD3)
        for (digit, x, y) in [("1", 9.0, 22.0), ("0", 5.0, 40.0), ("1", 64.0, 30.0), ("0", 66.0, 50.0)] {
            f.text(digit, PropFont.mono(9), 0x2F5BD3, at: CGPoint(x: x, y: y))
        }
    }
}
