import SwiftUI

/// The concert hall's named slots: a poster and a niche on the wood-panelled wall, the orchestra
/// on the stage, five spots along the front of the stage and three blocks of seats in the hall.
enum G6ConcertRoom {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [
        "wallLeft": PalaceSlot(frame: CGRect(x: 40, y: 18, width: 70, height: 100), pin: CGPoint(x: 42, y: 112), tilt: -1.5),
        "niche": PalaceSlot(frame: CGRect(x: 268, y: 16, width: 58, height: 100), pin: CGPoint(x: 330, y: 108), align: .trailing, tilt: 1.5),
        "orchestra": PalaceSlot(frame: CGRect(x: 96, y: 70, width: 178, height: 96), pin: CGPoint(x: 185, y: 66), align: .center, tilt: -1),
        "stageLeft": PalaceSlot(frame: CGRect(x: 36, y: 120, width: 62, height: 118), pin: CGPoint(x: 38, y: 210), tilt: 1.5),
        "standLeft": PalaceSlot(frame: CGRect(x: 100, y: 152, width: 58, height: 86), pin: CGPoint(x: 129, y: 226), align: .center, tilt: -1.5),
        "conductor": PalaceSlot(frame: CGRect(x: 162, y: 140, width: 52, height: 106), pin: CGPoint(x: 188, y: 230), align: .center, tilt: 1),
        "stageRight": PalaceSlot(frame: CGRect(x: 218, y: 168, width: 68, height: 70), pin: CGPoint(x: 252, y: 226), align: .center, tilt: -1),
        "steps": PalaceSlot(frame: CGRect(x: 288, y: 134, width: 74, height: 140), pin: CGPoint(x: 366, y: 254), align: .trailing, tilt: 1.5),
        "seatsLeft": PalaceSlot(frame: CGRect(x: 4, y: 270, width: 120, height: 134), pin: CGPoint(x: 6, y: 378), tilt: -1),
        "seatsMid": PalaceSlot(frame: CGRect(x: 125, y: 270, width: 120, height: 134), pin: CGPoint(x: 185, y: 378), align: .center, tilt: 1),
        "seatsRight": PalaceSlot(frame: CGRect(x: 246, y: 270, width: 120, height: 134), pin: CGPoint(x: 366, y: 378), align: .trailing, tilt: -1.5),
    ]
}

/// A concert hall seen from the stalls: wood-panelled wall with organ pipes, red curtains, a
/// wooden stage with footlights, and dark rows of red seats.
struct G6ConcertBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = wall + stage + curtains + hall

    private nonisolated static let wall: [PalaceMark] = {
        var slats = "", pipes = "", mouths = ""
        for x in stride(from: 40.0, to: 336, by: 12) { slats += "M\(x) 0V150" }
        for (i, x) in stride(from: 124.0, to: 246, by: 9).enumerated() {
            let top = 14 + abs(Double(i) - 6.5) * 6
            pipes += "M\(x) \(top)H\(x + 7)V86H\(x)Z"
            mouths += "M\(x + 1) 70L\(x + 3.5) 66L\(x + 6) 70Z"
        }
        return [
            .f("M0 0H370V152H0Z", 0x8C5E38),
            .s(slats, 0x7A5230, 1.2),
            .f("M114 8H256V92H114Z", 0x6B4A2E),
            .f(pipes, 0xC9A15B),
            .f(mouths, 0x6B4A2E),
            .f("M110 86H260V96H110Z", 0x5E3A2A),
            .f("M262 12H332V120H262Z", 0x6B4A2E),
            .f("M268 18Q297 4 326 18V116H268Z", 0x3E2A1E),
        ]
    }()

    private nonisolated static let stage: [PalaceMark] = {
        var planks = "", lights = ""
        for x in stride(from: 10.0, to: 370, by: 30) { planks += "M\(x) 150L\(x - (x - 185) * 0.25) 238" }
        for x in stride(from: 52.0, to: 330, by: 22) { lights += "M\(x - 4) 240H\(x + 4)V244H\(x - 4)Z" }
        return [
            .f("M0 148H370V238H0Z", 0xC98B5E),
            .s(planks, 0xB27748, 1),
            .f("M0 148H370V152H0Z", 0x1E1E1C, 0.15),
            .f("M0 236H370V262H0Z", 0x3E2A1E),
            .f("M0 236H370V239H0Z", 0x2E2117),
            .f(lights, 0xFAC775),
            .f("M0 262H370V266H0Z", 0x1E1E1C, 0.3),
        ]
    }()

    private nonisolated static let curtains: [PalaceMark] = {
        var valance = ""
        for x in stride(from: 0.0, to: 370, by: 26) { valance += "M\(x) 0H\(x + 26)V14Q\(x + 13) 26 \(x) 14Z" }
        return [
            .f("M0 0H38Q30 120 34 236H0Z", 0xA3201A),
            .f("M370 0H332Q340 120 336 236H370Z", 0xA3201A),
            .s("M10 10Q8 120 12 236M22 12Q18 120 24 236M360 10Q362 120 358 236M348 12Q352 120 346 236", 0x7A1510, 2),
            .f(valance, 0xC8261B),
            .s("M0 15H370", 0xC9A15B, 2),
        ]
    }()

    private nonisolated static let hall: [PalaceMark] = {
        var seats = ""
        for (r, y) in [282.0, 326, 372].enumerated() {
            let h = 18 + Double(r) * 4, w = 24 + Double(r) * 4
            for x in stride(from: Double(r % 2) * w / 2 - 6, to: 370, by: w + 4) {
                seats += "M\(x) \(y + h)V\(y + 6)Q\(x) \(y) \(x + 6) \(y)H\(x + w - 6)Q\(x + w) \(y) \(x + w) \(y + 6)V\(y + h)Z"
            }
        }
        return [
            .f("M0 266H370V408H0Z", 0x2E2117),
            .f(seats, 0x8C1F18),
        ]
    }()
}
