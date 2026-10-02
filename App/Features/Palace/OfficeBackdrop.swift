import SwiftUI

/// The office's named slots: three things high on the wall, a board lower left, the glass
/// meeting room, three spots on the back desk, two on the front desk and one standing spot.
enum OfficeFloor {
    static let noor = CGPoint(x: 210, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "wallLeft": PalaceSlot(frame: CGRect(x: 8, y: 22, width: 56, height: 62), pin: CGPoint(x: 8, y: 88), tilt: -1.5),
        "wallMid": PalaceSlot(frame: CGRect(x: 72, y: 26, width: 92, height: 56), pin: CGPoint(x: 118, y: 86), align: .center, tilt: 1.5),
        "wallRight": PalaceSlot(frame: CGRect(x: 172, y: 18, width: 58, height: 68), pin: CGPoint(x: 201, y: 90), align: .center, tilt: -1),
        "meeting": PalaceSlot(frame: CGRect(x: 258, y: 26, width: 110, height: 150), pin: CGPoint(x: 313, y: 180), align: .center, tilt: 1.5),
        "boardLow": PalaceSlot(frame: CGRect(x: 8, y: 112, width: 84, height: 70), pin: CGPoint(x: 8, y: 186), tilt: 1),
        "deskLeft": PalaceSlot(frame: CGRect(x: 100, y: 122, width: 48, height: 56), pin: CGPoint(x: 124, y: 214), align: .center, tilt: -1.5),
        "deskMid": PalaceSlot(frame: CGRect(x: 152, y: 118, width: 50, height: 60), pin: CGPoint(x: 178, y: 186), align: .center, tilt: 1.5),
        "deskRight": PalaceSlot(frame: CGRect(x: 208, y: 104, width: 48, height: 74), pin: CGPoint(x: 256, y: 214), align: .trailing, tilt: -1),
        "frontLeft": PalaceSlot(frame: CGRect(x: 6, y: 260, width: 104, height: 76), pin: CGPoint(x: 8, y: 342), tilt: -1.5),
        "frontRight": PalaceSlot(frame: CGRect(x: 120, y: 252, width: 60, height: 84), pin: CGPoint(x: 150, y: 342), align: .center, tilt: 1.5),
        "standing": PalaceSlot(frame: CGRect(x: 290, y: 280, width: 74, height: 122), pin: CGPoint(x: 366, y: 374), align: .trailing, tilt: 2),
    ]
}

/// An open-plan office: a tiled ceiling with light panels, pale green walls, a glass meeting
/// room on the right, a white back desk with drawers, a front desk, a plant and carpet tiles.
struct OfficeBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = {
        var ceiling = "", lights = "", carpet = ""
        for x in stride(from: 0.0, through: 370, by: 46) { ceiling += "M\(x) 0V16" }
        for x in stride(from: 10.0, to: 370, by: 92) { lights += "M\(x) 3H\(x + 26)V12H\(x)Z" }
        for x in stride(from: -10.0, to: 370, by: 40) { carpet += "M\(x) 300L\(x - 14) 408" }
        for y in [326.0, 360, 398] { carpet += "M0 \(y)H370" }
        return [
            .f("M0 0H370V300H0Z", 0xDCE3DF),
            .f("M0 0H370V16H0Z", 0xEFEBE2),
            .s(ceiling, 0xD3D1C7, 1.2),
            .f(lights, 0xFFFDF6),
            .f("M0 16H370V19H0Z", 0xB4B2A9),
            .f("M0 296H370V301H0Z", 0x8C9499),
            // Glass meeting room down to the floor
            .f("M256 22H370V300H256Z", 0x5E6B73),
            .f("M260 178H366V298H260Z", 0xE4ECEE),
            .f("M260 206H366V222H260Z", 0xFFFFFF, 0.6),
            .f("M300 178H302V298H300Z M330 178H332V298H330Z", 0x5E6B73, 0.6),
            .f("M262 298L292 178H300L270 298Z", 0xFFFFFF, 0.3),
            // Back desk with a drawer unit
            .f("M96 176H258V184H96Z", 0xF4F1EA),
            .f("M96 184H258V188H96Z", 0xB4B2A9),
            .s("M104 188V296M200 188V296", 0x8C9499, 3),
            .f("M206 188H254V296H206Z", 0xC9C4B8),
            .s("M206 224H254M206 260H254", 0xB4B2A9, 1.4),
            .s("M224 206H236M224 242H236M224 278H236", 0x5E6B73, 2.4),
            // Carpet
            .f("M0 300H370V408H0Z", 0x9AA4A9),
            .s(carpet, 0x8C969B, 1.2),
            .f("M0 300H370V304H0Z", 0x1E1E1C, 0.1),
            // Front desk
            .f("M0 332H186V340H0Z", 0xF4F1EA),
            .f("M0 340H186V344H0Z", 0xB4B2A9),
            .f("M4 344H182V408H4Z", 0xC9C4B8),
            .s("M4 376H182M92 344V408", 0xB4B2A9, 1.4),
            .s("M40 360H56M128 360H144M40 392H56M128 392H144", 0x5E6B73, 2.4),
        ]
    }()
}
