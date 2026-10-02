import SwiftUI

/// Dentist things: big model teeth (a molar, one with a cavity, one with a filling, one being
/// pulled, a whole set), mouth close-ups on posters, and the dentist's chair.
enum G3Dentist {
    typealias Look = PalaceFigures.Look

    /// A molar (crown and two roots) in a 60 × 76 box, centred on x 30.
    static let molar = "M12 12C17 4 24 8 30 8C36 8 43 4 48 12C54 20 51 32 47 38L44 62C43 68 37 68 36 62L33 46C32 42 28 42 27 46L24 62C23 68 17 68 16 62L13 38C9 32 6 20 12 12Z"

    // MARK: Model tooth

    /// A model tooth (60 × 80). `accessory` "molar": a big molar on a stand. "cavity": a black hole
    /// in its top under a magnifying glass. "filling": a grey filling pressed in by a little tool,
    /// shining. "pull": pliers lift it out of the pink gum, roots and all, an arrow up. "set": a
    /// whole set of teeth on a model, top and bottom.
    static func tooth(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 60, height: 80))
        let style = p.accessory ?? "molar"
        if style == "set" { wholeSet(f); return }
        if style == "pull" { pull(f); return }
        f.oval(8, 74, 44, 6, 0x1E1E1C, 0.15)
        f.rect(14, 70, 32, 6, 0x3E4C55, radius: 2)
        f.rect(27, 64, 6, 7, 0x5E6B73)
        let shape = PalaceSVG.path(molar)
        f.fill(shape, 0xFFFDF6)
        f.stroke(shape, 0xB4B2A9, 1.4)
        f.svgLine("M15 16Q19 11 24 12", 0xD3E0E6, 2)
        switch style {
        case "cavity":
            f.svg("M24 14Q30 11 35 15Q37 22 31 25Q25 25 24 14Z", 0x2E2117)
            f.svg("M28 16Q31 15 33 17Q33 20 30 21Q28 20 28 16Z", 0x1E1E1C)
            f.dot(30, 18, 13, 0xA9CBE0, 0.18)
            f.ring(30, 18, 13, 0x3E4C55, 2.4)
            f.svgLine("M39 27L50 40", 0x3E4C55, 4)
        case "filling":
            f.svg("M21 12Q30 9 38 13Q40 20 34 23Q26 24 21 12Z", 0x9A9890)
            f.svgLine("M25 14Q30 12.5 34 15", 0xD3D1C7, 1.2)
            f.svgLine("M38 6L52 1", 0x5E6B73, 2.4)
            f.svgLine("M36 8L39 3", 0x5E6B73, 2)
            PalaceCarePeople.star(f, 46, 18, 4.5)
            PalaceCarePeople.star(f, 14, 28, 3)
        default:
            PalaceCarePeople.star(f, 50, 8, 4)
        }
    }

    /// Pliers lifting a molar out of the gum, an arrow up.
    private static func pull(_ f: PropPen) {
        f.svg("M2 66Q30 54 58 66V80H2Z", 0xE89A9A)
        f.svg("M2 66Q30 54 58 66", 0xD9776E)
        f.svg("M18 66Q30 72 42 66Q30 62 18 66Z", 0x8C2F2A, 0.6)
        var t = f
        t.ctx.translateBy(x: 30, y: 36)
        t.ctx.scaleBy(x: 0.7, y: 0.7)
        t.ctx.translateBy(x: -30, y: -36)
        let shape = PalaceSVG.path(molar)
        t.fill(shape, 0xFFFDF6)
        t.stroke(shape, 0xB4B2A9, 1.6)
        // Pliers gripping the crown
        f.svgLine("M16 26C12 18 14 8 22 2M44 26C48 18 46 8 38 2", 0x5E6B73, 3.2)
        f.svgLine("M22 2L26 -6M38 2L34 -6", 0x9A9890, 3)
        f.svgLine("M52 44V14", 0x1E7A4C, 2.4)
        f.svg("M52 8L46.5 16H57.5Z", 0x1E7A4C)
    }

    /// A model of a whole set: pink gums with a row of teeth, top and bottom, hinged at the back.
    private static func wholeSet(_ f: PropPen) {
        f.oval(4, 74, 52, 6, 0x1E1E1C, 0.15)
        f.rect(2, 66, 56, 9, 0xEFEBE2, radius: 3)
        for (top, flip) in [(CGFloat(10), false), (CGFloat(40), true)] {
            let gum = flip ? "M4 \(top + 20)Q30 \(top + 34) 56 \(top + 20)V\(top + 12)Q30 \(top + 24) 4 \(top + 12)Z" : "M4 \(top)Q30 \(top - 12) 56 \(top)V\(top + 8)Q30 \(top - 4) 4 \(top + 8)Z"
            f.svg(gum, 0xE89A9A)
            for i in 0..<8 {
                let x = 6 + CGFloat(i) * 6.2
                let curve = abs(CGFloat(i) - 3.5) * 1.4
                let y = flip ? top + 6 + curve * -0.2 + 6 - curve : top - 2 + curve
                f.rect(x, y, 5.4, 10 - (i == 3 || i == 4 ? 0 : 1), 0xFFFDF6, radius: 1.6)
                f.stroke(Path(roundedRect: CGRect(x: x, y: y, width: 5.4, height: 9), cornerRadius: 1.6), 0xD3D1C7, 0.6)
            }
        }
        f.svgLine("M56 18Q62 34 56 50", 0x9A9890, 2)
    }

    // MARK: Mouth poster

    /// A poster (100 × 66) with a smiling mouth up close. `accessory` "brush": a toothbrush scrubs
    /// the teeth, foam and motion, a little clock with `text` ("2 min"). "gums": the lip pulled up
    /// shows the pink gums, one with a red drop and a probe pointing at it.
    static func face(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 66))
        f.rect(2, 3, 98, 63, 0x1E1E1C, radius: 3, 0.14)
        f.rect(0, 0, 98, 62, 0xFFFDF6, radius: 3)
        f.stroke(Path(roundedRect: CGRect(x: 2.5, y: 2.5, width: 93, height: 57), cornerRadius: 2), 0x0F6E56, 1.4)
        if p.accessory == "gums" {
            gums(f)
            return
        }
        // Lips around a wide smile
        f.oval(14, 12, 64, 40, 0xF1D3B8)
        f.svg("M22 30Q46 10 70 30Q46 52 22 30Z", 0xD9776E)
        f.svg("M26 30Q46 18 66 30Q46 46 26 30Z", 0x5A1F1B)
        for i in 0..<7 {
            let x = 29 + CGFloat(i) * 5.4
            let sag = abs(CGFloat(i) - 3) * 0.8
            f.rect(x, 23 + sag, 4.8, 7 - sag * 0.4, 0xFFFDF6, radius: 1.2)
            f.rect(x, 31.5, 4.8, 5 - sag * 0.6, 0xFFFDF6, radius: 1.2)
        }
        // Toothbrush scrubbing, foam and motion
        for (x, y, r) in [(36.0, 30.0, 3.2), (42, 33, 2.6), (31, 34, 2.2), (48, 29, 2.4)] as [(CGFloat, CGFloat, CGFloat)] {
            f.dot(x, y, r, 0xFFFFFF)
            f.ring(x, y, r, 0xA9CBE0, 0.6)
        }
        f.svgLine("M44 31H90", 0x2F5BD3, 4)
        f.rect(38, 26, 12, 5, 0xFFFDF6, radius: 1)
        f.svgLine("M40 26V22M43 26V22M46 26V22M49 26V22", 0x5DCAA5, 1.4)
        f.svgLine("M58 40H70M60 44H68", 0x9A9890, 1.2)
        if let text = p.text {
            f.dot(84, 14, 8, 0xFAC775)
            f.ring(84, 14, 8, 0x0F6E56, 1.2)
            f.text(text, PropFont.heavy(6), 0x1E1E1C, at: CGPoint(x: 84, y: 14.4), maxWidth: 14)
        }
    }

    /// Lips held wide open: broad pink gums above and below short teeth, a red drop on the gum and
    /// a probe pointing at it.
    private static func gums(_ f: PropPen) {
        f.oval(10, 8, 74, 48, 0xF1D3B8)
        f.svg("M16 31Q47 4 78 31Q47 58 16 31Z", 0xD9776E)
        f.svg("M21 31Q47 10 73 31Q47 52 21 31Z", 0xE8858A)
        f.svg("M27 31H67V33H27Z", 0x5A1F1B)
        for i in 0..<8 {
            let x = 28 + CGFloat(i) * 4.9
            let sag = abs(CGFloat(i) - 3.5) * 0.7
            f.rect(x, 25 + sag, 4.4, 6 - sag * 0.5, 0xFFFDF6, radius: 1.2)
            f.rect(x, 33, 4.4, 5 - sag * 0.5, 0xFFFDF6, radius: 1.2)
        }
        f.svgLine("M24 24Q47 12 70 24M24 40Q47 50 70 40", 0xC8616A, 1)
        f.svg("M49 19Q51 22.5 49 24.5Q47 22.5 49 19Z", 0xC8261B)
        f.svgLine("M88 6L56 18", 0x9A9890, 1.8)
        f.svgLine("M56 18L52 19.5", 0x5E6B73, 1.4)
    }

    // MARK: Dentist's chair

    /// The dentist's chair (156 × 110): a patient lying back with the mouth open and a paper bib,
    /// the dentist in a mask leaning in with a little mirror, the lamp on its arm, a tray of tools.
    static func chair(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 156, height: 110))
        let v = Look.at(p.variant ?? 2)
        let d = Look.at(4)
        f.oval(14, 102, 128, 7, 0x1E1E1C, 0.15)
        // Base and seat, reclined, head to the right
        f.rect(56, 96, 50, 8, 0x5E6B73, radius: 3)
        f.rect(76, 74, 10, 24, 0x9A9890)
        f.svg("M10 66Q8 58 16 58H70L104 52L126 44Q132 42 133 48L134 56L108 64L76 74H16Q10 74 10 66Z", 0x2B8C8C)
        // Patient lying back
        f.svgLine("M18 58L46 56", v.trousers, 7)
        f.svg("M10 56H22V62H10Z", 0x2E2117)
        f.svg("M44 60Q46 48 60 48L102 44Q108 46 104 54L66 62Z", v.coat)
        f.svg("M92 44L106 40L110 50L96 54Z", 0xA9CBE0)
        f.dot(118, 38, 10, v.skin)
        f.svg("M124 30C122 24 116 22 110 26C108 30 108 34 109 36C112 30 118 28 124 30Z", v.hair)
        f.oval(118, 30, 6, 5, 0x5A1F1B)
        f.dot(114, 33, 1.1, 0x2E2117)
        // The lamp on its arm
        f.svgLine("M150 104V10L126 4", 0x5E6B73, 2.4)
        f.svg("M112 0H132L128 8H116Z", 0x3E4C55)
        f.svg("M116 8H128L134 28H110Z", 0xFAC775, 0.3)
        // Dentist leaning in with a mirror
        f.svgLine("M136 74V100M142 74V100", 0x3E4C55, 4.5)
        let coat = PalaceSVG.path("M130 78L132 42C133 36 136 33 141 33C146 33 149 36 150 42L151 78Z")
        f.fill(coat, 0xFFFDF6)
        f.stroke(coat, 0xB4B2A9, 1)
        f.dot(140, 24, 8.5, d.skin)
        f.svg("M131.5 23C131 16 135 13 140 13C145 13 149 16 148.5 23C146.5 19 143.5 18 140 18C136.5 18 133.5 19 131.5 23Z", d.hair)
        f.svg("M132 26H142V31Q137 33 132 30Z", 0xA9CBE0)
        f.dot(134.5, 23.5, 1.1, 0x2E2117)
        f.svgLine("M134 44C130 46 128 40 126 36", 0xFFFDF6, 5.5)
        f.dot(125.5, 35, 2.8, 0x8FB6CF)
        f.svgLine("M125 34L121 30", 0x9A9890, 1.4)
        f.dot(120, 29, 2.6, 0xD3E0E6)
        f.ring(120, 29, 2.6, 0x5E6B73, 1)
        // Tray of tools
        f.svgLine("M30 24V58", 0x5E6B73, 2)
        f.rect(16, 18, 30, 6, 0xD3D1C7, radius: 1.5)
        f.svgLine("M20 17L30 15M24 19L36 17M32 20L42 18", 0x5E6B73, 1.2)
    }
}
