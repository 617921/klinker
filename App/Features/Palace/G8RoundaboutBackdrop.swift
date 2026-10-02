import SwiftUI

enum G8Roundabout {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [:]
}

struct G8RoundaboutBackdrop: View, Equatable {
    var body: some View {
        PalaceOutdoorBackdrop(houses: [], scale: 1, skyHeight: 408, marks: [])
    }
}
