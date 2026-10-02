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
        case .g3Ward: G3WardBackdrop()
        case .g3Gym: G3GymBackdrop()
        case .g3Salon: G3SalonBackdrop()
        case .g3LectureHall: G3LectureHallBackdrop()
        }
    }
}
