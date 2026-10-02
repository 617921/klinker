import SwiftUI

/// The GP practice's named slots: a plaque and a card high on the wall, the doorway, three spots
/// on and behind the desk, the printer cabinet, three waiting chairs and the couch.
enum DoctorRoom {
    static let noor = CGPoint(x: 150, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "plaque": PalaceSlot(frame: CGRect(x: 10, y: 22, width: 116, height: 62), pin: CGPoint(x: 14, y: 82), tilt: -2),
        "card": PalaceSlot(frame: CGRect(x: 254, y: 20, width: 106, height: 80), pin: CGPoint(x: 362, y: 92), align: .trailing, tilt: 1.5),
        "door": PalaceSlot(frame: CGRect(x: 20, y: 160, width: 66, height: 128), pin: CGPoint(x: 10, y: 136), tilt: 1.5),
        "deskLeft": PalaceSlot(frame: CGRect(x: 106, y: 174, width: 64, height: 66), pin: CGPoint(x: 138, y: 156), align: .center, tilt: -1.5),
        "deskMid": PalaceSlot(frame: CGRect(x: 172, y: 196, width: 62, height: 44), pin: CGPoint(x: 200, y: 252), align: .center, tilt: 1),
        "deskChair": PalaceSlot(frame: CGRect(x: 230, y: 152, width: 60, height: 86), pin: CGPoint(x: 262, y: 134), align: .center, tilt: -1),
        "cabinet": PalaceSlot(frame: CGRect(x: 298, y: 150, width: 68, height: 90), pin: CGPoint(x: 366, y: 250), align: .trailing, tilt: 2),
        "chair1": PalaceSlot(frame: CGRect(x: 4, y: 298, width: 62, height: 98), pin: CGPoint(x: 2, y: 372), tilt: -1.5),
        "chair2": PalaceSlot(frame: CGRect(x: 66, y: 298, width: 62, height: 98), pin: CGPoint(x: 100, y: 380), align: .center, tilt: 1.5),
        "chair3": PalaceSlot(frame: CGRect(x: 128, y: 296, width: 82, height: 100), pin: CGPoint(x: 174, y: 372), align: .center, tilt: -1),
        "couch": PalaceSlot(frame: CGRect(x: 212, y: 290, width: 154, height: 108), pin: CGPoint(x: 366, y: 376), align: .trailing, tilt: 1.5),
    ]
}

/// A Dutch GP practice: mint walls, a door with frosted glass, a window with a blind, the desk,
/// a white cabinet and a lino floor.
struct DoctorRoomBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = wall + window + door + desk + floor

    private nonisolated static let wall: [PalaceMark] = [
        .f("M0 0H370V294H0Z", 0xDCE3DF),
        .f("M0 192H370V294H0Z", 0xB9C4BF, 0.45),
        .f("M0 189H370V193H0Z", 0xEFEBE2),
        .f("M0 0H370V12H0Z", 0xEFEBE2),
        .f("M0 12H370V15H0Z", 0x1E1E1C, 0.07),
        .f("M150 6H220V12H150Z", 0xFFFDF6),
    ]

    private nonisolated static let window: [PalaceMark] = {
        var slats = ""
        for y in stride(from: 30.0, through: 56, by: 5) { slats += "M146 \(y)H224" }
        return [
            .f("M138 20H232V104H138Z", 0xEFEBE2),
            .f("M144 26H226V98H144Z", 0xBCCDD6),
            .f("M144 62H226V98H144Z", 0xD3E0E6),
            .f("M150 70L162 62H170L158 70Z M196 98L214 70H222L204 98Z", 0xFFFFFF, 0.4),
            .f("M144 26H226V60H144Z", 0xF4F1EA),
            .s(slats, 0xD3D1C7, 1),
            .f("M144 58H226V61H144Z", 0xB4B2A9),
            .s("M214 61V72", 0x5E6B73, 1),
            .f("M134 102H236V108H134Z", 0xEFEBE2),
            .f("M150 90H162L160 102H152Z", 0xA3410A),
            .f("M156 90C150 84 148 78 152 74C156 78 158 84 156 90Z M156 90C160 82 166 80 168 82C166 86 162 90 156 90Z", 0x5E8C45),
        ]
    }()

    private nonisolated static let door: [PalaceMark] = [
        .f("M10 96H96V294H10Z", 0xEFEBE2),
        .f("M16 102H90V294H16Z", 0x5E7A68),
        .f("M28 112H78V156H28Z", 0xD3E0E6),
        .f("M34 150L46 116H52L40 150Z", 0xFFFFFF, 0.35),
        .f("M24 176H82V280H24Z", 0x3F5A4A, 0.35),
        .f("M78 200H86V204H78Z", 0xC9A15B),
        .dot(80, 202, 2.6, 0xC9A15B),
    ]

    private nonisolated static let desk: [PalaceMark] = [
        .f("M104 244H294V294H104Z", 0x9A6A42),
        .f("M112 252H196V286H112Z M204 252H286V286H204Z", 0x8A5C38),
        .f("M150 266H160V270H150Z M240 266H250V270H240Z", 0xC9A15B),
        .f("M100 236H298V245H100Z", 0xC9965F),
        .f("M100 245H298V248H100Z", 0x6B4A2E),
        // White cabinet under the printer
        .f("M300 240H368V294H300Z", 0xEFEBE2),
        .s("M300 266H368M334 240V294", 0xD3D1C7, 1.2),
        .f("M326 250H332V254H326Z M336 250H342V254H336Z M326 276H332V280H326Z M336 276H342V280H336Z", 0x5E6B73),
    ]

    private nonisolated static let floor: [PalaceMark] = {
        var tiles = ""
        for r in 0..<5 {
            for c in 0..<16 where (r + c) % 2 == 0 {
                tiles += "M\(c * 24 - 4) \(294 + r * 24)h24v24h-24Z"
            }
        }
        return [
            .f("M0 294H370V408H0Z", 0xE2DED3),
            .f(tiles, 0xD8D3C6),
            .f("M0 292H370V296H0Z", 0x5E6B73),
            .f("M0 296H370V299H0Z", 0x1E1E1C, 0.08),
        ]
    }()
}
