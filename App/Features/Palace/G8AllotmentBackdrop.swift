import SwiftUI

/// The allotment's named slots in three bands: a shed, a greenhouse and the clubhouse at the
/// back; a plot, a weedy bed, a gardener and a path being laid in the middle; and four things on
/// the near bed (sowing, the soil, seeds, good and poor ground).
enum G8Allotment {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [
        "shed": PalaceSlot(frame: CGRect(x: 4, y: 70, width: 106, height: 110), pin: CGPoint(x: 8, y: 168), tilt: -1.5),
        "glass": PalaceSlot(frame: CGRect(x: 116, y: 92, width: 112, height: 88), pin: CGPoint(x: 172, y: 170), align: .center, tilt: 1.5),
        "club": PalaceSlot(frame: CGRect(x: 236, y: 22, width: 130, height: 160), pin: CGPoint(x: 366, y: 168), align: .trailing, tilt: -1),
        "plot": PalaceSlot(frame: CGRect(x: 4, y: 194, width: 118, height: 84), pin: CGPoint(x: 6, y: 274), tilt: 1),
        "weeds": PalaceSlot(frame: CGRect(x: 124, y: 206, width: 80, height: 64), pin: CGPoint(x: 166, y: 274), align: .center, tilt: -1.5),
        "gardener": PalaceSlot(frame: CGRect(x: 204, y: 174, width: 68, height: 112), pin: CGPoint(x: 238, y: 246), align: .center, tilt: 1.5),
        "path": PalaceSlot(frame: CGRect(x: 274, y: 200, width: 92, height: 74), pin: CGPoint(x: 366, y: 276), align: .trailing, tilt: -1),
        "sow": PalaceSlot(frame: CGRect(x: 4, y: 298, width: 88, height: 84), pin: CGPoint(x: 6, y: 380), tilt: -1),
        "soil": PalaceSlot(frame: CGRect(x: 98, y: 298, width: 76, height: 84), pin: CGPoint(x: 135, y: 382), align: .center, tilt: 1.5),
        "seed": PalaceSlot(frame: CGRect(x: 180, y: 298, width: 64, height: 84), pin: CGPoint(x: 212, y: 380), align: .center, tilt: -1.5),
        "ground": PalaceSlot(frame: CGRect(x: 250, y: 304, width: 116, height: 76), pin: CGPoint(x: 366, y: 380), align: .trailing, tilt: 1),
    ]
}

/// Allotment gardens at the edge of town: the city small in the distance behind a hedge,
/// grass paths between brown beds with rows of plants.
struct G8AllotmentBackdrop: View, Equatable {
    nonisolated static let scale: CGFloat = 0.26
    nonisolated static let houses = PalaceOutdoor.row(PalaceOutdoor.street(count: 18, floors: [3, 4, 2, 3]), scale: scale, baseline: 110)

    var body: some View {
        PalaceOutdoorBackdrop(houses: Self.houses, scale: Self.scale, skyHeight: 120,
                              clouds: [CGRect(x: 70, y: 18, width: 50, height: 11), CGRect(x: 186, y: 38, width: 34, height: 8)],
                              marks: Self.marks)
    }

    nonisolated static let marks: [PalaceMark] = hedge + ground + beds

    private nonisolated static let hedge: [PalaceMark] = {
        var dark = "", light = ""
        for (i, x) in stride(from: -8.0, to: 390, by: 20).enumerated() {
            let r = 12.0 + Double((i * 7) % 5) * 1.6
            let y = 116.0 - Double((i * 5) % 3) * 3
            let circle = "M\(x - r) \(y)a\(r) \(r) 0 1 0 \(2 * r) 0a\(r) \(r) 0 1 0 \(-2 * r) 0Z"
            if i % 2 == 0 { dark += circle } else { light += circle }
        }
        return [.f(light, 0x6E9C52), .f(dark, 0x5E8C45), .f("M0 118H370V128H0Z", 0x4E7A3A)]
    }()

    private nonisolated static let ground: [PalaceMark] = {
        var tufts = ""
        for (x, y) in [(110.0, 196.0), (230, 190), (128, 286), (250, 292), (178, 290), (96, 404), (244, 404), (20, 286)] as [(Double, Double)] {
            tufts += "M\(x) \(y)l2 -5l2 5l2 -6l2 6"
        }
        return [
            .f("M0 126H370V408H0Z", 0xA9C47F),
            .f("M0 126H370V136H0Z", 0x95B36B),
            .s(tufts, 0x7FA650, 1.4, round: true),
        ]
    }()

    /// Long beds of brown soil with rows of little plants: one behind the sheds, one across the
    /// middle and the near one the front props stand on.
    private nonisolated static let beds: [PalaceMark] = {
        func bed(_ top: Double, _ bottom: Double, inset: Double) -> [PalaceMark] {
            var rows = "", plants = ""
            let h = bottom - top
            for k in 1..<4 {
                let y = top + h * Double(k) / 4
                rows += "M\(inset + 4) \(y)H\(370 - inset - 4)"
                for x in stride(from: inset + 10 + Double(k % 2) * 6, to: 366 - inset, by: 12 + Double(k) * 2) {
                    let r = 1.6 + Double(k) * 0.5
                    plants += "M\(x - r) \(y - 1)a\(r) \(r) 0 1 0 \(2 * r) 0a\(r) \(r) 0 1 0 \(-2 * r) 0Z"
                }
            }
            return [
                .f("M\(inset) \(top)H\(370 - inset)L\(374 - inset * 0.5) \(bottom)H\(-4 + inset * 0.5)Z", 0x8C5E38),
                .s(rows, 0x6B4A2E, 1.2),
                .f(plants, 0x6E9C52),
            ]
        }
        return bed(140, 160, inset: 2) + bed(176, 196, inset: -4) + bed(280, 300, inset: -8)
            + [.f("M-8 300H378V306H-8Z", 0x1E1E1C, 0.08)]
    }()
}
