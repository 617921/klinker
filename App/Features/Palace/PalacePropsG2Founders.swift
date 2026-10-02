import SwiftUI

/// People who run their own business: a founder in front of a shop of their own, and someone who
/// works alone and is their own boss. Drawn for `G2People.person` ("founder", "solo").
enum G2Founders {
    typealias Look = PalaceFigures.Look

    /// Proud in front of a little shop of their own (110 × 114): an awning, a window, a door with a
    /// sign (`text`, "OPEN"); the founder points at it.
    static func founder(_ pen: PropPen, _ p: PalacePropParams, _ v: Look) {
        let f = pen.fitted(CGSize(width: 110, height: 114))
        let tone = PropColor.named(p.tone, 0x1E7A4C)
        f.rect(50, 18, 58, 90, 0xE9DFC9)
        f.rect(50, 14, 58, 6, 0x5E6B73)
        for k in 0..<5 {
            f.svg("M\(52 + CGFloat(k) * 11.2) 20h11.2v12q-5.6 5 -11.2 0Z", k % 2 == 0 ? tone : 0xFFFDF6)
        }
        f.rect(56, 42, 22, 26, 0xBCCDD6)
        f.svgLine("M67 42V68M56 55H78", 0xFFFDF6, 1.2)
        f.rect(84, 44, 18, 64, 0x1F3A6B)
        f.dot(98, 78, 1.4, 0xC9A15B)
        f.svgLine("M87 50L93 46L99 50", 0x5F5E5A, 0.8)
        f.rect(80, 50, 26, 12, tone, radius: 2)
        f.text(p.text ?? "", PropFont.heavy(8), 0xFFFFFF, at: CGPoint(x: 93, y: 56), maxWidth: 24)
        let me = f.within(CGRect(x: 0, y: 0, width: 64, height: 114))
        G2People.body(me, v)
        G2People.head(me, v, cx: 22, cy: 19, mood: "smile")
        me.svgLine("M25 25Q29 28 32 24", 0x8C5A3C, 1.4)
        me.svgLine("M31 42C40 44 50 50 60 54", v.coat, 6)
        me.dot(61, 54.5, 3.2, v.skin)
        me.svgLine("M62 54L70 56", v.skin, 2)
    }

    /// Working alone (110 × 114): on a stool at a high table with a laptop and a mug, no one else
    /// around, saying `text` in a bubble ("mijn eigen baas!").
    static func solo(_ pen: PropPen, _ p: PalacePropParams, _ v: Look) {
        let f = pen.fitted(CGSize(width: 110, height: 114))
        f.oval(6, 108, 100, 6, 0x1E1E1C, 0.15)
        // High table with a laptop and a mug
        f.svgLine("M84 66V110M74 110H94", 0x2E2117, 2.6)
        f.rect(56, 62, 52, 5, 0xD9B47E, radius: 2)
        f.svg("M66 62L72 40H96L92 62Z", 0x3E4C55)
        f.dot(83, 51, 2.4, 0xB4B2A9)
        f.rect(97, 52, 8, 10, 0xFFFDF6, radius: 1.5)
        f.svgLine("M105 54H107V59H105", 0xFFFDF6, 1.2)
        // Stool and the person on it, facing the laptop
        f.svgLine("M28 80L22 110M40 80L46 110M24 98H44", 0x5E6B73, 2.2)
        f.rect(20, 76, 28, 5, 0x2E2117, radius: 2)
        f.svg("M22 78V52C22 44 27 41 33 41C39 41 44 44 44 52V78Z", v.coat)
        f.svgLine("M34 78H56V104", v.trousers, 7)
        f.rect(52, 102, 10, 5, 0x2E2117, radius: 1.5)
        G2People.head(f, v, cx: 34, cy: 29, r: 10, mood: "smile")
        f.svgLine("M40 50Q52 58 66 58", v.coat, 5)
        f.dot(66, 58, 2.8, v.skin)
        guard let text = p.text else { return }
        let font = PropFont.heavy(9)
        let w = min(76, f.width(of: text, font) + 12)
        f.rect(2, 0, w, 18, 0xFFFDF6, radius: 6)
        f.stroke(Path(roundedRect: CGRect(x: 2, y: 0, width: w, height: 18), cornerRadius: 6), 0xB4B2A9, 0.8)
        f.svg("M20 17L26 24L28 17Z", 0xFFFDF6)
        f.text(text, font, 0x1E1E1C, at: CGPoint(x: 2 + w / 2, y: 9), maxWidth: w - 8)
    }
}
