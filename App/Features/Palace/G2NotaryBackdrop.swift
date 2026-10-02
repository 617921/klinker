import SwiftUI

/// The notary's study: four frames on the green wall, a shelf in the bookcase, three spots on the
/// big desk (the notary sits behind it), and three on the floor in front.
enum G2Notary {
    static let noor = CGPoint(x: 214, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "wallA": PalaceSlot(frame: CGRect(x: 6, y: 20, width: 84, height: 74), pin: CGPoint(x: 6, y: 94), tilt: -1.5),
        "wallB": PalaceSlot(frame: CGRect(x: 96, y: 20, width: 84, height: 74), pin: CGPoint(x: 128, y: 100), align: .center, tilt: 1.5),
        "wallC": PalaceSlot(frame: CGRect(x: 188, y: 20, width: 84, height: 74), pin: CGPoint(x: 176, y: 94), tilt: -1),
        "wallD": PalaceSlot(frame: CGRect(x: 280, y: 20, width: 84, height: 74), pin: CGPoint(x: 366, y: 100), align: .trailing, tilt: 1.5),
        "shelf": PalaceSlot(frame: CGRect(x: 8, y: 118, width: 80, height: 82), pin: CGPoint(x: 4, y: 204), tilt: 1),
        "deskA": PalaceSlot(frame: CGRect(x: 98, y: 146, width: 78, height: 76), pin: CGPoint(x: 136, y: 232), align: .center, tilt: -1.5),
        "deskB": PalaceSlot(frame: CGRect(x: 240, y: 148, width: 60, height: 74), pin: CGPoint(x: 268, y: 262), align: .center, tilt: 1.5),
        "deskC": PalaceSlot(frame: CGRect(x: 304, y: 138, width: 62, height: 84), pin: CGPoint(x: 366, y: 232), align: .trailing, tilt: -1),
        "frontLeft": PalaceSlot(frame: CGRect(x: 6, y: 266, width: 100, height: 92), pin: CGPoint(x: 6, y: 360), tilt: -1.5),
        "frontMid": PalaceSlot(frame: CGRect(x: 108, y: 254, width: 100, height: 110), pin: CGPoint(x: 158, y: 368), align: .center, tilt: 1.5),
        "standing": PalaceSlot(frame: CGRect(x: 262, y: 270, width: 104, height: 110), pin: CGPoint(x: 366, y: 380), align: .trailing, tilt: 2),
        /// The notary behind the desk (cut off at the desk top).
        "notary": PalaceSlot(frame: CGRect(x: 180, y: 134, width: 58, height: 88), pin: CGPoint(x: 209, y: 232), align: .center, tilt: -1),
    ]
}

/// A notary's study: dark green striped wallpaper above wood panelling, a bookcase of law books on
/// the left, a heavy desk with drawers, a parquet floor and a red rug.
struct G2NotaryBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = wall + bookcase + desk + floor

    private nonisolated static let wall: [PalaceMark] = {
        var stripes = "", panels = ""
        for x in stride(from: 8.0, to: 370, by: 18) { stripes += "M\(x) 14V200" }
        for x in stride(from: 100.0, to: 370, by: 68) { panels += "M\(x) 212h56v76h-56Z" }
        return [
            .f("M0 0H370V300H0Z", 0x2F4B3A),
            .s(stripes, 0x36553F, 5),
            .f("M0 0H370V12H0Z", 0xEFEBE2),
            .f("M0 12H370V15H0Z", 0xC9A15B),
            .f("M0 15H370V18H0Z", 0x1E1E1C, 0.15),
            .f("M0 104H370V108H0Z", 0x7A5230),
            .f("M0 200H370V300H0Z", 0x6B4A2E),
            .f("M0 200H370V205H0Z", 0x4A3524),
            .s(panels, 0x5A3E26, 2),
        ]
    }()

    private nonisolated static let bookcase: [PalaceMark] = {
        let colours: [UInt32] = [0x7A1E1E, 0x1F3A6B, 0x2F4B3A, 0x7A5230, 0x5A1414, 0x3E4C55, 0x993556, 0x6B4A2E]
        var books: [PalaceMark] = []
        for (row, bottom) in [(0, 252.0), (1, 294.0)] {
            var x = 8.0, i = row * 3
            while x < 84 {
                let w = [6.0, 8, 7, 9, 6, 8][i % 6], h = [34.0, 30, 36, 32, 28, 35][(i * 5) % 6]
                books.append(.f("M\(x) \(bottom - h)h\(w)v\(h)h-\(w)Z", colours[i % colours.count]))
                books.append(.f("M\(x) \(bottom - h + 5)h\(w)v2h-\(w)Z", 0xC9A15B, 0.8))
                x += w + 0.6
                i += 1
            }
        }
        return [
            .f("M0 108H94V300H0Z", 0x4A3524),
            .f("M6 114H88V202H6Z", 0x3A2A1C),
            .f("M6 210H88V252H6Z M6 260H88V294H6Z", 0x3A2A1C),
            .f("M0 202H94V210H0Z M0 252H94V260H0Z", 0x5A3E26),
        ] + books
    }()

    private nonisolated static let desk: [PalaceMark] = [
        .f("M96 220H370V226H96Z", 0x8C5E38),
        .f("M96 226H370V230H96Z", 0x4A3524),
        .f("M100 230H366V300H100Z", 0x6B4A2E),
        .f("M108 238H196V292H108Z M270 238H358V292H270Z", 0x5A3E26),
        .f("M204 238H262V292H204Z", 0x4A3524, 0.5),
        .f("M146 262H158V266H146Z M308 262H320V266H308Z", 0xC9A15B),
    ]

    private nonisolated static let floor: [PalaceMark] = {
        var herring = ""
        for y in stride(from: 300.0, to: 408, by: 20) {
            for x in stride(from: -20.0, to: 380, by: 20) { herring += "M\(x) \(y)L\(x + 10) \(y + 10)L\(x) \(y + 20)" }
        }
        return [
            .f("M0 300H370V408H0Z", 0xB07A4A),
            .s(herring, 0x9A6A42, 1.2),
            .f("M0 300H370V304H0Z", 0x1E1E1C, 0.15),
            .f("M96 336H340V408H96Z", 0x7A1E1E),
            .s("M104 344H332V408M104 344V408", 0xC9A15B, 1.6),
            .s("M112 352H324V408M112 352V408", 0x5A1414, 1.2),
        ]
    }()
}
