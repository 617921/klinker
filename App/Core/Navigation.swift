import SwiftUI

/// What a round plays: the full mixed round, or one game on its own.
enum RoundKind: String, Identifiable, CaseIterable {
    case full, match, balloons, ransom

    var id: String { rawValue }

    var title: String {
        switch self {
        case .full: "Je ronde"
        case .match: "Match rush"
        case .balloons: "Ballonnen"
        case .ransom: "Knip & plak"
        }
    }
}

/// A place to walk into (its memory palace).
struct PlaceVisit: Identifiable, Hashable {
    let sheetNumber: Int
    var id: Int { sheetNumber }
}

extension EnvironmentValues {
    /// Starts a round full screen. Set by `RootView`.
    @Entry var startRound: (RoundKind) -> Void = { _ in }
    /// Opens a place's memory palace full screen. Set by `RootView`.
    @Entry var enterPlace: (Int) -> Void = { _ in }
}
