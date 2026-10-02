import SwiftUI

/// The illustrated canal-ring map (port of StadKaart `paths()` and `extras()`), built once.
nonisolated struct KaartMapPaths: Sendable {
    var canals = Path()
    var streets = Path()
    var radials = Path()
    var rails = Path()
    var water = Path()
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
    var treesDark = Path()
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
        m.canals = SVGPath.parse(canals)

        var streets = ""
        for R in [220.0, 360, 500] {
            streets += "M\(500 - R) 76V96A\(R) \(R) 0 0 0 \(500 + R) 96V76"
        }
        streets += "M-140 96A640 640 0 0 0 1140 96"
        streets += "M500 736V1062M500 880C420 880 330 872 250 900S110 960 40 968M500 836C600 836 700 800 860 782M540 1062C700 1054 850 1060 1000 1052"
        m.streets = SVGPath.parse(streets)

        var radials = "M0 76H1000M500 96V736"
        for t in [18.0, 54, 126, 162] { radials += line(p(120, t), p(660, t)) }
        m.radials = SVGPath.parse(radials)

        var rails = ""
        for t in [18.0, 54, 90, 126, 162] {
            let a = t * .pi / 180, ux = cos(a), uy = sin(a), nx = -uy, ny = ux
            for R in [150.0, 290, 430, 570] {
                for o in [-6.5, 6.5] {
                    let p1 = CGPoint(x: 500 + (R - 14) * ux + o * nx, y: 96 + (R - 14) * uy + o * ny)
                    let p2 = CGPoint(x: 500 + (R + 14) * ux + o * nx, y: 96 + (R + 14) * uy + o * ny)
                    if p1.x > -20 && p1.x < 1020 { rails += line(p1, p2) }
                }
            }
        }
        for R in [150.0, 290, 430] {
            for x in [500 - R, 500 + R] {
                rails += "M\(x - 14) 69.5H\(x + 14)M\(x - 14) 82.5H\(x + 14)"
            }
        }
        m.rails = SVGPath.parse(rails)

        m.water = SVGPath.parse(
            "M0 0H1000V50C900 62 820 44 720 54S560 62 480 52S300 44 200 56S60 52 0 58Z"
                + "M0 1112C150 1100 300 1120 450 1108S760 1102 1000 1104V1200H0Z"
                + "M176 356a22 11 0 1 0 44 0a22 11 0 1 0-44 0Z"
        )
        m.park = SVGPath.parse("M140 338a82 64 0 1 0 164 0a82 64 0 1 0-164 0Z")
        m.parkPath = SVGPath.parse("M160 304C200 282 262 292 292 322S262 396 210 392S150 362 160 304Z")
        m.meadow = SVGPath.parse("M0 495.3A640 640 0 0 0 1000 495.3V1200H0Z")
        for row in 0..<5 {
            for c in 0..<3 {
                let d = rect(590 + Double(c) * 140, 772 + Double(row) * 50, 132, 44)
                if (row + c) % 2 == 0 { m.fieldsA.addPath(d) } else { m.fieldsB.addPath(d) }
            }
        }
        m.ditch = SVGPath.parse("M586 768V1024M726 768V1024M866 768V1024")
        m.sand = SVGPath.parse("M0 1040C120 1030 260 1050 400 1040S540 1034 560 1044V1116H0Z")
        m.dike = SVGPath.parse("M540 1036C700 1026 850 1032 1000 1024V1108H540Z")
        m.runway = SVGPath.parse("M18 692L246 702L245 722L17 712Z")
        m.runwayDash = SVGPath.parse("M30 702.5L236 711.5")
        for (x, y, h) in [(790.0, 12.0, 42.0), (850, 8, 46), (910, 12, 42), (962, 18, 36)] {
            m.jetty.addPath(rect(x, y, 10, h))
        }
        m.mooredA = SVGPath.parse("M806 22q14-12 28 0v26h-28Z")
        m.mooredB = SVGPath.parse("M868 26q12-10 24 0v22h-24Z")

        var shimmer = "M60 24h50M300 18h70M620 30h60M740 16h36M180 1150h60M560 1160h80M860 1140h50"
        for (R, t) in [(150.0, 40.0), (150, 128), (290, 22), (290, 100), (290, 160), (430, 50), (430, 118), (570, 70), (570, 108)] {
            let a = t * .pi / 180
            let q = p(R, t)
            shimmer += "M\(r(q.x + 9 * sin(a))) \(r(q.y - 9 * cos(a)))L\(r(q.x - 9 * sin(a))) \(r(q.y + 9 * cos(a)))"
        }
        m.shimmer = SVGPath.parse(shimmer)

        // Trees: same seeded placement as the prototype (rng 4242).
        var rnd = GevelRandom(seed: 4242)
        let occupied = KaartData.places.map(\.point)
        func inPark(_ x: Double, _ y: Double) -> Bool {
            let a = (x - 222) / 82, b = (y - 338) / 64
            return a * a + b * b < 1
        }
        func okSpot(_ x: Double, _ y: Double) -> Bool {
            if x < 8 || x > 992 || y < 62 || y > 1100 { return false }
            for o in occupied where abs(x - o.x) < 30 && y > o.y - 62 && y < o.y + 14 { return false }
            return true
        }
        var trees = Path(), treesDark = Path()
        func addTree(_ x: Double, _ y: Double, _ rr: Double) {
            treesDark.addPath(dot(x + 1.5, y + 2, rr))
            trees.addPath(dot(x, y, r(rr - 1.4)))
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
        return m
    }
}

/// Small fixed drawings on the map.
nonisolated enum KaartArt {
    static let personBody = SVGPath.parse("M1.5 20v-6.5a4.5 4.5 0 0 1 9 0V20z")
    static let bikeWheels = SVGPath.parse("M0.8 10a4.2 4.2 0 1 0 8.4 0a4.2 4.2 0 1 0-8.4 0Z M14.8 10a4.2 4.2 0 1 0 8.4 0a4.2 4.2 0 1 0-8.4 0Z")
    static let bikeFrame = SVGPath.parse("M5 10h6l-2-6zM9 4h7l-5 6M16 4l3 6M7 3h4M16 4l.5-2.5H19")

    static let outlineHouse = SVGPath.parse("M12 50V31L23 20L34 31V50ZM34 31L43 25V44L34 50M23 20L32 14L43 25")
    static let outlineWide = SVGPath.parse("M9 50V31H39V50ZM39 31L48 25V44L39 50M9 31L18 25H48")
    static let outlineMill = SVGPath.parse("M22 50L25 26H35L38 50ZM23 26Q30 15 37 26")
    static let outlineTower = SVGPath.parse("M25 50L27.5 14H32.5L35 50ZM22 14H38L36 8H24ZM26 32H34")
    static let outlineRing = SVGPath.parse("M10 46a20 7 0 1 0 40 0a20 7 0 1 0-40 0ZM24 46a6 2 0 1 0 12 0a6 2 0 1 0-12 0Z")
    static let outlineBoat = SVGPath.parse("M8 40H52L46 49H14ZM21 40V33H37V40")
    static let baseFlat = SVGPath.parse("M4 50H50L57 40H11Z")
    static let baseDefault = SVGPath.parse("M8 50H48L54 43H14Z")
    static let millSails = SVGPath.parse("M22 22V3M22 22H41M22 22V41M22 22H3M22 3h5v13h-5M41 22v5H28v-5M22 41h-5V28h5M3 22v-5h13v5")

    static func outline(_ kind: KaartOutline) -> Path {
        switch kind {
        case .house: outlineHouse
        case .wide: outlineWide
        case .mill: outlineMill
        case .tower: outlineTower
        case .ring: outlineRing
        case .boat: outlineBoat
        case .flat: Path()
        }
    }

    static func base(_ kind: KaartOutline) -> Path {
        switch kind {
        case .flat: baseFlat
        case .boat: Path()
        default: baseDefault
        }
    }

    // Crane over the place under construction (svg 160 × 146).
    static let craneLattice = SVGPath.parse("M97 144V22M107 144V22M97 144L107 132L97 120L107 108L97 96L107 84L97 72L107 60L97 48L107 36L97 24")
    static let craneJib = SVGPath.parse("M8 18H152M8 25H152M8 25L16 18L24 25L32 18L40 25L48 18L56 25L64 18L72 25L80 18L88 25L96 18M112 18L120 25L128 18L136 25L144 18L152 25")
    static let craneCables = SVGPath.parse("M102 2L97 18M102 2L107 18M102 2L20 18M102 2L148 18")
    static let craneWeights = SVGPath.parse("M132 26h20v12h-20z M90 140h24v6H90z")
    static let craneCabin = SVGPath.parse("M94 26h16v12H94z")
    static let craneWindow = SVGPath.parse("M96 28h12v5H96z")
    static let hookLine = SVGPath.parse("M22 25V54")
    static let hook = SVGPath.parse("M19 54h6v4h-6z")
    static let hookLoad = SVGPath.parse("M8 58h28v6H8z")

    // Canal boat (viewBox -6 0 48 16) and river barge (72 × 20).
    static let boatWake = SVGPath.parse("M-6 4L3 8L-6 12")
    static let boatHull = SVGPath.parse("M2 8C2 3.5 8 2 14 2H28L35 8L28 14H14C8 14 2 12.5 2 8Z")
    static let boatStripe = SVGPath.parse("M6 8H31")
    static let boatCabin = SVGPath.parse("M12 5h9v6h-9z")
    static let boatFlag = SVGPath.parse("M3 6h3v4H3z")
    static let bargeHull = SVGPath.parse("M3 10L10 2H68V18H10Z")

    // Ria de postbode (viewBox 70 × 62).
    static let riaWheels = SVGPath.parse("M4 50a10 10 0 1 0 20 0a10 10 0 1 0-20 0Z M44 50a10 10 0 1 0 20 0a10 10 0 1 0-20 0Z")
    static let riaFrame = SVGPath.parse("M14 50h18l-5-16zM27 34h20l-15 16M47 34l7 16M44 34l2-6h6")
    static let riaBag = SVGPath.parse("M50 26h16v12H50z")
    static let riaLetter = SVGPath.parse("M53 30h10v4H53z")
    static let riaBody = SVGPath.parse("M30 32l6-16M35 18l12 10M33 32l6 12")
    static let riaHead = SVGPath.parse("M30.5 10a6.5 6.5 0 1 0 13 0a6.5 6.5 0 1 0-13 0Z")
    static let riaCap = SVGPath.parse("M30.5 8a6.5 6.5 0 0 1 13 0h3v2.5h-16z")
}
