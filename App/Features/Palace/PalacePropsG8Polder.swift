import SwiftUI

/// The land side of a dike and the path in front: a pumping station with the water board's
/// badge, a house below the water level, a rain gauge, an information board, an umbrella held
/// over a child, and sandbags laid before the water comes.
enum G8Polder {
    typealias Look = PalaceFigures.Look

    // MARK: Pumping station

    /// A brick pumping station (98 × 112) with the water board's badge (a shield with a drop and
    /// waves) over the door and on its flag; a pipe lifts the water out of the ditch and away.
    static func pumpStation(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 98, height: 112))
        G8Props.shadow(f, 2, 106, 72)
        f.svgLine("M58 64V20Q58 12 50 12H0", 0x5E6B73, 7)
        f.svgLine("M58 64V20Q58 12 50 12H0", 0x7D8A92, 2)
        G8Props.arrow(f, CGPoint(x: 40, y: 4), CGPoint(x: 14, y: 4), 0x2F5BD3, 2, head: 6)
        f.rect(8, 54, 60, 54, 0x9A5238)
        f.svgLine("M8 64H68M8 74H68M8 84H68M8 94H68", 0x7A3F2E, 0.8)
        f.svg("M2 56L38 34L74 56Z", 0x3E4C55)
        f.rect(30, 82, 16, 26, 0x2F4B3A)
        badge(f, CGPoint(x: 38, y: 68), 9)
        f.rect(16, 62, 8, 10, 0xBCCDD6)
        f.rect(52, 62, 8, 10, 0xBCCDD6)
        f.rect(70, 30, 2.4, 78, 0x5E6B73)
        f.svg("M72 32H96V48H72Z", 0x2F5BD3)
        badge(f, CGPoint(x: 80, y: 40), 5.6)
        f.rect(0, 104, 76, 6, G8Water.water)
        G8Props.arrow(f, CGPoint(x: 74, y: 107), CGPoint(x: 62, y: 107), 0x1F3A6B, 1.8, head: 5)
    }

    /// The water board's badge: a blue shield with a white drop over waves.
    static func badge(_ f: PropPen, _ c: CGPoint, _ r: CGFloat) {
        f.svg("M\(c.x - r) \(c.y - r)H\(c.x + r)V\(c.y)Q\(c.x + r) \(c.y + r * 0.9) \(c.x) \(c.y + r * 1.25)Q\(c.x - r) \(c.y + r * 0.9) \(c.x - r) \(c.y)Z", 0x1F3A6B)
        f.svg("M\(c.x) \(c.y - r * 0.75)C\(c.x + r * 0.5) \(c.y - r * 0.1) \(c.x + r * 0.45) \(c.y + r * 0.35) \(c.x) \(c.y + r * 0.35)C\(c.x - r * 0.45) \(c.y + r * 0.35) \(c.x - r * 0.5) \(c.y - r * 0.1) \(c.x) \(c.y - r * 0.75)Z", 0xFFFDF6)
        f.svgLine("M\(c.x - r * 0.7) \(c.y + r * 0.62)Q\(c.x - r * 0.35) \(c.y + r * 0.45) \(c.x) \(c.y + r * 0.62)T\(c.x + r * 0.7) \(c.y + r * 0.62)", 0x8FB6CF, r * 0.18)
    }

    // MARK: Low-lying house

    /// A house far below the water (64 × 140): a dashed line at the water's height (top), the
    /// house on the low ground (bottom), a double arrow between them with the depth `text`.
    static func lowLand(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 64, height: 140))
        var dash = Path()
        dash.move(to: CGPoint(x: 0, y: 8))
        dash.addLine(to: CGPoint(x: 64, y: 8))
        f.ctx.stroke(dash, with: .color(PalaceInk.hex(0x2F5BD3)), style: StrokeStyle(lineWidth: 2.2, dash: [6, 4]))
        f.svgLine("M2 3Q6 0 10 3T18 3", 0x2F5BD3, 1.4)
        f.svgLine("M14 12V120", 0x1F3A6B, 1.8)
        G8Props.head(f, tip: CGPoint(x: 14, y: 10), dx: 0, dy: -1, 6, 0x1F3A6B)
        G8Props.head(f, tip: CGPoint(x: 14, y: 122), dx: 0, dy: 1, 6, 0x1F3A6B)
        let tag = CGRect(x: 18, y: 54, width: 40, height: 18)
        f.rect(tag, 0xFFFDF6, radius: 3)
        f.stroke(Path(roundedRect: tag, cornerRadius: 3), 0x1F3A6B, 1.2)
        f.text(p.text ?? "-4 m", PropFont.heavy(10), 0x1F3A6B, at: CGPoint(x: tag.midX, y: tag.midY + 0.5), maxWidth: tag.width - 4)
        G8Props.shadow(f, 20, 135, 44, 4)
        f.rect(26, 110, 32, 26, 0xE3D6BC)
        f.svg("M22 112L42 94L62 112Z", 0x7A1E1E)
        f.rect(30, 116, 7, 7, 0x3E4C55)
        f.rect(46, 122, 7, 14, 0x2F4B3A)
    }

    // MARK: Rain gauge

    /// A rain gauge on a post (66 × 104) under a small grey cloud whose drops fall into it: a
    /// clear tube with a scale, water up to a mark, the amount `text` on a tag.
    static func rainGauge(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 66, height: 104))
        G8Props.shadow(f, 18, 99, 30, 4)
        f.dot(22, 14, 11, 0x9A9A92)
        f.dot(38, 10, 12, 0x9A9A92)
        f.rect(12, 12, 40, 12, 0x9A9A92, radius: 6)
        for (x, y) in [(22.0, 32.0), (32, 28), (40, 34), (28, 40)] as [(CGFloat, CGFloat)] {
            f.svg("M\(x) \(y - 4)Q\(x + 3) \(y) \(x) \(y + 2)Q\(x - 3) \(y) \(x) \(y - 4)Z", 0x2F5BD3)
        }
        f.rect(29, 82, 6, 18, 0x6B4A2E)
        f.svg("M22 46H42L39 52V84H25V52Z", 0xEFF5F7)
        f.rect(25.6, 66, 12.8, 18, 0x8FB6CF)
        f.stroke(PalaceSVG.path("M22 46H42L39 52V84H25V52Z"), 0x5E6B73, 1.2)
        f.svgLine("M25 58H29M25 64H31M25 70H29M25 76H31", 0x1E1E1C, 1)
        let tag = CGRect(x: 40, y: 64, width: 26, height: 14)
        f.rect(tag, 0xFFFDF6, radius: 2)
        f.stroke(Path(roundedRect: tag, cornerRadius: 2), 0x1F3A6B, 1)
        f.text(p.text ?? "12 mm", PropFont.heavy(7.5), 0x1F3A6B, at: CGPoint(x: tag.midX, y: tag.midY + 0.5), maxWidth: tag.width - 3)
    }

    // MARK: Information board

    /// An information board on two legs (100 × 84): a dark-blue frame and a white face with
    /// `caption`, `icons` (with `labels` over them) and `text`, laid out like a sign.
    static func infoBoard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 84))
        G8Props.shadow(f, 8, 79, 84, 5)
        f.rect(16, 50, 4, 32, 0x5E6B73)
        f.rect(80, 50, 4, 32, 0x5E6B73)
        f.rect(0, 0, 100, 58, 0x1F3A6B, radius: 3)
        f.rect(4, 4, 92, 50, 0xFFFDF6, radius: 2)
        PalacePanels.content(f, p, in: CGRect(x: 8, y: 7, width: 84, height: 44), tone: .named("white"))
    }

    // MARK: Umbrella

    /// A grown-up holding a big umbrella over a child (96 × 114) while rain pours down all
    /// around; under the umbrella it stays dry.
    static func umbrella(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 114))
        let v = Look.at(p.variant ?? 4)
        var rain = ""
        for (i, x) in stride(from: 2.0, to: 96, by: 8).enumerated() where x < 8 || x > 88 || i % 2 == 0 {
            let top = x < 8 || x > 88 ? 30.0 : 0.0
            rain += "M\(x + 3) \(top + Double(i % 3) * 4)l-3 9"
        }
        rain += "M4 50l-3 9M92 46l-3 9M6 74l-3 9M94 70l-3 9"
        f.svgLine(rain, 0x5E7FA0, 1.6)
        G8Props.shadow(f, 12, 107, 74)
        PalaceFigures.person(f.within(CGRect(x: 12, y: 0, width: 64, height: 114)), PalacePropParams(variant: p.variant ?? 4, accessory: "none"))
        PalaceFigures.mini(f.within(CGRect(x: 48, y: 110 - 60 * 0.95, width: 30 * 0.95, height: 60 * 0.95), unit: 0.95), Look.at(6), walking: false, briefcase: false)
        f.svgLine("M44 42C50 36 52 30 52 26", v.coat, 6)
        f.svgLine("M52 30V14", 0x3E4C55, 2)
        f.svg("M8 30Q52 -8 96 30Q85 24 74 30Q63 24 52 30Q41 24 30 30Q19 24 8 30Z", 0xC8261B)
        f.svg("M52 4Q40 12 30 30Q41 24 52 30Z", 0xE5372A)
        f.svgLine("M52 30Q52 34 56 34", 0x3E4C55, 2)
        f.dot(52, 6, 2, 0x3E4C55)
    }

    // MARK: Sandbags

    /// Sandbags laid in front of a door before the water comes (136 × 80): water creeping in from
    /// the left stops at the bags, a hand lays the last one, the door behind stays dry (a tick).
    static func sandbags(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 136, height: 80))
        f.rect(84, 4, 52, 72, 0xE3D6BC)
        f.rect(100, 22, 22, 54, 0x24533F)
        f.dot(118, 50, 1.6, 0xC9A15B)
        f.svg("M0 60Q10 56 20 60T40 60T60 60V80H0Z", G8Water.water)
        f.svgLine("M2 60Q10 56 18 60T34 60T50 60", 0xFFFDF6, 1.4)
        for (row, y) in [(0, 64.0), (1, 52), (2, 40)] {
            let count = 3 - row
            for k in 0..<count {
                let x = 58 + CGFloat(k) * 18 + CGFloat(row) * 9
                f.rect(x, y, 19, 12, 0xC9A15B, radius: 5)
                f.svgLine("M\(x + 3) \(y + 4)Q\(x + 9.5) \(y + 2) \(x + 16) \(y + 4)", 0xA88748, 1)
            }
        }
        f.rect(76, 22, 19, 12, 0xC9A15B, radius: 5)
        f.svgLine("M100 0L90 18", 0x2F5BD3, 8)
        f.svg("M86 16C83 16 80 19 81 23L86 25C89 24 91 21 90 18Z", 0xE8C4A0)
        f.rect(84, 76, 52, 4, 0x9A9A92)
        G8Props.badge(f, 128, 12, 7, ok: true)
    }
}
