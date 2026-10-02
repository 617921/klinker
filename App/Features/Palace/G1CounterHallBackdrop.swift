import SwiftUI

/// The counter hall that the bank, the post office, the police front desk and the housing
/// office share (a relative of the Gemeentehuis): three spots high on the wall, a tall spot on
/// the left wall (split in two when needed), two glass counter windows, three spots on the
/// counter top and three on the floor. Behind the glass a clerk can sit as `decor`
/// (`g1Person` "clerk"), cut at the counter top (y 222).
enum G1CounterHall {
    static let noor = CGPoint(x: 212, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "highLeft": PalaceSlot(frame: CGRect(x: 8, y: 24, width: 96, height: 66), pin: CGPoint(x: 8, y: 92), tilt: -1.5),
        "highMid": PalaceSlot(frame: CGRect(x: 124, y: 22, width: 112, height: 58), pin: CGPoint(x: 180, y: 78), align: .center, tilt: 1.5),
        "highRight": PalaceSlot(frame: CGRect(x: 250, y: 22, width: 112, height: 58), pin: CGPoint(x: 364, y: 78), align: .trailing, tilt: -1),
        "side": PalaceSlot(frame: CGRect(x: 10, y: 100, width: 94, height: 170), pin: CGPoint(x: 8, y: 252), tilt: 1.5),
        "sideTop": PalaceSlot(frame: CGRect(x: 10, y: 100, width: 94, height: 92), pin: CGPoint(x: 8, y: 178), tilt: 1.5),
        "sideLow": PalaceSlot(frame: CGRect(x: 10, y: 198, width: 94, height: 70), pin: CGPoint(x: 8, y: 256), tilt: -1),
        "glassLeft": PalaceSlot(frame: CGRect(x: 122, y: 102, width: 110, height: 74), pin: CGPoint(x: 126, y: 168), tilt: -1.5),
        "glassRight": PalaceSlot(frame: CGRect(x: 250, y: 102, width: 110, height: 74), pin: CGPoint(x: 364, y: 168), align: .trailing, tilt: 1.5),
        "counterLeft": PalaceSlot(frame: CGRect(x: 116, y: 178, width: 78, height: 56), pin: CGPoint(x: 116, y: 230), tilt: -1),
        "counterMid": PalaceSlot(frame: CGRect(x: 200, y: 176, width: 82, height: 58), pin: CGPoint(x: 241, y: 234), align: .center, tilt: 1.5),
        "counterRight": PalaceSlot(frame: CGRect(x: 288, y: 178, width: 76, height: 56), pin: CGPoint(x: 366, y: 230), align: .trailing, tilt: -1.5),
        "floorLeft": PalaceSlot(frame: CGRect(x: 6, y: 274, width: 84, height: 128), pin: CGPoint(x: 4, y: 372), tilt: -1.5),
        "floorMid": PalaceSlot(frame: CGRect(x: 100, y: 296, width: 96, height: 106), pin: CGPoint(x: 148, y: 376), align: .center, tilt: 1.5),
        "floorRight": PalaceSlot(frame: CGRect(x: 290, y: 276, width: 76, height: 126), pin: CGPoint(x: 366, y: 378), align: .trailing, tilt: -2),
    ]
}

/// The colours of one counter hall.
nonisolated struct G1HallLook: Sendable {
    let wall: UInt32
    let trim: UInt32
    let back: UInt32
    let wood: UInt32
    let counterTop: UInt32
    let counterFront: UInt32
    let floor: UInt32
    let tile: UInt32
    let accent: UInt32

    static func of(_ type: PalaceRoomType) -> G1HallLook {
        switch type {
        case .g1PostOffice: post
        case .g1PoliceDesk: police
        case .g1HousingDesk: housing
        default: bank
        }
    }

    static let bank = G1HallLook(wall: 0xE6E1D6, trim: 0x2B3A4A, back: 0xD9DDE0, wood: 0x3E4C55, counterTop: 0xF4F1EA,
                                 counterFront: 0x5E6B73, floor: 0xE2DED3, tile: 0xC9C4B8, accent: 0xC9A15B)
    static let post = G1HallLook(wall: 0xF1E2C4, trim: 0x9A3A2A, back: 0xEDE3CF, wood: 0x7A5230, counterTop: 0xEFEBE2,
                                 counterFront: 0x9A6A42, floor: 0xE6CDB0, tile: 0xD1B48E, accent: 0xC8261B)
    static let police = G1HallLook(wall: 0xDCE3E8, trim: 0x1F3A6B, back: 0xE4E9EC, wood: 0x2B4C86, counterTop: 0xF4F1EA,
                                   counterFront: 0x1F3A6B, floor: 0xD8DCDD, tile: 0xC3C9CB, accent: 0xFAC775)
    static let housing = G1HallLook(wall: 0xE4EEE8, trim: 0x0F6E56, back: 0xF1EEE4, wood: 0x8C5E38, counterTop: 0xEFEBE2,
                                    counterFront: 0xC9965F, floor: 0xE8E2D2, tile: 0xD3CCBA, accent: 0x0F6E56)
}

/// A counter hall: cornice, a plain left wall with a wainscot, two numbered glass windows over a
/// long counter with the back office behind it, and a tiled floor.
struct G1CounterHallBackdrop: View, Equatable {
    let type: PalaceRoomType

    var body: some View {
        PalaceArtwork(marks: Self.marks(type), width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    private static let bank = build(.bank)
    private static let post = build(.post)
    private static let police = build(.police)
    private static let housing = build(.housing)

    private static func marks(_ type: PalaceRoomType) -> [PalaceMark] {
        switch type {
        case .g1PostOffice: post
        case .g1PoliceDesk: police
        case .g1HousingDesk: housing
        default: bank
        }
    }

    private nonisolated static func build(_ l: G1HallLook) -> [PalaceMark] {
        wall(l) + backOffice(l) + floor(l) + counter(l)
    }

    private nonisolated static func wall(_ l: G1HallLook) -> [PalaceMark] {
        var dentils = ""
        for x in stride(from: 4, to: 370, by: 10) { dentils += "M\(x) 14h5v4h-5Z" }
        return [
            .f("M0 0H370V300H0Z", l.wall),
            .f("M0 0H370V14H0Z", l.trim),
            .f("M0 14H370V18H0Z", PalaceInk.shade(l.wall, 0.92)),
            .f(dentils, l.trim),
            .f("M0 18H370V21H0Z", 0x1E1E1C, 0.07),
            // Wainscot on the left wall
            .f("M0 252H112V300H0Z", PalaceInk.shade(l.wall, 0.86)),
            .f("M0 249H112V253H0Z", l.trim),
            .s("M8 260H50V292H8Z M60 260H102V292H60Z", PalaceInk.shade(l.wall, 0.78), 1.2),
        ]
    }

    /// The back office behind the glass (x 112–370, y 88–222): shelves with binders, a door.
    private nonisolated static func backOffice(_ l: G1HallLook) -> [PalaceMark] {
        let binders: [(CGFloat, CGFloat, UInt32)] = [(124, 20, 0x2F5BD3), (132, 16, 0xC8261B), (139, 22, 0xFAC775),
                                                      (330, 18, 0x0F6E56), (338, 22, 0x3C3489), (346, 16, 0xF2711C)]
        var marks: [PalaceMark] = [
            .f("M112 88H370V222H112Z", l.back),
            .f("M112 88H370V92H112Z", 0x1E1E1C, 0.08),
            .f("M120 128H160V131H120Z M322 128H362V131H322Z", PalaceInk.shade(l.back, 0.8)),
            // A door at the back, between the two windows' shelves
            .f("M214 112H270V222H214Z", PalaceInk.shade(l.back, 0.9)),
            .f("M218 116H266V222H218Z", PalaceInk.shade(l.wood, 1.25)),
            .dot(260, 172, 2.2, l.accent),
        ]
        for (x, h, c) in binders { marks.append(.f("M\(x) \(128 - h)H\(x + 6.5)V128H\(x)Z", c)) }
        marks += [
            // The header beam with two number plaques, the window frames and a light glass tint
            .f("M112 84H370V100H112Z", l.trim),
            .f("M112 100H370V103H112Z", 0x1E1E1C, 0.12),
            .dot(177, 92, 6.5, 0xFFFDF6),
            .dot(305, 92, 6.5, 0xFFFDF6),
            .f("M175.6 88.5H178.4V95.5H175.6Z", l.trim),
            .s("M301.5 89.4Q305 87.4 307.6 89.4Q308.8 91.4 301.8 95.6H308.6", l.trim, 1.6, round: true),
            .f("M114 103H370V222H114Z", 0xA9CBE0, 0.12),
            .f("M112 100H118V222H112Z M238 100H244V222H238Z M364 100H370V222H364Z", l.wood),
            .f("M126 103H138L118 132V118Z M254 103H266L244 132V118Z", 0xFFFFFF, 0.35),
            .f("M118 196H238V222H118Z M244 196H364V222H244Z", 0xFFFFFF, 0.1),
            .s("M118 196H238M244 196H364", 0xFFFFFF, 1, 0.5),
        ]
        return marks
    }

    private nonisolated static func floor(_ l: G1HallLook) -> [PalaceMark] {
        var tiles = ""
        for r in 0..<5 {
            for c in 0..<17 where (r + c) % 2 == 0 {
                tiles += "M\(c * 23 - 6) \(300 + r * 23)h23v23h-23Z"
            }
        }
        return [
            .f("M0 300H370V408H0Z", l.floor),
            .f(tiles, l.tile, 0.6),
            .f("M0 298H112V302H0Z", PalaceInk.shade(l.trim, 0.8)),
            .f("M0 302H370V305H0Z", 0x1E1E1C, 0.08),
        ]
    }

    private nonisolated static func counter(_ l: G1HallLook) -> [PalaceMark] {
        let panel = PalaceInk.shade(l.counterFront, 0.88)
        return [
            .f("M110 222H370V234H110Z", l.counterTop),
            .f("M110 234H370V238H110Z", 0x1E1E1C, 0.18),
            .f("M112 238H370V300H112Z", l.counterFront),
            .f("M122 248H234V292H122Z M248 248H360V292H248Z", panel),
            .s("M126 252H230V288H126Z M252 252H356V288H252Z", PalaceInk.shade(l.counterFront, 1.18), 1),
            .f("M112 238H370V242H112Z", l.accent, 0.85),
            .f("M112 296H370V302H112Z", PalaceInk.shade(l.counterFront, 0.7)),
        ]
    }
}
