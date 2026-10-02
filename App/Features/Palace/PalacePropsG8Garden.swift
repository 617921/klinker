import SwiftUI

/// Allotment things that stand in the garden: a shed, a greenhouse, the clubhouse, a fenced
/// plot, a slice of soil and two patches of poor and rich ground.
enum G8Garden {
    // MARK: Shed

    /// A plank shed (104 × 100), its door open on a spade and a rake, a watering can by the door.
    /// `variant` 0 green, 1 brown.
    static func shed(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 104, height: 100))
        let wall: UInt32 = (p.variant ?? 0) == 1 ? 0x7A5230 : 0x3F5A4A
        let dark = PalaceInk.shade(wall, 0.72)
        G8Props.shadow(f, 2, 93, 100, 7)
        f.rect(8, 36, 88, 60, wall)
        f.svg("M8 37L52 13L96 37Z", wall)
        var planks = ""
        for x in stride(from: 15.0, to: 96, by: 7) { planks += "M\(x) \(x < 52 ? 37 - (x - 8) * 0.54 : 37 - (96 - x) * 0.54)V96" }
        f.svgLine(planks, dark, 1)
        f.svg("M-1 37L52 7L105 37V43L52 14L-1 43Z", 0x3E4C55)
        f.svgLine("M-1 43L52 14L105 43", 0x2E2117, 1.2)
        f.rect(15, 52, 18, 14, 0xBCCDD6)
        f.stroke(Path(CGRect(x: 15, y: 52, width: 18, height: 14)), 0xEFEBE2, 2)
        f.svgLine("M24 52V66M15 59H33", 0xEFEBE2, 1.4)
        // Open door: the dark inside with the tools, the leaf swung out to the right.
        f.rect(40, 48, 28, 48, 0x2E2117)
        f.svgLine("M47 54V84M44 54H50", 0xC9965F, 2.4)
        f.svg("M43.5 83H50.5V92Q47 95 43.5 92Z", 0xB4B2A9)
        f.svgLine("M60 50V88", 0xC9965F, 2.2)
        f.svgLine("M54 51H66", 0x7D8A92, 2.4)
        f.svgLine("M55 51V56M58 51V56M61 51V56M64 51V56", 0x7D8A92, 1.2)
        let leaf = PalaceInk.shade(wall, 1.18)
        f.svg("M68 48L82 52V92L68 96Z", leaf)
        f.svgLine("M73 50V94M78 51.5V93", wall, 1)
        f.dot(71, 72, 1.4, 0xC9A15B)
        // Watering can.
        f.svgLine("M85 84L76 75", 0x4E7A3A, 2.6)
        f.dot(75.5, 74.5, 2.6, 0x4E7A3A)
        f.svgLine("M88 81Q93 73 98 81", 0x4E7A3A, 1.8)
        f.rect(84, 80, 16, 15, 0x5E8C45, radius: 2)
        f.rect(6, 95, 92, 3, 0x6B4A2E)
    }

    // MARK: Greenhouse

    /// A small glass house (112 × 88) on a brick base: tomato plants behind the panes, white frames.
    static func greenhouse(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 88))
        G8Props.shadow(f, 2, 82, 108)
        for (i, x) in [16.0, 30, 78, 92].enumerated() {
            f.svgLine("M\(x) 74V\(40 + Double(i % 2) * 6)", 0x4E7A3A, 1.8)
            for (k, y) in [46.0, 56, 66].enumerated() {
                f.dot(x + (k % 2 == 0 ? -4 : 4), y, 4.2, k == 1 ? 0x4E7A3A : 0x5E8C45)
            }
            f.dot(x + 3, 52 + Double(i % 3) * 5, 2.8, 0xC8261B)
            f.dot(x - 3, 62, 2.6, i % 2 == 0 ? 0xC8261B : 0xF2711C)
        }
        f.svg("M4 74V36L56 10L108 36V74Z", 0xDDECF1, 0.55)
        f.rect(4, 72, 104, 12, 0x9A5238)
        f.svgLine("M4 78H108M30 72V78M58 78V84M86 72V78", 0x7A3F2E, 1)
        var frame = "M4 72V36L56 10L108 36V72M4 36H108"
        for x in [24.0, 40, 72, 88] {
            let top = x < 56 ? 36 - (x - 4) * 0.5 : 10 + (x - 56) * 0.5
            frame += "M\(x) 72V\(top)"
        }
        f.svgLine(frame, 0xFFFDF6, 2)
        f.stroke(Path(CGRect(x: 47, y: 44, width: 18, height: 28)), 0xFFFDF6, 2)
        f.dot(61, 59, 1.4, 0x5E6B73)
        f.svg("M10 70L26 40H31L15 70Z M76 70L90 44H94L80 70Z", 0xFFFFFF, 0.4)
    }

    // MARK: Clubhouse

    /// The allotment club's house (130 × 160): its flag with the club badge, the badge over the
    /// door, a notice board (`text` big, `caption` under it) and three members in club shirts.
    static func clubhouse(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 130, height: 160))
        G8Props.shadow(f, 2, 152, 126, 7)
        f.rect(8, 4, 3, 150, 0x5E6B73)
        f.dot(9.5, 4, 2.6, 0xC9A15B)
        f.svg("M11 9H62L54 25L62 41H11Z", 0x0F6E56)
        badge(f, 32, 25, 9)
        f.rect(18, 92, 106, 60, 0xC9965F)
        f.svgLine("M18 102H124M18 112H124M18 122H124M18 132H124M18 142H124", 0x9A6A42, 1)
        f.svg("M18 93L71 66L124 93Z", 0xC9965F)
        f.svg("M10 95L71 62L132 95V101L71 69L10 101Z", 0x7A1E1E)
        badge(f, 71, 84, 7.5)
        f.rect(96, 108, 20, 44, 0x2F4B3A)
        f.dot(100, 131, 1.4, 0xC9A15B)
        for (i, x) in [80.0, 99, 117].enumerated() {
            let look = PalaceFigures.Look.at(i * 3 + 1)
            let member = PalaceFigures.Look(coat: 0x0F6E56, trousers: look.trousers, skin: look.skin, hair: look.hair, bag: look.bag)
            let box = CGRect(x: x - 13, y: 104 + Double(i % 2) * 3, width: 26, height: 52)
            PalaceFigures.mini(f.within(box, unit: 26.0 / 30), member, walking: false, briefcase: false)
            f.dot(x + 3, 133 + Double(i % 2) * 3, 2.4, 0xFFFDF6)
        }
        let board = CGRect(x: 14, y: 98, width: 60, height: 36)
        f.rect(22, 130, 3.5, 26, 0x6B4A2E)
        f.rect(62, 130, 3.5, 26, 0x6B4A2E)
        f.rect(board.offsetBy(dx: 1, dy: 1.5), 0x1E1E1C, radius: 2, 0.18)
        f.rect(board, 0xFFFDF6, radius: 2)
        f.stroke(Path(roundedRect: board.insetBy(dx: 2, dy: 2), cornerRadius: 1.5), 0x0F6E56, 1.2)
        if let text = p.text {
            f.text(text, PropFont.heavy(13), 0x0F6E56, at: CGPoint(x: board.midX, y: board.minY + 13), maxWidth: board.width - 8)
        }
        if let caption = p.caption {
            f.text(caption, PropFont.demi(8.5), 0x1E1E1C, at: CGPoint(x: board.midX, y: board.maxY - 8), maxWidth: board.width - 8)
        }
    }

    /// The club badge: a white disc with a green sprout.
    private static func badge(_ f: PropPen, _ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat) {
        f.dot(cx, cy, r, 0xFFFDF6)
        f.svgLine("M\(cx) \(cy + r * 0.62)V\(cy - r * 0.1)", 0x0F6E56, r * 0.2)
        f.svg("M\(cx) \(cy)C\(cx - r * 0.2) \(cy - r * 0.55) \(cx - r * 0.6) \(cy - r * 0.6) \(cx - r * 0.7) \(cy - r * 0.35)C\(cx - r * 0.45) \(cy - r * 0.05) \(cx - r * 0.15) \(cy) \(cx) \(cy)Z", 0x0F6E56)
        f.svg("M\(cx) \(cy - r * 0.15)C\(cx + r * 0.2) \(cy - r * 0.7) \(cx + r * 0.6) \(cy - r * 0.75) \(cx + r * 0.72) \(cy - r * 0.5)C\(cx + r * 0.45) \(cy - r * 0.18) \(cx + r * 0.15) \(cy - r * 0.12) \(cx) \(cy - r * 0.15)Z", 0x0F6E56)
    }

    // MARK: Plot

    /// One rented garden plot (120 × 84) behind a white picket fence: beans on poles, cabbages,
    /// lettuces and a sunflower; the gate post carries the plot's number (`text`).
    static func plot(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 120, height: 84))
        G8Props.shadow(f, 0, 76, 120, 7)
        f.svg("M16 16H104L118 78H2Z", 0x8C5E38)
        f.svgLine("M14 28H106M11 42H109M7 58H113", 0x6B4A2E, 1.3)
        for x in [24.0, 32, 40, 48] {
            f.svgLine("M\(x) 27L\(x + 2) 2", 0x9A6A42, 1.2)
            f.dot(x - 1.5, 20, 3, 0x5E8C45)
            f.dot(x + 2.5, 12, 2.8, 0x4E7A3A)
        }
        for x in stride(from: 22.0, to: 100, by: 13) {
            f.dot(x, 40, 5, 0x6E9C52)
            f.dot(x, 39, 2.2, 0x95B36B)
        }
        for x in stride(from: 16.0, to: 108, by: 14) { f.dot(x, 55, 5.6, 0x95B36B) }
        f.svgLine("M94 46V8", 0x4E7A3A, 2)
        f.dot(90, 26, 3.2, 0x5E8C45)
        f.dot(98, 34, 3.2, 0x5E8C45)
        f.dot(94, 8, 7, 0xF2B33D)
        f.dot(94, 8, 3, 0x6B4A2E)
        // Fence: thin at the back and sides, pointed pickets in front with the gate.
        f.svgLine("M16 16H104M16 16L2 70M104 16L118 70", 0xEFEBE2, 1.4)
        var back = ""
        for x in stride(from: 18.0, to: 104, by: 6) { back += "M\(x) 16V10" }
        f.svgLine(back, 0xEFEBE2, 1.4)
        var front = ""
        for x in stride(from: 2.0, to: 118, by: 7) where !(48...70).contains(x) {
            front += "M\(x) 80V65L\(x + 2) 62L\(x + 4) 65V80Z"
        }
        f.svg(front, 0xFFFDF6)
        f.rect(2, 68, 46, 2, 0xD3D1C7)
        f.rect(72, 68, 46, 2, 0xD3D1C7)
        f.rect(2, 75, 46, 2, 0xD3D1C7)
        f.rect(72, 75, 46, 2, 0xD3D1C7)
        f.svg("M58 64L70 68V82L58 80Z", 0xFFFDF6, 0.95)
        f.svgLine("M60 70L68 72M60 76L68 78", 0xD3D1C7, 1.2)
        f.rect(46, 58, 4, 24, 0xEFEBE2)
        f.rect(70, 58, 4, 24, 0xEFEBE2)
        let plate = CGRect(x: 32, y: 50, width: 20, height: 13)
        f.rect(plate, 0x1F3A6B, radius: 2)
        f.text(p.text ?? "14", PropFont.heavy(10), 0xFFFDF6, at: CGPoint(x: plate.midX, y: plate.midY + 0.5), maxWidth: plate.width - 3)
    }

    // MARK: Soil

    /// A slice cut out of the ground (82 × 100): grass on top, dark earth with a worm and roots,
    /// brown subsoil, pale clay with stones; a small plant and a spade standing in it.
    static func soilCut(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 82, height: 100))
        G8Props.shadow(f, 2, 93, 80, 6)
        let layers: [(CGFloat, CGFloat, UInt32)] = [(20, 28, 0x5E8C45), (28, 52, 0x5A3E28), (52, 74, 0x8C5E38), (74, 96, 0xB08A5E)]
        for (top, bottom, hex) in layers {
            f.rect(6, top, 56, bottom - top, hex)
            f.svg("M62 \(top)L78 \(top - 10)V\(bottom - 10)L62 \(bottom)Z", PalaceInk.shade(hex, 0.78))
        }
        f.svg("M6 20L22 10H78L62 20Z", 0x7FA650)
        f.svgLine("M12 18l1.5 -4l1.5 4M30 16l1.5 -4l1.5 4M48 18l1.5 -4l1.5 4", 0x4E7A3A, 1.1)
        f.svgLine("M24 15V3", 0x4E7A3A, 1.6)
        f.dot(21, 6, 3, 0x6E9C52)
        f.dot(27, 4, 3, 0x6E9C52)
        f.svgLine("M24 22V40M24 30L16 42M24 32L32 46M24 38L20 50", 0xE8D6A8, 1.1)
        f.svgLine("M36 42Q40 36 44 42T52 42T58 38", 0xE89A8C, 3.2)
        f.dot(58.5, 37.5, 1.8, 0xE89A8C)
        f.svgLine("M10 58h3M30 64h4M46 60h3M16 68h2", 0x6B4A2E, 1.4)
        for (x, y, r) in [(14.0, 82.0, 3.4), (34, 88, 2.6), (50, 80, 3.8), (24, 92, 2.2), (68, 76, 2.6)] as [(CGFloat, CGFloat, CGFloat)] {
            f.oval(x - r, y - r * 0.7, 2 * r, 1.4 * r, 0x9A9A92)
        }
        f.svgLine("M54 -2V16M49 -2H59", 0xC9965F, 2.6)
        f.svg("M50.5 14H57.5V18H50.5Z", 0xB4B2A9)
    }

    // MARK: Poor and rich ground

    /// Two mounds of earth (116 × 70): pale cracked ground with a wilted sprout under a red cross,
    /// and dark crumbly ground with a big plant full of tomatoes under a green tick.
    static func fertile(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 116, height: 70))
        G8Props.shadow(f, 0, 63, 116, 6)
        f.svg("M2 66Q4 44 28 42Q52 44 54 66Z", 0xD9C29A)
        f.svgLine("M10 60L18 54L16 48M30 64L28 54L36 50M44 60L40 54", 0xB08A5E, 1.1)
        f.svgLine("M28 44Q27 36 30 32", 0x9A8A5A, 1.4)
        f.svg("M30 32Q36 32 38 38Q33 37 30 32Z M30 33Q25 34 24 40Q28 38 30 33Z", 0xC9A15B)
        G8Props.badge(f, 28, 14, 9, ok: false)
        f.svg("M62 66Q64 40 88 38Q112 40 114 66Z", 0x4A3524)
        f.svgLine("M70 58h2M84 52h3M98 60h2M78 62h2M104 54h2", 0x6B4A2E, 1.6)
        f.svgLine("M88 40V8M88 30L76 18M88 24L100 12M88 34L102 26", 0x4E7A3A, 2)
        for (x, y, r, hex) in [(76.0, 16.0, 6.0, 0x5E8C45), (100, 10, 6, 0x5E8C45), (88, 6, 5.5, 0x4E7A3A), (103, 25, 5.5, 0x4E7A3A),
                               (73, 28, 5, 0x6E9C52), (93, 20, 5, 0x6E9C52)] as [(CGFloat, CGFloat, CGFloat, UInt32)] {
            f.dot(x, y, r, hex)
        }
        for (x, y) in [(80.0, 24.0), (96, 30), (84, 34), (104, 18), (72, 20), (92, 14)] as [(CGFloat, CGFloat)] {
            f.dot(x, y, 3.4, 0xC8261B)
        }
        G8Props.badge(f, 108, 44, 8, ok: true)
    }
}
