import SwiftUI

/// Pictograms added for the care and learning places (hospital, gym, hairdresser, university,
/// language school, dentist), in the same 24 × 24 box, one colour `c` with a cut-out colour `d`.
enum G3Icons {
    @MainActor static func draw(_ icon: PalaceIcon, _ p: PropPen, _ c: UInt32, _ d: UInt32) {
        switch icon {
        case .g3Flowers:
            // A bouquet in a paper cone: visitors.
            p.svgLine("M12 15L7.5 9M12 15V7M12 15L16.5 9", c, 1.4)
            p.svg("M6.5 13H17.5L13.6 23H10.4Z", c)
            p.svgLine("M8.6 16.5H15.4", d, 1.2)
            for (x, y, r) in [(7.0, 7.5, 3.4), (12.0, 4.6, 3.6), (17.0, 7.5, 3.4)] as [(CGFloat, CGFloat, CGFloat)] {
                p.dot(x, y, r, c)
                p.dot(x, y, r * 0.36, d)
            }
        case .g3Tube:
            // A test tube with blood in it: a lab test.
            let tube = Path(roundedRect: CGRect(x: 8.5, y: 3, width: 7, height: 19.5), cornerRadius: 3.5)
            p.stroke(tube, c, 1.8)
            p.fill(Path(roundedRect: CGRect(x: 8.5, y: 11, width: 7, height: 11.5), cornerRadius: 3.5), c)
            p.rect(7, 1, 10, 3.4, c, radius: 1)
            p.svgLine("M10.5 14V19", d, 1.1)
        case .g3Microscope:
            p.rect(3, 20.5, 18, 2.6, c, radius: 1)
            p.rect(6.5, 14.2, 10, 2, c, radius: 0.6)
            p.svgLine("M15.5 20.5C20.5 18.5 20.5 10 15.4 7.4", c, 2.6)
            p.svgLine("M8.6 3.2L13.2 12.4", c, 4.4)
            p.svgLine("M7.6 1.2L8.8 3.6", c, 3)
            p.svgLine("M13.2 12.4L13.9 13.8", c, 2.4)
            p.svgLine("M9.6 5.4L11.2 8.6", d, 1)
        case .g3Flask:
            p.svg("M9 2H15V8.2L21 19.8Q22 22.5 19.2 22.5H4.8Q2 22.5 3 19.8L9 8.2Z", c)
            p.svgLine("M8 2H16", c, 1.8)
            p.svgLine("M5.6 15.5H18.4", d, 1.3)
            p.dot(10, 19, 1.3, d)
            p.dot(14, 18, 1, d)
            p.dot(12.5, 12, 0.9, d)
        case .g3Repeat:
            // Two arrows chasing each other round: again.
            p.svgLine("M4.2 11A8 8 0 0 1 18.4 6.6", c, 2.4)
            p.svg("M21.4 3.8L20.6 10.6L14.6 7.8Z", c)
            p.svgLine("M19.8 13A8 8 0 0 1 5.6 17.4", c, 2.4)
            p.svg("M2.6 20.2L3.4 13.4L9.4 16.2Z", c)
        case .g3Hanger:
            p.svgLine("M12 9V7.2C12 6 14.6 5.6 14.6 3.8C14.6 2.4 13.4 1.4 12 1.4C10.6 1.4 9.6 2.2 9.4 3.4", c, 1.6)
            p.svgLine("M12 9L1.8 17.6Q1 19 2.6 19H21.4Q23 19 22.2 17.6Z", c, 2)
        case .g3Tooth:
            p.svg("M5 4C8 1.5 10 3.4 12 3.4C14 3.4 16 1.5 19 4C22 7 21.2 11.6 19.6 14L18.1 21C17.7 23 15.7 23 15.3 21L13.9 16.2C13.4 14.6 10.6 14.6 10.1 16.2L8.7 21C8.3 23 6.3 23 5.9 21L4.4 14C2.8 11.6 2 7 5 4Z", c)
            p.svgLine("M6.8 6.6Q8 5 9.6 5.4", d, 1.3)
        case .g3Headphones:
            p.svgLine("M4.5 15V12A7.5 7.5 0 0 1 19.5 12V15", c, 2.2)
            p.rect(2.5, 13, 5, 8.5, c, radius: 2)
            p.rect(16.5, 13, 5, 8.5, c, radius: 2)
            p.svgLine("M4 15.5V19M20 15.5V19", d, 1)
        case .g3Dumbbell:
            p.svgLine("M6 12H18", c, 2.4)
            p.rect(3, 6, 4, 12, c, radius: 1)
            p.rect(17, 6, 4, 12, c, radius: 1)
            p.rect(0.8, 8.5, 2.6, 7, c, radius: 0.8)
            p.rect(20.6, 8.5, 2.6, 7, c, radius: 0.8)
        case .g3Scissors:
            p.svgLine("M9.5 13.5L20.5 2.5M14.5 13.5L3.5 2.5", c, 2)
            p.ring(7.5, 17.5, 3.6, c, 2)
            p.ring(16.5, 17.5, 3.6, c, 2)
            p.dot(12, 11.5, 1.1, d)
        default:
            break
        }
    }
}
