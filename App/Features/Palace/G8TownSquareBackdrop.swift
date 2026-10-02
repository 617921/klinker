import SwiftUI

/// The town hall square's named slots: a door on the left, a banner on the facade, the top of
/// the town hall steps and a board on the right at the back; three spots on the square in the
/// middle; four in front.
enum G8TownSquare {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [
        "doorLeft": PalaceSlot(frame: CGRect(x: 2, y: 108, width: 102, height: 90), pin: CGPoint(x: 6, y: 194), tilt: -1.5),
        "facade": PalaceSlot(frame: CGRect(x: 122, y: 82, width: 36, height: 76), pin: CGPoint(x: 120, y: 86), align: .trailing, tilt: 1.5),
        "steps": PalaceSlot(frame: CGRect(x: 164, y: 98, width: 46, height: 96), pin: CGPoint(x: 187, y: 194), align: .center, tilt: -1),
        "boardRight": PalaceSlot(frame: CGRect(x: 262, y: 110, width: 106, height: 86), pin: CGPoint(x: 366, y: 194), align: .trailing, tilt: 1.5),
        "squareLeft": PalaceSlot(frame: CGRect(x: 2, y: 210, width: 138, height: 78), pin: CGPoint(x: 6, y: 286), tilt: 1),
        "squareMid": PalaceSlot(frame: CGRect(x: 144, y: 204, width: 70, height: 84), pin: CGPoint(x: 177, y: 288), align: .center, tilt: -1.5),
        "squareRight": PalaceSlot(frame: CGRect(x: 250, y: 206, width: 116, height: 82), pin: CGPoint(x: 366, y: 286), align: .trailing, tilt: 1),
        "nearLeft": PalaceSlot(frame: CGRect(x: 2, y: 316, width: 88, height: 66), pin: CGPoint(x: 6, y: 380), tilt: -1),
        "nearMid": PalaceSlot(frame: CGRect(x: 92, y: 312, width: 102, height: 70), pin: CGPoint(x: 144, y: 382), align: .center, tilt: 1.5),
        "nearSpeaker": PalaceSlot(frame: CGRect(x: 196, y: 304, width: 78, height: 80), pin: CGPoint(x: 235, y: 382), align: .center, tilt: -1),
        "nearRight": PalaceSlot(frame: CGRect(x: 280, y: 308, width: 86, height: 76), pin: CGPoint(x: 366, y: 382), align: .trailing, tilt: 1.5),
    ]
}

/// The square in front of the town hall: a classical facade with columns, a pediment with a
/// clock and a flag, broad steps, canal houses on both sides and a cobbled square.
struct G8TownSquareBackdrop: View, Equatable {
    nonisolated static let scale: CGFloat = 0.5
    nonisolated static let houses: [PalaceWindowHouse] = {
        let street = PalaceOutdoor.street(count: 8, shops: [1, 5])
        return PalaceOutdoor.row(Array(street[0..<3]), scale: scale, baseline: 198, from: -14)
            + PalaceOutdoor.row(Array(street[4..<8]), scale: scale, baseline: 198, from: 262)
    }()

    var body: some View {
        PalaceOutdoorBackdrop(houses: Self.houses, scale: Self.scale, skyHeight: 200,
                              clouds: [CGRect(x: 30, y: 26, width: 46, height: 11), CGRect(x: 292, y: 16, width: 40, height: 9)],
                              marks: Self.marks)
    }

    nonisolated static let marks: [PalaceMark] = square + townHall

    private nonisolated static let square: [PalaceMark] =
        [.f("M0 196H370V200H0Z", 0xA19E95), .f("M0 200H370V202H0Z", 0x6E6B64)]
            + PalaceOutdoor.cobbles(top: 202, bottom: 408, base: 0xC4B9A2, stone: 0xDDD4C1)

    private nonisolated static let townHall: [PalaceMark] = {
        var columns: [PalaceMark] = []
        for x in [118.0, 146, 214, 242] {
            columns += [
                .f("M\(x) 94H\(x + 11)V182H\(x)Z", 0xF4EFE2),
                .f("M\(x + 8) 94H\(x + 11)V182H\(x + 8)Z", 0xD9CDB4),
                .f("M\(x - 2) 90H\(x + 13)V95H\(x - 2)Z M\(x - 2) 180H\(x + 13)V184H\(x - 2)Z", 0xD3C4A2),
            ]
        }
        var windows = ""
        for x in [131.0, 227] {
            for y in [100.0, 142] { windows += "M\(x) \(y)H\(x + 13)V\(y + 28)H\(x)Z" }
        }
        return [
            // Flag on the roof
            .f("M184 6H186V40H184Z", 0x5E6B73),
            .f("M186 7H208V12H186Z", 0xC8261B), .f("M186 12H208V17H186Z", 0xFFFDF6), .f("M186 17H208V22H186Z", 0x1F3A6B),
            // Body, pediment and cornice
            .f("M106 66H264V186H106Z", 0xE3D6BC),
            .f("M98 72L185 32L272 72Z", 0xEFE6D2),
            .s("M112 68L185 38L258 68Z", 0xC9B88F, 1.4),
            .f("M96 70H274V77H96Z", 0xD3C4A2),
            .f("M104 77H266V86H104Z", 0xD9CDB4),
            .s("M104 81.5H266", 0xC9B88F, 1),
            .dot(185, 56, 10.5, 0x5E6B73), .dot(185, 56, 8.6, 0xFFFDF6),
            .s("M185 56V50M185 56L189.5 58", 0x1E1E1C, 1.4, round: true),
            .f(windows, 0x3E4C55),
            .s(windows + "M137.5 100V128M137.5 142V170M233.5 100V128M233.5 142V170", 0xEFEBE2, 1.4),
            // Door
            .f("M170 182V132A15 15 0 0 1 200 132V182Z", 0x2F4B3A),
            .s("M185 120V182M174 140H182M188 140H196", 0x24533F, 1.4),
        ] + columns + [
            // Steps
            .f("M110 182H260V188H110Z", 0xD3D1C7),
            .f("M104 188H266V193H104Z", 0xC4C0B4),
            .f("M98 193H272V198H98Z", 0xB4B2A9),
            .f("M98 197H272V199H98Z", 0x1E1E1C, 0.1),
        ]
    }()
}
