import SwiftUI

/// The market square's named slots: a far stall on the left, three things hanging from the
/// awning rail of the near stall, four spots on its counter, and the cobbles in front.
enum MarketSquare {
    static let noor = CGPoint(x: 112, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "stallFar": PalaceSlot(frame: CGRect(x: 6, y: 92, width: 124, height: 112), pin: CGPoint(x: 68, y: 198), align: .center, tilt: -1.5),
        "hangLeft": PalaceSlot(frame: CGRect(x: 148, y: 84, width: 80, height: 58), pin: CGPoint(x: 152, y: 138), tilt: 1.5),
        "hangMid": PalaceSlot(frame: CGRect(x: 230, y: 84, width: 62, height: 64), pin: CGPoint(x: 256, y: 140), align: .center, tilt: -1.5),
        "hangRight": PalaceSlot(frame: CGRect(x: 302, y: 84, width: 60, height: 66), pin: CGPoint(x: 366, y: 152), align: .trailing, tilt: 2),
        "counter1": PalaceSlot(frame: CGRect(x: 150, y: 172, width: 56, height: 62), pin: CGPoint(x: 178, y: 240), align: .center, tilt: -1),
        "counter2": PalaceSlot(frame: CGRect(x: 210, y: 188, width: 50, height: 46), pin: CGPoint(x: 236, y: 240), align: .center, tilt: 1.5),
        "counter3": PalaceSlot(frame: CGRect(x: 262, y: 190, width: 52, height: 44), pin: CGPoint(x: 288, y: 240), align: .center, tilt: -1.5),
        "counter4": PalaceSlot(frame: CGRect(x: 316, y: 180, width: 52, height: 54), pin: CGPoint(x: 366, y: 268), align: .trailing, tilt: 1),
        "talk": PalaceSlot(frame: CGRect(x: 52, y: 222, width: 100, height: 66), pin: CGPoint(x: 6, y: 284), tilt: 1.5),
        "floorLeft": PalaceSlot(frame: CGRect(x: 6, y: 316, width: 100, height: 78), pin: CGPoint(x: 6, y: 370), tilt: -1.5),
        "floorRight": PalaceSlot(frame: CGRect(x: 182, y: 298, width: 84, height: 70), pin: CGPoint(x: 226, y: 366), align: .center, tilt: 2),
    ]
}

/// A Dutch market on a square: canal houses across the back, bunting, the cobbles, and a stall
/// with a red and white awning, a rail to hang signs from and an empty counter.
struct MarketSquareBackdrop: View, Equatable {
    nonisolated static let scale: CGFloat = 0.5
    nonisolated static let houses = PalaceOutdoor.row(PalaceOutdoor.street(count: 11, shops: [1, 6]), scale: scale, baseline: 180)

    var body: some View {
        PalaceOutdoorBackdrop(houses: Self.houses, scale: Self.scale, skyHeight: 186,
                              clouds: [CGRect(x: 24, y: 18, width: 46, height: 11), CGRect(x: 250, y: 12, width: 38, height: 9)],
                              marks: Self.marks)
    }

    nonisolated static let marks: [PalaceMark] = square + PalaceOutdoor.bunting(-4, 140, 32, sag: 8) + stall

    private nonisolated static let square: [PalaceMark] =
        [.f("M0 180H370V186H0Z", 0xA19E95), .f("M0 186H370V188H0Z", 0x6E6B64)]
            + PalaceOutdoor.cobbles(top: 188, bottom: 408, base: 0xC4B9A2, stone: 0xDDD4C1)

    private nonisolated static let stall: [PalaceMark] = {
        var stripes = "", roof = "", scallops = ""
        for (i, x) in stride(from: 136.0, to: 370, by: 14).enumerated() where i % 2 == 0 {
            stripes += "M\(x) 60H\(x + 14)V78H\(x)Z"
            scallops += "M\(x) 78A7 6 0 0 0 \(x + 14) 78Z"
            let top = 152 + (x - 136) * (218.0 / 234)
            roof += "M\(x) 60L\(top) 42H\(top + 13)L\(x + 14) 60Z"
        }
        var whites = ""
        for x in stride(from: 150.0, to: 370, by: 28) { whites += "M\(x) 78A7 6 0 0 0 \(x + 14) 78Z" }
        var planks = ""
        for y in stride(from: 254.0, to: 300, by: 11) { planks += "M146 \(y)H366" }
        var fringe = "M146 240H366V250"
        for x in stride(from: 366.0, to: 146, by: -6) { fringe += "L\(x - 3) 255L\(x - 6) 250" }
        return [
            // Shade under the awning
            .f("M146 78H366V232H146Z", 0x1E1E1C, 0.08),
            // Poles
            .f("M144 56H148V302H144Z M362 56H366V302H362Z", 0x5E6B73),
            .f("M144 56H145.5V302H144Z M362 56H363.5V302H362Z", 0x7D8A92),
            // Awning: slanted roof and the front valance with scallops
            .f("M136 60L152 42H370V60Z", 0xFFFDF6),
            .f(roof, 0xC8261B),
            .f("M136 60H370V78H136Z", 0xFFFDF6),
            .f(stripes, 0xC8261B),
            .f(scallops, 0xC8261B),
            .f(whites, 0xFFFDF6),
            .f("M136 59H370V61H136Z", 0x1E1E1C, 0.12),
            // Rail the signs hang from
            .f("M146 82H366V85H146Z", 0x4A3524),
            // Counter: top, front planks and a green grass mat over the edge
            .f("M140 230H370V238H140Z", 0xC9965F),
            .f("M140 238H370V240H140Z", 0x6B4A2E),
            .f("M146 240H366V300H146Z", 0x9A6A42),
            .s(planks, 0x8A5C38, 1.4),
            .f(fringe + "Z", 0x5E8C45),
            .f("M146 300H366V304H146Z", 0x1E1E1C, 0.14),
        ]
    }()
}
