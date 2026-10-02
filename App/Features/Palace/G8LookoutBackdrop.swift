import SwiftUI

/// The lookout's named slots: two things in the sky (over Noor and on the right), four along the
/// railing on either side of Noor, and five on the platform in front.
enum G8Lookout {
    static let noor: CGPoint? = CGPoint(x: 140, y: 126)

    nonisolated static let slots: [String: PalaceSlot] = [
        "skyLeft": PalaceSlot(frame: CGRect(x: 104, y: 16, width: 112, height: 88), pin: CGPoint(x: 100, y: 22), align: .trailing, tilt: -1.5),
        "skyRight": PalaceSlot(frame: CGRect(x: 230, y: 18, width: 136, height: 98), pin: CGPoint(x: 366, y: 2), align: .trailing, tilt: 1),
        "railFarLeft": PalaceSlot(frame: CGRect(x: 2, y: 110, width: 58, height: 122), pin: CGPoint(x: 4, y: 232), tilt: 1.5),
        "railLeft": PalaceSlot(frame: CGRect(x: 62, y: 128, width: 72, height: 100), pin: CGPoint(x: 96, y: 98), align: .center, tilt: -1),
        "railRight": PalaceSlot(frame: CGRect(x: 188, y: 128, width: 80, height: 104), pin: CGPoint(x: 228, y: 232), align: .center, tilt: 1),
        "railFarRight": PalaceSlot(frame: CGRect(x: 272, y: 124, width: 94, height: 108), pin: CGPoint(x: 366, y: 232), align: .trailing, tilt: -1.5),
        "deckLeft": PalaceSlot(frame: CGRect(x: 2, y: 266, width: 92, height: 116), pin: CGPoint(x: 4, y: 382), tilt: -1),
        "deckMidLeft": PalaceSlot(frame: CGRect(x: 96, y: 278, width: 70, height: 104), pin: CGPoint(x: 130, y: 260), align: .center, tilt: 1.5),
        "deckMid": PalaceSlot(frame: CGRect(x: 168, y: 268, width: 62, height: 114), pin: CGPoint(x: 199, y: 382), align: .center, tilt: -1.5),
        "deckMidRight": PalaceSlot(frame: CGRect(x: 232, y: 280, width: 84, height: 102), pin: CGPoint(x: 274, y: 382), align: .center, tilt: 1),
        "deckRight": PalaceSlot(frame: CGRect(x: 312, y: 250, width: 56, height: 132), pin: CGPoint(x: 366, y: 352), align: .trailing, tilt: -1),
    ]
}

/// The top of the lookout tower at the end of the course: the whole city below (its canals, the
/// station, the town hall, a church, a mill, the river with the ferry, the harbour cranes), a
/// railing hung with bunting and a plank floor.
struct G8LookoutBackdrop: View, Equatable {
    nonisolated static let farScale: CGFloat = 0.17
    nonisolated static let nearScale: CGFloat = 0.24
    nonisolated static let far = PalaceOutdoor.row(PalaceOutdoor.street(count: 30, floors: [3, 2, 4, 3]), scale: farScale, baseline: 168, from: -4)
    nonisolated static let near = PalaceOutdoor.row(PalaceOutdoor.street(count: 26, floors: [4, 3, 3, 2], shops: [3, 9, 15]), scale: nearScale, baseline: 206, from: -10)

    var body: some View {
        Canvas { ctx, _ in
            PalaceOutdoor.paintSky(&ctx, height: 236, clouds: [CGRect(x: 30, y: 60, width: 44, height: 10), CGRect(x: 210, y: 118, width: 36, height: 8)])
            PalaceMark.draw(Self.horizon, in: &ctx)
            PalaceOutdoor.paintHouses(Self.far, scale: Self.farScale, in: &ctx)
            PalaceMark.draw(Self.middle, in: &ctx)
            PalaceOutdoor.paintHouses(Self.near, scale: Self.nearScale, in: &ctx)
            PalaceMark.draw(Self.platform, in: &ctx)
        }
        .frame(width: 370, height: 408)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    /// The far edge of town: the river with the ferry, the dike, the mill and the cranes.
    nonisolated static let horizon: [PalaceMark] = [
        .f("M0 118H370V150H0Z", 0xF6E3BE, 0.45),
        .f("M0 136Q90 130 190 134T370 132V146H0Z", 0x8FB6CF),
        .s("M40 140H52M120 138H130M250 139H262", 0xFFFDF6, 1),
        .f("M206 134H226L224 138H208Z", 0x1F3A6B), .f("M213 129H219V134H213Z", 0xFFFDF6),
        .f("M0 134Q40 124 80 130V136H0Z", 0x7FA650),
        .f("M56 130V114L59 110L62 114V130Z", 0x6B4A2E),
        .s("M59 113L51 105M59 113L67 121M59 113L67 105M59 113L51 121", 0x3E4C55, 1.4),
        .s("M330 132V100M330 102H312M316 102V110M352 132V108M352 110H340", 0x5E6B73, 1.8),
        .f("M0 146H370V172H0Z", 0x9A968C, 0.25),
    ]

    /// Between the two rows of houses: a canal, the station's arched roof, the town hall, a church.
    nonisolated static let middle: [PalaceMark] = [
        .f("M0 168Q120 176 200 170T370 172V180Q250 178 190 182T0 178Z", 0x8FB6CF),
        .f("M20 168V150H70V168Z", 0xD9CDB4), .f("M18 152Q45 132 72 152Z", 0x5E6B73),
        .s("M24 152V168M32 148V168M40 145V168M48 145V168M56 147V168M64 151V168", 0x7D8A92, 0.8),
        .f("M262 168V150H296V168Z", 0xE3D6BC), .f("M258 151L279 140L300 151Z", 0xEFE6D2),
        .s("M268 153V168M276 153V168M284 153V168M292 153V168", 0xD9CDB4, 1),
        .f("M150 168V134L156 112L162 134V168Z", 0xC9A15B), .f("M154 112L156 104L158 112Z", 0x5E6B73),
    ]

    /// The railing with bunting and the plank floor of the platform.
    nonisolated static let platform: [PalaceMark] = {
        var posts = "", planks = ""
        for x in stride(from: 4.0, to: 370, by: 30) { posts += "M\(x) 214H\(x + 4)V242H\(x)Z" }
        for (i, y) in stride(from: 246.0, to: 408, by: 14).enumerated() { planks += "M0 \(y + Double(i) * 1.5)H370" }
        return [
            .f("M0 238H370V408H0Z", 0xC9965F),
            .s(planks, 0x9A6A42, 1.2),
            .f("M0 238H370V244H0Z", 0x1E1E1C, 0.12),
            .f(posts, 0x7A5230),
            .f("M0 226H370V230H0Z", 0x7A5230),
            .f("M0 210H370V216H0Z", 0x9A6A42),
            .f("M0 210H370V211.5H0Z", 0xC9965F),
        ] + PalaceOutdoor.bunting(-6, 186, 216, sag: 5) + PalaceOutdoor.bunting(184, 376, 216, sag: 5)
    }()
}
