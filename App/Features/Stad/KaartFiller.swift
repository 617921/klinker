import SwiftUI

/// The background city: rows of small, muted canal houses packed along the ring between the
/// 62 places, so the map reads as Amsterdam from above. Not tappable; drawn in the static map
/// as a handful of colour groups. Built once.
nonisolated struct KaartFiller: Sendable {
    struct House: Sendable {
        /// Facade, side wall and roof in world units (for the sun shadow).
        var silhouette: Path
        var baseY: CGFloat
        var footprint: CGRect
    }

    var houses: [House] = []
    /// One path per `Gevelkit.facades` colour.
    var bodies: [Path] = Array(repeating: Path(), count: Gevelkit.facades.count)
    var sides: [Path] = Array(repeating: Path(), count: Gevelkit.facades.count)
    var roofs = Path()
    var trims = Path()
    var windows = Path()
    var litWindows = Path()
    var doors = Path()
    /// Every edge of every background house, for the ink.
    var ink = Path()

    static let shared = build()

    /// World units per house viewBox unit (places use 0.39).
    static let scale = 0.18

    private static func build() -> KaartFiller {
        var filler = KaartFiller()
        var rnd = GevelRandom(seed: 9090)
        let radials = [18.0, 54, 90, 126, 162]
        let places = KaartData.places.map { (point: $0.point, half: KaartData.house($0.n).buttonWidth / 2) }
        var count = 0
        for ring in [185.0, 255, 325, 395, 465, 535, 605] {
            let radius = ring + 10
            var theta = 3.0
            while theta < 177 {
                let step = (14.5 + rnd.next() * 4) / radius * 180 / .pi
                defer { theta += step }
                let spot = KaartMapPaths.p(radius, theta)
                if spot.x < 16 || spot.x > 984 { continue }
                if radials.contains(where: { abs($0 - theta) * .pi / 180 * radius < 15 }) { continue }
                if places.contains(where: { abs(spot.x - $0.point.x) < $0.half + 7 && abs(spot.y - $0.point.y) < 40 }) { continue }
                let a = (spot.x - 222) / 98, b = (spot.y - 338) / 80
                if a * a + b * b < 1 { continue }
                // An alley now and then.
                if rnd.next() < 0.04 { continue }
                let colour = min(Gevelkit.facades.count - 1, Int(rnd.next() * Double(Gevelkit.facades.count)))
                let building = KaartBuilding(
                    type: rnd.pick(Gevelkit.streetTypes), width: rnd.pick([62.0, 66, 70, 76]), floors: rnd.pick([1, 2, 2]),
                    color: Gevelkit.facades[colour], door: rnd.pick(Gevelkit.doors), awning: rnd.pick(Gevelkit.awnings),
                    shop: rnd.next() < 0.15, flowers: rnd.next() < 0.3, doorLeft: rnd.next() < 0.5
                )
                let geo = KaartHouseGeometry.make(7000 + count, building)
                count += 1
                let base = geo.viewBox.maxY - 6
                let t = CGAffineTransform(translationX: spot.x, y: spot.y)
                    .scaledBy(x: scale, y: scale)
                    .translatedBy(x: -geo.viewBox.midX, y: -base)
                let body = geo.gevel.body.applying(t)
                let side = geo.side.applying(t)
                let roof = geo.roof.applying(t)
                filler.bodies[colour].addPath(body)
                filler.sides[colour].addPath(side)
                filler.roofs.addPath(roof)
                filler.trims.addPath(geo.gevel.trim.applying(t))
                filler.windows.addPath(geo.gevel.glass.applying(t))
                filler.litWindows.addPath(geo.gevel.lit.applying(t))
                filler.doors.addPath(geo.gevel.door.applying(t))
                filler.ink.addPath(body)
                filler.ink.addPath(side)
                filler.ink.addPath(roof)
                var silhouette = body
                silhouette.addPath(side)
                silhouette.addPath(roof)
                filler.houses.append(House(silhouette: silhouette, baseY: spot.y, footprint: silhouette.boundingRect))
            }
        }
        return filler
    }

    // MARK: Drawing

    func draw(_ ctx: inout GraphicsContext, night: Bool, season: GevelSeason, lean: Double?) {
        if let lean {
            var shadows = Path()
            for house in houses {
                shadows.addPath(house.silhouette.applying(Self.sunShear(lean: lean, baseY: house.baseY)))
            }
            ctx.fill(shadows, with: .color(StadInk.hex(0x1E1E1C, 0.1)))
        }
        let ground: UInt32 = night ? 0x20263A : 0xEDE7D6
        for i in bodies.indices {
            let base = night ? Gevelkit.shade(Gevelkit.facades[i], 0.45) : Gevelkit.facades[i]
            let muted = Self.mix(base, ground, night ? 0.25 : 0.3)
            ctx.fill(sides[i], with: .color(StadInk.hex(Gevelkit.shade(muted, night ? 0.7 : 0.8))))
            ctx.fill(bodies[i], with: .color(StadInk.hex(muted)))
        }
        let winter = season == .winter
        ctx.fill(roofs, with: .color(StadInk.hex(winter ? (night ? 0x6B7186 : 0xEEEEEA) : (night ? 0x2E2A33 : 0x86685A))))
        ctx.fill(trims, with: .color(StadInk.hex(night ? 0x8A8F9E : 0xF4F1EA, night ? 0.5 : 0.85)))
        ctx.fill(windows, with: .color(StadInk.hex(night ? 0x1E2433 : 0x5E6B73)))
        ctx.fill(litWindows, with: .color(StadInk.hex(night ? 0xF6D27A : 0x5E6B73)))
        ctx.fill(doors, with: .color(StadInk.hex(night ? 0x14171F : 0x3A3632)))
        ctx.stroke(ink, with: .color(KaartInk.line(night: night).opacity(0.75)), style: StrokeStyle(lineWidth: 0.5, lineJoin: .round))
    }

    /// Casts a shape onto the ground from its base: squashed back and leaning with the sun
    /// (`lean` −1 morning, to the west; +1 evening, to the east).
    static func sunShear(lean: Double, baseY: CGFloat) -> CGAffineTransform {
        let shear = lean * 0.95
        let squash = 0.42
        return CGAffineTransform(a: 1, b: 0, c: -shear, d: squash, tx: shear * baseY, ty: baseY * (1 - squash))
    }

    static func mix(_ a: UInt32, _ b: UInt32, _ t: Double) -> UInt32 {
        func ch(_ shift: UInt32) -> UInt32 {
            let x = Double((a >> shift) & 0xFF), y = Double((b >> shift) & 0xFF)
            return UInt32(max(0, min(255, (x * (1 - t) + y * t).rounded()))) << shift
        }
        return ch(16) | ch(8) | ch(0)
    }
}
