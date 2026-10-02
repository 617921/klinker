import SwiftUI

/// The room types of the city outdoors and the finale: the allotment (volkstuin), the square in
/// front of the town hall, a roundabout, a dike, the ferry landing and the top of the lookout
/// tower. Each one's backdrop and named slots live in its own `G8…Backdrop.swift`; this file
/// answers `PalaceRoomType`'s questions for them, so the shared switches need one line each.
enum G8Rooms {
    static func hall(_ type: PalaceRoomType) -> String {
        switch type {
        case .g8Allotment: "volkstuin"
        case .g8TownSquare: "plein"
        case .g8Roundabout: "kruising"
        case .g8Dike: "omgeving"
        case .g8Ferry: "kade"
        case .g8Lookout: "toren"
        default: "omgeving"
        }
    }

    static func sceneLabel(_ type: PalaceRoomType) -> String {
        switch type {
        case .g8Allotment: "Tuintjes aan de rand van de stad, met een schuurtje en een clubhuis"
        case .g8TownSquare: "Het plein voor het stadhuis"
        case .g8Roundabout: "Een rotonde met een fietspad en een zebrapad"
        case .g8Dike: "Een dijk tussen het hoge water en het lage land"
        case .g8Ferry: "Een kade aan het water, met de overkant in de verte"
        case .g8Lookout: "Boven op een toren, met de hele stad onder je"
        default: ""
        }
    }

    static func noor(_ type: PalaceRoomType) -> CGPoint? {
        switch type {
        case .g8Allotment: G8Allotment.noor
        case .g8TownSquare: G8TownSquare.noor
        case .g8Roundabout: G8Roundabout.noor
        case .g8Dike: G8Dike.noor
        case .g8Ferry: G8Ferry.noor
        case .g8Lookout: G8Lookout.noor
        default: nil
        }
    }

    static func slots(_ type: PalaceRoomType) -> [String: PalaceSlot] {
        switch type {
        case .g8Allotment: G8Allotment.slots
        case .g8TownSquare: G8TownSquare.slots
        case .g8Roundabout: G8Roundabout.slots
        case .g8Dike: G8Dike.slots
        case .g8Ferry: G8Ferry.slots
        case .g8Lookout: G8Lookout.slots
        default: [:]
        }
    }
}

/// The backdrop of a g8 room type.
struct G8RoomBackdrop: View, Equatable {
    let type: PalaceRoomType

    var body: some View {
        switch type {
        case .g8Allotment: G8AllotmentBackdrop()
        case .g8TownSquare: G8TownSquareBackdrop()
        case .g8Roundabout: G8RoundaboutBackdrop()
        case .g8Dike: G8DikeBackdrop()
        case .g8Ferry: G8FerryBackdrop()
        case .g8Lookout: G8LookoutBackdrop()
        default: EmptyView()
        }
    }
}
