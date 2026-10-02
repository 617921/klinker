import SwiftUI

/// Insurer props: a house kept dry under an umbrella, an umbrella with a price tag, a car that
/// hit a post, a house opened up to show what is inside, the small print under a magnifier.
enum G2InsuranceProps {
    // MARK: Shelter

    /// Rain everywhere except under a big umbrella (90 × 90, `tone`) that keeps the first of
    /// `icons` (default a house) dry; a lightning bolt in the corner.
    static func shelter(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 90, height: 90))
        let tone = PropColor.named(p.tone, 0x0F6E56)
        f.rect(0, 0, 90, 90, 0xD9E2E6, radius: 4)
        f.rect(0, 80, 90, 10, 0x9AA4A9, radius: 2)
        // Rain: short slanted drops, none under the umbrella.
        var rain = ""
        for (x, y) in [(6.0, 6.0), (20, 2), (64, 3), (80, 9), (4, 30), (8, 52), (84, 32), (80, 52), (4, 70), (84, 70), (40, 1), (52, 6)] as [(CGFloat, CGFloat)] {
            rain += "M\(x) \(y)l-2.5 6"
        }
        f.svgLine(rain, 0x2F5BD3, 1.6)
        f.svgLine("M10 84q2 -3 4 0M78 84q2 -3 4 0", 0x2F5BD3, 1.2)
        f.svg("M20 4L13 15H18L15 23L24 11H19Z", 0xFAC775)
        // The umbrella
        f.svg("M8 36Q10 12 45 12Q80 12 82 36Q75 31 68 36Q60 31 52 36Q45 31 38 36Q30 31 22 36Q15 31 8 36Z", tone)
        f.svgLine("M45 13Q34 20 30 35M45 13Q56 20 60 35", PalaceInk.shade(tone, 0.75), 1.2)
        f.svgLine("M45 8V12", 0x2E2117, 2)
        f.svgLine("M45 36V44", 0x2E2117, 2)
        let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first ?? .house
        icon.draw(f, in: CGRect(x: 27, y: 44, width: 36, height: 36), color: 0x9A5238, detail: 0xFAC775)
    }

    // MARK: Price tag

    /// The first of `icons` drawn big in `tone`, with a price tag hanging from it: `text` (big)
    /// and `caption` (small) (72 × 90).
    static func tagged(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 72, height: 90))
        let tone = PropColor.named(p.tone, 0x0F6E56)
        if let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first {
            icon.draw(f, in: CGRect(x: 2, y: 2, width: 54, height: 54), color: tone, detail: 0xFFFDF6)
        }
        f.svgLine("M24 54Q30 60 40 56", 0x5F5E5A, 1)
        let tag = CGRect(x: 26, y: 54, width: 44, height: 34)
        var t = f
        t.ctx.translateBy(x: tag.midX, y: tag.midY)
        t.ctx.rotate(by: .degrees(-6))
        let r = CGRect(x: -tag.width / 2, y: -tag.height / 2, width: tag.width, height: tag.height)
        t.svg("M\(r.minX + 8) \(r.minY)H\(r.maxX)V\(r.maxY)H\(r.minX + 8)L\(r.minX) \(r.midY)Z", 0xFAC775)
        t.dot(r.minX + 7, r.midY, 2, 0x7A5230)
        t.text(p.text ?? "", PropFont.heavy(12), 0x1E1E1C, at: CGPoint(x: 4, y: -5), maxWidth: r.width - 12)
        if let caption = p.caption {
            t.text(caption, PropFont.demi(7.5), 0x412402, at: CGPoint(x: 4, y: 8), maxWidth: r.width - 12)
        }
    }

    // MARK: Damage

    /// A small car (100 × 70) that drove into a post: the bonnet crumpled, a cracked headlight,
    /// a crash star and bits on the road.
    static func damage(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 70))
        let paint = PropColor.named(p.tone, 0xC8261B)
        f.oval(4, 62, 84, 7, 0x1E1E1C, 0.16)
        f.rect(86, 4, 7, 62, 0x8C9499, radius: 2)
        f.rect(86, 18, 7, 6, 0xF2711C)
        f.rect(86, 32, 7, 6, 0xF2711C)
        // Body, its front pushed in
        f.svg("M6 50V38Q6 33 12 32L24 20Q27 17 32 17H54Q58 17 61 20L69 29L74 30L71 36L78 38L75 44L80 46V54H6Z", paint)
        f.svg("M28 22H42V31H20Z M46 22H55Q57 22 58.5 24L63 31H46Z", 0xBCCDD6)
        f.svgLine("M44 32V50M64 34L68 40L66 46", PalaceInk.shade(paint, 0.7), 1.2)
        f.svgLine("M70 30L73 36L70 41L74 45", 0x1E1E1C, 1.4)
        f.dot(77, 42, 3.4, 0xFFFDF6)
        f.svgLine("M75 40L79 44M78 39.5L76 44", 0x5E6B73, 0.9)
        for x in [22.0, 64] as [CGFloat] {
            f.dot(x, 54, 8, 0x1E1E1C)
            f.dot(x, 54, 3.4, 0xB4B2A9)
        }
        // Crash star
        var star = ""
        for k in 0..<14 {
            let a = Double(k) * .pi / 7
            let r: CGFloat = k % 2 == 0 ? 13 : 6
            star += (k == 0 ? "M" : "L") + String(format: "%.1f %.1f", 84 + cos(a) * r, 26 + sin(a) * r)
        }
        f.svg(star + "Z", 0xFAC775)
        f.svgLine("M80 22L88 30M88 22L80 30", 0xC8261B, 1.8)
        f.svg("M58 64L62 61L63 65Z M70 66L75 63L74 67Z M50 66L53 64L54 67Z", 0x5E6B73)
    }

    // MARK: House contents

    /// A house opened up like a doll's house (100 × 100): sofa, lamp, TV, a picture and a plant —
    /// everything inside it.
    static func houseContents(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 100))
        f.oval(4, 94, 92, 6, 0x1E1E1C, 0.15)
        f.svg("M2 40L50 4L98 40Z", 0x9A5238)
        f.rect(8, 38, 84, 58, 0x7B3F2E)
        f.rect(12, 42, 76, 52, 0xF1E2C4)
        f.rect(12, 86, 76, 8, 0xC9965F)
        // Picture on the wall, a lamp
        f.rect(20, 48, 16, 12, 0x7A5230, radius: 1)
        f.rect(22, 50, 12, 8, 0xBCCDD6)
        f.svg("M23 58L27 53L30 56L32 54L34 58Z", 0x5E8C45)
        f.svgLine("M45 50V84", 0x3E4C55, 1.6)
        f.svg("M39 50L42 44H48L51 50Z", 0xFAC775)
        f.rect(41, 84, 8, 2, 0x3E4C55)
        // Sofa
        f.rect(14, 68, 30, 10, 0x2F5BD3, radius: 3)
        f.rect(14, 74, 30, 10, 0x21468B, radius: 2)
        f.rect(12, 70, 5, 14, 0x21468B, radius: 2)
        f.rect(41, 70, 5, 14, 0x21468B, radius: 2)
        // TV on a cabinet, a plant
        f.rect(56, 76, 26, 10, 0x8C5E38, radius: 1)
        f.rect(58, 56, 22, 16, 0x1E1E1C, radius: 1.5)
        f.rect(60, 58, 18, 12, 0x5E8C9A)
        f.rect(67, 72, 4, 4, 0x1E1E1C)
        f.svg("M83 86H90L89 80H84Z", 0xA3410A)
        f.svg("M86.5 80C82 74 82 68 85 64C88 70 88 75 86.5 80Z M86.5 80C90 73 92 70 92 66C88 68 86 74 86.5 80Z", 0x5E8C45)
        // Attic window
        f.dot(50, 26, 6, 0xBCCDD6)
        f.svgLine("M44 26H56M50 20V32", 0x7B3F2E, 1.2)
    }
}
