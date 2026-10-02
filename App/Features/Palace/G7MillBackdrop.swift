import SwiftUI

/// The windmill's named slots: the sails on the mill, two weather spots in the sky on the right,
/// a plaque on the mill's wall, a field on each side, and four spots in front.
enum G7Mill {
    static let noor = CGPoint(x: 210, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "sails": PalaceSlot(frame: CGRect(x: 36, y: 0, width: 200, height: 176), pin: CGPoint(x: 38, y: 40), tilt: -2),
        "skyRight": PalaceSlot(frame: CGRect(x: 244, y: 10, width: 122, height: 104), pin: CGPoint(x: 366, y: 100), align: .trailing, tilt: 1.5),
        "fieldRight": PalaceSlot(frame: CGRect(x: 250, y: 120, width: 116, height: 100), pin: CGPoint(x: 366, y: 194), align: .trailing, tilt: -1),
        "millWall": PalaceSlot(frame: CGRect(x: 114, y: 186, width: 46, height: 56), pin: CGPoint(x: 116, y: 246), tilt: 1),
        "fieldLeft": PalaceSlot(frame: CGRect(x: 4, y: 180, width: 98, height: 100), pin: CGPoint(x: 6, y: 262), tilt: -1.5),
        "nearMill": PalaceSlot(frame: CGRect(x: 176, y: 196, width: 72, height: 104), pin: CGPoint(x: 212, y: 292), align: .center, tilt: 2),
        "frontRightHigh": PalaceSlot(frame: CGRect(x: 252, y: 224, width: 114, height: 110), pin: CGPoint(x: 366, y: 306), align: .trailing, tilt: 1),
        "door": PalaceSlot(frame: CGRect(x: 96, y: 282, width: 64, height: 120), pin: CGPoint(x: 128, y: 372), align: .center, tilt: -1.5),
        "frontLeft": PalaceSlot(frame: CGRect(x: 4, y: 298, width: 90, height: 106), pin: CGPoint(x: 6, y: 376), tilt: 1.5),
        "frontMid": PalaceSlot(frame: CGRect(x: 164, y: 318, width: 94, height: 86), pin: CGPoint(x: 168, y: 380), tilt: -1),
        "frontRight": PalaceSlot(frame: CGRect(x: 262, y: 332, width: 104, height: 52), pin: CGPoint(x: 366, y: 382), align: .trailing, tilt: 1.5),
    ]
}

/// A polder under a big sky: a low horizon with far farms and mills, green fields cut by ditches,
/// a path to a thatched windmill on a brick foot (its sails are a prop).
struct G7MillBackdrop: View, Equatable {
    var body: some View {
        PalaceOutdoorBackdrop(houses: [], scale: 1, skyHeight: 200,
                              clouds: [CGRect(x: 268, y: 150, width: 46, height: 10), CGRect(x: 10, y: 120, width: 40, height: 9)],
                              marks: Self.marks)
    }

    nonisolated static let marks: [PalaceMark] = horizon + polder + mill

    private nonisolated static let horizon: [PalaceMark] = {
        var trees = ""
        for (x, r) in [(20.0, 6.0), (30, 5), (196, 5), (240, 7), (252, 5), (300, 6), (312, 5), (356, 6)] {
            trees += "M\(x - r) 196a\(r) \(r) 0 1 0 \(2 * r) 0a\(r) \(r) 0 1 0 \(-2 * r) 0Z"
        }
        return [
            .f(trees, 0x6E8C5A),
            .f("M262 184H282V196H262Z", 0xB4B2A9),
            .f("M260 186L272 178L284 186Z", 0x8C4A3A),
            .f("M216 196L219 180H225L228 196Z", 0x7D8A92),
            .s("M222 182L213 173M222 182L231 191M222 182L231 173M222 182L213 191", 0x7D8A92, 1.4),
            .f("M0 196H370V200H0Z", 0x7FA650),
        ]
    }()

    private nonisolated static let polder: [PalaceMark] = {
        var ditches = ""
        for x0 in [-200.0, 20, 340, 560] { ditches += "M\(185 + (x0 - 185) * 0.02) 200L\(x0) 408" }
        return [
            .f("M0 200H370V408H0Z", 0x95B36B),
            .f("M0 230H370V262H0Z M0 300H370V346H0Z", 0x8DAE62),
            .s(ditches, 0x8FB6CF, 1.8, round: false, 0.8),
            .f("M120 300C118 330 96 370 70 408H178C164 370 150 330 148 300Z", 0xD9CDB4),
        ]
    }()

    /// A thatched mill body tapering up to its cap, a brick foot, a green door and two windows.
    private nonisolated static let mill: [PalaceMark] = {
        var thatch = ""
        for k in 0..<9 {
            let t = Double(k) / 8
            thatch += "M\(118 + 36 * t) 98L\(96 + 80 * t) 278"
        }
        return [
            .oval(84, 296, 104, 10, 0x1E1E1C, 0.15),
            .f("M116 96H156L176 280H96Z", 0x6B6355),
            .s(thatch, 0x5A5347, 1.2),
            .f("M116 96H156L158 112H114Z", 0x5A5347),
            .f("M92 276H180V302H92Z", 0x9A5238),
            .s("M92 284H180M92 293H180", 0x7B3F2E, 1),
            .f("M124 262H148V302H124Z", 0xFFFDF6),
            .f("M127 265H145V302H127Z", 0x2F4B3A),
            .dot(142, 285, 1.2, 0xC9A15B),
            .f("M128 140H144V158H128Z M122 206H138V224H122Z", 0xFFFDF6),
            .f("M130 142H142V156H130Z M124 208H136V222H124Z", 0x3E4C55),
            // Cap
            .f("M108 98Q110 72 136 68Q162 72 164 98Z", 0x3E4C55),
            .f("M106 96H166V102H106Z", 0x2E2117),
        ]
    }()
}
