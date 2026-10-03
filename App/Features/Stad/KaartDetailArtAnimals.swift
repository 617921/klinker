import SwiftUI

/// Birds and animals hidden in the city and the countryside. Each draws in its own design box
/// (see `KaartDetailArt.draw`), facing right.
nonisolated extension KaartDetailArt {
    /// A short pulse (0...1...0) once every `period` seconds, lasting `share` of it.
    static func pulse(_ t: Double, period: Double, share: Double, offset: Double = 0) -> Double {
        let phase = ((t + offset) / period).truncatingRemainder(dividingBy: 1)
        let c = phase < 0 ? phase + 1 : phase
        return c < share ? sin(c / share * .pi) : 0
    }

    // MARK: Water birds

    /// A mother duck paddling with three yellow ducklings behind her.
    static func eend(_ p: KaartDetailPen, t: Double) {
        let brown: UInt32 = 0x8A6A4A
        let bob = sin(t * 3) * 0.35
        p.wake(26, 44, 12.4)
        p.poly([(29, 8.5 + bob), (25.5, 5.8 + bob), (30.5, 6.5 + bob)], 0x6E5238)
        p.oval(28, 5 + bob, 14, 7, brown)
        p.oval(30, 6.3 + bob, 8, 3.6, 0x6E5238)
        p.rect(33.5, 8 + bob, 3.2, 1.2, 0x2F5BD3)
        p.dot(40.6, 4 + bob, 2.7, brown)
        p.poly([(42.6, 3.6 + bob), (46, 4.6 + bob), (42.6, 5.8 + bob)], 0xE08A2C)
        p.dot(41.2, 3.3 + bob, 0.55, 0x1E1E1C)
        for (i, x) in [19.0, 11, 3].enumerated() {
            let b = sin(t * 3.4 + Double(i) * 1.3) * 0.45
            p.wake(x - 1, x + 7, 12.6)
            p.oval(x, 8.4 + b, 6, 4.2, 0xF2C53D)
            p.dot(x + 5.4, 7.6 + b, 1.9, 0xF2C53D)
            p.poly([(x + 6.9, 7.3 + b), (x + 8.6, 7.9 + b), (x + 6.9, 8.5 + b)], 0xE0802C)
            p.dot(x + 5.8, 7.1 + b, 0.4, 0x1E1E1C)
        }
    }

    /// A white swan with a grey cygnet, gliding.
    static func zwaan(_ p: KaartDetailPen, t: Double) {
        p.wake(16, 43, 21.5)
        swan(p, x: 17, scale: 1, body: 0xFFFDF6, shade: 0xD9D4CA, neck: 0xFFFDF6, t: t)
        p.wake(1, 15, 22)
        swan(p, x: 2, scale: 0.52, body: 0xA89F94, shade: 0x8C8378, neck: 0xA89F94, t: t + 1.7)
    }

    private static func swan(_ p: KaartDetailPen, x: Double, scale s: Double, body: UInt32, shade: UInt32, neck: UInt32, t: Double) {
        let base = 21.5
        let bob = sin(t * 1.4) * 0.3
        func q(_ dx: Double, _ dy: Double) -> (Double, Double) { (x + dx * s, base - dy * s + bob) }
        // Tail, body, and the wing raised in a curve, outlined so white reads on pale water.
        p.poly([q(1.5, 4), q(-1.5, 9.5), q(6, 7.5)], shade)
        let hull = Path(ellipseIn: CGRect(x: q(0, 9).0, y: q(0, 9).1, width: 22 * s, height: 9 * s))
        p.fill(hull, body)
        p.ctx.stroke(hull, with: .color(p.color(shade)), lineWidth: 0.5 * s)
        var wing = Path()
        wing.move(to: CGPoint(x: q(2, 6.5).0, y: q(2, 6.5).1))
        wing.addQuadCurve(to: CGPoint(x: q(16.5, 6).0, y: q(16.5, 6).1), control: CGPoint(x: q(5, 16).0, y: q(5, 16).1))
        wing.addQuadCurve(to: CGPoint(x: q(2, 6.5).0, y: q(2, 6.5).1), control: CGPoint(x: q(10, 3.5).0, y: q(10, 3.5).1))
        p.fill(wing, body)
        p.ctx.stroke(wing, with: .color(p.color(shade)), lineWidth: 0.6 * s)
        // The S of the neck, the head and the orange bill.
        p.curve(q(19, 6), control: q(25.5, 13), to: q(19.6, 18.5), neck, width: 2.6 * s)
        p.dot(q(20.6, 18.7).0, q(20.6, 18.7).1, 2.1 * s, neck)
        p.poly([q(22, 19.6), q(26, 17.8), q(22.2, 17.4)], body == 0xFFFDF6 ? 0xE8742C : 0x5F5E5A)
        p.dot(q(21.9, 18.9).0, q(21.9, 18.9).1, 0.7 * s, 0x1E1E1C)
    }

    /// A grey heron at the water's edge; now and then it dips its head to fish.
    static func reiger(_ p: KaartDetailPen, t: Double) {
        let d = pulse(t, period: 7, share: 0.28)
        p.shadow(10.5, 33, 12)
        p.line([(9, 21), (8.2, 33)], 0xB8A67A, width: 0.9)
        p.line([(11.2, 21), (12, 33)], 0xB8A67A, width: 0.9)
        // Body, wing and the dark flank stripe.
        p.poly([(2, 20.5), (8, 13), (15, 13), (15.5, 18.5), (10, 22.5)], 0x9AA2A8)
        p.poly([(3, 19.5), (8.5, 14), (14, 14.5), (11, 18.5)], 0x707A84)
        p.line([(6, 20.6), (13.5, 19)], 0x2C2C2A, width: 0.7)
        // Neck and head: up and alert, or down to the water.
        let head = (14.6 + d * 4.6, 4.6 + d * 16)
        p.curve((13.6, 14), control: (11 + d * 6, 6 + d * 9), to: head, 0xE4E7E8, width: 2.2)
        p.dot(head.0, head.1, 1.8, 0xE4E7E8)
        p.line([(head.0 - 0.6, head.1 - 0.8), (head.0 - 4.6, head.1 - 0.2 + d)], 0x2C2C2A, width: 0.6)
        p.line([(head.0 + 1, head.1 + 0.1), (head.0 + 6.4 - d * 2.6, head.1 + 0.8 + d * 4.6)], 0xE0A830, width: 0.9)
        p.dot(head.0 + 0.3, head.1 - 0.4, 0.35, 0x1E1E1C)
    }

    /// A coot on its nest of sticks at the canal edge, with two red-headed chicks.
    static func meerkoet(_ p: KaartDetailPen, t: Double) {
        let bob = sin(t * 1.6) * 0.35
        p.wake(0, 28, 15.5)
        p.line([(3.5, 11), (2.6, 1.5)], 0x7A9A4A, width: 0.8)
        p.line([(5, 11), (5.6, 3)], 0x6A8A40, width: 0.8)
        p.oval(1.5, 10, 25, 7, 0x7A5A3A)
        p.line([(3, 12), (12, 11), (20, 13), (26, 12)], 0xA08058, width: 0.6)
        p.line([(4, 14.5), (11, 15.5), (19, 14), (25, 15)], 0x5B4128, width: 0.6)
        // Chicks: black fluff with red heads.
        p.dot(6, 10.4, 1.7, 0x2A2A2E)
        p.dot(6.8, 9, 1, 0xE8582F)
        p.dot(23.4, 10.8, 1.5, 0x2A2A2E)
        p.dot(24.2, 9.6, 0.9, 0xE8582F)
        // The coot: black, with a white bill and shield.
        p.oval(8.5, 4.6, 12.5, 8, 0x26262A)
        p.dot(19.8, 5.4 + bob, 3, 0x26262A)
        p.poly([(21, 3.2 + bob), (25.8, 5.5 + bob), (21.4, 7.1 + bob)], 0xF4F1EA)
        p.glow.dot(19.9, 4.7 + bob, 0.55, 0xC8261B)
    }

    // MARK: Birds on land

    /// Two greylag geese walking in the grass: one grazes while the other looks around.
    static func gans(_ p: KaartDetailPen, t: Double) {
        p.shadow(21, 23, 38)
        goose(p, x: 11, down: pulse(t, period: 4, share: 0.6), step: sin(t * 5), scale: 0.86)
        goose(p, x: 30, down: pulse(t, period: 5, share: 0.35, offset: 2), step: sin(t * 5 + 1.6), scale: 1)
    }

    private static func goose(_ p: KaartDetailPen, x: Double, down: Double, step: Double, scale s: Double) {
        let y = 23.0
        func q(_ dx: Double, _ dy: Double) -> (Double, Double) { (x + dx * s, y - dy * s) }
        p.line([q(-1, 6), q(-1.5 + step, 0)], 0xF2711C, width: 0.9)
        p.line([q(1.5, 6), q(1.5 - step, 0)], 0xF2711C, width: 0.9)
        p.poly([q(-7.5, 9), q(-10, 12), q(-5, 11.5)], 0xF4F1EA)
        p.fill(Path(ellipseIn: CGRect(x: q(-8, 13).0, y: q(-8, 13).1, width: 15 * s, height: 8 * s)), 0x9A9183)
        p.fill(Path(ellipseIn: CGRect(x: q(-7, 12.5).0, y: q(-7, 12.5).1, width: 10 * s, height: 5 * s)), 0x746C60)
        let head = q(7 + down * 4, 19 - down * 16)
        p.curve(q(5, 10), control: q(7.5 + down * 3, 15 - down * 6), to: head, 0x857D70, width: 2.5 * s)
        p.dot(head.0, head.1, 2 * s, 0x6E675C)
        p.poly([(head.0 + 1.4 * s, head.1 - 0.6 * s), (head.0 + 4.4 * s, head.1 + (0.2 + down * 1.2) * s), (head.0 + 1.4 * s, head.1 + 0.9 * s)], 0xF2711C)
        p.dot(head.0 + 0.4 * s, head.1 - 0.5 * s, 0.4 * s, 0x1E1E1C)
    }

    /// Three pigeons on the square, pecking at crumbs.
    static func duif(_ p: KaartDetailPen, t: Double) {
        p.shadow(20, 15, 36)
        pigeon(p, x: 8, dir: 1, peck: pulse(t, period: 1.7, share: 0.3))
        pigeon(p, x: 31, dir: -1, peck: pulse(t, period: 2.3, share: 0.3, offset: 0.8))
        pigeon(p, x: 21, dir: 1, peck: pulse(t, period: 1.9, share: 0.3, offset: 1.4))
        for (x, y) in [(15.5, 14.6), (26, 15), (36, 14.4)] { p.dot(x, y, 0.45, 0xD9C08A) }
    }

    private static func pigeon(_ p: KaartDetailPen, x: Double, dir: Double, peck: Double) {
        func q(_ dx: Double, _ dy: Double) -> (Double, Double) { (x + dx * dir, dy) }
        p.line([q(-1, 12), q(-1, 14.6)], 0xD87A7A, width: 0.7)
        p.line([q(1.4, 12), q(1.4, 14.6)], 0xD87A7A, width: 0.7)
        p.poly([q(-5, 9), q(-8.5, 10.5), q(-5, 11.5)], 0x5E6878)
        p.oval(x - 5.5, 7.2, 11, 6.2, 0x808A9C)
        p.oval(dir > 0 ? x - 5 : x - 3, 8, 8, 3.8, 0x687286)
        p.line([q(-2.5, 9.2), q(0.5, 9.8)], 0x3A3F4A, width: 0.6)
        p.line([q(-2.5, 10.6), q(0.5, 11.2)], 0x3A3F4A, width: 0.6)
        let head = q(5 + peck * 2.4, 5.2 + peck * 7)
        p.dot(q(3.6, 8).0, 8, 2.2, 0x6A8A82)
        p.dot(head.0, head.1, 2, 0x6E788A)
        p.poly([q(6.6 + peck * 2.4, 5.2 + peck * 7), q(8.4 + peck * 2.4, 5.8 + peck * 7.4), q(6.6 + peck * 2.4, 6.2 + peck * 7)], 0xE8C4A0)
        p.glow.dot(head.0 + 0.5 * dir, head.1 - 0.5, 0.42, 0xE8742C)
    }

    /// A white stork on its nest on a pole in the polder.
    static func ooievaar(_ p: KaartDetailPen, t: Double) {
        let nod = sin(t * 0.9) * 0.8
        p.shadow(14, 53, 12)
        p.line([(14, 53), (14, 21)], 0x6B4A2E, width: 2)
        p.oval(3, 19, 22, 5, 0x5B4128)
        p.oval(2, 14.5, 24, 8, 0x8A6A42)
        p.line([(3, 17), (10, 15.6), (18, 17.4), (25, 16)], 0xB08A5A, width: 0.7)
        p.line([(4, 20.5), (12, 19.2), (20, 21), (24, 19.6)], 0x5B4128, width: 0.7)
        // Stork: white body, black wing feathers, red bill.
        p.oval(6.5, 6.5, 14, 9.5, 0xF7F4EC)
        p.poly([(6.5, 11), (16.5, 14), (9, 16), (4.5, 13)], 0x1E1E1C)
        let head = (19.6 + nod, 2.6)
        p.line([(17.5, 9), head], 0xF7F4EC, width: 2.6)
        p.dot(head.0, head.1, 2, 0xF7F4EC)
        p.poly([(head.0 + 1.2, head.1 - 0.6), (head.0 + 7.4, head.1 + 3.4), (head.0 + 1, head.1 + 1)], 0xE0442C)
        p.dot(head.0 + 0.4, head.1 - 0.5, 0.45, 0x1E1E1C)
    }

    /// A brown hen pecking, with three chicks hopping after her.
    static func kip(_ p: KaartDetailPen, t: Double) {
        let peck = pulse(t, period: 2.2, share: 0.35)
        p.shadow(17, 19.5, 30)
        p.line([(10, 15.5), (10, 19.5)], 0xE0A830, width: 0.9)
        p.line([(13, 15.5), (13, 19.5)], 0xE0A830, width: 0.9)
        p.poly([(5, 11), (1.5, 2.5), (6.5, 4.5), (9, 8)], 0x7A3A1E)
        p.oval(4, 7, 15, 10, 0xA0522D)
        p.oval(6.5, 9.5, 9, 5, 0x8A4424)
        let head = (18 + peck * 3, 5.5 + peck * 9)
        p.dot(head.0 - 0.6, head.1 - 2.5, 1, 0xD8342C)
        p.dot(head.0 + 0.8, head.1 - 2.6, 1, 0xD8342C)
        p.dot(head.0, head.1, 2.6, 0xA0522D)
        p.dot(head.0 + 1.6, head.1 + 2.2, 0.9, 0xD8342C)
        p.poly([(head.0 + 2.2, head.1 - 0.6), (head.0 + 4.4, head.1 + 0.3), (head.0 + 2.2, head.1 + 1)], 0xE0A830)
        p.dot(head.0 + 0.8, head.1 - 0.6, 0.45, 0x1E1E1C)
        for (i, x) in [23.5, 27.5, 31.5].enumerated() {
            let hop = max(0, sin(t * 5 + Double(i) * 2)) * 1.3
            p.dot(x, 17 - hop, 2, 0xF2D24A)
            p.dot(x + 1.5, 15 - hop, 1.35, 0xF2D24A)
            p.poly([(x + 2.6, 14.6 - hop), (x + 3.7, 15.1 - hop), (x + 2.6, 15.6 - hop)], 0xE0802C)
            p.dot(x + 1.8, 14.6 - hop, 0.3, 0x1E1E1C)
        }
    }

    // MARK: Animals

    /// A brown rabbit sitting up in the grass, ears twitching.
    static func konijn(_ p: KaartDetailPen, t: Double) {
        let twitch = pulse(t, period: 3.1, share: 0.25) * 1.2
        let fur: UInt32 = 0x9C7A5A
        p.shadow(9, 17.4, 16)
        p.line([(12.4, 7), (10.4 - twitch, 0.8)], fur, width: 2.4)
        p.line([(12.4, 7), (10.6 - twitch, 1.6)], 0xE8A9A0, width: 0.8)
        p.line([(14.4, 7), (15.2 + twitch * 0.4, 0.6)], fur, width: 2.4)
        p.oval(2, 8, 12.5, 9, fur)
        p.oval(2.5, 10, 7.5, 6.8, 0x8A6A4A)
        p.dot(2.6, 11.6, 1.9, 0xF4F1EA)
        p.oval(10.5, 5.8, 7.6, 6.6, fur)
        p.oval(12.6, 14.6, 3.4, 2.6, 0x8A6A4A)
        p.dot(15.6, 8.3, 0.7, 0x1E1E1C)
        p.dot(17.9, 9.6, 0.55, 0xE8A0A0)
    }

    /// Two spring lambs: one jumps for joy, one grazes.
    static func lam(_ p: KaartDetailPen, t: Double) {
        let hop = abs(sin(t * 3.2)) * 2.6
        p.shadow(17, 19.5, 30)
        lamb(p, x: 10, foot: 19.5 - hop, headDown: 0)
        lamb(p, x: 25, foot: 19.5, headDown: pulse(t, period: 3, share: 0.7))
    }

    private static func lamb(_ p: KaartDetailPen, x: Double, foot: Double, headDown: Double) {
        let legs: UInt32 = 0x3A3632
        for dx in [-4.0, -2, 2, 4] { p.line([(x + dx, foot - 5), (x + dx, foot)], legs, width: 0.9) }
        let wool: UInt32 = 0xF7F4EC
        for (dx, dy, r) in [(-3.6, 8.0, 3.2), (0, 9.4, 3.4), (3.4, 8.2, 3.2), (-0.5, 6.4, 3)] {
            p.dot(x + dx, foot - dy, r, wool)
        }
        let hy = foot - 11 + headDown * 6
        p.oval(x + 4.6, hy, 4.4, 4.2, 0x2C2C2A)
        p.line([(x + 5.2, hy + 1), (x + 3.6, hy - 0.2)], 0x2C2C2A, width: 1)
        p.dot(x + 7.4, hy + 1.4, 0.4, 0xF4F1EA)
    }

    /// A small dog sitting on the pavement, wagging its tail.
    static func hond(_ p: KaartDetailPen, t: Double) {
        let wag = sin(t * 10) * 1.6
        let tan: UInt32 = 0xB07A44
        p.shadow(10, 17.4, 16)
        p.curve((4.5, 14), control: (1, 13), to: (1.4 + wag * 0.3, 8.4 + wag), tan, width: 1.6)
        p.oval(4, 8, 9.5, 9.5, tan)
        p.oval(3.4, 12, 7.5, 5.6, 0x9A6838)
        p.oval(10, 9.5, 4.2, 6, 0xF0DCC0)
        p.rect(12, 13, 1.8, 4.4, tan, corner: 0.6)
        p.rect(14.2, 13, 1.8, 4.4, tan, corner: 0.6)
        p.dot(13.6, 6, 3.8, tan)
        p.oval(15.4, 6.2, 5.2, 3.4, 0xE8C8A0)
        p.dot(20.4, 7, 0.85, 0x1E1E1C)
        p.oval(10.4, 3.4, 3.4, 6.2, 0x7A4A24)
        p.dot(15, 4.9, 0.6, 0x1E1E1C)
        p.line([(11, 9.6), (15, 10.6)], 0xC8261B, width: 1.2)
    }

    /// A hedgehog snuffling through the autumn leaves, one leaf stuck on its spines.
    static func egel(_ p: KaartDetailPen, t: Double) {
        let sniff = sin(t * 6) * 0.3
        let step = sin(t * 5) * 0.8
        p.shadow(11, 13.4, 18)
        p.oval(5 + step, 11, 2.6, 2, 0x4A3524)
        p.oval(12 - step, 11, 2.6, 2, 0x4A3524)
        // Spines: a jagged dome.
        var spikes: [(Double, Double)] = []
        for i in 0...14 {
            let a = Double.pi + Double(i) / 14 * Double.pi * 0.92
            let r = i % 2 == 0 ? 1.0 : 0.78
            spikes.append((9.5 + cos(a) * 8.5 * r, 11.5 + sin(a) * 9 * r))
        }
        spikes.append((16, 11.8))
        p.poly(spikes, 0x5B4128)
        p.oval(3.5, 5.5, 12, 6.5, 0x7A5A3A)
        p.poly([(14, 6.8), (21.2, 10.4 + sniff), (15, 12.5)], 0xC8A27A)
        p.dot(21, 10.3 + sniff, 0.8, 0x1E1E1C)
        p.dot(16.8, 8.7, 0.55, 0x1E1E1C)
        p.poly([(5.5, 3.6), (10.5, 1.4), (9.6, 4.8)], 0xD9822B)
        p.line([(6, 3.6), (10, 2)], 0xA3410A, width: 0.4)
    }
}
