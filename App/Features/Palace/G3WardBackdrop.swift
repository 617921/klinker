import SwiftUI

/// The hospital ward's named slots: three signs high up, the theatre door on the left, two spots on
/// the wall, two beds along the back wall and three spots on the floor.
enum G3Ward {
    static let noor = CGPoint(x: 206, y: 294)

    nonisolated static let slots: [String: PalaceSlot] = [
        "signLeft": PalaceSlot(frame: CGRect(x: 6, y: 10, width: 114, height: 58), pin: CGPoint(x: 10, y: 68), tilt: -2),
        "signMid": PalaceSlot(frame: CGRect(x: 128, y: 4, width: 116, height: 66), pin: CGPoint(x: 186, y: 76), align: .center, tilt: 1.5),
        "signRight": PalaceSlot(frame: CGRect(x: 252, y: 12, width: 112, height: 80), pin: CGPoint(x: 362, y: 88), align: .trailing, tilt: -1.5),
        "door": PalaceSlot(frame: CGRect(x: 2, y: 102, width: 88, height: 194), pin: CGPoint(x: 6, y: 262), tilt: 1.5),
        "wallLeft": PalaceSlot(frame: CGRect(x: 98, y: 88, width: 62, height: 74), pin: CGPoint(x: 96, y: 152), tilt: -1.5),
        "wallRight": PalaceSlot(frame: CGRect(x: 300, y: 110, width: 64, height: 74), pin: CGPoint(x: 366, y: 176), align: .trailing, tilt: 1.5),
        "bedLeft": PalaceSlot(frame: CGRect(x: 92, y: 178, width: 142, height: 116), pin: CGPoint(x: 160, y: 270), align: .center, tilt: -1),
        "bedRight": PalaceSlot(frame: CGRect(x: 232, y: 178, width: 136, height: 116), pin: CGPoint(x: 300, y: 270), align: .center, tilt: 1),
        "floorLeft": PalaceSlot(frame: CGRect(x: 2, y: 292, width: 104, height: 114), pin: CGPoint(x: 4, y: 376), tilt: -1.5),
        "floorMid": PalaceSlot(frame: CGRect(x: 114, y: 280, width: 70, height: 126), pin: CGPoint(x: 150, y: 376), align: .center, tilt: 1.5),
        "floorRight": PalaceSlot(frame: CGRect(x: 292, y: 290, width: 70, height: 116), pin: CGPoint(x: 366, y: 376), align: .trailing, tilt: -1),
    ]
}

/// A hospital ward: cool green walls with a handrail, a curtain rail over the beds, a window with a
/// blind and a speckled vinyl floor.
struct G3WardBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = wall + window + curtains + floor

    private nonisolated static let wall: [PalaceMark] = [
        .f("M0 0H370V296H0Z", 0xE1E8E4),
        .f("M0 204H370V296H0Z", 0xC6D5CF, 0.6),
        .f("M0 196H370V203H0Z", 0xB4B2A9),
        .f("M0 203H370V205H0Z", 0x1E1E1C, 0.08),
        .f("M0 0H370V8H0Z", 0xEFEBE2),
        .f("M0 8H370V10H0Z", 0x1E1E1C, 0.07),
        .f("M150 3H220V8H150Z", 0xFFFDF6),
    ]

    private nonisolated static let window: [PalaceMark] = {
        var slats = ""
        for y in stride(from: 104.0, through: 126, by: 5) { slats += "M174 \(y)H286" }
        return [
            .f("M166 94H294V172H166Z", 0xEFEBE2),
            .f("M172 100H288V166H172Z", 0xBCCDD6),
            .f("M172 134H288V166H172Z", 0xD3E0E6),
            .f("M180 158L198 134H206L188 158Z M244 166L262 140H270L252 166Z", 0xFFFFFF, 0.4),
            .f("M172 100H288V130H172Z", 0xF4F1EA),
            .s(slats, 0xD3D1C7, 1),
            .f("M172 128H288V131H172Z", 0xB4B2A9),
            .f("M162 170H298V176H162Z", 0xEFEBE2),
        ]
    }()

    private nonisolated static let curtains: [PalaceMark] = [
        .s("M94 40H368", 0xB4B2A9, 2.5),
        .f("M226 42H244L246 196H224Z", 0xA9CBE0),
        .s("M230 44V194M235 44V196M240 44V194", 0x8FB6CF, 1),
        .f("M344 42H368V196H340Z", 0xA9CBE0),
        .s("M350 44V194M356 44V196M362 44V194", 0x8FB6CF, 1),
    ]

    private nonisolated static let floor: [PalaceMark] = {
        var specks = ""
        for i in 0..<70 {
            let x = Double((i * 53) % 368) + 1, y = 302 + Double((i * 37) % 102)
            specks += "M\(x) \(y)h2v1.4h-2Z"
        }
        return [
            .f("M0 296H370V408H0Z", 0xDCE3DE),
            .f(specks, 0xB9C4BF),
            .s("M0 340H370M0 384H370", 0xCBD4CE, 1),
            .f("M0 294H370V298H0Z", 0x5E6B73),
            .f("M0 298H370V301H0Z", 0x1E1E1C, 0.08),
        ]
    }()
}
