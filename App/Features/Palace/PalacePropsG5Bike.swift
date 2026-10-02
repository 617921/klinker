import SwiftUI

/// The bike shop: a Dutch city bike, parts on the wall, patching a tube, swapping an old part for
/// a new one and a checklist under a magnifier.
enum G5Bike {
    private static let tyre: UInt32 = 0x2E2117
    private static let steel: UInt32 = 0xB4B2A9

    // MARK: Bike

    /// A Dutch step-through city bike (124 × 78) facing right. `tone` frame colour; `accessory`
    /// "flat" (front tyre squashed on the ground, a nail in it, air hissing out with `text`) or
    /// "tag" (worn: rust spots and a taped saddle, a card on the handlebar with `text` over `caption`);
    /// `flip` faces left.
    static func bike(_ pen: PropPen, _ p: PalacePropParams) {
        let base = pen.fitted(CGSize(width: 124, height: 78))
        let f = base.mirrored(p.flip == true)
        let frame = PropColor.named(p.tone, 0x2E3A42)
        let worn = p.accessory == "tag", flat = p.accessory == "flat"
        f.oval(4, 72, 116, 6, 0x1E1E1C, 0.14)
        wheel(f, 30, 52, flat: false)
        wheel(f, 94, 52, flat: flat)
        let dark = PalaceInk.shade(frame, 0.75)
        f.svgLine("M7 46A24 24 0 0 1 50 36M71 38A24 24 0 0 1 116 44", frame, 2.6)
        f.svgLine("M30 52L58 54M30 52L51 27M58 54L50 21", frame, 3)
        f.svgLine("M58 54Q70 44 84 28M52 36Q66 32 83 22", frame, 3.2)
        f.svgLine("M83 17L86 30", dark, 4)
        f.svgLine("M86 30Q90 44 94 52", frame, 2.8)
        f.svgLine("M20 30H48M23 30L30 52M44 30L40 40", 0x5E6B73, 1.8)
        f.svgLine("M83 18L80 10M80 10C76 9 72 10 69.5 14", 0x8A8A82, 2.2)
        f.svgLine("M69.5 14L67 17.5", 0x2E2117, 3.6)
        f.svg("M30 49H58Q63 49 63 54Q63 59 58 59H30Q26 59 26 54Q26 49 30 49Z", dark)
        f.svgLine("M58 54L63 64", 0x5E6B73, 2.2)
        f.rect(59, 63, 9, 3, 0x2E2117, radius: 1)
        f.dot(88.5, 25, 3, 0xEFEBE2)
        f.dot(89.5, 25, 1.6, 0xFAC775)
        f.rect(18, 25, 4, 3.4, 0xC8261B, radius: 0.8)
        f.svgLine("M50 21V25", 0x5E6B73, 2)
        f.svg("M41 19C41 15 46 14.5 50 15.5L60 17.5Q62 19 59.5 20.5L46 22.5Q41 23 41 19Z", worn ? 0x7A5230 : 0x2E2117)
        f.svgLine("M44 22.5Q45 26 47 22.5Q48 26 50 22.5", 0x8A8A82, 1)
        if worn {
            f.svgLine("M44 16L50 21M50 16L44 21", 0xD3D1C7, 2.2)
            for (x, y) in [(14.0, 40.0), (40, 34), (108, 38), (75, 37), (33, 55)] as [(CGFloat, CGFloat)] {
                f.dot(x, y, 1.7, 0xA3410A, 0.85)
            }
            f.svgLine("M70 14L67 22", 0x8C5E38, 0.9)
            // The card is drawn unmirrored so its lettering reads.
            let flip = p.flip == true
            var tag = base.within(CGRect(x: flip ? 124 - 52 - 30 : 52, y: 20, width: 30, height: 22))
            tag.ctx.rotate(by: .degrees(flip ? 5 : -6))
            tag.rect(0, 1.5, 28, 19, 0xFAC775, radius: 2)
            tag.dot(flip ? 24 : 4, 4, 1.3, 0x8C5E38)
            if let caption = p.caption {
                tag.text(caption, PropFont.demi(6), 0x412402, at: CGPoint(x: 14, y: 8.5), maxWidth: 25)
            }
            tag.text(p.text ?? "", PropFont.heavy(8.5), 0xC8261B, at: CGPoint(x: 14, y: 15.5), maxWidth: 25)
        }
        if flat {
            f.svgLine("M103 71L110 63", 0x8A8A82, 2.2)
            f.svgLine("M107.5 60.5L112.5 65.5", 0x3E4C55, 3)
            f.svgLine("M113 62Q119 58 116 52M116 66Q124 62 122 54", 0x6FA3C7, 1.8)
            if let text = p.text {
                base.text(text, PropFont.heavy(10), 0x1F3A6B, at: CGPoint(x: p.flip == true ? 12 : 112, y: 44), maxWidth: 26)
            }
        }
    }

    /// A spoked wheel; `flat` squashes the tyre where it meets the ground.
    static func wheel(_ f: PropPen, _ cx: CGFloat, _ cy: CGFloat, flat: Bool) {
        var spokes = Path()
        for k in 0..<12 {
            let a = Double(k) * .pi / 6
            spokes.move(to: CGPoint(x: cx + cos(a) * 2, y: cy + sin(a) * 2))
            spokes.addLine(to: CGPoint(x: cx + cos(a) * 18, y: cy + sin(a) * 18))
        }
        f.stroke(spokes, 0x8A8A82, 0.6)
        f.ring(cx, cy, 18.4, steel, 1.6)
        if flat {
            // The tyre sags: round on top, squashed wide and flat where it meets the ground.
            f.svgLine("M\(cx + 15) \(cy + 14.5)A21 21 0 1 0 \(cx - 15) \(cy + 14.5)C\(cx - 22) \(cy + 20) \(cx - 24) \(cy + 22.5) \(cx - 18) \(cy + 22.5)H\(cx + 18)C\(cx + 24) \(cy + 22.5) \(cx + 22) \(cy + 20) \(cx + 15) \(cy + 14.5)Z", tyre, 4)
            f.svgLine("M\(cx - 10) \(cy + 20.5)Q\(cx - 7) \(cy + 18.5) \(cx - 4) \(cy + 20.5)M\(cx + 3) \(cy + 20.5)Q\(cx + 6) \(cy + 18.5) \(cx + 9) \(cy + 20.5)", 0x5A544E, 0.9)
        } else {
            f.ring(cx, cy, 21, tyre, 4.2)
        }
        f.dot(cx, cy, 2.6, 0x5E6B73)
    }

    // MARK: Parts on the wall

    /// A bay of parts (76 × 50). `accessory`: "tyre" (two new tyres on a hook, a band with `text`),
    /// "chain" (a chain round the big and the small sprocket), "brake" (a hand squeezing the lever,
    /// the cable down to the pads on the rim), "lock" (a U-lock with its key), "lights" (a front
    /// lamp beaming into the dark and a glowing red rear light).
    static func part(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        switch p.accessory ?? "tyre" {
        case "chain":
            f.dot(22, 26, 16.5, 0x8A8A82)
            G5Props.dashed(f, Path(ellipseIn: CGRect(x: 4.5, y: 8.5, width: 35, height: 35)), 0x8A8A82, 3, dash: [2.2, 1.6])
            f.dot(22, 26, 12, 0xD3D1C7)
            for k in 0..<5 {
                let a = Double(k) * 2 * .pi / 5
                f.dot(22 + cos(a) * 7, 26 + sin(a) * 7, 2.6, 0x8A8A82)
            }
            f.dot(22, 26, 2.6, 0x5E6B73)
            f.dot(60, 26, 7.5, 0x8A8A82)
            f.dot(60, 26, 2, 0x5E6B73)
            var chain = Path()
            chain.move(to: CGPoint(x: 22, y: 7.5))
            chain.addLine(to: CGPoint(x: 60, y: 16.5))
            chain.addArc(center: CGPoint(x: 60, y: 26), radius: 9.5, startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: false)
            chain.addLine(to: CGPoint(x: 22, y: 44.5))
            chain.addArc(center: CGPoint(x: 22, y: 26), radius: 18.5, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: false)
            f.stroke(chain, 0x3E4C55, 4.2)
            G5Props.dashed(f, chain, 0xD3D1C7, 2, dash: [2.4, 1.6])
        case "brake":
            f.svgLine("M2 10H44", 0x8A8A82, 3.6)
            f.svgLine("M2 10H19", 0x2E2117, 6.5)
            f.svgLine("M28 10L31 7H36", 0x5E6B73, 3)
            f.svgLine("M32 11Q21 15 9 21", 0x5E6B73, 2.6)
            f.svg("M3 5Q11 1 20 5L21 11Q11 8 4 12Z", 0xC99A74)
            f.svg("M4 12Q11 9 21 12L23 18Q13 16 8 21Q4 19 4 12Z", 0xC99A74)
            f.svgLine("M8 13.5Q14 12 20 14M9 17Q14 15.5 20.5 17.5", PalaceInk.shade(0xC99A74, 0.82), 0.9)
            f.svgLine("M36 7C46 4 54 8 54 17", 0x3E4C55, 1.3)
            var spokes = Path()
            for k in 0..<7 {
                let a = Double(k) * .pi / 6 + .pi
                spokes.move(to: CGPoint(x: 54, y: 52))
                spokes.addLine(to: CGPoint(x: 54 + cos(a) * 18.5, y: 52 + sin(a) * 18.5))
            }
            f.stroke(spokes, 0x8A8A82, 0.6)
            f.svgLine("M33 52A21 21 0 0 1 75 52", tyre, 4.6)
            f.svgLine("M35.5 52A18.5 18.5 0 0 1 72.5 52", steel, 1.8)
            f.svgLine("M46 30Q54 15 62 30", 0x5E6B73, 2.6)
            f.svgLine("M54 17V23", 0x5E6B73, 2)
            f.rect(44.5, 27, 4, 7, 0xC8261B, radius: 1)
            f.rect(59.5, 27, 4, 7, 0xC8261B, radius: 1)
            f.svgLine("M38 30L33 27M37 36L31 35M70 30L75 27M71 36L76 35", 0xC8261B, 1.3)
        case "lock":
            f.svgLine("M23 31V17A15 15 0 0 1 53 17V31", 0x8A8A82, 6)
            f.svgLine("M21.5 17A16.5 16.5 0 0 1 54.5 17", 0xD3D1C7, 1.2)
            f.rect(13, 29, 50, 12, 0x2E2117, radius: 3)
            f.rect(18, 30.5, 40, 9, 0xFAC775, radius: 2)
            f.dot(57, 35, 2.2, 0x8A8A82)
            f.svgLine("M58 35H66", 0xC9A15B, 2.4)
            f.ring(69.5, 35, 4, 0xC9A15B, 2.4)
            f.svgLine("M62 35V38.5M64.5 35V37.5", 0xC9A15B, 1.6)
        case "lights":
            f.rect(1, 3, 74, 44, 0x232B3B, radius: 4)
            f.svg("M21 18L74 5V45L21 30Z", 0xFAC775, 0.32)
            f.svg("M21 21L74 15V35L21 27Z", 0xFAC775, 0.3)
            f.svg("M8 16H17Q24 16 24 24Q24 32 17 32H8Z", 0xB4B2A9)
            f.svg("M17 17.5Q22.5 17.5 22.5 24Q22.5 30.5 17 30.5Z", 0xFFF6D8)
            f.rect(4, 22, 5, 4, 0x5E6B73, radius: 1)
            f.dot(12, 9.5, 6.5, 0xC8261B, 0.3)
            f.rect(7, 6, 10, 7, 0xC8261B, radius: 2)
            f.rect(8.5, 7, 7, 2, 0xF08A80, radius: 1)
        case "pump":
            f.rect(10, 4, 8, 40, 0x1F3A6B, radius: 2)
            f.svgLine("M4 3H24M14 3V8", 0x2E2117, 2.6)
            f.rect(4, 44, 20, 4, 0x2E2117, radius: 1.5)
            f.dot(14, 30, 4.5, 0xFFFDF6)
            f.ring(14, 30, 4.5, 0x5E6B73, 1)
            f.svgLine("M14 30L16 28", 0xC8261B, 1)
            f.svgLine("M18 40Q30 46 30 30Q30 18 26 14", 0x2E2117, 1.6)
            for (i, x) in [44.0, 62].enumerated() {
                f.svg("M\(x - 8) 30A8 8 0 0 1 \(x + 8) 30Z", i == 0 ? 0xB4B2A9 : 0xC8261B)
                f.rect(x - 9, 29.5, 18, 3, 0x5E6B73, radius: 1)
                f.dot(x, 21.5, 1.6, 0x5E6B73)
                f.svgLine("M\(x - 4) 25Q\(x - 1) 23 \(x + 2) 24", 0xFFFFFF, 1, 0.8)
            }
        default:
            f.svgLine("M38 1V7Q38 10 35 10", 0x5E6B73, 2)
            for (i, c) in [CGPoint(x: 29, y: 27), CGPoint(x: 45, y: 29)].enumerated() {
                f.ring(c.x, c.y, 17, tyre, 6)
                var tread = Path()
                for k in 0..<18 {
                    let a = Double(k) * .pi / 9 + Double(i) * 0.15
                    tread.move(to: CGPoint(x: c.x + cos(a) * 14.5, y: c.y + sin(a) * 14.5))
                    tread.addLine(to: CGPoint(x: c.x + cos(a + 0.12) * 19.5, y: c.y + sin(a + 0.12) * 19.5))
                }
                f.stroke(tread, 0x6B6258, 1)
            }
            if let text = p.text {
                f.rect(51, 30, 22, 11, 0xFAC775, radius: 1.5)
                f.text(text, PropFont.heavy(7), 0x412402, at: CGPoint(x: 62, y: 35.5), maxWidth: 20)
            }
        }
    }

    // MARK: Patching a tube

    /// An inner tube (78 × 54) with an orange patch pressed on by a thumb, a tube of glue and a drop.
    static func tubePatch(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 78, height: 54))
        f.oval(2, 34, 62, 12, 0x1E1E1C, 0.12)
        let ring = Path(ellipseIn: CGRect(x: 5, y: 10, width: 56, height: 30))
        f.stroke(ring, 0x3E3A36, 7)
        f.stroke(ring, 0x5A544E, 1.2)
        f.svgLine("M13 16Q29 9 47 13", 0x6B655E, 1)
        let patch = Path(roundedRect: CGRect(x: 20, y: 31, width: 16, height: 12), cornerRadius: 2.5)
        f.fill(patch, 0xF2711C)
        f.stroke(patch, 0xFFB36B, 1.2)
        f.svg("M30 30C29 24 33 20 38 20C43 20 46 24 46 29L44 37Q41 39 37 38L32 36Q30 34 30 30Z", 0xE8C4A0)
        f.svg("M32 26Q34 22 38 22.5Q41 23 41.5 26Q38 28 32 26Z", 0xF6DDC7)
        f.svgLine("M44 36L54 42H64", 0x2F5BD3, 7)
        f.svgLine("M24 47L22 51M29 47V52M34 47L36 51", 0xF2711C, 1.3)
        var glue = f.within(CGRect(x: 50, y: 2, width: 28, height: 22))
        glue.ctx.rotate(by: .degrees(16))
        glue.rect(2, 4, 18, 9, 0xD3D1C7, radius: 2)
        glue.rect(2, 4, 6, 9, 0xC8261B, radius: 2)
        glue.svg("M20 6L25 7.5V9.5L20 11Z", 0x8A8A82)
        f.dot(72, 23, 1.8, 0xEFEBE2)
    }

    // MARK: Swapping an old part

    /// An old, torn saddle (red cross) and a new shiny one (green tick) with two arrows going round
    /// between them (80 × 52). `tone` the new saddle's colour.
    static func swap(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 80, height: 52))
        saddle(f, cx: 18, cy: 28, body: 0x9A7A5A, worn: true)
        saddle(f, cx: 62, cy: 28, body: PropColor.named(p.tone, 0x2E2117), worn: false)
        f.svgLine("M28 12Q40 3 52 11", 0x2F5BD3, 2.2)
        f.svg("M49 6.5L55 12.5L47.5 13.5Z", 0x2F5BD3)
        f.svgLine("M52 48Q40 55 28 47", 0x8A8A82, 1.8)
        f.svg("M31 51.5L25 46L32.5 44.5Z", 0x8A8A82)
        G5Props.cross(f, 8, 10, 6)
        G5Props.tick(f, 74, 10, 6)
    }

    private static func saddle(_ f: PropPen, cx: CGFloat, cy: CGFloat, body: UInt32, worn: Bool) {
        f.svgLine("M\(cx - 1) \(cy + 3)V\(cy + 16)", 0x8A8A82, 2.6)
        f.svgLine("M\(cx - 9) \(cy + 3)Q\(cx - 12) \(cy + 6) \(cx - 9) \(cy + 8)Q\(cx - 6) \(cy + 10) \(cx - 9) \(cy + 12)", 0x5E6B73, 1.4)
        f.svg("M\(cx - 15) \(cy - 3)C\(cx - 15) \(cy - 9) \(cx - 6) \(cy - 10) \(cx) \(cy - 8)L\(cx + 15) \(cy - 4)Q\(cx + 17) \(cy - 1.5) \(cx + 13) \(cy)L\(cx - 9) \(cy + 4)Q\(cx - 15) \(cy + 4) \(cx - 15) \(cy - 3)Z", body)
        if worn {
            f.svg("M\(cx - 7) \(cy - 8)L\(cx - 3) \(cy - 3)L\(cx - 6) \(cy + 1)L\(cx - 1) \(cy + 3)L\(cx - 9) \(cy + 2)L\(cx - 5) \(cy - 3)Z", 0xF6D27A)
            f.svgLine("M\(cx + 4) \(cy - 6)L\(cx + 6) \(cy - 1)", 0x5E4A36, 0.8)
        } else {
            f.svgLine("M\(cx - 10) \(cy - 5)Q\(cx - 4) \(cy - 8.5) \(cx + 4) \(cy - 6)", 0xFFFFFF, 1.4)
        }
    }

    // MARK: Checklist

    /// A clipboard (66 × 72): one row per `icons` entry with a ticked box (the first `count`
    /// rows ticked), `caption` on top, and a magnifier over it.
    static func checklist(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 66, height: 72))
        f.rect(4, 6, 50, 64, 0x1E1E1C, radius: 3, 0.14)
        f.rect(2, 4, 50, 64, 0x8C5E38, radius: 3)
        f.rect(6, 11, 42, 54, 0xFFFDF6, radius: 1)
        f.rect(17, 1, 20, 8, 0x8A8A82, radius: 2)
        if let caption = p.caption {
            f.text(caption, PropFont.heavy(7), 0x1F3A6B, at: CGPoint(x: 27, y: 16.5), maxWidth: 38)
        }
        let icons = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).prefix(3)
        for (i, icon) in icons.enumerated() {
            let y = 22 + CGFloat(i) * 14
            icon.draw(f, in: CGRect(x: 9, y: y, width: 11, height: 11), color: 0x3E4C55, detail: 0xFFFDF6)
            f.line(23, y + 6, 32, y + 6, 0xD3D1C7, 1.4)
            f.stroke(Path(roundedRect: CGRect(x: 35, y: y + 1, width: 9, height: 9), cornerRadius: 1.5), 0x5E6B73, 1)
            if i < (p.count ?? icons.count) {
                f.svgLine("M36.5 \(y + 5.5)L39 \(y + 8.5)L45 \(y - 0.5)", 0x1E7A4C, 2)
            }
        }
        f.svgLine("M54 46L63 58", 0x5E4A36, 4.4)
        f.dot(47, 37, 11, 0xA9CBE0, 0.35)
        f.ring(47, 37, 11, 0x3E4C55, 3)
        f.svgLine("M41 31Q44 28 48 29", 0xFFFFFF, 1.4)
    }
}
