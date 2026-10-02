import SwiftUI

/// Day-care things around the children: the changing table, a box of toys, a chart of the first
/// days (from tears to smiles) and a picture of a babysitter's evening.
enum G4KidsCare {
    typealias Look = PalaceFigures.Look

    // MARK: Changing table

    /// A changing table (108 × 98): a baby on the mat kicking, hands from above fastening a clean
    /// nappy, a pedal bin beside it with a used nappy and smell lines.
    static func changingTable(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 108, height: 98))
        let baby = Look.at(p.variant ?? 3)
        f.oval(2, 93, 104, 5, 0x1E1E1C, 0.14)
        f.rect(4, 48, 76, 46, 0xEFEBE2, radius: 2)
        f.svgLine("M4 64H80M4 79H80", 0xD3D1C7, 1.2)
        f.rect(36, 69, 12, 3, 0x9A9890, radius: 1)
        f.rect(36, 84, 12, 3, 0x9A9890, radius: 1)
        f.rect(0, 38, 84, 12, 0x5DCAA5, radius: 5)
        f.svgLine("M8 40V48M76 40V48", 0x4FB894, 1)
        // The baby, head left, legs kicking up
        f.dot(16, 32, 9, baby.skin)
        f.svg("M9 28C10 23 14 22 17 22C21 22 24 24 24 28C21 26 18 25.5 16 25.5C13 25.5 11 26 9 28Z", baby.hair)
        f.dot(19, 31, 1.1, 0x2E2117)
        f.svgLine("M18 35Q20 36.5 22 35", 0x8C2A1E, 0.9)
        f.rect(24, 26, 26, 14, 0xFFFDF6, radius: 6)
        f.svgLine("M30 28L28 20M42 28L44 20", baby.skin, 3.4)
        f.svgLine("M58 30L66 14M60 34L72 22", baby.skin, 4.2)
        f.rect(48, 26, 14, 14, 0xFFFDF6, radius: 5)
        f.stroke(Path(roundedRect: CGRect(x: 48, y: 26, width: 14, height: 14), cornerRadius: 5), 0xB4B2A9, 1)
        f.rect(46, 29, 5, 4, 0x5DCAA5, radius: 1)
        // The carer's hands from the top right
        f.svgLine("M80 2L66 22", 0x0F6E56, 6)
        f.dot(64.5, 24.5, 3.4, 0xC99A74)
        f.svgLine("M84 10L60 26", 0x0F6E56, 6)
        f.dot(57, 28, 3.4, 0xC99A74)
        // The bin with the used nappy and its smell
        f.svg("M86 62H106L104 94H88Z", 0x5E6B73)
        f.rect(84, 58, 24, 5, 0x3E4C55, radius: 2)
        f.svg("M88 58Q90 48 96 50Q103 48 104 58Z", 0xE8D6A8)
        f.svgLine("M90 44q-3 -4 0 -8t0 -8M98 44q-3 -4 0 -8t0 -8M105 46q-3 -4 0 -8", 0x6E9C52, 1.4)
    }

    // MARK: Toy box

    /// An open toy box (108 × 86) overflowing: a ball, a teddy, stacking rings; letter blocks and
    /// a toy car on the floor beside it.
    static func toyBox(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 108, height: 86))
        f.oval(4, 80, 100, 6, 0x1E1E1C, 0.14)
        f.svg("M18 42L30 14H84L92 42Z", 0xB98A5A)
        // Toys inside, sticking up
        f.dot(40, 38, 12, 0xC8261B)
        f.svgLine("M29 34Q40 42 51 34", 0xFFFDF6, 2.4)
        f.dot(64, 30, 9, 0xA3713F)
        f.dot(57, 22, 3.6, 0xA3713F)
        f.dot(71, 22, 3.6, 0xA3713F)
        f.dot(64, 33, 3.4, 0xD9B68A)
        f.dot(61, 28, 1.1, 0x1E1E1C)
        f.dot(67, 28, 1.1, 0x1E1E1C)
        f.svgLine("M82 44V16", 0x9A6A42, 2.4)
        for (i, c) in ([0x2F5BD3, 0x5DCAA5, 0xF2B33D, 0xC8261B] as [UInt32]).enumerated() {
            let w = 18 - CGFloat(i) * 3.5
            f.rect(82 - w / 2, 38 - CGFloat(i) * 6, w, 6, c, radius: 3)
        }
        // The box front
        f.svg("M14 42H94L90 82H18Z", 0xC9965F)
        f.svgLine("M16 56H92M17 70H91", 0xA97A4A, 1.4)
        f.rect(12, 40, 84, 5, 0x9A6A42, radius: 2)
        // Blocks and a car on the floor
        for (x, y, c, l) in [(0.0, 64.0, 0x2F5BD3, "A"), (4, 50, 0xF2711C, "B"), (14, 68, 0x0F6E56, "C")] as [(CGFloat, CGFloat, UInt32, String)] {
            f.rect(x, y, 14, 14, c, radius: 1.5)
            f.text(l, PropFont.heavy(9), 0xFFFDF6, at: CGPoint(x: x + 7, y: y + 7.5))
        }
        f.svg("M90 70L94 62H102L106 70Z", 0xF2B33D)
        f.rect(86, 69, 22, 7, 0xC8261B, radius: 2)
        f.dot(91, 77, 3, 0x1E1E1C)
        f.dot(103, 77, 3, 0x1E1E1C)
    }

    // MARK: Settling in

    /// A chart pinned to the wall (84 × 70): three days in a row, a child's face going from tears
    /// to a smile, an arrow underneath. `labels` the three day names ("dag 1" …).
    static func settleChart(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 70))
        f.rect(2, 3, 82, 67, 0x1E1E1C, radius: 2, 0.14)
        f.rect(0, 0, 82, 67, 0xFFFDF6, radius: 2)
        f.dot(41, 2.5, 2.4, 0x2F5BD3)
        let labels = p.labels ?? []
        let skin = Look.at(p.variant ?? 3).skin
        for k in 0..<3 {
            let cx = 15 + CGFloat(k) * 26, cy: CGFloat = 32
            if k < labels.count {
                f.text(labels[k], PropFont.mono(7), 0x1F3A6B, at: CGPoint(x: cx, y: 12), maxWidth: 24)
            }
            f.dot(cx, cy, 10, skin)
            f.svg("M\(cx - 10) \(cy - 2)C\(cx - 10) \(cy - 9) \(cx - 5) \(cy - 11) \(cx) \(cy - 11)C\(cx + 5) \(cy - 11) \(cx + 10) \(cy - 9) \(cx + 10) \(cy - 2)C\(cx + 7) \(cy - 6) \(cx - 7) \(cy - 6) \(cx - 10) \(cy - 2)Z", 0x4A3524)
            switch k {
            case 0:
                f.svgLine("M\(cx - 5.5) \(cy)Q\(cx - 3.5) \(cy - 2) \(cx - 1.5) \(cy)M\(cx + 1.5) \(cy)Q\(cx + 3.5) \(cy - 2) \(cx + 5.5) \(cy)", 0x2E2117, 1)
                f.oval(cx - 3, cy + 3.5, 6, 4.5, 0x8C2A1E)
                G4Animals.tear(f, cx - 6, cy + 1.5)
                G4Animals.tear(f, cx + 6, cy + 1.5)
            case 1:
                f.dot(cx - 3.5, cy - 0.5, 1.2, 0x2E2117)
                f.dot(cx + 3.5, cy - 0.5, 1.2, 0x2E2117)
                f.svgLine("M\(cx - 3) \(cy + 5)H\(cx + 3)", 0x8C2A1E, 1.1)
            default:
                f.svgLine("M\(cx - 5.5) \(cy)Q\(cx - 3.5) \(cy - 2.5) \(cx - 1.5) \(cy)M\(cx + 1.5) \(cy)Q\(cx + 3.5) \(cy - 2.5) \(cx + 5.5) \(cy)", 0x2E2117, 1.1)
                f.svg("M\(cx - 4.5) \(cy + 3)H\(cx + 4.5)Q\(cx + 4) \(cy + 8) \(cx) \(cy + 8)Q\(cx - 4) \(cy + 8) \(cx - 4.5) \(cy + 3)Z", 0x8C2A1E)
                G4Draw.heart(f, cx + 9, cy - 10, 3.4, 0xC8261B)
            }
        }
        f.svgLine("M8 56H72M66 51L72 56L66 61", 0xF2711C, 2.2)
    }

    // MARK: Babysitter

    /// A framed picture of an evening at home (90 × 72): the moon in the window, a teenager reading
    /// to a small child on the sofa, the parents in going-out clothes waving goodbye in the doorway.
    static func babysit(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 90, height: 72))
        f.rect(2, 3, 88, 69, 0x1E1E1C, radius: 2, 0.14)
        f.rect(0, 0, 88, 69, 0x9A6A42, radius: 2)
        f.rect(4, 4, 80, 61, 0xEDE2CC)
        f.rect(4, 56, 80, 9, 0xB98A5A)
        // Night window
        f.rect(8, 8, 22, 22, 0x232B3B)
        PalaceIcon.g4Moon.draw(f, in: CGRect(x: 12, y: 11, width: 12, height: 12), color: 0xFAC775, detail: 0x232B3B)
        f.svgLine("M19 8V30M8 19H30", 0xEFEBE2, 1.2)
        // Sofa with the sitter and the child, a picture book open
        f.rect(8, 44, 48, 14, 0xC8261B, radius: 3)
        f.rect(8, 36, 48, 10, 0xA81E15, radius: 3)
        let teen = Look.at(6)
        f.svg("M15 52L16 40C16.5 36 19 35 22 35C25 35 27.5 36 28 40L29 52Z", 0x5DCAA5)
        f.dot(22, 29, 5.5, teen.skin)
        f.svg("M16.5 28C16.5 24 19 22.5 22 22.5C25 22.5 27.5 24 27.5 28C26 26 24 25.5 22 25.5C20 25.5 18 26 16.5 28Z", teen.hair)
        f.svgLine("M17 26Q12 28 13 34", teen.hair, 2.2)
        let kid = Look.at(3)
        f.svg("M38 52L39 44C39.5 41 41 40 43 40C45 40 46.5 41 47 44L48 52Z", 0xF2B33D)
        f.dot(43, 35.5, 4.5, kid.skin)
        f.svg("M38.6 35C38.6 31.5 40.5 30.5 43 30.5C45.5 30.5 47.4 31.5 47.4 35C46 33.5 44.5 33 43 33C41.5 33 40 33.5 38.6 35Z", kid.hair)
        f.svg("M26 46L33 43L40 46L33 49Z", 0xFFFDF6)
        f.svgLine("M33 43V49", 0x2F5BD3, 0.8)
        // Doorway with the parents waving
        f.rect(60, 12, 22, 46, 0x5A4636)
        f.svg("M62 58L63 38C63.5 34 65 33 67 33C69 33 70.5 34 71 38L72 58Z", 0x993556)
        f.dot(67, 28, 4, 0xE8C4A0)
        f.svg("M63 27C63 23 65 22 67 22C69.5 22 71 23 71 27Z", 0x4A3524)
        f.svgLine("M64 37L60 28", 0xE8C4A0, 1.8)
        f.svg("M72 58L73 38C73.5 34 75 33 77 33C79 33 80.5 34 81 38L82 58Z", 0x1E1E1C)
        f.svg("M75.5 33L77 36L78.5 33Z", 0xFFFDF6)
        f.dot(77, 28, 4, 0x8C5A3C)
        f.svgLine("M80.5 37L84 28", 0x1E1E1C, 1.8)
        f.svgLine("M57 26L55 24M57 30H54", 0x5E6B73, 0.8)
    }
}
