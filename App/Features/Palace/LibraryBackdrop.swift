import SwiftUI

/// The library's named slots: two signs hang from the beam beside the round window, three things
/// on the wall, a hold shelf in the low bookcase, three spots on the front desk and two on the floor.
enum Library {
    static let noor = CGPoint(x: 236, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "hangLeft": PalaceSlot(frame: CGRect(x: 8, y: 16, width: 128, height: 66), pin: CGPoint(x: 12, y: 82), tilt: -2),
        "hangRight": PalaceSlot(frame: CGRect(x: 234, y: 16, width: 128, height: 66), pin: CGPoint(x: 358, y: 76), align: .trailing, tilt: 1.5),
        "wallLeft": PalaceSlot(frame: CGRect(x: 22, y: 98, width: 70, height: 78), pin: CGPoint(x: 8, y: 170), tilt: 1.5),
        "wallCenter": PalaceSlot(frame: CGRect(x: 134, y: 92, width: 102, height: 72), pin: CGPoint(x: 186, y: 160), align: .center, tilt: -1.5),
        "wallRight": PalaceSlot(frame: CGRect(x: 256, y: 96, width: 104, height: 66), pin: CGPoint(x: 362, y: 156), align: .trailing, tilt: 2),
        "shelf": PalaceSlot(frame: CGRect(x: 8, y: 196, width: 76, height: 80), pin: CGPoint(x: 6, y: 264), tilt: -1.5),
        "deskLeft": PalaceSlot(frame: CGRect(x: 148, y: 182, width: 86, height: 58), pin: CGPoint(x: 190, y: 250), align: .center, tilt: 1),
        "deskMid": PalaceSlot(frame: CGRect(x: 240, y: 194, width: 62, height: 46), pin: CGPoint(x: 272, y: 250), align: .center, tilt: -2),
        "deskRight": PalaceSlot(frame: CGRect(x: 304, y: 190, width: 62, height: 50), pin: CGPoint(x: 366, y: 250), align: .trailing, tilt: 1.5),
        "floorLeft": PalaceSlot(frame: CGRect(x: 14, y: 292, width: 70, height: 108), pin: CGPoint(x: 8, y: 372), tilt: -1.5),
        "floorMid": PalaceSlot(frame: CGRect(x: 98, y: 294, width: 72, height: 106), pin: CGPoint(x: 134, y: 372), align: .center, tilt: 1.5),
        "floorRight": PalaceSlot(frame: CGRect(x: 288, y: 304, width: 74, height: 96), pin: CGPoint(x: 362, y: 372), align: .trailing, tilt: -1),
    ]
}

/// A Dutch public library: a wooden beam, a round window, a low bookcase along the back wall,
/// the front desk on the right and a light oak floor.
struct LibraryBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = wall + window + bookcase + floor + desk

    private nonisolated static let wall: [PalaceMark] = [
        .f("M0 0H370V280H0Z", 0xE8DDC6),
        .f("M0 0H370V13H0Z", 0x6B4A2E),
        .f("M0 13H370V16H0Z", 0x4A3524),
        .f("M0 16H370V20H0Z", 0x1E1E1C, 0.07),
    ]

    private nonisolated static let window: [PalaceMark] = [
        .dot(185, 52, 35, 0xEFEBE2),
        .dot(185, 52, 31, 0xBCCDD6),
        .f("M154 52A31 31 0 0 1 216 52Z", 0xD3E0E6),
        .oval(166, 30, 26, 8, 0xFFFFFF, 0.7),
        .s("M154 52H216M185 21V83", 0xEFEBE2, 2.5),
        .ring(185, 52, 14, 0xEFEBE2, 2),
        .f("M178 90H192V96H178Z", 0xD9CDB4),
    ]

    private nonisolated static let bookcase: [PalaceMark] = {
        let colours: [UInt32] = [0x5E7A68, 0x8C5E38, 0x3E4C55, 0xA3410A, 0x21468B, 0xC9A15B, 0x6B4A2E, 0x3C3489, 0x0F6E56, 0x993556]
        let widths: [Double] = [7, 9, 6, 8, 10, 7, 6, 9, 8, 7, 11]
        let heights: [Double] = [32, 36, 29, 34, 30, 37, 33, 28, 35, 31]
        var books: [PalaceMark] = []
        for (shelf, bottom) in [(0, 228.0), (1, 272.0)] {
            var x = 6.0, i = shelf * 3
            while x < 364 {
                let w = widths[i % widths.count], h = heights[(i * 7) % heights.count]
                if Int(x) % 92 > 86 { x += 6; continue }
                let lean = i % 9 == 4
                let d = lean ? "M\(x) \(bottom)L\(x + 6) \(bottom - h)H\(x + 6 + w)L\(x + w) \(bottom)Z" : "M\(x) \(bottom)V\(bottom - h)H\(x + w)V\(bottom)Z"
                books.append(.f(d, colours[(i * 3) % colours.count]))
                x += w + (lean ? 7 : 0.8)
                i += 1
            }
        }
        var uprights = ""
        for x in stride(from: 0, through: 368, by: 92) { uprights += "M\(x) 186H\(x + 5)V276H\(x)Z" }
        return [.f("M0 182H370V278H0Z", 0x4A3524)] + books + [
            .f("M0 182H370V278H0Z", 0xE8DDC6, 0.28),
            .f(uprights, 0x6B4A2E),
            .f("M0 178H370V186H0Z", 0x7A5230),
            .f("M0 186H370V188H0Z", 0x1E1E1C, 0.2),
            .f("M0 228H370V233H0Z", 0x7A5230),
            .f("M0 272H370V280H0Z", 0x7A5230),
        ]
    }()

    private nonisolated static let floor: [PalaceMark] = {
        var planks = ""
        for (r, y) in stride(from: 302.0, to: 408, by: 22).enumerated() {
            planks += "M0 \(y)H370"
            for x in stride(from: Double((r % 3) * 41 + 20), to: 370, by: 124) { planks += "M\(x) \(y - 22)V\(y)" }
        }
        return [
            .f("M0 280H370V408H0Z", 0xDCC7A1),
            .s(planks, 0xC9AE85, 1.2),
            .f("M0 280H370V284H0Z", 0x1E1E1C, 0.08),
            .oval(4, 384, 196, 22, 0xA3410A, 0.18),
        ]
    }()

    private nonisolated static let desk: [PalaceMark] = [
        .f("M150 304H370V309H150Z", 0x1E1E1C, 0.1),
        .f("M150 246H370V304H150Z", 0x9A6A42),
        .f("M158 254H214V296H158Z M222 254H278V296H222Z M286 254H342V296H286Z M350 254H370V296H350Z", 0x8A5C38),
        .f("M150 298H370V304H150Z", 0x4A3524),
        .f("M144 238H370V247H144Z", 0xC9965F),
        .f("M144 247H370V250H144Z", 0x6B4A2E),
    ]
}
