import SwiftUI

/// The park's named slots in three bands: far away (stage, pond, playground), the middle
/// (lawn, path, a sign, a bench) and up close (walkers, a low sign, the litter).
enum CityPark {
    static let noor = CGPoint(x: 214, y: 290)

    nonisolated static let slots: [String: PalaceSlot] = [
        "farLeft": PalaceSlot(frame: CGRect(x: 4, y: 50, width: 122, height: 106), pin: CGPoint(x: 64, y: 146), align: .center, tilt: -1.5),
        "farMid": PalaceSlot(frame: CGRect(x: 128, y: 128, width: 116, height: 54), pin: CGPoint(x: 186, y: 170), align: .center, tilt: 1.5),
        "farRight": PalaceSlot(frame: CGRect(x: 248, y: 62, width: 118, height: 100), pin: CGPoint(x: 366, y: 150), align: .trailing, tilt: 1),
        "midLeft": PalaceSlot(frame: CGRect(x: 4, y: 182, width: 116, height: 58), pin: CGPoint(x: 6, y: 232), tilt: -1),
        "path": PalaceSlot(frame: CGRect(x: 128, y: 176, width: 62, height: 108), pin: CGPoint(x: 159, y: 272), align: .center, tilt: 2),
        "signHigh": PalaceSlot(frame: CGRect(x: 200, y: 186, width: 50, height: 96), pin: CGPoint(x: 226, y: 236), align: .center, tilt: -2),
        "midRight": PalaceSlot(frame: CGRect(x: 258, y: 214, width: 106, height: 58), pin: CGPoint(x: 366, y: 262), align: .trailing, tilt: 1.5),
        "nearLeft": PalaceSlot(frame: CGRect(x: 2, y: 286, width: 114, height: 116), pin: CGPoint(x: 6, y: 366), tilt: 1.5),
        "nearMid": PalaceSlot(frame: CGRect(x: 120, y: 290, width: 84, height: 112), pin: CGPoint(x: 160, y: 380), align: .center, tilt: -1.5),
        "signLow": PalaceSlot(frame: CGRect(x: 208, y: 296, width: 60, height: 104), pin: CGPoint(x: 238, y: 352), align: .center, tilt: 1),
        "nearRight": PalaceSlot(frame: CGRect(x: 276, y: 300, width: 90, height: 68), pin: CGPoint(x: 366, y: 368), align: .trailing, tilt: -1.5),
    ]
}

/// A city park: the canal houses peeking over a row of trees, a wide meadow and a gravel path
/// that winds from the viewer to the pond.
struct ParkBackdrop: View, Equatable {
    nonisolated static let scale: CGFloat = 0.36
    nonisolated static let houses = PalaceOutdoor.row(PalaceOutdoor.street(count: 16, floors: [3, 4, 3, 2]), scale: scale, baseline: 132)

    var body: some View {
        PalaceOutdoorBackdrop(houses: Self.houses, scale: Self.scale, skyHeight: 140,
                              clouds: [CGRect(x: 150, y: 20, width: 52, height: 12), CGRect(x: 300, y: 34, width: 36, height: 9)],
                              marks: Self.marks)
    }

    nonisolated static let marks: [PalaceMark] = treeLine + meadow + path

    private nonisolated static let treeLine: [PalaceMark] = {
        var dark = "", light = ""
        for (i, x) in stride(from: -10.0, to: 390, by: 26).enumerated() {
            let r = 18.0 + Double((i * 7) % 5) * 2.5
            let y = 124.0 - Double((i * 5) % 3) * 4
            let circle = "M\(x - r) \(y)a\(r) \(r) 0 1 0 \(2 * r) 0a\(r) \(r) 0 1 0 \(-2 * r) 0Z"
            if i % 2 == 0 { dark += circle } else { light += circle }
        }
        return [.f(light, 0x5E8C45), .f(dark, 0x4E7A3A), .f("M0 128H370V146H0Z", 0x4E7A3A)]
    }()

    private nonisolated static let meadow: [PalaceMark] = {
        var tufts = ""
        let spots: [(Double, Double)] = [
            (20, 170), (96, 160), (240, 168), (330, 176), (60, 262), (140, 300), (300, 300), (24, 404),
            (200, 396), (350, 296), (110, 250), (250, 280), (176, 160), (340, 404), (90, 404),
        ]
        for (x, y) in spots { tufts += "M\(x) \(y)l2 -5l2 5l2 -6l2 6" }
        return [
            .f("M0 144H370V408H0Z", 0xA9C47F),
            .f("M0 144H370V156H0Z", 0x95B36B),
            .s(tufts, 0x7FA650, 1.4, round: true),
        ]
    }()

    private nonisolated static let path: [PalaceMark] = {
        let d = "M112 408C140 340 116 300 160 248C182 222 192 200 184 176H198C212 202 204 228 184 254C150 300 176 344 238 408Z"
        var gravel = ""
        for (x, y) in [(150.0, 380.0), (176, 360), (162, 330), (148, 300), (170, 270), (180, 240), (194, 210), (190, 190), (206, 392), (140, 350)] {
            gravel += "M\(x) \(y)a1.4 1.4 0 1 0 0.01 0Z"
        }
        return [.f(d, 0xE2D6BC), .s(d, 0xCDBF9E, 1.6), .f(gravel, 0xCDBF9E)]
    }()
}
