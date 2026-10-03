import SwiftUI

/// The illustrated canal-ring map (port of StadKaart `paths()` and `extras()`), built once.
nonisolated struct KaartMapPaths: Sendable {
    var canals = Path()
    var streets = Path()
    var radials = Path()
    var water = Path()
    /// All water as one shape (river, lake, pond and the canals), so banks are inked once and
    /// canals flow into the river without a line.
    var waterAll = Path()
    /// Streets and radials together, inked and paved in one go (clean junctions).
    var allStreets = Path()
    /// The edge between city and countryside, and the field borders, in ink.
    var meadowEdge = Path()
    var fieldInk = Path()
    var park = Path()
    var parkPath = Path()
    var meadow = Path()
    var fieldsA = Path()
    var fieldsB = Path()
    var ditch = Path()
    var sand = Path()
    var dike = Path()
    var runway = Path()
    var runwayDash = Path()
    var jetty = Path()
    var mooredA = Path()
    var mooredB = Path()
    var shimmer = Path()
    var trees = Path()
    /// Every third crown: blossom in spring, deeper orange in autumn.
    var treesAlt = Path()
    var treesDark = Path()
    /// The polder fields, one rect each (painted per season).
    var fieldRects: [CGRect] = []
    /// Where a street crosses a canal: the bridge's centre and the street's direction (radians).
    var bridges: [(center: CGPoint, angle: Double)] = []
    /// Small ripple marks on the canals.
    var ripples = Path()
    /// Houseboats moored along the canals: centre, heading (degrees), colour.
    var houseboats: [(center: CGPoint, heading: Double, color: UInt32)] = []
    var lamps: [CGPoint] = []
    /// (x, y, body, skin)
    var people: [(CGPoint, UInt32, UInt32)] = []
    /// (x, y, frame colour)
    var bikes: [(CGPoint, UInt32)] = []

    static let shared = KaartMapPaths.build()

    /// Unrounded ring point (prototype `paths()` P).
    static func p(_ r: Double, _ t: Double) -> CGPoint {
        let a = t * .pi / 180
        return CGPoint(x: 500 + r * cos(a), y: 96 + r * sin(a))
    }

    private static func line(_ a: CGPoint, _ b: CGPoint) -> String {
        let r = Gevelkit.r
        return "M\(r(a.x)) \(r(a.y))L\(r(b.x)) \(r(b.y))"
    }

    private static func build() -> KaartMapPaths {
        var m = KaartMapPaths()
        let r = Gevelkit.r
        let rect = Gevelkit.rect
        let dot = Gevelkit.dot

        var canals = ""
        for R in [150.0, 290, 430, 570] {
            canals += "M\(500 - R) 44V96A\(R) \(R) 0 0 0 \(500 + R) 96V44"
        }
        m.canals = StadSVG.path(canals)

        var streets = ""
        for R in [220.0, 360, 500] {
            streets += "M\(500 - R) 76V96A\(R) \(R) 0 0 0 \(500 + R) 96V76"
        }
        streets += "M-140 96A640 640 0 0 0 1140 96"
        streets += "M500 736V1062M500 880C420 880 330 872 250 900S110 960 40 968M500 836C600 836 700 800 860 782M540 1062C700 1054 850 1060 1000 1052"
        m.streets = StadSVG.path(streets)

        var radials = "M0 76H1000M500 96V736"
        for t in [18.0, 54, 126, 162] { radials += line(p(120, t), p(660, t)) }
        m.radials = StadSVG.path(radials)


        // Bridges: the five radial streets over the four canals, and the quay street over the canal ends.
        for t in [18.0, 54, 90, 126, 162] {
            for R in [150.0, 290, 430, 570] {
                let c = p(R, t)
                if c.x > 0 && c.x < 1000 { m.bridges.append((c, t * .pi / 180)) }
            }
        }
        for R in [150.0, 290, 430] {
            for x in [500 - R, 500 + R] { m.bridges.append((CGPoint(x: x, y: 76), 0)) }
        }

        var ripples = Path()
        for R in [150.0, 290, 430, 570] {
            var i = 0
            for t in stride(from: 6.0, through: 174, by: 6.5) {
                i += 1
                if [18.0, 54, 90, 126, 162].contains(where: { abs($0 - t) < 5 }) { continue }
                let r = R + (i % 2 == 0 ? 3.5 : -3.5)
                let start = p(r, t)
                if start.x < 4 || start.x > 996 { continue }
                ripples.move(to: start)
                ripples.addArc(center: CGPoint(x: 500, y: 96), radius: r, startAngle: .degrees(t), endAngle: .degrees(t + 2), clockwise: false)
            }
        }
        m.ripples = ripples

        for (R, t, side, color) in [
            (150.0, 32.0, -1.0, 0x2F4B3A as UInt32), (150, 146, 1, 0x7A1E1E), (290, 40, 1, 0x1F3A6B), (290, 104, -1, 0x2F4B3A),
            (290, 141, 1, 0x2C2C2A), (430, 30, -1, 0x7A1E1E), (430, 73, 1, 0x24533F), (430, 109, -1, 0x1F3A6B),
            (430, 148, 1, 0x7A1E1E), (570, 64, 1, 0x2C2C2A), (570, 98, -1, 0x2F4B3A), (570, 117, 1, 0x1F3A6B),
        ] {
            let c = p(R + side * 5.5, t)
            if c.x > 10 && c.x < 990 { m.houseboats.append((c, t + 90, color)) }
        }

        m.water = StadSVG.path(
            "M0 0H1000V50C900 62 820 44 720 54S560 62 480 52S300 44 200 56S60 52 0 58Z"
                + "M0 1112C150 1100 300 1120 450 1108S760 1102 1000 1104V1200H0Z"
                + "M176 356a22 11 0 1 0 44 0a22 11 0 1 0-44 0Z"
        )
        m.park = StadSVG.path("M140 338a82 64 0 1 0 164 0a82 64 0 1 0-164 0Z")
        m.parkPath = StadSVG.path("M160 304C200 282 262 292 292 322S262 396 210 392S150 362 160 304Z")
        m.meadow = StadSVG.path("M0 495.3A640 640 0 0 0 1000 495.3V1200H0Z")
        for row in 0..<5 {
            for c in 0..<3 {
                let d = rect(590 + Double(c) * 140, 772 + Double(row) * 50, 132, 44)
                if (row + c) % 2 == 0 { m.fieldsA.addPath(d) } else { m.fieldsB.addPath(d) }
                m.fieldRects.append(CGRect(x: 590 + Double(c) * 140, y: 772 + Double(row) * 50, width: 132, height: 44))
            }
        }
        m.ditch = StadSVG.path("M586 768V1024M726 768V1024M866 768V1024")
        m.sand = StadSVG.path("M0 1040C120 1030 260 1050 400 1040S540 1034 560 1044V1116H0Z")
        m.dike = StadSVG.path("M540 1036C700 1026 850 1032 1000 1024V1108H540Z")
        m.runway = StadSVG.path("M18 692L246 702L245 722L17 712Z")
        m.runwayDash = StadSVG.path("M30 702.5L236 711.5")
        for (x, y, h) in [(790.0, 12.0, 42.0), (850, 8, 46), (910, 12, 42), (962, 18, 36)] {
            m.jetty.addPath(rect(x, y, 10, h))
        }
        m.mooredA = StadSVG.path("M806 22q14-12 28 0v26h-28Z")
        m.mooredB = StadSVG.path("M868 26q12-10 24 0v22h-24Z")

        var shimmer = "M60 24h50M300 18h70M620 30h60M740 16h36M180 1150h60M560 1160h80M860 1140h50"
        for (R, t) in [(150.0, 40.0), (150, 128), (290, 22), (290, 100), (290, 160), (430, 50), (430, 118), (570, 70), (570, 108)] {
            let a = t * .pi / 180
            let q = p(R, t)
            shimmer += "M\(r(q.x + 9 * sin(a))) \(r(q.y - 9 * cos(a)))L\(r(q.x - 9 * sin(a))) \(r(q.y + 9 * cos(a)))"
        }
        m.shimmer = StadSVG.path(shimmer)

        // Trees: same seeded placement as the prototype (rng 4242).
        var rnd = GevelRandom(seed: 4242)
        let occupied = KaartData.places.map(\.point)
        func inPark(_ x: Double, _ y: Double) -> Bool {
            let a = (x - 222) / 82, b = (y - 338) / 64
            return a * a + b * b < 1
        }
        // Trees keep clear of the background houses too (a tree in front of or behind a house would overlap it).
        let fillerBoxes = KaartFiller.shared.houses.map { $0.footprint.insetBy(dx: -6, dy: -5) }
        func okSpot(_ x: Double, _ y: Double) -> Bool {
            if x < 8 || x > 992 || y < 62 || y > 1100 { return false }
            for o in occupied where abs(x - o.x) < 34 && y > o.y - 78 && y < o.y + 14 { return false }
            let spot = CGPoint(x: x, y: y)
            return !fillerBoxes.contains { $0.contains(spot) }
        }
        var trees = Path(), treesAlt = Path(), treesDark = Path()
        var treeCount = 0
        func addTree(_ x: Double, _ y: Double, _ rr: Double) {
            treesDark.addPath(dot(x + 1.5, y + 2, rr))
            if treeCount % 3 == 2 {
                treesAlt.addPath(dot(x, y, r(rr - 1.4)))
            } else {
                trees.addPath(dot(x, y, r(rr - 1.4)))
            }
            treeCount += 1
        }
        for R in [150.0, 290, 430, 570] {
            for off in [-17.0, 17] {
                let rr = R + off
                let step = 30 / rr * 180 / .pi
                var t = 2 + rnd.next() * step
                while t < 178 {
                    defer { t += step }
                    let near = [18.0, 54, 90, 126, 162].contains { abs($0 - t) * .pi / 180 * rr < 17 }
                    if near { continue }
                    let q = p(rr, t)
                    if inPark(q.x, q.y) || !okSpot(q.x, q.y) { continue }
                    addTree(q.x, q.y, r(6 + rnd.next() * 1.5))
                }
            }
        }
        var guardCount = 0, added = 0
        while added < 15 && guardCount < 300 {
            guardCount += 1
            let a = rnd.next() * .pi * 2, d = rnd.next().squareRoot()
            let x = 222 + cos(a) * 70 * d, y = 338 + sin(a) * 52 * d
            if abs(x - 222) < 28 && y > 290 && y < 346 { continue }
            if abs(x - 198) < 30 && abs(y - 356) < 16 { continue }
            addTree(x, y, r(6.5 + rnd.next() * 2))
            added += 1
        }
        let clusters: [(Double, Double, Double, Int)] = [(420, 962, 64, 16), (160, 900, 60, 8), (880, 800, 54, 5), (300, 812, 56, 5), (690, 852, 44, 3), (80, 790, 50, 4)]
        for c in clusters {
            var k = 0, tries = 0
            while k < c.3 && tries < 200 {
                tries += 1
                let a = rnd.next() * .pi * 2, d = 0.45 + rnd.next() * 0.55
                let x = c.0 + cos(a) * c.2 * d, y = c.1 + sin(a) * c.2 * 0.7 * d
                if !okSpot(x, y) { continue }
                if y > 1030 || x < 6 { continue }
                addTree(x, y, r(6.5 + rnd.next() * 2))
                k += 1
            }
        }
        for x in stride(from: 60.0, to: 480, by: 26) where okSpot(x, 1022) {
            addTree(x, 1022 + rnd.next() * 6, 6)
        }
        m.trees = trees
        m.treesAlt = treesAlt
        m.treesDark = treesDark

        // Extras: lamps, people, parked bikes.
        func ip(_ rr: Double, _ t: Double) -> CGPoint {
            let a = t * .pi / 180
            return CGPoint(x: Gevelkit.jsRound(500 + rr * cos(a)), y: Gevelkit.jsRound(96 + rr * sin(a)))
        }
        var lamps: [CGPoint] = []
        for t in stride(from: 27.0, through: 153, by: 18) {
            lamps.append(ip(229, t))
            lamps.append(ip(369, t))
        }
        for y in [250.0, 330, 410, 560] { lamps.append(CGPoint(x: 509, y: y)) }
        for x in [300.0, 420, 580, 700] { lamps.append(CGPoint(x: x, y: 86)) }
        m.lamps = lamps
        m.people = [
            (CGPoint(x: 452, y: 172), 0xF2711C, 0xE8C4A0), (CGPoint(x: 532, y: 210), 0x2F5BD3, 0x8C5A3C),
            (CGPoint(x: 470, y: 208), 0x5DCAA5, 0xC99A74), (CGPoint(x: 596, y: 178), 0x993556, 0xE8C4A0),
            (CGPoint(x: 376, y: 226), 0x3C3489, 0x5C3A28), (CGPoint(x: 250, y: 354), 0xF2711C, 0xC99A74),
            (CGPoint(x: 722, y: 238), 0xC8261B, 0xE8C4A0), (CGPoint(x: 600, y: 294), 0x0F6E56, 0x8C5A3C),
        ]
        m.bikes = [
            (CGPoint(x: 468, y: 292), 0x2F5BD3), (CGPoint(x: 672, y: 228), 0xC8261B), (CGPoint(x: 330, y: 142), 0x1E1E1C),
            (CGPoint(x: 522, y: 118), 0x3F5A4A), (CGPoint(x: 705, y: 132), 0xF2711C),
        ]
        // Bike racks: by the station, the market and the tram stop.
        for (x, y, color) in [
            (586.0, 120.0, 0x1E1E1C as UInt32), (597, 120, 0xC8261B), (608, 120, 0x2F5BD3), (619, 120, 0x3F5A4A),
            (380, 120, 0xF2711C), (391, 120, 0x1E1E1C), (402, 120, 0x2F5BD3),
            (444, 214, 0x5DCAA5), (455, 214, 0x1E1E1C), (622, 196, 0xC8261B), (633, 196, 0x1F3A6B),
        ] {
            m.bikes.append((CGPoint(x: x, y: y), color))
        }
        // Redraw the base by hand: every long edge wavers a little.
        m.canals = KaartInk.wobble(m.canals, amount: 1.2, seed: 1)
        m.streets = KaartInk.wobble(m.streets, amount: 1.0, seed: 2)
        m.radials = KaartInk.wobble(m.radials, amount: 0.9, seed: 3)
        m.water = KaartInk.wobble(m.water, amount: 1.4, seed: 4)
        m.park = KaartInk.wobble(m.park, amount: 1.2, seed: 5)
        m.parkPath = KaartInk.wobble(m.parkPath, amount: 0.8, seed: 6)
        m.sand = KaartInk.wobble(m.sand, amount: 1.2, seed: 7)
        m.dike = KaartInk.wobble(m.dike, amount: 1.2, seed: 8)
        m.meadowEdge = KaartInk.wobble(StadSVG.path("M0 495.3A640 640 0 0 0 1000 495.3"), amount: 1.2, seed: 9)
        var fields = Path()
        for rect in m.fieldRects { fields.addPath(Path(rect)) }
        m.fieldInk = KaartInk.wobble(fields, amount: 0.7, step: 8, seed: 10)
        m.allStreets = m.streets
        m.allStreets.addPath(m.radials)
        m.waterAll = m.water.union(m.canals.strokedPath(StrokeStyle(lineWidth: 21, lineCap: .butt)))
        return m
    }
}

/// Small fixed drawings on the map.
nonisolated enum KaartArt {
    static let personBody = StadSVG.path("M1.5 20v-6.5a4.5 4.5 0 0 1 9 0V20z")
    static let bikeWheels = StadSVG.path("M0.8 10a4.2 4.2 0 1 0 8.4 0a4.2 4.2 0 1 0-8.4 0Z M14.8 10a4.2 4.2 0 1 0 8.4 0a4.2 4.2 0 1 0-8.4 0Z")
    static let bikeFrame = StadSVG.path("M5 10h6l-2-6zM9 4h7l-5 6M16 4l3 6M7 3h4M16 4l.5-2.5H19")

    // Crane over the place under construction (svg 160 × 146).
    static let craneLattice = StadSVG.path("M97 144V22M107 144V22M97 144L107 132L97 120L107 108L97 96L107 84L97 72L107 60L97 48L107 36L97 24")
    static let craneJib = StadSVG.path("M8 18H152M8 25H152M8 25L16 18L24 25L32 18L40 25L48 18L56 25L64 18L72 25L80 18L88 25L96 18M112 18L120 25L128 18L136 25L144 18L152 25")
    static let craneCables = StadSVG.path("M102 2L97 18M102 2L107 18M102 2L20 18M102 2L148 18")
    static let craneWeights = StadSVG.path("M132 26h20v12h-20z M90 140h24v6H90z")
    static let craneCabin = StadSVG.path("M94 26h16v12H94z")
    static let craneWindow = StadSVG.path("M96 28h12v5H96z")
    static let hookLine = StadSVG.path("M22 25V54")
    static let hook = StadSVG.path("M19 54h6v4h-6z")
    static let hookLoad = StadSVG.path("M8 58h28v6H8z")

    // Canal boat (viewBox -6 0 48 16) and river barge (72 × 20).
    static let boatWake = StadSVG.path("M-6 4L3 8L-6 12")
    static let boatHull = StadSVG.path("M2 8C2 3.5 8 2 14 2H28L35 8L28 14H14C8 14 2 12.5 2 8Z")
    static let boatStripe = StadSVG.path("M6 8H31")
    static let boatCabin = StadSVG.path("M12 5h9v6h-9z")
    static let boatFlag = StadSVG.path("M3 6h3v4H3z")
    static let bargeHull = StadSVG.path("M3 10L10 2H68V18H10Z")

    // Ria de postbode (viewBox 70 × 62).
    static let riaWheels = StadSVG.path("M4 50a10 10 0 1 0 20 0a10 10 0 1 0-20 0Z M44 50a10 10 0 1 0 20 0a10 10 0 1 0-20 0Z")
    static let riaFrame = StadSVG.path("M14 50h18l-5-16zM27 34h20l-15 16M47 34l7 16M44 34l2-6h6")
    static let riaBag = StadSVG.path("M50 26h16v12H50z")
    static let riaLetter = StadSVG.path("M53 30h10v4H53z")
    static let riaBody = StadSVG.path("M30 32l6-16M35 18l12 10M33 32l6 12")
    static let riaHead = StadSVG.path("M30.5 10a6.5 6.5 0 1 0 13 0a6.5 6.5 0 1 0-13 0Z")
    static let riaCap = StadSVG.path("M30.5 8a6.5 6.5 0 0 1 13 0h3v2.5h-16z")
}
