import SwiftUI

// Group g5 (workshops and culture): the bike shop and the DIY store reuse the shop interior with
// their own looks; the cinema and the theatre share one hall (G5HallBackdrop.swift); the museum and
// the church have their own rooms. PalaceRoomType's switches route every g5 case through here.

extension PalaceRoomType {
    var g5Hall: String {
        switch self {
        case .g5BikeShop: "werkplaats"
        case .g5DiyStore: "bouwmarkt"
        case .g5Cinema, .g5Theater: "zaal"
        case .g5Museum: "museumzaal"
        default: "kerk"
        }
    }

    var g5SceneLabel: String {
        switch self {
        case .g5BikeShop: "De werkplaats van de fietsenmaker"
        case .g5DiyStore: "De bouwmarkt"
        case .g5Cinema: "Een donkere filmzaal met een groot scherm"
        case .g5Theater: "Een schouwburg met een rood doek en loges"
        case .g5Museum: "Een zaal in een museum met schilderijen"
        default: "Een oude Hollandse kerk van binnen"
        }
    }

    var g5Noor: CGPoint {
        switch self {
        case .g5BikeShop, .g5DiyStore: PalaceShop.noor
        case .g5Cinema, .g5Theater: G5Hall.noor
        case .g5Museum: G5Museum.noor
        default: G5Church.noor
        }
    }

    var g5Slots: [String: PalaceSlot] {
        switch self {
        case .g5BikeShop, .g5DiyStore: PalaceShop.slots
        case .g5Cinema, .g5Theater: G5Hall.slots
        case .g5Museum: G5Museum.slots
        default: G5Church.slots
        }
    }
}

/// The backdrop of a g5 room.
struct G5RoomBackdrop: View, Equatable {
    let type: PalaceRoomType

    var body: some View {
        switch type {
        case .g5BikeShop, .g5DiyStore: ShopBackdrop(type: type)
        case .g5Cinema, .g5Theater: G5HallBackdrop(theater: type == .g5Theater)
        case .g5Museum: G5MuseumBackdrop()
        default: G5ChurchBackdrop()
        }
    }
}

extension ShopLook {
    /// The bike shop's workshop: steel-grey shelves on a pale wall, navy trim, a concrete floor.
    nonisolated static let g5Bike = ShopLook(
        wall: 0xDCE3DF, trim: 0x1F3A6B, shelf: 0x5E6B73, shelfBack: 0xC9D3D3, counterTop: 0xC9965F,
        counterFront: 0x3E4C55, panel: 0x2E3A42, floor: 0xD3D1C7, tile: 0xB4B2A9, counter: "wood",
        houses: [
            PalaceHouse(type: .hals, width: 62, floors: 3, cols: 2, doorLeft: false, shop: true, flowers: false,
                        color: 0x7B3F2E, door: 0x1F3A6B, awning: 0xFAC775),
            PalaceHouse(type: .trap, width: 62, floors: 3, cols: 2, doorLeft: true, shop: false, flowers: true,
                        color: 0xD9CDB4, door: 0x7A1E1E, awning: 0x2F4B3A),
        ])

    /// The DIY store: orange trim, steel racking, a wooden workbench counter.
    nonisolated static let g5Diy = ShopLook(
        wall: 0xEFE6D6, trim: 0xD9601A, shelf: 0x5E6B73, shelfBack: 0xD9CDB4, counterTop: 0xC9965F,
        counterFront: 0xD9601A, panel: 0xB24E14, floor: 0xDAD6CA, tile: 0xC4BFB2, counter: "wood",
        houses: [
            PalaceHouse(type: .lijst, width: 62, floors: 3, cols: 2, doorLeft: true, shop: false, flowers: true,
                        color: 0x5E6B73, door: 0x24533F, awning: 0xC8261B),
            PalaceHouse(type: .klok, width: 62, floors: 3, cols: 2, doorLeft: false, shop: true, flowers: false,
                        color: 0x9A5238, door: 0x1F3A6B, awning: 0x0F6E56),
        ])
}
