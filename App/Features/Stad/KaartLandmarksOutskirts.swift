import SwiftUI

/// Out of the centre: harbour, mill, farm, beach, camping, airport, allotments, square,
/// roundabout, dike, ferry and the lookout tower. These have room, so several are little
/// scenes; each still has one door for the ribbon and padlock.
nonisolated extension KaartLandmarks {
    static func outskirts(_ n: Int) -> KaartLandmark? {
        switch n {
        case 24: haven()
        case 44: molen()
        case 45: boerderij()
        case 46: strand()
        case 47: camping()
        case 48: vliegveld()
        case 52: volkstuin()
        case 54: stadhuisplein()
        case 59: rotonde()
        case 60: dijk()
        case 61: veerpont()
        case 62: uitkijktoren()
        default: nil
        }
    }

    // MARK: On the water

    /// De haven: a tall brick warehouse with green loading hatches, a red quay crane lifting a crate, a barge moored behind.
    private static func haven() -> KaartLandmark {
        var pen = KaartPen(wall: 0x6E3A2C, roof: 0x34302C, door: 0x2F4B3A, accent: 0xC8261B)
        // The barge, in the river behind the quay: drawn first so the warehouse and crane stand in front.
        let wl = -42.0
        pen.poly([(84, wl - 13), (162, wl - 13), (170, wl - 8), (162, wl), (84, wl)], .color(0x2C2C2A))
        pen.rect(84, wl - 13, 84, 3, .color(0xC8261B))
        pen.box(x: 98, w: 40, h: 8, depth: 8, base: wl - 13, paint: .color(0x3F5A4A), top: .color(0x56715F))
        pen.box(x: 146, w: 16, h: 14, depth: 6, base: wl - 13, paint: .color(0xEFE6D6), top: .color(0x2C2C2A))
        pen.rect(149, wl - 24, 10, 5, .glass)
        pen.flag(x: 168, y: wl - 12, height: 18)
        pen.line(KaartPen.polygonLine([(90, wl + 1.5), (166, wl + 1.5)]), .white, width: 1.2)

        // The warehouse: spout gable with a hoist beam, a column of green loading hatches.
        let W = 62.0, H = 116.0
        let house = pen.box(x: 0, w: W, h: H, depth: 30)
        pen.poly([(31, -H - 50), (61, -H - 67), (W + 30, -H - 17), (W, -H)], .roofSide)
        let gable: [(Double, Double)] = [(0, -H), (16, -H - 30), (22, -H - 30), (22, -H - 50), (40, -H - 50), (40, -H - 30), (46, -H - 30), (W, -H)]
        pen.poly(gable, .wall)
        pen.line(KaartPen.polygonLine(gable), .trim, width: 2.2)
        pen.poly([(19, -H - 50), (31, -H - 60), (43, -H - 50)], .roof)
        pen.rect(29, -H - 50, 4, 7, .ink)
        pen.line(KaartPen.polygonLine([(31, -H - 43), (31, -H - 14)]), .ink, width: 0.9)
        pen.rect(28.5, -H - 14, 5, 3, .ink)
        pen.door(cx: 31, w: 20, h: 32, arched: true)
        pen.rect(0, -42, W, 2.5, .trim)
        for (y, w) in [(-63.0, 16.0), (-89, 16), (-114, 16), (-H - 26, 12)] {
            let hatch = CGRect(x: 31 - w / 2, y: y, width: w, height: 19)
            pen.fill(Path(hatch), .door)
            var frame = Path(hatch)
            frame.move(to: CGPoint(x: hatch.midX, y: hatch.minY))
            frame.addLine(to: CGPoint(x: hatch.midX, y: hatch.maxY))
            pen.line(frame, .trim, width: 1.4)
        }
        pen.windows(in: CGRect(x: 2, y: -H, width: 18, height: 74), cols: 1, rows: 3, w: 10, h: 15, seed: 24)
        pen.windows(in: CGRect(x: 42, y: -H, width: 18, height: 74), cols: 1, rows: 3, w: 10, h: 15, seed: 25)
        pen.windows(in: CGRect(x: 1, y: -38, width: 18, height: 26), cols: 1, rows: 1, w: 10, h: 15, seed: 26)
        pen.windows(in: CGRect(x: 43, y: -38, width: 18, height: 26), cols: 1, rows: 1, w: 10, h: 15, seed: 27)

        // The quay crane: a red portal on rails, a cabin, a lattice jib with a crate on the hook.
        pen.rect(90, -3, 42, 3, .ink)
        pen.poly([(92, 0), (97, 0), (107, -58), (103, -58)], .accent)
        pen.poly([(130, 0), (125, 0), (116, -58), (120, -58)], .accent)
        pen.rect(84, -86, 14, 6, .ink)
        pen.line(KaartPen.polygonLine([(96, -83), (104, -83)]), .accent, width: 2)
        pen.box(x: 98, w: 26, h: 22, depth: 10, base: -58, paint: .color(0xC8261B), top: .color(0x2C2C2A))
        pen.rect(102, -75, 9, 8, .glass)
        let foot = (116.0, -80.0), tip = (154.0, -198.0)
        var jib = Path()
        for off in [-3.0, 3.0] { jib.addPath(KaartPen.polygonLine([(foot.0 + off, foot.1), (tip.0 + off * 0.4, tip.1)])) }
        for i in 0..<9 {
            let t0 = Double(i) / 9, t1 = Double(i + 1) / 9
            let a = (foot.0 - 3 + (tip.0 - foot.0) * t0, foot.1 + (tip.1 - foot.1) * t0)
            let b = (foot.0 + 3 + (tip.0 - foot.0) * t1, foot.1 + (tip.1 - foot.1) * t1)
            jib.addPath(KaartPen.polygonLine([a, b]))
        }
        pen.line(jib, .accent, width: 1.6)
        pen.line(KaartPen.polygonLine([(108, -80), (106, -104), (tip.0, tip.1)]), .ink, width: 0.8)
        pen.line(KaartPen.polygonLine([(tip.0, tip.1), (tip.0, -124)]), .ink, width: 0.9)
        pen.crate(x: tip.0 - 9, base: -108, w: 18, h: 14)
        // Crates waiting on the quay, by the warehouse corner.
        pen.crate(x: 64, base: 0, w: 18, h: 15)
        pen.crate(x: 67, base: -15, w: 13, h: 11)

        pen.art.front = house
        pen.hangSign(x: 0, y: -22)
        pen.art.sign = "sailboat.fill"
        return pen.finish()
    }

    /// De veerpont: a white river ferry with a blue band and a wheelhouse, cyclists waiting on deck.
    private static func veerpont() -> KaartLandmark {
        var pen = KaartPen(wall: 0xEFEBE2, roof: 0x1F3A6B, door: 0x1F3A6B, accent: 0xF2711C)
        let L = 156.0, D = 36.0, dy = -D * KaartPen.slope, deck = -16.0
        // Hull: the long side faces you, both ends slope up to the loading ramps.
        pen.poly([(L, deck), (L + D, deck + dy), (L - 7 + D, dy), (L - 7, 0)], .darker(0xE9E4D8))
        pen.poly([(0, deck), (D, deck + dy), (L + D, deck + dy), (L, deck)], .color(0x9C9890))
        pen.poly([(0, deck), (L, deck), (L - 7, 0), (7, 0)], .color(0xE9E4D8))
        pen.poly([(2.5, -8), (L - 2.5, -8), (L - 4.2, -4), (4.2, -4)], .color(0x1F3A6B))
        var lanes = Path()
        for t in [0.33, 0.66] { lanes.addPath(KaartPen.polygonLine([(D * t + 8, deck + dy * t), (L + D * t - 8, deck + dy * t)])) }
        pen.line(lanes, .color(0xF2C53D), width: 1)

        // Wheelhouse on the left of the deck: its door is the place's door.
        let base = deck - 10
        let cabin = pen.box(x: 30, w: 36, h: 30, depth: 14, base: base, paint: .wall, top: .roof)
        pen.windows(in: CGRect(x: 44, y: base - 30, width: 22, height: 18), cols: 1, rows: 1, w: 14, h: 10, seed: 61)
        pen.door(cx: 38, w: 10, h: 19, base: base)
        pen.rect(28, base - 32, 40, 3, .roof)
        pen.rect(56, base - 46, 1.6, 14, .ink)
        pen.oval(54.5, base - 49, 4.5, 4.5, .accent)
        pen.line(Path(ellipseIn: CGRect(x: 51, y: base - 12, width: 8, height: 8)), .color(0xC8261B), width: 2.2)

        // Cyclists waiting with their bikes, and a scooter.
        pen.bike(x: 74, base: deck - 8, color: 0xC8261B)
        pen.person(x: 100, base: deck - 8, coat: 0xF2711C)
        pen.bike(x: 112, base: deck - 3, color: 0x2F5BD3)
        pen.person(x: 138, base: deck - 3, coat: 0x3F5A4A, skin: 0x8C5A3C)
        pen.person(x: 148, base: deck - 9, coat: 0xC9A15B, skin: 0xC99A74, h: 16)

        // Deck railing at the front, and some wake.
        var rail = Path()
        rail.addPath(KaartPen.polygonLine([(4, deck - 7), (L - 4, deck - 7)]))
        for x in stride(from: 4.0, through: L - 4, by: 13) { rail.addPath(KaartPen.polygonLine([(x, deck), (x, deck - 7)])) }
        pen.line(rail, .white, width: 1.2)
        var wake = Path()
        wake.addPath(KaartPen.polygonLine([(-14, 3), (3, 1)]))
        wake.addPath(KaartPen.polygonLine([(L - 3, 1), (L + 14, 3)]))
        wake.addPath(KaartPen.polygonLine([(24, 3.5), (64, 3.5)]))
        wake.addPath(KaartPen.polygonLine([(96, 3.5), (132, 3.5)]))
        pen.line(wake, .white, width: 1.4)

        pen.art.front = CGRect(x: 0, y: cabin.minY, width: L, height: -cabin.minY)
        pen.hangSign(x: 30, y: base - 24)
        pen.art.sign = "ferry.fill"
        return pen.finish()
    }

    // MARK: Country

    /// De molen: a tall green smock mill with a dark cap, a stage round its waist and white sails.
    private static func molen() -> KaartLandmark {
        var pen = KaartPen(wall: 0x3F5A4A, roof: 0x2C2C2A, door: 0x6B4A2E, accent: 0xF7F3EA)
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
            // The sail cloth is a surface, so it gets an outline and shows on a pale field too.
            pen.poly([p(14, 1.5), p(76, 1.5), p(76, 14), p(14, 14)], .color(0xF7F3EA))
            var lattice = Path()
            for l in stride(from: 20.0, through: 74, by: 9) { lattice.addPath(KaartPen.polygonLine([p(l, 1.5), p(l, 14)])) }
            lattice.addPath(KaartPen.polygonLine([p(14, 14), p(76, 14)]))
            pen.line(lattice, .ink, width: 0.8)
        }
        pen.oval(hub.x - 4, hub.y - 4, 8, 8, .ink)
        pen.windows(in: CGRect(x: 26, y: -120, width: 20, height: 50), cols: 1, rows: 2, w: 8, h: 11, seed: 44)
        pen.door(cx: 35, w: 14, h: 24, arched: true)
        pen.art.front = base
        pen.art.signAt = CGPoint(x: -14, y: -30)
        pen.art.sign = "wind"
        return pen.finish()
    }

    /// De boerderij: a stolp farm under a huge reed pyramid roof, a green barn door, a hay barrack and a cow.
    private static func boerderij() -> KaartLandmark {
        var pen = KaartPen(wall: 0x8C4A3A, roof: 0x9C8559, door: 0x2F4B3A, accent: 0xE2C66B)
        // The hay barrack behind, left: hay under a little pyramid roof on four poles.
        let hx = -48.0, hb = -6.0, hd = 14.0, hdy = -hd * KaartPen.slope
        pen.line(KaartPen.polygonLine([(hx + 30 + hd, hb + hdy), (hx + 30 + hd, hb + hdy - 34)]), .ink, width: 2)
        pen.poly([(hx + 31, hb), (hx + 31 + hd, hb + hdy), (hx + 31 + hd, hb + hdy - 22), (hx + 31, hb - 24)], .darker(0xE2C66B))
        pen.fill(Path(roundedRect: CGRect(x: hx - 1, y: hb - 26, width: 32, height: 26), cornerRadius: 7), .accent)
        let apex = (hx + 15 + hd / 2, hb - 64)
        pen.poly([(hx + 33, hb - 36), (hx + 33 + hd, hb - 36 + hdy), apex], .roofSide)
        pen.poly([(hx - 3, hb - 36), (hx + 33, hb - 36), apex], .roof)
        var poles = Path()
        for x in [hx, hx + 30] { poles.addPath(KaartPen.polygonLine([(x, hb), (x, hb - 36)])) }
        pen.line(poles, .ink, width: 2)

        // The farm: low brick walls, a pyramid roof reaching almost to the ground.
        let W = 96.0, H = 34.0, D = 56.0, dy = -D * KaartPen.slope
        let farm = pen.box(x: 0, w: W, h: H, depth: D)
        let top = (W / 2 + D / 2, -H + dy / 2 - 84)
        pen.poly([(W + 3, -H + 2), (W + D + 3, -H + dy + 2), top], .roofSide)
        pen.poly([(-4, -H + 2), (W + 3, -H + 2), top], .roof)
        pen.line(KaartPen.polygonLine([(-4, -H + 2), (W + 3, -H + 2)]), .color(0x6E5A38), width: 2.5)
        pen.box(x: top.0 - 4, w: 8, h: 10, depth: 5, base: top.1 + 22, paint: .color(0x7B3F2E), top: .color(0x5B3328))
        pen.door(cx: 64, w: 26, h: 30)
        var planks = Path()
        for x in stride(from: 56.0, through: 72, by: 5.5) { planks.addPath(KaartPen.polygonLine([(x, -29), (x, -1)])) }
        planks.addPath(KaartPen.polygonLine([(52, -2), (76, -28)]))
        pen.line(planks, .white, width: 1.3)
        pen.windows(in: CGRect(x: 4, y: -32, width: 40, height: 28), cols: 2, rows: 1, w: 11, h: 15, seed: 45)
        pen.windows(in: CGRect(x: 37, y: -H - 50, width: 24, height: 22), cols: 1, rows: 1, w: 10, h: 12, seed: 46)

        // A cow and a milk can by the door.
        pen.cow(x: 114, base: 2)
        pen.rect(84, -10, 7, 10, .color(0xB4B2A9))
        pen.rect(85.5, -12, 4, 2, .color(0xB4B2A9))

        pen.art.front = farm
        pen.hangSign(x: 48, y: -12)
        pen.art.sign = "leaf.fill"
        return pen.finish()
    }

    /// De volkstuin: an allotment with a green shed, a greenhouse, vegetable beds and tall sunflowers.
    private static func volkstuin() -> KaartLandmark {
        var pen = KaartPen(wall: 0x3F5A4A, roof: 0x5B3328, door: 0xC9A15B, accent: 0xF2C53D)
        // Greenhouse at the back, right.
        let gx = 86.0, gb = -14.0, gw = 50.0, gh = 26.0, gd = 22.0, gdy = -gd * KaartPen.slope
        let glass: KaartPaint = .color(0xCFE3DC)
        pen.poly([(gx + gw, gb), (gx + gw + gd, gb + gdy), (gx + gw + gd, gb + gdy - gh), (gx + gw, gb - gh)], glass.shaded)
        pen.poly([(gx + gw / 2, gb - gh - 16), (gx + gw / 2 + gd, gb + gdy - gh - 16), (gx + gw + gd, gb + gdy - gh), (gx + gw, gb - gh)], .color(0xB9D6CE))
        pen.rect(gx, gb - gh, gw, gh, glass)
        pen.poly([(gx, gb - gh), (gx + gw / 2, gb - gh - 16), (gx + gw, gb - gh)], .color(0xDCEBE6))
        var frame = Path()
        for x in stride(from: gx, through: gx + gw, by: gw / 4) { frame.addPath(KaartPen.polygonLine([(x, gb), (x, gb - gh)])) }
        frame.addPath(KaartPen.polygonLine([(gx, gb - gh), (gx + gw / 2, gb - gh - 16), (gx + gw, gb - gh)]))
        frame.addPath(KaartPen.polygonLine([(gx, gb - 10), (gx + gw, gb - 10)]))
        frame.addPath(KaartPen.polygonLine([(gx + gw / 2, gb - gh - 16), (gx + gw / 2 + gd, gb + gdy - gh - 16)]))
        pen.line(frame, .white, width: 1.4)
        for x in stride(from: gx + 5, through: gx + gw - 6, by: 9) {
            pen.oval(x, gb - 10, 6, 8, .plant)
            pen.oval(x + 2, gb - 7, 2.8, 2.8, .color(0xC8261B))
        }

        // Sunflowers between the shed and the greenhouse.
        for (x, h) in [(70.0, 66.0), (80, 80), (90, 60)] {
            pen.line(KaartPen.polygonLine([(x, -10), (x, -h)]), .plant, width: 1.8)
            pen.oval(x - 7, -h * 0.6, 7, 3.6, .plant)
            pen.oval(x - 6, -h - 6, 12, 12, .color(0xF2C53D))
            pen.oval(x - 2.8, -h - 2.8, 5.6, 5.6, .color(0x6B4A2E))
        }

        // The shed: a felt gable roof, the door and a small window, a rain barrel.
        let shed = pen.box(x: 0, w: 44, h: 34, depth: 22)
        pen.gableRoof(over: shed, rise: 18, depth: 22, overhang: 3, gable: .wall)
        pen.door(cx: 14, w: 13, h: 25)
        pen.windows(in: CGRect(x: 26, y: -30, width: 16, height: 18), cols: 1, rows: 1, w: 10, h: 9, seed: 52)
        pen.rect(47, -13, 10, 13, .color(0x3B5B7A))
        pen.oval(47, -15, 10, 4, .color(0x2F4B3A))

        // Vegetable beds in front: cabbages, carrots, lettuce.
        for (i, x) in [56.0, 98].enumerated() {
            let w = 34.0, d = 18.0, ddy = -d * KaartPen.slope
            pen.poly([(x, 0), (x + w, 0), (x + w + d, ddy), (x + d, ddy)], .color(0x6B4A2E))
            for r in 0..<3 {
                let t = (Double(r) + 0.5) / 3
                for c in 0..<4 {
                    let cx = x + d * t + 5 + Double(c) * 8, cy = ddy * t
                    let carrots = i == 0 && r == 1
                    pen.oval(cx - 2.8, cy - 3.8, 5.6, 4.6, carrots ? .color(0x9CBF6B) : .plant)
                    if carrots { pen.oval(cx - 1.4, cy - 1, 2.8, 2.4, .color(0xE07B28)) }
                }
            }
        }

        pen.art.front = shed
        pen.hangSign(x: 0, y: -14)
        pen.art.sign = "carrot.fill"
        return pen.finish()
    }

    /// De dijk: a brick pumping station with a tall chimney, a big arched window and an outlet, a white dike house beside it.
    private static func dijk() -> KaartLandmark {
        var pen = KaartPen(wall: 0x8C4A3A, roof: 0x45505A, door: 0x2F4B3A, accent: 0xC9A15B)
        // The chimney, behind the engine house.
        pen.box(x: 48, w: 12, h: 150, depth: 8, base: -26, paint: .color(0x7B3F2E))
        pen.rect(46, -180, 16, 5, .color(0x5B3328))

        // The little dike house, right: white walls and green shutters.
        let hx = 116.0
        let small = pen.box(x: hx, w: 40, h: 26, depth: 20, paint: .color(0xEFE6D6))
        pen.gableRoof(over: small, rise: 22, depth: 20, gable: .color(0xEFE6D6))
        pen.windows(in: CGRect(x: hx + 4, y: -24, width: 32, height: 18), cols: 2, rows: 1, w: 8, h: 10, seed: 59)
        var shutters = Path()
        for x in [hx + 5.6, hx + 15.4, hx + 23.6, hx + 33.4] { shutters.addRect(CGRect(x: x - 1.5, y: -20, width: 3, height: 10)) }
        pen.fill(shutters, .color(0x2F4B3A))

        // The pumping station: brick with stone bands and a hipped slate roof.
        let W = 84.0, H = 62.0
        let station = pen.box(x: 0, w: W, h: H, depth: 30)
        pen.ridgeRoof(over: station, rise: 30, depth: 30, overhang: 4)
        pen.rect(0, -H, W, 4, .trim)
        pen.rect(0, -12, W, 3, .trim)
        pen.door(cx: 20, w: 16, h: 28, arched: true)
        pen.windows(in: CGRect(x: 40, y: -H + 4, width: 40, height: 48), cols: 1, rows: 1, w: 22, h: 38, arched: true, seed: 60)
        pen.oval(15, -48, 10, 10, .accent)
        // The outlet, where the pumped water runs out into the ditch.
        pen.poly([(30, 0), (78, 0), (84, 9), (24, 9)], .color(0x8FB6CF))
        var outlet = Path()
        for x in [44.0, 64] { outlet.addPath(KaartPen.window(x: x - 7, y: -9, w: 14, h: 9, arched: true)) }
        pen.fill(outlet, .color(0x2E4A5C))
        pen.line(KaartPen.polygonLine([(34, 5), (50, 5)]), .white, width: 1)
        pen.line(KaartPen.polygonLine([(58, 6.5), (76, 6.5)]), .white, width: 1)

        pen.art.front = station
        pen.hangSign(x: 0, y: -22)
        pen.art.sign = "water.waves"
        return pen.finish()
    }

    // MARK: Days out

    /// Het strand: a beach pavilion on stilts with a terrace, flags on the roof, and a lifeguard chair on the sand.
    private static func strand() -> KaartLandmark {
        var pen = KaartPen(wall: 0xE3D6BC, roof: 0x1F3A6B, door: 0x1F3A6B, awning: 0x2F5BD3, accent: 0xF2C53D)
        let deckTop = -34.0
        // Stilts and braces.
        var stilts = Path()
        for x in [0.0, 30, 60, 90, 116] { stilts.addPath(KaartPen.polygonLine([(x, 0), (x, deckTop)])) }
        pen.line(stilts, .color(0x6B4A2E), width: 4)
        var braces = Path()
        for x in [0.0, 60] {
            braces.addPath(KaartPen.polygonLine([(x, -2), (x + 30, deckTop + 4)]))
            braces.addPath(KaartPen.polygonLine([(x + 30, -2), (x, deckTop + 4)]))
        }
        pen.line(braces, .color(0x6B4A2E), width: 1.4)
        // The deck.
        pen.box(x: -8, w: 132, h: 6, depth: 30, base: deckTop, paint: .color(0xA8865A), top: .color(0xC9A97A))

        // The pavilion: plank walls, big windows, a flat blue roof.
        let base = deckTop - 12
        let hall = pen.box(x: 6, w: 86, h: 38, depth: 20, base: base, paint: .wall, top: .roof)
        var planks = Path()
        for y in stride(from: base - 6, to: base - 36, by: -6) { planks.addPath(KaartPen.polygonLine([(6, y), (92, y)])) }
        pen.line(planks, .color(0xCBBE9F), width: 0.8)
        pen.rect(2, base - 42, 94, 5, .roof)
        pen.windows(in: CGRect(x: 6, y: base - 34, width: 36, height: 30), cols: 2, rows: 1, w: 12, h: 20, seed: 46)
        pen.windows(in: CGRect(x: 58, y: base - 34, width: 34, height: 30), cols: 2, rows: 1, w: 12, h: 20, seed: 47)
        pen.door(cx: 50, w: 13, h: 24, base: base)
        pen.awning(x: 58, y: base - 34, w: 34, drop: 8)
        pen.awning(x: 6, y: base - 34, w: 36, drop: 8)
        // Flags on the roof.
        for (i, x) in [14.0, 48, 84].enumerated() {
            let top = base - 42 - 26
            pen.rect(x - 0.7, top, 1.4, 26, .ink)
            pen.poly([(x + 0.7, top), (x + 15, top + 4), (x + 0.7, top + 8)], .color([0xC8261B, 0xF2C53D, 0x2F5BD3][i]))
        }
        // Terrace railing, the stairs down to the sand, a lifebuoy.
        var rail = Path()
        rail.addPath(KaartPen.polygonLine([(-6, deckTop - 10), (40, deckTop - 10)]))
        rail.addPath(KaartPen.polygonLine([(60, deckTop - 10), (122, deckTop - 10)]))
        for x in stride(from: -6.0, through: 122, by: 8) where x < 41 || x > 59 {
            rail.addPath(KaartPen.polygonLine([(x, deckTop), (x, deckTop - 10)]))
        }
        pen.line(rail, .white, width: 1.3)
        pen.line(KaartPen.polygonLine([(42, deckTop), (22, 0)]), .color(0x6B4A2E), width: 2)
        pen.line(KaartPen.polygonLine([(58, deckTop), (38, 0)]), .color(0x6B4A2E), width: 2)
        var steps = Path()
        for i in 1..<7 {
            let t = Double(i) / 7
            steps.addPath(KaartPen.polygonLine([(42 - 20 * t, deckTop * (1 - t)), (58 - 20 * t, deckTop * (1 - t))]))
        }
        pen.line(steps, .color(0x8C6A45), width: 2.2)
        pen.line(Path(ellipseIn: CGRect(x: 100, y: deckTop - 9, width: 9, height: 9)), .color(0xC8261B), width: 2.4)

        // The lifeguard chair on the sand.
        let lx = 152.0
        var chair = Path()
        chair.addPath(KaartPen.polygonLine([(lx - 8, 0), (lx - 2, -46)]))
        chair.addPath(KaartPen.polygonLine([(lx + 12, 0), (lx + 6, -46)]))
        for y in stride(from: -8.0, through: -40, by: -8) {
            let k = (y + 8) * 0.13
            chair.addPath(KaartPen.polygonLine([(lx - 7 - k, y), (lx + 11 + k, y)]))
        }
        pen.line(chair, .white, width: 2.2)
        pen.rect(lx - 6, -54, 16, 8, .color(0xC8261B))
        pen.rect(lx - 6, -64, 3, 10, .color(0xC8261B))
        pen.rect(lx + 13, -88, 1.4, 42, .ink)
        pen.rect(lx + 14.4, -88, 14, 5, .color(0xC8261B))
        pen.rect(lx + 14.4, -83, 14, 5, .color(0xF2C53D))

        pen.art.front = hall
        pen.hangSign(x: 0, y: -22)
        pen.art.sign = "beach.umbrella.fill"
        return pen.finish()
    }

    /// De camping: the green reception hut, an orange tent, a blue dome tent, a cream caravan and a campfire.
    private static func camping() -> KaartLandmark {
        var pen = KaartPen(wall: 0x3F5A4A, roof: 0x7A1E1E, door: 0xC9A15B, accent: 0xF2711C)
        // Caravan at the back, right.
        let cx = 112.0, cb = -22.0
        pen.poly([(cx + 56, cb - 2), (cx + 66, cb - 8), (cx + 66, cb - 32), (cx + 56, cb - 30)], .darker(0xF4EFE4))
        pen.fill(Path(roundedRect: CGRect(x: cx, y: cb - 34, width: 58, height: 32), cornerRadius: 11), .color(0xF4EFE4))
        pen.rect(cx + 2, cb - 15, 54, 3.5, .color(0x2F7FB5))
        pen.rect(cx + 10, cb - 28, 16, 9, .lit)
        pen.rect(cx + 34, cb - 28, 14, 9, .glass)
        pen.line(KaartPen.polygonLine([(cx - 8, cb - 2), (cx, cb - 7)]), .ink, width: 1.6)
        pen.oval(cx + 6, cb - 7, 11, 11, .ink)

        // Orange ridge tent in the middle, its flap open.
        let tx = 52.0, tb = -2.0, tw = 46.0, th = 40.0, td = 34.0, tdy = -td * KaartPen.slope
        pen.poly([(tx + tw / 2, tb - th), (tx + tw / 2 + td, tb - th + tdy), (tx + tw + td, tb + tdy), (tx + tw, tb)], .darker(0xF2711C))
        pen.poly([(tx, tb), (tx + tw / 2, tb - th), (tx + tw, tb)], .color(0xF2711C))
        pen.poly([(tx + 13, tb), (tx + tw / 2, tb - 24), (tx + tw - 13, tb)], .color(0x6B3010))
        pen.poly([(tx + tw / 2, tb - 24), (tx + tw - 13, tb), (tx + tw - 5, tb - 4)], .color(0xF7A35C))
        var guys = Path()
        guys.addPath(KaartPen.polygonLine([(tx - 8, tb + 2), (tx + tw / 2, tb - th)]))
        pen.line(guys, .ink, width: 0.7)

        // Blue dome tent, front right.
        var dome = Path()
        dome.move(to: CGPoint(x: 128, y: 0))
        dome.addQuadCurve(to: CGPoint(x: 174, y: 0), control: CGPoint(x: 151, y: -48))
        dome.closeSubpath()
        pen.fill(dome, .color(0x2F5BD3))
        var poles = Path()
        poles.move(to: CGPoint(x: 132, y: 0)); poles.addQuadCurve(to: CGPoint(x: 162, y: -20), control: CGPoint(x: 140, y: -27))
        pen.line(poles, .white, width: 1)
        pen.oval(143, -14, 16, 14, .color(0x1F3A6B))

        // Reception hut, left, with its flag.
        let hut = pen.box(x: 0, w: 44, h: 36, depth: 20)
        pen.gableRoof(over: hut, rise: 24, depth: 20, overhang: 3, gable: .wall)
        pen.door(cx: 12, w: 13, h: 24)
        pen.windows(in: CGRect(x: 23, y: -32, width: 20, height: 22), cols: 1, rows: 1, w: 12, h: 12, seed: 47)
        pen.flag(x: 22, y: -36 - 24, height: 22)

        // Campfire between the tents, with a log to sit on.
        let fx = 113.0, fy = 4.0
        pen.line(KaartPen.polygonLine([(fx - 9, fy + 2), (fx + 9, fy - 4)]), .color(0x6B4A2E), width: 3.2)
        pen.line(KaartPen.polygonLine([(fx - 9, fy - 4), (fx + 9, fy + 2)]), .color(0x6B4A2E), width: 3.2)
        var flame = Path()
        flame.move(to: CGPoint(x: fx - 7, y: fy - 2)); flame.addQuadCurve(to: CGPoint(x: fx, y: fy - 22), control: CGPoint(x: fx - 9, y: fy - 12))
        flame.addQuadCurve(to: CGPoint(x: fx + 7, y: fy - 2), control: CGPoint(x: fx + 9, y: fy - 12)); flame.closeSubpath()
        pen.fill(flame, .accent)
        pen.oval(fx - 3, fy - 11, 6, 8, .color(0xF6D27A))
        pen.line(KaartPen.polygonLine([(fx - 30, fy + 1), (fx - 16, fy + 1)]), .color(0x8C6A45), width: 4.5)

        pen.art.front = hut
        pen.hangSign(x: 0, y: -16)
        pen.art.sign = "tent.fill"
        return pen.finish()
    }

    /// Het vliegveld: a white terminal with a glass front, a control tower, a little plane and a windsock.
    private static func vliegveld() -> KaartLandmark {
        var pen = KaartPen(wall: 0xE3E1DA, roof: 0x5E6B73, door: 0x1F3A6B, awning: 0x1F3A6B, accent: 0xF2711C)
        // Control tower, left and a little behind.
        let tb = -6.0
        pen.box(x: -24, w: 18, h: 104, depth: 12, base: tb, paint: .color(0xEFEBE2), top: .roof)
        let cab = tb - 104
        pen.poly([(-34, cab), (4, cab), (8, cab - 20), (-38, cab - 20)], .color(0x3E5A5C))
        pen.poly([(4, cab), (14, cab - 6), (18, cab - 26), (8, cab - 20)], .darker(0x3E5A5C))
        pen.windows(in: CGRect(x: -36, y: cab - 19, width: 42, height: 17), cols: 4, rows: 1, w: 7, h: 11, seed: 48)
        pen.poly([(-40, cab - 20), (8, cab - 20), (18, cab - 26), (-30, cab - 26)], .roof)
        pen.rect(-16, cab - 46, 1.6, 20, .ink)
        pen.oval(-17.6, cab - 50, 4.8, 4.8, .color(0xC8261B))

        // The terminal: a long low hall with a glass front and a blue band.
        let W = 104.0, H = 40.0
        let hall = pen.box(x: 0, w: W, h: H, depth: 34, paint: .wall, top: .roof)
        pen.rect(0, -H, W, 7, .color(0x1F3A6B))
        pen.windows(in: CGRect(x: 2, y: -32, width: 40, height: 30), cols: 3, rows: 1, w: 10, h: 22, seed: 49)
        pen.windows(in: CGRect(x: 62, y: -32, width: 40, height: 30), cols: 3, rows: 1, w: 10, h: 22, seed: 50)
        pen.door(cx: 52, w: 16, h: 24)
        // Windsock on the roof: an orange-and-white cone blowing right.
        let wx = W + 14, wy = -H - 19 - 22
        pen.rect(wx - 0.8, wy, 1.6, 22, .ink)
        for i in 0..<4 {
            let a = Double(i) / 4, b = Double(i + 1) / 4
            let ha = 3.4 - 1.6 * a, hb = 3.4 - 1.6 * b, sag = 2.0
            pen.poly([(wx + 1 + 22 * a, wy + 3.4 + sag * a - ha), (wx + 1 + 22 * b, wy + 3.4 + sag * b - hb),
                      (wx + 1 + 22 * b, wy + 3.4 + sag * b + hb), (wx + 1 + 22 * a, wy + 3.4 + sag * a + ha)],
                     .color(i % 2 == 0 ? 0xF2711C : 0xF7F3EA))
        }

        // A little propeller plane on the apron.
        pen.plane(x: 94, base: 4)

        pen.art.front = hall
        pen.hangSign(x: 0, y: -22)
        pen.art.sign = "airplane"
        return pen.finish()
    }

    /// De uitkijktoren: a tall timber lookout tower with criss-cross braces, zigzag stairs, a roofed platform and a flag.
    private static func uitkijktoren() -> KaartLandmark {
        var pen = KaartPen(wall: 0x8C6A45, roof: 0x5B3328, door: 0x5B3328, accent: 0xC8261B)
        let H = 168.0, foot = 64.0, top = 30.0, d = 22.0, ddy = -d * KaartPen.slope
        let lx = 0.0, rx = foot, tlx = (foot - top) / 2, trx = tlx + top
        func left(_ y: Double) -> Double { lx + (tlx - lx) * (-y / H) }
        func right(_ y: Double) -> Double { rx + (trx - rx) * (-y / H) }
        let wood = KaartPaint.color(0x8C6A45)
        // Back legs, then the stairs inside, then the front legs and braces.
        pen.line(KaartPen.polygonLine([(rx + d, ddy), (trx + d, -H + ddy)]), .darker(0x8C6A45), width: 5)
        pen.line(KaartPen.polygonLine([(lx + d, ddy), (tlx + d, -H + ddy)]), .darker(0x8C6A45), width: 4)
        var stairs = Path(), treads = Path()
        let flights = 6
        for i in 0..<flights {
            let y0 = -Double(i) * H / Double(flights), y1 = y0 - H / Double(flights)
            let toRight = i % 2 == 0
            let a = (toRight ? left(y0) + 7 : right(y0) - 7 + d * 0.4, y0 + ddy * 0.5)
            let b = (toRight ? right(y1) - 7 + d * 0.4 : left(y1) + 7, y1 + ddy * 0.5)
            stairs.addPath(KaartPen.polygonLine([a, b]))
            for s in 1..<5 {
                let t = Double(s) / 5
                let p = (a.0 + (b.0 - a.0) * t, a.1 + (b.1 - a.1) * t)
                treads.addPath(KaartPen.polygonLine([(p.0 - 2.5, p.1), (p.0 + 2.5, p.1)]))
            }
        }
        pen.line(stairs, .color(0x5B3328), width: 2.4)
        pen.line(treads, .color(0x5B3328), width: 1.2)
        var braces = Path()
        let bays = 4
        for i in 0..<bays {
            let y0 = -Double(i) * H / Double(bays) - 4, y1 = y0 - H / Double(bays) + 8
            braces.addPath(KaartPen.polygonLine([(left(y0), y0), (right(y1), y1)]))
            braces.addPath(KaartPen.polygonLine([(right(y0), y0), (left(y1), y1)]))
            braces.addPath(KaartPen.polygonLine([(left(y1), y1), (right(y1), y1)]))
            braces.addPath(KaartPen.polygonLine([(right(y1), y1), (right(y1) + d, y1 + ddy)]))
        }
        pen.line(braces, wood, width: 2.2)
        pen.line(KaartPen.polygonLine([(lx, 0), (tlx, -H)]), wood, width: 6)
        pen.line(KaartPen.polygonLine([(rx, 0), (trx, -H)]), wood, width: 6)

        // The platform: a floor, a railing, a little pyramid roof and a flag.
        let px = tlx - 10, pw = top + 20
        let platform = pen.box(x: px, w: pw, h: 5, depth: d, base: -H, paint: wood, top: .color(0xA8865A))
        pen.person(x: px + 16, base: -H - 5 + ddy * 0.5, coat: 0xC8261B, h: 15)
        var rail = Path()
        rail.addPath(KaartPen.polygonLine([(px, -H - 19), (px + pw, -H - 19), (px + pw + d, -H - 19 + ddy)]))
        for x in stride(from: px, through: px + pw, by: 6) { rail.addPath(KaartPen.polygonLine([(x, -H - 5), (x, -H - 19)])) }
        rail.addPath(KaartPen.polygonLine([(px + pw + d, -H - 5 + ddy), (px + pw + d, -H - 19 + ddy)]))
        pen.line(rail, .ink, width: 1.4)
        let roofBase = -H - 36
        var posts = Path()
        for x in [px + 2, px + pw - 2] { posts.addPath(KaartPen.polygonLine([(x, -H - 5), (x, roofBase)])) }
        posts.addPath(KaartPen.polygonLine([(px + pw + d - 2, -H - 5 + ddy), (px + pw + d - 2, roofBase + ddy)]))
        pen.line(posts, .ink, width: 2)
        let peak = (px + pw / 2 + d / 2, roofBase - 32)
        pen.poly([(px + pw + 6, roofBase), peak, (px + pw + d + 5, roofBase + ddy + 1)], .roofSide)
        pen.poly([(px - 6, roofBase), peak, (px + pw + 6, roofBase)], .roof)
        pen.flag(x: peak.0, y: peak.1, height: 22)

        // The gate to the stairs: the place's door, in a little timber frame.
        pen.rect(foot / 2 - 13, -32, 26, 32, .color(0x6B4A2E))
        pen.door(cx: foot / 2, w: 16, h: 26)

        pen.art.front = platform.union(CGRect(x: lx, y: -H, width: foot, height: H))
        pen.hangSign(x: foot / 2 - 13, y: -18)
        pen.art.sign = "binoculars.fill"
        return pen.finish()
    }

    // MARK: In town

    /// Het stadhuisplein: a paved square with a fountain, a bandstand, benches, a lamp post and flags.
    private static func stadhuisplein() -> KaartLandmark {
        var pen = KaartPen(wall: 0x8C4A3A, roof: 0x3F5A4A, door: 0x2F4B3A, accent: 0x7FB3D5)
        let W = 140.0, D = 34.0, ddy = -D * KaartPen.slope
        // The paving.
        pen.poly([(0, 0), (W, 0), (W + D, ddy), (D, ddy)], .color(0xD5BC9C))
        var joints = Path()
        for i in 1..<4 { let t = Double(i) / 4; joints.addPath(KaartPen.polygonLine([(D * t, ddy * t), (W + D * t, ddy * t)])) }
        for x in stride(from: 14.0, to: W, by: 14) { joints.addPath(KaartPen.polygonLine([(x, 0), (x + D, ddy)])) }
        pen.line(joints, .color(0xC1A381), width: 0.8)
        pen.poly([(0, 0), (W, 0), (W, 3), (0, 3)], .color(0xAE906E))

        // Flags at the back right.
        for (i, x) in [114.0, 136, 158].enumerated() {
            pen.flag(x: x, y: ddy + 2 + Double(i) * 2, height: 52, colors: i == 1 ? [0xAE1C28, 0xFFFFFF, 0x21468B] : [0xC8261B, 0x1E1E1C, 0xC8261B])
        }

        // The bandstand, left and back: brick base with a door, slim columns, a green copper roof.
        let bx = 8.0, bw = 48.0, bb = -14.0
        let stand = pen.box(x: bx, w: bw, h: 14, depth: 16, base: bb, paint: .wall)
        pen.door(cx: bx + 14, w: 10, h: 12, base: bb)
        pen.columns(from: bx + 3, to: bx + bw - 3, count: 5, base: bb - 14, h: 30, paint: .trim)
        let roofY = bb - 14 - 37
        pen.poly([(bx + bw + 6, roofY), (bx + bw / 2 + 8, roofY - 30), (bx + bw + 20, roofY - 8)], .roofSide)
        pen.poly([(bx - 6, roofY), (bx + bw / 2 + 8, roofY - 30), (bx + bw + 6, roofY)], .roof)
        pen.rect(bx + bw / 2 + 7, roofY - 40, 2, 10, .ink)
        pen.oval(bx + bw / 2 + 5.5, roofY - 42, 5, 5, .color(0xC9A15B))

        // The fountain in the middle: a stone basin, a column, a bowl and splashing jets.
        let fx = 100.0, fy = ddy / 2 + 2
        pen.oval(fx - 24, fy - 8, 48, 16, .color(0xB9B1A2))
        pen.oval(fx - 20, fy - 6.5, 40, 11, .accent)
        pen.rect(fx - 3, fy - 30, 6, 28, .color(0xB9B1A2))
        pen.oval(fx - 12, fy - 34, 24, 8, .color(0xB9B1A2))
        var jets = Path()
        for s in [-1.0, 1.0] {
            jets.move(to: CGPoint(x: fx + s * 2, y: fy - 36))
            jets.addQuadCurve(to: CGPoint(x: fx + s * 18, y: fy - 4), control: CGPoint(x: fx + s * 14, y: fy - 52))
        }
        jets.move(to: CGPoint(x: fx, y: fy - 34)); jets.addLine(to: CGPoint(x: fx, y: fy - 50))
        pen.line(jets, .white, width: 1.6)
        pen.oval(fx - 2.5, fy - 54, 5, 5, .white)

        // Benches, the lamp post and pigeons at the front.
        pen.bench(x: 22, base: -2)
        pen.bench(x: 116, base: -2)
        pen.lamp(x: 4, base: 0, h: 58)
        for (x, y) in [(56.0, -6.0), (63, -4), (146, -10)] { pen.pigeon(x: x, y: y) }

        pen.art.front = stand
        pen.hangSign(x: 4, y: -36)
        pen.art.sign = "building.columns.fill"
        return pen.finish()
    }

    /// De rotonde: a brick roundabout round a raised flower island with a tree, blue roundabout signs and give-way teeth.
    private static func rotonde() -> KaartLandmark {
        // The ring road uses the roof paint so it snows over like the streets.
        var pen = KaartPen(wall: 0xC4A784, roof: 0xE6D2B4, door: 0x2F5BD3, accent: 0x2F5BD3)
        let cx = 70.0, cy = -24.0
        pen.oval(cx - 70, cy - 26, 140, 52, .color(0xC4A784))
        pen.oval(cx - 66, cy - 23.5, 132, 47, .roof)
        pen.line(Path(ellipseIn: CGRect(x: cx - 52, y: cy - 18, width: 104, height: 36)), .white, width: 0.9)
        // Give-way teeth where the street comes in at the front.
        var teeth = Path()
        for i in 0..<4 {
            let x = cx - 13 + Double(i) * 7
            teeth.addPath(KaartPen.polygon([(x, 0.5), (x + 5, 0.5), (x + 2.5, -3.5)]))
        }
        pen.fill(teeth, .white)

        // The island: a raised kerb, grass, a ring of flowers and a tree.
        let island = CGRect(x: cx - 36, y: cy - 16, width: 72, height: 30)
        pen.oval(cx - 36, cy - 12, 72, 26, .color(0xB09474))
        pen.oval(cx - 36, cy - 16, 72, 26, .color(0xD6C3A4))
        pen.oval(cx - 33, cy - 14.5, 66, 22, .color(0x7FA65A))
        var blooms = Path(), leaves = Path()
        for i in 0..<16 {
            let a = Double(i) / 16 * 2 * .pi
            let x = cx + cos(a) * 25, y = cy - 3.5 + sin(a) * 7
            leaves.addEllipse(in: CGRect(x: x - 3, y: y - 3, width: 6, height: 5))
            blooms.addEllipse(in: CGRect(x: x - 1.8, y: y - 3.5, width: 3.6, height: 3.6))
        }
        pen.fill(leaves, .plant)
        pen.fill(blooms, .bloom)
        pen.rect(cx - 1.5, cy - 30, 3, 26, .color(0x6B4A2E))
        pen.oval(cx - 17, cy - 60, 34, 34, .plant)
        pen.oval(cx - 9, cy - 66, 22, 20, .color(0x8DBE5A))

        // Blue roundabout signs on poles; the one at the front is the place's door.
        pen.roundaboutSign(x: cx + 40, base: 6, door: true)
        pen.roundaboutSign(x: cx - 56, base: -10, door: false)

        pen.art.front = island
        pen.art.sign = ""
        return pen.finish()
    }
}

// MARK: - Props

nonisolated private extension KaartPen {
    /// Hangs the shop sign's bracket on a wall at (x, y): the board hangs to the left of and below it.
    mutating func hangSign(x: Double, y: Double) {
        art.signAt = CGPoint(x: x - 49, y: y - 20.5)
    }

    /// Cuts each surface down to what the surfaces drawn after it leave visible, so the painter's
    /// outline only follows edges you can see (no chimney or barge edges showing through a wall).
    func finish() -> KaartLandmark {
        var art = art
        var cover = Path()
        for i in art.layers.indices.reversed() {
            let layer = art.layers[i]
            guard layer.line == nil, layer.paint.isSurface else { continue }
            if !cover.isEmpty { art.layers[i].path = layer.path.subtracting(cover) }
            cover = cover.isEmpty ? layer.path : cover.union(layer.path)
        }
        return art
    }

    /// A small person, feet at (x, base): legs, coat and head, drawn as strokes so they get no outline.
    mutating func person(x: Double, base: Double = 0, coat: UInt32, skin: UInt32 = 0xE8C4A0, h: Double = 20) {
        let s = h / 20
        var legs = Path()
        legs.addPath(KaartPen.polygonLine([(x - 1.5 * s, base), (x - 1.2 * s, base - 7 * s)]))
        legs.addPath(KaartPen.polygonLine([(x + 1.5 * s, base), (x + 1.2 * s, base - 7 * s)]))
        line(legs, .ink, width: 1.8 * s)
        line(KaartPen.polygonLine([(x, base - 8.5 * s), (x, base - 12.5 * s)]), .color(coat), width: 6.4 * s)
        let r = 2.9 * s
        line(Path(ellipseIn: CGRect(x: x - r / 2, y: base - 17.2 * s - r / 2, width: r, height: r)), .color(skin), width: r)
    }

    /// A Dutch bike side on, back wheel at x.
    mutating func bike(x: Double, base: Double = 0, color: UInt32) {
        let move = CGAffineTransform(translationX: x - 0.8, y: base - 14.2)
        line(KaartArt.bikeWheels.applying(move), .ink, width: 1.4)
        line(KaartArt.bikeFrame.applying(move), .color(color), width: 1.8)
    }

    /// A wooden crate in 3/4 view.
    mutating func crate(x: Double, base: Double, w: Double, h: Double) {
        let wood: KaartPaint = .color(0xB0834F)
        let d = w * 0.4, ddy = -d * KaartPen.slope
        poly([(x + w, base), (x + w + d, base + ddy), (x + w + d, base + ddy - h), (x + w, base - h)], wood.shaded)
        poly([(x, base - h), (x + d, base - h + ddy), (x + w + d, base - h + ddy), (x + w, base - h)], .color(0xC99A62))
        rect(x, base - h, w, h, wood)
        var slats = Path(CGRect(x: x + 1.5, y: base - h + 1.5, width: w - 3, height: h - 3))
        slats.addPath(KaartPen.polygonLine([(x + 1.5, base - 1.5), (x + w - 1.5, base - h + 1.5)]))
        line(slats, .color(0x7A5530), width: 0.9)
    }

    /// A black-and-white cow standing side on, facing left, feet at (x, base).
    mutating func cow(x: Double, base: Double) {
        var legs = Path()
        for lx in [x + 3, x + 7, x + 20, x + 24] { legs.addPath(KaartPen.polygonLine([(lx, base), (lx, base - 9)])) }
        line(legs, .ink, width: 2.2)
        fill(Path(roundedRect: CGRect(x: x, y: base - 22, width: 28, height: 14), cornerRadius: 6), .color(0xF7F5EF))
        oval(x + 9, base - 21, 10, 8, .ink)
        oval(x + 20, base - 18, 6, 6, .ink)
        fill(Path(roundedRect: CGRect(x: x - 9, y: base - 25, width: 11, height: 10), cornerRadius: 3), .ink)
        oval(x - 10, base - 19, 6, 5, .color(0xE8A9A0))
        line(KaartPen.polygonLine([(x - 6, base - 25), (x - 8, base - 28)]), .white, width: 1.2)
        line(KaartPen.polygonLine([(x + 28, base - 20), (x + 31, base - 10)]), .ink, width: 1)
    }

    /// A small high-wing propeller plane side on, nose left, wheels on `base`.
    mutating func plane(x: Double, base: Double) {
        let body: KaartPaint = .color(0xF4F2EC)
        line(KaartPen.polygonLine([(x + 14, base - 4), (x + 16, base - 10)]), .ink, width: 1.4)
        line(KaartPen.polygonLine([(x + 30, base - 4), (x + 28, base - 10)]), .ink, width: 1.4)
        oval(x + 11, base - 6, 6, 6, .ink)
        oval(x + 27, base - 6, 6, 6, .ink)
        poly([(x + 52, base - 15), (x + 64, base - 34), (x + 70, base - 34), (x + 66, base - 15)], body)
        var hull = Path()
        hull.move(to: CGPoint(x: x + 4, y: base - 16))
        hull.addQuadCurve(to: CGPoint(x: x + 14, y: base - 26), control: CGPoint(x: x + 4, y: base - 25))
        hull.addLine(to: CGPoint(x: x + 46, y: base - 24))
        hull.addLine(to: CGPoint(x: x + 68, y: base - 18))
        hull.addLine(to: CGPoint(x: x + 66, y: base - 14))
        hull.addLine(to: CGPoint(x: x + 14, y: base - 9))
        hull.addQuadCurve(to: CGPoint(x: x + 4, y: base - 16), control: CGPoint(x: x + 5, y: base - 10))
        hull.closeSubpath()
        fill(hull, body)
        poly([(x + 6, base - 15), (x + 66, base - 16.5), (x + 66.5, base - 14.5), (x + 8, base - 12.5)], .color(0xC8261B))
        rect(x + 15, base - 23, 14, 6, .glass)
        poly([(x + 12, base - 27), (x + 46, base - 27), (x + 50, base - 30), (x + 16, base - 30)], .color(0xC8261B))
        rect(x + 2, base - 18, 3, 5, .ink)
        fill(Path(roundedRect: CGRect(x: x, y: base - 28, width: 3, height: 24), cornerRadius: 1.5), .color(0x5F5E5A))
        poly([(x + 58, base - 22), (x + 72, base - 22), (x + 70, base - 19), (x + 58, base - 19)], .color(0xC8261B))
    }

    /// A park bench side on, feet at (x, base).
    mutating func bench(x: Double, base: Double) {
        var legs = Path()
        for lx in [x + 2, x + 20] { legs.addPath(KaartPen.polygonLine([(lx, base), (lx, base - 7)])) }
        line(legs, .ink, width: 1.6)
        rect(x - 1, base - 8, 24, 2.5, .color(0x8C6A45))
        rect(x - 1, base - 15, 24, 2.2, .color(0x8C6A45))
        rect(x - 1, base - 11.5, 24, 2.2, .color(0x8C6A45))
    }

    /// A black street lamp with a lantern that glows at night.
    mutating func lamp(x: Double, base: Double, h: Double) {
        rect(x - 2.5, base - 4, 5, 4, .ink)
        rect(x - 1, base - h, 2, h, .ink)
        poly([(x - 4, base - h - 2), (x + 4, base - h - 2), (x + 3, base - h - 12), (x - 3, base - h - 12)], .lit)
        poly([(x - 5, base - h - 12), (x + 5, base - h - 12), (x, base - h - 17)], .ink)
        rect(x - 5, base - h - 2, 10, 2, .ink)
    }

    /// A grey pigeon.
    mutating func pigeon(x: Double, y: Double) {
        oval(x - 3, y - 3, 6, 4, .color(0x8E8B83))
        oval(x + 1.5, y - 5, 3, 3, .color(0x6E6B64))
        line(KaartPen.polygonLine([(x + 4.5, y - 3.5), (x + 5.8, y - 3)]), .color(0xF2711C), width: 0.8)
    }

    /// A blue round roundabout sign with white arrows on a grey pole. `door`: the ribbon hangs on its plate.
    mutating func roundaboutSign(x: Double, base: Double, door: Bool) {
        rect(x - 1, base - 34, 2, 34, .color(0x8E8B83))
        let plate = CGRect(x: x - 8, y: base - 50, width: 16, height: 16)
        if door { art.doorRect = plate }
        fill(Path(ellipseIn: plate.insetBy(dx: -1.2, dy: -1.2)), .white)
        fill(Path(ellipseIn: plate), .door)
        var arrows = Path()
        arrows.addArc(center: CGPoint(x: plate.midX, y: plate.midY), radius: 4.5, startAngle: .degrees(0), endAngle: .degrees(300), clockwise: false)
        line(arrows, .white, width: 1.6)
        fill(KaartPen.polygon([(plate.midX + 4.5 - 2.4, plate.midY - 0.5), (plate.midX + 4.5 + 2.4, plate.midY - 0.5), (plate.midX + 4.5, plate.midY + 2.6)]), .white)
    }
}
