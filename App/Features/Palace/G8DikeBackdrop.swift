import SwiftUI

/// The dike's named slots: a storm, a flooded farm, a gauge and rising water on the water side
/// (left); the dike in the middle; a rain gauge, a house below the water and a pumping station
/// on the land side (right); an information board, an umbrella and sandbags on the path in front.
enum G8Dike {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [
        "sky": PalaceSlot(frame: CGRect(x: 4, y: 4, width: 120, height: 96), pin: CGPoint(x: 128, y: 18), tilt: -1.5),
        "floodplain": PalaceSlot(frame: CGRect(x: 2, y: 130, width: 88, height: 82), pin: CGPoint(x: 6, y: 92), tilt: 1),
        "gauge": PalaceSlot(frame: CGRect(x: 88, y: 104, width: 40, height: 140), pin: CGPoint(x: 124, y: 236), align: .center, tilt: -1),
        "water": PalaceSlot(frame: CGRect(x: 2, y: 178, width: 84, height: 144), pin: CGPoint(x: 6, y: 296), tilt: 1.5),
        "dike": PalaceSlot(frame: CGRect(x: 96, y: 134, width: 156, height: 196), pin: CGPoint(x: 190, y: 270), align: .center, tilt: -1),
        "polderSky": PalaceSlot(frame: CGRect(x: 296, y: 36, width: 68, height: 100), pin: CGPoint(x: 366, y: 10), align: .trailing, tilt: 1.5),
        "low": PalaceSlot(frame: CGRect(x: 306, y: 166, width: 60, height: 134), pin: CGPoint(x: 366, y: 140), align: .trailing, tilt: -1),
        "pump": PalaceSlot(frame: CGRect(x: 240, y: 190, width: 64, height: 112), pin: CGPoint(x: 262, y: 184), align: .center, tilt: 1),
        "pathLeft": PalaceSlot(frame: CGRect(x: 4, y: 326, width: 100, height: 58), pin: CGPoint(x: 6, y: 382), tilt: -1),
        "pathMid": PalaceSlot(frame: CGRect(x: 112, y: 300, width: 96, height: 84), pin: CGPoint(x: 160, y: 382), align: .center, tilt: 1.5),
        "pathRight": PalaceSlot(frame: CGRect(x: 214, y: 314, width: 152, height: 70), pin: CGPoint(x: 366, y: 382), align: .trailing, tilt: -1.5),
    ]
}

/// A dike seen from the side: high water on the left, the low polder on the right with a ditch,
/// trees and a mill on the horizon, and a grassy path along the front.
struct G8DikeBackdrop: View, Equatable {
    var body: some View {
        PalaceOutdoorBackdrop(houses: [], scale: 1, skyHeight: 408,
                              clouds: [CGRect(x: 170, y: 30, width: 50, height: 11), CGRect(x: 250, y: 14, width: 36, height: 9)],
                              marks: Self.marks)
    }

    nonisolated static let marks: [PalaceMark] = horizon + water + polder + path

    private nonisolated static let horizon: [PalaceMark] = {
        var trees = ""
        for (i, x) in stride(from: 236.0, to: 380, by: 13).enumerated() {
            let r = 6.0 + Double(i % 3) * 1.6
            trees += "M\(x - r) 300a\(r) \(r) 0 1 0 \(2 * r) 0a\(r) \(r) 0 1 0 \(-2 * r) 0Z"
        }
        return [
            .f(trees, 0x6E9C52),
            .f("M276 300V270L280 262L284 270V300Z", 0x6B4A2E),
            .s("M280 266L268 254M280 266L292 278M280 266L292 254M280 266L268 278", 0x3E4C55, 2),
        ]
    }()

    private nonisolated static let water: [PalaceMark] = {
        var waves = ""
        for x in stride(from: 0.0, to: 160, by: 16) { waves += "M\(x) 177Q\(x + 4) 173 \(x + 8) 177T\(x + 16) 177" }
        return [
            .f("M0 176H170V330H0Z", G8Water.water),
            .f("M0 250H170V330H0Z", G8Water.deep, 0.5),
            .s(waves, 0xFFFDF6, 1.4),
            .f("M0 322Q40 316 90 326L110 330H0Z", 0x8C7A5A),
        ]
    }()

    private nonisolated static let polder: [PalaceMark] = [
        .f("M200 300H370V330H200Z", 0xA9C47F),
        .f("M200 300H370V303H200Z", 0x95B36B),
        .f("M300 314H370V319H300Z", G8Water.water),
    ]

    private nonisolated static let path: [PalaceMark] = {
        var tufts = ""
        for (x, y) in [(20.0, 400.0), (110, 396), (210, 402), (300, 398), (356, 404)] as [(Double, Double)] {
            tufts += "M\(x) \(y)l2 -5l2 5l2 -6l2 6"
        }
        return [
            .f("M0 330H370V408H0Z", 0x95B36B),
            .f("M0 330H370V334H0Z", 0x7FA650),
            .f("M0 356H370V376H0Z", 0xE2D6BC),
            .s("M0 356H370M0 376H370", 0xCDBF9E, 1),
            .s(tufts, 0x7FA650, 1.4, round: true),
        ]
    }()
}
