import SwiftUI

/// The garage's named slots: a sign over the open door and the street in the doorway, three spots
/// high on the back wall, the car lift, the tool chest, and four spots on the workshop floor.
enum G6GarageRoom {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [
        "sign": PalaceSlot(frame: CGRect(x: 8, y: 20, width: 120, height: 54), pin: CGPoint(x: 68, y: 70), align: .center, tilt: -1.5),
        "doorway": PalaceSlot(frame: CGRect(x: 8, y: 100, width: 120, height: 168), pin: CGPoint(x: 68, y: 236), align: .center, tilt: 1.5),
        "wallLeft": PalaceSlot(frame: CGRect(x: 140, y: 18, width: 70, height: 78), pin: CGPoint(x: 175, y: 90), align: .center, tilt: -1.5),
        "wallMid": PalaceSlot(frame: CGRect(x: 218, y: 18, width: 70, height: 78), pin: CGPoint(x: 253, y: 90), align: .center, tilt: 1),
        "wallRight": PalaceSlot(frame: CGRect(x: 296, y: 18, width: 70, height: 78), pin: CGPoint(x: 366, y: 90), align: .trailing, tilt: -1),
        "lift": PalaceSlot(frame: CGRect(x: 140, y: 104, width: 168, height: 104), pin: CGPoint(x: 224, y: 194), align: .center, tilt: 1.5),
        "bench": PalaceSlot(frame: CGRect(x: 310, y: 136, width: 56, height: 74), pin: CGPoint(x: 366, y: 186), align: .trailing, tilt: -2),
        "floorLeft": PalaceSlot(frame: CGRect(x: 4, y: 272, width: 80, height: 132), pin: CGPoint(x: 6, y: 372), tilt: -1.5),
        "floorMid": PalaceSlot(frame: CGRect(x: 88, y: 296, width: 156, height: 104), pin: CGPoint(x: 166, y: 376), align: .center, tilt: 1),
        "floorRight": PalaceSlot(frame: CGRect(x: 244, y: 276, width: 60, height: 128), pin: CGPoint(x: 274, y: 372), align: .center, tilt: -1),
        "desk": PalaceSlot(frame: CGRect(x: 304, y: 262, width: 64, height: 120), pin: CGPoint(x: 366, y: 352), align: .trailing, tilt: 2),
    ]
}

/// A car workshop: ceiling lamps, a pale wall, the roll-up door open onto a canal street on the
/// left, the posts of a car lift, a red tool chest on the right and a concrete floor.
struct G6GarageBackdrop: View, Equatable {
    nonisolated static let door = CGRect(x: 8, y: 92, width: 120, height: 178)
    nonisolated static let houses = PalaceOutdoor.row(PalaceOutdoor.street(count: 5, shops: [1]), scale: 0.36, baseline: 214, from: 0)

    var body: some View {
        Canvas { ctx, _ in
            PalaceMark.draw(Self.wall, in: &ctx)
            var outside = ctx
            outside.clip(to: Path(Self.door))
            PalaceOutdoor.paintSky(&outside, height: 270, clouds: [CGRect(x: 30, y: 112, width: 34, height: 8)])
            PalaceOutdoor.paintHouses(Self.houses, scale: 0.36, in: &outside)
            PalaceMark.draw(Self.street, in: &outside)
            PalaceMark.draw(Self.front, in: &ctx)
        }
        .frame(width: 370, height: 408)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private nonisolated static let wall: [PalaceMark] = {
        var lamps = ""
        for x in stride(from: 150.0, to: 370, by: 74) { lamps += "M\(x) 4H\(x + 40)V10H\(x)Z" }
        return [
            .f("M0 0H370V272H0Z", 0xDCE0DA),
            .f("M0 0H370V14H0Z", 0x3E4C55),
            .f(lamps, 0xFFFDF6),
            .f("M0 14H370V17H0Z", 0x1E1E1C, 0.12),
            .f("M0 214H370V272H0Z", 0xB9C2BE),
            .f("M0 212H370V215H0Z", 0x8E9AA0),
        ]
    }()

    private nonisolated static let street: [PalaceMark] = [
        .f("M0 214H140V222H0Z", 0xA19E95),
        .f("M0 222H140V272H0Z", 0x8E8A80),
        .f("M14 246H40V249H14Z M64 246H90V249H64Z M114 246H140V249H114Z", 0xF4F1EA, 0.7),
    ]

    private nonisolated static let front: [PalaceMark] = {
        var slats = "", grate = ""
        for y in stride(from: 80.0, to: 92, by: 3) { slats += "M4 \(y)H132" }
        for x in stride(from: 172.0, to: 260, by: 6) { grate += "M\(x) 330V338" }
        return [
            // door frame and the rolled-up shutter
            .f("M2 76H134V92H2Z", 0x8E9AA0),
            .s(slats, 0x5E6B73, 1),
            .f("M2 92H8V272H2Z M128 92H134V272H128Z", 0x5E6B73),
            .f("M8 268H128V272H8Z", 0xFAC775),
            // lift posts with yellow arms' anchors
            .f("M142 70H151V272H142Z M296 70H305V272H296Z", 0x2F5BD3),
            .f("M142 70H145V272H142Z M296 70H299V272H296Z", 0x6F8FE8, 0.6),
            .f("M139 266H154V274H139Z M293 266H308V274H293Z", 0x1F3A6B),
            .f("M142 66H305V72H142Z", 0x1F3A6B),
            // tool chest
            .f("M308 208H368V272H308Z", 0xC8261B),
            .f("M308 206H368V212H308Z", 0x9A1E15),
            .s("M308 226H368M308 242H368M308 258H368", 0x9A1E15, 1.6),
            .s("M330 219H346M330 235H346M330 251H346", 0xD3D1C7, 2.4, round: true),
            // floor
            .f("M0 272H370V408H0Z", 0xB8B5AC),
            .f("M0 272H370V276H0Z", 0x1E1E1C, 0.12),
            .f("M0 290H370V294H0Z", 0xFAC775, 0.8),
            .oval(150, 340, 70, 14, 0x3E4C55, 0.18),
            .f("M168 326H262V342H168Z", 0x8E8A80),
            .s(grate, 0x5E6B73, 1.6),
        ]
    }()
}
