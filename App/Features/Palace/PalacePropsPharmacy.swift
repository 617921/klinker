import SwiftUI

/// Pharmacy props: medicines, the leaflet, a measuring cup, the insurance card and its refund,
/// the open rack and the empty breakfast plate. Each draws at a design size and scales to its frame.
enum PalacePharmacy {
    /// An amber pill jar with capsules and tablets spilling out (76 × 50).
    static func pillJar(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        f.oval(2, 46, 72, 4, 0x1E1E1C, 0.14)
        f.rect(6, 14, 28, 36, 0xC77A2A, radius: 3)
        f.rect(9, 16, 3, 32, 0xE0A15C, radius: 1.5)
        f.rect(4, 4, 32, 12, 0xFFFDF6, radius: 2)
        f.svgLine("M9 6V14M14 6V14M19 6V14M24 6V14M29 6V14", 0xD3D1C7, 1)
        f.rect(10, 24, 22, 18, 0xFFFDF6, radius: 1)
        f.svg("M19 27H23V31H27V35H23V39H19V35H15V31H19Z", 0x1E7A4C)
        let caps: [(CGFloat, CGFloat, CGFloat, UInt32, UInt32)] = [
            (44, 44, 0.3, 0xC8261B, 0xFFFDF6), (58, 46, -0.2, 0x2F5BD3, 0xFAC775),
            (50, 36, -0.9, 0xC8261B, 0xFFFDF6), (68, 40, 0.8, 0x0F6E56, 0xFFFDF6),
        ]
        for c in caps { PalaceShopProps.capsule(f, CGPoint(x: c.0, y: c.1), angle: c.2, c.3, c.4, length: 13) }
        f.dot(40, 35, 3.6, 0xFFFDF6)
        f.ring(40, 35, 3.6, 0xD3D1C7, 0.8)
        f.dot(64, 30, 3.2, 0xFFFDF6)
        f.ring(64, 30, 3.2, 0xD3D1C7, 0.8)
    }

    /// A medicine box with its folded leaflet opening out of it like an accordion (76 × 50).
    static func medLeaflet(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        f.oval(2, 46, 50, 4, 0x1E1E1C, 0.14)
        for i in 0..<5 {
            let x = 22 + CGFloat(i) * 10.5
            let top = 26 - CGFloat(i) * 5.2
            let s: CGFloat = i % 2 == 0 ? 3 : -3
            let d = "M\(x) \(top)L\(x + 10.5) \(top - 5.2 + s)V\(top - 5.2 + s + 26)L\(x) \(top + 26)Z"
            f.svg(d, i % 2 == 0 ? 0xFFFDF6 : 0xE9E4D6)
            f.svgLine(d, 0xD3D1C7, 0.7)
            for k in 0..<4 {
                let y = top + 5 + CGFloat(k) * 4.5
                f.svgLine("M\(x + 2) \(y + s * 0.15)L\(x + 8.5) \(y - 5.2 * 0.6 + s * 0.6)", 0x8E9AA0, 0.9)
            }
        }
        f.svg("M4 28L10 22H36L30 28Z", 0xEFEBE2)
        f.rect(4, 28, 26, 22, 0xFFFDF6)
        f.svg("M30 28L36 22V44L30 50Z", 0xD3D1C7)
        f.rect(4, 32, 26, 5, 0x2F5BD3)
        f.svgLine("M8 42H24M8 45.5H20", 0xB4B2A9, 1)
    }

    /// A poster (84 × 92): a capsule, an arrow and a dizzy green face; `lines` under it.
    static func effectPoster(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 92), hanging: true)
        f.rect(4, 5, 76, 84, 0x1E1E1C, radius: 2, 0.12)
        f.rect(2, 2, 76, 84, 0xFFFDF6, radius: 2)
        f.rect(2, 2, 76, 6, 0x1E7A4C, radius: 2)
        PalaceShopProps.capsule(f, CGPoint(x: 14, y: 30), angle: -0.6, 0xC8261B, 0xFFFDF6, length: 16)
        f.svgLine("M22 30H34M30 25.5L34.5 30L30 34.5", 0x3E4C55, 2.2)
        f.dot(56, 32, 16, 0xB9D88F)
        f.ring(56, 32, 16, 0x5E8C45, 1.2)
        for cx in [50.0, 62] {
            f.svgLine("M\(cx) 28.5a2.2 2.2 0 1 1 -2.2 2.2a3.6 3.6 0 1 1 3.6 3.6", 0x2E2117, 1.2)
        }
        f.svgLine("M48 41Q51 38 54 41T60 41T64 41", 0x2E2117, 1.4)
        f.svgLine("M44 13A14 5 0 1 1 68 13", 0x5E8C45, 1.4)
        f.svg("M48 13l1 2 2 .3-1.5 1.4.4 2-1.9-1-1.9 1 .4-2-1.5-1.4 2-.3Z M66 10l1 2 2 .3-1.5 1.4.4 2-1.9-1-1.9 1 .4-2-1.5-1.4 2-.3Z", 0xFAC775)
        for (i, line) in (p.lines ?? []).prefix(2).enumerated() {
            f.text(line, PropFont.heavy(9.5), i == 0 ? 0x1E1E1C : 0x5E6B73, at: CGPoint(x: 40, y: 62 + CGFloat(i) * 12), maxWidth: 68)
        }
    }

    /// A measuring cup with a red arrow at the dose (76 × 50): `text` ("10 ml"), optional `caption`.
    static func measureCup(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        f.oval(6, 46, 46, 4, 0x1E1E1C, 0.14)
        f.svg("M10 6H44L40 48H14Z", 0xE9F1F4, 0.9)
        f.svg("M12.4 26H41.6L40 48H14Z", 0xE89AA0)
        f.svg("M12.4 26H41.6L41.4 28.5H12.6Z", 0xF4C0D1)
        f.svgLine("M10 6H44L40 48H14Z", 0x8E9AA0, 1.4)
        for (i, y) in [14.0, 20, 26, 32, 38].enumerated() {
            f.svgLine("M33 \(y)H\(i % 2 == 0 ? 40.5 : 38)", 0x5E6B73, 1)
        }
        f.svg("M44 6L49 4V9Z", 0xE9F1F4)
        f.svgLine("M62 26H46M50 22L45.5 26L50 30", 0xC8261B, 2.4)
        f.text(p.text ?? "10 ml", PropFont.heavy(9), 0xC8261B, at: CGPoint(x: 64, y: 16), maxWidth: 24)
        if let caption = p.caption {
            f.rect(48, 34, 28, 12, 0xFAC775, radius: 2)
            f.text(caption, PropFont.heavy(7.5), 0x412402, at: CGPoint(x: 62, y: 40), maxWidth: 26)
        }
    }

    /// A box of tablets with a sore-head pictogram and a blister strip, one tablet out (76 × 50).
    static func medBox(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        f.oval(2, 46, 72, 4, 0x1E1E1C, 0.14)
        f.svg("M4 14L9 9H45L40 14Z", 0xEFEBE2)
        f.svg("M40 14L45 9V45L40 50Z", 0xD3D1C7)
        f.rect(4, 14, 36, 36, 0xFFFDF6)
        f.rect(4, 14, 36, 6, 0xC8261B)
        f.svg("M12 46V40C9 38 8 34 8 30C8 24 13 21 19 21C25 21 29 25 29 30C29 32 30 33 31 35L29 36V40H24V46Z", 0x5E6B73)
        f.svg("M23 22L18 29H22L17 37L27 27H23L27 22Z", 0xC8261B)
        f.svgLine("M33 25l4 -3M33 30h5M33 35l4 3", 0xC8261B, 1.4)
        f.rect(46, 18, 28, 30, 0xD3D1C7, radius: 3)
        for r in 0..<3 {
            for c in 0..<2 {
                let x = 54 + CGFloat(c) * 12, y = 24 + CGFloat(r) * 9
                if r == 2 && c == 1 {
                    f.dot(x, y, 3.6, 0xB4B2A9)
                } else {
                    f.dot(x, y, 3.6, 0xFFFDF6)
                    f.ring(x, y, 3.6, 0xB4B2A9, 0.8)
                }
            }
        }
        f.oval(60, 44, 9, 5, 0xFFFDF6)
        f.svgLine("M61.5 46.5H67.5", 0xD3D1C7, 0.8)
    }

    /// A syrup bottle with a spoon and a shelf card (76 × 50) saying what it is for (`text`, two
    /// words on two lines).
    static func syrupBottle(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        f.oval(2, 46, 50, 4, 0x1E1E1C, 0.14)
        f.svg("M6 50V24C6 19 10 17 13 16V10H23V16C26 17 30 19 30 24V50Z", 0x7A3E1A)
        f.rect(12, 4, 12, 7, 0xFFFDF6, radius: 1.5)
        f.rect(9, 27, 18, 16, 0xFFFDF6, radius: 1)
        f.svgLine("M12 33H24M12 37H21", 0xC8261B, 1.4)
        f.svg("M9 20C10 18.5 11 18 12 18V24H9Z", 0xFFFFFF, 0.2)
        f.svg("M30 48C30 45 34 44 37 45L50 46V48Z", 0xFFFDF6)
        f.oval(28, 44, 10, 5, 0xFFFDF6)
        f.rect(36, 6, 40, 30, 0xFAC775, radius: 2)
        f.svgLine("M38 36L36 46M74 36L76 46", 0x8E9AA0, 1.2)
        let words = (p.text ?? "").split(separator: " ").map(String.init)
        for (i, word) in words.prefix(2).enumerated() {
            f.text(word, PropFont.heavy(words.count > 1 ? 9.5 : 11), 0x412402,
                   at: CGPoint(x: 56, y: words.count > 1 ? 14 + CGFloat(i) * 12 : 21), maxWidth: 36)
        }
    }
}
