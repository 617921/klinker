import SwiftUI

/// People at work, each with the thing that shows what they do. Standing figures share
/// `G5Body`'s build (64 × 114) inside a wider drawing; `variant` picks the look.
enum G5Makers {
    typealias Look = PalaceFigures.Look

    /// `accessory`: "roller" (a painter rolling fresh paint up a wall, a tray at the feet), "diy"
    /// (overalls and a cap, a plank on the shoulder, a toolbox, a hammer in the belt), "handy" (a
    /// thumbs-up and a screwdriver beside `icons` things that are fixed, each ticked), "singer"
    /// (in a spotlight, a microphone at the mouth, notes), "director" (in a director's chair with a
    /// megaphone, a clapperboard), "painter" (beret, palette and brush at an easel with a painting),
    /// "minister" (in a black gown and white bands high in a carved pulpit, a hand raised, candles).
    /// `tone` the main colour (paint, dress, gown).
    static func maker(_ pen: PropPen, _ p: PalacePropParams) {
        let v = Look.at(p.variant ?? 0)
        switch p.accessory ?? "diy" {
        case "roller": roller(pen.fitted(CGSize(width: 96, height: 124)), v, PropColor.named(p.tone, 0x6FA3C7))
        case "handy": handy(pen.fitted(CGSize(width: 96, height: 124)), v, p.icons ?? [])
        case "singer": singer(pen.fitted(CGSize(width: 90, height: 130)), v, PropColor.named(p.tone, 0x993556))
        case "director": director(pen.fitted(CGSize(width: 96, height: 112)), v)
        case "painter": painter(pen.fitted(CGSize(width: 100, height: 118)), v)
        case "minister": minister(pen.fitted(CGSize(width: 100, height: 170)), v)
        default: diy(pen.fitted(CGSize(width: 96, height: 118)), v)
        }
    }

    private static func roller(_ f: PropPen, _ v: Look, _ paint: UInt32) {
        f.rect(54, 2, 42, 112, 0xD9CDB4)
        f.svg("M54 2H96V58Q90 62 84 57Q78 63 72 58Q66 63 60 58Q57 61 54 58Z", paint)
        f.svgLine("M64 61V68M80 60V66M91 59V64", paint, 1.6)
        f.oval(56, 112, 36, 7, 0x1E1E1C, 0.12)
        f.svg("M58 112H90L86 120H62Z", 0x8A8A82)
        f.oval(62, 112, 24, 4, paint)
        let fig = f.within(CGRect(x: 0, y: 10, width: 64, height: 114))
        G5Body.standing(fig, v, coat: 0xEFEBE2)
        fig.dot(16, 60, 1.8, paint)
        fig.dot(28, 74, 1.4, paint)
        fig.dot(14, 80, 1.2, paint)
        G5Body.arm(fig, "M13 42C10 52 10 62 12 70", hand: CGPoint(x: 12.5, y: 72), sleeve: 0xD3D1C7, skin: v.skin)
        G5Body.head(fig, v, 22, 19, face: .smile)
        fig.svg("M10.5 14C11 5 17 3 22 3C28 3 33 6 33.5 12L39 13.5L11 16Z", 0xFFFDF6)
        f.svgLine("M42 71L51 56", 0x5E6B73, 2.4)
        f.svgLine("M51 56L52 51H55", 0x3E4C55, 1.6)
        f.rect(55, 42, 10, 19, paint, radius: 2)
        f.rect(55, 42, 3, 19, PalaceInk.shade(paint, 1.15), radius: 1.5)
        f.stroke(Path(roundedRect: CGRect(x: 55, y: 42, width: 10, height: 19), cornerRadius: 2), 0x3E4C55, 1)
        G5Body.arm(fig, "M31 42C36 48 39 54 42 60", hand: CGPoint(x: 42.5, y: 61), sleeve: 0xEFEBE2, skin: v.skin)
    }

    private static func diy(_ f: PropPen, _ v: Look) {
        let fig = f.within(CGRect(x: 12, y: 4, width: 64, height: 114))
        G5Body.standing(fig, v, coat: 0x2F5BD3)
        fig.svgLine("M16 34V50M28 34V50", 0x21468B, 2)
        fig.rect(14, 48, 16, 10, 0x21468B, radius: 1.5)
        fig.rect(9.6, 66, 25, 4, 0x7A5230)
        fig.svgLine("M13 70L11 84", 0x8C5E38, 2.4)
        fig.rect(6, 82, 10, 4, 0x3E4C55, radius: 1)
        f.svgLine("M0 46L96 32", 0xC9965F, 6)
        f.svgLine("M0 48.5L96 34.5", 0xA87A4A, 1)
        G5Body.arm(fig, "M13 42C14 36 19 33 24 32", hand: CGPoint(x: 25, y: 31.5), sleeve: 0x21468B, skin: v.skin)
        G5Body.head(fig, v, 22, 19, face: .smile)
        fig.svg("M10.5 14C11 6 16 4 22 4C28 4 33 6.5 33.5 12L41 14L11 16Z", 0xF2711C)
        G5Body.arm(fig, "M31 42C34 52 35 60 36 66", hand: CGPoint(x: 36, y: 68), sleeve: 0x2F5BD3, skin: v.skin)
        fig.svgLine("M30 72Q36 64 42 72", 0x3E4C55, 1.6)
        fig.rect(26, 72, 22, 14, 0xC8261B, radius: 2)
        fig.rect(26, 72, 22, 4, 0xA3221B, radius: 2)
    }

    private static func handy(_ f: PropPen, _ v: Look, _ names: [String]) {
        let fig = f.within(CGRect(x: 0, y: 10, width: 64, height: 114))
        G5Body.standing(fig, v)
        G5Body.arm(fig, "M13 42C10 52 10 62 12 70", hand: CGPoint(x: 12.5, y: 72), sleeve: PalaceInk.shade(v.coat, 0.78), skin: v.skin)
        fig.svgLine("M12.5 74L11 88", 0x5E6B73, 1.8)
        fig.rect(10, 66, 5, 7, 0xFAC775, radius: 1.5)
        G5Body.head(fig, v, 22, 19, face: .smile)
        G5Body.arm(fig, "M31 42C38 42 42 38 43 32", hand: CGPoint(x: 43, y: 31), sleeve: v.coat, skin: v.skin)
        fig.rect(40.5, 22, 4, 9, v.skin, radius: 2)
        let icons = names.compactMap(PalaceIcon.init(rawValue:)).prefix(3)
        let spots: [CGPoint] = [CGPoint(x: 62, y: 6), CGPoint(x: 76, y: 38), CGPoint(x: 62, y: 70)]
        for (icon, at) in zip(icons, spots) {
            f.rect(at.x, at.y, 22, 22, 0xFFFDF6, radius: 4)
            f.stroke(Path(roundedRect: CGRect(x: at.x, y: at.y, width: 22, height: 22), cornerRadius: 4), 0xD3D1C7, 1)
            icon.draw(f, in: CGRect(x: at.x + 3, y: at.y + 3, width: 16, height: 16), color: 0x3E4C55, detail: 0xFFFDF6)
            G5Props.tick(f, at.x + 20, at.y + 20, 5)
        }
    }

    private static func singer(_ f: PropPen, _ v: Look, _ dress: UInt32) {
        f.svg("M38 0H52L86 122H4Z", 0xFAC775, 0.22)
        f.oval(4, 116, 82, 12, 0xFAC775, 0.4)
        let fig = f.within(CGRect(x: 13, y: 12, width: 64, height: 114))
        fig.oval(6, 106, 52, 6, 0x1E1E1C, 0.16)
        fig.svgLine("M18 84V104M26 84V104", v.skin, 4)
        fig.svg("M13 103H21V108H13Z M23 103H31V108H23Z", 0x2E2117)
        fig.svg("M14 34C10 60 6 80 4 98H40C38 80 34 60 30 34Z", dress)
        for (x, y) in [(14.0, 56.0), (24, 70), (18, 84), (30, 88), (26, 50)] as [(CGFloat, CGFloat)] {
            G5Props.sparkle(fig, x, y, 2.2, 0xFFE6A8)
        }
        G5Body.arm(fig, "M14 40C8 36 4 30 1 24", hand: CGPoint(x: 0.5, y: 22), sleeve: v.skin, skin: v.skin, width: 4.5)
        G5Body.head(fig, v, 22, 19, face: .sing)
        G5Body.arm(fig, "M30 40C37 42 39 36 35 31", hand: CGPoint(x: 34.5, y: 30), sleeve: v.skin, skin: v.skin, width: 4.5)
        fig.svgLine("M34 31L31 26.5", 0x1E1E1C, 2.4)
        fig.dot(30.5, 25.5, 2.6, 0x3E4C55)
        G5Props.note(f, 68, 30, 0xFAC775)
        G5Props.note(f, 78, 52, 0xFAC775, scale: 0.8)
        G5Props.note(f, 14, 34, 0xFAC775, scale: 0.8)
    }

    private static func director(_ f: PropPen, _ v: Look) {
        f.svgLine("M4 36V108M18 36V82", 0x6B4A2E, 2.6)
        f.rect(2, 42, 18, 14, 0x2E2117, radius: 1)
        f.svgLine("M8 84L42 108M42 84L8 108", 0x6B4A2E, 2.6)
        f.svgLine("M4 82H48", 0x6B4A2E, 2.6)
        let fig = f.within(CGRect(x: 0, y: 8, width: 64, height: 100))
        G5Body.seated(fig, v, seat: "none")
        fig.rect(0, 70, 46, 6, 0x2E2117, radius: 1)
        G5Body.head(fig, v, 23, 26, face: .laugh)
        fig.svg("M11.5 18C12 12 17 10 24 10.5C31 11 34 14 33 18Q22 14.5 11.5 18Z", 0x1E1E1C)
        fig.dot(14, 12.5, 2, 0x1E1E1C)
        f.svg("M33 31L56 21V49L33 39Z", 0xF2711C)
        f.svg("M53 22L58 20V50L53 48Z", 0xFFFDF6)
        G5Body.arm(fig, "M28 46C34 48 40 46 42 40", hand: CGPoint(x: 42, y: 39), sleeve: v.coat, skin: v.skin)
        f.svgLine("M64 26Q70 35 64 44M70 20Q79 35 70 50", 0x5E6B73, 1.6)
        f.rect(64, 84, 30, 22, 0x2E2117, radius: 1.5)
        f.svg("M64 84L92 74L94 79L66 89Z", 0x2E2117)
        f.svgLine("M70 82L72 87M76 80L78 85M82 78L84 83M88 76L90 81", 0xFFFDF6, 2)
        f.svgLine("M68 94H90M68 99H84", 0xFFFDF6, 1)
    }

    private static func painter(_ f: PropPen, _ v: Look) {
        f.svgLine("M62 10L56 116M86 10L94 116M74 60L74 112", 0x8C5E38, 2.6)
        f.rect(52, 66, 46, 4, 0x8C5E38)
        f.rect(54, 14, 42, 52, 0xFFFDF6)
        f.stroke(Path(CGRect(x: 54, y: 14, width: 42, height: 52)), 0xD3D1C7, 1)
        f.rect(56, 16, 38, 26, 0xA9CBE0)
        f.svg("M56 42Q68 30 80 38Q88 33 94 36V64H56Z", 0x5E8C45)
        f.dot(84, 25, 5, 0xFAC775)
        f.svg("M62 52L66 44L70 52Z", 0xC8261B)
        f.svg("M74 46H90V64H74Z", 0xFFFDF6, 0.85)
        let fig = f.within(CGRect(x: 0, y: 4, width: 64, height: 114))
        G5Body.standing(fig, v, coat: 0x5E7A68)
        fig.svg("M4 58C2 52 10 48 18 52C24 55 22 62 16 64C10 66 6 63 4 58Z", 0xD9B886)
        for (x, y, c) in [(8.0, 55.0, 0xC8261B), (13, 53, 0x2F5BD3), (18, 56, 0xFAC775), (9, 60, 0x5E8C45)] as [(CGFloat, CGFloat, UInt32)] {
            fig.dot(x, y, 1.6, c)
        }
        G5Body.arm(fig, "M13 42C10 50 10 56 12 60", hand: CGPoint(x: 12, y: 60), sleeve: PalaceInk.shade(0x5E7A68, 0.8), skin: v.skin)
        G5Body.head(fig, v, 22, 19, face: .smile)
        fig.svg("M10 12C11 5 17 3.5 23 4C30 4.5 34 8 33 11C28 9 18 10 10 12Z", 0xC8261B)
        fig.dot(23, 3.5, 1.6, 0xC8261B)
        G5Body.arm(fig, "M31 42C38 42 44 38 48 32", hand: CGPoint(x: 48.5, y: 31.5), sleeve: 0x5E7A68, skin: v.skin)
        f.svgLine("M48.5 35.5L58 28", 0x9A6A42, 1.6)
        f.dot(58.5, 27.5, 1.6, 0x2F5BD3)
    }

    private static func minister(_ f: PropPen, _ v: Look) {
        let oak: UInt32 = 0x6B4A2E, oakLight: UInt32 = 0x8C6440
        for x in [6.0, 90] as [CGFloat] {
            f.rect(x - 2, 96, 4, 72, 0xC9A15B)
            f.rect(x - 4, 166, 8, 3, 0xC9A15B)
            f.rect(x - 3, 78, 6, 18, 0xFFFDF6, radius: 1)
            f.svg("M\(x) 70Q\(x + 3) 74 \(x) 78Q\(x - 3) 74 \(x) 70Z", 0xF2B33D)
            f.dot(x, 74, 6, 0xFAC775, 0.25)
        }
        f.svg("M10 6H90L84 0H16Z", oak)
        f.rect(10, 6, 80, 6, oakLight)
        f.svgLine("M18 12V22M82 12V22", oak, 2)
        let fig = f.within(CGRect(x: 20, y: 30, width: 64, height: 114))
        fig.svg("M9 88L10.5 44C11.5 36 15.5 32 22 32C28.5 32 32.5 36 33.5 44L35 88Z", 0x1E1E1C)
        fig.svg("M19 33H25V37L22.5 46H19.5Z", 0xFFFDF6)
        fig.svgLine("M22 37V46", 0xD3D1C7, 0.8)
        G5Body.head(fig, v, 22, 19, face: .shut, hair: 0xB4B2A9)
        G5Body.arm(fig, "M31 42C38 40 42 34 42 26", hand: CGPoint(x: 42, y: 24), sleeve: 0x1E1E1C, skin: v.skin)
        fig.rect(39.5, 15, 5, 9, v.skin, radius: 2.4)
        f.svg("M14 94H86L80 140H20Z", oak)
        f.rect(12, 90, 76, 6, oakLight, radius: 1)
        f.svg("M22 100H40L38 132H24Z M46 100H64V132H46Z M70 100H78L76 132H66Z", oakLight, 0.7)
        f.svg("M30 86L50 90L70 86V91L50 94L30 91Z", 0xFFFDF6)
        f.svgLine("M50 90V94", 0xD3D1C7, 0.8)
        f.svg("M38 140H62L58 152H42Z", oak)
        f.rect(46, 152, 8, 16, oak)
        f.rect(38, 166, 24, 3, oak)
    }
}
