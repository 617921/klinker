import SwiftUI

/// Draws a `KaartLandmark` from simple parts: boxes in 3/4 view, roofs, windows, doors,
/// columns, spires, awnings, whole canal houses, and free shapes. Art units: y down, ground y = 0.
nonisolated struct KaartPen {
    var art: KaartLandmark

    /// The side wall of a box `depth` deep runs this far right and up per art unit of depth.
    static let slope = 17.0 / 30.0

    init(wall: UInt32, roof: UInt32 = 0x5B3328, door: UInt32 = 0x1E1E1C, awning: UInt32 = 0xC8261B, accent: UInt32 = 0xF2711C) {
        art = KaartLandmark(wall: wall, roof: roof, door: door, awning: awning, accent: accent)
    }

    // MARK: Free shapes

    /// Remembers where a named part is, for the Gevelplaat (the first one of each kind counts).
    mutating func mark(_ part: GevelDeel, _ rect: CGRect) {
        guard art.marks[part] == nil, !rect.isNull, rect.width > 0 || rect.height > 0 else { return }
        art.marks[part] = rect
    }

    mutating func fill(_ path: Path, _ paint: KaartPaint) {
        art.layers.append(KaartLayer(path: path, paint: paint, line: nil))
    }

    mutating func line(_ path: Path, _ paint: KaartPaint, width: Double = 2) {
        art.layers.append(KaartLayer(path: path, paint: paint, line: width))
    }

    mutating func rect(_ x: Double, _ y: Double, _ w: Double, _ h: Double, _ paint: KaartPaint) {
        fill(Path(CGRect(x: x, y: y, width: w, height: h)), paint)
    }

    mutating func poly(_ points: [(Double, Double)], _ paint: KaartPaint) {
        fill(Self.polygon(points), paint)
    }

    mutating func oval(_ x: Double, _ y: Double, _ w: Double, _ h: Double, _ paint: KaartPaint) {
        fill(Path(ellipseIn: CGRect(x: x, y: y, width: w, height: h)), paint)
    }

    static func polygon(_ points: [(Double, Double)]) -> Path {
        var p = Path()
        guard let first = points.first else { return p }
        p.move(to: CGPoint(x: first.0, y: first.1))
        for q in points.dropFirst() { p.addLine(to: CGPoint(x: q.0, y: q.1)) }
        p.closeSubpath()
        return p
    }

    // MARK: Boxes and roofs

    /// A box in 3/4 view: front face x...x+w, `h` high, standing on `base` (0 = the ground),
    /// with its side wall and flat top `depth` deep. The first box drawn is the main front.
    @discardableResult
    mutating func box(x: Double, w: Double, h: Double, depth: Double = 30, base: Double = 0, paint: KaartPaint = .wall, top: KaartPaint = .roof) -> CGRect {
        let dx = depth, dy = -depth * Self.slope
        let y0 = base - h
        poly([(x + w, base), (x + w + dx, base + dy), (x + w + dx, y0 + dy), (x + w, y0)], paint.shaded)
        poly([(x, y0), (x + dx, y0 + dy), (x + w + dx, y0 + dy), (x + w, y0)], top)
        let front = CGRect(x: x, y: y0, width: w, height: h)
        fill(Path(front), paint)
        mark(.gevel, front)
        if top == .roof && w >= 40 && depth >= 20 { mark(.dak, CGRect(x: x + dx * 0.3, y: y0 + dy, width: w, height: -dy)) }
        if paint == .wall && Gevelkit.isBrick(art.wall) { mortar(front) }
        if art.front == .zero { art.front = front }
        return front
    }

    /// Courses of bricks with staggered joints, inside `area`.
    mutating func mortar(_ area: CGRect) {
        var lines = Path()
        var row = 0
        var y = Double(area.maxY) - 4.2
        while y > Double(area.minY) {
            lines.move(to: CGPoint(x: area.minX, y: y)); lines.addLine(to: CGPoint(x: area.maxX, y: y))
            var x = Double(area.minX) + (row % 2 == 0 ? 4.2 : 8.4)
            while x < Double(area.maxX) {
                lines.move(to: CGPoint(x: x, y: y)); lines.addLine(to: CGPoint(x: x, y: y + 4.2))
                x += 8.4
            }
            y -= 4.2
            row += 1
        }
        art.layers.append(KaartLayer(path: lines, paint: .mortar, line: 0.45, clip: Path(area)))
        mark(.baksteen, area)
    }

    /// A pitched roof with its gable end facing you (ridge running back), on top of `front`.
    mutating func gableRoof(over front: CGRect, rise: Double, depth: Double = 30, overhang: Double = 3, gable: KaartPaint = .wall) {
        let dx: Double = depth, dy: Double = -depth * Self.slope
        let left = Double(front.minX), right = Double(front.maxX), top = Double(front.minY)
        let px = Double(front.midX), py = top - rise
        poly([(px, py), (px + dx, py + dy), (right + overhang + dx, top + dy), (right + overhang, top)], .roofSide)
        poly([(left, top), (px, py), (right, top)], gable)
        line(Self.polygonLine([(left - overhang, top + 1), (px, py), (right + overhang, top + 1)]), .roof, width: 3.5)
        mark(.dak, CGRect(x: px + dx * 0.2, y: py + dy * 0.3, width: right - px + dx * 0.6, height: (top - py) * 0.8))
    }

    /// A pitched roof with its long eaves facing you (ridge running left to right).
    mutating func ridgeRoof(over front: CGRect, rise: Double, depth: Double = 30, overhang: Double = 3) {
        let dx: Double = depth, dy: Double = -depth * Self.slope
        let left = Double(front.minX), right = Double(front.maxX), top = Double(front.minY)
        let ridgeY = top - rise + dy / 2
        poly([(right + overhang, top), (right + dx + overhang, top + dy), (right + dx / 2 + overhang, ridgeY)], .roofSide)
        poly([(left - overhang, top), (right + overhang, top), (right + dx / 2 + overhang, ridgeY), (left + dx / 2 - overhang, ridgeY)], .roof)
        mark(.dak, CGRect(x: left + dx / 4, y: ridgeY, width: right - left, height: top - ridgeY))
    }

    /// A dome on top of `front` (museum, church, observatory).
    mutating func dome(over front: CGRect, cx: Double? = nil, w: Double, h: Double, paint: KaartPaint = .roof) {
        let c = cx ?? front.midX
        var p = Path()
        p.move(to: CGPoint(x: c - w / 2, y: front.minY))
        p.addQuadCurve(to: CGPoint(x: c + w / 2, y: front.minY), control: CGPoint(x: c, y: front.minY - h * 2))
        p.closeSubpath()
        fill(p, paint)
        if w >= 30 { mark(.koepel, CGRect(x: c - w / 4, y: Double(front.minY) - h * 0.9, width: w / 2, height: h * 0.6)) }
    }

    /// A spire or pointed tower roof standing on `base` (y), `w` wide at the foot.
    mutating func spire(cx: Double, base: Double, w: Double, h: Double, paint: KaartPaint = .roof) {
        poly([(cx - w / 2, base), (cx, base - h), (cx + w / 2, base)], paint)
        poly([(cx, base - h), (cx + w / 2, base), (cx + w / 2 + 6, base - 4)], paint.shaded)
        mark(.toren, CGRect(x: cx - w / 4, y: base - h * 0.45, width: w / 2, height: h * 0.3))
    }

    // MARK: Fronts

    /// A grid of windows inside `area`, with cream frames and sills. `lit` picks which glow at night.
    mutating func windows(in area: CGRect, cols: Int, rows: Int, w: Double = 10, h: Double = 14, arched: Bool = false, seed: Int = 1) {
        guard cols > 0, rows > 0 else { return }
        var rnd = GevelRandom(seed: seed * 977 + 13)
        let gapX = (area.width - Double(cols) * w) / Double(cols + 1)
        let gapY = (area.height - Double(rows) * h) / Double(rows + 1)
        var glass = Path(), lit = Path(), frames = Path(), sills = Path()
        for r in 0..<rows {
            for c in 0..<cols {
                let x = area.minX + gapX + Double(c) * (w + gapX)
                let y = area.minY + gapY + Double(r) * (h + gapY)
                let pane = Self.window(x: x, y: y, w: w, h: h, arched: arched)
                mark(.raam, CGRect(x: x, y: y, width: w, height: h))
                if rnd.next() < 0.55 { lit.addPath(pane) } else { glass.addPath(pane) }
                frames.addPath(pane)
                frames.move(to: CGPoint(x: x + w / 2, y: y + (arched ? w / 2 : 0)))
                frames.addLine(to: CGPoint(x: x + w / 2, y: y + h))
                if h >= 15 && w >= 9 {
                    // Sash rails: eight panes.
                    for f in [0.25, 0.5, 0.75] where !arched || h * f > w / 2 {
                        frames.move(to: CGPoint(x: x, y: y + h * f)); frames.addLine(to: CGPoint(x: x + w, y: y + h * f))
                    }
                }
                sills.addRect(CGRect(x: x - 1.5, y: y + h, width: w + 3, height: 2.2))
            }
        }
        fill(glass, .glass)
        fill(lit, .lit)
        line(frames, .trim, width: 1.6)
        fill(sills, .trim)
    }

    static func window(x: Double, y: Double, w: Double, h: Double, arched: Bool) -> Path {
        guard arched else { return Path(CGRect(x: x, y: y, width: w, height: h)) }
        var p = Path()
        p.move(to: CGPoint(x: x, y: y + h))
        p.addLine(to: CGPoint(x: x, y: y + w / 2))
        p.addArc(center: CGPoint(x: x + w / 2, y: y + w / 2), radius: w / 2, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
        p.addLine(to: CGPoint(x: x + w, y: y + h))
        p.closeSubpath()
        return p
    }

    /// The front door (the first door drawn is where the ribbon goes while locked).
    mutating func door(cx: Double, w: Double = 14, h: Double = 24, base: Double = 0, arched: Bool = false, paint: KaartPaint = .door) {
        let rect = CGRect(x: cx - w / 2, y: base - h, width: w, height: h)
        let shape = Self.window(x: rect.minX, y: rect.minY, w: w, h: h, arched: arched)
        line(shape, .trim, width: 3)
        fill(shape, paint)
        oval(cx + w / 2 - 4, base - h / 2, 2, 2, .trim)
        if art.doorRect == .zero { art.doorRect = rect }
        mark(.deur, rect)
    }

    /// Classical columns from x to x2 on `base`, `h` high, with a beam on top.
    mutating func columns(from x: Double, to x2: Double, count: Int, base: Double = 0, h: Double, paint: KaartPaint = .trim) {
        guard count > 1 else { return }
        let step = (x2 - x) / Double(count - 1)
        var shafts = Path()
        for i in 0..<count {
            let cx = x + Double(i) * step
            shafts.addRect(CGRect(x: cx - 3, y: base - h, width: 6, height: h))
            shafts.addRect(CGRect(x: cx - 4.5, y: base - h, width: 9, height: 3))
            shafts.addRect(CGRect(x: cx - 4.5, y: base - 3, width: 9, height: 3))
        }
        fill(shafts, paint)
        rect(x - 8, base - h - 7, x2 - x + 16, 7, paint)
        mark(.zuil, CGRect(x: x - 3, y: base - h, width: 6, height: h))
    }

    /// A triangular pediment above a beam at `y`.
    mutating func pediment(x: Double, w: Double, y: Double, rise: Double, paint: KaartPaint = .trim) {
        poly([(x, y), (x + w / 2, y - rise), (x + w, y)], paint)
        poly([(x + 8, y - 2.5), (x + w / 2, y - rise + 5), (x + w - 8, y - 2.5)], .wall)
    }

    /// A shop awning: a sloped canvas with stripes from x to x+w, hanging from y.
    mutating func awning(x: Double, y: Double, w: Double, drop: Double = 10, stripes: Bool = true) {
        poly([(x - 2, y + drop), (x + w + 2, y + drop), (x + w - 1, y), (x + 1, y)], .awning)
        mark(.luifel, CGRect(x: x, y: y, width: w, height: drop))
        guard stripes else { return }
        var s = Path()
        var at = x + 3
        while at < x + w - 2 {
            s.addPath(Self.polygon([(at, y + 0.5), (at + 4, y + 0.5), (at + 4.6, y + drop - 0.5), (at + 0.6, y + drop - 0.5)]))
            at += 9
        }
        fill(s, .white)
    }

    /// A Dutch flag on a pole whose foot is at (x, y).
    mutating func flag(x: Double, y: Double, height: Double = 34, colors: [UInt32] = [0xAE1C28, 0xFFFFFF, 0x21468B]) {
        rect(x - 0.8, y - height, 1.6, height, .ink)
        for (i, c) in colors.enumerated() { rect(x + 0.8, y - height + Double(i) * 4, 18, 4, .color(c)) }
        mark(.vlag, CGRect(x: x + 0.8, y: y - height, width: 18, height: 12))
    }

    /// Flower boxes under windows and plants by the door.
    mutating func flowerBox(x: Double, y: Double, w: Double) {
        rect(x, y, w, 4, .color(0x4A3524))
        var blooms = Path(), leaves = Path()
        var at = x + 2
        while at < x + w - 1 {
            leaves.addEllipse(in: CGRect(x: at - 1, y: y - 3, width: 4, height: 4))
            blooms.addEllipse(in: CGRect(x: at, y: y - 4.5, width: 2.6, height: 2.6))
            at += 4.5
        }
        fill(leaves, .plant)
        fill(blooms, .bloom)
        mark(.bloembak, CGRect(x: x, y: y - 4, width: w, height: 8))
    }

    /// A tree in a pot or a small street tree, foot at (x, 0).
    mutating func pottedTree(x: Double, h: Double = 26) {
        rect(x - 4, -8, 8, 8, .color(0x6B4A2E))
        rect(x - 0.8, -h + 8, 1.6, h - 16, .ink)
        oval(x - 8, -h - 6, 16, 16, .plant)
    }

    // MARK: Canal houses

    /// A whole gevelkit canal house (same look as the street) with its side wall and roof,
    /// standing on the ground at x. Returns its front face.
    @discardableResult
    mutating func canalHouse(x: Double, type: GableType, width: Double, floors: Int, color: UInt32? = nil, shop: Bool = false, flowers: Bool = false, doorLeft: Bool = false, seed: Int = 1) -> CGRect {
        var rnd = GevelRandom(seed: seed * 131 + 7)
        var lit: [Bool] = []
        for _ in 0..<24 { lit.append(rnd.next() < 0.5) }
        let spec = HouseSpec(
            type: type, width: width, floors: floors,
            cols: width >= 96 ? 4 : width >= 76 ? 3 : 2, doorLeft: doorLeft, shop: shop,
            flowers: flowers, lit: lit, color: color ?? art.wall, door: art.door, awning: art.awning, stone: 0
        )
        let g = Gevelkit.gevel(spec)
        let B = g.size.height
        let yb = B - (60 + 34 * Double(floors))
        let wallTop = type == .lijst ? yb - 28 : yb
        let x0 = 3.0, x1 = 3 + width, cx = 3 + width / 2
        let D = 30.0, DY = 17.0
        let move = CGAffineTransform(translationX: x - x0, y: -B)
        let body: KaartPaint = color.map { .color($0) } ?? .wall

        var side = GevelPen()
        side.M(x1, B); side.L(x1 + D, B - DY); side.V(wallTop - DY); side.L(x1, wallTop); side.Z()
        fill(side.path.applying(move), body.shaded)
        var roof = GevelPen()
        if type == .lijst {
            roof.M(x0 - 3, wallTop); roof.L(x0 - 3 + D, wallTop - DY); roof.H(x1 + 3 + D); roof.L(x1 + 3, wallTop); roof.Z()
        } else {
            roof.M(cx, g.topY); roof.L(cx + D, g.topY - DY); roof.L(x1 + D, yb - DY); roof.L(x1, yb); roof.Z()
        }
        fill(roof.path.applying(move), type == .lijst ? .color(0x6E6B64) : .roof)

        fill(g.body.applying(move), body)
        if Gevelkit.isBrick(color ?? art.wall) {
            art.layers.append(KaartLayer(path: g.brick.applying(move), paint: .mortar, line: 0.45, clip: g.body.applying(move)))
        }
        line(g.edge.applying(move), .trim, width: 3)
        fill(g.trim.applying(move), .trim)
        fill(g.steps.applying(move), .color(0xCFC8BA))
        fill(g.glass.applying(move), .glass)
        line(g.glass.applying(move), .trim, width: 2.5)
        fill(g.lit.applying(move), .lit)
        fill(g.curtains.applying(move), .curtain)
        line(g.lit.applying(move), .trim, width: 2.5)
        line(g.mull.applying(move), .trim, width: 1.1)
        fill(g.shutters.applying(move), .door)
        line(g.ornament.applying(move), .trim, width: 2.2)
        fill(g.door.applying(move), .door)
        fill(g.awning.applying(move), .awning)
        fill(g.stripes.applying(move), .white)
        fill(g.box.applying(move), .color(0x3F5A4A))
        fill(g.bloom.applying(move), .bloom)
        fill(g.deco.applying(move), .ink)
        line(g.iron.applying(move), .ink, width: 1.1)

        let doorBox = g.door.boundingRect
        if art.doorRect == .zero, !doorBox.isNull { art.doorRect = doorBox.applying(move) }
        let front = CGRect(x: x, y: wallTop - B, width: width, height: B - wallTop)
        if art.front == .zero { art.front = front }
        if art.gable == nil { art.gable = type }
        // Where the Gevelplaat points.
        let first = { (path: Path) in KaartLandmarkPainter.subpathBounds(path.applying(move)).first ?? .null }
        mark(.gevel, front)
        mark(.dak, roof.path.applying(move).boundingRect)
        mark(.raam, first(g.lit.isEmpty ? g.glass : g.lit))
        mark(.deur, doorBox.applying(move))
        mark(.stoep, g.steps.applying(move).boundingRect)
        mark(.hijsbalk, g.hoist.applying(move))
        mark(.lantaarn, g.lamp.applying(move))
        mark(.luifel, g.awning.applying(move).boundingRect)
        mark(.bloembak, first(g.box))
        mark(.gordijn, first(g.curtains))
        if Gevelkit.isBrick(color ?? art.wall) { mark(.baksteen, front) }
        return front
    }

    static func polygonLine(_ points: [(Double, Double)]) -> Path {
        var p = Path()
        guard let first = points.first else { return p }
        p.move(to: CGPoint(x: first.0, y: first.1))
        for q in points.dropFirst() { p.addLine(to: CGPoint(x: q.0, y: q.1)) }
        return p
    }
}
