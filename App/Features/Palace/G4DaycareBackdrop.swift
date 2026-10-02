import SwiftUI

/// The day-care playroom's named slots: a sign over the door, two frames and a paper on the
/// wall, a shelf over the changing table, the doorway, the cot under the window and three spots
/// on the floor.
enum G4Daycare {
    static let noor: CGPoint? = CGPoint(x: 314, y: 290)

    nonisolated static let slots: [String: PalaceSlot] = [
        "signDoor": PalaceSlot(frame: CGRect(x: 292, y: 8, width: 74, height: 50), pin: CGPoint(x: 366, y: 56), align: .trailing, tilt: 1.5),
        "frameLeft": PalaceSlot(frame: CGRect(x: 118, y: 20, width: 86, height: 70), pin: CGPoint(x: 120, y: 86), tilt: -1.5),
        "frameRight": PalaceSlot(frame: CGRect(x: 208, y: 20, width: 80, height: 70), pin: CGPoint(x: 286, y: 86), align: .trailing, tilt: 1),
        "paper": PalaceSlot(frame: CGRect(x: 122, y: 104, width: 58, height: 72), pin: CGPoint(x: 118, y: 172), tilt: 1.5),
        "shelf": PalaceSlot(frame: CGRect(x: 192, y: 104, width: 96, height: 50), pin: CGPoint(x: 288, y: 132), align: .trailing, tilt: -1.5),
        "changer": PalaceSlot(frame: CGRect(x: 184, y: 156, width: 108, height: 98), pin: CGPoint(x: 238, y: 238), align: .center, tilt: 1),
        "doorway": PalaceSlot(frame: CGRect(x: 298, y: 144, width: 68, height: 108), pin: CGPoint(x: 366, y: 236), align: .trailing, tilt: -1.5),
        "cot": PalaceSlot(frame: CGRect(x: 4, y: 196, width: 108, height: 96), pin: CGPoint(x: 8, y: 182), tilt: -1),
        "floorLeft": PalaceSlot(frame: CGRect(x: 14, y: 300, width: 66, height: 104), pin: CGPoint(x: 10, y: 382), tilt: 1.5),
        "floorMid": PalaceSlot(frame: CGRect(x: 92, y: 316, width: 108, height: 88), pin: CGPoint(x: 146, y: 382), align: .center, tilt: -1),
        "floorRight": PalaceSlot(frame: CGRect(x: 208, y: 300, width: 86, height: 104), pin: CGPoint(x: 250, y: 382), align: .center, tilt: 1.5),
    ]
}

/// A bright day-care playroom: butter-yellow walls with a frieze of handprints, a window onto
/// a garden with a sandpit, a stable door, a soft green wainscot and a wooden floor with a round rug.
enum G4DaycareBackdrop {
    nonisolated static let marks: [PalaceMark] = wall + window + door + floor

    private nonisolated static let wall: [PalaceMark] = {
        let colours: [UInt32] = [0xC8261B, 0x2F5BD3, 0x0F6E56, 0xF2711C, 0x3C3489]
        var marks: [PalaceMark] = [
            .f("M0 0H370V252H0Z", 0xF6E7BE),
            .f("M0 0H370V6H0Z", 0xEFEBE2),
            .f("M0 196H370V252H0Z", 0xBFD9B7),
            .f("M0 192H370V198H0Z", 0x6E9C52),
        ]
        for (i, x) in stride(from: 124.0, to: 290, by: 24).enumerated() {
            let c = colours[i % colours.count]
            let y = 10.0 + Double(i % 2) * 2
            marks.append(.oval(x, y, 7, 6, c, 0.7))
            for k in 0..<4 { marks.append(.f("M\(x + Double(k) * 2) \(y + 1)L\(x - 1 + Double(k) * 2.4) \(y - 4)L\(x + 1 + Double(k) * 2.4) \(y - 4)Z", c, 0.7)) }
        }
        return marks
    }()

    private nonisolated static let window: [PalaceMark] = [
        .f("M6 20H112V182H6Z", 0xEFEBE2),
        .f("M12 26H106V176H12Z", 0xBCDCEB),
        .f("M12 130H106V176H12Z", 0x8FC07A),
        .dot(84, 50, 9, 0xFAC775),
        .s("M30 132V102", 0x6B4A2E, 4),
        .dot(30, 94, 16, 0x5E8C45),
        .dot(40, 104, 11, 0x6E9C52),
        .f("M58 160H100V172H58Z", 0xE8D6A8),
        .f("M56 156H102V160H56Z", 0x9A6A42),
        .f("M74 150L80 140L86 150Z", 0xC8261B),
        .s("M59 26V176M12 100H106", 0xEFEBE2, 3),
        .f("M2 176H116V184H2Z", 0xEFEBE2),
        .f("M0 14C10 60 8 130 16 196H0Z", 0xF2B33D),
        .f("M118 14C108 60 110 130 102 196H118Z", 0xF2B33D),
        .dot(6, 60, 2, 0xFFFDF6), .dot(8, 110, 2, 0xFFFDF6), .dot(10, 160, 2, 0xFFFDF6),
        .dot(112, 70, 2, 0xFFFDF6), .dot(110, 120, 2, 0xFFFDF6), .dot(108, 170, 2, 0xFFFDF6),
        .s("M0 15H120", 0x6B4A2E, 3),
    ]

    private nonisolated static let door: [PalaceMark] = [
        .f("M294 60H370V254H294Z", 0xEFEBE2),
        .f("M300 66H370V254H300Z", 0x5A4636),
        .f("M300 160H370V254H300Z", 0x5DCAA5),
        .f("M304 166H366V248H304Z", 0x4FB894),
        .f("M300 156H370V162H300Z", 0x3F9C7C),
        .f("M310 74H360V140H310Z", 0x8A6A4E, 0.6),
    ]

    private nonisolated static let floor: [PalaceMark] = {
        var planks = ""
        for (r, y) in [278.0, 306, 338, 374].enumerated() {
            planks += "M0 \(y)H370"
            var x = Double(r % 2) * 50 + 30
            while x < 370 {
                planks += "M\(x) \(y)V\(r == 0 ? 252 : [278.0, 306, 338][r - 1])"
                x += 100
            }
        }
        return [
            .f("M0 252H370V408H0Z", 0xD9B68A),
            .s(planks, 0xC09A6C, 1.3),
            .f("M0 252H370V256H0Z", 0x1E1E1C, 0.1),
            .oval(84, 330, 220, 70, 0x2F5BD3, 0.85),
            .oval(100, 336, 188, 58, 0xFAC775),
            .oval(122, 344, 144, 42, 0xC8261B, 0.85),
            .oval(146, 352, 96, 26, 0x5DCAA5),
        ]
    }()
}
