import SwiftUI

/// Things beside the road: a traffic light, a road sign on a pole, a direction sign for the exits
/// of a roundabout, someone walking on the footpath, people at the kerb about to cross, a zebra
/// crossing with its sign, and a board comparing a muddled junction with a clear one.
enum G8Street {
    typealias Look = PalaceFigures.Look

    // MARK: Traffic light

    /// A traffic light on a pole (36 × 104); `highlight` the lit lamp (0 red, 1 amber, 2 green).
    static func trafficLight(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 36, height: 104))
        let lit = p.highlight ?? 0
        G8Props.shadow(f, 8, 99, 20, 4)
        f.rect(16, 50, 4, 52, 0x3E4C55)
        f.rect(4, 0, 28, 56, 0xFFFDF6, radius: 4)
        f.rect(7, 3, 22, 50, 0x1E1E1C, radius: 3)
        let lamps: [(UInt32, UInt32)] = [(0xE5372A, 0x4A2220), (0xF2B33D, 0x4A3B1E), (0x2FBF71, 0x1E3A2A)]
        for (i, lamp) in lamps.enumerated() {
            let y = 12 + CGFloat(i) * 16
            if i == lit { f.dot(18, y, 11, lamp.0, 0.28) }
            f.dot(18, y, 6.4, i == lit ? lamp.0 : lamp.1)
            if i == lit { f.dot(16, y - 2, 2, 0xFFFFFF, 0.5) }
            f.svg("M10 \(y - 6)Q18 \(y - 10) 26 \(y - 6)V\(y - 4.6)Q18 \(y - 8) 10 \(y - 4.6)Z", 0x3E4C55)
        }
    }

    // MARK: Road sign on a pole

    /// A road sign on a pole (40 × 90): `accessory` "noEntry" | "giveWay" | "zebra" | "roundabout".
    static func trafficSign(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 40, height: 90))
        G8Props.shadow(f, 10, 86, 20, 4)
        f.rect(18, 20, 4, 68, 0x5E6B73)
        f.rect(18, 20, 1.4, 68, 0x7D8A92)
        G8Traffic.sign(f.within(CGRect(x: 2, y: 2, width: 36, height: 36)), p.accessory ?? "noEntry")
    }

    // MARK: Exit sign

    /// A blue direction sign on two posts (96 × 104): the roundabout drawn as a ring, its arms
    /// labelled with `labels` (left, ahead, right); the exit `highlight` (default 1) is drawn bold
    /// with an arrow from the entry at the bottom.
    static func exitSign(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 104))
        let labels = p.labels ?? ["Centrum", "Haven", "Dijk"]
        let pick = p.highlight ?? 1
        G8Props.shadow(f, 14, 99, 68, 4)
        f.rect(22, 70, 4, 32, 0x5E6B73)
        f.rect(70, 70, 4, 32, 0x5E6B73)
        f.rect(0, 0, 96, 76, 0xFFFDF6, radius: 4)
        f.rect(2, 2, 92, 72, 0x2F5BD3, radius: 3)
        let c = CGPoint(x: 48, y: 46)
        let arms: [(CGPoint, CGPoint)] = [(CGPoint(x: 37, y: 46), CGPoint(x: 18, y: 46)),
                                          (CGPoint(x: 48, y: 35), CGPoint(x: 48, y: 18)),
                                          (CGPoint(x: 59, y: 46), CGPoint(x: 78, y: 46))]
        f.line(48, 70, 48, 57, 0xFFFDF6, 4, round: false)
        for (i, arm) in arms.enumerated() where i != pick { f.line(arm.0.x, arm.0.y, arm.1.x, arm.1.y, 0xFFFDF6, 2.4, round: false) }
        f.ring(c.x, c.y, 9, 0xFFFDF6, 3)
        let chosen = arms[min(max(pick, 0), 2)]
        var route = Path()
        route.move(to: CGPoint(x: 52, y: 66))
        route.addLine(to: CGPoint(x: 52, y: 56))
        route.addArc(center: c, radius: 9, startAngle: .degrees(70), endAngle: .degrees(pick == 0 ? 180 : pick == 1 ? 270 : 360), clockwise: true)
        f.stroke(route, 0xFAC775, 3)
        G8Props.arrow(f, chosen.0, chosen.1, 0xFAC775, 4, head: 9)
        let spots = [CGPoint(x: 21, y: 62), CGPoint(x: 48, y: 11), CGPoint(x: 75, y: 62)]
        for (i, label) in labels.prefix(3).enumerated() {
            f.text(label, PropFont.heavy(i == pick ? 10 : 8.5), i == pick ? 0xFAC775 : 0xFFFDF6, at: spots[i], maxWidth: i == 1 ? 60 : 32)
        }
    }

    // MARK: Pedestrian

    /// Someone walking on the footpath (92 × 116) with a shopping bag, under the round blue
    /// footpath sign.
    static func pedestrian(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 92, height: 116))
        let v = Look.at(p.variant ?? 2)
        G8Props.shadow(f, 30, 109, 56)
        f.rect(12, 26, 3.4, 88, 0x5E6B73)
        f.dot(13.7, 15, 14, 0xFFFDF6)
        f.dot(13.7, 15, 12.6, 0x2F5BD3)
        PalaceIcon.walk.draw(f, in: CGRect(x: 3.7, y: 5, width: 20, height: 20), color: 0xFFFDF6, detail: 0x2F5BD3)
        let w = f.within(CGRect(x: 34, y: 2, width: 58, height: 114))
        PalaceParkPeople.walker(w, x: 0, v, hair: v.hair, hat: false)
        w.svgLine("M35 42C39 52 40 60 41 66", v.coat, 6)
        w.dot(41, 68, 3.1, v.skin)
        w.svgLine("M38 68Q41 62 44 68", 0xC8261B, 1.4)
        w.rect(36, 68, 12, 14, 0xC8261B, radius: 1.5)
        w.svgLine("M38 70H46", 0xFFFDF6, 1)
    }

    // MARK: About to cross

    /// A parent and child at the kerb (56 × 86), hand in hand, heads turned to look left and
    /// right, a dashed arrow showing the way across.
    static func kerbCross(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 56, height: 86))
        let parent = Look.at(p.variant ?? 7), child = Look.at((p.variant ?? 7) + 3)
        G8Props.shadow(f, 0, 81, 46, 5)
        let s: CGFloat = 0.74
        PalaceFigures.person(f.within(CGRect(x: 0, y: 84 - 114 * s, width: 64 * s, height: 114 * s), unit: s),
                             PalacePropParams(variant: (p.variant ?? 7), accessory: "none"))
        let k: CGFloat = 0.85
        PalaceFigures.mini(f.within(CGRect(x: 30, y: 84 - 60 * k, width: 30 * k, height: 60 * k), unit: k), child, walking: false, briefcase: false)
        f.svgLine("M24 54Q30 58 35 52", parent.skin, 2.2)
        f.svgLine("M6 5L1 9.5L6 14M45 27L50 31.5L45 36", 0x1E1E1C, 1.8)
        f.svgLine("M14 80H21M26 80H33M38 80H45", 0xF2711C, 2.6)
        G8Props.head(f, tip: CGPoint(x: 56, y: 80), dx: 1, dy: 0, 8, 0xF2711C)
    }

    // MARK: Zebra crossing

    /// A zebra crossing seen across a road coming toward the viewer (144 × 130, drawn from the
    /// top): white bars between y 40 and 76, the blue crossing sign on a pole at the right kerb,
    /// and the road below left clear. `count` bars (7).
    static func zebra(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 144, height: 130), hanging: true)
        let n = max(3, min(p.count ?? 7, 10))
        let top: (CGFloat, CGFloat) = (7.7, 94.3), bottom: (CGFloat, CGFloat) = (2.4, 99.6)
        func x(_ t: CGFloat, _ e: (CGFloat, CGFloat)) -> CGFloat { e.0 + (e.1 - e.0) * t }
        var bars = ""
        for k in 0..<n {
            let t0 = CGFloat(k) / CGFloat(n) + 0.02, t1 = t0 + 0.6 / CGFloat(n)
            bars += "M\(x(t0, top)) 40H\(x(t1, top))L\(x(t1, bottom)) 76H\(x(t0, bottom))Z"
        }
        f.svg(bars, 0xFFFDF6)
        G8Props.shadow(f, 110, 81, 16, 4)
        f.rect(116, 28, 3.4, 56, 0x5E6B73)
        G8Traffic.sign(f.within(CGRect(x: 102, y: 0, width: 32, height: 32)), "zebra")
    }

    // MARK: Clear or muddled

    /// A blue board high on two posts (100 × 136) with two panels: a muddled junction full of
    /// crossing roads and signs under a red cross, and a tidy roundabout with an eye under a tick.
    static func overview(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 136))
        G8Props.shadow(f, 10, 131, 80, 5)
        f.rect(18, 56, 4, 78, 0x5E6B73)
        f.rect(78, 56, 4, 78, 0x5E6B73)
        f.rect(0, 0, 100, 62, 0x1F3A6B, radius: 3)
        let left = CGRect(x: 4, y: 4, width: 44, height: 54), right = CGRect(x: 52, y: 4, width: 44, height: 54)
        f.rect(left, 0xEFEBE2, radius: 1.5)
        f.rect(right, 0xEFEBE2, radius: 1.5)
        var l = f
        l.ctx.clip(to: Path(left))
        l.svgLine("M2 18L50 44M10 2L32 60M2 48L48 10M40 2L18 60M2 32L50 30", 0x9A968C, 4)
        l.svgLine("M2 18L50 44M10 2L32 60M2 48L48 10M40 2L18 60M2 32L50 30", 0xFFFDF6, 0.6)
        for (cx, cy, hex) in [(14.0, 14.0, 0xC8261B), (36, 20, 0x2F5BD3), (22, 42, 0xFAC775), (40, 46, 0xC8261B), (10, 34, 0x2F5BD3)] as [(CGFloat, CGFloat, UInt32)] {
            l.dot(cx, cy, 3, hex)
        }
        l.text("?", PropFont.heavy(16), 0xC8261B, at: CGPoint(x: 26, y: 30))
        let c = CGPoint(x: right.midX, y: right.midY + 6)
        f.svgLine("M\(c.x) \(right.minY + 14)V\(right.maxY)M\(right.minX) \(c.y)H\(right.maxX)", 0x9A968C, 5)
        f.dot(c.x, c.y, 11, 0x9A968C)
        f.dot(c.x, c.y, 5.5, 0x95B36B)
        f.svgLine("M\(c.x - 11) \(right.minY + 11)Q\(c.x) \(right.minY + 3) \(c.x + 11) \(right.minY + 11)Q\(c.x) \(right.minY + 19) \(c.x - 11) \(right.minY + 11)Z", 0x1F3A6B, 1.4)
        f.dot(c.x, right.minY + 11, 2.6, 0x1F3A6B)
        G8Props.badge(f, left.maxX - 2, left.minY + 3, 6, ok: false)
        G8Props.badge(f, right.maxX - 2, right.minY + 3, 6, ok: true)
    }
}
