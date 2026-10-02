import SwiftUI

/// Pictograms of the city outdoors and the finale, in the same 24 × 24 box as `PalaceIcon`.
/// The dove's olive branch stays green: the colour is part of the meaning.
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
        default:
            break
        }
    }
}
