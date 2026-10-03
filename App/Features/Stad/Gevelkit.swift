import SwiftUI

// The 682 gevelkit: a faithful port of `gevel()`, `street()`, `rng()` and `shade()` from the
// StadStraat prototype. Same constants, same rounding, same geometry, so houses look identical.

/// mulberry32, the prototype's seeded random generator (same constants, same sequence).
nonisolated struct GevelRandom {
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
nonisolated enum GableType: String, CaseIterable, Hashable, Sendable {
    case trap, hals, klok, tuit, lijst

    /// Gable height above the top floor (prototype `GHS`).
    var gableHeight: Double {
        switch self {
        case .trap: 54
        case .hals: 62
        case .klok: 58
        case .tuit: 46
        case .lijst: 26
        }
    }

    var name: String {
        switch self {
        case .trap: "Trapgevel"
        case .hals: "Halsgevel"
        case .klok: "Klokgevel"
        case .tuit: "Tuitgevel"
        case .lijst: "Lijstgevel"
        }
    }

    /// The Dutch word (always a de-word): "trapgevel".
    var word: String { name.lowercased() }

    var fact: String {
        switch self {
        case .trap: "De top gaat omhoog als een trap. Vooral gebouwd rond 1600–1665."
        case .hals: "Een smalle hals met krullen opzij. Populair vanaf ongeveer 1640."
        case .klok: "De top heeft de vorm van een klok. Vooral in de achttiende eeuw."
        case .tuit: "Smal en spits, vaak bij pakhuizen aan het water. Met een hijsbalk boven."
        case .lijst: "Een rechte bovenkant met een kroonlijst. Mode vanaf het eind van de zeventiende eeuw."
        }
    }

    var factEnglish: String {
        switch self {
        case .trap: "Step gable: the top climbs like a staircase. Mostly built around 1600–1665."
        case .hals: "Neck gable: a narrow neck with scrolls on the sides. Popular from about 1640."
        case .klok: "Bell gable: the top is shaped like a bell. Mostly 18th century."
        case .tuit: "Spout gable: narrow and pointed, often on warehouses by the water, with a hoist beam."
        case .lijst: "Cornice gable: a straight top with a cornice. Fashionable from the late 17th century."
        }
    }
}

/// One canal house (the prototype's `o` object plus its colours and gevelsteen).
nonisolated struct HouseSpec: Hashable, Sendable {
    var type: GableType
    var width: Double
    var floors: Int
    var cols: Int
    var doorLeft: Bool
    var shop: Bool
    var flowers: Bool
    var lit: [Bool]
    var color: UInt32
    var door: UInt32
    var awning: UInt32
    var stone: Int

    /// The gevelsteen word on this house: ("de gracht", "canal").
    var stoneWord: (nl: String, en: String) {
        Gevelkit.stones[((stone % Gevelkit.stones.count) + Gevelkit.stones.count) % Gevelkit.stones.count]
    }
}

/// The path set of one house, in the house's own coordinates (0,0)–(W+6, T).
nonisolated struct GevelGeometry: Sendable {
    var size: CGSize
    /// Top of the gable (where the name tag hangs).
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
    // The rich details (only with `rich`; the tiny background houses skip them).
    /// Mortar lines between the bricks (stroke, clipped to `body`; brick houses only).
    var brick = Path()
    /// White stone curls and crowns on the gable (stroke).
    var ornament = Path()
    /// Wrought iron: railings, wall anchors, the lamp bracket, cellar bars (stroke).
    var iron = Path()
    /// Stone front steps (fill).
    var steps = Path()
    /// Curtains in the lit windows (fill).
    var curtains = Path()
    /// Warehouse shutters beside the windows (fill, door colour).
    var shutters = Path()
}

/// A tiny SVG-like pen: same commands as the prototype's path strings.
nonisolated struct GevelPen {
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

nonisolated enum Gevelkit {
    static let facades: [UInt32] = [
        0x7B3F2E, 0x9A5238, 0x5B3328, 0x8C4A3A, 0x6E3A2C, 0x2C2C2A, 0x5E6B73,
        0xD9CDB4, 0xE3D6BC, 0xC9A15B, 0x3F5A4A, 0x7B3F2E, 0x9A5238,
    ]
    static let doors: [UInt32] = [0x2F4B3A, 0x1F3A6B, 0x7A1E1E, 0x1E1E1C, 0x24533F]
    static let awnings: [UInt32] = [0xC8261B, 0x2F4B3A, 0x1F3A6B, 0xF2711C]
    static let streetTypes: [GableType] = [.trap, .trap, .hals, .hals, .hals, .klok, .klok, .klok, .tuit, .lijst, .lijst]

    static let stones: [(nl: String, en: String)] = [
        ("de gracht", "canal"), ("de brug", "bridge"), ("de boot", "boat"), ("het raam", "window"), ("de deur", "door"),
        ("het dak", "roof"), ("de trap", "stairs"), ("de fiets", "bike"), ("de sleutel", "key"), ("de bloem", "flower"),
        ("de vis", "fish"), ("het schip", "ship"), ("de buurman", "neighbour"), ("het loket", "service counter"),
        ("de afspraak", "appointment"), ("de gemeente", "municipality"), ("de huur", "rent"),
    ]

    // MARK: Helpers (same rounding as the prototype)

    /// `Math.round(v * 10) / 10`
    static func r(_ v: Double) -> Double { (v * 10 + 0.5).rounded(.down) / 10 }

    /// `Math.round(v)`
    static func jsRound(_ v: Double) -> Double { (v + 0.5).rounded(.down) }

    /// `'M' + r(x) + ' ' + r(y) + 'h' + r(w) + 'v' + r(h) + 'h' + r(-w) + 'Z'`
    static func rect(_ x: Double, _ y: Double, _ w: Double, _ h: Double) -> Path {
        var p = GevelPen()
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

    /// Is this facade colour brick (red, brown or tarred black), so mortar shows? Cream, grey
    /// and green fronts are painted.
    static func isBrick(_ hex: UInt32) -> Bool {
        let r = Int(hex >> 16 & 0xFF), g = Int(hex >> 8 & 0xFF), b = Int(hex & 0xFF)
        let lum = (r * 3 + g * 6 + b) / 10
        return (r > g + 25 && r > b + 25 && lum < 200) || lum < 55
    }

    /// One canal house. `rich` adds the close-up details (bricks, sash panes, curtains, curls,
    /// stoop and railings, anchors, lamp); the tiny background houses skip them.
    static func gevel(_ o: HouseSpec, rich: Bool = true) -> GevelGeometry {
        let W = o.width, fl = o.floors, fh = 34.0, gh = 46.0, band = 14.0, GH = o.type.gableHeight
        let H = gh + band + Double(fl) * fh
        let T = H + GH + 14
        let x0 = 3.0, x1 = 3 + W, cx = 3 + W / 2, B = T, yb = B - H, gy = B - gh
        var body = GevelPen(), edge = GevelPen()
        var trim = Path(), glass = Path(), lit = Path(), mull = Path(), deco = Path(), door = Path()
        var awning = Path(), stripes = Path(), box = Path(), bloom = Path(), snow = Path()
        var ornament = Path(), iron = Path(), steps = Path(), curtains = Path(), shutters = Path()
        var li = 0

        func isLit() -> Bool {
            guard !o.lit.isEmpty else { return false }
            let v = o.lit[li % o.lit.count]
            li += 1
            return v
        }

        /// A window. Rich sash windows get eight panes (a centre bar and three rails), shop
        /// windows tall mullions and a transom; lit ones get curtains.
        func win(_ x: Double, _ y: Double, _ w: Double, _ h: Double, _ on: Bool, shop: Bool = false, drapes: Bool = false) {
            let d = rect(x, y, w, h)
            if on { lit.addPath(d) } else { glass.addPath(d) }
            var m = GevelPen()
            if rich && shop {
                var at = x + 11
                while at < x + w - 4 { m.M(r(at), r(y)); m.v(r(h)); at += 11 }
                m.M(r(x), r(y + h * 0.28)); m.h(r(w))
            } else if rich && h >= 15 && w >= 9 {
                m.M(r(x + w / 2), r(y)); m.v(r(h))
                for f in [0.25, 0.5, 0.75] { m.M(r(x), r(y + h * f)); m.h(r(w)) }
            } else {
                m.M(r(x + w / 2), r(y)); m.v(r(h))
                m.M(r(x), r(y + h * 0.45)); m.h(r(w))
            }
            mull.addPath(m.path)
            if rich && drapes && on {
                // A valance and two curtains hanging at the sides.
                curtains.addPath(rect(x, y, w, h * 0.12))
                curtains.addPath(rect(x, y, w * 0.2, h))
                curtains.addPath(rect(x + w * 0.8, y, w * 0.2, h))
            }
        }

        /// A white stone curl (volute) centred at (x, y), curling in towards `dir` (+1 right).
        func curl(_ x: Double, _ y: Double, _ radius: Double, _ dir: Double) {
            var p = Path()
            for i in 0...28 {
                let t = Double(i) / 28
                let a = .pi / 2 + dir * t * 2.4 * .pi
                let rr = radius * (1 - 0.72 * t)
                let point = CGPoint(x: x + rr * cos(a) * dir, y: y - rr * sin(a))
                if i == 0 { p.move(to: point) } else { p.addLine(to: point) }
            }
            ornament.addPath(p)
        }

        /// Iron wall anchors (muurankers) at the floor lines, between the windows.
        func anchors(_ xs: [Double], _ y: Double) {
            for x in xs {
                var p = GevelPen()
                p.M(r(x), r(y - 4)); p.v(8)
                p.M(r(x - 2), r(y - 3)); p.l(4, 0)
                p.M(r(x - 2), r(y + 3)); p.l(4, 0)
                iron.addPath(p.path)
            }
        }

        func hoistBeam(_ top: Double) {
            deco.addPath(rect(cx - 2.5, top + 3, 5, 5))
            var p = GevelPen()
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
            let left: (inout GevelPen) -> Void = { $0.C(r(x0), r(yb - GH * 0.3), r(xL - W * 0.06), r(ys + 2), r(xL), r(ys)) }
            let ped: (inout GevelPen) -> Void = { $0.Q(r(cx), r(yt - GH * 0.14), r(xR), r(yn)) }
            let right: (inout GevelPen) -> Void = { $0.C(r(xR + W * 0.06), r(ys + 2), r(x1), r(yb - GH * 0.3), r(x1), r(yb)) }
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
            var s = GevelPen()
            s.M(r(xL - 3), r(yn - 1))
            ped(&s)
            s.H(r(xR + 3))
            s.V(r(yn - 1))
            s.Z()
            snow.addPath(s.path)
            win(cx - nw * 0.2, (ys + yn) / 2 - 10, nw * 0.4, 20, isLit())
            glass.addPath(dot(cx, yn - 4, 3))
            if rich {
                curl(x0 + W * 0.13, yb - GH * 0.2, W * 0.06, 1)
                curl(x1 - W * 0.13, yb - GH * 0.2, W * 0.06, -1)
                ornament.addPath(dot(cx, yt - GH * 0.05, 2.2))
            }
            topY = yt

        case .klok:
            let nw = W * 0.58, xL = cx - nw / 2, xR = cx + nw / 2
            let ys = yb - GH * 0.4, yc = yb - GH * 1.08
            let left: (inout GevelPen) -> Void = { $0.C(r(x0 + W * 0.1), r(yb - GH * 0.04), r(xL), r(yb - GH * 0.14), r(xL), r(ys)) }
            let bell: (inout GevelPen) -> Void = { $0.C(r(xL), r(yc), r(xR), r(yc), r(xR), r(ys)) }
            let right: (inout GevelPen) -> Void = { $0.C(r(xR), r(yb - GH * 0.14), r(x1 - W * 0.1), r(yb - GH * 0.04), r(x1), r(yb)) }
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
            if rich {
                curl(x0 + W * 0.15, yb - GH * 0.12, W * 0.065, 1)
                curl(x1 - W * 0.15, yb - GH * 0.12, W * 0.065, -1)
                // A stone crown over the bell and the hoisting beam under it.
                ornament.addEllipse(in: CGRect(x: cx - 6, y: apex - 9, width: 12, height: 7))
                hoistBeam(apex - 1)
            }
            var s = GevelPen()
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
        let warehouse = o.type == .tuit
        for f in 0..<fl {
            let y = yb + Double(f) * fh + fh * 0.18
            if rich && f > 0 && (o.type == .trap || o.type == .tuit || o.type == .hals) {
                // A thin stone band at each floor, with iron anchors on brick fronts.
                trim.addPath(rect(x0, yb + Double(f) * fh - 1, W, 1.8))
                if isBrick(o.color) { anchors((1..<cols).map { x0 + m + Double($0) * cw }, yb + Double(f) * fh) }
            }
            for k in 0..<cols {
                let x = x0 + m + Double(k) * cw + (cw - ww) / 2
                win(x, y, ww, wh, isLit(), drapes: !warehouse)
                trim.addPath(rect(x - 2, y + wh, ww + 4, 3))
                if rich {
                    // Stone lintel (with a keystone on the grander fronts).
                    trim.addPath(rect(x - 1.5, y - 3.5, ww + 3, 3))
                    if o.type == .lijst || o.type == .klok { trim.addPath(rect(x + ww / 2 - 1.6, y - 5, 3.2, 4.5)) }
                    if warehouse {
                        shutters.addPath(rect(x - ww * 0.42 - 1, y, ww * 0.42, wh))
                        shutters.addPath(rect(x + ww + 1, y, ww * 0.42, wh))
                    }
                }
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
        // Houses (not shops) stand on a stoop: the door is raised over stone steps.
        let stoop = rich && !o.shop ? 7.0 : 0
        let db = B - stoop
        door = rect(dx, db - dh, dw, dh)
        glass.addPath(rect(dx + 2, db - dh - 9, dw - 4, 7))
        deco.addPath(rect(dx + dw * 0.72, db - dh * 0.5, 2.5, 2.5))
        if stoop > 0 {
            trim.addPath(rect(dx - 2, db - 1.5, dw + 4, 2))
            steps.addPath(rect(dx - 2, db, dw + 4, 2.4))
            steps.addPath(rect(dx - 4, db + 2.4, dw + 8, 2.3))
            steps.addPath(rect(dx - 6, db + 4.7, dw + 12, 2.3))
            // Railings either side, and a lamp by the door.
            var rail = GevelPen()
            rail.M(r(dx - 6), r(B)); rail.L(r(dx - 2), r(db - 9)); rail.M(r(dx - 6), r(B)); rail.v(-9)
            rail.M(r(dx + dw + 6), r(B)); rail.L(r(dx + dw + 2), r(db - 9)); rail.M(r(dx + dw + 6), r(B)); rail.v(-9)
            iron.addPath(rail.path)
            let lampX = o.doorLeft ? dx + dw + 5 : dx - 9
            iron.addPath(rect(lampX + 1.5, db - dh + 2, 1, 6))
            lit.addPath(rect(lampX, db - dh + 8, 4, 6))
            deco.addPath(rect(lampX - 0.5, db - dh + 7, 5, 1.4))
            // Plants in pots at the foot of the steps.
            let px = o.doorLeft ? dx + dw + 10 : dx - 13
            deco.addPath(rect(px, B - 6, 6, 6))
            box.addPath(dot(px + 3, B - 9, 4.4))
        } else {
            trim.addPath(rect(dx - 4, B - 3, dw + 8, 3))
        }
        if rich {
            // Transom bars and door panels.
            var bars = GevelPen()
            bars.M(r(dx + dw / 3 + 0.7), r(db - dh - 9)); bars.v(7)
            bars.M(r(dx + 2 * dw / 3 - 0.7), r(db - dh - 9)); bars.v(7)
            mull.addPath(bars.path)
            iron.addPath(rect(dx + 3, db - dh + 4, dw - 6, dh * 0.38))
            iron.addPath(rect(dx + 3, db - dh * 0.48, dw - 6, dh * 0.38))
        }
        let sx = o.doorLeft ? dx + dw + 6 : x0 + m * 0.7
        let avail = W - dw - m * 1.4 - 6
        if o.shop {
            win(sx, gy + 12, avail, gh - 18, isLit(), shop: true)
            var a = GevelPen()
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
                let wx = sx + Double(k) * slot + (slot - gw) / 2
                win(wx, gy + 8, gw, gh * 0.52, isLit(), drapes: true)
                if rich {
                    // A barred cellar window under the ground-floor window.
                    glass.addPath(rect(wx + 1, B - 9, gw - 2, 6))
                    var bars = GevelPen()
                    var bx = wx + 3.5
                    while bx < wx + gw - 2 { bars.M(r(bx), r(B - 9)); bars.v(6); bx += 3.5 }
                    iron.addPath(bars.path)
                }
            }
        }

        // Mortar: courses of bricks with staggered joints (painters clip them to the wall).
        var brick = Path()
        if rich && isBrick(o.color) {
            var lines = brick
            var row = 0
            var y = B - 4.2
            while y > topY - 4 {
                lines.move(to: CGPoint(x: x0, y: y)); lines.addLine(to: CGPoint(x: x1, y: y))
                var x = x0 + (row % 2 == 0 ? 4.2 : 8.4)
                while x < x1 {
                    lines.move(to: CGPoint(x: x, y: y)); lines.addLine(to: CGPoint(x: x, y: y + 4.2))
                    x += 8.4
                }
                y -= 4.2
                row += 1
            }
            brick = lines
        }

        return GevelGeometry(
            size: CGSize(width: W + 6, height: T), topY: topY,
            body: body.path, edge: edge.path, trim: trim, glass: glass, lit: lit, mull: mull,
            door: door, awning: awning, stripes: stripes, box: box, bloom: bloom, snow: snow, deco: deco,
            brick: brick, ornament: ornament, iron: iron, steps: steps, curtains: curtains, shutters: shutters
        )
    }

    // MARK: street()

    /// A row of houses, at least 1290 units wide (prototype `street(seed)`).
    static func street(seed: Int) -> [HouseSpec] {
        var rnd = GevelRandom(seed: seed)
        var out: [HouseSpec] = []
        var total = 0.0
        var prevType: GableType?
        while total < 1290 {
            var type = rnd.pick(streetTypes)
            if type == prevType { type = rnd.pick(streetTypes) }
            prevType = type
            let W = type == .lijst ? rnd.pick([96.0, 104, 112]) : rnd.pick([62.0, 70, 76, 84, 90])
            var lit: [Bool] = []
            for _ in 0..<24 { lit.append(rnd.next() < 0.45) }
            // Same draw order as the prototype's object literal.
            let floors = type == .lijst ? rnd.pick([3, 4]) : rnd.pick([3, 3, 4, 4, 5])
            let cols = W >= 96 ? 4 : W >= 76 ? 3 : 2
            let doorLeft = rnd.next() < 0.5
            let shop = rnd.next() < 0.25
            let flowers = rnd.next() < 0.55
            let color = rnd.pick(facades)
            let door = rnd.pick(doors)
            let awn = rnd.pick(awnings)
            let stone = Int(rnd.next() * 1000)
            out.append(HouseSpec(
                type: type, width: W, floors: floors, cols: cols, doorLeft: doorLeft, shop: shop,
                flowers: flowers, lit: lit, color: color, door: door, awning: awn, stone: stone
            ))
            total += W + 4
        }
        return out
    }
}
