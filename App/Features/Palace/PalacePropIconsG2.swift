import SwiftUI

/// Pictograms for the offices and paperwork places (tax office, notary, insurer, energy company,
/// studio, startup), in the same 24 × 24 box as `PalaceIcon`: one colour `c`, cut-outs in `d`.
enum G2Icons {
    @MainActor static func draw(_ icon: PalaceIcon, _ p: PropPen, _ c: UInt32, _ d: UInt32) {
        switch icon {
        case .g2Wallet:
            p.svg("M3 7.5H19Q21.5 7.5 21.5 10V19.5Q21.5 22 19 22H5Q2.5 22 2.5 19.5V8Z", c)
            p.svg("M3.5 7.5L15.5 2.5L17.5 7.5Z", c)
            p.rect(14, 12, 9, 6, d, radius: 2)
            p.dot(17.4, 15, 1.5, c)
        case .g2Umbrella:
            p.svg("M1 12.5Q2 2.5 12 2.5Q22 2.5 23 12.5Q20.5 10.5 17.5 12.5Q15 10.5 12 12.5Q9 10.5 6.5 12.5Q3.5 10.5 1 12.5Z", c)
            p.svgLine("M12 1V2.5", c, 1.6)
            p.svgLine("M12 12.5V20Q12 22.5 9.8 22.5Q7.6 22.5 7.6 20", c, 1.9)
            p.svgLine("M12 3Q8 6 6.5 12.5M12 3Q16 6 17.5 12.5", d, 0.9)
        case .g2Bolt:
            p.svg("M14.5 1L4 13.5H10.5L8.5 23L20 9.5H13.5Z", c)
        case .g2Piggy:
            p.oval(2.5, 6.5, 18, 13, c)
            p.oval(18.5, 10, 4.5, 5, c)
            p.svg("M6 8L7 3.5L10.5 7Z", c)
            p.rect(5.5, 17.5, 3, 4.5, c, radius: 1)
            p.rect(13.5, 17.5, 3, 4.5, c, radius: 1)
            p.rect(9, 7.4, 6, 1.8, d, radius: 0.9)
            p.dot(16, 11, 1.2, d)
            p.dot(20.2, 12.4, 0.7, d)
            p.svgLine("M2.8 12Q0.6 11.4 1.4 9.2", c, 1.2)
        case .g2Tooth:
            p.svg("M5 3.5Q8.5 2 12 4Q15.5 2 19 3.5Q22 5.5 20.5 11Q19.5 14.5 18.5 20Q18 22.5 16.5 22.5Q15 22.5 14.5 19Q13.8 15 12 15Q10.2 15 9.5 19Q9 22.5 7.5 22.5Q6 22.5 5.5 20Q4.5 14.5 3.5 11Q2 5.5 5 3.5Z", c)
            p.svgLine("M7.5 6.5Q9 5.6 10.5 6.4", d, 1.2)
        case .g2Couple:
            p.svgLine("M1.5 10.5L12 2L22.5 10.5", c, 2.2)
            p.dot(8, 10.5, 2.8, c)
            p.dot(16, 10.5, 2.8, c)
            p.svg("M3.5 22.5V18Q3.5 14.3 8 14.3Q12 14.3 12 18Q12 14.3 16 14.3Q20.5 14.3 20.5 18V22.5Z", c)
            p.svg("M12 9.2C11 8 9.6 8.6 10.2 9.8L12 11.6L13.8 9.8C14.4 8.6 13 8 12 9.2Z", 0xC8261B)
        case .g2Lock:
            p.svgLine("M7 11V7.5Q7 2.5 12 2.5Q17 2.5 17 7.5V11", c, 2.6)
            p.rect(3.5, 10.5, 17, 12.5, c, radius: 2)
            p.dot(12, 15.5, 2, d)
            p.rect(11.2, 16, 1.6, 4, d, radius: 0.6)
        case .g2Flame:
            p.svg("M12 1.5Q14 6 17.5 9.5Q21 13 19.5 17.5Q17.5 22.5 12 22.5Q6.5 22.5 4.5 17.5Q3 13 6.5 9.5Q7 12.5 9 13Q8.5 7 12 1.5Z", c)
            p.svg("M12 11.5Q14.5 14.5 15 17Q15 20.5 12 20.5Q9 20.5 9 17.5Q9.5 15 12 11.5Z", d)
        case .g2Snow:
            for k in 0..<3 {
                let a = Double(k) * .pi / 3
                let (dx, dy) = (CGFloat(cos(a)) * 10.5, CGFloat(sin(a)) * 10.5)
                p.line(12 - dx, 12 - dy, 12 + dx, 12 + dy, c, 2)
            }
            for k in 0..<6 {
                let a = Double(k) * .pi / 3
                let (x, y) = (12 + CGFloat(cos(a)) * 6.5, 12 + CGFloat(sin(a)) * 6.5)
                let (l, r) = (a + 2.4, a - 2.4)
                p.line(x, y, x + CGFloat(cos(l)) * 3.2, y + CGFloat(sin(l)) * 3.2, c, 1.4)
                p.line(x, y, x + CGFloat(cos(r)) * 3.2, y + CGFloat(sin(r)) * 3.2, c, 1.4)
            }
        case .g2Car:
            p.svg("M2 16.5V13Q2 11 4 10.5L7 6.5Q8 5 10 5H15.5Q17.5 5 18.5 6.5L21 10.5Q23 11 23 13V16.5Z", c)
            p.svg("M8.2 7H11.6V10.4H6Z M13.4 7H16.4Q17 7 17.5 7.8L19 10.4H13.4Z", d)
            p.dot(6.5, 17, 3, c)
            p.dot(18.5, 17, 3, c)
            p.dot(6.5, 17, 1.3, d)
            p.dot(18.5, 17, 1.3, d)
        case .g2Scales:
            p.rect(11, 3, 2, 17, c)
            p.rect(6, 20, 12, 2.5, c, radius: 1)
            p.svgLine("M3 6H21", c, 2)
            p.svgLine("M4.5 6L1.5 13M4.5 6L7.5 13M19.5 6L16.5 13M19.5 6L22.5 13", c, 1)
            p.svg("M1 13H8Q7.5 16 4.5 16Q1.5 16 1 13Z M16 13H23Q22.5 16 19.5 16Q16.5 16 16 13Z", c)
            p.dot(12, 2.5, 1.8, c)
        case .g2Gear:
            for k in 0..<8 {
                let a = Double(k) * .pi / 4
                p.line(12 + CGFloat(cos(a)) * 7, 12 + CGFloat(sin(a)) * 7, 12 + CGFloat(cos(a)) * 10.5,
                       12 + CGFloat(sin(a)) * 10.5, c, 3.6, round: false)
            }
            p.dot(12, 12, 8, c)
            p.dot(12, 12, 3.4, d)
        default:
            break
        }
    }
}
