import SwiftUI

/// The farm's named slots: a far spot on each side of the barn and the barn itself, four spots
/// in the middle (meadow, stall, lane, animals) and four in front.
enum G7Farm {
    static let noor = CGPoint(x: 300, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "farLeft": PalaceSlot(frame: CGRect(x: 4, y: 64, width: 112, height: 116), pin: CGPoint(x: 6, y: 150), tilt: -1.5),
        "barn": PalaceSlot(frame: CGRect(x: 118, y: 30, width: 140, height: 160), pin: CGPoint(x: 188, y: 26), align: .center, tilt: 1),
        "farRight": PalaceSlot(frame: CGRect(x: 260, y: 80, width: 106, height: 110), pin: CGPoint(x: 366, y: 154), align: .trailing, tilt: 1.5),
        "midLeft": PalaceSlot(frame: CGRect(x: 4, y: 190, width: 98, height: 86), pin: CGPoint(x: 6, y: 254), tilt: 1),
        "midStall": PalaceSlot(frame: CGRect(x: 104, y: 186, width: 76, height: 104), pin: CGPoint(x: 142, y: 264), align: .center, tilt: -1.5),
        "midLane": PalaceSlot(frame: CGRect(x: 182, y: 210, width: 92, height: 80), pin: CGPoint(x: 228, y: 270), align: .center, tilt: 1.5),
        "midRight": PalaceSlot(frame: CGRect(x: 276, y: 186, width: 90, height: 100), pin: CGPoint(x: 366, y: 284), align: .trailing, tilt: -1),
        "frontLeft": PalaceSlot(frame: CGRect(x: 4, y: 286, width: 62, height: 118), pin: CGPoint(x: 6, y: 376), tilt: 1.5),
        "frontMid": PalaceSlot(frame: CGRect(x: 70, y: 300, width: 118, height: 104), pin: CGPoint(x: 150, y: 306), align: .center, tilt: -1),
        "frontMidRight": PalaceSlot(frame: CGRect(x: 192, y: 296, width: 88, height: 108), pin: CGPoint(x: 236, y: 380), align: .center, tilt: 1),
        "frontRight": PalaceSlot(frame: CGRect(x: 284, y: 318, width: 82, height: 74), pin: CGPoint(x: 366, y: 380), align: .trailing, tilt: -1.5),
    ]
}

/// Open farmland: a low horizon with trees, long green fields, a sandy lane up to the barn.
struct G7FarmBackdrop: View, Equatable {
    var body: some View {
        PalaceOutdoorBackdrop(houses: [], scale: 1, skyHeight: 132,
                              clouds: [CGRect(x: 30, y: 26, width: 46, height: 10), CGRect(x: 290, y: 40, width: 40, height: 9)],
                              marks: Self.marks)
    }

    nonisolated static let marks: [PalaceMark] = {
        var trees = ""
        for (x, r) in [(8.0, 7.0), (20, 9), (34, 6), (112, 6), (124, 8), (262, 7), (276, 9), (346, 8), (360, 6)] {
            trees += "M\(x - r) 130a\(r) \(r) 0 1 0 \(2 * r) 0a\(r) \(r) 0 1 0 \(-2 * r) 0Z"
        }
        var tufts = ""
        for (x, y) in [(30.0, 300.0), (180, 300), (300, 300), (60, 396), (170, 400), (330, 300), (250, 396)] {
            tufts += "M\(x) \(y)l2 -5l2 5l2 -6l2 6"
        }
        return [
            .f(trees, 0x6E8C5A),
            .f("M0 128H370V408H0Z", 0x9DBB72),
            .f("M0 128H370V134H0Z", 0x7FA650),
            .f("M0 150H370V176H0Z M0 214H370V250H0Z", 0x92B169),
            .f("M0 176H370V182H0Z", 0x8FB6CF, 0.8),
            .f("M150 408C160 330 190 250 186 190H198C206 250 236 330 260 408Z", 0xD9CDB4),
            .f("M170 360a6 2 0 1 0 12 0a6 2 0 1 0 -12 0Z M214 320a5 1.6 0 1 0 10 0a5 1.6 0 1 0 -10 0Z", 0xB49A66),
            .s(tufts, 0x7FA650, 1.4, round: true),
        ]
    }()
}
