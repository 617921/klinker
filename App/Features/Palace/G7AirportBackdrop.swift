import SwiftUI

/// The departure hall's named slots: two things hanging from the ceiling, two views through the
/// big window, three spots along the back of the floor and four in front.
enum G7Airport {
    static let noor = CGPoint(x: 230, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "hangLeft": PalaceSlot(frame: CGRect(x: 6, y: 4, width: 126, height: 68), pin: CGPoint(x: 8, y: 70), tilt: -1.5),
        "hangRight": PalaceSlot(frame: CGRect(x: 238, y: 4, width: 126, height: 72), pin: CGPoint(x: 362, y: 74), align: .trailing, tilt: 1.5),
        "windowLeft": PalaceSlot(frame: CGRect(x: 8, y: 96, width: 168, height: 86), pin: CGPoint(x: 10, y: 170), tilt: 1),
        "windowRight": PalaceSlot(frame: CGRect(x: 186, y: 80, width: 178, height: 98), pin: CGPoint(x: 362, y: 164), align: .trailing, tilt: -1),
        "floorBackLeft": PalaceSlot(frame: CGRect(x: 4, y: 194, width: 112, height: 114), pin: CGPoint(x: 6, y: 284), tilt: -1),
        "floorBackMid": PalaceSlot(frame: CGRect(x: 120, y: 186, width: 98, height: 124), pin: CGPoint(x: 168, y: 280), align: .center, tilt: 1.5),
        "floorBackRight": PalaceSlot(frame: CGRect(x: 222, y: 184, width: 144, height: 122), pin: CGPoint(x: 364, y: 280), align: .trailing, tilt: -1.5),
        "floorFront1": PalaceSlot(frame: CGRect(x: 4, y: 314, width: 84, height: 90), pin: CGPoint(x: 6, y: 382), tilt: 1),
        "floorFront2": PalaceSlot(frame: CGRect(x: 90, y: 312, width: 84, height: 92), pin: CGPoint(x: 132, y: 382), align: .center, tilt: -1),
        "floorFront3": PalaceSlot(frame: CGRect(x: 178, y: 306, width: 86, height: 98), pin: CGPoint(x: 220, y: 382), align: .center, tilt: 1.5),
        "floorFront4": PalaceSlot(frame: CGRect(x: 268, y: 304, width: 98, height: 98), pin: CGPoint(x: 364, y: 384), align: .trailing, tilt: -1),
    ]
}

/// An airport departure hall: a light ceiling with spots, a wall of glass looking out on the
/// apron and runway with a control tower, and a polished stone floor.
struct G7AirportBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = ceiling + window + floor

    private nonisolated static let ceiling: [PalaceMark] = {
        var spots = ""
        for x in stride(from: 20.0, to: 370, by: 40) { spots += "M\(x - 5) 22H\(x + 5)V25H\(x - 5)Z" }
        return [
            .f("M0 0H370V34H0Z", 0xEFEBE2),
            .s("M0 10H370M0 20H370", 0xE3E1D8, 1),
            .f(spots, 0xFAC775),
            .f("M0 30H370V36H0Z", 0x5E6B73),
        ]
    }()

    private nonisolated static let window: [PalaceMark] = {
        var dashes = ""
        for x in stride(from: 0.0, to: 370, by: 22) { dashes += "M\(x) 191H\(x + 12)" }
        return [
            .f("M0 36H370V206H0Z", 0xBCCDD6),
            .f("M0 120H370V170H0Z", 0xD3DEE3),
            .f("M326 112H334V164H326Z", 0xB4B2A9),
            .f("M318 100H342L338 112H322Z", 0x5E6B73),
            .f("M320 102H340V108H320Z", 0x8FB6CF),
            .f("M0 160H370V170H0Z", 0x9DBB72),
            .f("M0 170H370V206H0Z", 0x8E8A80),
            .s(dashes, 0xFFFDF6, 2),
            .s("M0 178Q120 176 200 184T370 200", 0xFAC775, 1.6),
            // Mullions and the sill
            .f("M0 36H4V206H0Z M90 36H94V206H90Z M182 36H186V206H182Z M274 36H278V206H274Z M366 36H370V206H366Z", 0x3E4C55),
            .f("M0 118H370V121H0Z", 0x3E4C55),
            .f("M0 40L60 40L20 118H0Z M184 40L240 40L210 118H184Z", 0xFFFFFF, 0.12),
            .f("M0 206H370V222H0Z", 0x5E6B73),
            .f("M0 206H370V208H0Z", 0x3E4C55),
        ]
    }()

    private nonisolated static let floor: [PalaceMark] = {
        var lines = ""
        for k in -4...10 {
            let x = Double(k) * 46
            lines += "M\(185 + (x - 185) * 0.45) 222L\(x) 408"
        }
        for y in [240.0, 266, 300, 346] { lines += "M0 \(y)H370" }
        return [
            .f("M0 222H370V408H0Z", 0xDAD6CA),
            .s(lines, 0xCDC8BA, 1.2),
            .f("M20 222H70L40 408H-20Z M200 222H250L280 408H200Z", 0xFFFFFF, 0.18),
        ]
    }()
}
