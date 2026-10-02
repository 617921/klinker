import SwiftUI

/// Pictograms of the city outdoors and the finale, in the same 24 × 24 box as `PalaceIcon`:
/// a ballot box, a dove of peace, the city ferry and a storm cloud. The dove's olive branch stays
/// green and the storm's lightning yellow: the colour is part of the meaning.
enum G8Icons {
    static func draw(_ icon: PalaceIcon, _ p: PropPen, _ c: UInt32, _ d: UInt32) {
        switch icon {
        case .g8BallotBox:
            p.rect(8.6, 0.8, 6.8, 10, c, radius: 0.6)
            p.svgLine("M10.4 3.6L13.6 7.2M13.6 3.6L10.4 7.2", d, 1.1)
            p.rect(2.2, 10.2, 19.6, 12.6, c, radius: 1.6)
            p.rect(6.6, 12, 10.8, 2, d, radius: 0.6)
            p.svgLine("M5 18.6H19", d, 0.9)
        case .g8Dove:
            p.svg("M2 13.4C4.6 10.6 8.4 9.8 12.2 10.6L16.4 8.2C18.4 7 20.8 7.6 21.4 9.4L19.6 10.6C19.6 15 16 18 11.2 18C7.6 18 4.4 16.4 2 13.4Z", c)
            p.svg("M7.6 11.4C6.2 6.6 8.4 2.4 13.6 1C13.8 5.4 12.8 9 10.6 11.6Z", c)
            p.svg("M2.6 13.6L0.2 11.2L0.6 16.2Z", c)
            p.dot(18.8, 9.2, 0.75, d)
            p.svgLine("M21.2 10L23.6 13.6", 0x4E7A3A, 0.9)
            p.oval(21.6, 11.2, 2.4, 1.3, 0x5E8C45)
            p.oval(22.2, 13.2, 1.6, 2.2, 0x5E8C45)
        case .g8Ferry:
            p.rect(8.6, 5, 6.8, 6.4, c, radius: 0.8)
            p.rect(9.8, 6.4, 4.4, 2.4, d)
            p.rect(11.3, 2, 1.4, 3.4, c)
            p.svgLine("M10 11.4V14M14 11.4V14", c, 1.2)
            p.svg("M0.6 14H23.4L21.4 19H2.6Z", c)
            p.rect(2.6, 15.4, 18.8, 1, d)
            p.svgLine("M0.6 22Q3.6 20.4 6.6 22T12.6 22T18.6 22T24.6 22", c, 1.2)
        case .g8Storm:
            p.dot(8, 8.6, 5, c)
            p.dot(14.6, 7, 6, c)
            p.rect(3, 8, 18.6, 6.6, c, radius: 3.3)
            p.svg("M12.4 13L9.4 18.4H12L10.2 23.4L16 16.2H13.2L15 13Z", 0xFAC775)
            p.svgLine("M5 17L3.6 20.6M19 17L17.6 20.6", c, 1.4)
        default:
            break
        }
    }
}
