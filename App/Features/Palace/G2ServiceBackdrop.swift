import SwiftUI

/// The service desk that the tax office, the insurer and the energy company share: four things
/// high on the wall, a long counter with an advisor behind it (four spots on the counter top),
/// and three spots on the floor in front. The slots are shared; each place has its own colours.
enum G2Service {
    static let noor = CGPoint(x: 222, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "wallA": PalaceSlot(frame: CGRect(x: 6, y: 20, width: 84, height: 72), pin: CGPoint(x: 6, y: 96), tilt: -1.5),
        "wallB": PalaceSlot(frame: CGRect(x: 96, y: 20, width: 84, height: 72), pin: CGPoint(x: 128, y: 100), align: .center, tilt: 1.5),
        "wallC": PalaceSlot(frame: CGRect(x: 188, y: 20, width: 84, height: 72), pin: CGPoint(x: 172, y: 96), tilt: -1),
        "wallD": PalaceSlot(frame: CGRect(x: 280, y: 20, width: 84, height: 72), pin: CGPoint(x: 366, y: 100), align: .trailing, tilt: 1.5),
        // Counter pins alternate between the top edge and lower on the counter front.
        "counterA": PalaceSlot(frame: CGRect(x: 6, y: 122, width: 84, height: 82), pin: CGPoint(x: 6, y: 212), tilt: 1),
        "counterB": PalaceSlot(frame: CGRect(x: 94, y: 126, width: 80, height: 78), pin: CGPoint(x: 134, y: 246), align: .center, tilt: -1.5),
        "counterC": PalaceSlot(frame: CGRect(x: 238, y: 126, width: 62, height: 78), pin: CGPoint(x: 268, y: 212), align: .center, tilt: 1.5),
        "counterD": PalaceSlot(frame: CGRect(x: 304, y: 122, width: 62, height: 82), pin: CGPoint(x: 366, y: 242), align: .trailing, tilt: -1),
        "frontLeft": PalaceSlot(frame: CGRect(x: 6, y: 254, width: 100, height: 104), pin: CGPoint(x: 6, y: 358), tilt: -1.5),
        "frontMid": PalaceSlot(frame: CGRect(x: 112, y: 258, width: 96, height: 100), pin: CGPoint(x: 158, y: 364), align: .center, tilt: 1.5),
        "standing": PalaceSlot(frame: CGRect(x: 290, y: 280, width: 74, height: 122), pin: CGPoint(x: 366, y: 376), align: .trailing, tilt: 2),
        /// The advisor behind the counter (cut off at the counter top).
        "advisor": PalaceSlot(frame: CGRect(x: 178, y: 116, width: 58, height: 88), pin: CGPoint(x: 207, y: 214), align: .center, tilt: -1),
    ]
}

/// Colours of one service desk.
nonisolated struct G2ServiceLook: Sendable {
    let wall: UInt32
    let lower: UInt32
    let rail: UInt32
    let counter: UInt32
    let panel: UInt32
    let floor: UInt32
    let tile: UInt32

    static func of(_ type: PalaceRoomType) -> G2ServiceLook {
        switch type {
        case .g2Insurer: insurer
        case .g2EnergyOffice: energy
        default: tax
        }
    }

    static let tax = G2ServiceLook(wall: 0xDCE4EC, lower: 0xC7D3DE, rail: 0x1F3A6B, counter: 0x93A9C2,
                                   panel: 0x8299B4, floor: 0xCDD1D3, tile: 0xBCC2C6)
    static let insurer = G2ServiceLook(wall: 0xE1E9DF, lower: 0xCADBC9, rail: 0x0F6E56, counter: 0x8DB5A2,
                                       panel: 0x7AA690, floor: 0xDDD6C6, tile: 0xCBC2AE)
    static let energy = G2ServiceLook(wall: 0xF4E9D2, lower: 0xEBD9B4, rail: 0xF2711C, counter: 0xE7A867,
                                      panel: 0xD99555, floor: 0xD9D2C2, tile: 0xC7BEAA)
}

/// A bright service hall: light ceiling panels, a wall with a coloured rail, a long counter with
/// a glass screen in the middle and a tiled floor.
struct G2ServiceBackdrop: View, Equatable {
    let type: PalaceRoomType

    var body: some View {
        PalaceArtwork(marks: Self.marks(type), width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    private static let taxMarks = build(.tax)
    private static let insurerMarks = build(.insurer)
    private static let energyMarks = build(.energy)

    private static func marks(_ type: PalaceRoomType) -> [PalaceMark] {
        switch type {
        case .g2Insurer: insurerMarks
        case .g2EnergyOffice: energyMarks
        default: taxMarks
        }
    }

    private nonisolated static func build(_ l: G2ServiceLook) -> [PalaceMark] {
        var lights = "", seams = "", tiles = ""
        for x in stride(from: 20.0, to: 370, by: 92) { lights += "M\(x) 3H\(x + 40)V11H\(x)Z" }
        for x in stride(from: 74.0, to: 370, by: 74) { seams += "M\(x) 216V292" }
        for r in 0..<5 {
            for c in 0..<14 where (r + c) % 2 == 0 { tiles += "M\(c * 28 - 6) \(300 + r * 22)h28v22h-28Z" }
        }
        return [
            // Ceiling and wall
            .f("M0 0H370V300H0Z", l.wall),
            .f("M0 0H370V14H0Z", 0xEFEBE2),
            .f(lights, 0xFFFDF6),
            .f("M0 14H370V17H0Z", 0x1E1E1C, 0.08),
            .f("M0 110H370V206H0Z", l.lower),
            .f("M0 106H370V111H0Z", l.rail),
            // Glass screen on the counter, behind the advisor
            .f("M172 112H242V204H172Z", 0xFFFFFF, 0.28),
            .s("M172 112V204M242 112V204", 0x8C9499, 2.2),
            .s("M172 112H242", 0x8C9499, 1.6),
            .f("M180 196L198 120H206L188 196Z", 0xFFFFFF, 0.3),
            // Counter
            .f("M0 202H370V210H0Z", 0xF4F1EA),
            .f("M0 210H370V214H0Z", 0xB4B2A9),
            .f("M0 214H370V300H0Z", l.counter),
            .s(seams, l.panel, 2.4),
            .f("M0 214H370V219H0Z", l.rail),
            .f("M0 288H370V300H0Z", l.rail),
            .f("M0 288H370V300H0Z", 0x1E1E1C, 0.15),
            // Floor
            .f("M0 300H370V408H0Z", l.floor),
            .f(tiles, l.tile),
            .f("M0 300H370V304H0Z", 0x1E1E1C, 0.1),
        ]
    }
}
