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
    // g2: offices and paperwork (G2*Backdrop.swift). The three service desks share one backdrop.
    case g2TaxOffice, g2Insurer, g2EnergyOffice
    case g2Notary
    case g2Studio
    case g2Loft

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
        case .g2TaxOffice, .g2Insurer, .g2EnergyOffice: "balie"
        case .g2Notary: "werkkamer"
        case .g2Studio: "studio"
        case .g2Loft: "werkplek"
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
        case .g2TaxOffice: "De balie van het belastingkantoor"
        case .g2Insurer: "De balie van de verzekeraar"
        case .g2EnergyOffice: "De balie van het energiebedrijf"
        case .g2Notary: "De werkkamer van de notaris"
        case .g2Studio: "Een televisiestudio"
        case .g2Loft: "Een startup in een oud pakhuis"
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
        case .g2TaxOffice, .g2Insurer, .g2EnergyOffice: G2Service.noor
        case .g2Notary: G2Notary.noor
        case .g2Studio: G2Studio.noor
        case .g2Loft: G2Loft.noor
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
        case .g2TaxOffice, .g2Insurer, .g2EnergyOffice: G2Service.slots
        case .g2Notary: G2Notary.slots
        case .g2Studio: G2Studio.slots
        case .g2Loft: G2Loft.slots
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
        case .g2TaxOffice, .g2Insurer, .g2EnergyOffice: G2ServiceBackdrop(type: type)
        case .g2Notary: G2NotaryBackdrop()
        case .g2Studio: G2StudioBackdrop()
        case .g2Loft: G2LoftBackdrop()
        }
    }
}
