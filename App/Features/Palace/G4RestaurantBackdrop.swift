import SwiftUI

/// The restaurant's named slots: the menu case by the door, four plates on the pass of the open
/// kitchen, three tables at the back and two at the front, and the waiter's spot.
enum G4Restaurant {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [
        "menu": PalaceSlot(frame: CGRect(x: 6, y: 18, width: 88, height: 126), pin: CGPoint(x: 4, y: 146), tilt: -1.5),
        "pass1": PalaceSlot(frame: CGRect(x: 104, y: 90, width: 62, height: 60), pin: CGPoint(x: 106, y: 154), tilt: 1.5),
        "pass2": PalaceSlot(frame: CGRect(x: 170, y: 90, width: 62, height: 60), pin: CGPoint(x: 112, y: 68), tilt: -1.5),
        "pass3": PalaceSlot(frame: CGRect(x: 236, y: 90, width: 62, height: 60), pin: CGPoint(x: 268, y: 154), align: .center, tilt: 1),
        "pass4": PalaceSlot(frame: CGRect(x: 302, y: 90, width: 62, height: 60), pin: CGPoint(x: 366, y: 68), align: .trailing, tilt: -1),
        "tableLeft": PalaceSlot(frame: CGRect(x: 4, y: 170, width: 116, height: 112), pin: CGPoint(x: 6, y: 266), tilt: -1.5),
        "tableMid": PalaceSlot(frame: CGRect(x: 124, y: 172, width: 112, height: 110), pin: CGPoint(x: 180, y: 266), align: .center, tilt: 1),
        "tableRight": PalaceSlot(frame: CGRect(x: 240, y: 172, width: 124, height: 96), pin: CGPoint(x: 242, y: 176), tilt: -1),
        "frontLeft": PalaceSlot(frame: CGRect(x: 4, y: 290, width: 124, height: 114), pin: CGPoint(x: 6, y: 382), tilt: 1.5),
        "frontMid": PalaceSlot(frame: CGRect(x: 132, y: 290, width: 130, height: 114), pin: CGPoint(x: 196, y: 382), align: .center, tilt: -1),
        "waiter": PalaceSlot(frame: CGRect(x: 280, y: 250, width: 86, height: 154), pin: CGPoint(x: 366, y: 382), align: .trailing, tilt: 1.5),
    ]
}

/// A restaurant: sand walls over a terracotta wainscot, the open kitchen behind a long steel pass
/// with heat lamps and a chef, a menu case by the door and a warm plank floor.
enum G4RestaurantBackdrop {
    nonisolated static let marks: [PalaceMark] = wall + kitchen + floor

    private nonisolated static let wall: [PalaceMark] = [
        .f("M0 0H370V246H0Z", 0xE7C9A0),
        .f("M0 0H370V6H0Z", 0xF4EEE2),
        .f("M0 176H370V246H0Z", 0xA3513A),
        .f("M0 172H370V178H0Z", 0x6B4A2E),
        .s("M30 182V240M90 182V240M150 182V240M210 182V240M270 182V240M330 182V240", 0x8C4230, 1.4),
    ]

    private nonisolated static let kitchen: [PalaceMark] = {
        var tiles = ""
        for y in stride(from: 36.0, to: 140, by: 12) { tiles += "M104 \(y)H366" }
        for x in stride(from: 110.0, to: 366, by: 12) { tiles += "M\(x) 26V140" }
        return [
            .f("M98 18H370V158H98Z", 0x6B4A2E),
            .f("M104 24H370V146H104Z", 0xE4ECEE),
            .s(tiles, 0xD3DCE0, 0.8),
            .f("M104 24H370V40H104Z", 0x9A9890),
            // Pans on a rail
            .s("M118 46H190", 0x5E6B73, 1.6),
            .f("M124 46h3v8h-3Z M150 46h3v8h-3Z M176 46h3v8h-3Z", 0x5E6B73),
            .dot(125.5, 62, 8, 0x3E4C55), .dot(151.5, 64, 10, 0x3E4C55), .dot(177.5, 61, 7, 0xC9A15B),
            // The chef at the back
            .f("M188 146 V80 C188 70 196 66 206 66 C216 66 224 70 224 80 V146Z", 0xFFFDF6),
            .s("M202 76 V140", 0xD3D1C7, 1.2),
            .dot(198, 86, 1.6, 0xB4B2A9), .dot(198, 98, 1.6, 0xB4B2A9),
            .dot(206, 52, 10, 0xC99A74),
            .f("M194 44 H218 V48 H194Z", 0xFFFDF6),
            .f("M196 44 C192 36 196 28 202 30 C204 24 212 24 212 30 C218 28 222 36 216 44Z", 0xFFFDF6),
            .dot(211, 52.5, 1.3, 0x2E2117),
            .s("M209 57 Q211.5 59 214 57", 0x8C5A3C, 1.1),
            // Heat lamps over the pass
            .s("M136 24V54M268 24V54M334 24V54", 0x3E4C55, 1.2),
            .f("M126 54H146L142 62H130Z M258 54H278L274 62H262Z M324 54H344L340 62H328Z", 0xC8261B),
            .f("M130 62H142L156 90H116Z M262 62H274L288 90H248Z M328 62H340L354 90H314Z", 0xF2B33D, 0.14),
            // The pass
            .f("M98 146H370V156H98Z", 0xB4B2A9),
            .f("M98 154H370V158H98Z", 0x5E6B73),
            // Menu case by the door
            .f("M2 14H98V150H2Z", 0x4A3524),
        ]
    }()

    private nonisolated static let floor: [PalaceMark] = {
        var planks = ""
        for (r, y) in [272.0, 304, 340, 378].enumerated() {
            planks += "M0 \(y)H370"
            var x = Double(r % 2) * 44 + 22
            while x < 370 {
                planks += "M\(x) \(y)V\(r == 0 ? 246 : [272.0, 304, 340][r - 1])"
                x += 88
            }
        }
        return [
            .f("M0 246H370V408H0Z", 0xA97A4A),
            .s(planks, 0x8C5E38, 1.3),
            .f("M0 246H370V250H0Z", 0x1E1E1C, 0.15),
        ]
    }()
}
