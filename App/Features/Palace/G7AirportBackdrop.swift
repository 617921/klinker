import SwiftUI

enum G7Airport {
    static let noor = CGPoint(x: 160, y: 292)
    nonisolated static let slots: [String: PalaceSlot] = [:]
}

struct G7AirportBackdrop: View, Equatable {
    var body: some View { Color.clear.frame(width: 370, height: 408) }
}
