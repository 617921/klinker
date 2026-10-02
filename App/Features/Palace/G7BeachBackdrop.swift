import SwiftUI

/// The beach's named slots: the promenade on the dune, the pavilion at its foot, a sheltered spot
/// below it and the lifeguard's chair; out at sea, by the water's edge and in the surf; and four
/// spots on the sand in front.
enum G7Beach {
    static let noor = CGPoint(x: 160, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "dune": PalaceSlot(frame: CGRect(x: 0, y: 18, width: 168, height: 84), pin: CGPoint(x: 6, y: 18), tilt: -1.5),
        "duneFoot": PalaceSlot(frame: CGRect(x: 4, y: 100, width: 124, height: 94), pin: CGPoint(x: 6, y: 172), tilt: 1),
        "sheltered": PalaceSlot(frame: CGRect(x: 4, y: 196, width: 124, height: 94), pin: CGPoint(x: 6, y: 266), tilt: -1),
        "chair": PalaceSlot(frame: CGRect(x: 134, y: 104, width: 76, height: 144), pin: CGPoint(x: 172, y: 232), align: .center, tilt: 1.5),
        "seaFar": PalaceSlot(frame: CGRect(x: 226, y: 104, width: 140, height: 84), pin: CGPoint(x: 366, y: 172), align: .trailing, tilt: 1),
        "waterEdge": PalaceSlot(frame: CGRect(x: 234, y: 190, width: 64, height: 110), pin: CGPoint(x: 268, y: 302), align: .center, tilt: -1.5),
        "surf": PalaceSlot(frame: CGRect(x: 272, y: 290, width: 94, height: 114), pin: CGPoint(x: 366, y: 380), align: .trailing, tilt: 1.5),
        "sandLeft": PalaceSlot(frame: CGRect(x: 4, y: 290, width: 66, height: 114), pin: CGPoint(x: 6, y: 378), tilt: 1),
        "sandBottle": PalaceSlot(frame: CGRect(x: 72, y: 318, width: 48, height: 86), pin: CGPoint(x: 80, y: 298), tilt: -2),
        "sandMid": PalaceSlot(frame: CGRect(x: 120, y: 320, width: 88, height: 62), pin: CGPoint(x: 166, y: 384), align: .center, tilt: 1),
        "wetSand": PalaceSlot(frame: CGRect(x: 212, y: 330, width: 64, height: 54), pin: CGPoint(x: 244, y: 384), align: .center, tilt: -1),
    ]
}

/// The North Sea coast: dunes with marram grass on the left, the sea running away to the right
/// horizon, a curving line of surf and wet sand, and dry sand in front.
struct G7BeachBackdrop: View, Equatable {
    var body: some View {
        PalaceOutdoorBackdrop(houses: [], scale: 1, skyHeight: 104,
                              clouds: [CGRect(x: 200, y: 22, width: 52, height: 12), CGRect(x: 310, y: 50, width: 36, height: 9)],
                              marks: Self.marks)
    }

    nonisolated static let marks: [PalaceMark] = sand + sea + dunes

    private nonisolated static let shore = "M120 100C170 180 220 260 300 408"

    private nonisolated static let sand: [PalaceMark] = [
        .f("M0 96H370V408H0Z", 0xEEDDB2),
        .f("M0 300Q120 290 200 320T300 408H0Z", 0xF2E4BE),
        .s("M30 330q6 -3 12 0M150 300q6 -3 12 0M90 390q6 -3 12 0M190 270q6 -3 12 0M60 250q6 -3 12 0", 0xD9C08F, 1.4, round: true),
    ]

    private nonisolated static let sea: [PalaceMark] = [
        .f("M112 100C162 180 212 262 288 408H312C232 260 182 180 128 100Z", 0xD9C08F),
        .f("M128 100H370V408H312C232 260 182 180 128 100Z", 0x7FA7C0),
        .f("M150 100H370V128H158Z", 0x8FB6CF),
        .f("M128 100H370V104H128Z", 0x6E95AE),
        .s("M128 100C182 180 232 260 312 408", 0xFFFFFF, 3, round: true, 0.85),
        .s("M150 112C196 186 248 264 326 408", 0xFFFFFF, 1.4, round: true, 0.5),
        .s("M250 130q5 -3 10 0t10 0M300 150q5 -3 10 0t10 0M330 230q5 -3 10 0t10 0M280 260q5 -3 10 0t10 0", 0xFFFFFF, 1.3, round: true, 0.7),
    ]

    private nonisolated static let dunes: [PalaceMark] = {
        var grass = ""
        for (x, y) in [(10.0, 102.0), (40, 96), (70, 100), (104, 104), (130, 108), (24, 120), (90, 118), (150, 112)] {
            grass += "M\(x) \(y)l-4 -10M\(x) \(y)l0 -12M\(x) \(y)l4 -10"
        }
        return [
            .f("M0 80Q30 70 60 84Q100 64 140 88Q160 96 176 112Q150 126 110 122Q60 130 0 124Z", 0xE2CC98),
            .f("M0 104Q50 96 90 110Q130 104 176 112Q150 126 110 122Q60 130 0 124Z", 0xD9C08F),
            .s(grass, 0x8DAE62, 1.6, round: true),
        ]
    }()
}
