import SwiftUI

/// Group g5's pictograms (24 × 24, colour `c`, cut-out `d`): workshop, cinema and theatre,
/// and the signs of several religions (drawn plainly and side by side, none above another).
enum G5Icons {
    static func draw(_ icon: PalaceIcon, _ p: PropPen, _ c: UInt32, _ d: UInt32) {
        switch icon {
        case .g5Wrench:
            p.svgLine("M5.5 18.5L15 9", c, 3.8)
            p.dot(17, 7, 5.2, c)
            p.svgLine("M18 6L22.5 1.5", d, 3.4)
            p.dot(5, 19, 3.4, c)
            p.dot(5, 19, 1.4, d)
        case .g5Film:
            p.rect(1.5, 5, 21, 14, c, radius: 1.5)
            for x in stride(from: 3.5, to: 21, by: 4) {
                p.rect(x, 6.3, 2, 1.8, d, radius: 0.4)
                p.rect(x, 15.9, 2, 1.8, d, radius: 0.4)
            }
            p.rect(4, 9.4, 7, 5.2, d, radius: 0.6)
            p.rect(13, 9.4, 7, 5.2, d, radius: 0.6)
        case .g5Masks:
            mask(p, x: 9, y: 6, c, d, sad: true)
            mask(p, x: 1, y: 2, c, d, sad: false)
        case .g5Cross:
            p.rect(10.3, 2, 3.4, 20, c, radius: 0.6)
            p.rect(5, 7, 14, 3.4, c, radius: 0.6)
        case .g5Crescent:
            p.dot(10.5, 12, 9, c)
            p.dot(14, 10.6, 7.6, d)
            p.svg(PalacePeople.star(cx: 18.6, cy: 12.4, r: 3.6), c)
        case .g5David:
            p.svgLine("M12 2.5L20.7 17.5H3.3Z", c, 2)
            p.svgLine("M12 21.5L3.3 6.5H20.7Z", c, 2)
        case .g5Dharma:
            p.ring(12, 12, 8, c, 2.4)
            for k in 0..<8 {
                let a = Double(k) * .pi / 4
                p.line(12 + cos(a) * 2, 12 + sin(a) * 2, 12 + cos(a) * 8, 12 + sin(a) * 8, c, 1.4)
                p.dot(12 + cos(a) * 10.4, 12 + sin(a) * 10.4, 1.3, c)
            }
            p.dot(12, 12, 2.4, c)
        case .g5Bulb:
            p.dot(12, 9.5, 6.8, c)
            p.rect(8.8, 14, 6.4, 6, c, radius: 1)
            p.svgLine("M9 16.6H15M9 18.6H15", d, 0.9)
            p.svgLine("M10 9.5Q12 6 14 9.5", d, 1.1)
        case .g5Tyre:
            p.ring(12, 12, 8.4, c, 4.6)
            for k in 0..<12 {
                let a = Double(k) * .pi / 6
                p.line(12 + cos(a) * 6.6, 12 + sin(a) * 6.6, 12 + cos(a) * 10.2, 12 + sin(a) * 10.2, d, 0.9)
            }
            p.dot(12, 12, 1.6, c)
        case .g5Chair:
            p.svgLine("M7 2.5V21.5M7 13H18V21.5M7 7.5H11", c, 2.8)
        case .g5Tree:
            p.svg("M12 3L18 10H15L20 16H14V16H4L9 10H6Z", c)
            p.rect(10.5, 16, 3, 5, c)
            p.svg(PalacePeople.star(cx: 12, cy: 3, r: 2.8), c)
            p.dot(9.5, 13, 1, d)
            p.dot(14.5, 11, 1, d)
        default:
            break
        }
    }

    /// One theatre mask (14 × 16 at `x`, `y`): smiling, or sad with downturned mouth.
    private static func mask(_ p: PropPen, x: CGFloat, y: CGFloat, _ c: UInt32, _ d: UInt32, sad: Bool) {
        let face = PalaceSVG.path("M\(x) \(y + 2)Q\(x) \(y) \(x + 2) \(y)H\(x + 12)Q\(x + 14) \(y) \(x + 14) \(y + 2)V\(y + 8)Q\(x + 14) \(y + 15.5) \(x + 7) \(y + 16)Q\(x) \(y + 15.5) \(x) \(y + 8)Z")
        p.fill(face, c)
        p.stroke(face, d, 1.1)
        for ex in [x + 2.4, x + 8.4] {
            p.svgLine(sad ? "M\(ex) \(y + 5)Q\(ex + 1.6) \(y + 7.4) \(ex + 3.2) \(y + 5)" : "M\(ex) \(y + 6.4)Q\(ex + 1.6) \(y + 3.8) \(ex + 3.2) \(y + 6.4)", d, 1.4)
        }
        p.svgLine(sad ? "M\(x + 3.6) \(y + 12.6)Q\(x + 7) \(y + 9) \(x + 10.4) \(y + 12.6)" : "M\(x + 3.4) \(y + 9.6)Q\(x + 7) \(y + 13.6) \(x + 10.6) \(y + 9.6)", d, 1.5)
    }
}
