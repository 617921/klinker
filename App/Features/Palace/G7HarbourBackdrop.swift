import SwiftUI

/// The harbour's named slots: four spots on the water (a lock on the left, the big ship, a boat
/// far out and one close by), the quay edge, and six spots on the quay in two rows.
enum G7Harbour {
    static let noor = CGPoint(x: 314, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "waterLeft": PalaceSlot(frame: CGRect(x: 4, y: 92, width: 90, height: 128), pin: CGPoint(x: 6, y: 72), tilt: -1.5),
        "waterMid": PalaceSlot(frame: CGRect(x: 96, y: 86, width: 188, height: 136), pin: CGPoint(x: 190, y: 64), align: .center, tilt: 1),
        "waterFar": PalaceSlot(frame: CGRect(x: 296, y: 66, width: 70, height: 84), pin: CGPoint(x: 366, y: 44), align: .trailing, tilt: 1.5),
        "waterNear": PalaceSlot(frame: CGRect(x: 284, y: 154, width: 84, height: 66), pin: CGPoint(x: 366, y: 222), align: .trailing, tilt: -1),
        "quayBackLeft": PalaceSlot(frame: CGRect(x: 4, y: 196, width: 58, height: 118), pin: CGPoint(x: 6, y: 292), tilt: -1),
        "quayBackMid": PalaceSlot(frame: CGRect(x: 64, y: 210, width: 98, height: 104), pin: CGPoint(x: 112, y: 288), align: .center, tilt: 1.5),
        "edge": PalaceSlot(frame: CGRect(x: 166, y: 196, width: 58, height: 66), pin: CGPoint(x: 194, y: 260), align: .center, tilt: 1.5),
        "quayBackRight": PalaceSlot(frame: CGRect(x: 228, y: 250, width: 138, height: 70), pin: CGPoint(x: 290, y: 266), align: .center, tilt: -1.5),
        "quayFrontLeft": PalaceSlot(frame: CGRect(x: 4, y: 318, width: 94, height: 86), pin: CGPoint(x: 6, y: 380), tilt: 1),
        "quayFrontMid": PalaceSlot(frame: CGRect(x: 100, y: 314, width: 124, height: 90), pin: CGPoint(x: 106, y: 380), tilt: -1.5),
        "quayFrontRight": PalaceSlot(frame: CGRect(x: 228, y: 300, width: 138, height: 104), pin: CGPoint(x: 362, y: 380), align: .trailing, tilt: 1),
    ]
}

/// A port on a wide water: the city's gables and big cranes across the water, the basin with
/// little waves, and the stone quay in front with its edge.
struct G7HarbourBackdrop: View, Equatable {
    nonisolated static let scale: CGFloat = 0.34
    nonisolated static let houses = PalaceOutdoor.row(PalaceOutdoor.street(count: 7, floors: [3, 4, 3, 4]), scale: scale, baseline: 104)

    var body: some View {
        PalaceOutdoorBackdrop(houses: Self.houses, scale: Self.scale, skyHeight: 110,
                              clouds: [CGRect(x: 120, y: 16, width: 46, height: 10), CGRect(x: 236, y: 10, width: 36, height: 8)],
                              marks: Self.marks)
    }

    nonisolated static let marks: [PalaceMark] = farQuay + cranes + water + quay

    private nonisolated static let farQuay: [PalaceMark] = {
        var boxes: [PalaceMark] = []
        let colors: [UInt32] = [0xC8261B, 0x2F5BD3, 0x0F6E56, 0xF2711C, 0x5E6B73, 0xC9A15B]
        for (i, x) in stride(from: 206.0, to: 366, by: 16).enumerated() {
            for row in 0..<(i % 3 == 0 ? 3 : 2) {
                boxes.append(.box(x, 96 - Double(row) * 7, 15, 6.4, colors[(i + row * 2) % colors.count]))
            }
        }
        return [
            .f("M180 76H232V104H180Z", 0x9A5238),
            .f("M176 76L206 64L236 76Z", 0x7B3F2E),
            .f("M188 88H196V104H188Z M204 88H212V104H204Z M220 88H228V104H220Z", 0x5E3A2A),
            .f("M0 102H370V112H0Z", 0xA19E95),
            .f("M0 110H370V112H0Z", 0x6E6B64),
        ] + boxes
    }()

    /// Two container cranes on the far quay.
    private nonisolated static let cranes: [PalaceMark] = [(250.0, 0x2F5BD3 as UInt32), (318, 0xF2711C)].flatMap { x, c -> [PalaceMark] in
        [
            .s("M\(x) 104L\(x + 8) 36L\(x + 16) 104M\(x + 28) 104L\(x + 36) 36L\(x + 44) 104", c, 3),
            .s("M\(x + 4) 76H\(x + 40)", c, 2),
            .f("M\(x - 24) 32H\(x + 66)V38H\(x - 24)Z", c),
            .f("M\(x + 14) 22H\(x + 30)V32H\(x + 14)Z", PalaceInk.shade(c, 0.8)),
            .s("M\(x + 22) 38V58", 0x2E2117, 1),
            .f("M\(x + 16) 58H\(x + 28)V64H\(x + 16)Z", 0x3E4C55),
        ]
    }

    private nonisolated static let water: [PalaceMark] = {
        var ripples = ""
        let spots: [(Double, Double, Double)] = [
            (20, 124, 14), (70, 134, 10), (150, 126, 12), (230, 136, 14), (300, 122, 10), (340, 146, 12),
            (30, 172, 16), (110, 186, 12), (200, 210, 16), (260, 196, 12), (40, 212, 14), (330, 212, 14),
        ]
        for (x, y, w) in spots { ripples += "M\(x) \(y)q\(w / 4) -3 \(w / 2) 0t\(w / 2) 0" }
        return [
            .f("M0 112H370V222H0Z", 0x8FB6CF),
            .f("M0 112H370V124H0Z", 0xA9CBE0),
            .f("M0 186H370V222H0Z", 0x7FA7C0),
            .s(ripples, 0xFFFFFF, 1.3, round: true, 0.7),
        ]
    }()

    /// The near quay: a row of coping stones along the water and cobbles to the front.
    private nonisolated static let quay: [PalaceMark] = {
        var joints = ""
        for x in stride(from: 14.0, to: 370, by: 30) { joints += "M\(x) 220V230" }
        return [
            .f("M0 216H370V222H0Z", 0x1E1E1C, 0.12),
            .f("M0 220H370V231H0Z", 0xB4B2A9),
            .f("M0 220H370V222H0Z", 0xD3D1C7),
            .s(joints, 0x8E8A80, 1),
        ] + PalaceOutdoor.cobbles(top: 231, bottom: 408, base: 0xB4AD9C, stone: 0xCFC8B6)
            + [.f("M0 231H370V234H0Z", 0x1E1E1C, 0.1)]
    }()
}
