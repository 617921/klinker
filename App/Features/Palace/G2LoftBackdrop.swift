import SwiftUI

/// The startup loft's named slots: four things on the brick wall, four on the long work table and
/// three on the wooden floor. Noor is not in this room by default.
enum G2Loft {
    static let noor = CGPoint(x: 226, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "wallA": PalaceSlot(frame: CGRect(x: 6, y: 24, width: 84, height: 72), pin: CGPoint(x: 6, y: 96), tilt: -1.5),
        "wallB": PalaceSlot(frame: CGRect(x: 96, y: 24, width: 84, height: 72), pin: CGPoint(x: 128, y: 100), align: .center, tilt: 1.5),
        "wallC": PalaceSlot(frame: CGRect(x: 188, y: 24, width: 84, height: 72), pin: CGPoint(x: 176, y: 96), tilt: -1),
        "wallD": PalaceSlot(frame: CGRect(x: 280, y: 24, width: 84, height: 72), pin: CGPoint(x: 366, y: 100), align: .trailing, tilt: 1.5),
        "tableA": PalaceSlot(frame: CGRect(x: 6, y: 136, width: 84, height: 84), pin: CGPoint(x: 6, y: 228), tilt: 1),
        "tableB": PalaceSlot(frame: CGRect(x: 94, y: 140, width: 90, height: 80), pin: CGPoint(x: 140, y: 258), align: .center, tilt: -1.5),
        "tableC": PalaceSlot(frame: CGRect(x: 188, y: 136, width: 90, height: 84), pin: CGPoint(x: 232, y: 228), align: .center, tilt: 1.5),
        "tableD": PalaceSlot(frame: CGRect(x: 282, y: 132, width: 84, height: 88), pin: CGPoint(x: 366, y: 258), align: .trailing, tilt: -1),
        "floorA": PalaceSlot(frame: CGRect(x: 4, y: 284, width: 126, height: 100), pin: CGPoint(x: 6, y: 384), tilt: -1.5),
        "floorB": PalaceSlot(frame: CGRect(x: 134, y: 270, width: 112, height: 114), pin: CGPoint(x: 190, y: 384), align: .center, tilt: 1.5),
        "floorC": PalaceSlot(frame: CGRect(x: 250, y: 270, width: 116, height: 114), pin: CGPoint(x: 366, y: 384), align: .trailing, tilt: 2),
    ]
}

/// A startup in an old warehouse: steel beams and a duct under the ceiling, a brick wall, pendant
/// lamps, a long wooden work table on black steel legs and a plank floor.
struct G2LoftBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = {
        var bricks = "", planks = "", lamps: [PalaceMark] = []
        for (r, y) in stride(from: 20.0, to: 300, by: 10).enumerated() {
            bricks += "M0 \(y)H370"
            let shift = r % 2 == 0 ? 0.0 : 11
            for x in stride(from: shift, to: 370, by: 22) { bricks += "M\(x) \(y)V\(y + 10)" }
        }
        for y in [318.0, 342, 370, 400] { planks += "M0 \(y)H370" }
        for (i, x) in stride(from: -10.0, to: 380, by: 46).enumerated() {
            let y = [300.0, 318, 342, 370][i % 4]
            planks += "M\(x) \(y)V\(y + 24)"
        }
        for x in [92.0, 184, 276] {
            lamps.append(.s("M\(x) 16V104", 0x1E1E1C, 1.2))
            lamps.append(.f("M\(x - 9) 112Q\(x - 9) 102 \(x) 102Q\(x + 9) 102 \(x + 9) 112Z", 0x1E1E1C))
            lamps.append(.oval(x - 4, 110, 8, 4, 0xFAC775))
            lamps.append(.f("M\(x - 9) 112H\(x + 9)L\(x + 26) 150H\(x - 26)Z", 0xFFF4D6, 0.12))
        }
        return [
            .f("M0 0H370V300H0Z", 0xB5603F),
            .s(bricks, 0x9A4E33, 1.2),
            .f("M0 0H370V16H0Z", 0x3E4C55),
            .f("M0 6H370V12H0Z", 0x8C9499),
            .s("M40 6V12M150 6V12M260 6V12", 0x5E6B73, 2),
            .f("M0 16H370V19H0Z", 0x1E1E1C, 0.2),
        ] + lamps + [
            // Long work table
            .f("M0 218H370V225H0Z", 0xD9B47E),
            .f("M0 225H370V229H0Z", 0x9A6A42),
            .s("M14 229V300M184 229V300M356 229V300M14 262H356", 0x2E2117, 3.4),
            // Plank floor
            .f("M0 300H370V408H0Z", 0xC9965F),
            .s(planks, 0xB07A4A, 1.4),
            .f("M0 300H370V304H0Z", 0x1E1E1C, 0.12),
        ]
    }()
}
