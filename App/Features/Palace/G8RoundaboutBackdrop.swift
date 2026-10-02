import SwiftUI

/// The roundabout's named slots: a traffic light, someone on the far pavement, a sign at the
/// mouth of an alley and a direction sign at the back; the left entry, the ring and the right
/// road in the middle; a board, people at the kerb, the zebra crossing and a parked car in front.
enum G8Roundabout {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [
        "lightFar": PalaceSlot(frame: CGRect(x: 4, y: 44, width: 44, height: 108), pin: CGPoint(x: 6, y: 18), tilt: -1.5),
        "paveFar": PalaceSlot(frame: CGRect(x: 76, y: 82, width: 104, height: 68), pin: CGPoint(x: 130, y: 56), align: .center, tilt: 1),
        "alley": PalaceSlot(frame: CGRect(x: 224, y: 62, width: 44, height: 90), pin: CGPoint(x: 246, y: 36), align: .center, tilt: 1.5),
        "signFar": PalaceSlot(frame: CGRect(x: 270, y: 48, width: 96, height: 104), pin: CGPoint(x: 366, y: 20), align: .trailing, tilt: -1),
        "entryLeft": PalaceSlot(frame: CGRect(x: 0, y: 156, width: 104, height: 80), pin: CGPoint(x: 6, y: 236), tilt: 1),
        "ring": PalaceSlot(frame: CGRect(x: 104, y: 152, width: 166, height: 84), pin: CGPoint(x: 185, y: 236), align: .center, tilt: -1),
        "roadRight": PalaceSlot(frame: CGRect(x: 272, y: 156, width: 96, height: 80), pin: CGPoint(x: 366, y: 236), align: .trailing, tilt: 1.5),
        "nearLeft": PalaceSlot(frame: CGRect(x: 4, y: 262, width: 82, height: 120), pin: CGPoint(x: 6, y: 382), tilt: -1),
        "kerb": PalaceSlot(frame: CGRect(x: 86, y: 254, width: 48, height: 86), pin: CGPoint(x: 90, y: 344), align: .leading, tilt: 1.5),
        "crossing": PalaceSlot(frame: CGRect(x: 134, y: 250, width: 144, height: 130), pin: CGPoint(x: 210, y: 382), align: .center, tilt: -1.5),
        "nearRight": PalaceSlot(frame: CGRect(x: 282, y: 270, width: 86, height: 112), pin: CGPoint(x: 366, y: 382), align: .trailing, tilt: 1),
    ]
}

/// A roundabout in town: canal houses with an alley between them, a pavement, the main road with
/// red cycle lanes and a ring round a green island, a road coming toward the viewer with a zebra
/// crossing, and pavements in front.
struct G8RoundaboutBackdrop: View, Equatable {
    nonisolated static let scale: CGFloat = 0.42
    nonisolated static let houses: [PalaceWindowHouse] = {
        let street = PalaceOutdoor.street(count: 9, shops: [2, 6])
        return PalaceOutdoor.row(Array(street[0..<6]), scale: scale, baseline: 142, from: -8)
            .filter { $0.x < 226 }
            + PalaceOutdoor.row(Array(street[6..<9]), scale: scale, baseline: 142, from: 264)
    }()

    var body: some View {
        PalaceOutdoorBackdrop(houses: Self.houses, scale: Self.scale, skyHeight: 144,
                              clouds: [CGRect(x: 150, y: 20, width: 46, height: 10), CGRect(x: 60, y: 8, width: 30, height: 8)],
                              marks: Self.marks)
    }

    nonisolated static let marks: [PalaceMark] = alley + pavements + road + ring + frontArm

    private nonisolated static let alley: [PalaceMark] = [
        .f("M224 142V84H266V142Z", 0xD9CDB4),
        .f("M224 84H266V96H224Z", 0x9A5238),
        .f("M240 142L245 98H247L252 142Z", 0x9A968C),
        .f("M224 142L240 142L245 98H224Z M266 142H252L247 98H266Z", 0xC4C0B4),
    ]

    private nonisolated static let pavements: [PalaceMark] = {
        var tiles = ""
        for r in 0..<8 {
            for c in 0..<17 where (r + c) % 2 == 0 { tiles += "M\(c * 23 - 6) \(241 + r * 21)h23v21h-23Z" }
        }
        return [
            .f("M0 140H370V152H0Z", 0xDAD6CA),
            .f("M0 150H370V153H0Z", 0xB4B2A9),
            .f("M0 238H370V408H0Z", 0xDAD6CA),
            .f(tiles, 0xCDC8BA),
            .f("M0 237H370V241H0Z", 0xF4F1EA),
        ]
    }()

    private nonisolated static let road: [PalaceMark] = {
        var dashes = ""
        for x in stride(from: 4.0, to: 90, by: 16) { dashes += "M\(x) 195H\(x + 9)" }
        for x in stride(from: 284.0, to: 370, by: 16) { dashes += "M\(x) 195H\(x + 9)" }
        return [
            .f("M0 153H370V237H0Z", 0x8E8A80),
            .f("M0 153H96V161H0Z M274 153H370V161H274Z M0 229H96V237H0Z M274 229H370V237H274Z", 0xB5574A),
            .s("M0 161H96M274 161H370M0 229H96M274 229H370", 0xFFFDF6, 1, 0.7),
            .s(dashes, 0xFFFDF6, 1.6),
        ]
    }()

    private nonisolated static let ring: [PalaceMark] = {
        var edge = Path()
        edge.addEllipse(in: CGRect(x: 97, y: 157, width: 176, height: 76))
        let dashed = edge.strokedPath(StrokeStyle(lineWidth: 1.6, dash: [7, 6]))
        return [
            PalaceMark(path: dashed, paint: .fill(PalaceInk.hex(0xFFFDF6), evenOdd: false)),
            .oval(135, 176, 100, 40, 0xD3D1C7),
            .oval(138, 178, 94, 36, 0x95B36B),
            .oval(150, 184, 70, 22, 0xA9C47F),
        ] + PalaceOutdoor.tree(185, 202, 12)
    }()

    /// The road toward the viewer (its zebra crossing is a prop, so it can go missing).
    private nonisolated static let frontArm: [PalaceMark] = [
        .f("M150 237H220L246 408H124Z", 0x8E8A80),
        .s("M150 237L124 408M220 237L246 408", 0xF4F1EA, 2),
        .s("M185 244V256M185 344V356M185 368V380M185 392V404", 0xFFFDF6, 1.6),
    ]
}
