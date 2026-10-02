import SwiftUI

/// The church's named slots: a board top left, the organ gallery top centre, a sign top right, the
/// pulpit on the left wall, the front under the apse, a memorial on the right wall, the aisle
/// and four spots on the floor.
enum G5Church {
    static let noor = CGPoint(x: 160, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "board": PalaceSlot(frame: CGRect(x: 12, y: 18, width: 54, height: 62), pin: CGPoint(x: 6, y: 80), tilt: -1.5),
        "gallery": PalaceSlot(frame: CGRect(x: 118, y: 18, width: 134, height: 98), pin: CGPoint(x: 185, y: 100), align: .center, tilt: 1),
        "signRight": PalaceSlot(frame: CGRect(x: 274, y: 24, width: 92, height: 48), pin: CGPoint(x: 366, y: 72), align: .trailing, tilt: 1.5),
        "pulpit": PalaceSlot(frame: CGRect(x: 2, y: 100, width: 100, height: 168), pin: CGPoint(x: 6, y: 236), tilt: 1),
        "front": PalaceSlot(frame: CGRect(x: 138, y: 126, width: 96, height: 124), pin: CGPoint(x: 186, y: 214), align: .center, tilt: -1.5),
        "plaque": PalaceSlot(frame: CGRect(x: 282, y: 96, width: 86, height: 152), pin: CGPoint(x: 366, y: 226), align: .trailing, tilt: -1),
        "aisle": PalaceSlot(frame: CGRect(x: 104, y: 248, width: 162, height: 80), pin: CGPoint(x: 185, y: 304), align: .center, tilt: 1.5),
        "floorLeft": PalaceSlot(frame: CGRect(x: 2, y: 290, width: 88, height: 114), pin: CGPoint(x: 6, y: 380), tilt: -1.5),
        "floorMid": PalaceSlot(frame: CGRect(x: 92, y: 300, width: 62, height: 104), pin: CGPoint(x: 122, y: 384), align: .center, tilt: 1),
        "floorCenter": PalaceSlot(frame: CGRect(x: 156, y: 318, width: 118, height: 86), pin: CGPoint(x: 214, y: 384), align: .center, tilt: -1),
        "floorRight": PalaceSlot(frame: CGRect(x: 276, y: 296, width: 92, height: 108), pin: CGPoint(x: 366, y: 384), align: .trailing, tilt: 1.5),
    ]
}

/// An old Dutch church inside: whitewashed walls under a wooden vault, tall clear leaded windows,
/// the organ on a gallery, a quiet apse, wooden pews and a stone floor with old slabs.
struct G5ChurchBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = wall + windows + organ + apse + floor + pews

    private nonisolated static let oak: UInt32 = 0x6B4A2E
    private nonisolated static let oakLight: UInt32 = 0x8C6440

    private nonisolated static let wall: [PalaceMark] = {
        var ribs = ""
        for x in stride(from: 0.0, through: 370, by: 46) { ribs += "M\(x) 0V14" }
        return [
            .f("M0 0H370V256H0Z", 0xEDE8DC),
            .f("M0 0H370V14H0Z", 0x6B4A2E),
            .s(ribs, 0x4A3524, 2),
            .f("M0 14H370V18H0Z", 0x1E1E1C, 0.12),
            .f("M0 236H370V256H0Z", 0xE2DCCB),
        ]
    }()

    private nonisolated static let windows: [PalaceMark] = [102.0, 254].flatMap { x -> [PalaceMark] in
        var lead = "M\(x + 8) 27V160"
        for y in stride(from: 38.0, to: 160, by: 10) { lead += "M\(x) \(y)H\(x + 16)" }
        let arch = "M\(x) 160V40Q\(x) 28 \(x + 8) 26Q\(x + 16) 28 \(x + 16) 40V160Z"
        return [
            .f(arch, 0xD3E0E6),
            PalaceMark(path: PalaceSVG.path(lead), paint: .stroke(PalaceInk.hex(0x9AAAB0), width: 0.6, round: false), opacity: 0.8),
            .s(arch, 0xB4AE9E, 2.4),
            .f("M\(x - 3) 160H\(x + 19)V164H\(x - 3)Z", 0xD9D3C4),
        ]
    }

    private nonisolated static let organ: [PalaceMark] = {
        var pipes: [PalaceMark] = []
        for (i, x) in stride(from: 132.0, to: 236, by: 8).enumerated() {
            let top = 30 + abs(Double(i) - 6.5) * 2.6
            pipes.append(.f("M\(x) \(top)H\(x + 6)V84H\(x)Z", i % 2 == 0 ? 0xC9C6BC : 0xB4B2A9))
            pipes.append(.f("M\(x + 1.5) 72H\(x + 4.5)V75H\(x + 1.5)Z", 0x5E6B73))
        }
        return [
            .f("M124 88V30Q124 18 136 18H234Q246 18 246 30V88Z", oak),
            .f("M130 88V34Q130 24 140 24H230Q240 24 240 34V88Z", 0x3A2A1E),
        ] + pipes + [
            .s("M124 30Q124 18 136 18H234Q246 18 246 30", 0xC9A15B, 1.6),
            .f("M112 98H258V122H112Z", oak),
            .f("M112 96H258V100H112Z", oakLight),
            .s("M120 104H250V118H120Z", 0x5A3E26, 1),
            .f("M112 122H258V125H112Z", 0x1E1E1C, 0.15),
        ]
    }()

    private nonisolated static let apse: [PalaceMark] = [
        .f("M140 236V158Q140 128 186 128Q232 128 232 158V236Z", 0xE2DCCB),
        .s("M140 236V158Q140 128 186 128Q232 128 232 158V236", 0xC9C2AE, 2),
        .f("M150 206H222V214H150Z", 0xFFFDF6),
        .f("M154 214H218V236H154Z", oak),
    ]

    private nonisolated static let floor: [PalaceMark] = {
        var joints = ""
        for y in stride(from: 270.0, to: 408, by: 22) { joints += "M0 \(y)H370" }
        for (r, y) in stride(from: 256.0, to: 408, by: 22).enumerated() {
            for x in stride(from: Double(r % 2) * 22, to: 370, by: 44) { joints += "M\(x) \(y)V\(y + 22)" }
        }
        return [
            .f("M0 256H370V408H0Z", 0xD9D3C4),
            .s(joints, 0xC4BCA8, 1),
            .f("M162 330H210V400H162Z", 0xC9C1AC),
            .s("M168 340H204M168 348H198", 0xB5AC95, 1),
            .f("M0 256H370V260H0Z", 0x1E1E1C, 0.1),
        ]
    }()

    private nonisolated static let pews: [PalaceMark] = [(4.0, 120.0), (250, 366)].flatMap { span -> [PalaceMark] in
        [264.0, 282].flatMap { y -> [PalaceMark] in
            [
                .f("M\(span.0) \(y)H\(span.1)V\(y + 6)H\(span.0)Z", oakLight),
                .f("M\(span.0) \(y + 6)H\(span.1)V\(y + 14)H\(span.0)Z", oak),
            ]
        }
    }
}
