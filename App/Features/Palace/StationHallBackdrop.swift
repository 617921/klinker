import SwiftUI

/// The station hall's named slots: three things hang from the roof beam, three on the wall
/// above the train, one window of the train, a clock pole on the platform and three floor spots.
/// Strips hang just under hanging and wall things, so signs stay readable.
enum StationHall {
    static let noor = CGPoint(x: 244, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "boardLeft": PalaceSlot(frame: CGRect(x: 8, y: 16, width: 124, height: 66), pin: CGPoint(x: 22, y: 80), tilt: -2),
        "signCenter": PalaceSlot(frame: CGRect(x: 158, y: 16, width: 54, height: 64), pin: CGPoint(x: 185, y: 79), align: .center, tilt: 2),
        "screenRight": PalaceSlot(frame: CGRect(x: 238, y: 16, width: 124, height: 66), pin: CGPoint(x: 358, y: 78), align: .trailing, tilt: 1.5),
        "wallLeft": PalaceSlot(frame: CGRect(x: 10, y: 106, width: 104, height: 50), pin: CGPoint(x: 12, y: 154), tilt: 1.5),
        "wallCenter": PalaceSlot(frame: CGRect(x: 138, y: 106, width: 96, height: 50), pin: CGPoint(x: 186, y: 155), align: .center, tilt: -1.5),
        "wallRight": PalaceSlot(frame: CGRect(x: 258, y: 106, width: 100, height: 50), pin: CGPoint(x: 362, y: 154), align: .trailing, tilt: 2),
        "trainWindow": PalaceSlot(frame: CGRect(x: 276, y: 184, width: 80, height: 56), pin: CGPoint(x: 316, y: 238), align: .center, tilt: -1.5),
        "platformPole": PalaceSlot(frame: CGRect(x: 140, y: 180, width: 92, height: 182), pin: CGPoint(x: 186, y: 230), align: .center, tilt: 1),
        "floorLeft": PalaceSlot(frame: CGRect(x: 8, y: 262, width: 60, height: 124), pin: CGPoint(x: 4, y: 372), tilt: -1.5),
        "floorMid": PalaceSlot(frame: CGRect(x: 88, y: 282, width: 50, height: 106), pin: CGPoint(x: 112, y: 334), align: .center, tilt: 1.5),
        "floorRight": PalaceSlot(frame: CGRect(x: 296, y: 278, width: 64, height: 114), pin: CGPoint(x: 290, y: 320), tilt: -2),
    ]
}

/// A Dutch station hall: green iron roof beam and columns, three tall arched windows, a train
/// waiting at the platform, the white edge with its yellow line, and a tiled platform floor.
struct StationHallBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = wall + windows + train + platform + columns

    private nonisolated static let wall: [PalaceMark] = {
        var rivets = ""
        for x in stride(from: 6, to: 370, by: 12) { rivets += "M\(x) 7.5a1.3 1.3 0 1 0 0.01 0Z" }
        return [
            .f("M0 0H370V262H0Z", 0xE8DDC6),
            .f("M0 0H370V15H0Z", 0x3F5A4A),
            .f("M0 15H370V18H0Z", 0x2F4337),
            .f(rivets, 0x5E7A68),
            .f("M0 18H370V22H0Z", 0x1E1E1C, 0.08),
        ]
    }()

    private nonisolated static let windows: [PalaceMark] = (0..<3).flatMap { i -> [PalaceMark] in
        let x = 14.0 + Double(i) * 119
        let arch = "M\(x) 178V76A52 52 0 0 1 \(x + 104) 76V178"
        return [
            .f(arch + "Z", 0xBCCDD6),
            .f("M\(x) 118V76A52 52 0 0 1 \(x + 104) 76V118Z", 0xD3E0E6),
            .oval(x + 18 + Double(i) * 14, 92, 34, 9, 0xFFFFFF, 0.7),
            .s("M\(x + 22) 76A30 30 0 0 1 \(x + 82) 76M\(x) 76H\(x + 104)M\(x + 52) 24V178M\(x + 52) 76L\(x + 15.2) 39.2M\(x + 52) 76L\(x + 88.8) 39.2",
               0xEFEBE2, 2),
            .s("M\(x) 118H\(x + 104)M\(x) 148H\(x + 104)M\(x + 26) 118V178M\(x + 78) 118V178", 0xEFEBE2, 2),
            .s(arch, 0xEFEBE2, 3),
        ]
    }

    private nonisolated static let train: [PalaceMark] = {
        var panes = "", shine = ""
        for x in [12.0, 104, 146, 226, 280, 322] {
            panes += "M\(x + 5) 194H\(x + 29)Q\(x + 34) 194 \(x + 34) 199V219Q\(x + 34) 224 \(x + 29) 224H\(x + 5)Q\(x) 224 \(x) 219V199Q\(x) 194 \(x + 5) 194Z"
            shine += "M\(x + 4) 222L\(x + 16) 196H\(x + 22)L\(x + 10) 222Z"
        }
        var doors = "", doorPanes = ""
        for x in [58.0, 186] {
            doors += "M\(x) 188H\(x + 32)V252H\(x)Z"
            doorPanes += "M\(x + 4) 194H\(x + 14)V222H\(x + 4)Z M\(x + 18) 194H\(x + 28)V222H\(x + 18)Z"
        }
        return [
            .f("M-4 180Q-4 174 4 174H366Q374 174 374 180V186H-4Z", 0xB4B2A9),
            .f("M-4 186H374V252H-4Z", 0xEFEBE2),
            .f(panes, 0x3E4C55),
            .f(shine, 0xFFFFFF, 0.15),
            .f("M-4 230H374V236H-4Z", 0x0F6E56),
            .f(doors, 0x0F6E56),
            .f(doorPanes, 0x3E4C55),
            .s("M74 188V252M202 188V252", 0x0A4F3E, 1.2),
            .f("M-4 252H374V258H-4Z", 0x3E4C55),
            .f("M266 182H272V252H266Z", 0x5E6B73),
            .s("M266 192H272M266 204H272M266 216H272M266 228H272M266 240H272", 0x3E4C55, 1),
        ]
    }()

    private nonisolated static let platform: [PalaceMark] = {
        var tiles = "", studs = ""
        for r in 0..<6 {
            for c in 0..<17 where (r + c) % 2 == 0 {
                tiles += "M\(c * 23 - 6) \(274 + r * 23)h23v23h-23Z"
            }
        }
        for x in stride(from: 4, to: 370, by: 7) { studs += "M\(x) 269a1.1 1.1 0 1 0 0.01 0Z" }
        return [
            .f("M0 256H370V408H0Z", 0xDAD6CA),
            .f(tiles, 0xCDC8BA),
            .f("M0 256H370V261H0Z", 0xF4F1EA),
            .f("M0 261H370V263H0Z", 0x1E1E1C, 0.1),
            .f("M0 265H370V273H0Z", 0xFAC775),
            .f(studs, 0xD9A440),
        ]
    }()

    private nonisolated static let columns: [PalaceMark] = [125.5, 244.5].flatMap { cx -> [PalaceMark] in
        [
            .s("M\(cx - 4) 44Q\(cx - 4) 21 \(cx - 26) 18M\(cx + 4) 44Q\(cx + 4) 21 \(cx + 26) 18", 0x3F5A4A, 2.5),
            .f("M\(cx - 4.5) 26H\(cx + 4.5)V266H\(cx - 4.5)Z", 0x3F5A4A),
            .f("M\(cx - 3) 26H\(cx - 1.5)V266H\(cx - 3)Z", 0x5E7A68),
            .f("M\(cx - 10) 18H\(cx + 10)V22H\(cx - 10)Z M\(cx - 7) 22H\(cx + 7)V27H\(cx - 7)Z", 0x2F4337),
            .f("M\(cx - 8) 262H\(cx + 8)V274H\(cx - 8)Z", 0x2F4337),
            .f("M\(cx - 10) 274H\(cx + 10)V276H\(cx - 10)Z", 0x1E1E1C, 0.15),
        ]
    }
}
