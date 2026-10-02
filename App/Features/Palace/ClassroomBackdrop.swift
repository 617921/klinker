import SwiftUI

/// The classroom's named slots: a sign, the blackboard and the window corner high up, two spots on
/// the wall, the teacher's place by the board, three pupils' desks and two spots on the floor.
enum Classroom {
    static let noor = CGPoint(x: 300, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "signLeft": PalaceSlot(frame: CGRect(x: 8, y: 20, width: 100, height: 62), pin: CGPoint(x: 10, y: 80), tilt: -2),
        "board": PalaceSlot(frame: CGRect(x: 116, y: 18, width: 140, height: 90), pin: CGPoint(x: 120, y: 96), tilt: 1.5),
        "window": PalaceSlot(frame: CGRect(x: 262, y: 14, width: 104, height: 156), pin: CGPoint(x: 366, y: 168), align: .trailing, tilt: -1.5),
        "wallLeft": PalaceSlot(frame: CGRect(x: 12, y: 106, width: 92, height: 72), pin: CGPoint(x: 8, y: 170), tilt: 1.5),
        "wallMid": PalaceSlot(frame: CGRect(x: 112, y: 128, width: 84, height: 56), pin: CGPoint(x: 154, y: 180), align: .center, tilt: -1.5),
        "teacher": PalaceSlot(frame: CGRect(x: 200, y: 116, width: 62, height: 126), pin: CGPoint(x: 236, y: 232), align: .center, tilt: 1),
        "desk1": PalaceSlot(frame: CGRect(x: 6, y: 196, width: 90, height: 92), pin: CGPoint(x: 4, y: 270), tilt: -1.5),
        "desk2": PalaceSlot(frame: CGRect(x: 104, y: 210, width: 90, height: 90), pin: CGPoint(x: 150, y: 290), align: .center, tilt: 1.5),
        "desk3": PalaceSlot(frame: CGRect(x: 268, y: 196, width: 92, height: 90), pin: CGPoint(x: 366, y: 270), align: .trailing, tilt: -1),
        "floorLeft": PalaceSlot(frame: CGRect(x: 10, y: 292, width: 64, height: 108), pin: CGPoint(x: 6, y: 376), tilt: 1.5),
        "floorRight": PalaceSlot(frame: CGRect(x: 214, y: 284, width: 60, height: 118), pin: CGPoint(x: 244, y: 376), align: .center, tilt: -1.5),
    ]
}

/// A Dutch primary-school classroom: cream walls with bunting, a wooden rail and a lino floor.
struct ClassroomBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = wall + bunting + floor

    private nonisolated static let wall: [PalaceMark] = [
        .f("M0 0H370V254H0Z", 0xE8DDC6),
        .f("M0 0H370V9H0Z", 0xEFEBE2),
        .f("M0 9H370V11H0Z", 0x1E1E1C, 0.07),
        .f("M0 198H370V254H0Z", 0xD9CDB4),
        .f("M0 194H370V199H0Z", 0x9A6A42),
        .f("M0 199H370V201H0Z", 0x1E1E1C, 0.1),
    ]

    private nonisolated static let bunting: [PalaceMark] = {
        let colours: [UInt32] = [0xC8261B, 0xFAC775, 0x2F5BD3, 0x5DCAA5, 0xF2711C]
        var flags: [PalaceMark] = [.s("M0 11Q92 17 185 11Q278 17 370 11", 0x5E6B73, 1)]
        for (i, x) in stride(from: 6.0, to: 364, by: 16).enumerated() {
            let y = 11 + 3 * sin(Double(i) * 0.55)
            flags.append(.f("M\(x) \(y)H\(x + 11)L\(x + 5.5) \(y + 9)Z", colours[i % colours.count]))
        }
        return flags
    }()

    private nonisolated static let floor: [PalaceMark] = {
        var tiles = ""
        for r in 0..<7 {
            for c in 0..<17 where (r + c) % 2 == 0 {
                tiles += "M\(c * 23 - 6) \(256 + r * 23)h23v23h-23Z"
            }
        }
        return [
            .f("M0 254H370V408H0Z", 0xDAD6CA),
            .f(tiles, 0xCFCABC),
            .f("M0 252H370V257H0Z", 0x6B4A2E),
            .f("M0 257H370V260H0Z", 0x1E1E1C, 0.08),
        ]
    }()
}
