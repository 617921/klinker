import SwiftUI

/// The community hall's named slots: a board and two posters high on the wall, a sign over the
/// side room, the table by the window, the coffee hatch, the glass side room and four floor spots.
enum G4CommunityHall {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [
        "boardLeft": PalaceSlot(frame: CGRect(x: 4, y: 10, width: 122, height: 82), pin: CGPoint(x: 6, y: 86), tilt: -1.5),
        "posterMid": PalaceSlot(frame: CGRect(x: 132, y: 12, width: 74, height: 80), pin: CGPoint(x: 168, y: 86), align: .center, tilt: 1.5),
        "posterRight": PalaceSlot(frame: CGRect(x: 212, y: 12, width: 74, height: 80), pin: CGPoint(x: 250, y: 2), align: .center, tilt: -1),
        "signDoor": PalaceSlot(frame: CGRect(x: 292, y: 10, width: 74, height: 62), pin: CGPoint(x: 366, y: 70), align: .trailing, tilt: 1.5),
        "window": PalaceSlot(frame: CGRect(x: 4, y: 136, width: 116, height: 116), pin: CGPoint(x: 6, y: 112), tilt: 1),
        "hatch": PalaceSlot(frame: CGRect(x: 132, y: 104, width: 100, height: 104), pin: CGPoint(x: 182, y: 212), align: .center, tilt: -1),
        "sideRoom": PalaceSlot(frame: CGRect(x: 246, y: 92, width: 120, height: 162), pin: CGPoint(x: 366, y: 236), align: .trailing, tilt: 1),
        "floor1": PalaceSlot(frame: CGRect(x: 4, y: 270, width: 72, height: 112), pin: CGPoint(x: 6, y: 382), tilt: -1.5),
        "floor2": PalaceSlot(frame: CGRect(x: 80, y: 278, width: 60, height: 104), pin: CGPoint(x: 110, y: 382), align: .center, tilt: 1.5),
        "floor3": PalaceSlot(frame: CGRect(x: 144, y: 290, width: 132, height: 92), pin: CGPoint(x: 210, y: 382), align: .center, tilt: -1),
        "floor4": PalaceSlot(frame: CGRect(x: 280, y: 270, width: 86, height: 112), pin: CGPoint(x: 366, y: 382), align: .trailing, tilt: 1.5),
    ]
}

/// A community hall: warm walls with a wooden rail, a big window onto the street, a coffee hatch
/// into the kitchen, a glass side room, stacked chairs and a parquet floor.
enum G4CommunityHallBackdrop {
    nonisolated static let marks: [PalaceMark] = wall + window + hatch + floor

    private nonisolated static let wall: [PalaceMark] = [
        .f("M0 0H370V258H0Z", 0xEBDCC2),
        .f("M0 0H370V6H0Z", 0xF4EEE2),
        .f("M0 206H370V258H0Z", 0xC97B52),
        .f("M0 202H370V208H0Z", 0x8C5E38),
        .s("M0 224H370M0 242H370", 0xB06A44, 1),
        .s("M20 208V224M60 208V224M100 208V224M140 208V224M180 208V224M220 208V224M260 208V224M300 208V224M340 208V224M40 224V242M80 224V242M120 224V242M160 224V242M200 224V242M240 224V242M280 224V242M320 224V242M360 224V242", 0xB06A44, 1),
    ]

    private nonisolated static let window: [PalaceMark] = [
        .f("M4 100H122V236H4Z", 0xEFEBE2),
        .f("M10 106H116V230H10Z", 0xBCDCEB),
        .f("M10 150H40V230H10Z", 0x9A5238),
        .f("M40 140H74V230H40Z", 0x5E6B73),
        .f("M74 156H116V230H74Z", 0xD9CDB4),
        .f("M16 160h8v10h-8Z M28 160h8v10h-8Z M16 182h8v10h-8Z M28 182h8v10h-8Z M46 150h8v10h-8Z M60 150h8v10h-8Z M46 172h8v10h-8Z M60 172h8v10h-8Z M80 166h8v10h-8Z M96 166h8v10h-8Z M80 188h8v10h-8Z M96 188h8v10h-8Z", 0xFFFDF6),
        .f("M10 214H116V230H10Z", 0x8A8478),
        .s("M63 106V230M10 168H116", 0xEFEBE2, 3),
        .f("M0 230H126V238H0Z", 0xEFEBE2),
    ]

    private nonisolated static let hatch: [PalaceMark] = [
        .f("M128 100H240V208H128Z", 0xEFEBE2),
        .f("M134 106H234V200H134Z", 0xD8E8EA),
        .s("M134 124H234M134 142H234M134 160H234M134 178H234M154 106V200M174 106V200M194 106V200M214 106V200", 0xC4D8DC, 0.8),
        .f("M140 112H176V138H140Z", 0x5E6B73),
        .f("M144 116H172V126H144Z", 0x232B3B),
        .f("M150 128H166V136H150Z", 0x3E4C55),
        .f("M196 116H228V120H196Z", 0x9A6A42),
        .f("M200 104H206V116H200Z M212 108H218V116H212Z M222 106H228V116H222Z", 0xC8261B),
        .f("M126 198H242V208H126Z", 0x9A6A42),
        .f("M126 206H242V210H126Z", 0x6B4A2E),
        // Side room's back wall
        .f("M244 88H370V258H244Z", 0xE4ECEE, 0.5),
    ]

    private nonisolated static let floor: [PalaceMark] = {
        var planks = ""
        for (r, y) in [282.0, 312, 346, 382].enumerated() {
            planks += "M0 \(y)H370"
            var x = Double(r % 2) * 36 + 18
            while x < 370 {
                planks += "M\(x) \(y)V\(r == 0 ? 258 : [282.0, 312, 346][r - 1])"
                x += 72
            }
        }
        return [
            .f("M0 258H370V408H0Z", 0xC99A62),
            .s(planks, 0xA97A4A, 1.3),
            .f("M0 258H370V262H0Z", 0x1E1E1C, 0.12),
        ]
    }()
}
