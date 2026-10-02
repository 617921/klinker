import SwiftUI

/// Gallery things on the floor and the door: a ribbon being cut with a toast, an exhibition
/// poster and an open guest book on a lectern.
enum G6ArtFloor {
    // MARK: Ribbon

    /// Two brass posts with a red ribbon cut in the middle by big scissors (84 × 116); above it two
    /// glasses of wine clink with a sparkle.
    static func ribbon(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 116))
        // glasses
        for (x, tilt) in [(30.0, 0.3), (54.0, -0.3)] as [(CGFloat, Double)] {
            var g = f
            g.ctx.translateBy(x: x, y: 30)
            g.ctx.rotate(by: .radians(tilt))
            g.svg("M-7 -18H7L5 -6Q0 -1 -5 -6Z", 0xFFFDF6, 0.9)
            g.svg("M-6.2 -13H6.2L4.6 -6.5Q0 -2.5 -4.6 -6.5Z", 0x9A1E3A)
            g.stroke(PalaceSVG.path("M-7 -18H7L5 -6Q0 -1 -5 -6Z"), 0xB4B2A9, 0.8)
            g.line(0, -3, 0, 10, 0xD3D1C7, 1.6)
            g.line(-5, 10, 5, 10, 0xD3D1C7, 1.6)
        }
        G6Props.sparkle(f, 42, 6, 5)
        G6Props.sparkle(f, 28, 2, 2.6, 0xF2711C)
        G6Props.sparkle(f, 60, 4, 2.6, 0xF2711C)
        // posts and ribbon
        f.oval(0, 110, 84, 6, 0x1E1E1C, 0.14)
        for x in [8.0, 76] as [CGFloat] {
            f.rect(x - 2.5, 64, 5, 46, 0xC9A15B)
            f.dot(x, 63, 4, 0xE8CF8E)
            f.oval(x - 9, 108, 18, 5, 0xC9A15B)
        }
        f.svg("M8 64Q22 70 36 72L37 77Q22 75 8 70Z", 0xC8261B)
        f.svg("M76 64Q62 70 48 72L47 77Q62 75 76 70Z", 0xC8261B)
        f.svg("M36 72L33 86L38 80Z M48 72L51 86L46 80Z", 0xC8261B)
        // scissors
        f.ring(36, 96, 5, 0x1F3A6B, 2.4)
        f.ring(50, 98, 5, 0x1F3A6B, 2.4)
        f.svgLine("M39 92L46 70M47 94L40 70", 0x8E9AA0, 2.4)
    }

    // MARK: Exhibition poster

    /// A poster on the glass (72 × 100): a coloured band, `text` big, three small pictures and
    /// `caption` (the dates) at the bottom.
    static func expoPoster(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 72, height: 100))
        f.rect(2, 3, 70, 97, 0x1E1E1C, radius: 1, 0.15)
        f.rect(0, 0, 70, 96, 0xFFFDF6, radius: 1)
        f.rect(0, 0, 70, 30, 0x3C3489, radius: 1)
        f.dot(56, 10, 7, 0xF2711C)
        f.svg("M4 30L18 14L30 30Z", 0xF2C230)
        if let text = p.text { f.text(text, PropFont.heavy(12), 0xFFFDF6, at: CGPoint(x: 35, y: 22), maxWidth: 62) }
        let pics: [(UInt32, UInt32)] = [(0x24302A, 0xF1D3B8), (0xFFFDF6, 0xC8261B), (0xBCCDD6, 0x5E8C45)]
        for (i, pic) in pics.enumerated() {
            let x = 5 + CGFloat(i) * 21
            f.rect(x, 38, 18, 24, 0xC9A15B)
            f.rect(x + 2, 40, 14, 20, pic.0)
            f.dot(x + 9, 48, 4, pic.1)
        }
        f.line(5, 70, 65, 70, 0xD3D1C7, 1)
        if let caption = p.caption { f.text(caption, PropFont.demi(8.5), 0x3C3489, at: CGPoint(x: 35, y: 80), maxWidth: 62) }
        f.rect(-3, -2, 12, 6, 0xFAC775, radius: 0.5, 0.8)
        f.rect(62, -2, 12, 6, 0xFAC775, radius: 0.5, 0.8)
    }

    // MARK: Guest book

    /// An open book on a lectern (52 × 112): handwritten `lines` and red hearts, a pen.
    static func guestbook(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 52, height: 112))
        f.oval(8, 106, 36, 6, 0x1E1E1C, 0.14)
        f.rect(23, 50, 6, 56, 0x6B4A2E)
        f.oval(12, 104, 28, 6, 0x6B4A2E)
        f.svg("M0 40L52 34V52L0 58Z", 0x8C5E38)
        f.svg("M2 38L26 34V54L2 58Z", 0xFFFDF6)
        f.svg("M26 34L50 30V50L26 54Z", 0xFFFDF6)
        f.svgLine("M26 34V54", 0xD3D1C7, 1)
        let lines = p.lines ?? []
        for (i, line) in lines.prefix(2).enumerated() {
            var t = f
            t.ctx.translateBy(x: i == 0 ? 14 : 38, y: i == 0 ? 42 : 38)
            t.ctx.rotate(by: .radians(-0.15))
            t.text(line, PropFont.demi(6.5), 0x2F5BD3, at: .zero, maxWidth: 22)
        }
        f.svgLine("M6 50L22 47M30 46L46 43", 0xB4B2A9, 1)
        G6Props.heart(f, 14, 24, 6)
        G6Props.heart(f, 30, 12, 7.5)
        G6Props.heart(f, 42, 26, 5)
        f.svgLine("M44 48L52 36", 0x1E1E1C, 2)
    }
}
