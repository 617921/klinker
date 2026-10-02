import SwiftUI

// A copy of the Stad gevelkit (`gevel()`, `rng()`, `shade()`), with its own type names, for Noor's
// klokgevel and her neighbours. Same constants and geometry as the StadStraat prototype; day and
// night colours (the StadHuis prototype's `hstyle`), no seasons.

/// Colours for the house drawings, usable from any isolation.
nonisolated enum HouseInk {
    static func hex(_ value: UInt32, _ opacity: Double = 1) -> Color {
        Color(
            .sRGB,
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255,
            opacity: opacity
        )
    }

    /// Multiplies each channel by `f` (the prototype's `shade(hex, f)`).
    static func shade(_ value: UInt32, _ f: Double) -> UInt32 {
        func ch(_ v: UInt32) -> UInt32 { UInt32(max(0, min(255, (Double(v) * f + 0.5).rounded(.down)))) }
        return (ch((value >> 16) & 0xFF) << 16) | (ch((value >> 8) & 0xFF) << 8) | ch(value & 0xFF)
    }
}

/// mulberry32, the prototype's seeded random generator (same constants, same sequence).
nonisolated struct HouseRandom {
    private var state: UInt32

    init(seed: Int) {
        state = UInt32(truncatingIfNeeded: seed)
    }

    mutating func next() -> Double {
        state = state &+ 0x6D2B_79F5
        var t = state
        t = (t ^ (t >> 15)) &* (t | 1)
        t ^= t &+ ((t ^ (t >> 7)) &* (t | 61))
        return Double(t ^ (t >> 14)) / 4_294_967_296
    }

    /// `a[Math.floor(rnd() * a.length)]`
    mutating func pick<T>(_ items: [T]) -> T {
        items[min(items.count - 1, Int(next() * Double(items.count)))]
    }
}

/// The five Amsterdam gable types.
nonisolated enum HouseGable: String, CaseIterable, Hashable, Sendable {
    case trap, hals, klok, tuit, lijst

    var gableHeight: Double {
        switch self {
        case .trap: 54
        case .hals: 62
        case .klok: 58
        case .tuit: 46
        case .lijst: 26
        }
    }
}

/// One canal house (the prototype's `o` object plus its colours).
nonisolated struct HouseFacadeSpec: Hashable, Sendable {
    var type: HouseGable
    var width: Double
    var floors: Int
    var cols: Int
    var doorLeft: Bool
    var shop: Bool
    var flowers: Bool
    var lit: [Bool] = [false]
    var color: UInt32
    var door: UInt32
    var awning: UInt32
}

/// The path set of one house, in the house's own coordinates (0,0)–(W+6, T).
nonisolated struct HouseFacadeShape: Sendable {
    var size: CGSize
    var topY: CGFloat
    var body = Path()
    var edge = Path()
    var trim = Path()
    var glass = Path()
    var lit = Path()
    var mull = Path()
    var door = Path()
    var awning = Path()
    var stripes = Path()
    var box = Path()
    var bloom = Path()
    var snow = Path()
    var deco = Path()
}

/// A tiny SVG-like pen: same commands as the prototype's path strings.
nonisolated struct HousePen {
    private(set) var path = Path()
    private var cur = CGPoint.zero
    private var start = CGPoint.zero

    mutating func M(_ x: Double, _ y: Double) {
        cur = CGPoint(x: x, y: y)
        start = cur
        path.move(to: cur)
    }

    mutating func L(_ x: Double, _ y: Double) {
        cur = CGPoint(x: x, y: y)
        path.addLine(to: cur)
    }

    mutating func H(_ x: Double) { L(x, cur.y) }
    mutating func V(_ y: Double) { L(cur.x, y) }
    mutating func h(_ dx: Double) { L(cur.x + dx, cur.y) }
    mutating func v(_ dy: Double) { L(cur.x, cur.y + dy) }
    mutating func l(_ dx: Double, _ dy: Double) { L(cur.x + dx, cur.y + dy) }

    mutating func C(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double, _ x: Double, _ y: Double) {
        cur = CGPoint(x: x, y: y)
        path.addCurve(to: cur, control1: CGPoint(x: x1, y: y1), control2: CGPoint(x: x2, y: y2))
    }

    mutating func Q(_ x1: Double, _ y1: Double, _ x: Double, _ y: Double) {
        cur = CGPoint(x: x, y: y)
        path.addQuadCurve(to: cur, control: CGPoint(x: x1, y: y1))
    }

    mutating func Z() {
        path.closeSubpath()
        cur = start
    }

    mutating func add(_ other: Path) { path.addPath(other) }
}

nonisolated enum HouseGevel {
    // MARK: Helpers (same rounding as the prototype)

    /// `Math.round(v * 10) / 10`
    static func r(_ v: Double) -> Double { (v * 10 + 0.5).rounded(.down) / 10 }

    /// `Math.round(v)`
    static func jsRound(_ v: Double) -> Double { (v + 0.5).rounded(.down) }

    /// `'M' + r(x) + ' ' + r(y) + 'h' + r(w) + 'v' + r(h) + 'h' + r(-w) + 'Z'`
    static func rect(_ x: Double, _ y: Double, _ w: Double, _ h: Double) -> Path {
        var p = HousePen()
        p.M(r(x), r(y))
        p.h(r(w))
        p.v(r(h))
        p.h(r(-w))
        p.Z()
        return p.path
    }

    /// A full circle drawn like the prototype's `dot()` (two sweep-0 arcs from the left point).
    static func dot(_ x: Double, _ y: Double, _ d: Double) -> Path {
        let left = CGPoint(x: r(x - d), y: r(y))
        var p = Path()
        p.move(to: left)
        p.addRelativeArc(center: CGPoint(x: left.x + d, y: left.y), radius: d, startAngle: .degrees(180), delta: .degrees(-360))
        p.closeSubpath()
        return p
    }

    /// Multiplies each channel by `f` (prototype `shade(hex, f)`).
    static func shade(_ hex: UInt32, _ f: Double) -> UInt32 {
        func ch(_ v: UInt32) -> UInt32 { UInt32(max(0, min(255, jsRound(Double(v) * f)))) }
        return (ch((hex >> 16) & 0xFF) << 16) | (ch((hex >> 8) & 0xFF) << 8) | ch(hex & 0xFF)
    }

    // MARK: gevel()

    static func gevel(_ o: HouseFacadeSpec) -> HouseFacadeShape {
        let W = o.width, fl = o.floors, fh = 34.0, gh = 46.0, band = 14.0, GH = o.type.gableHeight
        let H = gh + band + Double(fl) * fh
        let T = H + GH + 14
        let x0 = 3.0, x1 = 3 + W, cx = 3 + W / 2, B = T, yb = B - H, gy = B - gh
        var body = HousePen(), edge = HousePen()
        var trim = Path(), glass = Path(), lit = Path(), mull = Path(), deco = Path(), door = Path()
        var awning = Path(), stripes = Path(), box = Path(), bloom = Path(), snow = Path()
        var li = 0

        func isLit() -> Bool {
            guard !o.lit.isEmpty else { return false }
            let v = o.lit[li % o.lit.count]
            li += 1
            return v
        }

        func win(_ x: Double, _ y: Double, _ w: Double, _ h: Double, _ on: Bool) {
            let d = rect(x, y, w, h)
            if on { lit.addPath(d) } else { glass.addPath(d) }
            var m = HousePen()
            m.M(r(x + w / 2), r(y))
            m.v(r(h))
            m.M(r(x), r(y + h * 0.45))
            m.h(r(w))
            mull.addPath(m.path)
        }

        func hoistBeam(_ top: Double) {
            deco.addPath(rect(cx - 2.5, top + 3, 5, 5))
            var p = HousePen()
            p.M(r(cx - 0.6), r(top + 8))
            p.h(1.2)
            p.v(7)
            p.h(-1.2)
            p.Z()
            deco.addPath(p.path)
        }

        var topY = yb - GH
        switch o.type {
        case .trap:
            let sh = GH / 3.6, sw = (W - W * 0.3) / 6
            func cap(_ x: Double, _ y: Double, _ w: Double) -> Path { rect(x, y - 1, w, 4) }
            body.M(x0, r(B))
            body.V(r(yb))
            var x = x0, y = yb
            for i in 0..<3 {
                y -= sh
                body.V(r(y))
                let e = i == 0 ? 2.0 : 0
                trim.addPath(cap(x - e, y, sw + e))
                snow.addPath(rect(x - e, y - 4, sw + e, 4))
                x += sw
                body.H(r(x))
            }
            let top = y - sh * 0.6
            body.V(r(top))
            body.H(r(x1 - 3 * sw))
            body.V(r(y))
            trim.addPath(cap(x - 2, top, x1 - 3 * sw - x + 4))
            snow.addPath(rect(x - 2, top - 4, x1 - 3 * sw - x + 4, 4))
            var xr = x1 - 3 * sw, yr = y
            for i in 0..<3 {
                let e = i == 2 ? 2.0 : 0
                trim.addPath(cap(xr, yr, sw + e))
                snow.addPath(rect(xr, yr - 4, sw + e, 4))
                xr += sw
                body.H(r(xr))
                yr += sh
                body.V(r(yr))
            }
            body.V(r(B))
            body.Z()
            topY = top
            win(cx - 7, yb - GH * 0.62, 14, 18, isLit())
            hoistBeam(top)

        case .hals:
            let nw = W * 0.46, xL = cx - nw / 2, xR = cx + nw / 2
            let ys = yb - GH * 0.42, yn = yb - GH * 0.84, yt = yb - GH
            let left: (inout HousePen) -> Void = { $0.C(r(x0), r(yb - GH * 0.3), r(xL - W * 0.06), r(ys + 2), r(xL), r(ys)) }
            let ped: (inout HousePen) -> Void = { $0.Q(r(cx), r(yt - GH * 0.14), r(xR), r(yn)) }
            let right: (inout HousePen) -> Void = { $0.C(r(xR + W * 0.06), r(ys + 2), r(x1), r(yb - GH * 0.3), r(x1), r(yb)) }
            body.M(x0, r(B))
            body.V(r(yb))
            left(&body)
            body.V(r(yn))
            ped(&body)
            body.V(r(ys))
            right(&body)
            body.V(r(B))
            body.Z()
            edge.M(x0, r(yb))
            left(&edge)
            edge.M(r(xL), r(yn))
            ped(&edge)
            edge.M(r(xR), r(ys))
            right(&edge)
            trim.addPath(rect(xL - 3, yn - 1, nw + 6, 4))
            var s = HousePen()
            s.M(r(xL - 3), r(yn - 1))
            ped(&s)
            s.H(r(xR + 3))
            s.V(r(yn - 1))
            s.Z()
            snow.addPath(s.path)
            win(cx - nw * 0.2, (ys + yn) / 2 - 10, nw * 0.4, 20, isLit())
            glass.addPath(dot(cx, yn - 4, 3))
            topY = yt

        case .klok:
            let nw = W * 0.58, xL = cx - nw / 2, xR = cx + nw / 2
            let ys = yb - GH * 0.4, yc = yb - GH * 1.08
            let left: (inout HousePen) -> Void = { $0.C(r(x0 + W * 0.1), r(yb - GH * 0.04), r(xL), r(yb - GH * 0.14), r(xL), r(ys)) }
            let bell: (inout HousePen) -> Void = { $0.C(r(xL), r(yc), r(xR), r(yc), r(xR), r(ys)) }
            let right: (inout HousePen) -> Void = { $0.C(r(xR), r(yb - GH * 0.14), r(x1 - W * 0.1), r(yb - GH * 0.04), r(x1), r(yb)) }
            body.M(x0, r(B))
            body.V(r(yb))
            left(&body)
            bell(&body)
            right(&body)
            body.V(r(B))
            body.Z()
            edge.M(x0, r(yb))
            left(&edge)
            bell(&edge)
            right(&edge)
            let apex = 0.25 * ys + 0.75 * yc
            win(cx - nw * 0.2, ys - 14, nw * 0.4, 22, isLit())
            deco.addPath(dot(cx, apex - 3, 3))
            var s = HousePen()
            s.M(r(xL), r(ys))
            bell(&s)
            s.C(r(xR), r(yc + 4), r(xL), r(yc + 4), r(xL), r(ys))
            s.Z()
            snow.addPath(s.path)
            topY = apex - 6

        case .tuit:
            let tw = W * 0.26, yt = yb - GH, yk = yb - GH * 0.84
            body.M(x0, r(B))
            body.V(r(yb))
            body.L(r(cx - tw / 2), r(yk))
            body.V(r(yt))
            body.H(r(cx + tw / 2))
            body.V(r(yk))
            body.L(r(x1), r(yb))
            body.V(r(B))
            body.Z()
            edge.M(x0, r(yb))
            edge.L(r(cx - tw / 2), r(yk))
            edge.M(r(cx + tw / 2), r(yk))
            edge.L(r(x1), r(yb))
            trim.addPath(rect(cx - tw / 2 - 2, yt - 1, tw + 4, 4))
            snow.addPath(rect(cx - tw / 2 - 2, yt - 5, tw + 4, 5))
            win(cx - 8, yb - GH * 0.55, 16, 20, isLit())
            hoistBeam(yt)
            topY = yt

        case .lijst:
            let ya = yb - GH
            body.add(rect(x0, ya, W, B - ya))
            trim.addPath(rect(x0 - 3, ya - 2, W + 6, 7))
            for x in stride(from: x0 + 2, to: x1 - 3, by: 7) {
                trim.addPath(rect(x, ya + 5, 3, 3))
            }
            snow.addPath(rect(x0 - 3, ya - 6, W + 6, 5))
            glass.addPath(dot(cx, ya + GH * 0.6, 5.5))
            topY = ya - 2
        }

        // Floors
        let cols = max(1, o.cols), m = W * 0.12, cw = (W - 2 * m) / Double(cols), ww = cw * 0.62, wh = fh * 0.62
        for f in 0..<fl {
            let y = yb + Double(f) * fh + fh * 0.18
            for k in 0..<cols {
                let x = x0 + m + Double(k) * cw + (cw - ww) / 2
                win(x, y, ww, wh, isLit())
                trim.addPath(rect(x - 2, y + wh, ww + 4, 3))
                if f == fl - 1 && o.flowers {
                    box.addPath(rect(x - 1, y + wh + 3, ww + 2, 5))
                    bloom.addPath(dot(x + ww * 0.2, y + wh + 1, 2))
                    bloom.addPath(dot(x + ww * 0.5, y + wh, 2.2))
                    bloom.addPath(dot(x + ww * 0.8, y + wh + 1, 2))
                }
            }
        }
        let bandTop = yb + Double(fl) * fh
        trim.addPath(rect(x0, gy - 3, W, 3))
        trim.addPath(rect(cx - 10, bandTop + 2, 20, 9))
        deco.addPath(dot(cx, bandTop + 6.5, 2.4))

        // Ground floor: door plus shop window or windows
        let dw = max(16, W * 0.22), dh = gh * 0.72
        let dx = o.doorLeft ? x0 + m * 0.7 : x1 - m * 0.7 - dw
        door = rect(dx, B - dh, dw, dh)
        glass.addPath(rect(dx + 2, B - dh - 9, dw - 4, 7))
        trim.addPath(rect(dx - 4, B - 3, dw + 8, 3))
        deco.addPath(rect(dx + dw * 0.72, B - dh * 0.5, 2.5, 2.5))
        let sx = o.doorLeft ? dx + dw + 6 : x0 + m * 0.7
        let avail = W - dw - m * 1.4 - 6
        if o.shop {
            win(sx, gy + 12, avail, gh - 18, isLit())
            var a = HousePen()
            a.M(r(sx - 3), r(gy + 1))
            a.h(r(avail + 6))
            a.l(-4, 9)
            a.h(r(-(avail - 2)))
            a.Z()
            awning = a.path
            for i in stride(from: 0.0, to: avail - 2, by: 8) {
                stripes.addPath(rect(sx + i, gy + 1, 4, 8))
            }
        } else {
            let n = max(1, cols - 1)
            let slot = avail / Double(n)
            let gw = min(ww, slot * 0.8)
            for k in 0..<n {
                win(sx + Double(k) * slot + (slot - gw) / 2, gy + 8, gw, gh * 0.52, isLit())
            }
        }

        return HouseFacadeShape(
            size: CGSize(width: W + 6, height: T), topY: topY,
            body: body.path, edge: edge.path, trim: trim, glass: glass, lit: lit, mull: mull,
            door: door, awning: awning, stripes: stripes, box: box, bloom: bloom, snow: snow, deco: deco
        )
    }

    // MARK: Painting

    /// Paints one house in the prototype's fixed path order. Night darkens the facade (x0.62) and
    /// lights the lit windows.
    static func draw(_ g: HouseFacadeShape, _ o: HouseFacadeSpec, night: Bool, in ctx: inout GraphicsContext) {
        let f = night ? 0.62 : 1
        let trim = HouseInk.hex(night ? 0xB9B4A8 : 0xEFEBE2)
        let glass = HouseInk.hex(night ? 0x232B3B : 0x3E4C55)
        let litGlass = HouseInk.hex(night ? 0xF6D27A : 0x3E4C55)
        ctx.fill(g.body, with: .color(HouseInk.hex(shade(o.color, f))))
        ctx.stroke(g.edge, with: .color(trim), style: StrokeStyle(lineWidth: 3, lineJoin: .round))
        ctx.fill(g.trim, with: .color(trim))
        ctx.fill(g.glass, with: .color(glass))
        ctx.stroke(g.glass, with: .color(trim), lineWidth: 2.5)
        ctx.fill(g.lit, with: .color(litGlass))
        ctx.stroke(g.lit, with: .color(trim), lineWidth: 2.5)
        ctx.stroke(g.mull, with: .color(trim), lineWidth: 1.5)
        ctx.fill(g.door, with: .color(HouseInk.hex(shade(o.door, f))))
        ctx.fill(g.awning, with: .color(HouseInk.hex(shade(o.awning, f))))
        ctx.fill(g.stripes, with: .color(Color.white.opacity(0.85)))
        ctx.fill(g.box, with: .color(HouseInk.hex(0x3F5A4A)))
        ctx.fill(g.bloom, with: .color(HouseInk.hex(0xC8261B)))
        ctx.fill(g.deco, with: .color(HouseInk.hex(0x2E2117)))
    }
}
