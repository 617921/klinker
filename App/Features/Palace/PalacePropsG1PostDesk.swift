import SwiftUI

/// Post-office desk things: a registered letter signed for on a scanner, and something handed
/// across the counter from one hand into another.
enum G1PostDesk {
    // MARK: Registered letter

    /// A letter with a yellow "R" sticker and barcode (80 × 60), and a hand signing for it with a
    /// stylus on a hand scanner.
    static func registered(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 80, height: 60))
        var e = f
        e.ctx.translateBy(x: 26, y: 30)
        e.ctx.rotate(by: .radians(-0.1))
        e.rect(-23, -16, 48, 34, 0x1E1E1C, radius: 1.5, 0.15)
        e.rect(-25, -18, 48, 34, 0xFFFDF6, radius: 1.5)
        e.svgLine("M-24 -17L-1 0L22 -17", 0xE2DED3, 1.2)
        e.rect(-20, -1, 30, 14, 0xFAC775, radius: 1)
        e.rect(-19, 0, 9, 12, 0xC8261B, radius: 1)
        e.text("R", PropFont.heavy(10), 0xFFFDF6, at: CGPoint(x: -14.5, y: 6.5))
        var bars = ""
        for (i, w) in [1.0, 0.5, 1.4, 0.6, 1.0, 0.5, 1.2, 0.7].enumerated() { bars += "M\(-7 + CGFloat(i) * 2.1) 2v9h\(w)v-9Z" }
        e.svg(bars, 0x1E1E1C)
        // The scanner with a signature, the stylus in a hand
        f.rect(50, 18, 26, 40, 0x3E4C55, radius: 4)
        f.rect(53, 22, 20, 22, 0xFFFDF6, radius: 1.5)
        f.svgLine("M55 36C57 30 59 38 61 33C63 28 64 36 67 33L70 31", 0x2F5BD3, 1.3)
        f.line(54, 40, 72, 40, 0xB4B2A9, 0.8)
        f.rect(56, 48, 14, 4, 0x1E7A4C, radius: 1.5)
        f.line(70, 31, 79, 16, 0x1E1E1C, 1.8)
        f.svg("M73 22C74 17 79 15 83 18L84 26L77 28Z", G1Props.skin)
        f.svg("M80 14L90 12V30L84 27Z", 0x993556)
    }

    // MARK: Handing over

    /// Something handed across (84 × 60): a hand from the left holds it out, an open hand from the
    /// right takes it, an orange arrow over them. `accessory` "parcel" (default), "letter" or "key".
    static func giveAcross(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 60))
        f.svgLine("M20 8Q42 -2 62 8", 0xF2711C, 2.4)
        f.svg("M60 3L68 10L58 12Z", 0xF2711C)
        // Giver: sleeve from the bottom left, fingers under the thing
        f.svg("M-2 60L-2 44L14 38L20 52L4 60Z", 0x993556)
        f.svg("M14 38C20 34 30 34 36 37L38 43C30 44 24 46 20 50Z", G1Props.skin)
        switch p.accessory ?? "parcel" {
        case "letter":
            f.rect(24, 24, 32, 20, 0xFFFDF6, radius: 1)
            f.svgLine("M24 24L40 35L56 24", 0xD3D1C7, 1.2)
            f.rect(48, 26, 6, 7, 0xF2711C)
        case "key":
            f.ring(36, 30, 6, 0xC9A15B, 2.6)
            f.rect(41, 28.6, 16, 2.8, 0xC9A15B, radius: 1)
            f.rect(51, 31, 2.6, 4, 0xC9A15B)
            f.rect(55, 31, 2.6, 3, 0xC9A15B)
        default:
            G1Props.parcel(f, CGRect(x: 24, y: 22, width: 32, height: 20))
            f.rect(28, 27, 12, 8, 0xFFFDF6, radius: 0.8)
        }
        f.svg("M26 42C24 40 26 38 29 39L36 41L34 45Z", G1Props.skin)
        // Taker: sleeve from the right, an open hand reaching under
        f.svg("M86 30L86 50L70 52L66 38Z", 0x3E4C55)
        f.svg("M68 38C62 37 56 40 54 44C53 47 56 48 60 47L70 50Z", 0xC99A74)
        f.svgLine("M56 44L64 43", 0xA87B4F, 1)
    }

    // MARK: Mail slot

    /// A letter box in the wall (100 × 84): a red plate with a letter sign and a brass flap, a hand
    /// pushing a letter in, and a letter flying off along a dotted line, on its way.
    static func mailSlot(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 84))
        f.rect(6, 16, 70, 44, 0x1E1E1C, radius: 5, 0.15)
        f.rect(4, 14, 70, 44, 0x8C2E22, radius: 5)
        f.rect(8, 18, 62, 36, 0xB5402F, radius: 3)
        f.rect(30, 21, 18, 11, 0xFFFDF6, radius: 1)
        f.svgLine("M30 21L39 28L48 21", 0xB5402F, 1.2)
        f.rect(16, 38, 46, 9, 0x1E1E1C, radius: 2)
        f.rect(16, 35, 46, 4, 0xC9A15B, radius: 1)
        f.svg("M26 44H54L56 70H28Z", 0xFFFDF6)
        f.svgLine("M28 47L41 56L54 47", 0xD3D1C7, 1.2)
        f.rect(46, 58, 6, 7, 0xF2711C)
        f.svg("M30 66C30 63 36 62 42 63L52 64C56 65 56 69 52 70L34 72C31 72 30 69 30 66Z", 0xC99A74)
        f.svg("M28 84L31 70H53L56 84Z", 0x993556)
        // On its way
        var dots = ""
        for k in 0..<6 { dots += String(format: "M%.1f %.1fa1.2 1.2 0 1 0 0.01 0Z", 76 + Double(k) * 3.2, 36 - Double(k) * 4.6) }
        f.svg(dots, 0xF2711C)
        var e = f
        e.ctx.translateBy(x: 90, y: 8)
        e.ctx.rotate(by: .radians(-0.35))
        e.rect(-9, -6, 18, 12, 0xFFFDF6, radius: 1)
        e.stroke(Path(roundedRect: CGRect(x: -9, y: -6, width: 18, height: 12), cornerRadius: 1), 0xB4B2A9, 0.8)
        e.svgLine("M-9 -6L0 1L9 -6", 0xB4B2A9, 1)
        f.svgLine("M70 6H78M72 12H80", 0xF2711C, 1.6)
    }
}
