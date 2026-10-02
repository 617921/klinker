import SwiftUI

/// Where a prop stands in a room type (its tap box, in scene points) and where its strip hangs.
nonisolated struct PalaceSlot: Sendable {
    var frame: CGRect
    var pin: CGPoint
    var align: PalacePinAlign = .leading
    var tilt: Double = 0
}

/// The rooms that anchored places are built in. Each type draws its own backdrop and names the
/// slots where props fit, so a new place of the same kind only needs lines in anchors.json.
/// Raw values are the names used in anchors.json (`type`).
enum PalaceRoomType: String, CaseIterable {
    case stationHall
    // Shops (one interior, three looks): see ShopBackdrop.swift.
    case bakery, supermarket, pharmacy
    case marketSquare
    case park
    case tramStop
    case livingRoom
    case brownCafe
    case office

    /// The room word in the panels: "Verken de hal", "Kijk goed naar de hal…".
    var hall: String {
        switch self {
        case .stationHall: "hal"
        case .bakery: "bakkerij"
        case .supermarket: "supermarkt"
        case .pharmacy: "apotheek"
        case .marketSquare: "omgeving"
        case .park: "omgeving"
        case .tramStop: "straat"
        case .livingRoom: "kamer"
        case .brownCafe: "kroeg"
        case .office: "kantoortuin"
        }
    }

    /// VoiceOver name of the whole scene.
    var sceneLabel: String {
        switch self {
        case .stationHall: "De stationshal"
        case .bakery: "De bakkerij"
        case .supermarket: "De supermarkt"
        case .pharmacy: "De apotheek"
        case .marketSquare: "De markt op het plein"
        case .park: "Het park"
        case .tramStop: "De tramhalte in de straat"
        case .livingRoom: "De woonkamer van een grachtenhuis"
        case .brownCafe: "Een bruin café met een terras"
        case .office: "Een kantoortuin"
        }
    }

    /// Where Noor stands by default (top-left of her 44 × 112 figure).
    var noor: CGPoint? {
        switch self {
        case .stationHall: StationHall.noor
        case .bakery, .supermarket, .pharmacy: PalaceShop.noor
        case .marketSquare: MarketSquare.noor
        case .park: CityPark.noor
        case .tramStop: TramStop.noor
        case .livingRoom: LivingRoom.noor
        case .brownCafe: BrownCafe.noor
        case .office: OfficeFloor.noor
        }
    }

    var slots: [String: PalaceSlot] {
        switch self {
        case .stationHall: StationHall.slots
        case .bakery, .supermarket, .pharmacy: PalaceShop.slots
        case .marketSquare: MarketSquare.slots
        case .park: CityPark.slots
        case .tramStop: TramStop.slots
        case .livingRoom: LivingRoom.slots
        case .brownCafe: BrownCafe.slots
        case .office: OfficeFloor.slots
        }
    }
}

/// The backdrop (everything that carries no word) of an anchored room.
struct PalaceRoomTypeBackdrop: View, Equatable {
    let type: PalaceRoomType

    var body: some View {
        switch type {
        case .stationHall: StationHallBackdrop()
        case .bakery, .supermarket, .pharmacy: ShopBackdrop(type: type)
        case .marketSquare: MarketSquareBackdrop()
        case .park: ParkBackdrop()
        case .tramStop: TramStopBackdrop()
        case .livingRoom: LivingRoomBackdrop()
        case .brownCafe: BrownCafeBackdrop()
        case .office: OfficeBackdrop()
        }
    }
}
