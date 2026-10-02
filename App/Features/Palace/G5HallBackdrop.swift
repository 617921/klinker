import SwiftUI

/// The hall that the cinema and the theatre share (two looks): a crest above a wide opening that
/// holds the screen or the stage, two spots high on each side wall (posters, or a box with a rail
/// in the theatre), three rows of seats across the room and a carpeted front with three spots.
enum G5Hall {
    static let noor = CGPoint(x: 222, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "crest": PalaceSlot(frame: CGRect(x: 150, y: 1, width: 70, height: 38), pin: CGPoint(x: 185, y: 38), align: .center, tilt: -1),
        "stage": PalaceSlot(frame: CGRect(x: 134, y: 52, width: 102, height: 146), pin: CGPoint(x: 185, y: 172), align: .center, tilt: 1.5),
        "screen": PalaceSlot(frame: CGRect(x: 74, y: 34, width: 222, height: 138), pin: CGPoint(x: 80, y: 40), tilt: -1.5),
        "wallLeft": PalaceSlot(frame: CGRect(x: 6, y: 16, width: 54, height: 58), pin: CGPoint(x: 4, y: 76), tilt: 1.5),
        "wallRight": PalaceSlot(frame: CGRect(x: 310, y: 16, width: 54, height: 58), pin: CGPoint(x: 366, y: 76), align: .trailing, tilt: -1.5),
        "boxLeft": PalaceSlot(frame: CGRect(x: 0, y: 100, width: 84, height: 64), pin: CGPoint(x: 4, y: 166), tilt: -1),
        "boxRight": PalaceSlot(frame: CGRect(x: 286, y: 100, width: 84, height: 64), pin: CGPoint(x: 366, y: 166), align: .trailing, tilt: 1),
        "seats": PalaceSlot(frame: CGRect(x: 0, y: 204, width: 370, height: 88), pin: CGPoint(x: 112, y: 254), align: .center, tilt: -1),
        "floorLeft": PalaceSlot(frame: CGRect(x: 2, y: 288, width: 86, height: 114), pin: CGPoint(x: 6, y: 376), tilt: 1.5),
        "floorMid": PalaceSlot(frame: CGRect(x: 92, y: 292, width: 92, height: 110), pin: CGPoint(x: 138, y: 378), align: .center, tilt: -1.5),
        "floorRight": PalaceSlot(frame: CGRect(x: 276, y: 286, width: 92, height: 116), pin: CGPoint(x: 366, y: 376), align: .trailing, tilt: 1.5),
    ]
}

/// A cinema (indigo walls, a framed screen between narrow curtains) or a theatre (red walls,
/// a gilded arch with drawn-back curtains over a wooden stage with footlights, a box on each side).
struct G5HallBackdrop: View, Equatable {
    let theater: Bool

    var body: some View {
        PalaceArtwork(marks: theater ? Self.theaterMarks : Self.cinemaMarks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    private nonisolated static let theaterMarks: [PalaceMark] =
        walls(0x6E1A16, band: 0x4A120F, trim: 0xC9A15B) + arch + stage + boxes + floor(0x5A1612, front: 0x7A2A22)
    private nonisolated static let cinemaMarks: [PalaceMark] =
        walls(0x2B2840, band: 0x1E1C30, trim: 0x5E5A7A) + screen + floor(0x231F33, front: 0x3A2E44)

    private nonisolated static func walls(_ wall: UInt32, band: UInt32, trim: UInt32) -> [PalaceMark] {
        var panels: [PalaceMark] = []
        for x in [6.0, 310] {
            panels.append(.s("M\(x) 96H\(x + 54)V200H\(x)Z", PalaceInk.shade(wall, 1.15), 1.2))
        }
        return [
            .f("M0 0H370V204H0Z", wall),
            .f("M0 0H370V12H0Z", band),
            .f("M0 12H370V14H0Z", trim),
            .f("M0 14H370V18H0Z", 0x1E1E1C, 0.12),
        ] + panels
    }

    private nonisolated static let screen: [PalaceMark] = [
        .f("M62 22H308V202H62Z", 0x1E1E1C),
        .f("M74 34H296V172H74Z", 0xE8E4DA),
        .f("M62 22H78V202H62Z M292 22H308V202H292Z", 0x6E2A4A),
        .s("M67 24V200M72 24V200M298 24V200M303 24V200", 0x52203A, 1.2),
        .f("M74 176H296V202H74Z", 0x3A3550),
        .f("M74 176H296V179H74Z", 0x1E1E1C, 0.25),
        .dot(34, 100, 8, 0xFAC775, 0.18), .f("M30 98H38L36 106H32Z", 0xC9A15B),
        .dot(336, 100, 8, 0xFAC775, 0.18), .f("M332 98H340L338 106H334Z", 0xC9A15B),
    ]

    private nonisolated static let arch: [PalaceMark] = [
        .f("M60 204V40Q60 20 80 20H290Q310 20 310 40V204Z", 0xC9A15B),
        .f("M64 204V42Q64 24 82 24H288Q306 24 306 42V204Z", 0xA8843E),
        .f("M72 204V46Q72 32 86 32H284Q298 32 298 46V204Z", 0x2E1A12),
        .f("M86 40H284V176H86Z", 0x3A2418),
        .f("M72 32H112Q100 70 106 112Q94 150 102 176H72Z", 0xA3221B),
        .f("M298 32H258Q270 70 264 112Q276 150 268 176H298Z", 0xA3221B),
        .s("M80 36Q78 100 82 176M90 36Q86 100 92 176M290 36Q292 100 288 176M280 36Q284 100 278 176", 0x7A1A14, 1.4),
        .f("M98 110H110V118H98Z M260 110H272V118H260Z", 0xC9A15B),
        .f("M72 32H298V48H72Z", 0xA3221B),
        .f("M72 48Q84 58 96 48Q108 58 120 48Q132 58 144 48Q156 58 168 48Q180 58 192 48Q204 58 216 48Q228 58 240 48Q252 58 264 48Q276 58 288 48Q293 54 298 48V48H72Z", 0xA3221B),
        .s("M72 48Q84 58 96 48Q108 58 120 48Q132 58 144 48Q156 58 168 48Q180 58 192 48Q204 58 216 48Q228 58 240 48Q252 58 264 48Q276 58 288 48Q293 54 298 48", 0xC9A15B, 1.6),
    ]

    private nonisolated static let stage: [PalaceMark] = {
        var planks = "", lights: [PalaceMark] = []
        for y in stride(from: 182.0, to: 196, by: 6) { planks += "M72 \(y)H298" }
        for x in stride(from: 90.0, to: 290, by: 24) {
            lights.append(.dot(x, 199, 5, 0xFAC775, 0.25))
            lights.append(.f("M\(x - 3) 202H\(x + 3)L\(x + 2) 197H\(x - 2)Z", 0xFFF6D8))
        }
        return [
            .f("M72 176H298V196H72Z", 0x9A6A42),
            .s(planks, 0x7A5230, 1),
            .f("M66 196H304V204H66Z", 0x4A3524),
        ] + lights
    }()

    private nonisolated static let boxes: [PalaceMark] = [42.0, 328].flatMap { cx -> [PalaceMark] in
        [
            .f("M\(cx - 30) 168V112Q\(cx - 30) 92 \(cx - 10) 92H\(cx + 10)Q\(cx + 30) 92 \(cx + 30) 112V168Z", 0x2E1210),
            .f("M\(cx - 30) 104Q\(cx) 120 \(cx + 30) 104V96H\(cx - 30)Z", 0xA3221B),
            .f("M\(cx - 36) 162H\(cx + 36)V170H\(cx - 36)Z", 0x8C1E18),
            .f("M\(cx - 34) 170H\(cx + 34)Q\(cx + 32) 196 \(cx) 200Q\(cx - 32) 196 \(cx - 34) 170Z", 0xC9A15B),
            .f("M\(cx - 28) 174H\(cx + 28)Q\(cx + 26) 191 \(cx) 194Q\(cx - 26) 191 \(cx - 28) 174Z", 0xA3221B),
        ]
    }

    private nonisolated static func floor(_ carpet: UInt32, front: UInt32) -> [PalaceMark] {
        var pattern = ""
        for y in stride(from: 304.0, to: 408, by: 20) {
            for x in stride(from: Double(Int(y) % 40 == 4 ? 0 : 20), to: 370, by: 40) {
                pattern += "M\(x) \(y)l6 6l-6 6l-6 -6Z"
            }
        }
        return [
            .f("M0 204H370V292H0Z", carpet),
            .f("M0 204H370V208H0Z", 0x1E1E1C, 0.25),
            .f("M0 292H370V408H0Z", front),
            .f(pattern, PalaceInk.shade(front, 1.18)),
            .f("M0 292H370V296H0Z", 0x1E1E1C, 0.18),
        ]
    }
}
