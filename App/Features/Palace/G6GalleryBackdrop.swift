import SwiftUI

/// The gallery's named slots: a poster on the glass door, five places for pictures on the white
/// wall (three high, two low) and five spots on the wooden floor.
enum G6GalleryRoom {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [
        "door": PalaceSlot(frame: CGRect(x: 14, y: 58, width: 72, height: 100), pin: CGPoint(x: 50, y: 160), align: .center, tilt: -1.5),
        "wallLeft": PalaceSlot(frame: CGRect(x: 106, y: 28, width: 76, height: 96), pin: CGPoint(x: 144, y: 118), align: .center, tilt: 1),
        "wallMid": PalaceSlot(frame: CGRect(x: 192, y: 32, width: 84, height: 80), pin: CGPoint(x: 234, y: 106), align: .center, tilt: -1.5),
        "wallRight": PalaceSlot(frame: CGRect(x: 286, y: 28, width: 78, height: 96), pin: CGPoint(x: 366, y: 118), align: .trailing, tilt: 1.5),
        "lowLeft": PalaceSlot(frame: CGRect(x: 104, y: 146, width: 122, height: 84), pin: CGPoint(x: 165, y: 222), align: .center, tilt: -1),
        "lowRight": PalaceSlot(frame: CGRect(x: 234, y: 146, width: 132, height: 84), pin: CGPoint(x: 366, y: 222), align: .trailing, tilt: 1.5),
        "floor1": PalaceSlot(frame: CGRect(x: 4, y: 288, width: 84, height: 116), pin: CGPoint(x: 6, y: 378), tilt: -1.5),
        "floor2": PalaceSlot(frame: CGRect(x: 88, y: 262, width: 92, height: 142), pin: CGPoint(x: 134, y: 378), align: .center, tilt: 1),
        "floor3": PalaceSlot(frame: CGRect(x: 182, y: 304, width: 84, height: 100), pin: CGPoint(x: 224, y: 378), align: .center, tilt: -1),
        "floor4": PalaceSlot(frame: CGRect(x: 266, y: 274, width: 56, height: 130), pin: CGPoint(x: 294, y: 346), align: .center, tilt: 1.5),
        "floor5": PalaceSlot(frame: CGRect(x: 320, y: 292, width: 48, height: 112), pin: CGPoint(x: 366, y: 378), align: .trailing, tilt: -1),
    ]
}

/// A white gallery: spotlights on a ceiling track, a glass entrance door on the left, white walls
/// and a light wooden floor.
struct G6GalleryBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = {
        var spots = "", beams = "", planks = ""
        for x in [144.0, 234, 326] {
            spots += "M\(x - 5) 10H\(x + 5)L\(x + 7) 20H\(x - 3)Z"
            beams += "M\(x - 3) 20L\(x - 40) 130H\(x + 40)L\(x + 7) 20Z"
        }
        for x in stride(from: -20.0, to: 400, by: 34) { planks += "M\(x) 272L\(x - (x - 185) * 0.3) 408" }
        return [
            .f("M0 0H370V272H0Z", 0xF4F1EA),
            .f("M0 0H370V8H0Z", 0xE2DED3),
            .f("M96 6H370V10H96Z", 0x3E4C55),
            .f(spots, 0x1E1E1C),
            .f(beams, 0xFFFDF6, 0.5),
            .f("M0 262H370V272H0Z", 0xE2DED3),
            // glass door
            .f("M6 32H94V272H6Z", 0x3E4C55),
            .f("M12 38H88V266H12Z", 0xCFE0E8),
            .f("M16 266L60 38H76L32 266Z", 0xFFFFFF, 0.35),
            .f("M74 150H80V200H74Z", 0xB4B2A9),
            // floor
            .f("M0 272H370V408H0Z", 0xD9B98C),
            .s(planks, 0xC7A577, 1.2),
            .f("M0 272H370V276H0Z", 0x1E1E1C, 0.08),
        ]
    }()
}
