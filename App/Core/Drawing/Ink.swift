import SwiftUI

/// Colours for the illustrations (city, palaces, house). Usable from any isolation, unlike
/// Theme's `Color(hex:)`, which is main-actor bound, so Canvas painters and static tables can use it.
nonisolated enum Ink {
    static func hex(_ value: UInt32, _ opacity: Double = 1) -> Color {
        Color(
            .sRGB,
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255,
            opacity: opacity
        )
    }

    /// Multiplies each channel by `f` (prototype `shade(hex, f)`).
    static func shade(_ value: UInt32, _ f: Double) -> UInt32 {
        func ch(_ v: UInt32) -> UInt32 { UInt32(max(0, min(255, Gevelkit.jsRound(Double(v) * f)))) }
        return (ch((value >> 16) & 0xFF) << 16) | (ch((value >> 8) & 0xFF) << 8) | ch(value & 0xFF)
    }
}
