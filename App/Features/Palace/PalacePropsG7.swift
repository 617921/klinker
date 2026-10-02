import SwiftUI

/// Draws the g7 props (harbour, windmill, farm, beach, campsite, airport), so `PalacePropView`
/// needs one line for them. Each prop is described at its case in `PalacePropKind`.
enum G7Props {
    static func draw(_ kind: PalacePropKind, _ pen: PropPen, _ p: PalacePropParams) {
        switch kind {
        case .g7Ship: G7HarbourProps.ship(pen, p)
        case .g7Lock: G7HarbourProps.lock(pen, p)
        case .g7Sailboat: G7HarbourProps.sailboat(pen, p)
        case .g7SeasickBoat: G7HarbourProps.seasickBoat(pen, p)
        case .g7Bollard: G7HarbourProps.bollard(pen, p)
        case .g7Goods: G7HarbourProps.goods(pen, p)
        case .g7Truck: G7HarbourProps.truck(pen, p)
        case .g7Signpost: G7HarbourProps.signpost(pen, p)
        case .g7Worker: G7People.workers(pen, p)
        case .g7Customs: G7People.customs(pen, p)
        case .g7MillSails: G7MillProps.sails(pen, p)
        case .g7Wheat: G7MillProps.wheat(pen, p)
        case .g7Shield: G7MillProps.shield(pen, p)
        case .g7Dancers: G7MillPeople.dancers(pen, p)
        case .g7Workbench: G7MillProps.workbench(pen, p)
        case .g7Millstones: G7MillProps.millstones(pen, p)
        case .g7Wind: G7MillProps.wind(pen, p)
        case .g7Hands: G7MillPeople.hands(pen, p)
        case .g7DutchSet: G7MillPeople.dutchSet(pen, p)
        case .g7Barn: G7FarmProps.barn(pen, p)
        case .g7Livestock: G7FarmAnimals.livestock(pen, p)
        case .g7Meadow: G7FarmProps.meadow(pen, p)
        case .g7Fields: G7FarmProps.fields(pen, p)
        case .g7Milking: G7FarmAnimals.milking(pen, p)
        case .g7Feeding: G7FarmAnimals.feeding(pen, p)
        case .g7Dairy: G7FarmProps.dairy(pen, p)
        case .g7FarmStall: G7FarmProps.farmStall(pen, p)
        case .g7Tractor: G7FarmProps.tractor(pen, p)
        case .g7Wave: G7BeachProps.wave(pen, p)
        case .g7Sunscreen: G7BeachProps.sunscreen(pen, p)
        case .g7BeachCafe: G7BeachProps.beachCafe(pen, p)
        case .g7Lifeguard: G7BeachProps.lifeguard(pen, p)
        case .g7Current: G7BeachProps.current(pen, p)
        case .g7Jellyfish: G7BeachProps.jellyfish(pen, p)
        case .g7Promenade: G7BeachProps.promenade(pen, p)
        case .g7Beachgoer: G7BeachPeople.beachgoer(pen, p)
        case .g7Windscreen: G7BeachPeople.windscreen(pen, p)
        case .g7Pitch: G7CampProps.pitch(pen, p)
        case .g7Washblock: G7CampProps.washblock(pen, p)
        case .g7SleepingBag: G7CampProps.sleepingBag(pen, p)
        case .g7TentPeg: G7CampProps.tentPeg(pen, p)
        case .g7Campfire: G7CampProps.campfire(pen, p)
        case .g7PostBoard: G7CampProps.postBoard(pen, p)
        case .g7AirBed: G7CampProps.airBed(pen, p)
        case .g7Tent: G7CampTents.tent(pen, p)
        case .g7Outhouse: G7CampTents.outhouse(pen, p)
        case .g7FlightScreen: G7AirportProps.flightScreen(pen, p)
        case .g7BoardingPass: G7AirportProps.boardingPass(pen, p)
        case .g7CabinCase: G7AirportProps.cabinCase(pen, p)
        case .g7PassportBooth: G7AirportProps.passportBooth(pen, p)
        case .g7SecurityArch: G7AirportProps.securityArch(pen, p)
        case .g7Destination: G7AirportViews.destination(pen, p)
        case .g7Aisle: G7AirportViews.aisle(pen, p)
        case .g7Plane: G7AirportViews.plane(pen, p)
        default: break
        }
    }
}

/// People at work for the g7 places, built like `PalaceFigures.person` (64 × 114, facing right):
/// sailors, port workers in high-vis, a farmer, a miller, a customs officer.
enum G7People {
    typealias Look = PalaceFigures.Look

    enum Hat { case none, sailor, hardHat, flatCap, peaked, straw }

    /// Legs, coat, back arm, head, hair and hat of a standing person in a 64 × 114 box. The front
    /// arm is left to the caller (shoulder at about (31, 42)).
    static func body(_ f: PropPen, skin: UInt32, hair: UInt32, coat: UInt32, trousers: UInt32, hat: Hat,
                     shoes: UInt32 = 0x2E2117, shadow: Bool = true) {
        let dark = PalaceInk.shade(coat, 0.78)
        if shadow { f.oval(6, 106, 56, 6, 0x1E1E1C, 0.16) }
        f.svgLine("M17 84V104M27 84V104", trousers, 5)
        f.svg("M12 103H21V108H12Z M23 103H32V108H23Z", shoes)
        f.svg("M9 88L10.5 44C11.5 36 15.5 32 22 32C28.5 32 32.5 36 33.5 44L35 88Z", coat)
        f.svgLine("M13 42C10 52 10 62 12 70", dark, 6)
        f.dot(12.5, 72, 3.1, skin)
        f.dot(22, 19, 11, skin)
        f.svg("M11 18C10 10 15 6 22 6C29 6 34 10 33 18C31 13 27 11.5 22 11.5C17 11.5 13 13 11 18Z", hair)
        f.dot(28, 19.5, 1.3, 0x2E2117)
        hatShape(f, hat)
    }

    static func hatShape(_ f: PropPen, _ hat: Hat) {
        switch hat {
        case .none: break
        case .sailor:
            f.svg("M10.5 12.5Q11 4 22 4Q33 4 33.5 12.5Z", 0xFFFDF6)
            f.rect(10.5, 10.5, 23, 3.4, 0x1F3A6B, radius: 1)
        case .hardHat:
            f.svg("M11 13Q11 2.5 22 2.5Q33 2.5 33 13Z", 0xFAC775)
            f.rect(8.5, 12, 27, 3.2, 0xE0A93A, radius: 1.6)
            f.svgLine("M22 3V12", 0xE0A93A, 1.4)
        case .flatCap:
            f.svg("M10.5 14Q10.5 4.5 22 4.5Q31 4.5 33 10.5L39 12.5Q38 14.5 33 14Z", 0x5E6B73)
            f.svgLine("M12 13.5H33", 0x3E4C55, 1)
        case .peaked:
            f.rect(11, 5, 22, 8.5, 0x1F3A6B, radius: 2)
            f.rect(11, 11, 22, 2.6, 0xC9A15B)
            f.svg("M27 13H39Q38 15.5 34 15.5H27Z", 0x1E1E1C)
            f.dot(22, 8.6, 1.8, 0xC9A15B)
        case .straw:
            f.oval(5, 10, 34, 6, 0xE8D6A8)
            f.svg("M13 13Q13 3 22 3Q31 3 31 13Z", 0xE8D6A8)
            f.rect(13, 9.5, 18, 2.6, 0xC8261B)
        }
    }

    // MARK: Workers

    /// `count` workers (1–3) in a row, each a little behind the one in front. `accessory` sets the
    /// outfit; `text` puts a small board on a post beside them.
    static func workers(_ pen: PropPen, _ p: PalacePropParams) {
        let n = max(1, min(p.count ?? 1, 3))
        let step: CGFloat = 30
        let width = 64 + step * CGFloat(n - 1)
        let f = pen.fitted(CGSize(width: width + (p.text != nil ? 40 : 0), height: 114))
        if let text = p.text {
            let x = width + 18
            f.oval(x - 8, 108, 16, 4, 0x1E1E1C, 0.15)
            f.rect(x - 2, 44, 4, 66, 0x6B4A2E)
            let board = CGRect(x: x - 21, y: 26, width: 42, height: 32)
            f.rect(board, 0xFFFDF6, radius: 2)
            f.stroke(Path(roundedRect: board.insetBy(dx: 1.5, dy: 1.5), cornerRadius: 1.5), 0x1E7A4C, 1.4)
            let parts = text.split(separator: " ", maxSplits: 1).map(String.init)
            f.text(parts[0], PropFont.heavy(11), 0x1E7A4C, at: CGPoint(x: x, y: 37), maxWidth: 38)
            if parts.count > 1 { f.text(parts[1], PropFont.demi(9), 0x1E7A4C, at: CGPoint(x: x, y: 50), maxWidth: 38) }
        }
        for i in 0..<n {
            let w = f.within(CGRect(x: CGFloat(i) * step, y: 0, width: 64, height: 114))
            worker(w, Look.at((p.variant ?? 0) + i * 3), outfit: p.accessory ?? "vest")
        }
    }

    /// One worker in an outfit: "sailor", "vest" (port worker), "farmer" (pitchfork), "miller" (flour sack).
    static func worker(_ f: PropPen, _ v: Look, outfit: String) {
        switch outfit {
        case "sailor":
            body(f, skin: v.skin, hair: v.hair, coat: 0xFFFDF6, trousers: 0x1F3A6B, hat: .sailor)
            for y in stride(from: CGFloat(46), through: 82, by: 7) { f.rect(10.5, y, 23.5, 3, 0x2F5BD3) }
            f.svg("M15 33L22 44L29 33Z", 0x1F3A6B)
            f.svg("M20 42L22 46L24 42Z", 0xC8261B)
        case "farmer":
            body(f, skin: v.skin, hair: v.hair, coat: 0xC8261B, trousers: 0x2F5BD3, hat: .flatCap, shoes: 0x2F4337)
            f.svg("M13 52H33L34.5 88H10Z", 0x2F5BD3)
            f.svgLine("M15 52L15 34M30 52L29 34", 0x2F5BD3, 2.6)
            f.svgLine("M17 84V104M27 84V104", 0x2F5BD3, 5.5)
            f.svg("M13 92H21V108H12Z M23 92H31V108H23Z", 0x2F4337)
        case "miller":
            body(f, skin: v.skin, hair: v.hair, coat: 0x8C6A4A, trousers: 0x6B4A2E, hat: .flatCap)
            f.svg("M12.5 44H31.5L34 92H10Z", 0xF4F1EA)
            f.svgLine("M14 44L22 34L30 44", 0xF4F1EA, 1.6)
            f.dot(17, 60, 1.4, 0xD3D1C7)
            f.dot(26, 72, 1.6, 0xD3D1C7)
            f.dot(20, 82, 1.2, 0xD3D1C7)
        default:
            body(f, skin: v.skin, hair: v.hair, coat: 0x3E4C55, trousers: 0x1F3A6B, hat: .hardHat)
            f.svg("M11 44C12 37 15.5 33 19 32.5V62H10.5Z M33 44C32 37 28.5 33 25 32.5V62H33.5Z", 0xF2711C)
            f.rect(10.6, 50, 9, 3.2, 0xE3E1D8)
            f.rect(25, 50, 8.6, 3.2, 0xE3E1D8)
            f.rect(10.4, 62, 23.4, 4, 0xF2711C)
        }
        switch outfit {
        case "farmer":
            f.svgLine("M44 6V104", 0x9A6A42, 2.4)
            f.svgLine("M38 2V8Q38 12 44 12Q50 12 50 8V2M44 2V12", 0x7D8A92, 1.8)
            f.svgLine("M31 42C36 50 40 54 43 56", 0xC8261B, 6)
            f.dot(44, 56, 3.4, v.skin)
        case "miller":
            f.svg("M24 26Q22 16 34 15L50 18Q58 20 56 30L52 40Q44 44 32 40Z", 0xEFEBE2)
            f.svgLine("M48 18Q52 14 50 10", 0xC9A15B, 1.6)
            f.svgLine("M34 22Q42 26 52 24", 0xD3D1C7, 1)
            f.svgLine("M31 42C35 38 36 34 34 30", 0x8C6A4A, 6)
            f.dot(33.5, 29, 3.4, v.skin)
        default:
            f.svgLine("M31 42C34 52 34 62 32 70", outfit == "sailor" ? 0xFFFDF6 : 0x3E4C55, 6)
            f.dot(32, 72, 3.1, v.skin)
        }
    }

    // MARK: Customs

    /// A customs officer (peaked cap, torch) and a sniffer dog at an open suitcase (112 × 114).
    static func customs(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 114))
        let v = Look.at(p.variant ?? 4)
        f.oval(2, 106, 108, 7, 0x1E1E1C, 0.15)
        body(f, skin: v.skin, hair: v.hair, coat: 0x1F3A6B, trousers: 0x1F3A6B, hat: .peaked, shadow: false)
        f.svgLine("M22 40V86", 0x16294D, 1.2)
        f.svg("M24 46L29 47.5L28 53L25 54Z", 0xC9A15B)
        f.rect(9.5, 66, 25, 3, 0x1E1E1C)
        f.svgLine("M31 42C38 48 42 52 46 52", 0x1F3A6B, 6)
        f.rect(44, 47, 13, 7, 0x3E4C55, radius: 2)
        f.dot(45, 52.5, 3.2, v.skin)
        f.svg("M57 47L86 70L80 84L57 54Z", 0xFAC775, 0.4)
        // Open suitcase on the ground
        f.rect(66, 84, 44, 22, PalaceInk.shade(v.bag, 0.8), radius: 3)
        f.svg("M68 84L62 66H104L108 84Z", v.bag)
        f.rect(70, 88, 14, 7, 0xFFFDF6, radius: 1)
        f.rect(86, 90, 18, 6, 0x5DCAA5, radius: 1)
        f.rect(80, 81, 12, 3, 0x1E1E1C, radius: 1)
        // Dog sniffing at it, nose to the case
        var d = f
        d.ctx.translateBy(x: 4, y: 8)
        d.ctx.scaleBy(x: 0.62, y: 0.86)
        let coat: UInt32 = 0x2E2117
        d.svgLine("M54 90L52 104M60 91L62 104M73 90L71 104M78 89L81 104", coat, 4)
        d.svgLine("M52 84Q44 76 46 70", coat, 3.2)
        d.rect(49, 79, 32, 14, coat, radius: 7)
        d.dot(84, 82, 7.5, coat)
        d.rect(86, 83, 9, 6, 0x4A3524, radius: 3)
        d.svg("M78 76Q75 85 80 89Q83 82 82 76Z", 0x1E1E1C)
        d.dot(87, 79, 1.2, 0xFFFDF6)
        d.svgLine("M74 82L77 88", 0xC8261B, 2.6)
        f.svgLine("M64 80Q66 77 64 74M67.5 79Q70 75 67.5 71", 0xB4B2A9, 1.2)
    }
}
