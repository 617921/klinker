import SwiftUI

/// Noor, the newcomer, standing in the room (44 × 112, the prototype's standing pose).
struct PalaceNoor: View {
    var facingLeft = false

    nonisolated static let marks: [PalaceMark] = [
        .f("M8 109a14 3 0 1 0 28 0a14 3 0 1 0 -28 0Z", 0x1E1E1C, 0.16),
        .s("M17 82V104M27 82V104", 0x1E1E1C, 5, round: true),
        .f("M12 103H21V108H12Z M23 103H32V108H23Z", 0x2E2117),
        .f("M8 86C8 54 11 34 22 32C33 34 36 54 36 86Z", 0x993556),
        .s("M15 34L30 62", 0x2E2117, 2),
        .f("M25 60H36V71H25Z", 0xC9A15B),
        .f("M14 29H30V35H14Z", 0xFAC775),
        .dot(22, 18, 11, 0xC99A74),
        .f("M11 18C10 9 16 5 22 5C29 5 34 10 33 19C30 13 26 11 21 12C17 12 13 14 11 18Z", 0x2E2117),
        .dot(11.5, 10, 4.5, 0x2E2117),
        .dot(28, 19, 1.3, 0x2E2117),
        .s("M31 40C36 50 36 60 34 68", 0x7A2A44, 6, round: true),
        .dot(34, 70, 3.2, 0xC99A74),
    ]

    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 44, height: 112)
            .scaleEffect(x: facingLeft ? -1 : 1, y: 1)
            .accessibilityHidden(true)
    }
}
