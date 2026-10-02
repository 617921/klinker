import SwiftUI

/// People who hold the thing that makes their word (keys, a tray, a badge, their own mug),
/// and a phone in a hand. Same build and colours as `PalaceFigures.person`.
enum PalacePeople {
    typealias Look = PalaceFigures.Look

    /// A standing person (64 × 114) facing right; `accessory` decides what the front hand holds.
    /// "stool" seats them at the bar with their own mug (`text` = the name on it).
    static func holding(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 64, height: 114))
        let v = Look.at(p.variant ?? 0)
        let accessory = p.accessory ?? "keys"
        if accessory == "stool" { return seated(f, v, name: p.text ?? "") }
        let waiter = accessory == "tray"
        let coat = waiter ? 0x2E2117 : v.coat
        let sleeve = waiter ? 0xF4F1EA : coat
        let dark = PalaceInk.shade(coat, 0.78)
        f.oval(6, 106, 56, 6, 0x1E1E1C, 0.16)
        f.svgLine("M17 84V104M27 84V104", v.trousers, 5)
        f.svg("M12 103H21V108H12Z M23 103H32V108H23Z", 0x2E2117)
        f.svg("M9 88L10.5 44C11.5 36 15.5 32 22 32C28.5 32 32.5 36 33.5 44L35 88Z", coat)
        f.svg("M17 32L22 39L27 32Z", 0xFFFDF6)
        switch accessory {
        case "tray":
            f.svg("M9.5 60H34.5L36.5 98H7.5Z", 0xF4F1EA)
            f.svgLine("M9.5 60H34.5", 0xD3D1C7, 1.4)
            f.svg("M18.5 34.5L22 37L25.5 34.5V39.5L22 37L18.5 39.5Z", 0x1E1E1C)
        case "badge":
            f.svgLine("M22 40V86", dark, 1.2)
            f.svgLine("M17.5 33L20.5 50M26.5 33L23.5 50", 0xC8261B, 1.6)
            f.rect(15.5, 49, 13, 16, 0xFFFDF6, radius: 1.5)
            f.svg(star(cx: 22, cy: 56, r: 5), 0xF2711C)
            f.rect(18, 62, 8, 1.4, 0xB4B2A9)
        default:
            f.svgLine("M22 40V86", dark, 1.2)
            f.svg("M20.4 36H23.6L24.6 52L22 55L19.4 52Z", 0xC8261B)
            f.dot(24.5, 64, 1.3, dark)
            f.dot(24.5, 74, 1.3, dark)
        }
        // Back arm, head
        f.svgLine("M13 42C10 52 10 62 12 70", waiter ? sleeve : dark, 6)
        f.dot(12.5, 72, 3.1, v.skin)
        if waiter { f.svg("M8 60H17L16 74H9Z", 0xFFFDF6) }
        f.dot(22, 19, 11, v.skin)
        f.svg("M11 18C10 10 15 6 22 6C29 6 34 10 33 18C31 13 27 11.5 22 11.5C17 11.5 13 13 11 18Z", v.hair)
        f.dot(28, 19.5, 1.3, 0x2E2117)
        f.svgLine("M27 25Q29.5 26 31 24.5", 0x8C5A3C, 1.1)
        switch accessory {
        case "tray":
            f.svgLine("M31 42L41 47L46 35", sleeve, 6)
            f.dot(46.5, 33, 3.2, v.skin)
            f.oval(30, 29, 34, 6, 0x9A9A92)
            f.oval(30, 28, 34, 5, 0xD3D1C7)
            for (x, hgt) in [(35.0, 14.0), (45.0, 17.0), (55.0, 14.0)] as [(CGFloat, CGFloat)] {
                f.svg("M\(x) \(30.5 - hgt)H\(x + 7)L\(x + 6.2) 30.5H\(x + 0.8)Z", 0xF2B33D)
                f.rect(x - 0.4, 28 - hgt, 7.8, 4, 0xFFFDF6, radius: 1.6)
            }
        case "badge":
            f.svgLine("M31 41C37 44 42 42 45 36", coat, 6)
            f.dot(45.5, 34, 3.2, v.skin)
            bigKey(f, x: 47, y: 12)
        default:
            f.svgLine("M31 41C37 44 42 44 46 38", coat, 6)
            f.dot(46.5, 36.5, 3.2, v.skin)
            f.ring(47.5, 42.5, 3, 0x5E6B73, 1.4)
            f.svgLine("M46 45L43.5 57M43.5 51H41.5M43 54H41", 0xC9A15B, 2)
            f.svgLine("M49 45.5L51 52", 0x5E6B73, 1.2)
            f.svg("M51.5 50L58 55.5H56.2V63H46.8V55.5H45Z", 0xC8261B)
            f.rect(50.2, 58, 3, 5, 0xFFFDF6)
        }
    }

    /// A five-pointed star path.
    static func star(cx: CGFloat, cy: CGFloat, r: CGFloat) -> String {
        var d = ""
        for k in 0..<10 {
            let a = Double(k) * .pi / 5 - .pi / 2
            let rr = k % 2 == 0 ? r : r * 0.45
            d += (k == 0 ? "M" : "L") + String(format: "%.2f %.2f", cx + cos(a) * rr, cy + sin(a) * rr)
        }
        return d + "Z"
    }

    /// A big old key held upright, its bow at the top.
    private static func bigKey(_ f: PropPen, x: CGFloat, y: CGFloat) {
        f.ring(x, y + 5, 5, 0xC9A15B, 2.6)
        f.rect(x - 1.4, y + 9.5, 2.8, 20, 0xC9A15B, radius: 1)
        f.rect(x + 1, y + 23, 5, 2.6, 0xC9A15B)
        f.rect(x + 1, y + 27, 3.6, 2.6, 0xC9A15B)
    }

    /// A regular on a bar stool (64 × 114 design), cap on, his own mug with his name.
    private static func seated(_ f: PropPen, _ v: Look, name: String) {
        let dark = PalaceInk.shade(v.coat, 0.78)
        f.oval(8, 108, 50, 5, 0x1E1E1C, 0.16)
        f.svgLine("M18 77L14 110M40 77L44 110", 0x2E2117, 2.6)
        f.svgLine("M16 96H42", 0x5E6B73, 2)
        f.svgLine("M24 74H42L41 96", v.trousers, 7)
        f.svg("M37 94H48Q50 94 50 97V99H37Z", 0x2E2117)
        f.oval(12, 72, 34, 7, 0x7A1E1E)
        f.svg("M12 76L13 44C14 36 17 32 23 32C29 32 33 36 34 44L36 76Z", v.coat)
        f.svgLine("M23 40V74", dark, 1.2)
        f.svgLine("M14 42C11 52 12 62 16 66", dark, 6)
        f.dot(23, 19, 11, v.skin)
        f.svg("M12 20C11 16 12 14 13 13H33C34 14 35 16 34 20C32 17 28 16 23 16C18 16 14 17 12 20Z", 0xD3D1C7)
        f.svg("M11.5 13.5C12 6 17 4.5 23 4.5C29 4.5 34 6 34.5 12.5L38 14L11.5 15Z", 0x5E6B73)
        f.dot(29, 19.5, 1.3, 0x2E2117)
        f.svgLine("M27.5 24.5Q30 23 32.5 24.5", 0xD3D1C7, 2.2)
        f.svgLine("M31 42C35 50 39 54 44 56", v.coat, 6)
        f.dot(45, 56, 3.2, v.skin)
        let mug = CGRect(x: 43, y: 40, width: 20, height: 24)
        f.svgLine("M\(mug.minX + 1) \(mug.minY + 6)H\(mug.minX - 3)V\(mug.maxY - 7)H\(mug.minX + 1)", 0xD9CDB4, 2.6)
        f.rect(mug, 0xF4F1EA, radius: 2.5)
        f.rect(mug.minX, mug.minY + 3, mug.width, 3, 0x1F3A6B)
        f.rect(mug.minX, mug.maxY - 5, mug.width, 2, 0x1F3A6B)
        f.rect(mug.minX - 0.5, mug.minY - 2.5, mug.width + 1, 4, 0xFFFDF6, radius: 2)
        f.text(name, PropFont.heavy(7.5), 0x1F3A6B, at: CGPoint(x: mug.midX, y: mug.midY + 1.5), maxWidth: mug.width - 2)
    }
}

/// A phone in a hand: a chat whose bubbles pop out of it, or a call with a picture on the screen.
enum PalacePhone {
    static func draw(_ pen: PropPen, _ p: PalacePropParams) {
        if let lines = p.lines, !lines.isEmpty { chat(pen, lines) } else { call(pen, p) }
    }

    private static let skin: UInt32 = 0xC99A74

    /// Chat: a small phone low on the left, bubbles ("in|…" grey, "out|…" green) above it.
    static func chat(_ pen: PropPen, _ lines: [String]) {
        let f = pen.fitted(CGSize(width: 104, height: 86))
        f.svg("M8 86L9 66Q10 60 16 60H24V86Z", skin)
        f.rect(10, 40, 28, 46, 0x1E1E1C, radius: 5)
        f.rect(12.5, 45, 23, 34, 0xF4F1EA, radius: 1.5)
        f.rect(14.5, 48, 13, 4.5, 0xD3D1C7, radius: 2.2)
        f.rect(20.5, 55, 13, 4.5, 0x5DCAA5, radius: 2.2)
        f.rect(14.5, 62, 10, 4.5, 0xD3D1C7, radius: 2.2)
        f.svg("M7 70Q9 62 15 64L14 69Q11 69 10 74Z", skin)
        for y in [58.0, 64.5, 71] as [CGFloat] { f.rect(35.5, y, 5.5, 5, skin, radius: 2.4) }
        var y: CGFloat = 1
        for line in lines.prefix(3) {
            let cells = line.split(separator: "|", omittingEmptySubsequences: false).map(String.init)
            let out = cells.first == "out"
            let text = cells.count > 1 ? cells[1] : cells[0]
            let font = PropFont.demi(11)
            let tw = min(f.width(of: text, font) + 14, 70)
            let x: CGFloat = out ? 103 - tw : 30
            let bubble = CGRect(x: x, y: y, width: tw, height: 19)
            f.rect(bubble.offsetBy(dx: 1, dy: 1.5), 0x1E1E1C, radius: 7, 0.12)
            f.rect(bubble, out ? 0x5DCAA5 : 0xFFFDF6, radius: 7)
            let tail = out ? "M\(bubble.maxX - 9) \(bubble.maxY - 1)L\(bubble.maxX - 2) \(bubble.maxY + 4)L\(bubble.maxX - 3) \(bubble.maxY - 6)Z"
                : "M\(bubble.minX + 9) \(bubble.maxY - 1)L\(bubble.minX + 2) \(bubble.maxY + 4)L\(bubble.minX + 3) \(bubble.maxY - 6)Z"
            f.svg(tail, out ? 0x5DCAA5 : 0xFFFDF6)
            if !out { f.stroke(Path(roundedRect: bubble, cornerRadius: 7), 0xB4B2A9, 0.8) }
            f.text(text, font, 0x1E1E1C, at: CGPoint(x: bubble.midX, y: bubble.midY + 0.5), maxWidth: tw - 8)
            y += 24
        }
    }

    /// Call: a big phone in a hand, `time` on top, the picture (`icons`) in a circle, a green call button.
    static func call(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 56, height: 86))
        f.svg("M4 86L5 64Q6 58 12 58H22V86Z", skin)
        f.rect(8, 4, 38, 74, 0x1E1E1C, radius: 7)
        f.rect(10.5, 10, 33, 60, 0x232B3B, radius: 2)
        f.rect(22, 6.4, 10, 1.6, 0x3E4C55, radius: 0.8)
        if let time = p.time {
            f.text(time, PropFont.mono(9.5), 0xF4F1EA, at: CGPoint(x: 27, y: 17))
        }
        f.dot(27, 36, 12, 0xFFFDF6)
        if let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first {
            icon.draw(f, in: CGRect(x: 18, y: 27, width: 18, height: 18), color: 0xC8261B, detail: 0xFFFDF6)
        }
        f.dot(27, 60, 6, 0x1E7A4C)
        f.svgLine("M23.6 58.6Q24.5 63.4 30.4 62.2", 0xFFFDF6, 2.4)
        f.svgLine("M50 12Q54 17 50 22M53 9Q59 17 53 25", 0x1E7A4C, 1.6)
        f.svg("M3 68Q5 60 11 62L10 67Q7 67 6 72Z", skin)
        for y in [56.0, 62.5, 69] as [CGFloat] { f.rect(43.5, y, 5.5, 5, skin, radius: 2.4) }
    }
}
