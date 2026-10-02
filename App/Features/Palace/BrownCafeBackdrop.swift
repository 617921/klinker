import SwiftUI

/// The brown café's named slots: the front window (a view outside), two spots on the back-bar
/// shelves, a stool and three spots on the bar, and four floor spots.
enum BrownCafe {
    static let noor = CGPoint(x: 214, y: 292)

    nonisolated static let slots: [String: PalaceSlot] = [
        "window": PalaceSlot(frame: CGRect(x: 8, y: 24, width: 112, height: 184), pin: CGPoint(x: 16, y: 196), tilt: -1.5),
        "shelfLeft": PalaceSlot(frame: CGRect(x: 140, y: 26, width: 54, height: 74), pin: CGPoint(x: 140, y: 104), tilt: 1.5),
        "shelfRight": PalaceSlot(frame: CGRect(x: 200, y: 24, width: 96, height: 100), pin: CGPoint(x: 296, y: 128), align: .trailing, tilt: -1.5),
        "barStool": PalaceSlot(frame: CGRect(x: 126, y: 182, width: 66, height: 120), pin: CGPoint(x: 128, y: 276), tilt: 1.5),
        "barLeft": PalaceSlot(frame: CGRect(x: 196, y: 148, width: 66, height: 62), pin: CGPoint(x: 198, y: 214), tilt: -1),
        "barMid": PalaceSlot(frame: CGRect(x: 266, y: 152, width: 46, height: 58), pin: CGPoint(x: 289, y: 244), align: .center, tilt: 2),
        "barRight": PalaceSlot(frame: CGRect(x: 318, y: 152, width: 48, height: 58), pin: CGPoint(x: 366, y: 214), align: .trailing, tilt: 1.5),
        "tableLeft": PalaceSlot(frame: CGRect(x: 2, y: 290, width: 122, height: 112), pin: CGPoint(x: 62, y: 382), align: .center, tilt: -1.5),
        "highTable": PalaceSlot(frame: CGRect(x: 126, y: 302, width: 82, height: 102), pin: CGPoint(x: 167, y: 382), align: .center, tilt: 1),
        "floorRight": PalaceSlot(frame: CGRect(x: 208, y: 298, width: 94, height: 86), pin: CGPoint(x: 254, y: 382), align: .center, tilt: -1),
        "standing": PalaceSlot(frame: CGRect(x: 304, y: 282, width: 64, height: 120), pin: CGPoint(x: 368, y: 272), align: .trailing, tilt: 2),
    ]
}

/// A brown café: smoky ochre walls, a dark beamed ceiling, the front window, a back bar with
/// shelves and a mirror, the long wooden bar with its brass foot rail, a dark plank floor.
struct BrownCafeBackdrop: View, Equatable {
    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            .frame(width: 370, height: 408, alignment: .topLeading)
            .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = {
        var beams = "", panels = "", barPanels = "", planks = "", glasses = ""
        for x in stride(from: 6.0, to: 370, by: 30) { beams += "M\(x) 0H\(x + 12)V16H\(x)Z" }
        for x in stride(from: 8.0, to: 120, by: 38) { panels += "M\(x) 226H\(x + 30)V290H\(x)Z" }
        for x in stride(from: 134.0, to: 370, by: 48) { barPanels += "M\(x) 226H\(x + 38)V284H\(x)Z" }
        for (r, y) in [320.0, 344, 372].enumerated() {
            planks += "M0 \(y)H370"
            var x = Double(r % 2) * 40 + 24
            while x < 370 {
                planks += "M\(x) \(y)V\(r == 0 ? 300 : [320.0, 344][r - 1])"
                x += 80
            }
        }
        for x in stride(from: 142.0, to: 290, by: 18) {
            glasses += "M\(x) 150H\(x + 9)L\(x + 6) 142V136H\(x + 9)Q\(x + 9) 128 \(x + 4.5) 128Q\(x) 128 \(x) 136H\(x + 3)V142Z"
        }
        return [
            .f("M0 0H370V300H0Z", 0xC9A46A),
            .f("M0 18H370V40H0Z", 0x8A6A3E, 0.22),
            .f("M0 0H370V18H0Z", 0x3A2A1E),
            .f(beams, 0x2A1E15),
            .f("M0 16H370V21H0Z", 0x2A1E15),
            // Front window reveal and the panelling under it
            .f("M4 20H124V212H4Z", 0x4A3524),
            .f("M0 214H126V300H0Z", 0x6B4A2E),
            .f(panels, 0x7A5230),
            .f("M0 210H126V216H0Z", 0x4A3524),
            // Back bar: posts, dark panel, shelves, glasses, mirror
            .f("M134 22H300V206H134Z", 0x5A3A24),
            .f("M128 22H134V206H128Z M298 22H304V206H298Z", 0x3A2A1E),
            .f("M134 98H198V104H134Z", 0x7A5230),
            .f("M134 152H298V158H134Z", 0x7A5230),
            .f(glasses, 0xE2DED3, 0.55),
            .f("M304 30H368V156H304Z", 0x3A2A1E),
            .f("M308 34H364V152H308Z", 0x9FB3BC),
            .f("M316 34H330L308 70V50Z M340 34H346L308 100V90Z", 0xFFFFFF, 0.25),
            .f("M304 152H370V158H304Z", 0x7A5230),
            // Bar
            .f("M124 202H370V210H124Z", 0x8C5E38),
            .f("M124 210H370V216H124Z", 0x4A3524),
            .f("M126 216H370V300H126Z", 0x5A3A24),
            .f(barPanels, 0x6B4A2E),
            .s("M126 292H370", 0xC9A15B, 3),
            .s("M140 292V300M220 292V300M300 292V300", 0x8C6A2E, 2),
            // Floor
            .f("M0 300H370V408H0Z", 0x7A5230),
            .s(planks, 0x5E3E26, 1.4),
            .f("M0 300H370V305H0Z", 0x1E1E1C, 0.18),
        ]
    }()
}
