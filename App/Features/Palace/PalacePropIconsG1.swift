import SwiftUI

/// Pictograms added for the g1 places, in the same 24 × 24 box as `PalaceIcon` (one colour `c`,
/// cut-out colour `d`). `g1Badge`: a generic police badge, a shield with a star (no real emblem).
enum G1Icons {
    @MainActor static func draw(_ icon: PalaceIcon, _ p: PropPen, _ c: UInt32, _ d: UInt32) {
        switch icon {
        case .g1Badge:
            p.svg("M12 1.5L21 5V12C21 17.5 17 21 12 22.8C7 21 3 17.5 3 12V5Z", c)
            p.svg(PalacePeople.star(cx: 12, cy: 12, r: 6.4), d)
        default:
            break
        }
    }
}
