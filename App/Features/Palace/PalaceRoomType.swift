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
    case library
    case doctorRoom
    case classroom
    // g6: shops, culture and safety (G6ShopBackdrop, G6GarageBackdrop, G6ConcertBackdrop, G6GalleryBackdrop, G6FireBackdrop)
    case g6Thrift, g6Kiosk, g6Garage, g6ConcertHall, g6Gallery, g6FireStation
    // g1: counter halls (G1CounterHallBackdrop.swift) and the courtroom (G1CourtroomBackdrop.swift)
    case g1Bank, g1PostOffice, g1PoliceDesk, g1HousingDesk
    case g1Courtroom
    // g7: outdoors, water and travel (G7*Backdrop.swift)
    case g7Harbour, g7Mill, g7Farm, g7Beach, g7Camping, g7Airport
    // g2: offices and paperwork (G2*Backdrop.swift). The three service desks share one backdrop.
    case g2TaxOffice, g2Insurer, g2EnergyOffice
    case g2Notary
    case g2Studio
    case g2Loft
    // Group g5 (workshops and culture): see G5Rooms.swift.
    case g5BikeShop, g5DiyStore, g5Cinema, g5Theater, g5Museum, g5Church
    // g3: care and learning places (G3*Backdrop.swift)
    case g3Ward, g3Gym, g3Salon, g3LectureHall

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
        case .library: "bibliotheek"
        case .doctorRoom: "praktijk"
        case .classroom: "klas"
        case .g6Thrift: "winkel"
        case .g6Kiosk: "kiosk"
        case .g6Garage: "garage"
        case .g6ConcertHall: "zaal"
        case .g6Gallery: "galerie"
        case .g6FireStation: "straat"
        case .g1Bank: "bank"
        case .g1PostOffice, .g1PoliceDesk, .g1HousingDesk: "hal"
        case .g1Courtroom: "zaal"
        case .g7Harbour: "haven"
        case .g7Mill: "polder"
        case .g7Farm: "boerderij"
        case .g7Beach: "badplaats"
        case .g7Camping: "omgeving"
        case .g7Airport: "vertrekhal"
        case .g2TaxOffice, .g2Insurer, .g2EnergyOffice: "balie"
        case .g2Notary: "werkkamer"
        case .g2Studio: "studio"
        case .g2Loft: "werkplek"
        case .g5BikeShop, .g5DiyStore, .g5Cinema, .g5Theater, .g5Museum, .g5Church: g5Hall
        case .g3Ward: "zaal"
        case .g3Gym: "sportschool"
        case .g3Salon: "salon"
        case .g3LectureHall: "zaal"
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
        case .library: "De bibliotheek"
        case .doctorRoom: "De praktijk van de dokter"
        case .classroom: "Het klaslokaal"
        case .g6Thrift: "Een tweedehandswinkel"
        case .g6Kiosk: "Een kiosk met kranten en tijdschriften"
        case .g6Garage: "Een garage met een werkplaats"
        case .g6ConcertHall: "Een concertzaal met een orkest en publiek"
        case .g6Gallery: "Een galerie met schilderijen aan witte muren"
        case .g6FireStation: "Een kazerne met een rode wagen, en een huis aan de overkant"
        case .g1Bank: "De hal van de bank, met loketten"
        case .g1PostOffice: "Het postkantoor, met loketten"
        case .g1PoliceDesk: "De balie van het politiebureau"
        case .g1HousingDesk: "De balie van de woningcorporatie"
        case .g1Courtroom: "Een zaal van de rechtbank"
        case .g7Harbour: "Een haven met schepen, een sluis en een kade"
        case .g7Mill: "Een molen in de polder"
        case .g7Farm: "Een boerderij met een stal en weilanden"
        case .g7Beach: "Het strand met de zee en de duinen"
        case .g7Camping: "Een camping met tenten tussen de bomen"
        case .g7Airport: "De vertrekhal van een vliegveld met een groot raam"
        case .g2TaxOffice: "De balie van het belastingkantoor"
        case .g2Insurer: "De balie van de verzekeraar"
        case .g2EnergyOffice: "De balie van het energiebedrijf"
        case .g2Notary: "De werkkamer van de notaris"
        case .g2Studio: "Een televisiestudio"
        case .g2Loft: "Een startup in een oud pakhuis"
        case .g5BikeShop, .g5DiyStore, .g5Cinema, .g5Theater, .g5Museum, .g5Church: g5SceneLabel
        case .g3Ward: "Een zaal in het ziekenhuis"
        case .g3Gym: "De sportschool"
        case .g3Salon: "Een kapsalon met spiegels"
        case .g3LectureHall: "Een zaal van de universiteit met een groot scherm"
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
        case .library: Library.noor
        case .doctorRoom: DoctorRoom.noor
        case .classroom: Classroom.noor
        case .g6Thrift, .g6Kiosk: PalaceShop.noor
        case .g6Garage: G6GarageRoom.noor
        case .g6ConcertHall: G6ConcertRoom.noor
        case .g6Gallery: G6GalleryRoom.noor
        case .g6FireStation: G6FireRoom.noor
        case .g1Bank, .g1PostOffice, .g1PoliceDesk, .g1HousingDesk: G1CounterHall.noor
        case .g1Courtroom: G1Courtroom.noor
        case .g7Harbour: G7Harbour.noor
        case .g7Mill: G7Mill.noor
        case .g7Farm: G7Farm.noor
        case .g7Beach: G7Beach.noor
        case .g7Camping: G7Camping.noor
        case .g7Airport: G7Airport.noor
        case .g2TaxOffice, .g2Insurer, .g2EnergyOffice: G2Service.noor
        case .g2Notary: G2Notary.noor
        case .g2Studio: G2Studio.noor
        case .g2Loft: G2Loft.noor
        case .g5BikeShop, .g5DiyStore, .g5Cinema, .g5Theater, .g5Museum, .g5Church: g5Noor
        case .g3Ward: G3Ward.noor
        case .g3Gym: G3GymRoom.noor
        case .g3Salon: G3SalonRoom.noor
        case .g3LectureHall: G3LectureHall.noor
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
        case .library: Library.slots
        case .doctorRoom: DoctorRoom.slots
        case .classroom: Classroom.slots
        case .g6Thrift, .g6Kiosk: PalaceShop.slots
        case .g6Garage: G6GarageRoom.slots
        case .g6ConcertHall: G6ConcertRoom.slots
        case .g6Gallery: G6GalleryRoom.slots
        case .g6FireStation: G6FireRoom.slots
        case .g1Bank, .g1PostOffice, .g1PoliceDesk, .g1HousingDesk: G1CounterHall.slots
        case .g1Courtroom: G1Courtroom.slots
        case .g7Harbour: G7Harbour.slots
        case .g7Mill: G7Mill.slots
        case .g7Farm: G7Farm.slots
        case .g7Beach: G7Beach.slots
        case .g7Camping: G7Camping.slots
        case .g7Airport: G7Airport.slots
        case .g2TaxOffice, .g2Insurer, .g2EnergyOffice: G2Service.slots
        case .g2Notary: G2Notary.slots
        case .g2Studio: G2Studio.slots
        case .g2Loft: G2Loft.slots
        case .g5BikeShop, .g5DiyStore, .g5Cinema, .g5Theater, .g5Museum, .g5Church: g5Slots
        case .g3Ward: G3Ward.slots
        case .g3Gym: G3GymRoom.slots
        case .g3Salon: G3SalonRoom.slots
        case .g3LectureHall: G3LectureHall.slots
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
        case .library: LibraryBackdrop()
        case .doctorRoom: DoctorRoomBackdrop()
        case .classroom: ClassroomBackdrop()
        case .g6Thrift, .g6Kiosk: G6ShopBackdrop(type: type)
        case .g6Garage: G6GarageBackdrop()
        case .g6ConcertHall: G6ConcertBackdrop()
        case .g6Gallery: G6GalleryBackdrop()
        case .g6FireStation: G6FireBackdrop()
        case .g1Bank, .g1PostOffice, .g1PoliceDesk, .g1HousingDesk: G1CounterHallBackdrop(type: type)
        case .g1Courtroom: G1CourtroomBackdrop()
        case .g7Harbour: G7HarbourBackdrop()
        case .g7Mill: G7MillBackdrop()
        case .g7Farm: G7FarmBackdrop()
        case .g7Beach: G7BeachBackdrop()
        case .g7Camping: G7CampingBackdrop()
        case .g7Airport: G7AirportBackdrop()
        case .g2TaxOffice, .g2Insurer, .g2EnergyOffice: G2ServiceBackdrop(type: type)
        case .g2Notary: G2NotaryBackdrop()
        case .g2Studio: G2StudioBackdrop()
        case .g2Loft: G2LoftBackdrop()
        case .g5BikeShop, .g5DiyStore, .g5Cinema, .g5Theater, .g5Museum, .g5Church: G5RoomBackdrop(type: type)
        case .g3Ward: G3WardBackdrop()
        case .g3Gym: G3GymBackdrop()
        case .g3Salon: G3SalonBackdrop()
        case .g3LectureHall: G3LectureHallBackdrop()
        }
    }
}
