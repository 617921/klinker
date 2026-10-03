import SwiftUI

/// The hand-made map look: warm brown ink lines that wobble a little, like a drawn line, and
/// watercolour washes whose pigment pools darker at the edges.
nonisolated enum KaartInk {
    /// The ink: warm sepia by day, deep blue-black by night.
    static func line(night: Bool) -> Color {
        night ? StadInk.hex(0x080B14, 0.75) : StadInk.hex(0x3B2A1F, 0.82)
    }

    /// A path redrawn by hand: split into short steps and nudged by a smooth noise field, so long
    /// edges waver gently (and both sides of a stroked street waver together).
    static func wobble(_ path: Path, amount: Double = 1.1, step: Double = 6, seed: Double = 0) -> Path {
        var out = Path()
        var current = CGPoint.zero, start = CGPoint.zero
        func nudge(_ p: CGPoint) -> CGPoint {
            let x = Double(p.x), y = Double(p.y)
            let dx = sin(x * 0.083 + y * 0.051 + seed) * 0.6 + sin(x * 0.031 - y * 0.127 + seed * 1.7) * 0.4
            let dy = sin(x * 0.067 - y * 0.091 + seed * 2.3) * 0.6 + sin(x * 0.143 + y * 0.029 + seed * 0.7) * 0.4
            return CGPoint(x: x + dx * amount, y: y + dy * amount)
        }
        func sample(length: Double, _ point: (Double) -> CGPoint) {
            let n = max(1, Int(length / step))
            for i in 1...n { out.addLine(to: nudge(point(Double(i) / Double(n)))) }
        }
        func dist(_ a: CGPoint, _ b: CGPoint) -> Double { hypot(Double(b.x - a.x), Double(b.y - a.y)) }
        path.forEach { element in
            switch element {
            case .move(let p):
                out.move(to: nudge(p))
                current = p
                start = p
            case .line(let p):
                let a = current
                sample(length: dist(a, p)) { t in CGPoint(x: a.x + (p.x - a.x) * t, y: a.y + (p.y - a.y) * t) }
                current = p
            case .quadCurve(let p, let c):
                let a = current
                sample(length: dist(a, c) + dist(c, p)) { t in
                    let u = 1 - t
                    return CGPoint(x: u * u * a.x + 2 * u * t * c.x + t * t * p.x, y: u * u * a.y + 2 * u * t * c.y + t * t * p.y)
                }
                current = p
            case .curve(let p, let c1, let c2):
                let a = current
                sample(length: dist(a, c1) + dist(c1, c2) + dist(c2, p)) { t in
                    let u = 1 - t
                    let x = u * u * u * a.x + 3 * u * u * t * c1.x + 3 * u * t * t * c2.x + t * t * t * p.x
                    let y = u * u * u * a.y + 3 * u * u * t * c1.y + 3 * u * t * t * c2.y + t * t * t * p.y
                    return CGPoint(x: x, y: y)
                }
                current = p
            case .closeSubpath:
                let a = current, b = start
                if dist(a, b) > 0.01 {
                    sample(length: dist(a, b)) { t in CGPoint(x: a.x + (b.x - a.x) * t, y: a.y + (b.y - a.y) * t) }
                }
                out.closeSubpath()
                current = start
            }
        }
        return out
    }

    /// A watercolour wash: the colour, then the same pigment pooling darker towards the edges
    /// (painted onto itself in multiply, so it deepens in its own hue).
    static func wash(_ path: Path, _ color: Color, rim: Double, in ctx: inout GraphicsContext, strength: Double = 1) {
        ctx.fill(path, with: .color(color))
        pool(path, color, rim: rim, in: &ctx, strength: strength)
    }

    /// Just the pooled edge of a wash, for a shape that is already filled: the same pigment,
    /// deeper (as if multiplied onto itself), stacked thinner and stronger towards the edge.
    static func pool(_ path: Path, _ color: Color, rim: Double, in ctx: inout GraphicsContext, strength: Double = 1) {
        let deep = deeper(color, in: ctx.environment)
        var edge = ctx
        edge.clip(to: path)
        edge.stroke(path, with: .color(deep.opacity(0.22 * strength)), lineWidth: rim * 2)
        edge.stroke(path, with: .color(deep.opacity(0.32 * strength)), lineWidth: rim)
        edge.stroke(path, with: .color(deep.opacity(0.42 * strength)), lineWidth: rim * 0.35)
    }

    /// The colour multiplied by itself: what pooled pigment looks like. (A plain colour, so
    /// drawing it needs no blend layer.)
    static func deeper(_ color: Color, in environment: EnvironmentValues) -> Color {
        let c = color.resolve(in: environment)
        return Color(.sRGB, red: Double(c.red * c.red), green: Double(c.green * c.green), blue: Double(c.blue * c.blue), opacity: Double(c.opacity))
    }

    /// Soft uneven blooms of pigment inside a big wash (where the water pooled while drying).
    static func blooms(_ path: Path, _ color: Color, spots: [CGRect], in ctx: inout GraphicsContext) {
        let box = path.boundingRect.insetBy(dx: -40, dy: -40)
        let deep = deeper(color, in: ctx.environment)
        var c = ctx
        c.clip(to: path)
        for spot in spots where box.intersects(spot) {
            let center = CGPoint(x: spot.midX, y: spot.midY)
            let gradient = Gradient(colors: [deep.opacity(0.28), deep.opacity(0)])
            c.fill(Path(ellipseIn: spot), with: .radialGradient(gradient, center: center, startRadius: 0, endRadius: spot.width / 2))
        }
    }

    /// Fixed places for pigment blooms over the whole world.
    static let bloomSpots: [CGRect] = {
        var rnd = GevelRandom(seed: 5150)
        return (0..<70).map { _ in
            let size = 40 + rnd.next() * 90
            return CGRect(x: rnd.next() * 1040 - 20 - size / 2, y: rnd.next() * 1240 - 20 - size / 2, width: size, height: size * (0.6 + rnd.next() * 0.5))
        }
    }()
}
