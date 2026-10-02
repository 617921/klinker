import SwiftUI

/// The canal-house living room's named slots: a leak column by the window, two frames high on
/// the wall, two papers below them, the sofa corner, the doorway to the hall with the doormat,
/// and three floor spots.
enum LivingRoom {
    static let noor = CGPoint(x: 152, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "leakColumn": PalaceSlot(frame: CGRect(x: 106, y: 18, width: 46, height: 294), pin: CGPoint(x: 127, y: 236), align: .center, tilt: -1.5),
        "frameLeft": PalaceSlot(frame: CGRect(x: 156, y: 30, width: 66, height: 60), pin: CGPoint(x: 154, y: 94), tilt: -2),
        "frameRight": PalaceSlot(frame: CGRect(x: 226, y: 28, width: 68, height: 62), pin: CGPoint(x: 296, y: 94), align: .trailing, tilt: 1.5),
        "paperLeft": PalaceSlot(frame: CGRect(x: 158, y: 126, width: 58, height: 62), pin: CGPoint(x: 156, y: 190), tilt: 1.5),
        "paperRight": PalaceSlot(frame: CGRect(x: 228, y: 122, width: 64, height: 68), pin: CGPoint(x: 294, y: 190), align: .trailing, tilt: -1.5),
        "sofa": PalaceSlot(frame: CGRect(x: 154, y: 214, width: 140, height: 88), pin: CGPoint(x: 226, y: 254), align: .center, tilt: 1),
        "doorway": PalaceSlot(frame: CGRect(x: 302, y: 182, width: 64, height: 118), pin: CGPoint(x: 368, y: 274), align: .trailing, tilt: 2),
        "doormat": PalaceSlot(frame: CGRect(x: 302, y: 308, width: 64, height: 48), pin: CGPoint(x: 366, y: 358), align: .trailing, tilt: -2),
        "floorLeft": PalaceSlot(frame: CGRect(x: 6, y: 252, width: 80, height: 128), pin: CGPoint(x: 8, y: 368), tilt: -1.5),
        "floorMid": PalaceSlot(frame: CGRect(x: 90, y: 318, width: 62, height: 86), pin: CGPoint(x: 90, y: 302), tilt: 1.5),
        "floorRight": PalaceSlot(frame: CGRect(x: 164, y: 312, width: 124, height: 90), pin: CGPoint(x: 226, y: 382), align: .center, tilt: -1),
    ]
}

/// A canal-house living room: beamed ceiling, a tall window onto the canal with red curtains,
/// green panelling, a doorway to the hall with its steep stair, and a plank floor.
struct LivingRoomBackdrop: View, Equatable {
    var body: some View {
        ZStack(alignment: .topLeading) {
            PalaceArtwork(marks: Self.back, width: 370, height: 408)
            PalaceCanalWindow(houses: Self.view).palaceAt(12, 28)
            PalaceArtwork(marks: Self.front, width: 370, height: 408)
        }
        .frame(width: 370, height: 408, alignment: .topLeading)
        .accessibilityHidden(true)
    }

    static let view = PalaceCanal.row([
        PalaceHouse(type: .hals, width: 62, floors: 3, cols: 2, doorLeft: false, shop: false, flowers: true,
                    color: 0x5E6B73, door: 0x1F3A6B, awning: 0x2F4B3A),
        PalaceHouse(type: .tuit, width: 46, floors: 3, cols: 2, doorLeft: true, shop: false, flowers: false,
                    color: 0x9A5238, door: 0x24533F, awning: 0xC8261B),
        PalaceHouse(type: .klok, width: 62, floors: 3, cols: 2, doorLeft: true, shop: true, flowers: true,
                    color: 0xD9CDB4, door: 0x7A1E1E, awning: 0x1F3A6B),
    ])

    nonisolated static let back: [PalaceMark] = {
        var beams = "", beamShade = ""
        for x in stride(from: 8.0, to: 370, by: 34) {
            beams += "M\(x) 0H\(x + 10)V16H\(x)Z"
            beamShade += "M\(x + 7) 0H\(x + 10)V16H\(x + 7)Z"
        }
        var planks = ""
        for (r, y) in [318.0, 338, 362, 390].enumerated() {
            planks += "M0 \(y)H370"
            var x = Double(r % 2) * 46 + 20
            while x < 370 {
                planks += "M\(x) \(y)V\(r == 0 ? 300 : [318.0, 338, 362][r - 1])"
                x += 92
            }
        }
        var panels = ""
        for x in stride(from: 108.0, to: 296, by: 47) { panels += "M\(x) 250H\(x + 39)V290H\(x)Z" }
        var steps = ""
        for k in 0..<9 {
            let y = 290.0 - Double(k) * 22, x = 356.0 - Double(k) * 6
            steps += "M\(x - 30) \(y)H\(x)V\(y + 4)H\(x - 30)Z"
        }
        return [
            .f("M0 0H370V300H0Z", 0xEDE2CC),
            .f("M0 0H370V18H0Z", 0xF4EEE2),
            .f(beams, 0x7A5230),
            .f(beamShade, 0x5E4029),
            .f("M0 16H370V24H0Z", 0x4A3524),
            .f("M0 24H370V27H0Z", 0x1E1E1C, 0.08),
            // Wainscot
            .f("M0 242H370V300H0Z", 0x3F5A4A),
            .f(panels, 0x4A6A57),
            .f("M0 238H370V244H0Z", 0x2F4337),
            .f("M0 296H370V302H0Z", 0x2F4337),
            // Window reveal
            .f("M6 22H102V216H6Z", 0xDCCDB0),
            // Doorway to the hall: casing, fanlight, the hall and its steep stair
            .f("M296 56H370V302H296Z", 0xEFEBE2),
            .f("M302 64H370V88H302Z", 0xBCCDD6),
            .s("M302 88L318 64M336 88V64M302 88H370", 0xEFEBE2, 2),
            .f("M302 92H370V300H302Z", 0x5A4636),
            .f("M302 92H370V110H302Z", 0x1E1E1C, 0.2),
            .f(steps, 0x8C5E38),
            .s("M326 296L356 104", 0x2E2117, 1.6),
            .f("M302 92L292 98V306L302 300Z", 0x2F4B3A),
            .f("M294 190H298V204H294Z", 0xC9A15B),
            // Floor
            .f("M0 300H370V408H0Z", 0xB98A5A),
            .s(planks, 0x9A6A42, 1.4),
            .f("M0 300H370V304H0Z", 0x1E1E1C, 0.1),
            .f("M150 328H300L310 396H140Z", 0x993556),
            .s("M156 333H295L303 391H147Z", 0xF6D27A, 1.6),
            .f("M298 316H368L374 344H292Z", 0x8A6A3E),
            .s("M302 320H366L370 340H296Z", 0x6B4A2E, 1.2),
        ]
    }()

    nonisolated static let front: [PalaceMark] = [
        .s("M12 28H96V208H12Z", 0xF4F1EA, 4),
        .s("M54 28V208M12 88H96M12 148H96", 0xF4F1EA, 2.4),
        .f("M2 206H106V214H2Z", 0xF4F1EA),
        .f("M4 214H104V218H4Z", 0xD9CDB4),
        .f("M0 18C6 60 4 150 12 240H0Z", 0x7A1E1E),
        .s("M4 30C8 80 6 150 9 232", 0x5A1414, 1.4),
        .f("M106 18C100 60 102 150 94 240H106Z", 0x7A1E1E),
        .s("M102 30C98 80 100 150 97 232", 0x5A1414, 1.4),
        .f("M0 150H14V156H0Z M92 150H106V156H92Z", 0xC9A15B),
        .s("M0 19H108", 0x2E2117, 3),
        .dot(106, 19, 3, 0xC9A15B),
    ]
}
