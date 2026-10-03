import SwiftUI

/// Map colours by day and by night, per season (StadKaart `mapGeo`, plus seasons):
/// fresh green and blossom in spring, gold in autumn, snow and ice in winter.
nonisolated struct KaartColors: Sendable {
    let ground, north, northEdge, meadow, sand, dike, runway: Color
    let streetCase, street, park, parkPath, water, edge, rail, jetty, mooredA, mooredB: Color
    let tree, treeDark, treeAlt, waterLabel, landLabel: Color
    /// Field rows: the row colour and the soil between rows, one pair per field look.
    let fields: [(row: Color, soil: Color)]
    /// Winter: canals freeze, boats stay in, roofs turn white.
    let frozen: Bool

    init(night: Bool, season: GevelSeason = .zomer) {
        let h = { (v: UInt32) in StadInk.hex(v) }
        let winter = season == .winter
        frozen = winter
        ground = h(night ? 0x20263A : Self.pick(season, 0xEDE9D8, 0xEDE7D6, 0xEBE3CF, 0xEFF0EB))
        north = h(night ? 0x262C3F : winter ? 0xE6E8E3 : 0xE3DCC8)
        northEdge = h(night ? 0x3A3F4E : 0x6E6B64)
        meadow = h(night ? 0x263126 : Self.pick(season, 0xD9E7C4, 0xE1E6CF, 0xDFDBC0, 0xE8ECE6))
        sand = h(night ? 0x3E3B33 : winter ? 0xEDE8DA : 0xEADFC2)
        dike = h(night ? 0x2B3B2E : Self.pick(season, 0xB3D196, 0xBCD1A3, 0xC4C99A, 0xDDE4D9))
        runway = h(night ? 0x3A3E48 : 0x8E8B83)
        streetCase = h(night ? 0x3A3F4E : winter ? 0xD9D6CC : 0xD6CCB4)
        street = h(night ? 0x4B5163 : 0xFFFFFF)
        park = h(night ? 0x26392F : Self.pick(season, 0xC6E2B2, 0xCFE0C0, 0xD8D9B2, 0xE1E7DF))
        parkPath = h(night ? 0x3D4A3F : 0xE9DFC6)
        water = h(night ? (winter ? 0x3A4A66 : 0x2B3A58) : (winter ? 0xD5E6EE : 0xA9CBE0))
        edge = h(night ? (winter ? 0x2A3550 : 0x1D2A44) : (winter ? 0xA7C3D2 : 0x8FB6CF))
        rail = h(night ? 0x8A8F9E : 0xEFEBE2)
        jetty = h(night ? 0x2E2117 : 0x4A3524)
        mooredA = h(night ? 0x1F3328 : 0x2F4B3A)
        mooredB = h(night ? 0x4A1A1A : 0x7A1E1E)
        waterLabel = h(night ? 0x9FB4D4 : 0x2C5674)
        landLabel = h(night ? 0x8A9488 : 0x5F5E5A)

        let trees: (UInt32, UInt32, UInt32) = switch (season, night) {
        case (.lente, false): (0x8DBE5A, 0x5E8C45, 0xF4C0D1)
        case (.zomer, false): (0x6E9C52, 0x4E7A3A, 0x5E8C45)
        case (.herfst, false): (0xD9A441, 0xA3410A, 0xC7772E)
        case (.winter, false): (0xF5F6F2, 0xB4BCC4, 0xE6E9E4)
        case (.lente, true): (0x2C4A32, 0x1F3526, 0x5A4652)
        case (.zomer, true): (0x2C4A32, 0x1F3526, 0x263F2B)
        case (.herfst, true): (0x5A4426, 0x3E2A18, 0x4E3520)
        case (.winter, true): (0x5D6880, 0x2E3446, 0x4D586C)
        }
        tree = h(trees.0)
        treeDark = h(trees.1)
        treeAlt = h(trees.2)

        let pairs: [(UInt32, UInt32)] = switch season {
        // Bulb fields: red, yellow, pink, orange, purple and white tulips in green rows.
        case .lente: [(0xD8342C, 0x5E8C45), (0xF2C53D, 0x5E8C45), (0xE58BB0, 0x5E8C45), (0xF2711C, 0x5E8C45), (0x7B4FA0, 0x5E8C45), (0xFFFDF6, 0x6E9C52)]
        case .zomer: [(0xE2C66B, 0xCDB056), (0x9CBF6B, 0x86AD58), (0xC9D98F, 0xB2C77A), (0x7FA65A, 0x6C9449)]
        case .herfst: [(0xA07B55, 0x86643F), (0xB89470, 0x9E7B58), (0x8FA85C, 0x7D9650), (0xC9A15B, 0xAE8B4C)]
        case .winter: [(0xEEF0EC, 0xD3D9D1), (0xE6EAE5, 0xCCD3CB), (0xF2F3F0, 0xDADFD8)]
        }
        let f = night ? 0.4 : 1
        fields = pairs.map { (h(Gevelkit.shade($0.0, f)), h(Gevelkit.shade($0.1, f * 0.9))) }
    }

    private static func pick(_ season: GevelSeason, _ lente: UInt32, _ zomer: UInt32, _ herfst: UInt32, _ winter: UInt32) -> UInt32 {
        switch season {
        case .lente: lente
        case .zomer: zomer
        case .herfst: herfst
        case .winter: winter
        }
    }
}
