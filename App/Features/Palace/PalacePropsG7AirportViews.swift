import SwiftUI

/// Airport views: a destination poster, the aisle seen through an open plane door, and planes
/// taking off or landing (seen through the window).
enum G7AirportViews {
    // MARK: Destination

    /// A poster on a stand (98 × 108): a sunny town by the sea with a palm, a big red map pin over
    /// it at the end of a dotted line from a little plane; `text` (the town) underneath.
    static func destination(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 98, height: 108))
        f.oval(10, 102, 78, 6, 0x1E1E1C, 0.15)
        f.svgLine("M22 88V104M76 88V104", 0x3E4C55, 3)
        f.rect(0, 0, 98, 90, 0x3E4C55, radius: 3)
        let pic = CGRect(x: 4, y: 4, width: 90, height: 70)
        f.rect(pic, 0x9FD0E8)
        var c = f
        c.ctx.clip(to: Path(pic))
        c.dot(20, 20, 9, 0xFAC775)
        c.rect(4, 52, 90, 22, 0x2F8FB8)
        c.svgLine("M10 60H22M40 66H56M70 58H84", 0xFFFFFF, 1.2)
        for (x, w, h) in [(46.0, 14.0, 20.0), (58, 12, 14), (68, 16, 24), (82, 12, 16)] as [(CGFloat, CGFloat, CGFloat)] {
            c.rect(x, 54 - h, w, h, 0xFFFDF6)
            c.svg("M\(x - 1) \(54 - h)L\(x + w / 2) \(48 - h)L\(x + w + 1) \(54 - h)Z", 0xE0743A)
            c.rect(x + 3, 58 - h, 3, 4, 0x2F8FB8)
        }
        c.svgLine("M36 56Q38 40 34 30", 0x8A5C38, 2.4)
        c.svg("M34 30Q24 24 18 32Q26 28 34 32Q30 22 22 20Q32 20 34 30Q40 20 48 22Q40 24 36 30Q46 28 50 34Q42 30 34 32Z", 0x3F8F4A)
        c.svgLine("M10 70Q30 50 56 36", 0xFFFDF6, 1.6)
        PalaceIcon.g7Plane.draw(c, in: CGRect(x: 4, y: 62, width: 12, height: 12), color: 0xFFFDF6, detail: 0x2F8FB8)
        // Map pin
        f.svg("M70 4C62 4 58 10 58 15C58 24 70 36 70 36C70 36 82 24 82 15C82 10 78 4 70 4Z", 0xC8261B)
        f.dot(70, 15, 4.2, 0xFFFDF6)
        f.rect(4, 74, 90, 12, 0xFFFDF6)
        if let text = p.text { f.text(text, PropFont.heavy(10), 0x1F3A6B, at: CGPoint(x: 49, y: 80.5), maxWidth: 84) }
    }

    // MARK: Aisle

    /// An open plane door at the end of the jet bridge (144 × 122): inside, rows of blue seats on
    /// both sides of a long aisle with little lights, running to the back of the cabin.
    static func aisle(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 144, height: 122))
        f.rect(0, 0, 144, 122, 0x8E8A80, radius: 4)
        f.rect(10, 0, 116, 122, 0xF4F1EA, radius: 20)
        f.rect(10, 52, 116, 6, 0x2F5BD3)
        let door = CGRect(x: 24, y: 10, width: 88, height: 112)
        f.rect(door, 0xEFEBE2, radius: 14)
        var c = f
        c.ctx.clip(to: Path(roundedRect: door, cornerRadius: 14))
        let vp = CGPoint(x: 68, y: 50)
        c.svg("M24 10H112L\(vp.x + 10) \(vp.y - 8)H\(vp.x - 10)Z", 0xFFFDF6)
        c.svg("M24 10L\(vp.x - 10) \(vp.y - 8)V\(vp.y - 2)L24 36Z M112 10L\(vp.x + 10) \(vp.y - 8)V\(vp.y - 2)L112 36Z", 0xD3D1C7)
        c.rect(vp.x - 10, vp.y - 8, 20, 18, 0xE3E1D8)
        c.svg("M24 122L\(vp.x - 4) \(vp.y + 10)H\(vp.x + 4)L112 122Z", 0xB4B2A9)
        c.svg("M50 122L\(vp.x - 2) \(vp.y + 10)H\(vp.x + 2)L86 122Z", 0x5E6B73)
        for k in 0..<6 {
            let t = 1 - CGFloat(k) / 6
            c.dot(vp.x - 2 - 14 * t, vp.y + 12 + 60 * t, 1 + t, 0xFAC775)
            c.dot(vp.x + 2 + 14 * t, vp.y + 12 + 60 * t, 1 + t, 0xFAC775)
        }
        for k in stride(from: 4, through: 0, by: -1) {
            let t = 1 - CGFloat(k) * 0.19
            let h = 36 * t, w = 22 * t
            let bottom = vp.y + 10 + 62 * t
            let inner = 6 + 12 * t
            for side in [-1.0, 1.0] as [CGFloat] {
                let x0 = side < 0 ? vp.x - inner - w : vp.x + inner
                c.rect(x0, bottom - h, w, h, 0x2F5BD3, radius: 3 * t)
                c.rect(x0, bottom - h, w, h * 0.22, 0xFFFDF6, radius: 2 * t)
                c.rect(x0 + (side < 0 ? 0 : w - 4 * t), bottom - h * 0.4, 4 * t, h * 0.4, 0x21468B)
            }
        }
        // The door itself, swung open against the fuselage
        f.svg("M112 14Q126 16 130 30V112Q126 120 112 120Z", 0xE3E1D8)
        f.rect(118, 52, 6, 16, 0x8E8A80, radius: 2)
    }

    // MARK: Plane

    /// A plane over the runway (178 × 98): `accessory` "up" climbs away nose up, wheels tucked,
    /// with a green arrow up; "down" comes in nose down, wheels out, with a blue arrow down.
    static func plane(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 178, height: 98))
        let up = p.accessory != "down"
        if up {
            f.svgLine("M40 96Q80 92 100 76", 0xFFFFFF, 2.4, 0.8)
            jet(f, at: CGPoint(x: 112, y: 54), angle: -20, scale: 1.1, wheels: false)
            f.svgLine("M14 72L44 30", 0x1E7A4C, 5)
            f.svg("M32 26L52 16L48 38Z", 0x1E7A4C)
        } else {
            jet(f, at: CGPoint(x: 72, y: 40), angle: 9, scale: 1.1, wheels: true)
            f.svgLine("M150 12L166 52", 0x2F5BD3, 5)
            f.svg("M154 50L172 66L176 42Z", 0x2F5BD3)
        }
    }

    /// A white airliner seen from the side, nose right, centred on `at` (120 × 40 at scale 1).
    static func jet(_ f: PropPen, at c: CGPoint, angle: Double, scale: CGFloat, wheels: Bool) {
        var j = f
        j.ctx.translateBy(x: c.x, y: c.y)
        j.ctx.rotate(by: .degrees(angle))
        j.ctx.scaleBy(x: scale, y: scale)
        j.ctx.translateBy(x: -60, y: -20)
        if wheels {
            j.svgLine("M34 26V34M96 26V34", 0x5E6B73, 1.6)
            j.dot(34, 35, 2.6, 0x1E1E1C)
            j.dot(96, 35, 2.6, 0x1E1E1C)
        }
        j.svg("M10 12L4 0H14L28 12Z", 0x2F5BD3)
        j.svg("M8 18Q8 12 16 12H100Q114 12 120 20Q114 28 100 28H16Q8 28 8 22Z", 0xFFFDF6)
        j.svg("M6 20L0 25H18Z", 0xD3D1C7)
        j.rect(10, 22, 104, 2.4, 0x2F5BD3)
        for x in stride(from: CGFloat(26), through: 96, by: 6) { j.dot(x, 17, 1.4, 0x3E4C55) }
        j.svg("M106 15H113L117 19H108Z", 0x3E4C55)
        j.svg("M48 22H70L56 38H44Z", 0xD3D1C7)
        j.rect(52, 27, 16, 7, 0xB4B2A9, radius: 3.5)
    }
}
