import SwiftUI

/// Pictograms added for the learning places (library, GP, school), in the same 24 × 24 box,
/// one colour `c` with a cut-out colour `d`. Reusable on any sign, screen or poster.
enum PalaceLearningIcons {
    @MainActor static func draw(_ icon: PalaceIcon, _ p: PropPen, _ c: UInt32, _ d: UInt32) {
        switch icon {
        case .heart:
            p.svg("M12 21.5C5 16.5 1.8 12.8 1.8 8.6C1.8 5.4 4.3 3 7.4 3C9.4 3 11 4.1 12 5.8C13 4.1 14.6 3 16.6 3C19.7 3 22.2 5.4 22.2 8.6C22.2 12.8 19 16.5 12 21.5Z", c)
            p.svgLine("M4.5 11H8.5L10.2 7.5L12.6 14L14.4 11H19.5", d, 1.6)
        case .globe:
            p.dot(12, 12, 10.5, c)
            p.svgLine("M1.5 12H22.5M12 1.5V22.5M3.5 6.8H20.5M3.5 17.2H20.5", d, 1.2)
            p.stroke(Path(ellipseIn: CGRect(x: 7, y: 1.6, width: 10, height: 20.8)), d, 1.2)
        case .pan:
            p.svg("M2.5 11H17.5V15Q17.5 19.5 13 19.5H7Q2.5 19.5 2.5 15Z", c)
            p.svgLine("M17.5 12.5H23", c, 2.6)
            p.svgLine("M1.5 11H18.5", c, 1.6)
            p.svgLine("M6.5 8.5Q5 6.5 6.5 4.5Q8 2.5 6.5 0.5M10.5 8.5Q9 6.5 10.5 4.5Q12 2.5 10.5 0.5M14.5 8.5Q13 6.5 14.5 4.5", c, 1.4)
        case .lesson:
            p.rect(8, 2, 15.5, 12.5, c, radius: 1)
            p.svgLine("M10.5 6H14.5M16.5 6H20.5M10.5 10H19", d, 1.4)
            p.dot(4.6, 8.4, 2.7, c)
            p.svg("M1 23V15.5Q1 12.4 4.6 12.4Q8.2 12.4 8.2 15.5V23Z", c)
            p.svgLine("M6.6 14.6L10.5 11", c, 1.8)
        case .clock:
            p.dot(12, 12, 11, c)
            p.dot(12, 12, 8.6, d)
            p.svgLine("M12 6.5V12L15.8 14.2", c, 2)
        case .talk:
            p.rect(1, 2, 14, 10, c, radius: 2.5)
            p.svg("M3.5 11.5L3 16L7.5 11.5Z", c)
            p.dot(5, 7, 1.2, d)
            p.dot(8, 7, 1.2, d)
            p.dot(11, 7, 1.2, d)
            p.rect(9.5, 10, 13.5, 9.5, d, radius: 2.5)
            p.rect(10.5, 11, 11.5, 7.5, c, radius: 2)
            p.svg("M19 18L21.5 22L15.5 18Z", c)
        case .pill:
            let capsule = Path(roundedRect: CGRect(x: -9.5, y: -4.2, width: 19, height: 8.4), cornerRadius: 4.2)
                .applying(CGAffineTransform(rotationAngle: -.pi / 4).concatenating(CGAffineTransform(translationX: 12, y: 12)))
            p.fill(capsule, c)
            p.svgLine("M9 9L15 15", d, 1.4)
            p.svg("M14.2 6.6L17.4 9.8L18.3 8.9Q19.2 7.6 17.9 6.1Q16.4 4.8 15.1 5.7Z", d, 0.45)
        case .hospital:
            p.svg("M3 23V8H21V23Z", c)
            p.svg("M7 8V4H17V8Z", c)
            p.svgLine("M9 11.5V19M15 11.5V19M9 15.2H15", d, 2)
        case .practice:
            p.svg("M1.5 11.5L12 2.5L22.5 11.5V23H1.5Z", c)
            p.svg("M10.4 11H13.6V14.2H16.8V17.4H13.6V20.6H10.4V17.4H7.2V14.2H10.4Z", d)
        case .school:
            p.svg("M1.5 23V11L12 5.5L22.5 11V23Z", c)
            p.rect(10, 1, 4, 5.5, c)
            p.svg("M9 1H15L12 -1Z", c)
            p.dot(12, 10.5, 1.6, d)
            p.rect(9.8, 16.5, 4.4, 6.5, d, radius: 0.6)
            p.rect(4, 14, 3.6, 3.6, d)
            p.rect(16.4, 14, 3.6, 3.6, d)
        case .children:
            p.dot(7, 4.5, 2.6, c)
            p.svg("M4 8.5H10L10.5 15.5H3.5Z", c)
            p.svgLine("M5.4 15.5V22M8.6 15.5V22", c, 2.2)
            p.dot(17, 7, 2.3, c)
            p.svg("M14.4 10.5H19.6L20 16.5H14Z", c)
            p.svgLine("M15.6 16.5V22M18.4 16.5V22", c, 2)
            p.svgLine("M10.2 10.5L14.4 12", c, 1.6)
            p.svgLine("M4 10L1.5 15M20 11.5L22.5 16", c, 1.6)
        case .book:
            p.svg("M12 6Q7 2.8 1.5 4V20.5Q7 19.5 12 22Q17 19.5 22.5 20.5V4Q17 2.8 12 6Z", c)
            p.svgLine("M12 6V21.5", d, 1.4)
            p.svgLine("M4 8.5Q7 8 9.8 9.4M4 12Q7 11.5 9.8 12.9M14.2 9.4Q17 8 20 8.5M14.2 12.9Q17 11.5 20 12", d, 1.1)
        case .cap:
            p.svg("M12 3.5L23.5 9L12 14.5L0.5 9Z", c)
            p.svg("M5.5 11.5V16.5Q12 20.5 18.5 16.5V11.5L12 14.6Z", c)
            p.svgLine("M12 9L20.5 10.5V17", c, 1.2)
            p.dot(20.5, 18, 1.5, c)
        case .steps:
            p.svg("M0.5 23V18.5H6.5V13.5H12.5V8.5H18.5V23Z", c)
            p.svgLine("M21 23V3", c, 1.4)
            p.svg("M21 3L24 4.8L21 6.6Z", c)
            p.dot(4, 15, 1.9, c)
            p.svgLine("M4 17V18", c, 1.6)
        case .abc:
            p.text("Aa", PropFont.heavy(14), c, at: CGPoint(x: 12, y: 12.5))
        case .math:
            p.svgLine("M3 7H11M7 3V11M14 7H21M4 14.5L10 20.5M10 14.5L4 20.5M14 16H21M14 19.5H21", c, 2)
        case .music:
            p.svgLine("M9.5 18.5V4.5L20 2.5V16.5", c, 1.8)
            p.svgLine("M9.5 8L20 6", c, 2.4)
            p.oval(3.5, 15.6, 7.2, 5.4, c)
            p.oval(14, 13.6, 7.2, 5.4, c)
        case .ball:
            p.dot(12, 12, 10.5, c)
            p.svgLine("M3 7.5Q12 12 21 7.5M3 16.5Q12 12 21 16.5M12 1.5Q8 12 12 22.5", d, 1.3)
        case .paint:
            p.svg("M12 2C5.8 2 1.5 6.3 1.5 11.8C1.5 17.6 6 22 11.4 22C13.6 22 14 20.8 13.2 19.6C12.2 18.2 13 16.6 14.8 16.6H17.6C20.6 16.6 22.5 14.6 22.5 11.6C22.5 6.2 17.8 2 12 2Z", c)
            p.dot(6.6, 12.4, 1.9, d)
            p.dot(8.6, 7.2, 1.9, d)
            p.dot(14, 6.2, 1.9, d)
            p.dot(18.2, 10.2, 1.9, d)
        default:
            break
        }
    }
}
