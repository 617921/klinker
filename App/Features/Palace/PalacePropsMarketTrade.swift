import SwiftUI

/// Market props for buying and paying: a punnet of berries, fruit ripening from green to red,
/// a crate with one apple being picked out, a cash box of coins, two hands handing money back,
/// and two speech bubbles bargaining over a price.
enum PalaceTradeProps {
    // MARK: Punnet

    /// A green punnet heaped with strawberries (52 × 46).
    static func punnet(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 52, height: 46))
        f.oval(5, 41, 42, 5, 0x1E1E1C, 0.15)
        for (x, y) in [(13.0, 15.0), (25.0, 12.0), (37.0, 15.0), (19.0, 20.0), (31.0, 20.0), (43.0, 21.0), (9.0, 21.0)] as [(CGFloat, CGFloat)] {
            berry(f, x, y)
        }
        f.svg("M4 24H48L44 44H8Z", 0x5E8C45)
        f.rect(2, 22, 48, 4, 0x4E7A3A, radius: 1)
        f.svgLine("M13 30V39M21 30V39M29 30V39M37 30V39", 0x4E7A3A, 2)
    }

    /// One strawberry, point down, centred on (x, y).
    static func berry(_ f: PropPen, _ x: CGFloat, _ y: CGFloat) {
        f.svg("M\(x) \(y - 5)C\(x + 5) \(y - 6) \(x + 7) \(y - 1) \(x + 5) \(y + 3)C\(x + 3) \(y + 7) \(x + 1) \(y + 8) \(x) \(y + 9)C\(x - 1) \(y + 8) \(x - 3) \(y + 7) \(x - 5) \(y + 3)C\(x - 7) \(y - 1) \(x - 5) \(y - 6) \(x) \(y - 5)Z", 0xC8261B)
        for (dx, dy) in [(-2.5, -1.0), (1.5, -2.0), (3.0, 2.0), (-1.0, 3.0), (0.5, 6.0)] as [(CGFloat, CGFloat)] {
            f.dot(x + dx, y + dy, 0.6, 0xFAC775)
        }
        f.svg("M\(x - 4.5) \(y - 5)L\(x - 1) \(y - 3.5)L\(x) \(y - 2)L\(x + 1) \(y - 3.5)L\(x + 4.5) \(y - 5)L\(x + 1) \(y - 6)L\(x) \(y - 8.5)L\(x - 1) \(y - 6)Z", 0x3F5A4A)
    }

    // MARK: Ripening

    /// Three tomatoes from green to red on the counter, a green tick over the red one (66 × 46).
    static func ripeness(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 66, height: 46))
        let fruit: [(x: CGFloat, r: CGFloat, c: UInt32)] = [(11, 8, 0x8DB061), (30, 9.5, 0xF2A33A), (52, 11.5, 0xC8261B)]
        for t in fruit {
            let cy = 44 - t.r
            f.oval(t.x - t.r, 42.5, 2 * t.r, 3.5, 0x1E1E1C, 0.15)
            f.dot(t.x, cy, t.r, t.c)
            f.oval(t.x - t.r * 0.6, cy - t.r * 0.6, t.r * 0.55, t.r * 0.4, 0xFFFFFF, 0.4)
            f.svg("M\(t.x - 4) \(cy - t.r + 1)L\(t.x) \(cy - t.r + 2.5)L\(t.x + 4) \(cy - t.r + 1)L\(t.x + 1) \(cy - t.r - 0.5)L\(t.x) \(cy - t.r - 3.5)L\(t.x - 1) \(cy - t.r - 0.5)Z", 0x3F5A4A)
        }
        f.dot(52, 9, 7.5, 0x1E7A4C)
        f.svgLine("M48.5 9.2L51 11.8L55.8 6.4", 0xFFFFFF, 2)
    }

    // MARK: Picking out

    /// A crate of apples with a hand lifting the best one out (96 × 76).
    static func pickCrate(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 76))
        f.oval(2, 70, 92, 6, 0x1E1E1C, 0.15)
        f.rect(4, 36, 88, 8, 0x9A6A42)
        let apples: [(CGFloat, CGFloat, UInt32)] = [
            (12, 40, 0xC8261B), (26, 38, 0x8DB061), (40, 40, 0xA51E15), (68, 39, 0xC8261B), (82, 40, 0x8DB061),
            (19, 45, 0xA51E15), (33, 45, 0xC8261B), (47, 45, 0x8DB061), (61, 45, 0xA51E15), (75, 45, 0xC8261B),
        ]
        for (x, y, c) in apples {
            f.dot(x, y, 7, c)
            f.dot(x - 2.5, y - 2.5, 1.6, 0xFFFFFF, 0.35)
        }
        f.rect(2, 44, 92, 30, 0xC9965F)
        f.svgLine("M2 54H94M2 64H94", 0x9A6A42, 1.4)
        f.rect(2, 44, 6, 30, 0xB07F4E)
        f.rect(88, 44, 6, 30, 0xB07F4E)
        f.rect(38, 47, 20, 5, 0x6B4A2E, radius: 2.5)
        f.svgLine("M54 34Q52 30 54 26", 0xF2711C, 1.4)
        f.svg("M51 28L54 23.5L57 28Z", 0xF2711C)
        f.svgLine("M38 10L42 12M37 18H41.5M41 3.5L44 7", 0xF2711C, 1.6)
        f.dot(54, 14, 9, 0xC8261B)
        f.dot(50.5, 10.5, 2.2, 0xFFFFFF, 0.4)
        f.svgLine("M54 5.5Q54 3 56 1.5", 0x4A3524, 1.4)
        f.svg("M56 3.5C59 0.5 63 1 64 2.5C61 5 58 5 56 3.5Z", 0x5E8C45)
        f.svg("M96 4L78 9L80 21L96 17Z", 0x993556)
        f.svg("M79 9C73 7 66 9 62 13C60 15 61 17 63 17L60 21C59 23 61 25 63 23L66 21C65 24 67 25 69 23L81 20Z", 0xC99A74)
        f.svgLine("M63 17L69 16", 0xA87B4F, 1)
    }

    // MARK: Cash box

    /// An open cash box with its trays of coins and a little stack in front (64 × 52).
    static func cashBox(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 64, height: 52))
        f.oval(0, 47, 64, 5, 0x1E1E1C, 0.15)
        f.svg("M6 4H46L42 22H10Z", 0x2F4B3A)
        f.svg("M9 7H43L40.5 20H11.5Z", 0x3F5A4A)
        f.svg("M3 22H49L53 33H-1Z", 0x1E2A24)
        f.svgLine("M14.5 22L12.5 33M26 22V33M37.5 22L39.5 33", 0x5E7A68, 1.4)
        let trays: [(CGFloat, UInt32, UInt32)] = [(7.5, 0xF6D27A, 0xC9A15B), (19.5, 0xF6D27A, 0xC9A15B), (32.5, 0xD3D1C7, 0x8E8A80), (44.5, 0xD3D1C7, 0x8E8A80)]
        for (x, top, side) in trays {
            for k in 0..<3 {
                let y = 30.5 - CGFloat(k) * 2.2
                f.oval(x - 5.5, y - 1, 11, 4.8, side)
                f.oval(x - 5.5, y - 2, 11, 4.4, top)
            }
        }
        f.rect(-1, 33, 54, 15, 0x3F5A4A, radius: 1.5)
        f.rect(-1, 33, 54, 2.5, 0x2F4B3A)
        f.rect(19, 39, 14, 4, 0x5E7A68, radius: 2)
        for k in 0..<4 {
            let y = 46 - CGFloat(k) * 3
            f.oval(52, y - 1, 12, 5, 0xC9A15B)
            f.oval(52, y - 2, 12, 4.6, 0xF6D27A)
        }
    }

    // MARK: Handing back

    /// A hand from the top right dropping coins into a cupped hand from the bottom left, with an
    /// arrow showing the way they go (70 × 58). `variant` colours the giver's sleeve.
    static func handover(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 70, height: 58))
        let sleeves: [UInt32] = [0x0F6E56, 0x1F3A6B, 0x5E6B73, 0xC8261B]
        let sleeve = sleeves[((p.variant ?? 0) % sleeves.count + sleeves.count) % sleeves.count]
        f.svgLine("M62 30Q61 47 42 51", 0xF2711C, 2.6)
        f.svg("M44 46L36.5 51.5L45 55.5Z", 0xF2711C)
        f.svg("M70 0L51 7L56 22L70 16Z", sleeve)
        f.svgLine("M51 7L56 22", PalaceInk.shade(sleeve, 0.75), 2.2)
        f.svg("M53 8C45 6 36 8 31 13C29 15.5 30 18.5 33.5 18L39 17.5C37.5 20.5 39.5 23 42.5 22L55 20.5Z", 0xE8C4A0)
        f.svgLine("M33.5 18L40 16", 0xC99A74, 1.1)
        for (x, y) in [(29.0, 26.5), (23.0, 33.5)] as [(CGFloat, CGFloat)] { coin(f, x, y) }
        f.svg("M0 44L16 37L21 51L0 58Z", 0x993556)
        f.svgLine("M16 37L21 51", 0x7A2A44, 2.2)
        f.svg("M17 39C23 36.5 33 36.5 39 38.5C42.5 39.5 42.5 43 39 44.5C33 47.5 26 48.5 19.5 50Z", 0xC99A74)
        f.svgLine("M22 43H35", 0xA87B4F, 1.1)
        coin(f, 28.5, 38.5)
    }

    private static func coin(_ f: PropPen, _ x: CGFloat, _ y: CGFloat) {
        f.dot(x, y, 5, 0xC9A15B)
        f.dot(x - 0.4, y - 0.4, 4, 0xF6D27A)
        f.text("€", PropFont.heavy(6), 0xA3410A, at: CGPoint(x: x - 0.3, y: y - 0.3))
    }

    // MARK: Haggling

    /// Two speech bubbles bargaining (100 × 66): the seller's price (`lines[0]`, top right, tail to
    /// the right) and the buyer's lower offer (`lines[1]`, bottom left, tail down). `highlight`
    /// strikes a price through in red.
    static func haggle(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 66))
        let lines = p.lines ?? ["€ 5", "€ 3?"]
        let boxes: [(CGRect, String, UInt32)] = [
            (CGRect(x: 40, y: 1, width: 56, height: 28), "M90 10L99 6L91 21Z", 0xFFFDF6),
            (CGRect(x: 3, y: 31, width: 58, height: 28), "M38 58L50 65.5L48 58Z", 0xFAC775),
        ]
        for (i, (box, tail, fill)) in boxes.enumerated() {
            f.svg(tail, fill)
            f.svgLine(tail, 0x2E2117, 1.4)
            f.rect(box, fill, radius: 9)
            f.stroke(Path(roundedRect: box, cornerRadius: 9), 0x2E2117, 1.4)
            guard i < lines.count else { continue }
            f.text(lines[i], PropFont.heavy(15), 0x1E1E1C, at: CGPoint(x: box.midX, y: box.midY + 0.5), maxWidth: box.width - 10)
            if p.highlight == i {
                f.line(box.minX + 10, box.midY + 5, box.maxX - 10, box.midY - 4, 0xC8261B, 2.6)
            }
        }
    }
}
