import SwiftUI

/// Pictograms of the g7 places (airport, campsite), in the same 24 × 24 box as `PalaceIcon`.
/// The slash of "no music" stays red: the colour is the meaning.
enum G7Icons {
    static func draw(_ icon: PalaceIcon, _ p: PropPen, _ c: UInt32, _ d: UInt32) {
        switch icon {
        case .g7Plane:
            // Seen from above, nose up and to the right (like airport signs).
            var r = p
            r.ctx.translateBy(x: 12, y: 12)
            r.ctx.rotate(by: .degrees(45))
            r.ctx.translateBy(x: -12, y: -12)
            r.svg("M12 0.8C13.4 0.8 14 2.6 14 4.4V9.4L23 14.6V17.2L14 14.4V19.4L16.8 21.4V23.2L12 22L7.2 23.2V21.4L10 19.4V14.4L1 17.2V14.6L10 9.4V4.4C10 2.6 10.6 0.8 12 0.8Z", c)
        case .g7Moon:
            p.dot(11, 12.5, 9.5, c)
            p.dot(16, 9, 8.2, d)
            p.svg(PalacePeople.star(cx: 19.5, cy: 17, r: 3), c)
        case .g7NoMusic:
            p.oval(3.5, 14.5, 7.4, 5.6, c)
            p.oval(13.5, 12.5, 7.4, 5.6, c)
            p.svgLine("M10 17V5L20 3V15", c, 2)
            p.svgLine("M10 7.6L20 5.6", c, 3)
            p.line(3, 3, 21, 21, d, 5)
            p.line(3, 3, 21, 21, 0xC8261B, 2.8)
        case .g7Toilet:
            p.rect(4, 2, 7, 10, c, radius: 1.2)
            p.svg("M3 12H21Q21 18 15 19.5L15.5 22.5H8.5L9 19.5Q3 18 3 12Z", c)
            p.rect(5, 12.6, 14, 1.4, d)
        case .g7Shower:
            p.svgLine("M4 23V6Q4 2 8 2H12Q15 2 15 5V7", c, 2)
            p.svg("M10 7H20L18 10H12Z", c)
            p.svgLine("M12.5 13L11.5 16M15 13V16.5M17.5 13L18.5 16M12 19L11 22M15 19.5V23M18 19L19 22", c, 1.5)
        default:
            break
        }
    }
}
