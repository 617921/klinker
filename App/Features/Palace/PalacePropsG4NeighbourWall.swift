import SwiftUI

/// Wall things in a neighbourhood centre: a map of the neighbourhood with one home pinned, a
/// drawing of a person linked to everything around them, and a planning board on an easel.
enum G4NeighbourWall {
    // MARK: Neighbourhood map

    /// A map poster (78 × 82): streets, a canal, a park, rows of little houses; one house has a red
    /// pin and a woman's face beside it. `caption` under the map ("hier woon ik").
    static func localMap(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 78, height: 82))
        f.rect(2, 3, 76, 79, 0x1E1E1C, radius: 2, 0.14)
        f.rect(0, 0, 76, 79, 0xFFFDF6, radius: 2)
        let map = CGRect(x: 4, y: 4, width: 68, height: 60)
        f.rect(map, 0xEFE6D0)
        var g = f
        g.ctx.clip(to: Path(map))
        g.ctx.translateBy(x: 0, y: -10)
        var h = f
        h.ctx.translateBy(x: 0, y: -10)
        g.oval(44, 52, 34, 26, 0xBFD9B7)
        g.dot(54, 62, 3, 0x6E9C52)
        g.dot(62, 58, 3, 0x6E9C52)
        g.svgLine("M0 40L80 24", 0x8FB6CF, 6)
        g.svgLine("M4 30H72M4 56H72M24 14V75M50 14V75", 0xFFFDF6, 3)
        let roofs: [UInt32] = [0xC8261B, 0x1F3A6B, 0x5E6B73]
        for (i, (x, y)) in ([(8.0, 17.0), (32, 17), (56, 15), (8, 44), (32, 42), (8, 60), (32, 60)] as [(CGFloat, CGFloat)]).enumerated() {
            g.rect(x, y + 4, 10, 7, 0xD9CDB4)
            g.svg("M\(x - 1) \(y + 4.5)L\(x + 5) \(y)L\(x + 11) \(y + 4.5)Z", roofs[i % 3])
        }
        // The pinned home and its resident
        g.ring(37, 49, 9, 0xC8261B, 1.4)
        h.svg("M37 47C33 41 33 35 37 33C41 35 41 41 37 47Z", 0xC8261B)
        h.dot(37, 37.5, 1.8, 0xFFFDF6)
        h.dot(58, 32, 9, 0xFFFDF6)
        h.ring(58, 32, 9, 0x5E6B73, 1)
        h.svg("M50 37L44 40L51 33Z", 0xFFFDF6)
        h.dot(58, 32, 5, 0xC99A74)
        h.svg("M52.6 31C52.6 26 55 25 58 25C61 25 63.4 26 63.4 31L64 37Q62 32 60 30Q57 32 54 31Q53 34 52 37Z", 0x4A3524)
        h.svg("M51 41Q58 35 65 41Z", 0x993556)
        if let caption = p.caption {
            f.text(caption, PropFont.demi(8.5), 0x1F3A6B, at: CGPoint(x: 38, y: 71.5), maxWidth: 68)
        }
    }

    // MARK: Involved

    /// A drawing (76 × 82): a person in the middle with lines to a house, a school, children, a
    /// group of neighbours and a heart all round them.
    static func network(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 82))
        f.rect(2, 3, 74, 79, 0x1E1E1C, radius: 2, 0.14)
        f.rect(0, 0, 74, 79, 0xFFFDF6, radius: 2)
        f.dot(37, 2.5, 2.4, 0xC8261B)
        let c = CGPoint(x: 37, y: 42)
        let spots: [(PalaceIcon, CGFloat, CGFloat)] = [(.house, 12, 16), (.school, 62, 16), (.children, 10, 66), (.g4Group, 64, 66), (.heart, 37, 12)]
        for (_, x, y) in spots { f.line(c.x, c.y, x, y, 0xF2711C, 1.6) }
        for (icon, x, y) in spots {
            f.dot(x, y, 9.5, 0xFFFDF6)
            f.ring(x, y, 9.5, 0xF2711C, 1.4)
            let colour: UInt32 = icon == .heart ? 0xC8261B : 0x1F3A6B
            icon.draw(f, in: CGRect(x: x - 6.5, y: y - 6.5, width: 13, height: 13), color: colour, detail: 0xFFFDF6)
        }
        f.dot(c.x, c.y, 14, 0xFAC775)
        let v = PalaceFigures.Look.at(p.variant ?? 7)
        f.svg("M27 54Q27 44 37 44Q47 44 47 54Z", v.coat)
        f.dot(c.x, 36, 6.5, v.skin)
        f.svg("M30.5 35C30.5 30 33.5 28.5 37 28.5C40.5 28.5 43.5 30 43.5 35C41.5 32.5 39.5 32 37 32C34.5 32 32.5 32.5 30.5 35Z", v.hair)
        f.svgLine("M34.5 38.5Q37 40.5 39.5 38.5", 0x8C5A3C, 1)
    }

    // MARK: Planning board

    /// A whiteboard on an easel (76 × 124): bunting along the top, a date `text`, a checklist of
    /// `icons` with ticks for the first `count` and an empty box for the rest, a marker in the tray.
    static func planBoard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 124))
        f.oval(4, 118, 68, 6, 0x1E1E1C, 0.14)
        f.svgLine("M14 120L24 70M62 120L52 70M38 120V80", 0x8C5E38, 3)
        f.rect(2, 6, 72, 82, 0x9A9890, radius: 2)
        f.rect(5, 9, 66, 76, 0xFFFDF6, radius: 1)
        f.rect(8, 86, 60, 4, 0x9A9890, radius: 1)
        f.rect(46, 83, 12, 3, 0x2F5BD3, radius: 1.5)
        let colours: [UInt32] = [0xC8261B, 0xFAC775, 0x2F5BD3, 0x5DCAA5, 0xF2711C]
        f.svgLine("M6 12Q38 22 70 12", 0x5E6B73, 0.8)
        for k in 0..<7 {
            let x = 8 + CGFloat(k) * 9
            let y = 12 + 4.2 * sin(Double(k) / 6 * .pi)
            f.svg("M\(x) \(y)H\(x + 7)L\(x + 3.5) \(y + 7)Z", colours[k % colours.count])
        }
        if let text = p.text {
            f.text(text, PropFont.heavy(10), 0xC8261B, at: CGPoint(x: 38, y: 30), maxWidth: 60)
        }
        let icons = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:))
        let done = p.count ?? max(0, icons.count - 1)
        for (i, icon) in icons.prefix(4).enumerated() {
            let y = 40 + CGFloat(i) * 14
            icon.draw(f, in: CGRect(x: 12, y: y, width: 11, height: 11), color: 0x1F3A6B, detail: 0xFFFDF6)
            f.svgLine("M27 \(y + 6)H52", 0xB4B2A9, 1.2)
            f.stroke(Path(CGRect(x: 56, y: y + 1, width: 10, height: 10)), 0x1F3A6B, 1.2)
            if i < done { f.svgLine("M57 \(y + 6)L60.5 \(y + 9.5)L67 \(y - 1)", 0x1E7A4C, 2.2) }
        }
    }
}
