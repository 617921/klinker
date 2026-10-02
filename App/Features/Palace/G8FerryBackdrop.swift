import SwiftUI

/// The ferry landing's named slots: the far bank (left), the ferry on the water and a tall sign
/// at the right of the landing; four things on the quay behind and four flat ones in front.
enum G8Ferry {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [
        "farBank": PalaceSlot(frame: CGRect(x: 4, y: 52, width: 132, height: 88), pin: CGPoint(x: 6, y: 26), tilt: -1.5),
        "water": PalaceSlot(frame: CGRect(x: 100, y: 138, width: 192, height: 98), pin: CGPoint(x: 196, y: 212), align: .center, tilt: 1),
        "postRight": PalaceSlot(frame: CGRect(x: 300, y: 92, width: 66, height: 150), pin: CGPoint(x: 366, y: 66), align: .trailing, tilt: 1.5),
        "quay1": PalaceSlot(frame: CGRect(x: 4, y: 242, width: 76, height: 68), pin: CGPoint(x: 6, y: 308), tilt: -1),
        "quay2": PalaceSlot(frame: CGRect(x: 84, y: 242, width: 62, height: 68), pin: CGPoint(x: 114, y: 310), align: .center, tilt: 1.5),
        "quay3": PalaceSlot(frame: CGRect(x: 152, y: 242, width: 92, height: 68), pin: CGPoint(x: 198, y: 308), align: .center, tilt: -1.5),
        "quay4": PalaceSlot(frame: CGRect(x: 250, y: 242, width: 116, height: 68), pin: CGPoint(x: 366, y: 308), align: .trailing, tilt: 1),
        "near1": PalaceSlot(frame: CGRect(x: 2, y: 332, width: 90, height: 52), pin: CGPoint(x: 6, y: 382), tilt: 1),
        "near2": PalaceSlot(frame: CGRect(x: 94, y: 332, width: 88, height: 52), pin: CGPoint(x: 138, y: 382), align: .center, tilt: -1),
        "near3": PalaceSlot(frame: CGRect(x: 186, y: 332, width: 88, height: 52), pin: CGPoint(x: 230, y: 382), align: .center, tilt: 1.5),
        "near4": PalaceSlot(frame: CGRect(x: 278, y: 332, width: 88, height: 52), pin: CGPoint(x: 366, y: 382), align: .trailing, tilt: -1),
    ]
}

/// A ferry landing on a wide river: the far bank low on the horizon with sheds, trees and a
/// crane, the water with waves, and a cobbled quay with bollards in front.
struct G8FerryBackdrop: View, Equatable {
    var body: some View {
        PalaceOutdoorBackdrop(houses: [], scale: 1, skyHeight: 140,
                              clouds: [CGRect(x: 180, y: 26, width: 52, height: 11), CGRect(x: 300, y: 12, width: 34, height: 8)],
                              marks: Self.marks)
    }

    nonisolated static let marks: [PalaceMark] = farShore + water + quay

    private nonisolated static let farShore: [PalaceMark] = {
        var trees = ""
        for (i, x) in stride(from: 150.0, to: 380, by: 15).enumerated() where i % 3 != 1 {
            let r = 6.0 + Double(i % 2) * 2
            trees += "M\(x - r) 124a\(r) \(r) 0 1 0 \(2 * r) 0a\(r) \(r) 0 1 0 \(-2 * r) 0Z"
        }
        return [
            .f("M210 124V104H246V124Z M280 124V110H330V124Z", 0x9A968C),
            .f("M206 104L228 96L250 104Z M276 110L305 102L334 110Z", 0x7D7A72),
            .s("M352 124V70M352 72H322M330 72V86", 0x5E6B73, 2.4),
            .f(trees, 0x6E9C52),
            .f("M0 122Q100 118 200 122T370 120V134H0Z", 0x7FA650),
            .f("M0 132H370V136H0Z", 0x8C7A5A),
        ]
    }()

    private nonisolated static let water: [PalaceMark] = {
        var waves = ""
        for (row, y) in [(0, 150.0), (1, 172), (2, 196), (3, 222)] {
            for x in stride(from: Double(row % 2) * 30 + 10, to: 370, by: 60 + Double(row) * 10) {
                waves += "M\(x) \(y)Q\(x + 5) \(y - 3) \(x + 10) \(y)T\(x + 20) \(y)"
            }
        }
        return [
            .f("M0 135H370V240H0Z", G8Water.water),
            .f("M0 135H370V156H0Z", 0xA9CBE0, 0.7),
            .s(waves, 0xFFFDF6, 1.3),
        ]
    }()

    private nonisolated static let quay: [PalaceMark] = {
        var bollards: [PalaceMark] = []
        for x in [92.0, 286] {
            bollards += [.f("M\(x - 5) 246V236Q\(x - 5) 232 \(x) 232Q\(x + 5) 232 \(x + 5) 236V246Z", 0x2E2117), .f("M\(x - 7) 236H\(x + 7)V239H\(x - 7)Z", 0x1E1E1C)]
        }
        return [.f("M0 236H370V246H0Z", 0x5E6B73), .f("M0 236H370V238H0Z", 0x7D8A92)]
            + PalaceOutdoor.cobbles(top: 246, bottom: 408, base: 0xC4B9A2, stone: 0xDDD4C1)
            + bollards
    }()
}
