import SwiftUI

/// The g4 room types (care, community and hospitality): their room word, scene label, Noor's
/// spot, named slots and backdrop. `PalaceRoomType` forwards its switches here.
enum G4Rooms {
    static func hall(_ type: PalaceRoomType) -> String {
        switch type {
        case .g4Pool: "zwemhal"
        case .g4Daycare: "groepsruimte"
        case .g4CommunityHall: "zaal"
        case .g4HotelLobby: "lobby"
        case .g4Restaurant: "eetzaal"
        default: "ruimte"
        }
    }

    static func sceneLabel(_ type: PalaceRoomType) -> String {
        switch type {
        case .g4Pool: "Een binnenzwembad met een glijbaan en een springplank"
        case .g4Daycare: "Een vrolijke speelkamer voor kleine kinderen"
        case .g4CommunityHall: "Een zaal in de buurt met een koffieluik"
        case .g4HotelLobby: "Een hotel: twee kamers boven, de lobby beneden"
        case .g4Restaurant: "Een restaurant met een open keuken"
        default: ""
        }
    }

    static func noor(_ type: PalaceRoomType) -> CGPoint? {
        switch type {
        case .g4Pool: G4Pool.noor
        case .g4Daycare: G4Daycare.noor
        case .g4CommunityHall: G4CommunityHall.noor
        case .g4HotelLobby: G4HotelLobby.noor
        case .g4Restaurant: G4Restaurant.noor
        default: nil
        }
    }

    static func slots(_ type: PalaceRoomType) -> [String: PalaceSlot] {
        switch type {
        case .g4Pool: G4Pool.slots
        case .g4Daycare: G4Daycare.slots
        case .g4CommunityHall: G4CommunityHall.slots
        case .g4HotelLobby: G4HotelLobby.slots
        case .g4Restaurant: G4Restaurant.slots
        default: [:]
        }
    }
}

/// The backdrop of a g4 room type.
struct G4RoomBackdrop: View, Equatable {
    let type: PalaceRoomType

    var body: some View {
        Group {
            switch type {
            case .g4Pool: PalaceArtwork(marks: G4PoolBackdrop.marks, width: 370, height: 408)
            case .g4Daycare: PalaceArtwork(marks: G4DaycareBackdrop.marks, width: 370, height: 408)
            case .g4CommunityHall: PalaceArtwork(marks: G4CommunityHallBackdrop.marks, width: 370, height: 408)
            case .g4HotelLobby: PalaceArtwork(marks: G4HotelBackdrop.marks, width: 370, height: 408)
            case .g4Restaurant: PalaceArtwork(marks: G4RestaurantBackdrop.marks, width: 370, height: 408)
            default: Color.clear
            }
        }
        .frame(width: 370, height: 408, alignment: .topLeading)
        .accessibilityHidden(true)
    }
}
