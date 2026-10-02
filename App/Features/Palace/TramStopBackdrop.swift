import SwiftUI

/// The tram stop's named slots: a sign and road works on the left, the tram's display and two
/// doors in the middle, a clock and the end of the track on the right, and four spots on the
/// platform in front.
enum TramStop {
    static let noor = CGPoint(x: 322, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "signLeft": PalaceSlot(frame: CGRect(x: 6, y: 70, width: 82, height: 122), pin: CGPoint(x: 8, y: 116), tilt: -1.5),
        "streetLeft": PalaceSlot(frame: CGRect(x: 0, y: 196, width: 96, height: 86), pin: CGPoint(x: 4, y: 160), tilt: 1.5),
        "tramDisplay": PalaceSlot(frame: CGRect(x: 130, y: 146, width: 126, height: 44), pin: CGPoint(x: 193, y: 112), align: .center, tilt: 1),
        "doorFront": PalaceSlot(frame: CGRect(x: 108, y: 186, width: 50, height: 96), pin: CGPoint(x: 158, y: 266), align: .trailing, tilt: -2),
        "doorBack": PalaceSlot(frame: CGRect(x: 198, y: 186, width: 50, height: 96), pin: CGPoint(x: 198, y: 266), tilt: 1.5),
        "clockRight": PalaceSlot(frame: CGRect(x: 286, y: 40, width: 78, height: 94), pin: CGPoint(x: 366, y: 136), align: .trailing, tilt: 1.5),
        "trackEnd": PalaceSlot(frame: CGRect(x: 294, y: 204, width: 74, height: 80), pin: CGPoint(x: 366, y: 172), align: .trailing, tilt: -1),
        "platform1": PalaceSlot(frame: CGRect(x: 4, y: 298, width: 66, height: 106), pin: CGPoint(x: 6, y: 352), tilt: 1),
        "platform2": PalaceSlot(frame: CGRect(x: 126, y: 298, width: 64, height: 106), pin: CGPoint(x: 158, y: 384), align: .center, tilt: -1.5),
        "platform3": PalaceSlot(frame: CGRect(x: 198, y: 300, width: 50, height: 98), pin: CGPoint(x: 223, y: 348), align: .center, tilt: 2),
        "platform4": PalaceSlot(frame: CGRect(x: 256, y: 290, width: 66, height: 116), pin: CGPoint(x: 290, y: 384), align: .center, tilt: -1),
    ]
}

/// A tram stop in a canal street: houses across the back, an overhead wire, a tram waiting at
/// the platform with its two doors, the rails running on to the right, and the platform in front.
struct TramStopBackdrop: View, Equatable {
    nonisolated static let scale: CGFloat = 0.5
    nonisolated static let houses = PalaceOutdoor.row(PalaceOutdoor.street(count: 11, shops: [2, 7]), scale: scale, baseline: 186)

    var body: some View {
        PalaceOutdoorBackdrop(houses: Self.houses, scale: Self.scale, skyHeight: 192,
                              clouds: [CGRect(x: 120, y: 22, width: 48, height: 11), CGRect(x: 20, y: 44, width: 34, height: 8)],
                              marks: Self.marks)
    }

    nonisolated static let marks: [PalaceMark] = street + wire + tram + platform

    private nonisolated static let street: [PalaceMark] = [
        .f("M0 186H370V192H0Z", 0xA19E95),
        .f("M0 192H370V194H0Z", 0x6E6B64),
        .f("M0 194H370V286H0Z", 0x8E8A80),
        .f("M0 238H370V240H0Z", 0xA19E95, 0.6),
        .f("M0 271H370V274H0Z M0 279H370V282H0Z", 0x5E6B73),
        .f("M0 271H370V272H0Z M0 279H370V280H0Z", 0xD3D1C7),
    ]

    private nonisolated static let wire: [PalaceMark] = [
        .f("M361 52H366V286H361Z", 0x5E6B73),
        .f("M361 52H362.5V286H361Z", 0x7D8A92),
        .s("M0 126H362M240 126L362 60", 0x2E2117, 1.1),
        .s("M188 151L196 136L204 151M196 136V126M190 126H202", 0x3E4C55, 1.6),
    ]

    private nonisolated static let tram: [PalaceMark] = {
        var windows = "", shine = ""
        for x in [160.0, 250] {
            windows += "M\(x + 4) 192H\(x + 34)Q\(x + 38) 192 \(x + 38) 196V214Q\(x + 38) 218 \(x + 34) 218H\(x + 4)Q\(x) 218 \(x) 214V196Q\(x) 192 \(x + 4) 192Z"
            shine += "M\(x + 4) 216L\(x + 15) 194H\(x + 21)L\(x + 10) 216Z"
        }
        return [
            .f("M100 146H262V152H100Z", 0xB4B2A9),
            .f("M96 150H262Q286 152 288 196V280H96Z", 0xEFEBE2),
            .f("M96 150H100V280H96Z", 0x1E1E1C, 0.08),
            .f("M96 226H288V234H96Z", 0x2F5BD3),
            .f(windows, 0x3E4C55),
            .f(shine, 0xFFFFFF, 0.15),
            .f("M98 192H104V218H98Z", 0x3E4C55),
            .f("M266 160Q282 164 284 198H266Z", 0x3E4C55),
            .f("M268 164L276 164L270 194H268Z", 0xFFFFFF, 0.18),
            .dot(279, 252, 3.6, 0xFAC775),
            .f("M96 268H288V280H96Z", 0x3E4C55),
            // Closed doors (the door props open them)
            .f("M108 186H158V280H108Z M198 186H248V280H198Z", 0x2F5BD3),
            .f("M112 192H130V240H112Z M136 192H154V240H136Z M202 192H220V240H202Z M226 192H244V240H226Z", 0x3E4C55),
            .s("M133 186V280M223 186V280", 0x21468B, 1.4),
        ]
    }()

    private nonisolated static let platform: [PalaceMark] = {
        var tiles = "", studs = ""
        for r in 0..<6 {
            for c in 0..<17 where (r + c) % 2 == 0 {
                tiles += "M\(c * 23 - 6) \(298 + r * 23)h23v23h-23Z"
            }
        }
        for x in stride(from: 4, to: 370, by: 7) { studs += "M\(x) 293.5a1.1 1.1 0 1 0 0.01 0Z" }
        return [
            .f("M0 282H370V408H0Z", 0xDAD6CA),
            .f(tiles, 0xCDC8BA),
            .f("M0 282H370V287H0Z", 0xF4F1EA),
            .f("M0 287H370V289H0Z", 0x1E1E1C, 0.1),
            .f("M0 290H370V297H0Z", 0xFAC775),
            .f(studs, 0xD9A440),
        ]
    }()
}
