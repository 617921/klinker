import SwiftUI

/// The prikbord room: seeded wall and floor, a big cork board in a wooden frame with the place's
/// name sign on top, wainscot, a plank floor and a plant in the corner.
struct PalaceNoticeBackdrop: View, Equatable {
    let sheetNumber: Int
    let placeName: String
    let marks: [PalaceMark]

    static func == (a: Self, b: Self) -> Bool { a.sheetNumber == b.sheetNumber && a.marks.count == b.marks.count }

    var body: some View {
        ZStack(alignment: .topLeading) {
            PalaceArtwork(marks: marks, width: 370, height: 408)
            PalaceDoorSign(name: placeName)
                .frame(width: 180, height: 26)
                .palaceAt(95, 18)
        }
        .frame(width: 370, height: 408, alignment: .topLeading)
        .accessibilityHidden(true)
    }

    // MARK: Drawing

    static func marks(_ style: PalaceRoomStyle) -> [PalaceMark] {
        wall(style) + board(style) + floor(style) + plant(onRight: style.noorLeft)
    }

    private static func wall(_ s: PalaceRoomStyle) -> [PalaceMark] {
        var dentils = ""
        for x in stride(from: 4, to: 370, by: 10) { dentils += "M\(x) 17h5v4h-5Z" }
        var panels = ""
        for k in 0..<7 { panels += "M\(8 + k * 54) 261h44v30h-44Z" }
        return [
            .f("M0 0H370V300H0Z", s.wall),
            .f("M0 0H370V14H0Z", 0xD9CDB4),
            .f("M0 14H370V17H0Z", 0xEFEBE2),
            .f(dentils, 0xD9CDB4),
            .f("M0 24H370V26H0Z", PalaceInk.shade(s.wall, 0.9)),
            .f("M0 252H370V300H0Z", s.panel),
            .f("M0 249H370V254H0Z", 0x4A3524),
            .f(panels, PalaceInk.shade(s.panel, 0.86)),
            .s(panels, PalaceInk.shade(s.panel, 1.18), 1),
            .f("M0 296H370V301H0Z", 0x4A3524),
        ]
    }

    private static func board(_ s: PalaceRoomStyle) -> [PalaceMark] {
        var rnd = PalaceRandom(seed: Int(s.wall & 0xFFFF) &+ 11)
        var dark = "", light = ""
        for _ in 0..<170 {
            let x = 23 + rnd.next() * 323, y = 39 + rnd.next() * 197
            let d = String(format: "M%.1f %.1fh1.4v1.4h-1.4Z", x, y)
            if rnd.next() < 0.6 { dark += d } else { light += d }
        }
        return [
            .f("M18 35H360V251H18Z", 0x1E1E1C, 0.14),
            .f("M14 30H356V246H14Z", 0x7A5230),
            .f("M18 34H352V242H18Z", 0x4A3524),
            .f("M21 37H349V239H21Z", 0xC9965F),
            .f(dark, 0xA8784A, 0.55),
            .f(light, 0xE0B886, 0.6),
            .s("M14.5 30.5H355.5V245.5H14.5Z", 0x9A6A42, 1),
        ]
    }

    private static func floor(_ s: PalaceRoomStyle) -> [PalaceMark] {
        var rnd = PalaceRandom(seed: Int(s.floor & 0xFFFF) &+ Int(s.wall & 0xFF))
        var light = "", joints = "", seams = ""
        let rowH = 13.0
        for row in 0..<9 {
            let y = 301 + Double(row) * rowH
            if row % 2 == 1 { light += "M0 \(y)H370V\(y + rowH)H0Z" }
            if row > 0 { seams += "M0 \(y)H370" }
            var x = -rnd.next() * 90
            while x < 370 {
                x += 70 + rnd.next() * 60
                if x > 0 && x < 370 { joints += String(format: "M%.1f %.1fV%.1f", x, y, y + rowH) }
            }
        }
        return [
            .f("M0 301H370V408H0Z", s.floor),
            .f(light, PalaceInk.shade(s.floor, 1.06)),
            .s(seams, PalaceInk.shade(s.floor, 0.78), 1),
            .s(joints, PalaceInk.shade(s.floor, 0.78), 1),
            .f("M0 301H370V305H0Z", 0x1E1E1C, 0.08),
        ]
    }

    /// A potted plant in the corner Noor doesn't stand in.
    private static func plant(onRight: Bool) -> [PalaceMark] {
        let marks: [PalaceMark] = [
            .f("M38 362C30 346 18 334 12 308C28 318 38 338 38 362Z", 0x5E8C45),
            .f("M43 362C31 342 31 320 41 300C47 322 49 342 43 362Z", 0x4E7A3A),
            .f("M47 362C49 340 57 324 69 314C65 336 57 350 47 362Z", 0x6E9C52),
            .f("M27 366H59L55 402H31Z", 0xA3410A),
            .f("M24 360H62V368H24Z", 0x8A3B12),
            .f("M28 402H58V405H28Z", 0x1E1E1C, 0.12),
        ]
        guard onRight else { return marks }
        let flip = CGAffineTransform(a: -1, b: 0, c: 0, d: 1, tx: 370, ty: 0)
        return marks.map { m in
            var mark = m
            mark.path = m.path.applying(flip)
            return mark
        }
    }
}

/// The black sign with the place's name ("BAKKER", "STATION").
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
            .overlay(Rectangle().stroke(PalaceInk.hex(0xC9A15B), lineWidth: 1).padding(3))
            .frame(maxWidth: .infinity)
            .accessibilityHidden(true)
    }
}
