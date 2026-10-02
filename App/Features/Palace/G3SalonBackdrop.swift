import SwiftUI

/// The hairdresser's named slots: two posters high on the left, four heads on the wall shelf, two
/// salon chairs before the mirrors and three spots on the floor.
enum G3SalonRoom {
    static let noor = CGPoint(x: 300, y: 294)

    nonisolated static let slots: [String: PalaceSlot] = [
        "posterLeft": PalaceSlot(frame: CGRect(x: 6, y: 6, width: 96, height: 74), pin: CGPoint(x: 8, y: 76), tilt: -2),
        "posterMid": PalaceSlot(frame: CGRect(x: 110, y: 8, width: 82, height: 70), pin: CGPoint(x: 190, y: 76), align: .trailing, tilt: 1.5),
        "head1": PalaceSlot(frame: CGRect(x: 4, y: 104, width: 46, height: 72), pin: CGPoint(x: 4, y: 178), tilt: -1.5),
        "head2": PalaceSlot(frame: CGRect(x: 50, y: 104, width: 46, height: 72), pin: CGPoint(x: 73, y: 208), align: .center, tilt: 1.5),
        "head3": PalaceSlot(frame: CGRect(x: 96, y: 104, width: 46, height: 72), pin: CGPoint(x: 119, y: 178), align: .center, tilt: -1),
        "head4": PalaceSlot(frame: CGRect(x: 142, y: 104, width: 46, height: 72), pin: CGPoint(x: 168, y: 208), align: .center, tilt: 1),
        "chairLeft": PalaceSlot(frame: CGRect(x: 194, y: 100, width: 92, height: 196), pin: CGPoint(x: 240, y: 256), align: .center, tilt: -1.5),
        "chairRight": PalaceSlot(frame: CGRect(x: 280, y: 100, width: 90, height: 196), pin: CGPoint(x: 366, y: 264), align: .trailing, tilt: 1.5),
        "floor1": PalaceSlot(frame: CGRect(x: 4, y: 284, width: 66, height: 120), pin: CGPoint(x: 4, y: 378), tilt: -1.5),
        "floor2": PalaceSlot(frame: CGRect(x: 80, y: 284, width: 66, height: 120), pin: CGPoint(x: 113, y: 378), align: .center, tilt: 1.5),
        "floor3": PalaceSlot(frame: CGRect(x: 160, y: 292, width: 76, height: 112), pin: CGPoint(x: 198, y: 380), align: .center, tilt: -1),
    ]
}

/// A hairdresser's salon: blush walls, a shelf for the heads, two framed mirrors over a counter and
/// a soft chequered floor with a few clippings.
struct G3SalonBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = wall + mirrors + floor

    private nonisolated static let wall: [PalaceMark] = [
        .f("M0 0H370V252H0Z", 0xECD9CE),
        .f("M0 210H370V252H0Z", 0xD9BFB1),
        .f("M0 206H370V211H0Z", 0x9A6A42),
        .f("M0 0H370V7H0Z", 0xEFEBE2),
        .f("M0 7H370V9H0Z", 0x1E1E1C, 0.07),
        // The shelf for the heads
        .f("M2 172H190V179H2Z", 0x9A6A42),
        .f("M2 179H190V181H2Z", 0x1E1E1C, 0.12),
        .f("M14 181H20L20 192Z M172 181H178L172 192Z", 0x6B4A2E),
    ]

    private nonisolated static let mirrors: [PalaceMark] = {
        var marks: [PalaceMark] = []
        for x in [204.0, 290] {
            marks += [
                .f("M\(x) 54Q\(x) 24 \(x + 37) 24Q\(x + 74) 24 \(x + 74) 54V176H\(x)Z", 0xC9A15B),
                .f("M\(x + 5) 56Q\(x + 5) 30 \(x + 37) 30Q\(x + 69) 30 \(x + 69) 56V172H\(x + 5)Z", 0xC9D6DC),
                .f("M\(x + 14) 150L\(x + 44) 50H\(x + 54)L\(x + 24) 150Z", 0xFFFFFF, 0.35),
            ]
        }
        return marks + [
            .f("M196 176H370V188H196Z", 0xEFEBE2),
            .f("M196 188H370V191H196Z", 0x1E1E1C, 0.1),
            .f("M282 160H288V176H282Z", 0x2F5BD3),
            .f("M283 156H287V160H283Z", 0x1E1E1C),
            .f("M362 164H368V176H362Z", 0xED93B1),
        ]
    }()

    private nonisolated static let floor: [PalaceMark] = {
        var tiles = ""
        for r in 0..<7 {
            for c in 0..<17 where (r + c) % 2 == 0 {
                tiles += "M\(c * 23 - 6) \(254 + r * 23)h23v23h-23Z"
            }
        }
        var clips = ""
        for (x, y) in [(220.0, 300.0), (236, 306), (250, 298), (306, 304), (322, 310), (338, 300), (230, 316)] {
            clips += "M\(x) \(y)l5 2M\(x + 3) \(y + 4)l4 -2"
        }
        return [
            .f("M0 252H370V408H0Z", 0xE8E2D6),
            .f(tiles, 0xD3C9B7),
            .s(clips, 0x4A3524, 1.2),
            .f("M0 250H370V255H0Z", 0x6B4A2E),
            .f("M0 255H370V258H0Z", 0x1E1E1C, 0.08),
        ]
    }()
}
