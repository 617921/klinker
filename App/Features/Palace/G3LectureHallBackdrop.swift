import SwiftUI

/// The lecture hall's named slots: a sign, the screen and a notice board high up, four spots on the
/// long desk and four on the steps in front.
enum G3LectureHall {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [
        "signLeft": PalaceSlot(frame: CGRect(x: 6, y: 8, width: 108, height: 82), pin: CGPoint(x: 8, y: 92), tilt: -2),
        "screen": PalaceSlot(frame: CGRect(x: 118, y: 4, width: 134, height: 102), pin: CGPoint(x: 168, y: 100), align: .center, tilt: 1.5),
        "board": PalaceSlot(frame: CGRect(x: 280, y: 12, width: 62, height: 80), pin: CGPoint(x: 366, y: 92), align: .trailing, tilt: -1.5),
        "desk1": PalaceSlot(frame: CGRect(x: 4, y: 126, width: 88, height: 60), pin: CGPoint(x: 4, y: 182), tilt: 1.5),
        "desk2": PalaceSlot(frame: CGRect(x: 94, y: 126, width: 88, height: 60), pin: CGPoint(x: 138, y: 212), align: .center, tilt: -1.5),
        "desk3": PalaceSlot(frame: CGRect(x: 186, y: 126, width: 88, height: 60), pin: CGPoint(x: 230, y: 182), align: .center, tilt: 1),
        "desk4": PalaceSlot(frame: CGRect(x: 278, y: 124, width: 88, height: 62), pin: CGPoint(x: 366, y: 212), align: .trailing, tilt: -1),
        "step1": PalaceSlot(frame: CGRect(x: 4, y: 270, width: 68, height: 128), pin: CGPoint(x: 4, y: 376), tilt: -1.5),
        "step2": PalaceSlot(frame: CGRect(x: 76, y: 262, width: 96, height: 136), pin: CGPoint(x: 112, y: 380), align: .center, tilt: 1.5),
        "step3": PalaceSlot(frame: CGRect(x: 182, y: 270, width: 72, height: 128), pin: CGPoint(x: 218, y: 376), align: .center, tilt: -1),
        "step4": PalaceSlot(frame: CGRect(x: 280, y: 262, width: 82, height: 136), pin: CGPoint(x: 366, y: 380), align: .trailing, tilt: 1.5),
    ]
}

/// A lecture hall: cream walls with wood panelling, a cork board, one long desk with folding
/// seats and wide wooden steps.
struct G3LectureHallBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = wall + cork + desk + steps

    private nonisolated static let wall: [PalaceMark] = {
        var panels = ""
        for x in stride(from: 46.0, to: 370, by: 46) { panels += "M\(x) 112V182" }
        return [
            .f("M0 0H370V184H0Z", 0xE9E2D4),
            .f("M0 0H370V7H0Z", 0x5E6B73),
            .f("M0 7H370V9H0Z", 0x1E1E1C, 0.1),
            .f("M0 108H370V184H0Z", 0xC9A67C),
            .f("M0 106H370V111H0Z", 0x9A6A42),
            .s(panels, 0xB18E62, 1.2),
        ]
    }()

    private nonisolated static let cork: [PalaceMark] = [
        .f("M258 4H368V100H258Z", 0x7A5230),
        .f("M262 8H364V96H262Z", 0xC9965F),
        .dot(272, 18, 2, 0x2F5BD3),
        .dot(354, 84, 2, 0xC8261B),
        .f("M268 74H286V90H268Z", 0xFAC775),
    ]

    private nonisolated static let desk: [PalaceMark] = {
        var seams = ""
        for x in stride(from: 92.0, to: 370, by: 92) { seams += "M\(x) 194V238" }
        return [
            .f("M0 182H370V190H0Z", 0xC9965F),
            .f("M0 190H370V238H0Z", 0x9A6A42),
            .f("M0 190H370V193H0Z", 0x6B4A2E),
            .s(seams, 0x7A5230, 1.4),
            .f("M0 238H370V242H0Z", 0x1E1E1C, 0.12),
        ]
    }()

    private nonisolated static let steps: [PalaceMark] = [
        .f("M0 240H370V408H0Z", 0xD5C2A1),
        .f("M0 296H370V306H0Z", 0xB59870),
        .f("M0 352H370V362H0Z", 0xB59870),
        .s("M0 296H370M0 352H370", 0x8C6E4B, 1.6),
        .f("M0 306H370V309H0Z M0 362H370V365H0Z", 0x1E1E1C, 0.08),
    ]
}
