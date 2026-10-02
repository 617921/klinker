import SwiftUI

/// The ferry and the water: the flat city ferry, the village on the far bank, a transport sign,
/// the crossing sign, and a traveller who has arrived.
enum G8FerryProps {
    typealias Look = PalaceFigures.Look

    // MARK: Ferry

    /// A flat city ferry (176 × 90) side-on: a navy hull with a white band, ramps at both ends, a
    /// wheelhouse on legs in the middle, cyclists and people on deck, a wake in the water.
    static func boat(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 176, height: 90))
        f.svgLine("M2 84Q20 80 40 84M130 84Q150 80 172 84M60 88H110", 0xFFFDF6, 1.6)
        f.svg("M6 64H170L162 82H14Z", 0x1F3A6B)
        f.rect(6, 58, 164, 7, 0xFFFDF6)
        f.svg("M0 54L12 52V60L0 64Z M176 54L164 52V60L176 64Z", 0x5E6B73)
        f.rect(10, 52, 156, 6, 0xD3D1C7)
        f.svgLine("M12 40H164", 0x5E6B73, 1.2)
        var posts = ""
        for x in stride(from: 12.0, through: 164, by: 19) { posts += "M\(x) 40V52" }
        f.svgLine(posts, 0x5E6B73, 1)
        f.svgLine("M76 30V52M100 30V52", 0x5E6B73, 2.4)
        f.rect(68, 12, 40, 20, 0xFFFDF6, radius: 2)
        f.rect(71, 16, 34, 8, 0x3E4C55, radius: 1)
        f.rect(66, 8, 44, 5, 0x1F3A6B, radius: 1.5)
        f.rect(86, 2, 3, 7, 0x5E6B73)
        f.rect(89, 2, 9, 5, 0xF2711C)
        G8Traffic.cyclist(f, 20, 52, 0.9, Look.at(2), left: false)
        G8Traffic.cyclist(f, 124, 52, 0.9, Look.at(6), left: true)
        for (i, x) in [56.0, 112, 150].enumerated() {
            PalaceFigures.mini(f.within(CGRect(x: x - 11, y: 52 - 44, width: 22, height: 44), unit: 22.0 / 30), Look.at(i * 3 + 1), walking: false, briefcase: false)
        }
    }

    // MARK: The far bank

    /// The village on the far bank (130 × 86): a church, houses, trees and a mill on a strip of
    /// land, a landing stage with a shelter and a flag, and a big arrow from this side pointing over.
    static func farBank(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 130, height: 86))
        f.svg("M0 60Q30 54 70 56T130 54V70H0Z", 0x7FA650)
        f.rect(0, 66, 130, 4, 0x8C7A5A)
        f.svg("M30 58V30L36 8L42 30V58Z", 0xD9CDB4)
        f.svg("M36 2L40 12H32Z", 0x5E6B73)
        f.dot(36, 34, 3, 0x3E4C55)
        for (x, h, c) in [(8.0, 18.0, 0x9A5238), (46, 22, 0x7B3F2E), (60, 16, 0xE3D6BC), (74, 20, 0x5E6B73)] as [(CGFloat, CGFloat, UInt32)] {
            f.rect(x, 58 - h, 12, h, c)
            f.svg("M\(x - 1) \(58 - h)L\(x + 6) \(51 - h)L\(x + 13) \(58 - h)Z", PalaceInk.shade(c, 0.7))
        }
        f.dot(22, 50, 7, 0x5E8C45)
        f.dot(92, 48, 8, 0x4E7A3A)
        f.svg("M104 58V40L108 34L112 40V58Z", 0x6B4A2E)
        f.svgLine("M108 38L98 28M108 38L118 48M108 38L118 28M108 38L98 48", 0x3E4C55, 2)
        f.rect(86, 64, 40, 4, 0x6B4A2E)
        f.svgLine("M90 68V76M120 68V76", 0x6B4A2E, 2)
        f.rect(96, 52, 18, 12, 0xEFEBE2)
        f.rect(94, 50, 22, 3, 0x2F5BD3)
        f.rect(118, 40, 2, 24, 0x5E6B73)
        f.svg("M120 40H129V46H120Z", 0xF2711C)
        f.svgLine("M10 84Q40 70 78 74", 0xF2711C, 3)
        G8Props.head(f, tip: CGPoint(x: 90, y: 74), dx: 1, dy: 0.05, 11, 0xF2711C)
    }

    // MARK: Transport sign

    /// A white sign on a pole (60 × 96) with `icons` (bus, tram, train, ferry) in a 2 × 2 grid.
    static func transportSign(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 60, height: 96))
        let icons = (p.icons ?? ["bus", "tram", "train", "g8Ferry"]).compactMap(PalaceIcon.init(rawValue:))
        G8Props.shadow(f, 20, 91, 20, 4)
        f.rect(28, 50, 4, 44, 0x5E6B73)
        f.rect(0, 0, 60, 60, 0x1F3A6B, radius: 4)
        f.rect(3, 3, 54, 54, 0xFFFDF6, radius: 3)
        for (i, icon) in icons.prefix(4).enumerated() {
            let x = 7 + CGFloat(i % 2) * 24, y = 7 + CGFloat(i / 2) * 24
            icon.draw(f, in: CGRect(x: x, y: y, width: 22, height: 22), color: 0x1F3A6B, detail: 0xFFFDF6)
        }
    }

    // MARK: Crossing sign

    /// A blue sign on a tall pole (66 × 150): two banks with the water between, a dashed arc from
    /// one landing to the other with the ferry on it, and how long it takes (`text`).
    static func crossingSign(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 66, height: 150))
        G8Props.shadow(f, 22, 145, 22, 4)
        f.rect(31, 60, 4, 88, 0x5E6B73)
        f.rect(0, 0, 66, 66, 0xFFFDF6, radius: 4)
        f.rect(2.5, 2.5, 61, 61, 0x2F5BD3, radius: 3)
        f.rect(6, 28, 54, 20, 0x8FB6CF)
        f.rect(6, 22, 54, 6, 0x95B36B)
        f.rect(6, 48, 54, 6, 0x95B36B)
        f.dot(14, 50, 3, 0xFFFDF6)
        f.dot(52, 25, 3, 0xFFFDF6)
        var arc = Path()
        arc.move(to: CGPoint(x: 14, y: 50))
        arc.addQuadCurve(to: CGPoint(x: 52, y: 25), control: CGPoint(x: 36, y: 46))
        f.ctx.stroke(arc, with: .color(PalaceInk.hex(0xFFFDF6)), style: StrokeStyle(lineWidth: 1.6, dash: [3, 2.5]))
        PalaceIcon.g8Ferry.draw(f, in: CGRect(x: 24, y: 29, width: 16, height: 16), color: 0xFFFDF6, detail: 0x2F5BD3)
        f.text(p.text ?? "5 min", PropFont.heavy(11), 0xFFFDF6, at: CGPoint(x: 33, y: 12), maxWidth: 56)
    }

    // MARK: Arrived

    /// A traveller with a suitcase just stepped off onto the quay (80 × 96), a red map pin with a
    /// white tick over them.
    static func arrived(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 80, height: 96))
        PalaceFigures.person(f.within(CGRect(x: 4, y: 96 - 114 * 0.66, width: 64 * 0.66, height: 114 * 0.66), unit: 0.66),
                             PalacePropParams(variant: p.variant ?? 3, accessory: "suitcase"))
        let c = CGPoint(x: 62, y: 16)
        f.svg("M\(c.x) \(c.y + 24)C\(c.x - 4) \(c.y + 14) \(c.x - 13) \(c.y + 9) \(c.x - 13) \(c.y)A13 13 0 0 1 \(c.x + 13) \(c.y)C\(c.x + 13) \(c.y + 9) \(c.x + 4) \(c.y + 14) \(c.x) \(c.y + 24)Z", 0xC8261B)
        f.dot(c.x, c.y, 8, 0xFFFDF6)
        f.svgLine("M\(c.x - 4) \(c.y)L\(c.x - 1) \(c.y + 3.4)L\(c.x + 4.4) \(c.y - 3.4)", 0x1E7A4C, 2.2)
        f.oval(c.x - 6, c.y + 25, 12, 3, 0x1E1E1C, 0.15)
    }
}
