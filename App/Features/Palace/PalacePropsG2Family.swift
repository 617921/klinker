import SwiftUI

/// Family things at the notary: grandmother's chest of treasures, a family tree with the heirs
/// marked, an old hand passing a key to a young one, two people carrying one house together, and
/// someone on crutches who lets another sign for them.
enum G2FamilyProps {
    typealias Look = PalaceFigures.Look

    // MARK: Heirlooms

    /// An old chest (100 × 90) open on the floor: gold coins, a pearl necklace over the edge, a
    /// pocket watch, and a tag on a string with `text` ("van oma").
    static func heirlooms(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 90))
        f.oval(4, 84, 92, 6, 0x1E1E1C, 0.18)
        f.svg("M12 40L22 8H82L88 40Z", 0x5A3E26)
        f.svg("M17 38L25 12H79L84 38Z", 0x3A2A1C)
        f.rect(8, 40, 84, 46, 0x7A5230, radius: 2)
        f.svgLine("M8 54H92M8 72H92", 0x5A3E26, 2)
        f.svgLine("M10 40V86M90 40V86", 0xC9A15B, 3)
        f.rect(44, 48, 12, 12, 0xC9A15B, radius: 1.5)
        f.dot(50, 54, 2, 0x3A2A1C)
        // Treasure heaped up
        for (x, y) in [(22.0, 36.0), (30, 33), (38, 36), (60, 35), (68, 32), (76, 36), (46, 34), (54, 37)] as [(CGFloat, CGFloat)] {
            f.dot(x, y, 5, G2Props.coin)
            f.ring(x, y, 3.2, 0xC9A15B, 0.9)
        }
        var pearls = ""
        for k in 0..<12 {
            let t = CGFloat(k) / 11
            let x = 64 + t * 24, y = 38 + sin(t * .pi) * 18
            pearls += "M\(x) \(y)m-2.2 0a2.2 2.2 0 1 0 4.4 0a2.2 2.2 0 1 0 -4.4 0"
        }
        f.svg(pearls, 0xFFFDF6)
        f.dot(32, 26, 9, 0xC9A15B)
        f.dot(32, 26, 7, 0xFFFDF6)
        f.svgLine("M32 21V26L35 28", 0x1E1E1C, 1.2)
        f.rect(30, 15, 4, 3, 0xC9A15B)
        guard let text = p.text else { return }
        f.svgLine("M14 58Q8 62 6 70", 0x5F5E5A, 0.9)
        f.rect(0, 68, 32, 15, 0xF4F1EA, radius: 2)
        f.text(text, PropFont.heavy(8.5), 0x412402, at: CGPoint(x: 16, y: 75.5), maxWidth: 30)
    }

    // MARK: Family tree

    /// A framed family tree (84 × 76): the grandmother on top with a black mourning ribbon, lines
    /// down to `count` (2–3) grandchildren who wear a gold star.
    static func familyTree(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 76))
        f.rect(2, 3, 82, 73, 0x1E1E1C, radius: 2, 0.18)
        f.rect(0, 0, 82, 72, 0xC9A15B, radius: 2)
        f.rect(4, 4, 74, 64, 0xF1E2C4)
        portrait(f, cx: 41, cy: 18, look: Look(coat: 0x5E6B73, trousers: 0, skin: 0xF1D3B8, hair: 0xD3D1C7, bag: 0))
        f.svgLine("M45 7L53 15", 0x1E1E1C, 3.2)
        let n = max(2, min(p.count ?? 2, 3))
        let xs: [CGFloat] = n == 2 ? [24, 58] : [18, 41, 64]
        f.svgLine("M41 31V38M\(xs.first!) 38H\(xs.last!)" + xs.map { "M\($0) 38V44" }.joined(), 0x7A5230, 1.4)
        for (i, x) in xs.enumerated() {
            portrait(f, cx: x, cy: 54, look: Look.at(i * 3 + 1), small: true)
            f.svg(PalacePeople.star(cx: x + 9, cy: 46, r: 5), 0xE8B32C)
        }
    }

    /// A head-and-shoulders portrait in an oval.
    private static func portrait(_ f: PropPen, cx: CGFloat, cy: CGFloat, look: Look, small: Bool = false) {
        let s: CGFloat = small ? 0.85 : 1
        f.oval(cx - 11 * s, cy - 12 * s, 22 * s, 25 * s, 0xFFFDF6)
        f.stroke(Path(ellipseIn: CGRect(x: cx - 11 * s, y: cy - 12 * s, width: 22 * s, height: 25 * s)), 0x7A5230, 1.2)
        f.svg("M\(cx - 8 * s) \(cy + 11 * s)Q\(cx - 8 * s) \(cy + 3 * s) \(cx) \(cy + 3 * s)Q\(cx + 8 * s) \(cy + 3 * s) \(cx + 8 * s) \(cy + 11 * s)Z", look.coat)
        f.dot(cx, cy - 3 * s, 5.5 * s, look.skin)
        f.svg("M\(cx - 5.5 * s) \(cy - 3 * s)Q\(cx - 6 * s) \(cy - 10 * s) \(cx) \(cy - 10 * s)Q\(cx + 6 * s) \(cy - 10 * s) \(cx + 5.5 * s) \(cy - 3 * s)Q\(cx + 3 * s) \(cy - 6.5 * s) \(cx) \(cy - 6.5 * s)Q\(cx - 3 * s) \(cy - 6.5 * s) \(cx - 5.5 * s) \(cy - 3 * s)Z", look.hair)
    }

    // MARK: Inherit

    /// A card (100 × 80): an old hand in a grey cardigan sleeve (top left) lets a house key drop
    /// into a young open hand (bottom right); a curved arrow from one to the other.
    static func inherit(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 80))
        f.rect(1.5, 3, 98, 77, 0x1E1E1C, radius: 4, 0.14)
        f.rect(0, 0, 98, 76, 0xFFFDF6, radius: 4)
        // Old hand
        f.svg("M0 8H22L26 24L0 28Z", 0x8C9499)
        f.svgLine("M4 10V26M9 9V27M14 9V26", 0x7D858A, 1)
        f.svg("M22 12Q30 10 38 14Q42 18 38 22L30 26Q24 26 22 24Z", 0xF1D3B8)
        f.svgLine("M26 16Q29 15 31 17M27 20Q30 19 32 21", 0xC9A07E, 0.9)
        f.svgLine("M38 18L44 22M36 22L41 27", 0xF1D3B8, 3)
        // The key on its way, a little house tag
        f.ring(50, 34, 4.5, 0xC9A15B, 2.2)
        f.svgLine("M53 37L64 48M60 44L57 47M63 47L60 50", 0xC9A15B, 2.4)
        PalaceIcon.house.draw(f, in: CGRect(x: 36, y: 36, width: 11, height: 11), color: 0x9A5238, detail: 0xFFFDF6)
        // Young open hand
        f.svg("M100 56H76L70 70L100 74Z", 0x2F5BD3)
        f.svg("M76 56Q66 52 58 58Q52 64 58 68Q66 72 74 68Z", 0x8C5A3C)
        f.svgLine("M58 58Q54 56 52 58M60 62Q55 61 52 63", 0x8C5A3C, 3)
        f.svgLine("M10 40Q14 64 46 66", 0xF2711C, 2)
        f.svgLine("M40 60L47 66L40 71", 0xF2711C, 2)
    }
}
