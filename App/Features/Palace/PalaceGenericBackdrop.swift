import SwiftUI

/// The generic room's walls, floor, tall canal window, door and the sign with the place's name.
struct PalaceGenericBackdrop: View, Equatable {
    let sheetNumber: Int
    let style: PalaceRoomStyle
    let placeName: String
    let window: [PalaceWindowHouse]
    let marks: [PalaceMark]

    static func == (a: Self, b: Self) -> Bool { a.sheetNumber == b.sheetNumber && a.marks.count == b.marks.count }

    private var windowX: CGFloat { style.mirrored ? 370 - 96 : 12 }
    private var doorX: CGFloat { style.mirrored ? 370 - PalaceGenericRoom.doorX : PalaceGenericRoom.doorX }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Ink.hex(style.wall)
            PalaceCanalWindow(houses: window).palaceAt(windowX, 40)
            PalaceArtwork(marks: marks, width: 370, height: 408)
            PalaceDoorSign(name: placeName)
                .frame(width: 180, height: 26)
                .palaceAt(doorX - 90, 62)
        }
        .frame(width: 370, height: 408, alignment: .topLeading)
        .accessibilityHidden(true)
    }

    // MARK: Drawing

    static func marks(_ style: PalaceRoomStyle) -> [PalaceMark] {
        var list: [PalaceMark] = []
        list += wallMarks(style)
        list += windowMarks(style)
        list += doorMarks(style)
        list += floorMarks(style)
        guard style.mirrored else { return list }
        let flip = CGAffineTransform(a: -1, b: 0, c: 0, d: 1, tx: 370, ty: 0)
        return list.map { m in
            var mark = m
            mark.path = m.path.applying(flip)
            return mark
        }
    }

    private static func wallMarks(_ s: PalaceRoomStyle) -> [PalaceMark] {
        var dentils = ""
        for x in stride(from: 4, to: 370, by: 10) { dentils += "M\(x) 17h5v4h-5Z" }
        var panels = ""
        for k in 0..<7 { panels += "M\(8 + k * 54) 261h44v30h-44Z" }
        return [
            .f("M0 0H370V14H0Z", 0xD9CDB4),
            .f("M0 14H370V17H0Z", 0xEFEBE2),
            .f(dentils, 0xD9CDB4),
            .f("M0 24H370V26H0Z", Ink.shade(s.wall, 0.9)),
            // Wainscot and skirting
            .f("M0 252H370V300H0Z", s.panel),
            .f("M0 249H370V254H0Z", 0x4A3524),
            .f(panels, Ink.shade(s.panel, 0.86)),
            .s(panels, Ink.shade(s.panel, 1.18), 1),
            .f("M0 296H370V301H0Z", 0x4A3524),
            // Wall shelf with brackets
            .f("M110 150H264V156H110Z", 0x7A5230),
            .f("M110 156H264V158H110Z", 0x4A3524),
            .f("M124 158h4v10h-4Z M246 158h4v10h-4Z", 0x4A3524),
        ]
    }

    private static func windowMarks(_ s: PalaceRoomStyle) -> [PalaceMark] {
        [
            .eo("M12 40H96V220H12Z M12 220V59A19 19 0 0 1 50 59V220Z M58 220V59A19 19 0 0 1 96 59V220Z", s.wall),
            .s("M12 220V59A19 19 0 0 1 50 59V220Z M58 220V59A19 19 0 0 1 96 59V220Z", 0xEFEBE2, 3),
            .s("M31 42V220M77 42V220M12 100H50M12 160H50M58 100H96M58 160H96", 0xEFEBE2, 2),
            .f("M6 219H102V226H6Z", 0xEFEBE2),
            .f("M8 226H100V229H8Z", 0xD9CDB4),
        ]
    }

    private static func doorMarks(_ s: PalaceRoomStyle) -> [PalaceMark] {
        let lower = Ink.shade(s.door, 0.8)
        return [
            .f("M266 92H338V300H266Z", 0xEFEBE2),
            .f("M272 98H332V300H272Z", s.door),
            .f("M278 106H299V160H278Z M305 106H326V160H305Z", 0x3E4C55),
            .f("M280 152L291 108H295L284 152Z M307 152L318 108H322L311 152Z", 0xFFFFFF, 0.18),
            .f("M278 214H299V290H278Z M305 214H326V290H305Z", lower),
            .f("M290 188H314V192H290Z", 0xC9A15B),
            .dot(322, 204, 2.6, 0xC9A15B),
            .f("M262 297H342V302H262Z", 0x4A3524),
        ]
    }

    private static func floorMarks(_ s: PalaceRoomStyle) -> [PalaceMark] {
        var rnd = GevelRandom(seed: Int(s.floor & 0xFFFF) &+ Int(s.wall & 0xFF))
        var light = "", joints = ""
        let rowH = 13.0
        for row in 0..<9 {
            let y = 301 + Double(row) * rowH
            if row % 2 == 1 { light += "M0 \(y)H370V\(y + rowH)H0Z" }
            var x = -rnd.next() * 90
            while x < 370 {
                x += 70 + rnd.next() * 60
                if x > 0 && x < 370 { joints += String(format: "M%.1f %.1fV%.1f", x, y, y + rowH) }
            }
        }
        var seams = ""
        for row in 1..<9 { seams += "M0 \(301 + Double(row) * rowH)H370" }
        return [
            .f("M0 301H370V408H0Z", s.floor),
            .f(light, Ink.shade(s.floor, 1.06)),
            .s(seams, Ink.shade(s.floor, 0.78), 1),
            .s(joints, Ink.shade(s.floor, 0.78), 1),
            .f("M0 301H370V305H0Z", 0x1E1E1C, 0.08),
        ]
    }
}

/// The black sign above the door with the place's name ("BAKKER", "STATION").
struct PalaceDoorSign: View {
    let name: String

    var body: some View {
        Text(name.uppercased())
            .font(.custom("AvenirNext-Heavy", fixedSize: 12))
            .tracking(0.6)
            .foregroundStyle(Theme.onInk)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .padding(.horizontal, 11)
            .frame(height: 24)
            .background(Theme.ink)
            .overlay(Rectangle().stroke(Ink.hex(0xC9A15B), lineWidth: 1).padding(3))
            .frame(maxWidth: .infinity)
            .accessibilityHidden(true)
    }
}
