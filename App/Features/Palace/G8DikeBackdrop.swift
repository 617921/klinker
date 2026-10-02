import SwiftUI

enum G8Dike {
    static let noor: CGPoint? = nil

    nonisolated static let slots: [String: PalaceSlot] = [:]
}

struct G8DikeBackdrop: View, Equatable {
    var body: some View {
        PalaceOutdoorBackdrop(houses: [], scale: 1, skyHeight: 408, marks: [])
    }
}
