import SwiftUI

/// Pictograms added for care, community and hospitality places (vet, pool, day care, community
/// centre, hotel, restaurant), in the usual 24 × 24 box: one colour `c` with a cut-out colour `d`.
enum G4Icons {
    @MainActor static func draw(_ icon: PalaceIcon, _ p: PropPen, _ c: UInt32, _ d: UInt32) {
        switch icon {
        case .g4Group:
            // Two people behind, one in front with a cut-out edge.
            for x in [5.5, 18.5] as [CGFloat] {
                p.dot(x, 7.5, 3.2, c)
                p.svg("M\(x - 5) 19V15Q\(x - 5) 11.5 \(x) 11.5Q\(x + 5) 11.5 \(x + 5) 15V19Z", c)
            }
            p.dot(12, 10, 5.2, d)
            p.svg("M4.6 24V19Q4.6 13.6 12 13.6Q19.4 13.6 19.4 19V24Z", d)
            p.dot(12, 10, 3.8, c)
            p.svg("M6 23V19Q6 15 12 15Q18 15 18 19V23Z", c)
        case .g4Moon:
            p.svg("M14 2A10 10 0 1 0 22 16A8 8 0 0 1 14 2Z", c)
            p.dot(20, 5, 1.2, c)
            p.dot(17, 9.5, 0.9, c)
        case .g4Camera:
            p.rect(7, 3.5, 8, 4.5, c, radius: 1)
            p.rect(1.5, 6.5, 21, 14, c, radius: 2.5)
            p.dot(12, 13.5, 5, d)
            p.dot(12, 13.5, 3, c)
            p.dot(18.6, 9.6, 1.2, d)
        case .g4Suitcase:
            p.svgLine("M9 7V3.8H15V7", c, 1.8)
            p.rect(2.5, 7, 19, 14.5, c, radius: 2.5)
            p.svgLine("M8 7.5V21M16 7.5V21", d, 1.3)
            p.dot(5.5, 22.5, 1.3, c)
            p.dot(18.5, 22.5, 1.3, c)
        case .g4Bed:
            p.rect(1.5, 6, 3, 16, c, radius: 1)
            p.rect(1.5, 13.5, 21, 5, c, radius: 1)
            p.rect(19.5, 11, 3, 11, c, radius: 1)
            p.rect(5.6, 9.4, 7, 3.6, c, radius: 1.8)
            p.rect(4.6, 13.5, 14.8, 1.1, d)
        case .g4Cup:
            p.svgLine("M8 6.5Q6.8 4.5 8 2.5M12 6.5Q10.8 4.5 12 2.5", c, 1.3)
            p.svg("M3.5 9H17V14.5Q17 20 11.5 20H9Q3.5 20 3.5 14.5Z", c)
            p.ring(18.6, 12.6, 2.6, c, 1.8)
            p.rect(1.5, 20.6, 19, 2, c, radius: 1)
        case .g4Wifi:
            p.dot(12, 19.5, 2.2, c)
            p.svgLine("M7.6 14.8A6.4 6.4 0 0 1 16.4 14.8M4.4 11.2A11 11 0 0 1 19.6 11.2M1.4 7.6A15.4 15.4 0 0 1 22.6 7.6", c, 2.2)
        case .g4Paw:
            p.oval(6.5, 11.5, 11, 9.5, c)
            for (x, y) in [(5.0, 9.0), (9.6, 5.4), (14.4, 5.4), (19.0, 9.0)] as [(CGFloat, CGFloat)] {
                p.oval(x - 2.2, y - 2.8, 4.4, 5.6, c)
            }
        default:
            break
        }
    }
}
