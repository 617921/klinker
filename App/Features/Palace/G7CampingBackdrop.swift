import SwiftUI

/// The campsite's named slots: four spots along the trees at the back, three on the field in
/// the middle and four in front.
enum G7Camping {
    static let noor = CGPoint(x: 160, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "backLeft": PalaceSlot(frame: CGRect(x: 4, y: 72, width: 94, height: 116), pin: CGPoint(x: 6, y: 168), tilt: -1.5),
        "backMid": PalaceSlot(frame: CGRect(x: 100, y: 42, width: 104, height: 148), pin: CGPoint(x: 152, y: 186), align: .center, tilt: 1),
        "backSign": PalaceSlot(frame: CGRect(x: 206, y: 86, width: 64, height: 104), pin: CGPoint(x: 238, y: 168), align: .center, tilt: -1),
        "backRight": PalaceSlot(frame: CGRect(x: 272, y: 78, width: 94, height: 108), pin: CGPoint(x: 366, y: 166), align: .trailing, tilt: 1.5),
        "midLeft": PalaceSlot(frame: CGRect(x: 4, y: 198, width: 116, height: 86), pin: CGPoint(x: 6, y: 264), tilt: 1),
        "midMid": PalaceSlot(frame: CGRect(x: 122, y: 188, width: 116, height: 102), pin: CGPoint(x: 180, y: 270), align: .center, tilt: -1.5),
        "midRight": PalaceSlot(frame: CGRect(x: 240, y: 192, width: 126, height: 98), pin: CGPoint(x: 366, y: 270), align: .trailing, tilt: 1),
        "frontLeft": PalaceSlot(frame: CGRect(x: 4, y: 324, width: 108, height: 70), pin: CGPoint(x: 6, y: 380), tilt: -1),
        "frontFire": PalaceSlot(frame: CGRect(x: 114, y: 298, width: 100, height: 104), pin: CGPoint(x: 164, y: 380), align: .center, tilt: 1.5),
        "frontPeg": PalaceSlot(frame: CGRect(x: 216, y: 304, width: 64, height: 100), pin: CGPoint(x: 248, y: 380), align: .center, tilt: -1.5),
        "frontRight": PalaceSlot(frame: CGRect(x: 282, y: 318, width: 84, height: 70), pin: CGPoint(x: 366, y: 382), align: .trailing, tilt: 1),
    ]
}

/// A campsite in the woods: a row of trees with a glimpse of a lake, a wide mown field and a
/// gravel path running through it.
struct G7CampingBackdrop: View, Equatable {
    var body: some View {
        PalaceOutdoorBackdrop(houses: [], scale: 1, skyHeight: 150,
                              clouds: [CGRect(x: 40, y: 24, width: 48, height: 11), CGRect(x: 240, y: 16, width: 40, height: 9)],
                              marks: Self.marks)
    }

    nonisolated static let marks: [PalaceMark] = {
        var crowns = "", light = ""
        for (i, x) in stride(from: -10.0, to: 390, by: 24).enumerated() {
            let r = 20.0 + Double((i * 7) % 5) * 3
            let y = 118.0 - Double((i * 5) % 3) * 6
            let circle = "M\(x - r) \(y)a\(r) \(r) 0 1 0 \(2 * r) 0a\(r) \(r) 0 1 0 \(-2 * r) 0Z"
            if i % 2 == 0 { crowns += circle } else { light += circle }
        }
        var tufts = ""
        for (x, y) in [(20.0, 300.0), (130, 300), (290, 296), (60, 404), (200, 300), (350, 300), (100, 190), (250, 186)] {
            tufts += "M\(x) \(y)l2 -5l2 5l2 -6l2 6"
        }
        return [
            .f("M200 110H300V140H200Z", 0x8FB6CF),
            .f(light, 0x4E7A3A),
            .f(crowns, 0x3F6B33),
            .f("M0 136H370V408H0Z", 0x9DBB72),
            .f("M0 136H370V146H0Z", 0x7FA650),
            .f("M0 196H370V206H0Z M0 296H370V304H0Z", 0x92B169),
            .f("M186 146C176 200 210 250 190 300C176 340 200 380 196 408H232C238 380 214 340 226 300C246 250 212 200 200 146Z", 0xD9CDB4),
            .s("M196 180h2M206 230h2M210 270h2M200 320h2M214 360h2M206 396h2", 0xB49A66, 2, round: true),
            .s(tufts, 0x7FA650, 1.4, round: true),
        ]
    }()
}
