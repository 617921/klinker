import SwiftUI

/// The indoor pool's named slots: the slide on the left, a frame and a hook high on the wall,
/// a cubicle, a spot on the deck and the lifeguard's chair, the diving board on the right, the
/// lap lane and three spots in the water in front.
enum G4Pool {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [
        "slide": PalaceSlot(frame: CGRect(x: 2, y: 60, width: 100, height: 206), pin: CGPoint(x: 4, y: 42), tilt: -2),
        "wallLeft": PalaceSlot(frame: CGRect(x: 108, y: 16, width: 96, height: 74), pin: CGPoint(x: 110, y: 88), tilt: 1.5),
        "hook": PalaceSlot(frame: CGRect(x: 210, y: 14, width: 56, height: 74), pin: CGPoint(x: 238, y: 86), align: .center, tilt: -1.5),
        "cubicle": PalaceSlot(frame: CGRect(x: 106, y: 100, width: 60, height: 146), pin: CGPoint(x: 106, y: 196), tilt: -1),
        "deck": PalaceSlot(frame: CGRect(x: 168, y: 126, width: 52, height: 122), pin: CGPoint(x: 194, y: 224), align: .center, tilt: 1.5),
        "chair": PalaceSlot(frame: CGRect(x: 220, y: 92, width: 60, height: 156), pin: CGPoint(x: 250, y: 94), align: .center, tilt: 1),
        "board": PalaceSlot(frame: CGRect(x: 276, y: 74, width: 92, height: 200), pin: CGPoint(x: 366, y: 64), align: .trailing, tilt: 2),
        "lane": PalaceSlot(frame: CGRect(x: 104, y: 256, width: 172, height: 56), pin: CGPoint(x: 190, y: 286), align: .center, tilt: -1),
        "waterLeft": PalaceSlot(frame: CGRect(x: 2, y: 318, width: 128, height: 88), pin: CGPoint(x: 6, y: 380), tilt: 1.5),
        "waterMid": PalaceSlot(frame: CGRect(x: 134, y: 318, width: 112, height: 88), pin: CGPoint(x: 190, y: 380), align: .center, tilt: -1.5),
        "waterRight": PalaceSlot(frame: CGRect(x: 250, y: 312, width: 118, height: 94), pin: CGPoint(x: 366, y: 380), align: .trailing, tilt: 1),
    ]
}

/// An indoor pool: tiled aqua walls with high windows, a deck along the back, blue water with
/// ripples and a lane rope of red and white floats.
enum G4PoolBackdrop {
    nonisolated static let marks: [PalaceMark] = wall + windows + deck + water

    private nonisolated static let wall: [PalaceMark] = {
        var grout = ""
        for y in stride(from: 26.0, to: 196, by: 16) { grout += "M0 \(y)H370" }
        for x in stride(from: 8.0, to: 370, by: 16) { grout += "M\(x) 10V196" }
        return [
            .f("M0 0H370V214H0Z", 0xD8E8EA),
            .s(grout, 0xC4D8DC, 0.8),
            .f("M0 0H370V10H0Z", 0xEFEBE2),
            .f("M0 10H370V12H0Z", 0x1E1E1C, 0.06),
            .f("M0 194H370V206H0Z", 0x2F6E9E),
            .f("M0 198H370V202H0Z", 0x8FB6CF),
            .f("M0 206H370V214H0Z", 0xD8E8EA),
        ]
    }()

    private nonisolated static let windows: [PalaceMark] = {
        var marks: [PalaceMark] = []
        for x in [284.0, 326] {
            marks += [
                .f("M\(x) 14H\(x + 38)V60H\(x)Z", 0xEFEBE2),
                .f("M\(x + 3) 17H\(x + 35)V57H\(x + 3)Z", 0xBCDCEB),
                .f("M\(x + 6) 52L\(x + 22) 20H\(x + 28)L\(x + 12) 52Z", 0xFFFFFF, 0.35),
                .s("M\(x + 19) 17V57", 0xEFEBE2, 2),
            ]
        }
        return marks
    }()

    private nonisolated static let deck: [PalaceMark] = {
        var tiles = ""
        for x in stride(from: 0.0, to: 370, by: 22) { tiles += "M\(x) 214V246" }
        return [
            .f("M0 214H370V248H0Z", 0xE2DED3),
            .s(tiles + "M0 230H370", 0xD3CEC1, 1),
            .f("M0 246H370V252H0Z", 0xFFFDF6),
            .f("M0 252H370V256H0Z", 0x2F6E9E),
        ]
    }()

    private nonisolated static let water: [PalaceMark] = {
        var ripples = "", floats = ""
        for (i, y) in [272.0, 300, 336, 362, 392].enumerated() {
            var x = Double(i % 2) * 30 + 10
            while x < 360 {
                ripples += "M\(x) \(y)q6 -3 12 0t12 0"
                x += 74
            }
        }
        var x = 2.0
        while x < 370 {
            floats += "M\(x) 312h8v7h-8Z"
            x += 10
        }
        var whites = ""
        x = 12
        while x < 370 {
            whites += "M\(x) 312h8v7h-8Z"
            x += 20
        }
        return [
            .f("M0 256H370V408H0Z", 0x5BAED0),
            .f("M0 256H370V262H0Z", 0x2F6E9E, 0.25),
            .f("M0 330H370V408H0Z", 0x4FA3C7, 0.5),
            .s(ripples, 0xFFFFFF, 1.4, round: true, 0.45),
            .s("M0 315.5H370", 0x1F3A6B, 1),
            .f(floats, 0xC8261B),
            .f(whites, 0xFFFDF6),
        ]
    }()
}
