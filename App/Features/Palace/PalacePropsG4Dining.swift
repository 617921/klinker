import SwiftUI

/// Restaurant things: the menu in its case, plates on the pass (a dish under a lifted cover, a
/// main course, a vegetable plate with a leaf badge, an ice-cream dessert) and the waiter.
enum G4Dining {
    typealias Look = PalaceFigures.Look

    // MARK: Menu

    /// An open menu in a glass case (88 × 126): a fork and knife on top, three courses each with a
    /// picture (soup, a plate with fish, ice cream) and a price from `lines`.
    static func menu(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 88, height: 126))
        f.rect(0, 0, 88, 126, 0x2E2117, radius: 2)
        f.rect(6, 6, 76, 114, 0xFFFDF6, radius: 1)
        f.rect(6, 6, 76, 18, 0x7A1E1E, radius: 1)
        f.svgLine("M38 10V20M35 10V14Q35 16 38 16Q41 16 41 14V10", 0xFFFDF6, 1.2)
        f.svg("M48 10Q53 12 52 18V20H49V10Z", 0xFFFDF6)
        let prices = p.lines ?? []
        for k in 0..<3 {
            let y = 32 + CGFloat(k) * 29
            let pic = CGRect(x: 10, y: y, width: 22, height: 20)
            switch k {
            case 0:
                f.svg("M\(pic.minX) \(pic.minY + 9)H\(pic.maxX)Q\(pic.maxX - 2) \(pic.maxY) \(pic.midX) \(pic.maxY)Q\(pic.minX + 2) \(pic.maxY) \(pic.minX) \(pic.minY + 9)Z", 0xF2711C)
                f.svgLine("M\(pic.midX - 4) \(pic.minY + 6)Q\(pic.midX - 6) \(pic.minY + 3) \(pic.midX - 4) \(pic.minY)M\(pic.midX + 3) \(pic.minY + 6)Q\(pic.midX + 1) \(pic.minY + 3) \(pic.midX + 3) \(pic.minY)", 0xB4B2A9, 1)
            case 1:
                f.oval(pic.minX, pic.minY + 4, 22, 14, 0xD3D1C7)
                f.oval(pic.minX + 5, pic.minY + 8, 11, 6, 0x8FB6CF)
                f.svg("M\(pic.minX + 16) \(pic.minY + 11)L\(pic.minX + 20) \(pic.minY + 8)V\(pic.minY + 14)Z", 0x8FB6CF)
            default:
                f.svg("M\(pic.minX + 6) \(pic.minY + 10)H\(pic.maxX - 6)L\(pic.midX + 1) \(pic.maxY - 3)H\(pic.midX - 1)Z", 0xE4ECEE)
                f.rect(pic.midX - 1, pic.maxY - 4, 2, 4, 0xE4ECEE)
                f.dot(pic.midX - 3, pic.minY + 8, 4.4, 0xED93B1)
                f.dot(pic.midX + 3, pic.minY + 8, 4.4, 0xFFFDF6)
                f.dot(pic.midX, pic.minY + 3, 4.2, 0x8C5E38)
                f.dot(pic.midX + 1, pic.minY - 1, 1.8, 0xC8261B)
            }
            f.svgLine("M36 \(y + 6)H60M36 \(y + 12)H54", 0xB4B2A9, 1.4)
            if k < prices.count {
                f.text(prices[k], PropFont.demi(8), 0x1E1E1C, at: CGPoint(x: 78, y: y + 9), anchor: .trailing, maxWidth: 24)
            }
        }
        f.svg("M12 120L42 6H54L24 120Z", 0xFFFFFF, 0.12)
    }

    // MARK: Plates

    /// A plate on the pass (see `PalacePropKind.g4Plate`).
    static func plate(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 62, height: 58))
        f.oval(2, 50, 58, 7, 0x1E1E1C, 0.12)
        switch p.accessory {
        case "dessert": dessert(f)
        case "veg":
            dish(f)
            for (x, y) in [(18.0, 42.0), (26, 40), (22, 36)] as [(CGFloat, CGFloat)] {
                f.dot(x, y, 4.2, 0x5E8C45)
                f.rect(x - 1, y + 2, 2, 4, 0x8FC07A)
            }
            for x in [32.0, 38, 44] as [CGFloat] { f.dot(x, 43, 3.6, 0xC8261B); f.dot(x, 43, 1.8, 0xF6A99A) }
            f.svgLine("M30 37L42 34M32 39L44 36", 0xF2711C, 2.4)
            f.dot(50, 24, 10, 0x1E7A4C)
            f.svg("M44 30C44 22 50 18 57 18C57 26 52 30 44 30Z", 0xFFFDF6)
            f.svgLine("M45 29L52 22", 0x1E7A4C, 1)
        case "main":
            f.oval(0, 30, 62, 22, 0xFFFDF6)
            f.stroke(Path(ellipseIn: CGRect(x: 0, y: 30, width: 62, height: 22)), 0xD3D1C7, 1)
            f.oval(8, 33, 26, 13, 0x7A3E1E)
            f.svgLine("M12 38L28 36M12 42L28 40", 0x5A2A12, 1)
            for (x, y) in [(40.0, 38.0), (47, 41), (41, 45)] as [(CGFloat, CGFloat)] { f.dot(x, y, 3.6, 0xF2B33D) }
            f.svgLine("M36 34L50 32M38 32L52 30", 0x5E8C45, 2)
            f.svgLine("M18 28Q16 24 18 20M28 28Q26 24 28 18M40 28Q38 24 40 20", 0xB4B2A9, 1.2)
            f.svgLine("M-2 30V52M60 32V52", 0x9A9890, 1.6)
        default:
            dish(f)
            f.oval(16, 34, 30, 11, 0x7A3E1E)
            f.svgLine("M18 40H44", 0x5E8C45, 2)
            f.svgLine("M22 30Q20 26 22 22M31 30Q29 26 31 20M40 30Q38 26 40 22", 0xB4B2A9, 1.3)
            // The cover lifted up by a hand
            var g = f
            g.ctx.translateBy(x: 50, y: 20)
            g.ctx.rotate(by: .degrees(-35))
            g.svg("M-26 0Q-26 -22 0 -22Q26 -22 26 0Z", 0xD3D1C7)
            g.svgLine("M-18 -6Q-16 -14 -6 -16", 0xFFFFFF, 2)
            g.rect(-27, -1.5, 54, 3, 0x9A9890, radius: 1.5)
            g.dot(0, -24, 3, 0x9A9890)
            f.svg("M52 0L62 -2V10L56 12Z", 0xFFFDF6)
            f.dot(52, 6, 3.4, 0xC99A74)
        }
    }

    /// A white plate seen from the front, low on the pass.
    private static func dish(_ f: PropPen) {
        f.oval(4, 36, 54, 16, 0xFFFDF6)
        f.stroke(Path(ellipseIn: CGRect(x: 4, y: 36, width: 54, height: 16)), 0xD3D1C7, 1)
    }

    private static func dessert(_ f: PropPen) {
        f.oval(18, 50, 26, 5, 0xD3D1C7)
        f.rect(29, 34, 4, 17, 0xE4ECEE)
        f.svg("M14 22H48L40 36H22Z", 0xE4ECEE)
        f.dot(24, 20, 7, 0xED93B1)
        f.dot(38, 20, 7, 0xFFFDF6)
        f.dot(31, 13, 7, 0x8C5E38)
        f.svg("M24 10Q31 -2 38 10Q34 6 31 8Q28 6 24 10Z", 0xFFFDF6)
        f.dot(31, 3, 3, 0xC8261B)
        f.svgLine("M31 1Q33 -3 36 -4", 0x5E8C45, 1)
        f.svgLine("M44 6L52 36", 0x9A9890, 1.6)
        f.oval(41, 2, 6, 8, 0x9A9890)
        f.rect(12, 8, 6, 14, 0xF2B33D, radius: 1)
    }

    // MARK: Waiter

    /// A waiter (64 × 114): white shirt, black waistcoat and bow tie, a long white apron, a towel
    /// over the arm, a notepad with the order and a pen. `variant`.
    static func waiter(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 64, height: 114))
        let v = Look.at(p.variant ?? 4)
        G4Draw.adult(f, v, coat: 0xFFFDF6, hair: 0x1E1E1C)
        f.svg("M11 44C12 37 15 34 18 33L22 50L26 33C29 34 32 37 33 44L34 66H10Z", 0x1E1E1C)
        f.dot(24, 52, 1, 0xC9A15B)
        f.dot(24, 58, 1, 0xC9A15B)
        f.svg("M18.5 33L22 35L25.5 33V37.5L22 35.5L18.5 37.5Z", 0x1E1E1C)
        f.svg("M9 64H35L37 96H7Z", 0xFFFDF6)
        f.stroke(PalaceSVG.path("M9 64H35L37 96H7Z"), 0xD3D1C7, 1)
        f.svg("M8 56H17L16 80H9Z", 0xFFFDF6)
        f.svgLine("M9 58V78", 0xD3D1C7, 1)
        G4Draw.smile(f, 22, 19)
        // The pad and pen
        f.svgLine("M31 42C36 48 40 48 44 44", 0xFFFDF6, 6)
        f.svgLine("M31 42C36 48 40 48 44 44", 0xD3D1C7, 0.8)
        f.rect(42, 30, 14, 18, 0xFFFDF6, radius: 1)
        f.stroke(Path(CGRect(x: 42, y: 30, width: 14, height: 18)), 0xB4B2A9, 0.8)
        f.svgLine("M45 35H53M45 39H53M45 43H50", 0x2F5BD3, 0.9)
        f.dot(44, 46, 3, v.skin)
        f.svgLine("M58 28L52 41", 0x1E1E1C, 1.6)
        f.svgLine("M52 41L51.4 42.6", 0xC9A15B, 1.2)
    }
}
