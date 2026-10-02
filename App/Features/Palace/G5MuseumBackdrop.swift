import SwiftUI

/// The museum gallery's named slots: a banner on the left, a painting with a niche under it, one big
/// canvas in the middle with a label on the dado below, a painting on the right with room for people
/// in front, a plinth and four spots on the floor.
enum G5Museum {
    static let noor = CGPoint(x: 160, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "banner": PalaceSlot(frame: CGRect(x: 4, y: 12, width: 58, height: 142), pin: CGPoint(x: 4, y: 124), tilt: -1.5),
        "paintingLeft": PalaceSlot(frame: CGRect(x: 72, y: 26, width: 90, height: 70), pin: CGPoint(x: 117, y: 92), align: .center, tilt: 1.5),
        "niche": PalaceSlot(frame: CGRect(x: 74, y: 124, width: 86, height: 82), pin: CGPoint(x: 117, y: 204), align: .center, tilt: -1),
        "plaque": PalaceSlot(frame: CGRect(x: 178, y: 208, width: 64, height: 34), pin: CGPoint(x: 212, y: 242), align: .center, tilt: 1),
        "paintingBig": PalaceSlot(frame: CGRect(x: 172, y: 18, width: 128, height: 236), pin: CGPoint(x: 236, y: 24), align: .center, tilt: -1),
        "paintingRight": PalaceSlot(frame: CGRect(x: 306, y: 30, width: 62, height: 220), pin: CGPoint(x: 366, y: 104), align: .trailing, tilt: 1.5),
        "plinthLeft": PalaceSlot(frame: CGRect(x: 2, y: 166, width: 60, height: 136), pin: CGPoint(x: 4, y: 258), tilt: 1.5),
        "floorLeft": PalaceSlot(frame: CGRect(x: 2, y: 330, width: 64, height: 74), pin: CGPoint(x: 4, y: 302), tilt: -1),
        "floorMid": PalaceSlot(frame: CGRect(x: 64, y: 258, width: 78, height: 146), pin: CGPoint(x: 100, y: 382), align: .center, tilt: 1.5),
        "floorCenter": PalaceSlot(frame: CGRect(x: 140, y: 280, width: 110, height: 124), pin: CGPoint(x: 196, y: 380), align: .center, tilt: -1.5),
        "floorRight": PalaceSlot(frame: CGRect(x: 250, y: 276, width: 118, height: 128), pin: CGPoint(x: 366, y: 380), align: .trailing, tilt: 1),
    ]
}

/// A gallery in a Dutch museum: deep green walls under a white cornice, a gilt picture rail,
/// a dark dado and a herringbone oak floor.
struct G5MuseumBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = wall + floor

    private nonisolated static let wall: [PalaceMark] = {
        var dentils = ""
        for x in stride(from: 3, to: 370, by: 9) { dentils += "M\(x) 8h5v4h-5Z" }
        return [
            .f("M0 0H370V240H0Z", 0x2E4A3E),
            .f("M0 0H370V8H0Z", 0xEFEBE2),
            .f(dentils, 0xEFEBE2),
            .f("M0 12H370V14H0Z", 0xD9CDB4),
            .f("M0 14H370V18H0Z", 0x1E1E1C, 0.15),
            .f("M0 18H370V19.5H0Z", 0xC9A15B),
            .f("M0 206H370V240H0Z", 0x22392F),
            .f("M0 204H370V208H0Z", 0x3F5A4A),
            .s("M10 214H120V234H10Z M130 214H240V234H130Z M250 214H360V234H250Z", 0x2E4A3E, 1.2),
            .f("M74 206V146Q74 118 117 118Q160 118 160 146V206Z", 0x1F3329),
            .s("M74 206V146Q74 118 117 118Q160 118 160 146V206", 0xC9A15B, 1.4),
            .f("M70 204H164V210H70Z", 0x3F5A4A),
            .dot(117, 22, 2, 0xC9A15B), .s("M117 22L102 26M117 22L132 26", 0xC9A15B, 0.8),
            .dot(337, 22, 2, 0xC9A15B), .s("M337 22L322 30M337 22L352 30", 0xC9A15B, 0.8),
        ]
    }()

    private nonisolated static let floor: [PalaceMark] = {
        var bones = ""
        for (r, y) in stride(from: 240.0, to: 408, by: 14).enumerated() {
            for x in stride(from: Double(r % 2) * 14 - 14, to: 384, by: 28) {
                bones += "M\(x) \(y)L\(x + 14) \(y + 14)M\(x + 14) \(y + 14)L\(x + 28) \(y)"
            }
        }
        return [
            .f("M0 240H370V408H0Z", 0xC9965F),
            .s(bones, 0xB07E4C, 1),
            .f("M0 240H370V244H0Z", 0x1E1E1C, 0.15),
        ]
    }()
}
