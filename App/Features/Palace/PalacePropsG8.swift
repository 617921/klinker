import SwiftUI

/// Routes the g8 props (allotment, town hall square, roundabout, dike, ferry, lookout tower) so
/// `PalacePropView` needs one line for them, and holds the little drawing helpers they share.
enum G8Props {
    static func draw(_ kind: PalacePropKind, _ pen: PropPen, _ p: PalacePropParams) {
        switch kind {
        case .g8Shed: G8Garden.shed(pen, p)
        case .g8Greenhouse: G8Garden.greenhouse(pen, p)
        case .g8Clubhouse: G8Garden.clubhouse(pen, p)
        case .g8Plot: G8Garden.plot(pen, p)
        case .g8Weeds: G8GardenWork.weeds(pen, p)
        case .g8Gardener: G8GardenWork.gardener(pen, p)
        case .g8LayPath: G8GardenWork.layPath(pen, p)
        case .g8Sowing: G8GardenWork.sowing(pen, p)
        case .g8SoilCut: G8Garden.soilCut(pen, p)
        case .g8SeedPacket: G8GardenWork.seedPacket(pen, p)
        case .g8Fertile: G8Garden.fertile(pen, p)
        case .g8PollingStation: G8Square.pollingStation(pen, p)
        case .g8ElectionBoard: G8Square.electionBoard(pen, p)
        case .g8PartyStand: G8Square.partyStand(pen, p)
        case .g8Cage: G8Square.cage(pen, p)
        case .g8Banner: G8Square.banner(pen, p)
        case .g8March: G8SquarePeople.march(pen, p)
        case .g8Mayor: G8SquarePeople.mayor(pen, p)
        case .g8PollCard: G8SquarePeople.pollCard(pen, p)
        case .g8Ballot: G8SquarePeople.ballot(pen, p)
        case .g8Megaphone: G8SquarePeople.megaphone(pen, p)
        case .g8Equal: G8SquarePeople.equal(pen, p)
        case .g8TrafficLight: G8Street.trafficLight(pen, p)
        case .g8TrafficSign: G8Street.trafficSign(pen, p)
        case .g8ExitSign: G8Street.exitSign(pen, p)
        case .g8Pedestrian: G8Street.pedestrian(pen, p)
        case .g8KerbCross: G8Street.kerbCross(pen, p)
        case .g8Zebra: G8Street.zebra(pen, p)
        case .g8Overview: G8Street.overview(pen, p)
        case .g8RingTraffic: G8Traffic.ring(pen, p)
        case .g8GiveWay: G8Traffic.giveWay(pen, p)
        case .g8Overtake: G8Traffic.overtake(pen, p)
        case .g8Fine: G8Traffic.fine(pen, p)
        case .g8Storm: G8Water.storm(pen, p)
        case .g8FloodedFarm: G8Water.floodedFarm(pen, p)
        case .g8Gauge: G8Water.gauge(pen, p)
        case .g8RisingWater: G8Water.rising(pen, p)
        case .g8Dike: G8Water.dike(pen, p)
        case .g8PumpStation: G8Polder.pumpStation(pen, p)
        case .g8LowLand: G8Polder.lowLand(pen, p)
        case .g8RainGauge: G8Polder.rainGauge(pen, p)
        case .g8InfoBoard: G8Polder.infoBoard(pen, p)
        case .g8Umbrella: G8Polder.umbrella(pen, p)
        case .g8Sandbags: G8Polder.sandbags(pen, p)
        default: break
        }
    }

    // MARK: Shared helpers

    /// A round badge: a green disc with a white tick (`ok`) or a red disc with a white cross.
    static func badge(_ f: PropPen, _ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat, ok: Bool) {
        f.dot(cx, cy, r + 1.2, 0xFFFDF6)
        f.dot(cx, cy, r, ok ? 0x1E7A4C : 0xC8261B)
        let k = r * 0.42
        if ok {
            f.svgLine("M\(cx - k * 1.1) \(cy + k * 0.05)L\(cx - k * 0.25) \(cy + k * 0.9)L\(cx + k * 1.15) \(cy - k * 0.85)", 0xFFFFFF, r * 0.3)
        } else {
            f.svgLine("M\(cx - k) \(cy - k)L\(cx + k) \(cy + k)M\(cx + k) \(cy - k)L\(cx - k) \(cy + k)", 0xFFFFFF, r * 0.3)
        }
    }

    /// A straight arrow from `a` to `b` with a filled head.
    static func arrow(_ f: PropPen, _ a: CGPoint, _ b: CGPoint, _ hex: UInt32, _ width: CGFloat, head: CGFloat? = nil) {
        let len = max(0.1, hypot(b.x - a.x, b.y - a.y))
        let (ux, uy) = ((b.x - a.x) / len, (b.y - a.y) / len)
        let h = head ?? width * 2.6
        f.line(a.x, a.y, b.x - ux * h * 0.6, b.y - uy * h * 0.6, hex, width)
        f.svg("M\(b.x) \(b.y)L\(b.x - ux * h - uy * h * 0.62) \(b.y - uy * h + ux * h * 0.62)L\(b.x - ux * h + uy * h * 0.62) \(b.y - uy * h - ux * h * 0.62)Z", hex)
    }

    /// An arrow head pointing along (dx, dy) with its tip at `tip` (for curved arrows).
    static func head(_ f: PropPen, tip: CGPoint, dx: CGFloat, dy: CGFloat, _ size: CGFloat, _ hex: UInt32) {
        let len = max(0.1, hypot(dx, dy))
        let (ux, uy) = (dx / len, dy / len)
        f.svg("M\(tip.x) \(tip.y)L\(tip.x - ux * size - uy * size * 0.62) \(tip.y - uy * size + ux * size * 0.62)L\(tip.x - ux * size + uy * size * 0.62) \(tip.y - uy * size - ux * size * 0.62)Z", hex)
    }

    /// A pen turned by `degrees` (clockwise) around `center`, which becomes its origin.
    static func turned(_ f: PropPen, _ center: CGPoint, _ degrees: Double) -> PropPen {
        var c = f.ctx
        c.translateBy(x: center.x, y: center.y)
        c.rotate(by: .degrees(degrees))
        return PropPen(ctx: c, size: f.size)
    }

    /// A pen mirrored left–right inside its own width (figures facing left).
    static func mirrored(_ f: PropPen) -> PropPen {
        var c = f.ctx
        c.translateBy(x: f.size.width, y: 0)
        c.scaleBy(x: -1, y: 1)
        return PropPen(ctx: c, size: f.size)
    }

    /// A five-pointed star centred on (cx, cy).
    static func star(_ f: PropPen, _ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat, _ hex: UInt32) {
        f.svg(PalacePeople.star(cx: cx, cy: cy, r: r), hex)
    }

    /// A soft shadow on the ground.
    static func shadow(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat = 6) {
        f.oval(x, y, w, h, 0x1E1E1C, 0.15)
    }
}
