import SwiftUI

/// Day or night in the city: follows the clock unless the learner picks one in the menu.
enum StadLight: String, CaseIterable, Identifiable {
    case auto, day, night

    static let storageKey = "klinker.light"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .auto: "Volgt de klok"
        case .day: "Altijd dag"
        case .night: "Altijd nacht"
        }
    }

    var systemImage: String {
        switch self {
        case .auto: "clock"
        case .day: "sun.max"
        case .night: "moon"
        }
    }
}
