import SwiftUI

/// The TV studio's named slots: four things on the dark wall, three on the raised set (left,
/// middle, right) and four on the studio floor. Noor is not in this room by default.
enum G2Studio {
    static let noor = CGPoint(x: 222, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "wallA": PalaceSlot(frame: CGRect(x: 6, y: 28, width: 84, height: 70), pin: CGPoint(x: 6, y: 98), tilt: -1.5),
        "wallB": PalaceSlot(frame: CGRect(x: 96, y: 28, width: 84, height: 70), pin: CGPoint(x: 132, y: 102), align: .center, tilt: 1.5),
        "wallC": PalaceSlot(frame: CGRect(x: 188, y: 28, width: 84, height: 70), pin: CGPoint(x: 182, y: 98), tilt: -1),
        "wallD": PalaceSlot(frame: CGRect(x: 280, y: 28, width: 84, height: 70), pin: CGPoint(x: 366, y: 102), align: .trailing, tilt: 1.5),
        "setLeft": PalaceSlot(frame: CGRect(x: 6, y: 132, width: 98, height: 96), pin: CGPoint(x: 6, y: 232), tilt: 1),
        "setMid": PalaceSlot(frame: CGRect(x: 112, y: 112, width: 146, height: 120), pin: CGPoint(x: 185, y: 236), align: .center, tilt: -1.5),
        "setRight": PalaceSlot(frame: CGRect(x: 266, y: 128, width: 100, height: 100), pin: CGPoint(x: 366, y: 232), align: .trailing, tilt: 1.5),
        "floorA": PalaceSlot(frame: CGRect(x: 4, y: 266, width: 88, height: 112), pin: CGPoint(x: 4, y: 380), tilt: -1.5),
        "floorB": PalaceSlot(frame: CGRect(x: 94, y: 282, width: 94, height: 96), pin: CGPoint(x: 140, y: 384), align: .center, tilt: 1.5),
        "floorC": PalaceSlot(frame: CGRect(x: 190, y: 264, width: 84, height: 114), pin: CGPoint(x: 232, y: 352), align: .center, tilt: -1),
        "floorD": PalaceSlot(frame: CGRect(x: 280, y: 262, width: 86, height: 116), pin: CGPoint(x: 366, y: 382), align: .trailing, tilt: 2),
    ]
}

/// A TV studio: a lighting truss with spotlights, a dark wall with acoustic panels, a raised set
/// with a strip of light along its edge, and a dark floor with cables and tape marks.
struct G2StudioBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = {
        var panels = "", lattice = "", lamps: [PalaceMark] = []
        for x in stride(from: 0.0, to: 370, by: 46) { panels += "M\(x + 4) 22h38v204h-38Z" }
        for x in stride(from: 0.0, to: 370, by: 14) { lattice += "M\(x) 4L\(x + 7) 14L\(x + 14) 4" }
        for x in [52.0, 142, 232, 322] {
            lamps.append(.f("M\(x - 2) 14H\(x + 2)V20H\(x - 2)Z", 0x1E1E1C))
            lamps.append(.f("M\(x - 7) 19H\(x + 7)L\(x + 5) 30H\(x - 5)Z", 0x1E1E1C))
            lamps.append(.f("M\(x - 5) 30H\(x + 5)L\(x + 30) 120H\(x - 30)Z", 0xFFF4D6, 0.05))
            lamps.append(.f("M\(x - 4) 29H\(x + 4)V31H\(x - 4)Z", 0xFAC775))
        }
        return [
            .f("M0 0H370V262H0Z", 0x2A3242),
            .f(panels, 0x313A4C),
            .f("M0 0H370V18H0Z", 0x1E1E1C),
            .s("M0 4H370M0 14H370", 0x8C9499, 1.6),
            .s(lattice, 0x8C9499, 0.9),
        ] + lamps + [
            // The raised set
            .f("M0 226H370V262H0Z", 0x1F3A6B),
            .f("M0 224H370V230H0Z", 0x3E5C8C),
            .f("M0 246H370V249H0Z", 0x5E9BD6, 0.8),
            // Studio floor with cables and tape marks
            .f("M0 262H370V408H0Z", 0x3E4C55),
            .f("M0 262H370V268H0Z", 0x1E1E1C, 0.3),
            .s("M-4 330Q60 300 120 340T250 330T380 352", 0x1E1E1C, 2.2),
            .s("M40 408Q70 370 150 380T300 408", 0x1E1E1C, 2),
            .s("M176 300l10 10M186 300l-10 10M84 396l10 10M94 396l-10 10", 0xFAC775, 2.4),
        ]
    }()
}
