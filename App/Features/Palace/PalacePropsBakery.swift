import SwiftUI

/// Bakery props: the pastry case, dough, toppings, ingredients, bread, an order slip, a tasting
/// plate and a warning sign. Each draws at a design size and scales to its frame.
enum PalaceBakery {
    /// A glass case on the counter (84 × 58) with pastries on two levels.
    static func pastryCase(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 58))
        f.rect(0, 46, 84, 12, 0x8C5E38)
        f.rect(0, 46, 84, 3, 0xC9965F)
        f.rect(2, 4, 80, 42, 0xDCEBF0, 0.45)
        // Top level: tompouce, cream slice, apple pie, eclair
        f.rect(6, 19, 15, 4, 0xE2B47A)
        f.rect(6, 15, 15, 4, 0xFAD97A)
        f.rect(6, 12, 15, 3, 0xF4A6C0)
        f.svg("M26 23V14L42 10V23Z", 0xFFFDF6)
        f.svg("M26 14L42 10V12L26 16Z", 0xF4E1C8)
        f.dot(34, 9.5, 2.6, 0xD9381E)
        f.svg("M46 23V15L62 12V23Z", 0xC98A45)
        f.svgLine("M48 16.5L60 14M48 20L60 18M51 23V15M56 23V13.5", 0xE8B978, 1.1)
        f.svg("M66 23C66 18 69 16 73 16C77 16 80 18 80 23Z", 0xD9A05B)
        f.svg("M66 19C67 16.5 70 16 73 16C76 16 79 16.5 80 19C77 18 69 18 66 19Z", 0x4A3524)
        f.rect(4, 23, 76, 2, 0xFFFFFF, 0.8)
        // Bottom level: a whole cake and cupcakes
        f.rect(8, 33, 30, 13, 0xFFFDF6)
        f.oval(8, 30, 30, 6, 0xF4E1C8)
        for x in [14.0, 23, 32] { f.dot(x, 31.5, 2.4, 0xD9381E) }
        f.svgLine("M8 40H38", 0xF4A6C0, 2)
        for (i, x) in [48.0, 61, 74].enumerated() {
            f.svg("M\(x - 5) 39H\(x + 5)L\(x + 3.5) 46H\(x - 3.5)Z", [0x2F5BD3, 0xC8261B, 0x0F6E56][i])
            f.svg("M\(x - 6) 39.5C\(x - 6) 33 \(x + 6) 33 \(x + 6) 39.5Z", [0xF4C0D1, 0x4A3524, 0xFFFDF6][i])
        }
        f.stroke(Path(CGRect(x: 2, y: 4, width: 80, height: 42)), 0x8E9AA0, 1.6)
        f.svg("M10 44L24 6H30L16 44Z M60 44L74 6H77L63 44Z", 0xFFFFFF, 0.3)
    }

    /// Dough on a floured board (76 × 50): a soft ball and a sheet under a rolling pin.
    static func doughBoard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        f.oval(2, 45, 72, 5, 0x1E1E1C, 0.14)
        f.rect(2, 34, 72, 13, 0xC9965F, radius: 3)
        f.rect(2, 44, 72, 3, 0xA0723F, radius: 1.5)
        for (x, y, r) in [(10.0, 37.0, 3.0), (30, 36, 2.4), (58, 38, 2.8), (68, 36, 2), (20, 40, 2)] as [(CGFloat, CGFloat, CGFloat)] {
            f.dot(x, y, r, 0xFFFDF6, 0.85)
        }
        f.svg("M6 38C3 30 7 17 20 15C26 13 34 15 38 21C44 27 44 34 42 38Z", 0xF6E7C4)
        f.svg("M11 23C14 18 19 16 25 16C21 19 16 21 11 23Z", 0xFFFBF0)
        f.svg("M17 18C21 15 29 15 33 18C29 19 22 19 17 18Z", 0xFFFDF6, 0.9)
        f.svgLine("M9 34C14 36 26 37 38 34", 0xE2CB98, 1.2)
        f.svg("M38 38C38 34 44 33 56 33C68 33 74 34 74 38Z", 0xF3DFB4)
        f.svgLine("M44 33.5L72 21", 0xD9AE78, 7.5)
        f.svgLine("M40 35.5L45 33.2M71 21.4L76 19", 0x8C5E38, 3.4)
        for (x, y) in [(46.0, 14.0), (52, 9), (40, 8), (58, 14)] as [(CGFloat, CGFloat)] { f.dot(x, y, 1.3, 0xFFFDF6) }
    }

    /// A slice of bread with cheese and ham, a box of chocolate sprinkles beside it (76 × 50).
    static func toppings(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        f.oval(2, 46, 72, 4, 0x1E1E1C, 0.14)
        f.svg("M4 48V20C4 10 10 6 18 6H30C38 6 44 10 44 20V48Z", 0xB97A3E)
        f.svg("M7 46V21C7 13 12 9 18.5 9H29.5C36 9 41 13 41 21V46Z", 0xF3DFB4)
        f.svg("M10 20L34 15L38 36L14 41Z", 0xF6C744)
        f.dot(19, 27, 2, 0xE8A93A)
        f.dot(28, 22, 1.6, 0xE8A93A)
        f.dot(31, 31, 2.2, 0xE8A93A)
        f.svg("M22 44C14 44 12 36 18 33C24 30 34 33 34 39C34 43 28 44 22 44Z", 0xE89AA0)
        f.svgLine("M19 37Q25 35 30 39", 0xF4C0D1, 1.4)
        f.rect(50, 12, 22, 36, 0x4A3524, radius: 2)
        f.rect(50, 12, 22, 7, 0xFFFDF6, radius: 2)
        f.rect(53, 24, 16, 14, 0xFFFDF6, radius: 1.5)
        for (x, y) in [(56.0, 28.0), (61, 30), (65, 27), (58, 33), (64, 34)] as [(CGFloat, CGFloat)] {
            f.svgLine("M\(x) \(y)l2 -1", 0x2E2117, 1.4)
        }
        for (x, y) in [(46.0, 46.0), (48, 43), (74, 46)] as [(CGFloat, CGFloat)] { f.svgLine("M\(x) \(y)l2 -1", 0x2E2117, 1.4) }
    }

    /// Flour + eggs + butter (84 × 50): the separate things that go into a cake.
    static func ingredientRow(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 50))
        f.oval(0, 46, 84, 4, 0x1E1E1C, 0.12)
        f.svg("M2 48C1 38 2 26 4 18H22C24 26 25 38 24 48Z", 0xE8D5B0)
        f.svg("M4 18C3 14 5 12 8 13C10 9 16 9 18 13C21 12 23 14 22 18Z", 0xFFFDF6)
        f.svgLine("M4 18H22", 0xC9A87A, 1.2)
        f.dot(9, 9, 1.3, 0xFFFDF6)
        f.dot(15, 7, 1, 0xFFFDF6)
        f.rect(6, 27, 14, 12, 0xFFFDF6, radius: 1)
        f.svgLine("M13 36V29M13 31l-2.5 -2M13 31l2.5 -2M13 34l-2.5 -2M13 34l2.5 -2", 0xC9A15B, 1.1)
        plus(f, 29, 32)
        f.svg("M41 48C35 48 33 44 33 40C33 34 37 28 41 28C45 28 49 34 49 40C49 44 47 48 41 48Z", 0xFFF6E6)
        f.stroke(PalaceSVG.path("M41 48C35 48 33 44 33 40C33 34 37 28 41 28C45 28 49 34 49 40C49 44 47 48 41 48Z"), 0xE2D6BE, 1)
        f.oval(36, 41, 18, 9, 0xF5E6CC)
        plus(f, 59, 32)
        f.svg("M65 34H82V48H65Z", 0xF6D873)
        f.svg("M65 34H76V48H65Z", 0xFFFDF6)
        f.svgLine("M68 38H74M68 42H73", 0xC9A15B, 1.2)
        f.svg("M65 34L68 30H85L82 34Z", 0xFAE59A)
    }

    private static func plus(_ f: PropPen, _ x: CGFloat, _ y: CGFloat) {
        f.svgLine("M\(x - 4) \(y)H\(x + 4)M\(x) \(y - 4)V\(y + 4)", 0x3E4C55, 2.6)
    }

    /// A warning sign (84 × 92): a red triangle with a peanut, `caption` and `text` under it.
    static func warningSign(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 92), hanging: true)
        f.rect(4, 5, 76, 84, 0x1E1E1C, radius: 2, 0.12)
        f.rect(2, 2, 76, 84, 0xFFFDF6, radius: 2)
        f.svg("M40 8L70 58H10Z", 0xC8261B)
        f.svg("M40 19L61 53H19Z", 0xFFFDF6)
        let nut = PalaceSVG.path("M33 44C29 41 30 34 35 33C37 32.5 38 33.5 40 32C42 30 44 27 48 28C53 29 54 35 51 38C48 41 46 39 44 42C42 45 38 47 33 44Z")
        f.fill(nut, 0xC9965F)
        f.stroke(nut, 0x8C5E38, 1.2)
        f.svgLine("M36 38l2 1.5M42 36l2 1.5M47 32l2 1.5", 0x8C5E38, 1.1)
        if let caption = p.caption {
            f.text(caption, PropFont.demi(9), 0x1E1E1C, at: CGPoint(x: 40, y: 66), maxWidth: 68)
        }
        if let text = p.text {
            f.text(text, PropFont.heavy(13), 0xC8261B, at: CGPoint(x: 40, y: 78), maxWidth: 68)
        }
        for (x, a) in [(2.0, -0.4), (66, 0.4)] as [(CGFloat, CGFloat)] {
            let tape = Path(CGRect(x: -7, y: -3, width: 14, height: 6))
                .applying(CGAffineTransform(rotationAngle: a).concatenating(CGAffineTransform(translationX: x + 6, y: 4)))
            f.fill(tape, 0xF4F1EA, 0.85)
        }
    }

    /// An order on a clipboard (76 × 54): a `caption` (the name) and order `lines`, a pencil.
    static func orderSlip(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 54))
        f.oval(10, 50, 56, 4, 0x1E1E1C, 0.14)
        f.rect(12, 6, 46, 46, 0x9A6A42, radius: 3)
        f.rect(16, 10, 38, 40, 0xFFFDF6)
        f.rect(26, 3, 18, 8, 0xB4B2A9, radius: 2)
        f.rect(30, 1, 10, 4, 0x8E9AA0, radius: 1.5)
        if let caption = p.caption {
            f.text(caption, PropFont.heavy(7.5), 0x1F3A6B, at: CGPoint(x: 35, y: 16), maxWidth: 34)
            f.svgLine("M19 20.5H51", 0x1F3A6B, 0.8)
        }
        for (i, line) in (p.lines ?? []).prefix(3).enumerated() {
            let y = 26 + CGFloat(i) * 7.5
            f.text(line, PropFont.demi(6.2), 0x2E2117, at: CGPoint(x: 19, y: y), anchor: .leading, maxWidth: 33)
        }
        f.svgLine("M64 50L74 18", 0xFAC775, 4)
        f.svgLine("M74 18L75.5 13.5", 0xF4C0D1, 4)
        f.svg("M62.6 49.2L64.4 50.4L63 53.5Z", 0x2E2117)
    }

    /// A plate of tasting cubes on toothpicks on a little stand (82 × 98) and a flag card with a
    /// licking face and `text`.
    static func tastingPlate(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 82, height: 98))
        f.oval(18, 92, 46, 6, 0x1E1E1C, 0.16)
        f.oval(24, 89, 34, 6, 0x3E4C55)
        f.rect(38, 54, 6, 37, 0x5E6B73)
        f.oval(4, 44, 74, 13, 0xD3D1C7)
        f.oval(6, 42, 70, 12, 0xFFFDF6)
        f.oval(14, 44, 54, 8, 0xEFEBE2)
        let cubes: [(CGFloat, CGFloat)] = [(19, 43), (30, 41.5), (41, 43), (52, 41.5), (24, 48), (36, 48.5), (47, 48)]
        for (i, (x, y)) in cubes.enumerated() {
            f.line(x + 4, y, x + 4, y - 11, 0xA0723F, 1.2)
            f.rect(x, y - 3.5, 8, 7.5, i % 2 == 0 ? 0xF6C744 : 0xC98A45, radius: 1.2)
        }
        f.line(10, 44, 10, 20, 0x8C5E38, 1.6)
        let card = CGRect(x: 1, y: 3, width: 46, height: 18)
        f.rect(card, 0xFFFDF6, radius: 1.5)
        f.stroke(Path(roundedRect: card, cornerRadius: 1.5), 0xC8261B, 1.2)
        f.dot(10, 12, 6, 0xFAC775)
        f.dot(8, 10.5, 0.9, 0x2E2117)
        f.dot(12, 10.5, 0.9, 0x2E2117)
        f.svgLine("M6.5 13.5Q10 16.5 13.5 13.5", 0x2E2117, 1)
        f.svg("M10.5 15C11 17.5 13.5 17.5 13.5 15Z", 0xE0576B)
        if let text = p.text {
            f.text(text, PropFont.heavy(8.5), 0xC8261B, at: CGPoint(x: 31, y: 12), maxWidth: 28)
        }
    }

    /// Bread (76 × 50). `accessory` "baguette": snapped in two with crumbs and crack lines and a
    /// sound word (`text`); "loaf": a tin loaf, with `tone` "noWheat" a label with a crossed-out ear of wheat.
    static func breadLoaf(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        f.oval(2, 46, 72, 4, 0x1E1E1C, 0.14)
        if p.accessory == "baguette" {
            f.svgLine("M6 44L33 26", 0xD9A05B, 11)
            f.svgLine("M43 26L70 44", 0xD9A05B, 11)
            f.svgLine("M12 37.5l5 -1.5M20 32l5 -1.5M51 30.5l5 1.5M59 36l5 1.5", 0xF0C98A, 1.6)
            f.svg("M30 22L34 25L32 28L35 31L31 33Z", 0xF6E4C0)
            f.svg("M46 22L42 25L44 28L41 31L45 33Z", 0xF6E4C0)
            for (x, y, r) in [(38.0, 30.0, 1.6), (35, 36, 1.2), (41, 37, 1.4), (38, 41, 1), (32, 18, 1.2), (45, 17, 1.4)] as [(CGFloat, CGFloat, CGFloat)] {
                f.dot(x, y, r, 0xC98A45)
            }
            f.svgLine("M28 16L24 11M38 14V8M48 16L52 11M22 22L16 20M54 22L60 20", 0x3E4C55, 1.6)
            if let text = p.text {
                f.text(text, PropFont.heavy(11), 0xC8261B, at: CGPoint(x: 38, y: 3), maxWidth: 40)
            }
        } else {
            f.svg("M4 48V28C4 18 10 14 18 14H38C46 14 52 18 52 28V48Z", 0xC98A45)
            f.svg("M4 28C4 18 10 14 18 14H38C46 14 52 18 52 28C46 24 10 24 4 28Z", 0xA86A2E)
            f.svgLine("M14 20Q18 16 22 20M26 19Q30 15 34 19M38 20Q42 16 46 20", 0xE2B47A, 1.5)
            if p.tone == "noWheat" {
                f.svgLine("M50 30L56 26", 0x8C5E38, 0.9)
                f.dot(62, 22, 14, 0xFFFDF6)
                f.ring(62, 22, 12.5, 0x1E7A4C, 1.6)
                f.svgLine("M62 33V12", 0xC9A15B, 1.4)
                for y in [14.0, 19, 24] {
                    f.svg("M62 \(y + 4)C58 \(y + 3) 57.5 \(y) 58.5 \(y - 1)C61 \(y) 62 \(y + 2) 62 \(y + 4)Z", 0xC9A15B)
                    f.svg("M62 \(y + 4)C66 \(y + 3) 66.5 \(y) 65.5 \(y - 1)C63 \(y) 62 \(y + 2) 62 \(y + 4)Z", 0xC9A15B)
                }
                f.line(53, 13, 71, 31, 0xC8261B, 2.6)
            }
        }
    }
}
