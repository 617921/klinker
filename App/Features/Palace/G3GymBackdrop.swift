import SwiftUI

/// The gym's named slots: three cards high on the wall, a door and a block of lockers on the left,
/// two machines before the mirror and four spots on the rubber floor.
enum G3GymRoom {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [
        "wallLeft": PalaceSlot(frame: CGRect(x: 92, y: 10, width: 86, height: 64), pin: CGPoint(x: 178, y: 70), align: .trailing, tilt: -2),
        "wallMid": PalaceSlot(frame: CGRect(x: 188, y: 8, width: 84, height: 80), pin: CGPoint(x: 236, y: 70), align: .center, tilt: 1.5),
        "wallRight": PalaceSlot(frame: CGRect(x: 280, y: 10, width: 86, height: 74), pin: CGPoint(x: 364, y: 102), align: .trailing, tilt: -1.5),
        "door": PalaceSlot(frame: CGRect(x: 2, y: 46, width: 84, height: 204), pin: CGPoint(x: 6, y: 212), tilt: 1.5),
        "lockers": PalaceSlot(frame: CGRect(x: 90, y: 98, width: 90, height: 152), pin: CGPoint(x: 134, y: 222), align: .center, tilt: -1.5),
        "machineLeft": PalaceSlot(frame: CGRect(x: 186, y: 106, width: 96, height: 140), pin: CGPoint(x: 230, y: 222), align: .center, tilt: 1),
        "machineRight": PalaceSlot(frame: CGRect(x: 282, y: 112, width: 86, height: 134), pin: CGPoint(x: 366, y: 222), align: .trailing, tilt: -1),
        "floor1": PalaceSlot(frame: CGRect(x: 4, y: 276, width: 68, height: 128), pin: CGPoint(x: 4, y: 376), tilt: -1.5),
        "floor2": PalaceSlot(frame: CGRect(x: 80, y: 272, width: 72, height: 132), pin: CGPoint(x: 116, y: 382), align: .center, tilt: 1.5),
        "floor3": PalaceSlot(frame: CGRect(x: 160, y: 266, width: 104, height: 110), pin: CGPoint(x: 212, y: 378), align: .center, tilt: -1),
        "floor4": PalaceSlot(frame: CGRect(x: 276, y: 262, width: 90, height: 116), pin: CGPoint(x: 366, y: 380), align: .trailing, tilt: 1.5),
    ]
}

/// A gym: pale concrete walls with an orange band, a long mirror, spotlights and a rubber floor.
struct G3GymBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = wall + mirror + floor

    private nonisolated static let wall: [PalaceMark] = {
        var spots: [PalaceMark] = []
        for x in stride(from: 40.0, to: 370, by: 82) {
            spots.append(.f("M\(x - 8) 8H\(x + 8)L\(x + 5) 14H\(x - 5)Z", 0x3E4C55))
            spots.append(.f("M\(x - 5) 14H\(x + 5)L\(x + 16) 48H\(x - 16)Z", 0xFFFDF6, 0.25))
        }
        return [
            .f("M0 0H370V252H0Z", 0xDEDFDB),
            .f("M0 0H370V8H0Z", 0x3E4C55),
            .f("M0 8H370V10H0Z", 0x1E1E1C, 0.1),
            .f("M0 176H370V186H0Z", 0xF2711C),
            .f("M0 186H370V188H0Z", 0x1E1E1C, 0.08),
        ] + spots
    }()

    private nonisolated static let mirror: [PalaceMark] = [
        .f("M184 96H370V246H184Z", 0x9AA3A8),
        .f("M188 100H370V244H188Z", 0xC9D6DC),
        .f("M200 244L250 100H272L222 244Z M262 244L312 100H322L272 244Z", 0xFFFFFF, 0.35),
        .f("M188 236H370V244H188Z", 0x9AA3A8, 0.5),
    ]

    private nonisolated static let floor: [PalaceMark] = {
        var seams = ""
        for x in stride(from: 46.0, to: 370, by: 46) { seams += "M\(x) 252V408" }
        for y in stride(from: 298.0, to: 408, by: 46) { seams += "M0 \(y)H370" }
        return [
            .f("M0 252H370V408H0Z", 0xA7AFAB),
            .s(seams, 0x959D99, 1.2),
            .f("M0 250H370V254H0Z", 0x2E2117),
            .f("M0 254H370V257H0Z", 0x1E1E1C, 0.1),
            .f("M156 364H272Q276 364 276 368V380Q276 384 272 384H156Q152 384 152 380V368Q152 364 156 364Z", 0x2B4C86, 0.55),
        ]
    }()
}
