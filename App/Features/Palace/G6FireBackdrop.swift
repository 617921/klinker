import SwiftUI

/// The fire station's named slots: a sign on the station, the bay ceiling over the red truck, the
/// hose tower and its door, the canal house across (roof, ladder window, ground-floor window), the
/// road and three spots on the near pavement.
enum G6FireRoom {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [
        "facade": PalaceSlot(frame: CGRect(x: 16, y: 42, width: 118, height: 44), pin: CGPoint(x: 75, y: 80), align: .center, tilt: -1.5),
        "bayCeiling": PalaceSlot(frame: CGRect(x: 52, y: 98, width: 78, height: 44), pin: CGPoint(x: 92, y: 134), align: .center, tilt: 1.5),
        "tower": PalaceSlot(frame: CGRect(x: 148, y: 62, width: 48, height: 60), pin: CGPoint(x: 198, y: 112), align: .trailing, tilt: -1),
        "towerDoor": PalaceSlot(frame: CGRect(x: 148, y: 140, width: 50, height: 46), pin: CGPoint(x: 198, y: 178), align: .trailing, tilt: 1.5),
        "roof": PalaceSlot(frame: CGRect(x: 214, y: 0, width: 152, height: 122), pin: CGPoint(x: 290, y: 96), align: .center, tilt: -1),
        "ladder": PalaceSlot(frame: CGRect(x: 248, y: 120, width: 118, height: 146), pin: CGPoint(x: 366, y: 196), align: .trailing, tilt: 1.5),
        "groundWindow": PalaceSlot(frame: CGRect(x: 220, y: 194, width: 60, height: 66), pin: CGPoint(x: 250, y: 250), align: .center, tilt: -2),
        "street": PalaceSlot(frame: CGRect(x: 100, y: 268, width: 150, height: 58), pin: CGPoint(x: 175, y: 318), align: .center, tilt: 1),
        "nearLeft": PalaceSlot(frame: CGRect(x: 4, y: 318, width: 62, height: 86), pin: CGPoint(x: 6, y: 378), tilt: -1.5),
        "nearMid": PalaceSlot(frame: CGRect(x: 70, y: 302, width: 70, height: 102), pin: CGPoint(x: 112, y: 378), align: .center, tilt: 1.5),
        "nearRight": PalaceSlot(frame: CGRect(x: 222, y: 292, width: 144, height: 112), pin: CGPoint(x: 366, y: 378), align: .trailing, tilt: -1),
    ]
}

/// A street: the brick fire station with a hose tower and a red fire truck in its open bay on the
/// left, a canal house across on the right, the road and the near pavement.
struct G6FireBackdrop: View, Equatable {
    var body: some View {
        Canvas { ctx, _ in
            PalaceOutdoor.paintSky(&ctx, height: 268, clouds: [CGRect(x: 18, y: 14, width: 40, height: 9)])
            PalaceMark.draw(Self.marks, in: &ctx)
        }
        .frame(width: 370, height: 408)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = station + truck + house + ground

    private nonisolated static let station: [PalaceMark] = {
        var bricks = ""
        for y in stride(from: 46.0, to: 268, by: 8) { bricks += "M0 \(y)H198" }
        return [
            .f("M0 34H148V268H0Z", 0x9A3B2C),
            .f("M146 6H198V268H146Z", 0x86342A),
            .s(bricks, 0x7A2A20, 0.6, 0.5),
            .f("M0 30H150V38H0Z", 0xC9A15B),
            .f("M142 2H202V10H142Z", 0xC9A15B),
            .f("M162 22H182V40H162Z", 0x2E2A26),
            .f("M162 22H182V40H162Z", 0x6FA3C7, 0.4),
            .f("M156 186H188V268H156Z", 0x24533F),
            .f("M161 194H183V214H161Z", 0xBFD9E6, 0.7),
            .dot(183, 232, 1.8, 0xC9A15B),
            .f("M150 182H194V188H150Z", 0x7A2A20),
            // the bay
            .f("M10 268V112Q10 94 30 94H116Q136 94 136 112V268Z", 0x2E2A26),
            .f("M14 100H132V106H14Z", 0x3E3A36),
            .s("M10 268V112Q10 94 30 94H116Q136 94 136 112V268", 0xC9A15B, 3),
        ]
    }()

    /// The fire truck, seen from the front, nose out of the bay.
    private nonisolated static let truck: [PalaceMark] = {
        var rungs = ""
        for x in stride(from: 26.0, to: 124, by: 8) { rungs += "M\(x) 136V144" }
        return [
            .f("M22 134H124V138H22Z M22 142H124V146H22Z", 0xB4B2A9),
            .s(rungs, 0xB4B2A9, 1.4),
            .f("M26 150Q26 146 32 146H114Q120 146 120 150V258H26Z", 0xC8261B),
            .f("M30 142H44V150H30Z M102 142H116V150H102Z", 0x2F5BD3),
            .f("M34 158H71V194H34Z M75 158H112V194H75Z", 0xBFD9E6),
            .f("M36 192L52 160H58L42 192Z M77 192L93 160H99L83 192Z", 0xFFFFFF, 0.35),
            .f("M26 200H120V206H26Z", 0xFFFDF6),
            .f("M48 214H98V238H48Z", 0x9A1E15),
            .s("M50 220H96M50 226H96M50 232H96", 0x7A1510, 1.2),
            .dot(38, 226, 6, 0xFFFDF6),
            .dot(108, 226, 6, 0xFFFDF6),
            .f("M22 244H124V252H22Z", 0xD3D1C7),
            .f("M28 252H46V268H28Z M100 252H118V268H100Z", 0x1E1E1C),
            .f("M18 166H26V184H18Z M120 166H128V184H120Z", 0x1E1E1C),
        ]
    }()

    /// A cream canal house with a bell gable (its windows are where the fire props go).
    private nonisolated static let house: [PalaceMark] = [
        .f("M214 62H366V264H214Z", 0xD9CDB4),
        .f("M246 62V40Q246 22 262 18Q272 6 290 6Q308 6 318 18Q334 22 334 40V62Z", 0xD9CDB4),
        .f("M214 58H366V64H214Z", 0xC9BB9C),
        .f("M276 28H304V54H276Z", 0x3E4C55),
        .f("M230 76H262V114H230Z M318 76H350V114H318Z M230 142H262V182H230Z M318 142H350V182H318Z", 0x3E4C55),
        .s("M246 76V114M334 76V114M246 142V182M334 142V182M290 28V54", 0xEFE4CF, 2),
        .f("M226 114H266V118H226Z M314 114H354V118H314Z M226 182H266V186H226Z M314 182H354V186H314Z", 0xEFE4CF),
        .f("M226 200H274V252H226Z", 0x3E4C55),
        .f("M316 194H350V264H316Z", 0x7A1E1E),
        .f("M322 200H344V222H322Z", 0xBFD9E6, 0.6),
        .f("M310 258H356V264H310Z", 0xA19E95),
    ]

    private nonisolated static let ground: [PalaceMark] = {
        var lines = ""
        for x in stride(from: 10.0, to: 370, by: 52) { lines += "M\(x) 299H\(x + 26)V302H\(x)Z" }
        return [
            .f("M0 264H370V272H0Z", 0xA19E95),
            .f("M0 272H370V328H0Z", 0x6E6B64),
            .f(lines, 0xF4F1EA, 0.8),
            .f("M0 328H370V334H0Z", 0xD3D1C7),
        ] + PalaceOutdoor.cobbles(top: 334, bottom: 408, base: 0xCFC8B8, stone: 0xBDB4A0)
    }()
}
