import SwiftUI

/// The big buildings: church, museum, theatre, school, hospital, hotel and friends.
nonisolated extension KaartLandmarks {
    static func big(_ n: Int) -> KaartLandmark? {
        switch n {
        case 17: ziekenhuis()
        case 18: sportschool()
        case 22: museum()
        case 23: bioscoop()
        case 25: kerk()
        case 26: theater()
        case 29: universiteit()
        case 32: rechtbank()
        case 35: zwembad()
        case 36: kinderopvang()
        case 49: hotel()
        default: nil
        }
    }

    /// Het ziekenhuis: a tall white block with blue bands, a red cross on the roof and a yellow ambulance at the emergency doors.
    private static func ziekenhuis() -> KaartLandmark {
        var pen = KaartPen(wall: 0xF1EEE8, roof: 0x7E8A93, door: 0x8FB8CC, awning: 0xC8261B, accent: 0xF2C230)
        let main = pen.box(x: 0, w: 96, h: 124, depth: 26)
        pen.band(main, y: -36, h: 3, depth: 26, paint: .color(0x2E6E9E))
        pen.band(main, y: -124, h: 4, depth: 26, paint: .color(0x2E6E9E))
        pen.windows(in: CGRect(x: 2, y: -120, width: 92, height: 84), cols: 5, rows: 3, w: 11, h: 15, seed: 17)
        pen.sideWindows(x: 96, depth: 26, tops: [-110.25, -85.5, -60.75], h: 15, cols: 2, w: 8, seed: 17)
        // Emergency entrance: wide glass doors under a red canopy on two posts.
        pen.door(cx: 22, w: 24, h: 24)
        pen.rect(3, -26, 2, 26, .ink)
        pen.rect(39, -26, 2, 26, .ink)
        pen.rect(1, -31, 42, 5, .awning)
        pen.windows(in: CGRect(x: 46, y: -32, width: 48, height: 26), cols: 3, rows: 1, w: 10, h: 14, seed: 4)
        pen.ambulance(x: 50)
        // The red cross on a white board on the roof.
        pen.rect(52, -136, 2, 10, .ink)
        pen.rect(68, -136, 2, 10, .ink)
        pen.rect(46, -166, 30, 30, .color(0xFFFFFF))
        pen.rect(57.5, -162, 7, 22, .color(0xD7262E))
        pen.rect(50, -154.5, 22, 7, .color(0xD7262E))
        pen.art.signAt = CGPoint(x: -44, y: -100)
        pen.art.sign = "cross.fill"
        return pen.finished()
    }

    /// De sportschool: a dark modern box with a big glass front, an orange fascia and a giant dumbbell on the roof.
    private static func sportschool() -> KaartLandmark {
        var pen = KaartPen(wall: 0x2C2C2A, roof: 0x5E6B73, door: 0xF2711C, awning: 0xF2711C, accent: 0x8E9AA3)
        let hall = pen.box(x: 0, w: 90, h: 72, depth: 28)
        pen.band(hall, y: -72, h: 8, depth: 28, paint: .color(0xF2711C))
        pen.windows(in: CGRect(x: 2, y: -64, width: 86, height: 32), cols: 4, rows: 1, w: 18, h: 26, seed: 18)
        pen.windows(in: CGRect(x: 26, y: -32, width: 64, height: 30), cols: 3, rows: 1, w: 16, h: 24, seed: 5)
        pen.door(cx: 14, w: 16, h: 26)
        // The dumbbell sign on two posts.
        pen.rect(38, -90, 2.4, 14, .ink)
        pen.rect(60, -90, 2.4, 14, .ink)
        pen.dumbbell(cx: 50, cy: -96, w: 64)
        pen.art.signAt = CGPoint(x: -44, y: -66)
        pen.art.sign = "dumbbell.fill"
        return pen.finished()
    }

    /// Het museum: a grand red-brick front with two spired towers, three arched gates, stone bands and blue banners.
    private static func museum() -> KaartLandmark {
        var pen = KaartPen(wall: 0x9A5238, roof: 0x45505A, door: 0x2E2117, awning: 0x1F3A6B, accent: 0xC9A15B)
        let d = 22.0
        let left = pen.box(x: 0, w: 24, h: 112, depth: d)
        let mid = pen.box(x: 24, w: 60, h: 80, depth: d)
        pen.gableRoof(over: mid, rise: 40, depth: d, overhang: 0)
        let right = pen.box(x: 84, w: 24, h: 112, depth: d)
        pen.art.front = CGRect(x: 0, y: -112, width: 108, height: 112)
        // Stone bands and cornices.
        pen.rect(0, -37, 108, 3, .trim)
        for tower in [left, right] {
            pen.rect(tower.minX, -80, tower.width, 3, .trim)
            pen.rect(tower.minX - 1, tower.minY, tower.width + 2, 4, .trim)
            pen.windows(in: CGRect(x: tower.minX + 2, y: -110, width: 20, height: 28), cols: 1, rows: 1, w: 9, h: 20, arched: true, seed: Int(tower.minX) + 3)
            pen.windows(in: CGRect(x: tower.minX + 2, y: -77, width: 20, height: 38), cols: 1, rows: 1, w: 9, h: 26, arched: true, seed: Int(tower.minX) + 4)
            pen.windows(in: CGRect(x: tower.minX + 2, y: -34, width: 20, height: 34), cols: 1, rows: 1, w: 9, h: 16, arched: true, seed: 9)
            let cx = tower.minX + 12 + 7
            pen.spire(cx: cx, base: tower.minY - 6, w: 30, h: 44)
            pen.rect(cx - 0.8, tower.minY - 59, 1.6, 10, .accent)
            pen.oval(cx - 2.5, tower.minY - 62, 5, 5, .accent)
        }
        // Three arched gates, the middle one is the door.
        pen.door(cx: 54, w: 16, h: 30, arched: true)
        pen.door(cx: 35, w: 13, h: 26, arched: true)
        pen.door(cx: 73, w: 13, h: 26, arched: true)
        // One tall arched window between two banners, a rose window in the gable.
        pen.windows(in: CGRect(x: 44, y: -78, width: 20, height: 38), cols: 1, rows: 1, w: 14, h: 30, arched: true, seed: 22)
        for x in [29.0, 69] { pen.banner(x: x, y: -76, w: 10, h: 32) }
        pen.oval(47, -110, 14, 14, .trim)
        pen.oval(49.5, -107.5, 9, 9, .lit)
        pen.art.signAt = CGPoint(x: -46, y: -86)
        pen.art.sign = "photo.artframe"
        return pen.finished()
    }

    /// De bioscoop: a dark green art-deco front with a stepped crown, a tall red sign with bulbs and a lit marquee.
    private static func bioscoop() -> KaartLandmark {
        var pen = KaartPen(wall: 0x24533F, roof: 0x2C2C2A, door: 0x7A1E1E, awning: 0x1E1E1C, accent: 0xF6D27A)
        pen.box(x: 0, w: 96, h: 86, depth: 28)
        let crown: [(Double, Double)] = [(12, -86), (12, -96), (26, -96), (26, -106), (70, -106), (70, -96), (84, -96), (84, -86)]
        pen.poly(crown, .wall)
        pen.line(KaartPen.polygonLine(crown), .accent, width: 1.4)
        // Gold pilasters and tall windows on the upper floor.
        for x in [4.0, 36, 58, 90] { pen.rect(x, -84, 2, 32, .accent) }
        pen.windows(in: CGRect(x: 6, y: -84, width: 30, height: 32), cols: 2, rows: 1, w: 8, h: 24, arched: true, seed: 23)
        pen.windows(in: CGRect(x: 60, y: -84, width: 30, height: 32), cols: 2, rows: 1, w: 8, h: 24, arched: true, seed: 32)
        // Entrance with poster cases.
        pen.door(cx: 48, w: 24, h: 28)
        pen.poster(x: 9, color: 0xC8261B)
        pen.poster(x: 71, color: 0x1F6FB2)
        // The marquee: a dark band with two rows of bulbs.
        pen.rect(2, -50, 92, 12, .awning)
        pen.bulbs(from: 6, to: 90, y: -46.5)
        pen.bulbs(from: 8, to: 88, y: -41.5)
        // The vertical sign above it.
        let blade = CGRect(x: 40, y: -152, width: 16, height: 98)
        pen.fill(Path(blade), .color(0xC8261B))
        pen.line(Path(blade.insetBy(dx: 2.2, dy: 2.2)), .accent, width: 1.2)
        for y in stride(from: blade.minY + 6, through: blade.maxY - 6, by: 7) {
            pen.oval(blade.minX + 4.6 - 1.5, y, 3, 3, .accent)
            pen.oval(blade.maxX - 4.6 - 1.5, y, 3, 3, .accent)
        }
        pen.poly([(42, -152), (48, -164), (54, -152)], .accent)
        pen.art.signAt = CGPoint(x: -44, y: -78)
        pen.art.sign = "popcorn.fill"
        return pen.finished()
    }

    /// De kerk: a brick church with a slate roof, arched windows and a tall tower with a clock and spire.
    private static func kerk() -> KaartLandmark {
        var pen = KaartPen(wall: 0x8C4A3A, roof: 0x45505A, door: 0x3E2A1E, accent: 0xC9A15B)
        // The tower comes first: it is the front with the door.
        let tower = pen.box(x: 0, w: 34, h: 128, depth: 26)
        let nave = pen.box(x: 34, w: 104, h: 74, depth: 44)
        pen.ridgeRoof(over: nave, rise: 46, depth: 44, overhang: 4)
        pen.windows(in: CGRect(x: 40, y: -66, width: 94, height: 54), cols: 4, rows: 1, w: 12, h: 30, arched: true, seed: 25)
        pen.oval(82, -70 - 14, 16, 16, .trim)
        pen.oval(85, -70 - 11, 10, 10, .lit)
        // Tower: belfry openings, clock, spire with a golden weathercock.
        pen.windows(in: CGRect(x: 4, y: -124, width: 26, height: 30), cols: 2, rows: 1, w: 7, h: 16, arched: true, seed: 3)
        pen.oval(7, -88, 20, 20, .white)
        pen.line(Path { $0.addEllipse(in: CGRect(x: 7, y: -88, width: 20, height: 20)) }, .ink, width: 1.4)
        pen.line(KaartPen.polygonLine([(17, -84), (17, -78), (21, -76)]), .ink, width: 1.4)
        pen.spire(cx: 17 + 6, base: tower.minY - 7, w: 40, h: 74)
        pen.rect(22.2, tower.minY - 7 - 74 - 10, 1.6, 12, .ink)
        pen.poly([(19, -219), (27, -219), (25, -223)], .accent)
        pen.door(cx: 17, w: 16, h: 30, arched: true)
        pen.art.signAt = CGPoint(x: 36, y: -40)
        pen.art.sign = "bell.fill"
        return pen.finished()
    }

    /// Het theater: a cream classical front with columns, a pediment and red doors, a tall stage house behind and a poster column.
    private static func theater() -> KaartLandmark {
        var pen = KaartPen(wall: 0xE8DCC0, roof: 0x45505A, door: 0xB0231B, awning: 0x7A1E1E, accent: 0xC9A15B)
        // The tall stage house stands behind the front.
        let stage = pen.box(x: 46, w: 58, h: 102, depth: 28, base: -16, paint: .color(0xCDB991))
        pen.ridgeRoof(over: stage, rise: 12, depth: 28, overhang: 2)
        let front = pen.box(x: 0, w: 110, h: 76, depth: 28)
        pen.art.front = front
        pen.balustrade(from: 2, to: 30, y: -76)
        pen.balustrade(from: 80, to: 108, y: -76)
        pen.rect(0, -38, 110, 3, .trim)
        // Three red doors with lanterns, columns and arched windows above.
        pen.door(cx: 55, w: 15, h: 28, arched: true)
        pen.door(cx: 28, w: 13, h: 24, arched: true)
        pen.door(cx: 82, w: 13, h: 24, arched: true)
        pen.lantern(x: 42, y: -22)
        pen.lantern(x: 68, y: -22)
        pen.columns(from: 12, to: 98, count: 5, base: -38, h: 30, paint: .color(0xF6F1E6))
        for (i, c) in [22.75, 44.25, 65.75, 87.25].enumerated() {
            pen.windows(in: CGRect(x: c - 8, y: -66, width: 16, height: 26), cols: 1, rows: 1, w: 10, h: 20, arched: true, seed: 26 + i)
        }
        pen.pediment(x: 26, w: 58, y: -75, rise: 22)
        pen.oval(51, -90, 8, 8, .accent)
        pen.posterColumn(x: 114)
        pen.art.signAt = CGPoint(x: -44.7, y: -90)
        pen.art.sign = "theatermasks.fill"
        return pen.finished()
    }

    /// De universiteit: a stately brick building with arched windows and a central clock tower with a green copper dome.
    private static func universiteit() -> KaartLandmark {
        var pen = KaartPen(wall: 0x7B3F2E, roof: 0x45505A, door: 0x24533F, awning: 0x1F3A6B, accent: 0xC9A15B)
        let main = pen.box(x: 0, w: 104, h: 70, depth: 26)
        pen.ridgeRoof(over: main, rise: 20, depth: 26, overhang: 3)
        pen.rect(0, -37, 104, 2.5, .trim)
        pen.windows(in: CGRect(x: 2, y: -68, width: 36, height: 66), cols: 2, rows: 2, w: 10, h: 18, arched: true, seed: 29)
        pen.windows(in: CGRect(x: 66, y: -68, width: 36, height: 66), cols: 2, rows: 2, w: 10, h: 18, arched: true, seed: 92)
        // The tower: its foot is the porch, its top rises above the roof.
        pen.rect(40, -70, 24, 70, .wall)
        let top = pen.box(x: 40, w: 24, h: 64, depth: 18, base: -70)
        for y in stride(from: -132.0, to: -2, by: 10) {
            pen.rect(40, y, 4, 5, .trim)
            pen.rect(60, y + 5, 4, 5, .trim)
        }
        pen.rect(38, top.minY, 28, 4, .trim)
        pen.clock(cx: 52, cy: -112, r: 8)
        pen.windows(in: CGRect(x: 44, y: -98, width: 16, height: 26), cols: 1, rows: 1, w: 8, h: 16, arched: true, seed: 7)
        // Lantern and copper dome.
        let drum = pen.box(x: 45, w: 14, h: 12, depth: 10, base: top.minY - 4, paint: .color(0xE8DCC0))
        pen.dome(over: drum, cx: 52 + 2, w: 24, h: 12, paint: .color(0x5E9C86))
        pen.rect(53.2, drum.minY - 22, 1.6, 10, .accent)
        pen.oval(51.5, drum.minY - 25, 5, 5, .accent)
        // Door with a small pediment, and students' bikes.
        pen.door(cx: 52, w: 14, h: 26, arched: true)
        pen.pediment(x: 42, w: 20, y: -32, rise: 7)
        pen.bike(x: 70, frame: 0x1F3A6B)
        pen.bike(x: 82, frame: 0xC8261B)
        pen.art.signAt = CGPoint(x: -44, y: -70)
        pen.art.sign = "graduationcap.fill"
        return pen.finished()
    }

    /// De rechtbank: a stern grey temple front on wide steps, with six columns and golden scales in the pediment.
    private static func rechtbank() -> KaartLandmark {
        let stone: UInt32 = 0xA9A69B
        var pen = KaartPen(wall: stone, roof: 0x5E6B73, door: 0x3A2A1E, awning: 0x2C2C2A, accent: 0xC9A15B)
        // Steps first, the hall stands on them.
        for i in 0..<3 {
            let inset = -Double(2 - i) * 4
            pen.box(x: inset, w: 116 - 2 * inset, h: 3.4, depth: 8, base: -Double(i) * 3.4, paint: .color(0xCFCBC0), top: .color(0xDEDBD2))
        }
        let hall = pen.box(x: 0, w: 116, h: 82, depth: 30, base: -10)
        pen.art.front = hall
        // A dark porch behind six columns, with tall windows and a bronze door.
        pen.rect(4, -64, 108, 54, .side)
        for (i, c) in [21.2, 39.6, 76.4, 94.8].enumerated() {
            pen.windows(in: CGRect(x: c - 6, y: -60, width: 12, height: 48), cols: 1, rows: 2, w: 7, h: 15, seed: 32 + i)
        }
        pen.door(cx: 58, w: 11, h: 32, base: -10)
        pen.columns(from: 12, to: 104, count: 6, base: -10, h: 54, paint: .color(0xE4E1D8))
        pen.rect(0, -92, 116, 3, .trim)
        pen.pediment(x: 0, w: 116, y: -92, rise: 34)
        pen.scales(cx: 58, y: -97)
        pen.art.signAt = CGPoint(x: -44, y: -60)
        pen.art.sign = "building.columns.fill"
        return pen.finished()
    }

    /// Het zwembad: a white hall with a curved blue roof and tall windows, an outdoor pool with a float and a water slide.
    private static func zwembad() -> KaartLandmark {
        var pen = KaartPen(wall: 0xF1F3F2, roof: 0x2E6E9E, door: 0x1F3A6B, awning: 0x5BB3E0, accent: 0xF2C230)
        let hall = pen.box(x: 0, w: 92, h: 54, depth: 30)
        pen.barrelRoof(over: hall, rise: 28, depth: 30)
        pen.windows(in: CGRect(x: 24, y: -52, width: 68, height: 48), cols: 4, rows: 1, w: 11, h: 34, seed: 35)
        pen.door(cx: 13, w: 14, h: 24)
        pen.pool(x: 98, y: 6, w: 66, depth: 36)
        pen.slide(x: 190)
        pen.art.signAt = CGPoint(x: -44, y: -64)
        pen.art.sign = "figure.pool.swim"
        return pen.finished()
    }

    /// De kinderopvang: a yellow house with a red roof and colourful windows, a playground with a slide and a swing behind a picket fence.
    private static func kinderopvang() -> KaartLandmark {
        var pen = KaartPen(wall: 0xF2C230, roof: 0xC8261B, door: 0x1F6FB2, awning: 0xC8261B, accent: 0xF2711C)
        let house = pen.box(x: 0, w: 76, h: 42, depth: 26)
        pen.gableRoof(over: house, rise: 28, depth: 26, overhang: 4)
        pen.oval(32, -62, 12, 12, .trim)
        pen.oval(34, -60, 8, 8, .lit)
        pen.rect(5, -36, 22, 26, .color(0x1F6FB2))
        pen.rect(30, -36, 22, 26, .color(0x5E8C45))
        pen.windows(in: CGRect(x: 5, y: -36, width: 22, height: 26), cols: 1, rows: 1, w: 14, h: 18, seed: 36)
        pen.windows(in: CGRect(x: 30, y: -36, width: 22, height: 26), cols: 1, rows: 1, w: 14, h: 18, seed: 63)
        pen.door(cx: 64, w: 14, h: 26)
        pen.bunting(from: 2, to: 74, y: -40)
        // The playground sits beside the house, a little back.
        pen.playground(x: 106, ground: -10)
        pen.art.signAt = CGPoint(x: -44.7, y: -52)
        pen.art.sign = "teddybear.fill"
        return pen.finished()
    }

    /// Het hotel: a tall cream hotel with iron balconies, a dark mansard roof with dormers, three flags and a green canopy with stars.
    private static func hotel() -> KaartLandmark {
        var pen = KaartPen(wall: 0xE8DCC4, roof: 0x2C2C2A, door: 0x7A1E1E, awning: 0x2F4B3A, accent: 0xC9A15B)
        let main = pen.box(x: 0, w: 92, h: 150, depth: 30)
        pen.mansard(over: main, rise: 22, inset: 7, depth: 30)
        for x in [16.0, 40, 64] { pen.dormer(x: x, y: -153) }
        pen.rect(0, -37, 92, 3, .trim)
        // Four floors of rooms with balconies.
        for (i, y) in [-140.0, -114, -88, -62].enumerated() {
            pen.windows(in: CGRect(x: 4, y: y - 4, width: 84, height: 26), cols: 3, rows: 1, w: 14, h: 18, seed: 49 + i)
            if i < 3 { for x in [14.5, 39, 63.5] { pen.balcony(x: x - 3, y: y + 18, w: 20) } }
        }
        pen.sideWindows(x: 92, depth: 30, tops: [-140, -114, -88, -62], h: 18, cols: 2, w: 9, seed: 49)
        // Lobby windows, the red door and carpet under a canopy with gold stars.
        pen.windows(in: CGRect(x: 2, y: -32, width: 26, height: 30), cols: 1, rows: 1, w: 18, h: 22, seed: 4)
        pen.windows(in: CGRect(x: 64, y: -32, width: 26, height: 30), cols: 1, rows: 1, w: 18, h: 22, seed: 5)
        pen.door(cx: 46, w: 16, h: 26)
        pen.poly([(40, 0), (52, 0), (55, 5), (37, 5)], .door)
        pen.canopy(x: 28, w: 36, y: -40)
        let flags: [[UInt32]] = [[0xAE1C28, 0xFFFFFF, 0x21468B], [0x2F4B3A, 0xC9A15B, 0x2F4B3A], [0xF2711C, 0xFFFFFF, 0xF2711C]]
        for (i, colors) in flags.enumerated() { pen.flag(x: 26 + Double(i) * 22, y: -177, height: 30, colors: colors) }
        pen.art.signAt = CGPoint(x: -44, y: -98)
        pen.art.sign = "bed.double.fill"
        return pen.finished()
    }
}

// MARK: - Parts for the big buildings

nonisolated extension KaartPen {
    /// The finished landmark, with every surface cut where a later surface covers it, so hidden
    /// edges don't show through the outline.
    fileprivate func finished() -> KaartLandmark {
        var art = self.art
        var cover = Path()
        for i in art.layers.indices.reversed() where art.layers[i].line == nil && art.layers[i].paint.isSurface {
            let path = art.layers[i].path
            if !cover.isEmpty { art.layers[i].path = path.subtracting(cover) }
            cover = cover.union(path)
        }
        return art
    }

    /// A strip across a box's front and round its side wall (bands, fascias).
    fileprivate mutating func band(_ front: CGRect, y: Double, h: Double, depth: Double, paint: KaartPaint) {
        rect(front.minX, y, front.width, h, paint)
        let x = front.maxX, dy = depth * Self.slope
        poly([(x, y), (x + depth, y - dy), (x + depth, y + h - dy), (x, y + h)], paint.shaded)
    }

    /// Windows on a box's side wall, which starts at the front's right edge `x`; one row per top.
    fileprivate mutating func sideWindows(x: Double, depth: Double, tops: [Double], h: Double, cols: Int, w: Double, seed: Int) {
        let s = Self.slope
        let gap = (depth - Double(cols) * w) / Double(cols + 1)
        var rnd = GevelRandom(seed: seed * 613 + 5)
        var glass = Path(), lit = Path()
        for top in tops {
            for c in 0..<cols {
                let u0 = gap + Double(c) * (w + gap), u1 = u0 + w
                let pane = Self.polygon([(x + u0, top - u0 * s), (x + u1, top - u1 * s), (x + u1, top + h - u1 * s), (x + u0, top + h - u0 * s)])
                if rnd.next() < 0.5 { lit.addPath(pane) } else { glass.addPath(pane) }
            }
        }
        fill(glass, .glass)
        fill(lit, .lit)
    }

    /// A yellow Dutch ambulance with blue checks and a blue light, parked facing left, its front bumper at x.
    fileprivate mutating func ambulance(x: Double) {
        let body = Self.polygon([(x, -1), (x, -12), (x + 4, -18), (x + 11, -18), (x + 11, -22), (x + 40, -22), (x + 40, -1)])
        fill(body, .color(0xF2C230))
        rect(x, -11, 40, 5, .color(0x1F6FB2))
        var checks = Path()
        for i in 0..<5 {
            checks.addRect(CGRect(x: x + 2 + Double(i) * 8, y: -11, width: 4, height: 2.5))
            checks.addRect(CGRect(x: x + 6 + Double(i) * 8, y: -8.5, width: 4, height: 2.5))
        }
        fill(checks, .accent)
        poly([(x + 1.5, -12.5), (x + 4.6, -16.5), (x + 10, -16.5), (x + 10, -12.5)], .ink)
        rect(x + 6, -24, 4, 3, .color(0x3D7DE0))
        rect(x + 33, -25, 4, 3, .color(0x3D7DE0))
        for wx in [x + 8, x + 32] {
            oval(wx - 3.6, -4.6, 7.2, 7.2, .ink)
            oval(wx - 1.4, -2.4, 2.8, 2.8, .trim)
        }
    }

    /// A dumbbell lying level, centred on (cx, cy).
    fileprivate mutating func dumbbell(cx: Double, cy: Double, w: Double) {
        let half = w / 2
        rect(cx - half + 2, cy - 2, w - 4, 4, .accent)
        for side in [-1.0, 1] {
            let outer = cx + side * (half - 9), inner = cx + side * (half - 15)
            fill(Path(roundedRect: CGRect(x: outer - 4.5, y: cy - 13, width: 9, height: 26), cornerRadius: 2.5), .color(0xF2711C))
            fill(Path(roundedRect: CGRect(x: inner - 3, y: cy - 9, width: 6, height: 18), cornerRadius: 2), .color(0x1E1E1C))
        }
    }

    /// A museum banner with a swallow tail, hanging from (x, y).
    fileprivate mutating func banner(x: Double, y: Double, w: Double, h: Double) {
        poly([(x, y), (x + w, y), (x + w, y + h), (x + w / 2, y + h - 5), (x, y + h)], .awning)
        rect(x, y + 3, w, 2, .accent)
        oval(x + w / 2 - 2, y + h / 2 - 2, 4, 4, .accent)
    }

    /// A row of little light bulbs.
    fileprivate mutating func bulbs(from x0: Double, to x1: Double, y: Double) {
        var dots = Path()
        for x in stride(from: x0, through: x1, by: 4) { dots.addEllipse(in: CGRect(x: x - 1.2, y: y - 1.2, width: 2.4, height: 2.4)) }
        fill(dots, .accent)
    }

    /// A gold-framed film poster case, 16 wide, by a cinema door.
    fileprivate mutating func poster(x: Double, color: UInt32) {
        rect(x, -34, 16, 24, .accent)
        rect(x + 2, -32, 12, 20, .color(color))
        oval(x + 4.5, -27, 7, 7, .white)
    }

    /// A wall lantern on a little bracket, its lamp at (x, y).
    fileprivate mutating func lantern(x: Double, y: Double) {
        rect(x - 0.6, y - 2, 1.2, 6, .ink)
        poly([(x - 3, y - 4), (x + 3, y - 4), (x + 2, y + 3), (x - 2, y + 3)], .accent)
        poly([(x - 3.6, y - 4), (x, y - 7), (x + 3.6, y - 4)], .ink)
    }

    /// A stone balustrade standing on y, from x0 to x1.
    fileprivate mutating func balustrade(from x0: Double, to x1: Double, y: Double) {
        rect(x0, y - 9, x1 - x0, 2.4, .trim)
        rect(x0, y - 2, x1 - x0, 2, .trim)
        var posts = Path()
        for x in stride(from: x0 + 2, through: x1 - 3, by: 4) { posts.addRect(CGRect(x: x, y: y - 7, width: 2, height: 5)) }
        fill(posts, .trim)
    }

    /// A green round advertising column with posters and a little dome, left edge at x.
    fileprivate mutating func posterColumn(x: Double) {
        rect(x - 1, -5, 14, 5, .color(0x2F4B3A))
        rect(x, -36, 12, 31, .color(0x2F4B3A))
        rect(x + 1, -32, 5, 12, .white)
        rect(x + 6.5, -31, 4.5, 14, .awning)
        rect(x + 1, -18, 9, 9, .accent)
        rect(x - 1.5, -38, 15, 3, .color(0x2F4B3A))
        var cap = Path()
        cap.move(to: CGPoint(x: x - 0.5, y: -38))
        cap.addQuadCurve(to: CGPoint(x: x + 12.5, y: -38), control: CGPoint(x: x + 6, y: -50))
        cap.closeSubpath()
        fill(cap, .color(0x2F4B3A))
        oval(x + 4.8, -47.5, 2.4, 2.4, .accent)
    }

    /// A clock face with hands at ten past ten.
    fileprivate mutating func clock(cx: Double, cy: Double, r: Double) {
        oval(cx - r, cy - r, 2 * r, 2 * r, .white)
        line(Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: 2 * r, height: 2 * r)), .accent, width: 1.4)
        line(Self.polygonLine([(cx - r * 0.5, cy - r * 0.3), (cx, cy), (cx + r * 0.35, cy - r * 0.6)]), .ink, width: 1.3)
    }

    /// A bicycle standing on the ground with its back wheel at x.
    fileprivate mutating func bike(x: Double, frame: UInt32) {
        var wheels = Path()
        wheels.addEllipse(in: CGRect(x: x, y: -9, width: 9, height: 9))
        wheels.addEllipse(in: CGRect(x: x + 13, y: -9, width: 9, height: 9))
        line(wheels, .ink, width: 1.2)
        line(Self.polygonLine([(x + 4.5, -4.5), (x + 8, -12), (x + 16, -12), (x + 17.5, -4.5)]), .color(frame), width: 1.6)
        line(Self.polygonLine([(x + 4.5, -4.5), (x + 11, -4.5), (x + 8, -12)]), .color(frame), width: 1.6)
        line(Self.polygonLine([(x + 6, -13.5), (x + 10, -13.5)]), .ink, width: 1.6)
        line(Self.polygonLine([(x + 16, -12), (x + 15, -15.5), (x + 18.5, -15.5)]), .ink, width: 1.3)
    }

    /// Golden scales of justice standing on (cx, y).
    fileprivate mutating func scales(cx: Double, y: Double) {
        rect(cx - 5, y - 2, 10, 2, .accent)
        rect(cx - 0.8, y - 20, 1.6, 18, .accent)
        oval(cx - 2, y - 23, 4, 4, .accent)
        rect(cx - 13, y - 18, 26, 1.6, .accent)
        var strings = Path()
        for side in [-1.0, 1] {
            let end = cx + side * 12
            strings.move(to: CGPoint(x: end, y: y - 17)); strings.addLine(to: CGPoint(x: end - 3.5, y: y - 8))
            strings.move(to: CGPoint(x: end, y: y - 17)); strings.addLine(to: CGPoint(x: end + 3.5, y: y - 8))
            var pan = Path()
            pan.move(to: CGPoint(x: end - 4.5, y: y - 8))
            pan.addQuadCurve(to: CGPoint(x: end + 4.5, y: y - 8), control: CGPoint(x: end, y: y - 2))
            pan.closeSubpath()
            fill(pan, .accent)
        }
        line(strings, .accent, width: 0.9)
    }

    /// A barrel roof on top of `front`: the curved end faces you, the vault runs back.
    fileprivate mutating func barrelRoof(over front: CGRect, rise: Double, depth: Double) {
        let a = front.width / 2, b = rise, cx = front.midX, base = front.minY
        let dx = depth, dy = -depth * Self.slope
        func arch(_ t: Double, _ ox: Double = 0, _ oy: Double = 0) -> (Double, Double) {
            (cx + a * cos(t) + ox, base - b * sin(t) + oy)
        }
        // Where the vault's outline leaves the front arch for the back one.
        let turn = Double.pi - atan(-dx * b / (dy * a))
        var vault: [(Double, Double)] = []
        for i in 0...16 { vault.append(arch(.pi - (Double.pi - turn) * Double(i) / 16)) }
        for i in 0...24 { vault.append(arch(turn * (1 - Double(i) / 24), dx, dy)) }
        vault.append((front.maxX, base))
        poly(vault, .roof)
        var end: [(Double, Double)] = []
        for i in 0...24 { end.append(arch(.pi * (1 - Double(i) / 24))) }
        poly(end, .wall)
        var fan: [(Double, Double)] = []
        for i in 0...20 { fan.append((cx + a * 0.62 * cos(.pi * (1 - Double(i) / 20)), base - 2 - b * 0.62 * sin(.pi * (1 - Double(i) / 20)))) }
        poly(fan, .glass)
        var ribs = Path()
        for t in [0.25, 0.5, 0.75] {
            ribs.move(to: CGPoint(x: cx, y: base - 2))
            ribs.addLine(to: CGPoint(x: cx + a * 0.62 * cos(.pi * t), y: base - 2 - b * 0.62 * sin(.pi * t)))
        }
        line(ribs, .trim, width: 1.4)
        rect(front.minX, base - 2, front.width, 2.5, .trim)
    }

    /// An outdoor pool lying on the ground: front edge from (x, y), `w` long, `depth` deep.
    fileprivate mutating func pool(x: Double, y: Double, w: Double, depth: Double) {
        let dx = depth, dy = -depth * Self.slope
        let corners = [(x, y), (x + w, y), (x + w + dx, y + dy), (x + dx, y + dy)]
        fill(Self.polygon(corners), .awning)
        line(Self.polygon(corners), .white, width: 3)
        var lanes = Path()
        for f in [1.0 / 3, 2.0 / 3] {
            lanes.move(to: CGPoint(x: x + 3 + dx * f, y: y + dy * f))
            lanes.addLine(to: CGPoint(x: x + w - 3 + dx * f, y: y + dy * f))
        }
        line(lanes, .white, width: 0.9)
        // A floating ring.
        oval(x + 14 + dx * 0.4, y + dy * 0.4 - 3, 10, 6.5, .accent)
        oval(x + 16.8 + dx * 0.4, y + dy * 0.4 - 1.5, 4.4, 3, .awning)
    }

    /// A water slide: a tower with a ladder behind the pool at x, the tube curving down into the water.
    fileprivate mutating func slide(x: Double) {
        var frame = Path()
        frame.move(to: CGPoint(x: x, y: -14)); frame.addLine(to: CGPoint(x: x, y: -60))
        frame.move(to: CGPoint(x: x + 10, y: -18)); frame.addLine(to: CGPoint(x: x + 10, y: -60))
        frame.move(to: CGPoint(x: x, y: -24)); frame.addLine(to: CGPoint(x: x + 10, y: -44))
        frame.move(to: CGPoint(x: x + 10, y: -28)); frame.addLine(to: CGPoint(x: x, y: -48))
        line(frame, .ink, width: 1.6)
        var ladder = Path()
        ladder.move(to: CGPoint(x: x + 13, y: -18)); ladder.addLine(to: CGPoint(x: x + 13, y: -60))
        ladder.move(to: CGPoint(x: x + 18, y: -20)); ladder.addLine(to: CGPoint(x: x + 18, y: -60))
        for y in stride(from: -24.0, through: -56, by: -5) { ladder.move(to: CGPoint(x: x + 13, y: y)); ladder.addLine(to: CGPoint(x: x + 18, y: y)) }
        line(ladder, .ink, width: 1.1)
        rect(x - 3, -62, 23, 3, .ink)
        line(KaartPen.polygonLine([(x - 2, -62), (x - 2, -68), (x + 19, -68), (x + 19, -62)]), .ink, width: 1.1)
        var chute = Path()
        chute.move(to: CGPoint(x: x, y: -59))
        chute.addCurve(to: CGPoint(x: x - 22, y: -34), control1: CGPoint(x: x - 16, y: -60), control2: CGPoint(x: x - 14, y: -40))
        chute.addCurve(to: CGPoint(x: x - 40, y: -8), control1: CGPoint(x: x - 30, y: -28), control2: CGPoint(x: x - 30, y: -9))
        line(chute, .color(0xC4471A), width: 7)
        line(chute, .color(0xF2711C), width: 3.6)
    }

    /// Little triangle flags on a sagging string from x0 to x1, hung at y.
    fileprivate mutating func bunting(from x0: Double, to x1: Double, y: Double) {
        var string = Path()
        string.move(to: CGPoint(x: x0, y: y))
        string.addQuadCurve(to: CGPoint(x: x1, y: y), control: CGPoint(x: (x0 + x1) / 2, y: y + 10))
        line(string, .ink, width: 0.8)
        let colors: [UInt32] = [0xC8261B, 0x1F6FB2, 0x5E8C45, 0xF2711C]
        let count = Int((x1 - x0) / 8)
        for i in 1..<count {
            let t = Double(i) / Double(count)
            let fx = x0 + (x1 - x0) * t, fy = y + 10 * 2 * t * (1 - t)
            poly([(fx - 2.6, fy), (fx + 2.6, fy), (fx, fy + 5)], .color(colors[i % colors.count]))
        }
    }

    /// A playground from x, standing on `ground`: a swing with a child, a slide and a white picket fence in front.
    fileprivate mutating func playground(x: Double, ground: Double) {
        let first = art.layers.count
        // Swing.
        var frame = Path()
        for (top, l, r) in [(x + 3.0, x, x + 6.0), (x + 25, x + 22, x + 28)] {
            frame.move(to: CGPoint(x: l, y: 0)); frame.addLine(to: CGPoint(x: top, y: -30)); frame.addLine(to: CGPoint(x: r, y: 0))
        }
        line(frame, .color(0x6B4A2E), width: 1.8)
        rect(x + 1, -31.5, 26, 2.4, .color(0x6B4A2E))
        var ropes = Path()
        for rx in [x + 10, x + 18] { ropes.move(to: CGPoint(x: rx, y: -29)); ropes.addLine(to: CGPoint(x: rx + 3, y: -12)) }
        line(ropes, .ink, width: 0.8)
        rect(x + 11, -13, 11, 2, .awning)
        oval(x + 14, -24, 5, 5, .color(0xE8B48A))
        rect(x + 13.5, -19.5, 6, 7, .color(0x1F6FB2))
        // Slide.
        var ladder = Path()
        ladder.move(to: CGPoint(x: x + 48, y: 0)); ladder.addLine(to: CGPoint(x: x + 48, y: -28))
        ladder.move(to: CGPoint(x: x + 54, y: 0)); ladder.addLine(to: CGPoint(x: x + 54, y: -28))
        for y in stride(from: -5.0, through: -25, by: -5) { ladder.move(to: CGPoint(x: x + 48, y: y)); ladder.addLine(to: CGPoint(x: x + 54, y: y)) }
        line(ladder, .ink, width: 1.2)
        rect(x + 44, -30, 12, 2.5, .ink)
        var chute = Path()
        chute.move(to: CGPoint(x: x + 45, y: -29))
        chute.addQuadCurve(to: CGPoint(x: x + 30, y: -2), control: CGPoint(x: x + 40, y: -6))
        line(chute, .accent, width: 4)
        // Picket fence.
        var pickets = Path()
        for px in stride(from: x - 2, through: x + 58, by: 5) {
            pickets.addPath(Self.polygon([(px, 5), (px, -5), (px + 1.5, -7), (px + 3, -5), (px + 3, 5)]))
        }
        pickets.addRect(CGRect(x: x - 2, y: -3, width: 63, height: 1.6))
        pickets.addRect(CGRect(x: x - 2, y: 1.5, width: 63, height: 1.6))
        fill(pickets, .white)
        let move = CGAffineTransform(translationX: 0, y: ground)
        for i in first..<art.layers.count { art.layers[i].path = art.layers[i].path.applying(move) }
    }

    /// A dark mansard roof on top of `front`: a steep lower slope, a flat top and its side.
    fileprivate mutating func mansard(over front: CGRect, rise: Double, inset: Double, depth: Double) {
        let l = front.minX - 3, r = front.maxX + 3, y0 = front.minY, y1 = y0 - rise
        let dx = depth, dy = -depth * Self.slope
        poly([(r, y0), (r + dx, y0 + dy), (r + dx - inset, y1 + dy), (r - inset, y1)], .roofSide)
        poly([(l + inset, y1), (l + inset + dx, y1 + dy), (r - inset + dx, y1 + dy), (r - inset, y1)], .color(0x45505A))
        poly([(l, y0), (r, y0), (r - inset, y1), (l + inset, y1)], .roof)
        rect(front.minX - 3, y0 - 1, front.width + 6, 3, .trim)
    }

    /// A dormer window on a mansard, x its left edge, y its foot.
    fileprivate mutating func dormer(x: Double, y: Double) {
        rect(x, y - 12, 12, 12, .trim)
        poly([(x - 2, y - 12), (x + 6, y - 18), (x + 14, y - 12)], .trim)
        fill(KaartPen.window(x: x + 3, y: y - 10, w: 6, h: 9, arched: true), .lit)
    }

    /// An iron balcony in front of a window: slab and railing, x its left edge, y its floor.
    fileprivate mutating func balcony(x: Double, y: Double, w: Double) {
        rect(x, y, w, 2.5, .trim)
        var rail = Path()
        rail.addRect(CGRect(x: x + 0.5, y: y - 7, width: w - 1, height: 7))
        for bx in stride(from: x + 3.5, to: x + w - 1, by: 3) { rail.move(to: CGPoint(x: bx, y: y - 7)); rail.addLine(to: CGPoint(x: bx, y: y)) }
        line(rail, .ink, width: 0.9)
    }

    /// A hotel canopy over the door: a green band with gold stars on two gold poles.
    fileprivate mutating func canopy(x: Double, w: Double, y: Double) {
        rect(x + 1, y + 8, 1.6, -y - 3, .accent)
        rect(x + w - 2.6, y + 8, 1.6, -y - 3, .accent)
        poly([(x, y), (x + w, y), (x + w + 4, y - 4), (x + 4, y - 4)], .color(0x24533F))
        rect(x, y, w, 8, .awning)
        rect(x, y + 7, w, 1.4, .accent)
        var stars = Path()
        for i in 0..<5 {
            let sx = x + w / 2 + Double(i - 2) * 6, sy = y + 3.6
            var pts: [(Double, Double)] = []
            for k in 0..<10 {
                let a = -Double.pi / 2 + Double(k) * .pi / 5, r = k % 2 == 0 ? 2.4 : 1
                pts.append((sx + r * cos(a), sy + r * sin(a)))
            }
            stars.addPath(Self.polygon(pts))
        }
        fill(stars, .accent)
    }
}
