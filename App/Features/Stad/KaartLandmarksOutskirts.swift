import SwiftUI

/// Out of the centre: harbour, mill, farm, beach, camping, airport, allotments, square,
/// roundabout, dike, ferry and the lookout tower.
nonisolated extension KaartLandmarks {
    static func outskirts(_ n: Int) -> KaartLandmark? {
        switch n {
        case 44: molen()
        default: nil
        }
    }

    /// De molen: a tall green smock mill with a reed-thatched cap, a stage round its waist and white sails.
    private static func molen() -> KaartLandmark {
        var pen = KaartPen(wall: 0x3F5A4A, roof: 0x2C2C2A, door: 0x6B4A2E, accent: 0xEFE6D6)
        // Brick base, then the tapering wooden body.
        let base = pen.box(x: 0, w: 70, h: 40, depth: 28, paint: .color(0x8C4A3A))
        pen.poly([(8, -40), (62, -40), (52, -140), (18, -140)], .wall)
        pen.poly([(62, -40), (78, -52), (64, -146), (52, -140)], .side)
        pen.rect(-6, -46, 82, 6, .ink)
        var rails = Path()
        for x in stride(from: -4.0, through: 74, by: 6) { rails.addRect(CGRect(x: x, y: -54, width: 1.2, height: 8)) }
        rails.addRect(CGRect(x: -6, y: -55, width: 82, height: 1.6))
        pen.fill(rails, .ink)
        // Cap and sails (fixed; the decorative mill in the meadow is the one that turns).
        var cap = Path()
        cap.move(to: CGPoint(x: 14, y: -140))
        cap.addQuadCurve(to: CGPoint(x: 58, y: -140), control: CGPoint(x: 36, y: -172))
        cap.closeSubpath()
        pen.fill(cap, .roof)
        let hub = CGPoint(x: 36, y: -146)
        for angle in [20.0, 110, 200, 290] {
            let a = angle * .pi / 180
            let along = CGPoint(x: cos(a), y: sin(a)), across = CGPoint(x: -sin(a), y: cos(a))
            func p(_ l: Double, _ w: Double) -> (Double, Double) {
                (hub.x + along.x * l + across.x * w, hub.y + along.y * l + across.y * w)
            }
            pen.line(KaartPen.polygonLine([p(0, 0), p(78, 0)]), .ink, width: 2.4)
            pen.poly([p(14, 1.5), p(76, 1.5), p(76, 14), p(14, 14)], .accent)
            var lattice = Path()
            for l in stride(from: 20.0, through: 74, by: 9) { lattice.addPath(KaartPen.polygonLine([p(l, 1.5), p(l, 14)])) }
            pen.line(lattice, .ink, width: 0.8)
        }
        pen.oval(hub.x - 4, hub.y - 4, 8, 8, .ink)
        pen.windows(in: CGRect(x: 26, y: -120, width: 20, height: 50), cols: 1, rows: 2, w: 8, h: 11, seed: 44)
        pen.door(cx: 35, w: 14, h: 24, arched: true)
        pen.art.front = base
        pen.art.signAt = CGPoint(x: -14, y: -30)
        pen.art.sign = "wind"
        return pen.art
    }
}
