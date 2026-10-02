import SwiftUI

/// The hotel's named slots: two guest rooms upstairs; in the lobby four spots on the wall, the
/// receptionist behind the desk, a spot on the desk, two guests and a spot in front of the desk.
enum G4HotelLobby {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [
        "roomLeft": PalaceSlot(frame: CGRect(x: 8, y: 30, width: 168, height: 112), pin: CGPoint(x: 10, y: 118), tilt: -1.5),
        "roomRight": PalaceSlot(frame: CGRect(x: 194, y: 30, width: 170, height: 112), pin: CGPoint(x: 362, y: 118), align: .trailing, tilt: 1.5),
        "wallLeft": PalaceSlot(frame: CGRect(x: 6, y: 170, width: 90, height: 58), pin: CGPoint(x: 6, y: 226), tilt: 1.5),
        "calendar": PalaceSlot(frame: CGRect(x: 100, y: 166, width: 52, height: 64), pin: CGPoint(x: 100, y: 150), tilt: -1),
        "keys": PalaceSlot(frame: CGRect(x: 172, y: 166, width: 98, height: 60), pin: CGPoint(x: 190, y: 150), tilt: 1),
        "wallRight": PalaceSlot(frame: CGRect(x: 276, y: 170, width: 90, height: 56), pin: CGPoint(x: 366, y: 228), align: .trailing, tilt: -1.5),
        "deskLeft": PalaceSlot(frame: CGRect(x: 108, y: 220, width: 52, height: 46), pin: CGPoint(x: 108, y: 272), tilt: 1.5),
        "desk": PalaceSlot(frame: CGRect(x: 198, y: 182, width: 78, height: 84), pin: CGPoint(x: 286, y: 272), align: .trailing, tilt: -1),
        "guestLeft": PalaceSlot(frame: CGRect(x: 4, y: 236, width: 90, height: 166), pin: CGPoint(x: 6, y: 382), tilt: 1),
        "front": PalaceSlot(frame: CGRect(x: 112, y: 324, width: 150, height: 80), pin: CGPoint(x: 186, y: 382), align: .center, tilt: -1),
        "guestRight": PalaceSlot(frame: CGRect(x: 286, y: 236, width: 80, height: 166), pin: CGPoint(x: 366, y: 382), align: .trailing, tilt: -1.5),
    ]
}

/// A hotel cut open like a doll's house: two guest rooms upstairs (blue and yellow wallpaper),
/// a floor between, and the lobby below with green walls, a long wooden desk and a marble floor.
enum G4HotelBackdrop {
    nonisolated static let marks: [PalaceMark] = rooms + lobby + desk + floor

    private nonisolated static let rooms: [PalaceMark] = {
        var stripes = "", dots = ""
        for x in stride(from: 10.0, to: 182, by: 14) { stripes += "M\(x) 8V136" }
        for x in stride(from: 196.0, to: 370, by: 18) {
            for y in stride(from: 18.0, to: 130, by: 18) { dots += "M\(x) \(y)h2.4v2.4h-2.4Z" }
        }
        return [
            .f("M0 0H370V150H0Z", 0xD8E2EA),
            .s(stripes, 0xC8D6E0, 3),
            .f("M186 0H370V150H186Z", 0xF2E6C8),
            .f(dots, 0xD9C08A),
            .f("M0 0H370V8H0Z", 0x5E6B73),
            .f("M0 136H370V150H0Z", 0x9A6A42),
            .s("M0 143H370", 0x7A5230, 1),
            .f("M180 8H190V150H180Z", 0xEFEBE2),
            .f("M188 8H190V150H188Z", 0x1E1E1C, 0.1),
            // Windows in each room
            .f("M140 18H172V60H140Z", 0xEFEBE2),
            .f("M143 21H169V57H143Z", 0x232B3B),
            .dot(160, 30, 4.5, 0xFAC775),
            .dot(162, 28.5, 4.5, 0x232B3B),
            .f("M326 18H358V60H326Z", 0xEFEBE2),
            .f("M329 21H355V57H329Z", 0xBCDCEB),
            .dot(344, 34, 5, 0xFAC775),
            .f("M329 46H355V57H329Z", 0xF2B33D, 0.4),
            .f("M0 150H370V162H0Z", 0xB4B2A9),
            .f("M0 160H370V164H0Z", 0x5E6B73),
        ]
    }()

    private nonisolated static let lobby: [PalaceMark] = [
        .f("M0 164H370V300H0Z", 0x3F5A4A),
        .f("M0 164H370V168H0Z", 0xC9A15B),
        .f("M0 252H370V300H0Z", 0x7A5230),
        .f("M0 250H370V254H0Z", 0xC9A15B),
        .s("M40 258V296M100 258V296M160 258V296M220 258V296M280 258V296M340 258V296", 0x6B4A2E, 1.4),
        // Lamps on the wall
        .f("M96 236H104L102 246H98Z M266 236H274L272 246H268Z", 0xC9A15B),
        .dot(100, 234, 5, 0xFAC775),
        .dot(270, 234, 5, 0xFAC775),
    ]

    private nonisolated static let desk: [PalaceMark] = [
        .f("M108 264H286V324H108Z", 0x7A5230),
        .f("M118 274H190V316H118Z M204 274H276V316H204Z", 0x8C5E38),
        .s("M118 274H190V316H118Z M204 274H276V316H204Z", 0xC9A15B, 1),
        .f("M102 256H292V266H102Z", 0xC9965F),
        .f("M102 266H292V269H102Z", 0x4A3524),
    ]

    private nonisolated static let floor: [PalaceMark] = {
        var tiles = ""
        for r in 0..<5 {
            for c in 0..<16 where (r + c) % 2 == 0 {
                tiles += "M\(c * 24 - 6) \(300 + r * 24)h24v24h-24Z"
            }
        }
        return [
            .f("M0 300H370V408H0Z", 0xEFEBE2),
            .f(tiles, 0xD3D1C7),
            .f("M0 300H370V304H0Z", 0x1E1E1C, 0.12),
            .oval(100, 318, 194, 14, 0x1E1E1C, 0.1),
        ]
    }()
}
