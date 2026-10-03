import Foundation

/// A part of a building that the Gevelplaat can point at, with its Dutch word.
nonisolated enum GevelDeel: String, CaseIterable, Hashable, Sendable {
    case gevel, dak, raam, deur, uithangbord, toren, koepel, zuil, hijsbalk, stoep, luifel, kraam
    case vlag, bloembak, lantaarn, gordijn, baksteen, steiger, wiek

    var nl: String {
        switch self {
        case .gevel: "gevel"
        case .dak: "dak"
        case .raam: "raam"
        case .deur: "deur"
        case .uithangbord: "uithangbord"
        case .toren: "toren"
        case .koepel: "koepel"
        case .zuil: "zuil"
        case .hijsbalk: "hijsbalk"
        case .stoep: "stoep"
        case .luifel: "luifel"
        case .kraam: "kraam"
        case .vlag: "vlag"
        case .bloembak: "bloembak"
        case .lantaarn: "lantaarn"
        case .gordijn: "gordijn"
        case .baksteen: "baksteen"
        case .steiger: "steiger"
        case .wiek: "wiek"
        }
    }

    var article: Article {
        switch self {
        case .dak, .raam, .uithangbord, .gordijn: .het
        default: .de
        }
    }

    var en: String {
        switch self {
        case .gevel: "facade"
        case .dak: "roof"
        case .raam: "window"
        case .deur: "door"
        case .uithangbord: "shop sign"
        case .toren: "tower"
        case .koepel: "dome"
        case .zuil: "column"
        case .hijsbalk: "hoisting beam"
        case .stoep: "front step"
        case .luifel: "awning"
        case .kraam: "market stall"
        case .vlag: "flag"
        case .bloembak: "flower box"
        case .lantaarn: "lantern"
        case .gordijn: "curtain"
        case .baksteen: "brick"
        case .steiger: "scaffolding"
        case .wiek: "sail (of a windmill)"
        }
    }

    /// Which parts a plate shows first (it shows at most a handful).
    static let priority: [GevelDeel] = [
        .gevel, .dak, .raam, .deur, .uithangbord, .wiek, .toren, .koepel, .zuil, .hijsbalk, .steiger,
        .stoep, .luifel, .kraam, .vlag, .bloembak, .lantaarn, .gordijn, .baksteen,
    ]
}
