import SwiftUI

/// The objects of a generic room, each drawn in its own box in the gevelkit's flat style.
struct PalaceGenericObjectArt: View {
    let art: PalaceArt

    var body: some View {
        switch art {
        case let .painting(variant):
            PalaceArtwork(marks: Self.frame + Self.paintings[abs(variant) % Self.paintings.count], width: 76, height: 66)
        case .clock:
            PalaceClock().frame(width: 32, height: 32).frame(width: 36, height: 36)
        case .books: PalaceArtwork(marks: Self.books, width: 60, height: 48)
        case .vase: PalaceArtwork(marks: Self.vase, width: 40, height: 52)
        case let .noticeBoard(symbol):
            ZStack(alignment: .topLeading) {
                PalaceArtwork(marks: Self.board, width: 72, height: 58)
                Image(systemName: symbol)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Theme.ink)
                    .frame(width: 22, height: 24)
                    .palaceAt(9, 12)
                    .accessibilityHidden(true)
            }
            .frame(width: 72, height: 58, alignment: .topLeading)
        case .mirror: PalaceArtwork(marks: Self.mirror, width: 42, height: 62)
        case .sillPlant: PalaceArtwork(marks: Self.plant, width: 40, height: 44)
        case .floorLamp: PalaceArtwork(marks: Self.floorLamp(0xF6EBD9), width: 36, height: 112)
        case .desk: PalaceArtwork(marks: Self.desk, width: 96, height: 64)
        case .chair: PalaceArtwork(marks: Self.chair, width: 40, height: 64)
        case let .rug(color): PalaceArtwork(marks: Self.rug(color), width: 150, height: 30)
        case let .coatRack(color): PalaceArtwork(marks: Self.coatRack(color), width: 34, height: 114)
        case .umbrellaStand: PalaceArtwork(marks: Self.umbrellas, width: 30, height: 46)
        default: EmptyView()
        }
    }

    // MARK: Wall

    nonisolated static let frame: [PalaceMark] = [
        .s("M20 12L38 2L56 12", 0x2E2117, 1),
        .dot(38, 2.5, 1.8, 0x2E2117),
        .f("M4 10H72V62H4Z", 0xC9A15B),
        .s("M6.5 12.5H69.5V59.5H6.5Z", 0xE3D6BC, 1),
        .f("M9 15H67V57H9Z", 0xBCCDD6),
    ]

    nonisolated static let paintings: [[PalaceMark]] = [
        // Polder with a windmill
        [
            .dot(22, 25, 4, 0xFAC775),
            .f("M9 44C24 38 44 42 67 39V57H9Z", 0xA9C795),
            .f("M9 50C28 46 46 50 67 47V57H9Z", 0x6E9C52),
            .f("M50 31H54L56 45H48Z", 0x4A3524),
            .s("M44 24L60 38M60 24L44 38", 0x2E2117, 1.6, round: true),
        ],
        // Sea with a sailing boat
        [
            .f("M9 15H67V40H9Z", 0xD9DED9),
            .f("M9 40H67V57H9Z", 0x8FB6CF),
            .s("M13 47q3 -2 6 0t6 0M41 52q3 -2 6 0t6 0", 0xFFFFFF, 1),
            .f("M27 41H51L47 46H31Z", 0x6B4A2E),
            .f("M39 40V20L50 40Z", 0xF4F1EA),
            .f("M38 40V25L30 40Z", 0xC8261B),
        ],
        // Tulip field with a farm
        [
            .f("M9 15H67V36H9Z", 0xE8E2D2),
            .f("M44 24H58V36H44Z", 0x7B3F2E),
            .f("M42 25L51 17L60 25Z", 0x2C2C2A),
            .f("M49 29H53V36H49Z", 0xEFEBE2),
            .f("M9 36H67V41H9Z", 0xC8261B),
            .f("M9 41H67V46H9Z", 0xFAC775),
            .f("M9 46H67V51H9Z", 0xF4C0D1),
            .f("M9 51H67V57H9Z", 0x6E9C52),
        ],
    ]

    nonisolated static let books: [PalaceMark] = [
        .f("M4 18H12V48H4Z", 0x2F5BD3),
        .f("M13 12H20V48H13Z", 0xC8261B),
        .f("M21 20H30V48H21Z", 0xFAC775),
        .f("M31 14H38V48H31Z", 0x0F6E56),
        .f("M40 48L51 23L57 26L46 48Z", 0x3C3489),
        .s("M4 23H12M13 17H20M21 25H30M31 19H38", 0xF4F1EA, 1),
    ]

    nonisolated static let vase: [PalaceMark] = [
        .s("M20 30V12M20 30C18 22 13 17 10 13M20 30C22 22 27 16 30 11", 0x4E7A3A, 1.6, round: true),
        .f("M7 13C7 6 13 6 13 13C12 16 8 16 7 13Z", 0xC8261B),
        .f("M17 10C17 3 23 3 23 10C22 13 18 13 17 10Z", 0xF2711C),
        .f("M27 11C27 4 33 4 33 11C32 14 28 14 27 11Z", 0xF4C0D1),
        .f("M14 52C8 46 9 38 15 33V28H25V33C31 38 32 46 26 52Z", 0x1F3A6B),
        .f("M14 28H26V30H14Z", 0x2B4C86),
        .s("M15 42C17 38 23 38 25 42C23 46 17 46 15 42Z M20 36V48", 0xFFFFFF, 1),
    ]

    nonisolated static let board: [PalaceMark] = [
        .f("M0 0H72V58H0Z", 0x7A5230),
        .f("M4 4H68V54H4Z", 0xC9965F),
        .f("M9 9H31V37H9Z", 0xFFFFFF),
        .f("M36 8H63V26H36Z", 0xFAC775),
        .s("M39 14H59M39 18H56M39 22H50", 0x8A3B12, 1),
        .f("M37 30H61V49H37Z", 0xC9E6E2),
        .s("M40 36H57M40 40H54M40 44H49", 0x04342C, 1),
        .f("M10 41H29V51H10Z", 0xF4C0D1),
        .dot(20, 11, 2, 0xC8261B),
        .dot(49, 10, 2, 0x2F5BD3),
        .dot(49, 32, 2, 0x1E7A4C),
        .dot(19, 43, 2, 0xF2711C),
    ]

    nonisolated static let mirror: [PalaceMark] = [
        .dot(21, 3, 1.6, 0x2E2117),
        .oval(1, 2, 40, 60, 0xC9A15B),
        .oval(5, 6, 32, 52, 0xDCE3DF),
        .f("M11 22C12 16 16 12 21 11L13 28Z", 0xFFFFFF, 0.7),
        .f("M14 40L27 18L29 21L16 44Z", 0xFFFFFF, 0.35),
    ]

    nonisolated static let plant: [PalaceMark] = [
        .f("M20 28C14 20 8 18 3 10C12 11 18 18 20 28Z", 0x5E8C45),
        .f("M20 28C22 18 27 10 36 6C34 16 27 22 20 28Z", 0x4E7A3A),
        .f("M20 28C17 16 19 7 22 1C26 9 24 19 20 28Z", 0x6E9C52),
        .dot(22, 4, 2.6, 0xC8261B),
        .f("M10 29H30L27 44H13Z", 0xA3410A),
        .f("M8 26H32V31H8Z", 0x8A3B12),
    ]

    // MARK: Floor

    nonisolated static func floorLamp(_ shade: UInt32) -> [PalaceMark] {
        [
            .f("M10 26H26L34 64H2Z", 0xFAC775, 0.16),
            .f("M6 24L12 2H24L30 24Z", shade),
            .f("M6 23H30V26H6Z", PalaceInk.shade(shade, 0.8)),
            .f("M17 26H19V106H17Z", 0x2E2117),
            .oval(8, 104, 20, 7, 0x2E2117),
        ]
    }

    nonisolated static let desk: [PalaceMark] = [
        .f("M76 2H92L96 13H72Z", 0x0F6E56),
        .s("M80 20L84 8", 0x1E1E1C, 2, round: true),
        .f("M74 19H88V22H74Z", 0x1E1E1C),
        .f("M14 22L19 16H42L39 22Z", 0xFFFFFF),
        .s("M22 18.5H36", 0xB4B2A9, 1),
        .f("M50 12H58V22H50Z", 0x2F5BD3),
        .s("M58 14q4 0 4 3t-4 3", 0x2F5BD3, 1.5),
        .f("M0 22H96V28H0Z", 0x7A5230),
        .f("M0 28H96V31H0Z", 0x4A3524),
        .f("M10 31H50V43H10Z", 0x6B4A2E),
        .dot(30, 37, 1.6, 0xC9A15B),
        .f("M4 31H9V64H4Z M87 31H92V64H87Z", 0x4A3524),
    ]

    nonisolated static let chair: [PalaceMark] = [
        .f("M8 0H32V4H8Z", 0x4A3524),
        .f("M9 4H12V32H9Z M18.5 4H21.5V32H18.5Z M28 4H31V32H28Z", 0x4A3524),
        .f("M6 28H34V33H6Z", 0xC8261B),
        .f("M4 32H36V38H4Z", 0x7A5230),
        .f("M6 38H10V64H6Z M30 38H34V64H30Z", 0x4A3524),
        .f("M10 52H30V54.5H10Z", 0x4A3524),
    ]

    nonisolated static func rug(_ color: UInt32) -> [PalaceMark] {
        [
            .f("M8 4H142V26H8Z", color),
            .s("M13 8H137V22H13Z", 0xF4F1EA, 1.5),
            .f("M40 15L46 10L52 15L46 20Z M69 15L75 10L81 15L75 20Z M98 15L104 10L110 15L104 20Z", 0xFAC775),
            .s("M8 6H3M8 10H3M8 14H3M8 18H3M8 22H3M142 6H147M142 10H147M142 14H147M142 18H147M142 22H147", 0xD9CDB4, 1.2),
        ]
    }

    nonisolated static func coatRack(_ coat: UInt32) -> [PalaceMark] {
        [
            .f("M15 10H19V108H15Z", 0x2E2117),
            .f("M5 108H29V114H5Z", 0x2E2117),
            .s("M17 18L7 13M17 18L27 13", 0x2E2117, 2, round: true),
            .f("M10 18C14 15 20 15 24 18L30 70H4Z", coat),
            .f("M13 17L17 25L21 17Z", 0xEFEBE2),
            .f("M11 22H23V26H11Z M19 26H23V42H19Z", 0xFAC775),
            .dot(16, 34, 1.2, 0x2E2117),
            .dot(16, 44, 1.2, 0x2E2117),
            .dot(16, 54, 1.2, 0x2E2117),
            .f("M11 0H23V9H11Z", 0x1E1E1C),
            .f("M7 8H27V11H7Z", 0x1E1E1C),
        ]
    }

    nonisolated static let umbrellas: [PalaceMark] = [
        .s("M10 20V5Q10 1 14 1", 0x1E1E1C, 1.6, round: true),
        .f("M17 22L20 3L23 22Z", 0xC8261B),
        .s("M20 3V0", 0x1E1E1C, 1.2),
        .f("M3 18H27V21H3Z", 0x3E4C55),
        .f("M4 21H26L24 46H6Z", 0x5E6B73),
        .f("M5 27H25V29H5Z M5.5 38H24.5V40H5.5Z", 0x3E4C55),
    ]
}
