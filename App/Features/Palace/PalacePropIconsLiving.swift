import SwiftUI

/// Pictograms for home, café and office signs and papers (same 24 × 24 box as `PalaceIcon`).
extension PalaceIcon {
    @MainActor static func drawLiving(_ icon: PalaceIcon, _ p: PropPen, _ c: UInt32, _ d: UInt32) {
        switch icon {
        case .house:
            p.svg("M12 2.2L23 11.6H20.2V22H3.8V11.6H1Z", c)
            p.rect(10, 14.6, 4.2, 7.4, d, radius: 0.6)
            p.rect(5.8, 13.2, 3, 3, d, radius: 0.4)
            p.rect(15.4, 13.2, 3, 3, d, radius: 0.4)
        case .euro:
            p.svgLine("M18.4 6.2A7.6 7.6 0 1 0 18.4 17.8", c, 2.7)
            p.svgLine("M3.6 10.2H14M3.6 13.8H12.6", c, 2.2)
        case .townHall:
            p.svgLine("M12 1.2V5", c, 1.2)
            p.svg("M12.4 1.2H17L15.6 2.6L17 4H12.4Z", c)
            p.svg("M2.4 9.6L12 4.8L21.6 9.6Z", c)
            p.rect(2.4, 9.6, 19.2, 1.8, c)
            for x in [4.4, 9.0, 13.6, 18.2] as [CGFloat] { p.rect(x, 11.8, 1.6, 7.2, c) }
            p.rect(1.6, 19.2, 20.8, 2.6, c)
            p.dot(12, 8.2, 1.1, d)
        case .company:
            p.rect(3, 3, 11, 19, c, radius: 0.8)
            p.rect(14, 9, 7.5, 13, c, radius: 0.8)
            for r in 0..<4 {
                for k in 0..<2 { p.rect(5 + CGFloat(k) * 4.4, 5.6 + CGFloat(r) * 3.6, 2.4, 2, d) }
            }
            p.rect(16, 11.6, 3.4, 2, d)
            p.rect(16, 15.2, 3.4, 2, d)
            p.rect(7, 19, 3, 3, d)
        case .handshake:
            // Two forearms rise from the bottom corners and meet in one clasp.
            p.svgLine("M0.8 18.5L7 13.5M23.2 18.5L17 13.5", c, 5.4)
            p.svgLine("M1.6 14.6L4.4 18.2M22.4 14.6L19.6 18.2", d, 1.2)
            p.rect(5, 8.6, 14, 8, c, radius: 4)
            p.svgLine("M9.6 11.6V15.4M12.2 11.2V15.6M14.8 11.6V15.4", d, 1.1)
            p.svgLine("M7 11.2Q9.6 8.4 13.6 9.8", d, 1.3)
        case .thermometer:
            p.rect(9.4, 1.6, 5.2, 16, c, radius: 2.6)
            p.dot(12, 18.6, 4.4, c)
            p.rect(11, 7, 2, 11, d, radius: 1)
            p.dot(12, 18.6, 2.6, d)
            p.svgLine("M16.6 5H19M16.6 8.4H18.4M16.6 11.8H19", c, 1.4)
        case .sun:
            p.dot(12, 12, 5.2, c)
            for k in 0..<8 {
                let a = Double(k) * .pi / 4
                p.line(12 + cos(a) * 7.6, 12 + sin(a) * 7.6, 12 + cos(a) * 10.6, 12 + sin(a) * 10.6, c, 2)
            }
        default:
            break
        }
    }
}
