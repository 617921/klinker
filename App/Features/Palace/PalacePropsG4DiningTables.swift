import SwiftUI

/// Restaurant tables: a little table set for four, hands clearing dirty plates, and a guest at a
/// table who complains about cold soup, who breathes fire after a hot pepper dish, or who stares
/// at an enormous heap of fries.
enum G4DiningTables {
    typealias Look = PalaceFigures.Look

    /// A table (see `PalacePropKind.g4Table`).
    static func table(_ pen: PropPen, _ p: PalacePropParams) {
        let v = Look.at(p.variant ?? 0)
        switch p.accessory {
        case "set": setTable(pen.fitted(CGSize(width: 124, height: 96)), p)
        case "clear": clear(pen.fitted(CGSize(width: 116, height: 104)))
        case "spicy": spicy(pen.fitted(CGSize(width: 124, height: 110)), v)
        case "portion": portion(pen.fitted(CGSize(width: 124, height: 110)), v)
        default: complain(pen.fitted(CGSize(width: 124, height: 110)), v, p.text)
        }
    }

    /// A table with a white cloth from `x0` to `x1`, its top at `top`, legs down to `floor`.
    static func cloth(_ f: PropPen, _ x0: CGFloat, _ x1: CGFloat, top: CGFloat, floor: CGFloat) {
        f.oval(x0 - 4, floor - 4, x1 - x0 + 8, 7, 0x1E1E1C, 0.14)
        f.svgLine("M\(x0 + 10) \(top + 20)V\(floor)M\(x1 - 10) \(top + 20)V\(floor)", 0x4A3524, 3)
        f.svg("M\(x0) \(top + 4)L\(x0 - 3) \(top + 26)H\(x1 + 3)L\(x1) \(top + 4)Z", 0xFFFDF6)
        f.svgLine("M\(x0 + 16) \(top + 8)L\(x0 + 14) \(top + 26)M\((x0 + x1) / 2) \(top + 8)V\(top + 26)M\(x1 - 16) \(top + 8)L\(x1 - 14) \(top + 26)", 0xE2DED3, 1.2)
        f.rect(x0 - 2, top, x1 - x0 + 4, 6, 0xFFFDF6, radius: 2)
        f.rect(x0 - 2, top + 5, x1 - x0 + 4, 1.4, 0xD3D1C7)
    }

    /// A guest seated behind the left of the table, facing right; returns the head centre.
    @discardableResult
    static func diner(_ f: PropPen, _ v: Look, top: CGFloat, skin: UInt32? = nil) -> CGPoint {
        f.rect(4, top - 44, 8, 50, 0x6B4A2E, radius: 3)
        f.svg("M12 \(top + 4)L13 \(top - 22)C14 \(top - 30) 18 \(top - 33) 25 \(top - 33)C32 \(top - 33) 36 \(top - 30) 37 \(top - 22)L38 \(top + 4)Z", v.coat)
        f.svg("M20 \(top - 33)L25 \(top - 27)L30 \(top - 33)Z", 0xEFEBE2)
        let head = CGPoint(x: 25, y: top - 45)
        f.dot(head.x, head.y, 11, skin ?? v.skin)
        f.svg("M\(head.x - 11) \(head.y - 1)C\(head.x - 12) \(head.y - 9) \(head.x - 7) \(head.y - 13) \(head.x) \(head.y - 13)C\(head.x + 7) \(head.y - 13) \(head.x + 12) \(head.y - 9) \(head.x + 11) \(head.y - 1)C\(head.x + 9) \(head.y - 6) \(head.x + 5) \(head.y - 7.5) \(head.x) \(head.y - 7.5)C\(head.x - 5) \(head.y - 7.5) \(head.x - 9) \(head.y - 6) \(head.x - 11) \(head.y - 1)Z", v.hair)
        return head
    }

    // MARK: Set for four

    private static func setTable(_ f: PropPen, _ p: PalacePropParams) {
        for x in [26.0, 98] as [CGFloat] {
            f.rect(x - 9, 20, 18, 40, 0x6B4A2E, radius: 3)
            f.rect(x - 6, 24, 12, 30, 0x8C5E38, radius: 2)
        }
        f.svgLine("M4 50V92M14 66V92M4 66H16M120 50V92M110 66V92M108 66H120", 0x6B4A2E, 3)
        f.rect(1, 44, 6, 26, 0x8C5E38, radius: 2)
        f.rect(117, 44, 6, 26, 0x8C5E38, radius: 2)
        cloth(f, 18, 106, top: 58, floor: 94)
        for x in [30.0, 52, 74, 96] as [CGFloat] {
            f.oval(x - 7, 54, 14, 5, 0xFFFDF6)
            f.stroke(Path(ellipseIn: CGRect(x: x - 7, y: 54, width: 14, height: 5)), 0xD3D1C7, 0.8)
            f.svg("M\(x + 5) 44H\(x + 10)L\(x + 9) 52H\(x + 6)Z", 0xBCDCEB, 0.9)
        }
        f.rect(60, 36, 4, 20, 0xBCDCEB, radius: 1.5)
        f.dot(62, 32, 4, 0xC8261B)
        f.svgLine("M62 36L58 40", 0x5E8C45, 1.2)
        f.svg("M38 58L42 46H54L58 58Z", 0xFFFDF6)
        f.stroke(PalaceSVG.path("M38 58L42 46H54L58 58Z"), 0x7A1E1E, 1)
        f.text(p.text ?? "", PropFont.heavy(9), 0x7A1E1E, at: CGPoint(x: 48, y: 53), maxWidth: 14)
    }

    // MARK: Clearing

    private static func clear(_ f: PropPen) {
        cloth(f, 6, 92, top: 64, floor: 102)
        // Dirty plates and a crumpled napkin left on the table
        f.oval(12, 58, 26, 8, 0xFFFDF6)
        f.stroke(Path(ellipseIn: CGRect(x: 12, y: 58, width: 26, height: 8)), 0xD3D1C7, 0.8)
        f.svgLine("M18 61Q24 59 28 62M30 60L34 63", 0xA3713F, 1.2)
        f.svgLine("M22 58L34 54M24 60L36 56", 0x9A9890, 1.2)
        f.svg("M44 64L46 56L52 58L56 54L58 62Z", 0xFFFDF6)
        f.stroke(PalaceSVG.path("M44 64L46 56L52 58L56 54L58 62Z"), 0xD3D1C7, 0.8)
        f.svg("M62 64L63 52H70L71 64Z", 0xBCDCEB, 0.8)
        f.dot(28, 69, 1, 0xA3713F)
        f.dot(40, 68, 1, 0xA3713F)
        // Arms from the right: one holds a stack of dirty plates, one lifts another
        f.svgLine("M116 30L92 40", 0xFFFDF6, 7)
        f.svgLine("M116 30L92 40", 0xD3D1C7, 0.8)
        for k in 0..<4 {
            let y = 36 - CGFloat(k) * 4
            f.oval(66, y, 32, 7, 0xFFFDF6)
            f.stroke(Path(ellipseIn: CGRect(x: 66, y: y, width: 32, height: 7)), 0xD3D1C7, 0.8)
        }
        f.svgLine("M72 24Q80 22 86 26", 0xA3713F, 1.2)
        f.dot(90, 42, 3.4, 0xC99A74)
        f.svgLine("M116 56L82 58", 0xFFFDF6, 7)
        f.svgLine("M116 56L82 58", 0xD3D1C7, 0.8)
        f.rect(108, 52, 8, 9, 0x1E1E1C)
        f.dot(80, 58, 3.4, 0xC99A74)
        f.svgLine("M76 52L84 48M78 64L86 66", 0x5E6B73, 1.2)
    }

    // MARK: Guests

    private static func complain(_ f: PropPen, _ v: Look, _ text: String?) {
        let top: CGFloat = 70
        let h = diner(f, v, top: top)
        f.svgLine("M\(h.x + 2) \(h.y - 4)L\(h.x + 9) \(h.y - 2)", 0x2E2117, 1.6)
        f.dot(h.x + 6, h.y + 1, 1.3, 0x2E2117)
        f.svgLine("M\(h.x + 3) \(h.y + 8)Q\(h.x + 6) \(h.y + 5.5) \(h.x + 9) \(h.y + 8)", 0x8C2A1E, 1.2)
        f.svgLine("M\(h.x - 12) \(h.y - 14)L\(h.x - 16) \(h.y - 18)M\(h.x - 6) \(h.y - 17)L\(h.x - 8) \(h.y - 22)", 0xC8261B, 1.4)
        cloth(f, 28, 120, top: top, floor: 108)
        // The bowl of cold soup, a crystal of ice over it
        f.svg("M66 60H98Q96 70 82 70Q68 70 66 60Z", 0xFFFDF6)
        f.oval(66, 57, 32, 6, 0x9FC59A)
        f.svgLine("M82 40V52M76.8 43L87.2 49M76.8 49L87.2 43", 0x2F5BD3, 1.4)
        // Pointing at it
        f.svgLine("M36 \(top - 24)C44 \(top - 16) 54 \(top - 16) 62 \(top - 16)", v.coat, 6)
        f.dot(63, top - 16, 3.2, v.skin)
        f.svgLine("M65 \(top - 16)H70", v.skin, 2)
        if let text {
            let b = CGRect(x: 58, y: 2, width: 60, height: 22)
            f.rect(b, 0xFFFDF6, radius: 7)
            f.stroke(Path(roundedRect: b, cornerRadius: 7), 0x5E6B73, 1)
            f.svg("M66 23L60 32L74 23Z", 0xFFFDF6)
            f.svgLine("M66 23L60 32L74 23", 0x5E6B73, 1)
            f.rect(65, 21, 10, 3, 0xFFFDF6)
            f.text(text, PropFont.heavy(11), 0xC8261B, at: CGPoint(x: b.midX, y: b.midY), maxWidth: b.width - 8)
        }
    }

    private static func spicy(_ f: PropPen, _ v: Look) {
        let top: CGFloat = 72
        let h = diner(f, v, top: top, skin: 0xE8765E)
        f.svgLine("M\(h.x + 3) \(h.y - 1)L\(h.x + 7) \(h.y + 1)L\(h.x + 3) \(h.y + 3)", 0x2E2117, 1.1)
        f.oval(h.x + 5, h.y + 4, 6, 6, 0x8C2A1E)
        // Fire out of the mouth, steam out of the ears, sweat
        f.svg("M\(h.x + 10) \(h.y + 6)Q\(h.x + 24) \(h.y - 8) \(h.x + 40) \(h.y + 2)Q\(h.x + 30) \(h.y + 4) \(h.x + 36) \(h.y + 12)Q\(h.x + 24) \(h.y + 10) \(h.x + 10) \(h.y + 10)Z", 0xF2711C)
        f.svg("M\(h.x + 12) \(h.y + 7)Q\(h.x + 22) \(h.y) \(h.x + 30) \(h.y + 5)Q\(h.x + 22) \(h.y + 9) \(h.x + 12) \(h.y + 9)Z", 0xFAC775)
        for (dx, dy, r) in [(-14.0, -14.0, 3.4), (-18.0, -20.0, 2.6), (-12.0, -24.0, 2.0)] as [(CGFloat, CGFloat, CGFloat)] {
            f.dot(h.x + dx, h.y + dy, r, 0xD3D1C7)
        }
        f.svg("M\(h.x - 4) \(h.y - 16)Q\(h.x - 2) \(h.y - 12) \(h.x - 4) \(h.y - 11)Q\(h.x - 6) \(h.y - 12) \(h.x - 4) \(h.y - 16)Z", 0x8FB6CF)
        cloth(f, 30, 120, top: top, floor: 108)
        // The plate with hot peppers, a glass of water
        f.oval(56, top - 6, 40, 8, 0xFFFDF6)
        f.stroke(Path(ellipseIn: CGRect(x: 56, y: top - 6, width: 40, height: 8)), 0xD3D1C7, 0.8)
        for (x, a) in [(64.0, -0.3), (76.0, 0.2), (86.0, -0.1)] as [(CGFloat, Double)] {
            var g = f
            g.ctx.translateBy(x: x, y: top - 6)
            g.ctx.rotate(by: .radians(a))
            g.svg("M-6 0Q0 -4 6 -2Q2 2 -6 2Z", 0xC8261B)
            g.svgLine("M6 -2L9 -5", 0x5E8C45, 1.4)
        }
        f.svg("M102 \(top - 22)H112L111 \(top)H103Z", 0xBCDCEB, 0.9)
        // Fanning the mouth
        f.svgLine("M36 \(top - 24)C40 \(top - 34) 44 \(top - 40) 48 \(top - 46)", v.coat, 6)
        f.svg("M44 \(top - 50)L52 \(top - 56)L56 \(top - 48)L50 \(top - 42)Z", 0xE8765E)
        f.svgLine("M58 \(top - 58)Q62 \(top - 52) 58 \(top - 46)", 0x5E6B73, 1)
    }

    private static func portion(_ f: PropPen, _ v: Look) {
        let top: CGFloat = 72
        let h = diner(f, v, top: top)
        f.dot(h.x + 3, h.y, 2.8, 0xFFFFFF)
        f.dot(h.x + 9, h.y, 2.8, 0xFFFFFF)
        f.dot(h.x + 3.6, h.y, 1.3, 0x2E2117)
        f.dot(h.x + 9.6, h.y, 1.3, 0x2E2117)
        f.oval(h.x + 4, h.y + 5, 5, 5, 0x8C2A1E)
        f.svgLine("M14 \(top - 24)L6 \(top - 50)M36 \(top - 24)L42 \(top - 52)", v.coat, 5.5)
        f.dot(6, top - 53, 3.2, v.skin)
        f.dot(42, top - 55, 3.2, v.skin)
        f.svgLine("M\(h.x - 6) \(h.y - 18)L\(h.x - 8) \(h.y - 24)M\(h.x + 4) \(h.y - 20)V\(h.y - 26)M\(h.x + 13) \(h.y - 17)L\(h.x + 17) \(h.y - 22)", 0xF2711C, 1.4)
        cloth(f, 30, 120, top: top, floor: 108)
        // An enormous heap of fries, higher than the guest
        f.oval(50, top - 6, 64, 9, 0xFFFDF6)
        f.svg("M54 \(top - 2)Q60 \(top - 30) 72 \(top - 46)Q82 \(top - 62) 90 \(top - 46)Q102 \(top - 30) 110 \(top - 2)Z", 0xF2B33D)
        var sticks = ""
        for (x, y, dx, dy) in [(60.0, -10.0, 6.0, -8.0), (66, -20, -4, -9), (72, -30, 7, -6), (78, -42, -3, -9), (84, -36, 6, -8), (90, -24, -5, -9),
                                (96, -14, 6, -7), (102, -8, -4, -8), (76, -16, 5, -9), (86, -10, -6, -8), (82, -52, 4, -8), (70, -6, 3, -9)] as [(CGFloat, CGFloat, CGFloat, CGFloat)] {
            sticks += "M\(x) \(top + y)l\(dx) \(dy)"
        }
        f.svgLine(sticks, 0xE0A030, 2.2)
        f.svg("M76 \(top - 50)Q82 \(top - 58) 88 \(top - 50)Q82 \(top - 46) 76 \(top - 50)Z", 0xFFFDF6)
    }
}
