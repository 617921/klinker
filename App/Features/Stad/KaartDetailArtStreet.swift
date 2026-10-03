import SwiftUI

/// Street life, food stands, boats and seasonal things. Each draws in its own design box
/// (see `KaartDetailArt.draw`), facing right.
nonisolated extension KaartDetailArt {
    private static let skins: [UInt32] = [0xE8C4A0, 0xC99A74, 0x8C5A3C, 0xF0D2B4]
    private static let hairs: [UInt32] = [0x3A2A1E, 0xC9A15B, 0x1E1E1C, 0x8C4A2A]

    /// A striped market awning from x to x+w, hanging from y, with snow on it in winter.
    private static func canopy(_ p: KaartDetailPen, x: Double, y: Double, w: Double, drop: Double, color: UInt32, winter: Bool) {
        p.poly([(x, y + drop), (x + w, y + drop), (x + w - 2, y), (x + 2, y)], color)
        var at = x + 3
        while at < x + w - 3 {
            p.poly([(at, y + 0.4), (at + 2.8, y + 0.4), (at + 3.2, y + drop - 0.4), (at + 0.4, y + drop - 0.4)], 0xFFFDF6)
            at += 6.5
        }
        if winter { p.rect(x + 1.5, y - 1.4, w - 3, 2, 0xF6F7F4, corner: 1) }
    }

    /// The Dutch flag on a pole, waving: pole foot at (x, foot), flag `w` wide at the top.
    private static func dutchFlag(_ p: KaartDetailPen, x: Double, top: Double, foot: Double, w: Double, t: Double) {
        p.line([(x, foot), (x, top)], 0x5F5E5A, width: 0.9)
        let band = w * 0.3
        for (i, color) in [0xAE1C28, 0xFFFDF6, 0x21468B].enumerated() {
            let y0 = top + Double(i) * band
            var points: [(Double, Double)] = []
            for k in 0...4 {
                let fx = Double(k) / 4
                points.append((x + 0.4 + fx * w, y0 + sin(t * 5 - fx * 4) * fx * 0.9))
            }
            for k in (0...4).reversed() {
                let fx = Double(k) / 4
                points.append((x + 0.4 + fx * w, y0 + band + sin(t * 5 - fx * 4) * fx * 0.9))
            }
            p.poly(points, UInt32(color))
        }
    }

    /// A spoked wheel, `turn` radians around.
    private static func wheel(_ p: KaartDetailPen, _ cx: Double, _ cy: Double, r: Double, color: UInt32, turn: Double = 0) {
        p.ring(cx, cy, r - 0.5, color, width: 1.2)
        var spokes: [(Double, Double)] = []
        for i in 0..<3 {
            let a = turn + Double(i) * .pi / 3
            spokes = [(cx + cos(a) * r, cy + sin(a) * r), (cx - cos(a) * r, cy - sin(a) * r)]
            p.line(spokes, color, width: 0.5)
        }
        p.dot(cx, cy, r * 0.22, color)
    }

    /// Steam rising in two wisps from (x, y).
    private static func steam(_ p: KaartDetailPen, x: Double, y: Double, t: Double) {
        for i in 0..<2 {
            let phase = ((t * 0.6 + Double(i) * 0.5).truncatingRemainder(dividingBy: 1))
            let sway = sin(t * 2 + Double(i)) * 0.8
            var path = Path()
            path.move(to: CGPoint(x: x + Double(i) * 3, y: y - phase * 5))
            path.addQuadCurve(to: CGPoint(x: x + Double(i) * 3 + sway, y: y - 3.5 - phase * 5), control: CGPoint(x: x + Double(i) * 3 + 1.6, y: y - 1.8 - phase * 5))
            p.ctx.stroke(path, with: .color(.white.opacity(0.85 * (1 - phase))), style: StrokeStyle(lineWidth: 0.9, lineCap: .round))
        }
    }

    // MARK: Food stands

    /// A stroopwafel cart: a striped canopy, a stack of syrup waffles and one big waffle on the front.
    static func stroopwafel(_ p: KaartDetailPen, t: Double, winter: Bool) {
        p.shadow(20, 38.4, 36)
        p.line([(5.5, 12), (5.5, 24)], 0x6B4A2E, width: 1)
        p.line([(34.5, 12), (34.5, 24)], 0x6B4A2E, width: 1)
        p.head(25, 16.5, r: 2.4, skin: 0xE8C4A0, hair: 0x8C4A2A, shirt: 0xFFFDF6)
        canopy(p, x: 2, y: 7, w: 36, drop: 6, color: 0xC8261B, winter: winter)
        p.rect(4, 24, 32, 10, 0x2F4B3A)
        p.rect(2.5, 22.4, 35, 2, 0xD9CDB4)
        for i in 0..<4 {
            p.oval(7, 20.6 - Double(i) * 1.5, 12, 2.6, 0xC98A3C)
            p.line([(7.4, 21.9 - Double(i) * 1.5), (18.6, 21.9 - Double(i) * 1.5)], 0x8A5A24, width: 0.4)
        }
        steam(p, x: 11, y: 15.5, t: t)
        // The big waffle on the front, with its grid.
        p.dot(20, 29, 4.6, 0xD9A04A)
        var grid = p.ctx
        grid.clip(to: Path(ellipseIn: CGRect(x: 15.4, y: 24.4, width: 9.2, height: 9.2)))
        var lines = Path()
        for k in -3...3 {
            let o = Double(k) * 2.2
            lines.move(to: CGPoint(x: 14 + o, y: 24)); lines.addLine(to: CGPoint(x: 24 + o, y: 34))
            lines.move(to: CGPoint(x: 26 + o, y: 24)); lines.addLine(to: CGPoint(x: 16 + o, y: 34))
        }
        grid.stroke(lines, with: .color(p.color(0x9A6428)), lineWidth: 0.5)
        p.ring(20, 29, 4.6, 0x9A6428, width: 0.6)
        wheel(p, 10, 34.4, r: 4.4, color: 0x3A3632)
        wheel(p, 30, 34.4, r: 4.4, color: 0x3A3632)
    }

    /// A fries kiosk with a giant paper cone of fries (and mayo) on the roof.
    static func friet(_ p: KaartDetailPen, t: Double, winter: Bool) {
        p.shadow(18, 45, 34)
        // Kiosk: front, side and roof.
        p.poly([(29, 45), (34, 42), (34, 19.5), (29, 22)], 0xD9CDB4)
        p.rect(3, 22, 26, 23, 0xF4EEE2)
        p.poly([(1.5, 19.5), (6.5, 16.5), (35.5, 16.5), (30.5, 19.5)], 0x9E1E16)
        p.rect(1.5, 19.5, 29, 3, 0xC8261B)
        if winter { p.poly([(2, 18.6), (6.6, 15.8), (35, 15.8), (30.4, 18.6)], 0xF6F7F4) }
        p.rect(6, 25, 20, 9, 0x3A3632)
        p.head(17, 29, r: 2.3, skin: 0xC99A74, hair: 0xFFFDF6, shirt: 0xFFFDF6)
        p.rect(5, 33.6, 22, 2, 0xC8261B)
        p.rect(3, 41, 26, 4, 0xC8261B)
        // Two cones on the counter.
        p.poly([(8, 31.6), (11, 31.6), (9.5, 33.8)], 0xFFFDF6)
        p.rect(8.4, 30.4, 2.2, 1.4, 0xF6C84A)
        // The big cone: fries, mayo, and the striped paper.
        for (i, x) in [12.6, 15, 17.4, 19.8, 22.2].enumerated() {
            let lean = Double(i - 2) * 0.7
            p.line([(x, 6.5), (x + lean, 1.5 + Double(i % 2))], 0xF6C84A, width: 2)
        }
        p.dot(19.2, 4.4, 2.6, 0xFFFDF6)
        p.dot(16.2, 5.2, 1.6, 0xFFFDF6)
        p.poly([(11, 5.5), (25, 5.5), (18, 17)], 0xFFFDF6)
        p.poly([(14.2, 5.5), (16.6, 5.5), (18.3, 14.6), (17.4, 15.6)], 0xC8261B)
        p.poly([(20.4, 5.5), (22.6, 5.5), (19.3, 13.6), (18.6, 12)], 0xC8261B)
    }

    /// A herring cart flying the Dutch flag, and a customer eating a herring the Dutch way.
    static func haring(_ p: KaartDetailPen, t: Double, winter: Bool) {
        p.shadow(22, 37, 42)
        dutchFlag(p, x: 39.5, top: 1, foot: 32, w: 6.5, t: t)
        canopy(p, x: 6, y: 8, w: 32, drop: 4.5, color: 0x1F3A6B, winter: winter)
        p.rect(8, 12.5, 28, 5.5, 0xBFDCEA)
        for x in [11.0, 18, 25] {
            p.oval(x, 14.2, 6, 2.2, 0xB8C4CC)
            p.oval(x + 0.4, 14.2, 5.2, 1, 0x5E6B73)
            p.poly([(x, 15.3), (x - 1.8, 14.2), (x - 1.8, 16.4)], 0xB8C4CC)
        }
        p.rect(7, 18, 30, 12, 0xF4F1EA)
        p.rect(9, 20, 12, 8, 0x1F3A6B)
        p.rect(23, 20, 12, 8, 0x1F3A6B)
        wheel(p, 13, 31.5, r: 4, color: 0x3A3632)
        wheel(p, 31, 31.5, r: 4, color: 0x3A3632)
        // The customer: head back, herring held up by the tail.
        p.line([(2.6, 31), (2.2, 37)], 0x2C2C2A, width: 1.3)
        p.line([(4.2, 31), (4.8, 37)], 0x2C2C2A, width: 1.3)
        p.rect(1, 21, 5, 11, 0xC99A2C, corner: 1.8)
        p.dot(3.2, 18.6, 2.3, 0xE8C4A0)
        p.dot(2.6, 17.7, 1.6, 0x3A2A1E)
        p.line([(5, 22.5), (6.4, 15.5)], 0xC99A2C, width: 1.2)
        p.oval(5.2, 10.6, 1.6, 5, 0xB8C4CC)
        p.poly([(6, 10.8), (4.8, 9), (7.2, 9)], 0x8E98A8)
    }

    /// A farm cheese stand: a little roof, wheels of yellow cheese and a red-waxed ball.
    static func kaas(_ p: KaartDetailPen, winter: Bool) {
        p.shadow(17, 27.4, 32)
        p.line([(4, 9), (4, 27)], 0x6B4A2E, width: 1.4)
        p.line([(30, 9), (30, 27)], 0x6B4A2E, width: 1.4)
        p.poly([(1, 10), (33, 10), (30, 4.5), (4, 4.5)], 0x7A1E1E)
        p.rect(1, 9.6, 32, 1.2, 0x5B1A14)
        if winter { p.rect(3.6, 3.4, 26.8, 2, 0xF6F7F4, corner: 1) }
        p.rect(3, 18, 28, 2, 0x8A6240)
        p.line([(6, 20), (6, 27)], 0x8A6240, width: 1.2)
        p.line([(28, 20), (28, 27)], 0x8A6240, width: 1.2)
        for (x, y, w) in [(5.0, 14.2, 10.0), (5.6, 10.6, 8.8), (17, 14.2, 9.6)] {
            p.rect(x, y, w, 3.8, 0xE0A82E, corner: 1.4)
            p.oval(x + 0.3, y - 0.2, w - 0.6, 1.8, 0xF6D873)
        }
        p.dot(29, 15.8, 2.3, 0xD8342C)
        p.rect(8, 22.5, 12, 4.5, 0x8A6240)
        p.oval(9.2, 21.6, 4.4, 2.2, 0xF2C53D)
        p.oval(14.2, 21.6, 4.4, 2.2, 0xF2C53D)
    }

    /// The winter oliebollen stand: a fairground-style booth with a pile of sugared doughnut balls.
    static func oliebol(_ p: KaartDetailPen, t: Double) {
        p.shadow(23, 37.5, 44)
        p.rect(3, 13, 40, 22, 0xFFF6E6)
        p.rect(3, 30, 40, 5, 0xC8261B)
        p.poly([(3, 13.5), (3, 9.5), (10, 7.5), (16, 5), (23, 3), (30, 5), (36, 7.5), (43, 9.5), (43, 13.5)], 0xC8261B)
        p.poly([(6, 13.5), (6, 11), (12, 9.4), (17, 7.4), (23, 5.8), (29, 7.4), (34, 9.4), (40, 11), (40, 13.5)], 0xF2C53D)
        for (x, y) in [(5.0, 9.6), (11, 7.8), (17, 5.6), (23, 3.6), (29, 5.6), (35, 7.8), (41, 9.6)] {
            p.glow.dot(x, y, 0.8, 0xF6D27A)
        }
        p.rect(7, 16, 32, 10, 0x3A2A22)
        p.head(32, 20, r: 2.3, skin: 0xE8C4A0, hair: 0xFFFDF6, shirt: 0xFFFDF6)
        p.rect(6, 25.5, 34, 2, 0xF4EEE2)
        for (x, y) in [(12.0, 23.8), (16.2, 23.8), (20.4, 23.8), (24.6, 23.8), (14.1, 20.6), (18.3, 20.6), (22.5, 20.6), (16.2, 17.6), (20.4, 17.6)] {
            p.dot(x, y, 2.1, 0x9A5A2A)
            p.dot(x - 0.5, y - 0.9, 0.9, 0xFFFDF6)
        }
        steam(p, x: 16, y: 15, t: t)
        wheel(p, 10, 35.6, r: 2.4, color: 0x3A3632)
        wheel(p, 36, 35.6, r: 2.4, color: 0x3A3632)
    }

    /// An ice cream bike cart under a pink parasol.
    static func ijsje(_ p: KaartDetailPen, t: Double) {
        p.shadow(18, 37, 32)
        p.line([(18, 7), (18, 21)], 0x5F5E5A, width: 0.9)
        var top = Path()
        top.move(to: CGPoint(x: 4, y: 10))
        top.addQuadCurve(to: CGPoint(x: 32, y: 10), control: CGPoint(x: 18, y: -4))
        top.closeSubpath()
        p.fill(top, 0xF4A0B8)
        var stripes = p.ctx
        stripes.clip(to: top)
        for x in [9.0, 16.5, 24] { stripes.fill(Path(CGRect(x: x, y: 0, width: 3.5, height: 11)), with: .color(p.color(0xFFFDF6))) }
        p.rect(7, 20, 22, 11, 0x9ED9C4, corner: 1.5)
        p.oval(9.5, 18.6, 7, 3, 0xC9D2D6)
        p.oval(19.5, 18.6, 7, 3, 0xC9D2D6)
        p.poly([(15.4, 25), (20.6, 25), (18, 30.4)], 0xD9A441)
        p.dot(18, 24, 2.6, 0xF4A0B8)
        p.dot(17, 22.4, 1.3, 0xFFFDF6)
        wheel(p, 10, 33, r: 4, color: 0x3A3632)
        wheel(p, 26, 33, r: 4, color: 0x3A3632)
        p.line([(7, 22), (3, 18), (1.5, 18)], 0x3A3632, width: 1)
    }

    // MARK: Street life

    /// A street organ: an ornate painted cabinet with pipes, and its man turning the crank.
    static func draaiorgel(_ p: KaartDetailPen, t: Double, winter: Bool) {
        p.shadow(24, 41.4, 48)
        p.poly([(37, 34), (41, 31), (41, 10), (37, 10)], 0x5B1A1A)
        p.rect(3, 28, 36, 6, 0x7A1E1E)
        p.line([(3, 29.5), (39, 29.5)], 0xD9A441, width: 0.7)
        p.rect(5, 10, 32, 18, 0x2F5B8A)
        p.poly([(5, 10.5), (12, 6), (21, 2), (30, 6), (37, 10.5)], 0xD9A441)
        p.poly([(9, 10.5), (14, 7.4), (21, 4.4), (28, 7.4), (33, 10.5)], 0xC8261B)
        p.dot(21, 7, 1.8, 0xF2C53D)
        if winter { p.poly([(6, 9.8), (12, 5.2), (21, 1.2), (30, 5.2), (36, 9.8), (30, 6.4), (21, 2.6), (12, 6.4)], 0xF6F7F4) }
        p.ring(21, 19, 9, 0xD9A441, width: 0.6)
        for i in 0..<9 {
            let x = 10.6 + Double(i) * 2.6
            let h = 12 - abs(Double(i) - 4) * 1.6
            p.rect(x, 26 - h, 1.8, h, i % 2 == 0 ? 0xF0E2B6 : 0xD9A441, corner: 0.8)
        }
        p.oval(6.4, 13, 3.4, 9, 0x5E8C45)
        p.oval(32.2, 13, 3.4, 9, 0x5E8C45)
        wheel(p, 9, 37, r: 4, color: 0x5B3328)
        wheel(p, 21, 37, r: 4, color: 0x5B3328)
        wheel(p, 33, 37, r: 4, color: 0x5B3328)
        // The organ man: cap, coat, and the crank going round.
        let a = t * 4
        let handle = (41.6 + cos(a) * 3, 22 + sin(a) * 3)
        p.line([(46, 31), (45.4, 41)], 0x2C2C2A, width: 1.5)
        p.line([(48, 31), (48.6, 41)], 0x2C2C2A, width: 1.5)
        p.rect(43.5, 21.5, 6.5, 11, 0x3F5A4A, corner: 2)
        p.dot(46.6, 18.6, 2.5, 0xE8C4A0)
        p.rect(43.8, 15.4, 5.8, 2.2, 0x2C2C2A, corner: 1)
        p.line([(43.5, 16.8), (42.2, 17.2)], 0x2C2C2A, width: 0.8)
        p.line([(41.6, 22), handle], 0x5F5E5A, width: 0.9)
        p.line([(45, 23.5), handle], 0x3F5A4A, width: 1.5)
        p.dot(handle.0, handle.1, 0.9, 0xE8C4A0)
    }

    /// A bike covered in flowers, with a basket full of them.
    static func bloemenfiets(_ p: KaartDetailPen, season: GevelSeason) {
        p.shadow(20, 27, 34)
        bike(p, rear: (9, 20), front: (31, 20), frame: 0x5E8C45)
        p.rect(26.5, 4.5, 9, 5, 0xB08850, corner: 1)
        let blooms: [UInt32] = [0xD8342C, 0xF2C53D, 0xF4A0B8, 0xFFFDF6, 0xF2711C, 0x7B4FA0]
        // Along the frame: leaves, then flowers.
        let frame: [(Double, Double)] = [(10.5, 18), (13, 13.4), (15, 10.5), (17, 19.2), (19.5, 15), (22.5, 11.5), (25.4, 9.4), (11.6, 20), (6.5, 16.5)]
        for (i, q) in frame.enumerated() {
            p.dot(q.0 + 0.8, q.1 + 0.6, 1.2, 0x5E8C45)
            p.dot(q.0, q.1, 1.1, blooms[i % blooms.count])
        }
        for (i, x) in [27.5, 29.6, 31.8, 34, 28.6, 30.8, 33].enumerated() {
            let y = i < 4 ? 4.2 : 2.4
            p.dot(x + 0.6, y + 0.8, 1.2, 0x4E7A3A)
            p.dot(x, y, 1.3, blooms[(i + 2) % blooms.count])
        }
    }

    /// A cargo bike: a parent pedalling, two children in the wooden box in front, one waving.
    static func bakfiets(_ p: KaartDetailPen, t: Double) {
        p.shadow(26, 31, 44)
        let turn = t * 6
        wheel(p, 10, 25.5, r: 5.6, color: 0x1E1E1C, turn: turn)
        wheel(p, 42, 27, r: 4, color: 0x1E1E1C, turn: turn * 1.4)
        let frame: UInt32 = 0x2C2C2A
        p.line([(10, 25.5), (17, 25.5), (14, 14), (10, 25.5)], frame, width: 1.4)
        p.line([(17, 25.5), (24, 25), (42, 27)], frame, width: 1.4)
        p.line([(14, 14), (14, 12.6)], frame, width: 1.2)
        p.rect(11.6, 11.4, 5, 1.6, 0x6B4A2E, corner: 0.8)
        // Children in the box.
        p.head(29, 12, r: 2.6, skin: 0xF0D2B4, hair: 0xD8342C)
        p.head(36.5, 12.4, r: 2.4, skin: 0xC99A74, hair: 0x1E1E1C)
        let wave = sin(t * 6)
        p.line([(38.4, 14), (40.2 + wave, 8)], 0xC99A74, width: 1)
        p.poly([(22, 14), (46, 14), (44, 25), (24, 25)], 0xA87A48)
        p.line([(23, 18.5), (45.2, 18.5)], 0x8A5A30, width: 0.6)
        p.line([(23.6, 22), (44.6, 22)], 0x8A5A30, width: 0.6)
        // The parent: legs on the turning pedals, hands on the long handlebar.
        let crank = (17.0, 25.5)
        for k in [0.0, Double.pi] {
            let pedal = (crank.0 + cos(turn + k) * 2.6, crank.1 + sin(turn + k) * 2.6)
            let knee = ((14 + pedal.0) / 2 + 3, (13 + pedal.1) / 2 - 2)
            p.line([(14, 13), knee, pedal], k == 0 ? 0x1F3A6B : 0x2B4A80, width: 1.6)
        }
        p.line([(20.5, 6.5), (21, 12), (23, 14)], frame, width: 1.1)
        p.rect(12, 4.5, 5.4, 9.5, 0xF2711C, corner: 2)
        p.line([(16.5, 6.5), (21, 7)], 0xF2711C, width: 1.4)
        p.head(15.6, 2.8, r: 2.4, skin: 0xE8C4A0, hair: 0x8C4A2A)
    }

    /// A row of Amsterdammertjes: the brown cast-iron posts along the pavement.
    static func paaltje(_ p: KaartDetailPen, winter: Bool) {
        for x in [6.0, 17.5, 29, 40.5] {
            p.oval(x - 3, 13.4, 7, 2, 0x1E1E1C)
            p.rect(x - 2, 4, 4, 11, 0x5B2A1E, corner: 1)
            p.dot(x, 4, 2.2, 0x5B2A1E)
            p.line([(x - 0.8, 4), (x - 0.8, 13.5)], 0x7E3E2C, width: 0.6)
            p.rect(x - 2.5, 7.4, 5, 0.9, 0x4A2016)
            if winter { p.dot(x, 2.8, 1.8, 0xF6F7F4) }
        }
    }

    /// The floating flower market: zinc buckets of tulips under a green awning.
    static func tulp(_ p: KaartDetailPen, t: Double) {
        p.rect(1, 21.5, 38, 3, 0x8A6240)
        p.line([(3, 6), (3, 21.5)], 0x6B4A2E, width: 1)
        p.line([(37, 6), (37, 21.5)], 0x6B4A2E, width: 1)
        p.rect(3, 13.4, 34, 1.8, 0x8A6240)
        p.poly([(0, 6.5), (40, 6.5), (38, 2), (2, 2)], 0x2F4B3A)
        var at = 4.0
        while at < 36 {
            p.poly([(at, 2.3), (at + 2.6, 2.3), (at + 3, 6.2), (at + 0.4, 6.2)], 0xFFFDF6)
            at += 6.4
        }
        let colors: [UInt32] = [0xD8342C, 0xF2C53D, 0xF4A0B8, 0xF2711C, 0x7B4FA0, 0xFFFDF6, 0xD8342C]
        func bucket(_ x: Double, _ base: Double, _ i: Int) {
            let sway = sin(t * 1.4 + Double(i)) * 0.3
            for k in 0..<3 {
                let fx = x + 1.2 + Double(k) * 1.6
                p.line([(fx, base - 3.5), (fx + sway, base - 6.4)], 0x5E8C45, width: 0.5)
                p.oval(fx - 0.9 + sway, base - 8.2, 1.9, 2.2, colors[(i + k) % colors.count])
            }
            p.poly([(x, base - 4), (x + 6.4, base - 4), (x + 5.6, base), (x + 0.8, base)], 0xA7B0B6)
            p.rect(x - 0.2, base - 4.4, 6.8, 0.9, 0x7E8890)
        }
        for (i, x) in [5.0, 12.5, 20, 27.5].enumerated() { bucket(x, 13.4, i) }
        for (i, x) in [8.5, 16, 23.5, 31].enumerated() { bucket(x, 21.5, i + 4) }
    }

    /// A man fishing from the quay on a folding stool, his float bobbing on the water.
    static func hengel(_ p: KaartDetailPen, t: Double) {
        let bob = max(0, sin(t * 2.2)) * 0.8 + pulse(t, period: 6, share: 0.12) * 1.6
        p.shadow(11, 23, 18)
        // Line and float on the water.
        p.line([(28.5, 3), (28.5, 18.6 + bob)], 0xF4F1EA, width: 0.35)
        p.dot(28.5, 19 + bob, 1.1, 0xC8261B)
        p.rect(27.4, 19 + bob, 2.2, 1, 0xFFFDF6)
        // Stool, bucket and the fisherman.
        p.line([(6, 23), (11, 17)], 0x5F5E5A, width: 0.8)
        p.line([(11, 23), (6, 17)], 0x5F5E5A, width: 0.8)
        p.rect(5, 16.2, 7, 1.3, 0x2F4B3A)
        p.poly([(14.5, 18.5), (19, 18.5), (18.4, 23), (15.1, 23)], 0x2F5BD3)
        p.line([(10, 16.5), (14.5, 16.5), (14.5, 22.6)], 0x3A3632, width: 1.6)
        p.rect(6.4, 8.6, 6, 8.4, 0x5E8C45, corner: 2)
        p.dot(9.6, 6.6, 2.3, 0xE8C4A0)
        p.poly([(6.6, 6), (12.6, 6), (11.8, 3.8), (7.4, 3.8)], 0x8A6240)
        p.rect(5.8, 5.6, 7.6, 1, 0x8A6240)
        // The rod, from his hands out over the water.
        p.line([(11.6, 12.6), (14.6, 12)], 0x5E8C45, width: 1.2)
        p.line([(13.6, 13.4), (28.5, 3)], 0x3A3632, width: 0.7)
    }

    // MARK: Boats

    /// A canal tour boat: long and low, with a glass roof full of sightseers.
    static func rondvaartboot(_ p: KaartDetailPen, t: Double) {
        p.wake(4, 66, 17.6)
        p.line([(0.5, 13), (6, 15.4)], 0xFFFDF6, width: 0.7, opacity: p.night ? 0.3 : 0.8)
        p.line([(0.5, 19), (6, 16.8)], 0xFFFDF6, width: 0.7, opacity: p.night ? 0.3 : 0.8)
        var hull = Path()
        hull.move(to: CGPoint(x: 4, y: 11))
        hull.addLine(to: CGPoint(x: 61, y: 11))
        hull.addQuadCurve(to: CGPoint(x: 64, y: 17.5), control: CGPoint(x: 70, y: 12.5))
        hull.addLine(to: CGPoint(x: 7, y: 17.5))
        hull.addQuadCurve(to: CGPoint(x: 4, y: 11), control: CGPoint(x: 3.5, y: 16))
        p.fill(hull, 0x1F3A6B)
        p.line([(6, 13.8), (64, 13.8)], 0xF4F1EA, width: 0.9)
        // Sightseers under the glass.
        for i in 0..<8 {
            p.head(14.5 + Double(i) * 6, 8.6, r: 1.6, skin: skins[i % skins.count], hair: hairs[(i * 3) % hairs.count])
        }
        let glass = CGRect(x: 10, y: 3.6, width: 50, height: 7.8)
        p.ctx.fill(Path(roundedRect: glass, cornerRadius: 3.6), with: .color(p.night ? StadInk.hex(0xF6D27A, 0.45) : StadInk.hex(0xCFE6EF, 0.55)))
        p.ctx.stroke(Path(roundedRect: glass, cornerRadius: 3.6), with: .color(p.color(0x8FA6B2)), lineWidth: 0.7)
        var mullions: [(Double, Double)] = []
        for x in stride(from: 17.0, through: 53, by: 6) {
            mullions = [(x, 4.2), (x, 11)]
            p.line(mullions, 0x8FA6B2, width: 0.5)
        }
        p.line([(12, 4.6), (58, 4.6)], 0xFFFDF6, width: 0.7, opacity: 0.8)
        // The skipper at the stern, and the flag.
        p.head(6.6, 7.4, r: 1.7, skin: 0xE8C4A0, hair: 0x1F3A6B, shirt: 0xFFFDF6)
        dutchFlag(p, x: 2.4, top: 2, foot: 11, w: 3.6, t: t)
    }

    /// A small open boat full of friends, one waving, the Dutch flag at the stern.
    static func sloep(_ p: KaartDetailPen, t: Double) {
        p.wake(3, 44, 17.4)
        p.rect(0.6, 9.5, 3, 6, 0x2C2C2A, corner: 0.8)
        dutchFlag(p, x: 4.6, top: 2.4, foot: 11, w: 4, t: t)
        let shirts: [UInt32] = [0xC8261B, 0xF2C53D, 0x2F5BD3, 0x5E8C45]
        for (i, x) in [12.0, 20, 28, 36].enumerated() {
            p.head(x, 7.2 - Double(i % 2) * 0.4, r: 2.1, skin: skins[(i + 1) % skins.count], hair: hairs[i % hairs.count], shirt: shirts[i])
        }
        let wave = sin(t * 5) * 0.9
        p.line([(29.6, 9), (31 + wave, 2.6)], skins[3], width: 1.1)
        p.poly([(2, 11), (42, 11), (45.5, 12.4), (40, 17.4), (6, 17.4), (3, 14.5)], 0xF4F1EA)
        p.line([(2.4, 11), (42, 11)], 0x8A5A34, width: 1.6)
        p.line([(6, 15.8), (40.5, 15.8)], 0x1F3A6B, width: 1)
    }

    /// A pedal boat on the lake, paddle wheel turning.
    static func waterfiets(_ p: KaartDetailPen, t: Double) {
        p.wake(2, 29, 17.5)
        let turn = t * 3
        p.head(12, 5, r: 2.1, skin: 0xE8C4A0, hair: 0xC9A15B, shirt: 0xF2711C)
        p.head(17.6, 5.4, r: 2.1, skin: 0x8C5A3C, hair: 0x1E1E1C, shirt: 0x2F5BD3)
        for (i, x) in [13.0, 18.6].enumerated() {
            let k = sin(turn + Double(i) * .pi) * 1.2
            p.line([(x, 10), (x + 3, 9.5 + k), (x + 4.4, 12.4)], 0x3A3632, width: 1)
        }
        p.rect(7.5, 6, 2, 7, 0xFFFDF6, corner: 0.6)
        p.rect(2, 12, 26, 4.4, 0xF2C53D, corner: 2.2)
        p.line([(3.5, 14.2), (26.5, 14.2)], 0xD9A441, width: 0.5)
        wheel(p, 4.5, 12, r: 3.6, color: 0xFFFDF6, turn: -turn)
    }

    /// A wooden rowing boat with one rower pulling at the oars.
    static func roeiboot(_ p: KaartDetailPen, t: Double) {
        let stroke = sin(t * 2.4)
        p.wake(3, 32, 13.6)
        p.line([(16 + stroke * 1.5, 7.2), (16 - stroke * 9, 13.4)], 0xC49A64, width: 0.8)
        p.oval(15 - stroke * 9 - 1.4, 12.6, 3, 1.6, 0xC49A64)
        p.rect(14 + stroke * 1.2, 4.5, 4.6, 5, 0x1F3A6B, corner: 1.6)
        p.line([(14.4 + stroke * 1.2, 6.2), (18.2 + stroke * 1.2, 6.2)], 0xFFFDF6, width: 0.5)
        p.line([(14.4 + stroke * 1.2, 7.8), (18.2 + stroke * 1.2, 7.8)], 0xFFFDF6, width: 0.5)
        p.head(16.6 + stroke * 1.6, 3, r: 1.9, skin: 0xE8C4A0, hair: 0x8C4A2A)
        p.poly([(2, 9), (32, 9), (28.5, 13.5), (5.5, 13.5)], 0x9A6A3C)
        p.line([(3.5, 10.6), (30.5, 10.6)], 0xC49A64, width: 0.6)
    }

    // MARK: Countryside and seasons

    /// A red tractor chugging along, smoke puffing from its pipe.
    static func trekker(_ p: KaartDetailPen, t: Double) {
        p.shadow(23, 33.4, 42)
        let turn = t * 2.5
        for i in 0..<3 {
            let phase = (t * 0.8 + Double(i) / 3).truncatingRemainder(dividingBy: 1)
            p.ctx.fill(Path(ellipseIn: CGRect(x: 34 + phase * 3 - (1 + phase * 1.6), y: 6 - phase * 6 - (1 + phase * 1.6), width: 2 + phase * 3.2, height: 2 + phase * 3.2)),
                       with: .color(StadInk.hex(0x8E8B83, 0.55 * (1 - phase))))
        }
        p.rect(33.2, 6.5, 1.6, 9.5, 0x3A3632)
        p.rect(18, 15.5, 22, 8.5, 0xC8261B, corner: 1.2)
        p.rect(39, 16.5, 2.6, 6.5, 0x3A3632)
        p.rect(4, 3.5, 15, 15, 0xC8261B, corner: 1)
        p.window(6, 5.6, 11, 8.4)
        p.head(11.4, 10.5, r: 2.2, skin: 0xE8C4A0, hair: 0x2F4B3A, shirt: 0x2F5BD3)
        p.rect(2.8, 2, 17.4, 2.4, 0x2C2C2A, corner: 0.8)
        p.dot(12, 25, 8.4, 0x1E1E1C)
        for i in 0..<8 {
            let a = turn + Double(i) * .pi / 4
            p.dot(12 + cos(a) * 7.6, 25 + sin(a) * 7.6, 0.9, 0x3A3632)
        }
        p.dot(12, 25, 3.6, 0xF2C53D)
        p.dot(36, 28.6, 4.8, 0x1E1E1C)
        p.dot(36, 28.6, 2, 0xF2C53D)
    }

    /// A striped hot-air balloon drifting over the meadow, two people waving from the basket.
    static func luchtballon(_ p: KaartDetailPen, t: Double) {
        let lift = sin(t * 0.6) * 1.2
        var envelope = Path()
        envelope.move(to: CGPoint(x: 11, y: 28 + lift))
        envelope.addCurve(to: CGPoint(x: 16, y: 1 + lift), control1: CGPoint(x: 1, y: 22 + lift), control2: CGPoint(x: 1, y: 1 + lift))
        envelope.addCurve(to: CGPoint(x: 21, y: 28 + lift), control1: CGPoint(x: 31, y: 1 + lift), control2: CGPoint(x: 31, y: 22 + lift))
        envelope.closeSubpath()
        p.fill(envelope, 0xC8261B)
        var stripes = p.ctx
        stripes.clip(to: envelope)
        for (x, color) in [(6.5, 0xF2C53D as UInt32), (14, 0xFFFDF6), (21.5, 0x2F5BD3)] {
            var band = Path()
            band.move(to: CGPoint(x: 16, y: lift))
            band.addQuadCurve(to: CGPoint(x: 16, y: 30 + lift), control: CGPoint(x: x + (x - 16) * 0.4, y: 14 + lift))
            band.addQuadCurve(to: CGPoint(x: 16, y: lift), control: CGPoint(x: x + 4 + (x + 4 - 16) * 0.4, y: 14 + lift))
            stripes.fill(band, with: .color(p.color(color)))
        }
        p.line([(11.5, 28 + lift), (13.4, 36 + lift)], 0x6B4A2E, width: 0.5)
        p.line([(20.5, 28 + lift), (18.6, 36 + lift)], 0x6B4A2E, width: 0.5)
        p.head(14.6, 34.6 + lift, r: 1.4, skin: 0xE8C4A0, hair: 0x8C4A2A)
        p.head(17.6, 34.8 + lift, r: 1.4, skin: 0xC99A74, hair: 0x1E1E1C)
        p.line([(18.6, 34 + lift), (20.4 + sin(t * 5) * 0.6, 31.4 + lift)], 0xC99A74, width: 0.7)
        p.rect(13, 36 + lift, 6, 4.4, 0x9A6A3C, corner: 0.8)
        p.line([(13.4, 37.6 + lift), (18.6, 37.6 + lift)], 0x6B4A2E, width: 0.5)
    }

    /// A snowman with a carrot nose, a red scarf and a black hat.
    static func sneeuwman(_ p: KaartDetailPen, t: Double) {
        p.oval(1, 26, 20, 4, 0xEEF2F4)
        p.line([(6.5, 13), (1.6, 9.4), (0.6, 8)], 0x6B4A2E, width: 0.8)
        p.line([(15.5, 13), (20.4, 9.8), (21.2, 8.2)], 0x6B4A2E, width: 0.8)
        for (cy, r) in [(22.0, 6.4), (13.6, 4.6), (6.6, 3.4)] {
            p.dot(11.6, cy + 0.4, r, 0xD6E2EA)
            p.dot(10.9, cy, r * 0.94, 0xFFFFFF)
        }
        p.rect(7.5, 9.2, 7.2, 1.9, 0xC8261B, corner: 0.8)
        let flap = sin(t * 3) * 0.6
        p.poly([(12.6, 10.4), (15.8 + flap, 14), (13.8 + flap * 0.5, 14.4)], 0xC8261B)
        p.rect(8, 0.4, 6, 3.6, 0x2C2C2A)
        p.rect(6.8, 3.6, 8.4, 1.1, 0x2C2C2A)
        p.dot(9.6, 5.8, 0.55, 0x1E1E1C)
        p.dot(12.2, 5.8, 0.55, 0x1E1E1C)
        p.poly([(12, 6.7), (17.4, 7.6), (12, 8.2)], 0xF2711C)
        p.dot(11, 13.4, 0.55, 0x1E1E1C)
        p.dot(11, 15.8, 0.55, 0x1E1E1C)
    }

    /// Two striped beach loungers on the sand, one with a sunbather, one with a towel.
    static func ligstoel(_ p: KaartDetailPen) {
        p.shadow(21, 21, 42)
        let wood: UInt32 = 0x8A6240
        for (x, color) in [(1.0, 0x2F5BD3 as UInt32), (22, 0xC8261B)] {
            p.line([(x + 2.5, 20.5), (x + 3, 16)], wood, width: 1)
            p.line([(x + 14.5, 20.5), (x + 14, 16)], wood, width: 1)
            p.line([(x + 17.5, 9.5), (x + 13, 16.4)], wood, width: 0.8)
            p.line([(x + 1, 16), (x + 13, 16), (x + 18.5, 7.5)], color, width: 3)
            p.line([(x + 1.6, 16), (x + 13, 16), (x + 18, 8.3)], 0xFFFDF6, width: 0.9)
        }
        // The sunbather, sunglasses on.
        p.line([(2.4, 13.6), (10.6, 13.6)], 0xE8C4A0, width: 1.9)
        p.line([(10.4, 13.6), (14.6, 10.2)], 0xF2C53D, width: 2.8)
        p.head(16.4, 8, r: 2, skin: 0xE8C4A0, hair: 0x8C4A2A)
        p.line([(16.2, 8.1), (18, 8.1)], 0x1E1E1C, width: 0.8)
        // A folded towel on the other one.
        p.rect(25, 13.4, 7, 2.2, 0xF2711C, corner: 0.6)
        p.line([(26.5, 13.4), (26.5, 15.6)], 0xFFFDF6, width: 0.6)
    }

    /// A sandcastle with a little flag, a red bucket and a yellow spade.
    static func zandkasteel(_ p: KaartDetailPen, t: Double) {
        let sand: UInt32 = 0xD9C08A, dark: UInt32 = 0xC4A56E
        p.oval(1, 17, 28, 5, 0xC9AE78)
        for (x, y, w) in [(5.0, 11.0, 6.0), (19, 11, 6), (11, 7, 8)] {
            p.rect(x, y, w, 19 - y, sand)
            p.rect(x + w - 1.4, y, 1.4, 19 - y, dark)
            var at = x
            while at < x + w - 0.5 {
                p.rect(at, y - 1.5, 1.6, 1.6, sand)
                at += 2.7
            }
        }
        p.rect(13.8, 14.2, 2.4, 4.8, 0xA88A58, corner: 1.2)
        p.line([(15, 5.5), (15, 0.6)], 0x5F5E5A, width: 0.5)
        p.poly([(15.2, 0.6), (19 + sin(t * 4) * 0.5, 1.7), (15.2, 2.8)], 0xC8261B)
        p.poly([(24.4, 15), (29, 15), (28.2, 20), (25.2, 20)], 0xC8261B)
        p.line([(24.6, 15), (26.7, 12.6), (28.8, 15)], 0x8E1A12, width: 0.5)
        p.line([(3, 19), (2.2, 12)], 0x8A6240, width: 0.8)
        p.poly([(1.2, 12.5), (3.4, 12.2), (2.8, 9), (1.4, 9.2)], 0xF2C53D)
    }

    /// A child flying a kite with a tail of bows.
    static func vlieger(_ p: KaartDetailPen, t: Double) {
        let c = (24 + sin(t * 1.1) * 1.6, 11 + cos(t * 0.9) * 1.2)
        let tilt = sin(t * 1.3) * 0.18
        func rot(_ dx: Double, _ dy: Double) -> (Double, Double) {
            (c.0 + dx * cos(tilt) - dy * sin(tilt), c.1 + dx * sin(tilt) + dy * cos(tilt))
        }
        let bottom = rot(0, 9)
        p.shadow(8, 55, 10)
        p.curve((8.4, 46.5), control: (21, 32), to: bottom, 0xF4F1EA, width: 0.4)
        // Tail: a wavy string with three bows.
        var tail: [(Double, Double)] = [bottom]
        for k in 1...6 {
            let f = Double(k) / 6
            tail.append((bottom.0 - f * 9 + sin(t * 3 + f * 5) * 1.6, bottom.1 + f * 13))
        }
        p.line(tail, 0x5F5E5A, width: 0.4)
        for k in [2, 4, 6] {
            let q = tail[k]
            p.poly([(q.0 - 1.4, q.1 - 0.9), (q.0 + 1.4, q.1 + 0.9), (q.0 + 1.4, q.1 - 0.9), (q.0 - 1.4, q.1 + 0.9)], k == 4 ? 0x2F5BD3 : 0xC8261B)
        }
        let top = rot(0, -8), right = rot(6, -1), left = rot(-6, -1)
        p.poly([top, right, c], 0xC8261B)
        p.poly([top, left, c], 0xF2C53D)
        p.poly([bottom, right, c], 0xF2C53D)
        p.poly([bottom, left, c], 0xC8261B)
        p.line([top, bottom], 0x6B4A2E, width: 0.4)
        p.line([left, right], 0x6B4A2E, width: 0.4)
        // The child holding the string.
        p.line([(6.6, 50), (6, 55)], 0x2C2C2A, width: 1.2)
        p.line([(8.4, 50), (9.2, 55)], 0x2C2C2A, width: 1.2)
        p.rect(4.8, 43.6, 5, 7.4, 0x2F5BD3, corner: 1.8)
        p.line([(9, 45), (8.4, 46.6)], 0xE8C4A0, width: 1)
        p.head(7.2, 41.4, r: 2.2, skin: 0xE8C4A0, hair: 0xC9A15B)
    }

    /// Red toadstools with white spots among the fallen leaves.
    static func paddenstoel(_ p: KaartDetailPen) {
        p.oval(1, 13, 4, 2.2, 0xD9822B)
        p.oval(15.5, 13.6, 4, 2, 0xC7772E)
        for (cx, base, w, h) in [(9.6, 8.6, 12.5, 6.0), (16, 11.2, 6.4, 3.4), (4, 12.4, 4.6, 2.6)] {
            p.rect(cx - w * 0.13, base - 0.4, w * 0.26, 15 - base, 0xF4EEE2, corner: 0.6)
            var cap = Path()
            cap.move(to: CGPoint(x: cx - w / 2, y: base))
            cap.addQuadCurve(to: CGPoint(x: cx + w / 2, y: base), control: CGPoint(x: cx, y: base - h * 2))
            cap.closeSubpath()
            p.fill(cap, 0xD8342C)
            for (dx, dy) in [(-0.25, -0.3), (0.12, -0.55), (0.3, -0.22)] {
                p.dot(cx + dx * w, base + dy * h, w * 0.06, 0xFFFDF6)
            }
        }
    }
}
