import SwiftUI

enum G8TownSquare {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [:]
}

struct G8TownSquareBackdrop: View, Equatable {
    var body: some View {
        PalaceOutdoorBackdrop(houses: [], scale: 1, skyHeight: 408, marks: [])
    }
}
