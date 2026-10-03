import SwiftUI

/// The outline drawn on an empty plot.
nonisolated enum KaartOutline: Sendable {
    case house, wide, mill, tower, ring, boat, flat
}

/// One of the 62 places on the map, in world units (map 1000 × 1200).
nonisolated struct KaartPlace: Identifiable, Equatable, Sendable {
    let n: Int
    let point: CGPoint
    let outline: KaartOutline
    var id: Int { n }
}

/// What stands on a place once it is built (StadKaart `SPEC`).
nonisolated struct KaartBuilding: Sendable {
    enum Kind: Sendable { case gevel, markt, park, tram }
    enum Extra: Sendable { case none, station, flag }

    var kind: Kind = .gevel
    var type: GableType = .trap
    var width: Double = 70
    var floors = 1
    var color: UInt32 = 0x9A5238
    var door: UInt32 = 0x1E1E1C
    var awning: UInt32?
    var shop = false
    var flowers = false
    var doorLeft = false
    var extra: Extra = .none
}

nonisolated enum KaartData {
    static let worldWidth: CGFloat = 1000
    static let worldHeight: CGFloat = 1200
    /// The river bank strip above the map (world y -90...0).
    static let north: CGFloat = 90
    static var contentHeight: CGFloat { worldHeight + north }

    static let hetPlaces: Set<Int> = [1, 6, 7, 11, 14, 16, 17, 21, 22, 26, 28, 31, 35, 42, 46, 48, 49, 51, 54]

    /// "de", "het", or "" for Jouw huis.
    static func article(_ n: Int) -> String {
        n == 3 ? "" : hetPlaces.contains(n) ? "het" : "de"
    }

    /// A point on the canal rings around (500, 96), rounded to 0.1 like the prototype's `P`.
    static func ring(_ r: Double, _ t: Double) -> CGPoint {
        let a = t * .pi / 180
        return CGPoint(x: Gevelkit.r(500 + r * cos(a)), y: Gevelkit.r(96 + r * sin(a)))
    }

    private static let positions: [Int: CGPoint] = [
        1: CGPoint(x: 500, y: 100), 2: CGPoint(x: 420, y: 160), 12: CGPoint(x: 580, y: 160), 5: CGPoint(x: 500, y: 192),
        10: ring(185, 5), 4: ring(185, 36), 6: ring(185, 72), 3: ring(185, 108), 7: ring(185, 144), 13: ring(185, 175),
        17: ring(255, 5), 8: ring(255, 36), 9: ring(255, 72), 15: ring(255, 108), 16: ring(255, 144), 18: ring(255, 175),
        21: ring(325, 5), 20: ring(325, 36), 14: ring(325, 72), 19: ring(325, 108), 22: ring(325, 175),
        29: ring(395, 6), 28: ring(395, 28), 27: ring(395, 44), 25: ring(395, 64), 54: ring(395, 80), 23: ring(395, 100),
        26: ring(395, 116), 30: ring(395, 172),
        40: ring(465, 6), 38: ring(465, 28), 36: ring(465, 44), 33: ring(465, 64), 31: ring(465, 80), 32: ring(465, 100),
        34: ring(465, 116), 37: ring(465, 136), 39: ring(465, 152), 41: ring(465, 174),
        55: ring(535, 32), 51: ring(535, 46), 49: ring(535, 64), 42: ring(535, 80), 43: ring(535, 100), 50: ring(535, 116),
        53: ring(535, 134), 56: ring(535, 148),
        57: ring(605, 80), 58: ring(605, 100),
        11: CGPoint(x: 222, y: 338), 24: CGPoint(x: 905, y: 66), 61: CGPoint(x: 130, y: 38), 59: CGPoint(x: 500, y: 742),
        48: CGPoint(x: 120, y: 666), 35: CGPoint(x: 300, y: 812), 47: CGPoint(x: 160, y: 900), 46: CGPoint(x: 300, y: 1068),
        62: CGPoint(x: 420, y: 962), 52: CGPoint(x: 690, y: 852), 45: CGPoint(x: 880, y: 800), 44: CGPoint(x: 905, y: 1062),
        60: CGPoint(x: 700, y: 1070),
    ]

    private static let outlines: [Int: KaartOutline] = [
        44: .mill, 62: .tower, 59: .ring, 61: .boat, 24: .flat, 46: .flat, 47: .flat, 48: .flat,
        52: .flat, 54: .flat, 60: .flat, 35: .wide,
    ]

    /// All 62 places, back to front (sorted by y).
    static let places: [KaartPlace] = (1...62).map { n in
        let outline: KaartOutline = n > 14 ? (outlines[n] ?? (n % 3 == 0 ? .wide : .house)) : .house
        return KaartPlace(n: n, point: positions[n] ?? CGPoint(x: 500, y: 600), outline: outline)
    }
    .sorted { $0.point.y < $1.point.y }

    static let byNumber: [Int: KaartPlace] = Dictionary(uniqueKeysWithValues: places.map { ($0.n, $0) })

    // MARK: Buildings

    private static let specs: [Int: KaartBuilding] = [
        1: KaartBuilding(type: .lijst, width: 150, floors: 1, color: 0x9A5238, door: 0x1E1E1C, doorLeft: true, extra: .station),
        2: KaartBuilding(type: .hals, width: 70, floors: 1, color: 0xE3D6BC, door: 0x7A1E1E, awning: 0xC8261B, shop: true, flowers: true),
        3: KaartBuilding(type: .trap, width: 66, floors: 2, color: 0x3F5A4A, door: 0x7A1E1E, flowers: true, doorLeft: true),
        4: KaartBuilding(type: .lijst, width: 116, floors: 1, color: 0x5E6B73, door: 0x1E1E1C, awning: 0x2F4B3A, shop: true),
        5: KaartBuilding(kind: .markt),
        6: KaartBuilding(type: .klok, width: 72, floors: 1, color: 0x8C4A3A, door: 0x2F4B3A, awning: 0x2F4B3A, shop: true, flowers: true, doorLeft: true),
        7: KaartBuilding(type: .lijst, width: 100, floors: 2, color: 0x2C2C2A, door: 0x1F3A6B),
        8: KaartBuilding(type: .klok, width: 88, floors: 2, color: 0xC9A15B, door: 0x1F3A6B, doorLeft: true),
        9: KaartBuilding(type: .tuit, width: 66, floors: 2, color: 0xD9CDB4, door: 0x24533F, flowers: true),
        10: KaartBuilding(type: .hals, width: 66, floors: 1, color: 0x6E3A2C, door: 0x24533F, awning: 0x24533F, shop: true, doorLeft: true),
        11: KaartBuilding(kind: .park),
        12: KaartBuilding(kind: .tram),
        13: KaartBuilding(type: .lijst, width: 116, floors: 2, color: 0x7B3F2E, door: 0x1F3A6B, flowers: true, doorLeft: true),
        14: KaartBuilding(type: .trap, width: 100, floors: 2, color: 0xE3D6BC, door: 0x1F3A6B, extra: .flag),
    ]

    /// Places 1–14 come from the prototype; later places get a seeded canal house of their own.
    static func building(_ n: Int) -> KaartBuilding {
        if let spec = specs[n] { return spec }
        var rnd = GevelRandom(seed: n * 977 + 31)
        let type = rnd.pick([GableType.trap, .hals, .hals, .klok, .klok, .tuit, .lijst])
        let width = type == .lijst ? rnd.pick([96.0, 104, 116]) : rnd.pick([62.0, 66, 70, 76, 84])
        return KaartBuilding(
            type: type, width: width, floors: rnd.pick([1, 1, 2]),
            color: rnd.pick(Gevelkit.facades), door: rnd.pick(Gevelkit.doors), awning: rnd.pick(Gevelkit.awnings),
            shop: rnd.next() < 0.3, flowers: rnd.next() < 0.5, doorLeft: rnd.next() < 0.5
        )
    }

    /// The buildings, made once: a place's own landmark if it has one, else its canal house.
    static let houses: [Int: KaartHouseGeometry] = Dictionary(uniqueKeysWithValues: (1...62).map { ($0, make($0)) })

    static func house(_ n: Int) -> KaartHouseGeometry {
        houses[n] ?? make(n)
    }

    private static func make(_ n: Int) -> KaartHouseGeometry {
        if let landmark = KaartLandmarks.make(n) { return KaartHouseGeometry.make(n, landmark: landmark) }
        return KaartHouseGeometry.make(n, building(n))
    }
}

nonisolated struct KaartScaffold: Sendable {
    var poles: Path
    var planks: Path
    var net: Path
}

/// A place's building in 3/4 view: the gevelkit front plus side wall, roof, shadow, extras and
/// scaffolding (port of StadKaart `houseGeom`). Units: the house's own viewBox.
nonisolated struct KaartHouseGeometry: Sendable {
    var gevel: GevelGeometry
    var side = Path()
    var roof = Path()
    var shadow = Path()
    var spA = Path()
    var spB = Path()
    var spC = Path()
    var viewBox: CGRect
    /// Sprite size in world units (viewBox × KS).
    var spriteSize: CGSize
    /// Tap target width in world units (height is always 70).
    var buttonWidth: CGFloat
    /// Sprite top-left inside the tap target (world units).
    var spriteOrigin: CGPoint
    /// Top-left of the 22-unit badge and the 20-unit "!" inside the tap target.
    var badge: CGPoint
    var bang: CGPoint
    var scaffoldFull: KaartScaffold?
    var scaffoldPart: KaartScaffold?
    var spFills: [UInt32]
    var awning: UInt32
    var color: UInt32
    var door: UInt32
    var roofColor: UInt32
    /// The place's own building, when it has one (then `gevel`, `side` and `roof` are empty).
    var landmark: KaartLandmark? = nil
    /// The front door inside the tap target (world units): ribbon and padlock while locked.
    var doorFrame: CGRect = .zero

    /// Everything solid in viewBox units, for the sun shadow.
    var silhouette: Path {
        if let landmark { return landmark.silhouette }
        var path = gevel.body
        for part in [side, roof, spA, spB] { path.addPath(part) }
        return path
    }

    /// A place drawn with the building kit: same frame rules as the canal houses.
    static func make(_ n: Int, landmark art: KaartLandmark) -> KaartHouseGeometry {
        let r = Gevelkit.r
        let KS = 0.39
        let bounds = art.bounds.isNull ? CGRect(x: 0, y: -100, width: 70, height: 100) : art.bounds
        let vx = (bounds.minX - 6).rounded(.down)
        let vy = (bounds.minY - 6).rounded(.down)
        let vw = (bounds.maxX + 6 - vx).rounded(.up)
        let vh = (max(0, bounds.maxY) + 6 - vy).rounded(.up)
        let sw = r(vw * KS), sh = r(vh * KS)
        let bw = max(72, (sw + 6).rounded(.up))
        let svgLeft = r(bw / 2 - (bounds.midX - vx) * KS), svgTop = r(58 + vy * KS)
        func local(_ p: CGPoint) -> CGPoint { CGPoint(x: svgLeft + (p.x - vx) * KS, y: svgTop + (p.y - vy) * KS) }
        let front = art.front == .zero ? bounds : art.front
        let sign = local(art.signAt ?? CGPoint(x: front.minX - 6, y: front.minY + min(40, front.height * 0.35)))
        let bang = local(CGPoint(x: front.maxX + 15, y: front.minY - 22))

        func scaffold(full: Bool) -> KaartScaffold {
            let D = 30.0, DY = 17.0
            let x0 = front.minX, x1 = front.maxX, W = front.width
            let top = full ? front.minY - 6 : front.minY + front.height * 0.45
            let xs = [x0 - 6, front.midX, x1 + 6]
            var poles = GevelPen()
            var planks = Path()
            for x in xs { poles.M(r(x), 0); poles.V(r(top)) }
            poles.M(x1 + D + 3, -DY)
            poles.V(r(top - DY))
            var prev = 0.0, i = 0
            var y = -32.0
            while y > top + 6 {
                planks.addPath(Gevelkit.rect(x0 - 11, y, W + 22, 5))
                var p = GevelPen()
                p.M(x1 + 11, y); p.L(x1 + D + 6, y - DY); p.v(5); p.L(x1 + 11, y + 5); p.Z()
                planks.addPath(p.path)
                let a = i % 2
                poles.M(r(xs[a]), r(prev))
                poles.L(r(xs[a + 1]), r(y))
                prev = y
                i += 1
                y -= 34
            }
            planks.addPath(Gevelkit.rect(x0 - 11, top, W + 22, 5))
            let net = full ? Gevelkit.rect(x0 - 8, top + 5, W + 16, max(0, -top - 40)) : Path()
            return KaartScaffold(poles: poles.path, planks: planks, net: net)
        }

        var shadow = GevelPen()
        shadow.M(bounds.minX - 2, 1); shadow.H(bounds.maxX + 10); shadow.L(bounds.maxX, -14); shadow.H(bounds.minX + 6); shadow.Z()

        let door = art.doorRect == .zero ? CGRect(x: front.midX - 7, y: -24, width: 14, height: 24) : art.doorRect
        let d0 = local(door.origin)
        return KaartHouseGeometry(
            gevel: GevelGeometry(size: .zero, topY: 0), shadow: shadow.path,
            viewBox: CGRect(x: vx, y: vy, width: vw, height: vh),
            spriteSize: CGSize(width: sw, height: sh),
            buttonWidth: bw,
            spriteOrigin: CGPoint(x: svgLeft, y: svgTop),
            badge: CGPoint(x: r(sign.x), y: r(sign.y)),
            bang: CGPoint(x: r(bang.x - 10), y: r(bang.y - 10)),
            scaffoldFull: scaffold(full: true),
            scaffoldPart: scaffold(full: false),
            spFills: [0x1E1E1C, 0x1E1E1C, 0x1E1E1C], awning: art.awning, color: art.wall, door: art.door,
            roofColor: art.roof, landmark: art,
            doorFrame: CGRect(x: d0.x, y: d0.y, width: door.width * KS, height: door.height * KS)
        )
    }

    static func make(_ n: Int, _ s: KaartBuilding) -> KaartHouseGeometry {
        let r = Gevelkit.r
        let rect = Gevelkit.rect
        let dot = Gevelkit.dot
        let D = 30.0, DY = 17.0, x0 = 3.0
        // Places stand out over the background houses: 1.3× the prototype size.
        let KS = s.kind == .gevel ? 0.39 : 0.46
        var g = GevelGeometry(size: .zero, topY: 0)
        var W = 0.0, B = 0.0, x1 = 0.0, cx = 0.0, yb = 0.0, topY = 0.0, wallTop = 0.0
        var hasSide = false
        var side = Path(), roof = Path(), spA = Path(), spB = Path(), spC = Path()
        var badgeAt = CGPoint.zero, bangAt = CGPoint.zero

        switch s.kind {
        case .markt:
            W = 130; B = 100; x1 = 3 + W; cx = 3 + W / 2; yb = 48; topY = 46; wallTop = 48
            for i in 0..<3 {
                let x = 6 + Double(i) * 42, w = 36.0
                spA.addPath(rect(x, 76, w, 24))
                g.trim.addPath(rect(x + 1, 50, 2.5, 50))
                g.trim.addPath(rect(x + w - 3.5, 50, 2.5, 50))
                var a = GevelPen()
                a.M(x - 3, 62); a.L(x + w + 3, 62); a.L(x + w - 1, 48); a.L(x + 1, 48); a.Z()
                g.awning.addPath(a.path)
                for j in 0..<4 {
                    var st = GevelPen()
                    st.M(x + 2 + Double(j) * 8.5, 48.5); st.h(4); st.l(0.6, 13); st.h(-4.8); st.Z()
                    g.stripes.addPath(st.path)
                }
                spB.addPath(dot(x + 8, 73, 3.5)); spB.addPath(dot(x + 18, 72.5, 3.5)); spB.addPath(dot(x + 28, 73, 3.5))
                spC.addPath(dot(x + 13, 70, 3)); spC.addPath(dot(x + 23, 69.5, 3))
            }
            badgeAt = CGPoint(x: 4, y: 46)
            bangAt = CGPoint(x: x1, y: 48)

        case .park:
            W = 100; B = 104; x1 = 103; cx = 53; yb = 56; topY = 12; wallTop = 56
            spA = StadSVG.path("M10 92H96L102 104H4Z")
            for x in [14.0, 31, 50, 69, 86] { g.trim.addPath(rect(x, 58, 3, 34)) }
            g.trim.addPath(rect(2, 56, 99, 4))
            g.deco.addPath(rect(12, 80, 82, 2.5))
            g.deco.addPath(dot(53, 22, 3))
            g.deco.addPath(StadSVG.path("M52.4 12h1.2v10h-1.2Z"))
            spB = StadSVG.path("M2 58L53 26L104 58Z")
            for (x, y) in [(14.0, 63.0), (30, 64.5), (46, 65), (62, 65), (78, 64.5), (94, 63)] { spC.addPath(dot(x, y, 2.5)) }
            badgeAt = CGPoint(x: 0, y: 50)
            bangAt = CGPoint(x: x1, y: 40)

        case .tram:
            W = 118; B = 100; x1 = 121; cx = 62; yb = 44; topY = 22; wallTop = 44
            g.awning = rect(104, 26, 4, 74)
            g.glass = rect(12, 49, 68, 32)
            g.trim.addPath(rect(8, 49, 3, 51)); g.trim.addPath(rect(81, 49, 3, 51)); g.trim.addPath(rect(12, 64, 68, 2))
            g.deco.addPath(rect(18, 84, 56, 4)); g.deco.addPath(rect(22, 88, 2.5, 12)); g.deco.addPath(rect(68, 88, 2.5, 12))
            spA = dot(106, 34, 9)
            spB = rect(6, 42, 80, 7)
            spB.addPath(StadSVG.path("M6 42L14 36H92L86 42Z"))
            spC = rect(102, 30, 8, 2.5)
            spC.addPath(rect(104.8, 30, 2.4, 9))
            badgeAt = CGPoint(x: 6, y: 40)
            bangAt = CGPoint(x: x1, y: 30)

        case .gevel:
            var rnd = GevelRandom(seed: n * 131 + 7)
            var lit: [Bool] = []
            for _ in 0..<24 { lit.append(rnd.next() < 0.5) }
            let spec = HouseSpec(
                type: s.type, width: s.width, floors: s.floors,
                cols: s.width >= 96 ? 4 : s.width >= 76 ? 3 : 2, doorLeft: s.doorLeft, shop: s.shop,
                flowers: s.flowers, lit: lit, color: s.color, door: s.door, awning: s.awning ?? 0xC8261B, stone: 0
            )
            g = Gevelkit.gevel(spec)
            hasSide = true
            W = s.width; B = g.size.height; x1 = 3 + W; cx = 3 + W / 2
            yb = B - (60 + 34 * Double(s.floors)); topY = g.topY
            wallTop = s.type == .lijst ? yb - 28 : yb
            var sd = GevelPen()
            sd.M(x1, B); sd.L(x1 + D, B - DY); sd.V(r(wallTop - DY)); sd.L(x1, r(wallTop)); sd.Z()
            side = sd.path
            var rf = GevelPen()
            if s.type == .lijst {
                rf.M(x0 - 3, r(wallTop)); rf.L(x0 - 3 + D, r(wallTop - DY)); rf.H(x1 + 3 + D); rf.L(x1 + 3, r(wallTop)); rf.Z()
            } else {
                rf.M(r(cx), r(topY)); rf.L(r(cx + D), r(topY - DY)); rf.L(x1 + D, r(yb - DY)); rf.L(x1, r(yb)); rf.Z()
            }
            roof = rf.path
            switch s.extra {
            case .station:
                let tw = 20.0, ty = wallTop - 30
                spA = rect(x0 - 5, ty, tw, B - ty)
                spA.addPath(rect(x1 + 5 - tw, ty, tw, B - ty))
                var towers = GevelPen()
                towers.M(x0 - 8, ty); towers.L(x0 - 5 + tw / 2, ty - 26); towers.L(x0 - 2 + tw, ty); towers.Z()
                towers.M(x1 + 2 - tw, ty); towers.L(x1 + 5 - tw / 2, ty - 26); towers.L(x1 + 8, ty); towers.Z()
                spB = towers.path
                spC = dot(x0 - 5 + tw / 2, ty + 14, 6)
                spC.addPath(dot(x1 + 5 - tw / 2, ty + 14, 6))
                g.deco.addPath(rect(x0 - 5 + tw / 2 - 0.6, ty + 9, 1.2, 5))
                g.deco.addPath(rect(x1 + 5 - tw / 2 - 0.6, ty + 9, 1.2, 5))
                topY = ty - 26
            case .flag:
                g.deco.addPath(rect(cx - 0.8, topY - 36, 1.6, 37))
                spA = rect(cx + 0.8, topY - 36, 24, 5)
                spB = rect(cx + 0.8, topY - 31, 24, 5)
                spC = rect(cx + 0.8, topY - 26, 24, 5)
                topY -= 38
            case .none:
                break
            }
            badgeAt = CGPoint(x: x0, y: yb)
            bangAt = CGPoint(x: x1 + D * 0.5, y: yb - 22)
        }

        let vx = -6.0
        let topEff = min(topY, wallTop) - (hasSide ? DY : 0)
        let vy = (topEff - 6).rounded(.down)
        let vw = (x1 + (hasSide ? D : 0) + 10 - vx).rounded(.up)
        let vh = (B + 6 - vy).rounded(.up)
        let gx = cx + (hasSide ? D / 2 : 0)
        let sw = r(vw * KS), sh = r(vh * KS)
        let bw = max(72, (sw + 6).rounded(.up))
        let svgLeft = r(bw / 2 - (gx - vx) * KS), svgTop = r(58 - (B - vy) * KS)

        func scaffold(full: Bool) -> KaartScaffold {
            let top = full ? topY + 44 : yb - 10
            let xs = [x0 - 6, cx, x1 + 6]
            var poles = GevelPen()
            var planks = Path()
            for x in xs { poles.M(r(x), B); poles.V(r(top)) }
            poles.M(x1 + D + 3, B - DY)
            poles.V(r(max(top, yb - 10) - DY))
            var prev = B, i = 0
            var y = B - 32
            while y > top + 6 {
                planks.addPath(rect(x0 - 11, y, W + 22, 5))
                var p = GevelPen()
                p.M(x1 + 11, y); p.L(x1 + D + 6, y - DY); p.v(5); p.L(x1 + 11, y + 5); p.Z()
                planks.addPath(p.path)
                let a = i % 2
                poles.M(r(xs[a]), r(prev))
                poles.L(r(xs[a + 1]), r(y))
                prev = y
                i += 1
                y -= 34
            }
            planks.addPath(rect(x0 - 11, top, W + 22, 5))
            let net = full ? rect(x0 - 8, top + 5, W + 16, max(0, B - top - 40)) : Path()
            return KaartScaffold(poles: poles.path, planks: planks, net: net)
        }

        var shadow = GevelPen()
        if hasSide {
            shadow.M(x0 - 2, B + 1); shadow.H(x1 + D + 12); shadow.L(x1 + D + 2, B - DY); shadow.H(x1); shadow.Z()
        } else {
            shadow.M(x0 - 2, B + 2); shadow.H(x1 + 8); shadow.L(x1 + 2, B - 8); shadow.H(x0 + 4); shadow.Z()
        }

        let color = s.color
        let spFills: [UInt32]
        switch (s.kind, s.extra) {
        case (.markt, _): spFills = [0x6B4A2E, 0xF2711C, 0x5E8C45]
        case (.park, _): spFills = [0xD9CDB4, 0x2F4B3A, 0xF2711C]
        case (.tram, _): spFills = [0xF6D27A, 0x1E1E1C, 0x1E1E1C]
        case (_, .station): spFills = [Gevelkit.shade(color, 0.86), 0x2C2C2A, 0xEFEBE2]
        case (_, .flag): spFills = [0xAE1C28, 0xFFFFFF, 0x21468B]
        default: spFills = [0x1E1E1C, 0x1E1E1C, 0x1E1E1C]
        }
        let awning: UInt32 = s.kind == .markt ? 0xC8261B : s.kind == .tram ? 0x2B3A33 : (s.awning ?? 0xC8261B)
        func doorFrame(_ door: Path) -> CGRect {
            let d = door.boundingRect
            guard !d.isNull, d.width > 0 else { return CGRect(x: bw / 2 - 3, y: 50, width: 6, height: 8) }
            return CGRect(x: svgLeft + (d.minX - vx) * KS, y: svgTop + (d.minY - vy) * KS, width: d.width * KS, height: d.height * KS)
        }

        return KaartHouseGeometry(
            gevel: g, side: side, roof: roof, shadow: shadow.path, spA: spA, spB: spB, spC: spC,
            viewBox: CGRect(x: vx, y: vy, width: vw, height: vh),
            spriteSize: CGSize(width: sw, height: sh),
            buttonWidth: bw,
            spriteOrigin: CGPoint(x: svgLeft, y: svgTop),
            badge: CGPoint(x: r(svgLeft + (badgeAt.x - vx) * KS - 11), y: r(svgTop + (badgeAt.y - vy) * KS - 11)),
            bang: CGPoint(x: r(svgLeft + (bangAt.x - vx) * KS - 10), y: r(svgTop + (bangAt.y - vy) * KS - 10)),
            scaffoldFull: hasSide ? scaffold(full: true) : nil,
            scaffoldPart: hasSide ? scaffold(full: false) : nil,
            spFills: spFills, awning: awning, color: color, door: s.door,
            roofColor: s.type == .lijst && s.kind == .gevel ? 0x6E6B64 : 0x5B3328,
            doorFrame: doorFrame(g.door)
        )
    }
}
