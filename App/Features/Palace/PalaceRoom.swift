import SwiftUI

/// Which object an anchor spot draws.
enum PalaceArt: Hashable {
    // Gemeentehuis (vel 14)
    case calendar, wallPhone, loketSign, permitCard, inTray, form, signature, stamp, idSign, passport, standingDesk
    // Any other place
    case painting(Int), mirror, clock, books, vase, sillPlant, noticeBoard(String), desk, chair
    case coatRack(UInt32), floorLamp, rug(UInt32), umbrellaStand
}

/// How a strip lines up with its anchor point.
nonisolated enum PalacePinAlign: Sendable {
    case leading, center, trailing
}

/// One word on one object in the room (method of loci).
struct PalaceSpot: Identifiable {
    let word: Word
    let art: PalaceArt
    /// The object's tap area, in scene points (370 × 408).
    let frame: CGRect
    /// Where its strip hangs: top edge of the strip, aligned by `align`.
    let pin: CGPoint
    var align: PalacePinAlign = .leading
    var tilt: Double = 0
    /// What the object is, in Dutch, for VoiceOver ("De kalender aan de muur").
    let label: String

    var id: String { word.id }
}

/// An object drawn in the room that carries no word (decoration).
struct PalaceDecor: Identifiable {
    let id: Int
    let art: PalaceArt
    let frame: CGRect
}

/// One "Wat is weg?" round: the word that disappears and three strips to choose from.
struct PalaceWegRound: Equatable {
    let target: String
    let options: [String]
}

/// A place's memory palace: its look and its 11 anchored words.
struct PalaceRoom {
    enum Kind {
        case gemeentehuis
        case generic(PalaceRoomStyle)
    }

    let sheetNumber: Int
    let placeName: String
    let kind: Kind
    let spots: [PalaceSpot]
    var decor: [PalaceDecor] = []
    let window: [PalaceWindowHouse]
    /// Pre-built wall, window, door and floor paths (generic rooms).
    var backdrop: [PalaceMark] = []
    /// Where Noor stands (top-left of her 44 × 112 figure), if she is in the room.
    var noor: CGPoint?
    /// "zaal" for the town hall, "ruimte" elsewhere.
    var hall = "ruimte"
    /// The first "Waar is…?" order (word ids).
    var waarOrder: [String]
    /// Fixed first "Wat is weg?" rounds, if the room has them.
    var wegRounds: [PalaceWegRound] = []
    /// Per-word prompt overrides: id → words before the strip ("Wat kun je hier").
    var promptOverrides: [String: String] = [:]
    /// Nudge strips apart when long words would overlap (generic rooms; the town hall is hand-placed).
    var spreadPins = false

    var ids: [String] { spots.map(\.id) }

    func spot(_ id: String) -> PalaceSpot? { spots.first { $0.id == id } }

    /// The Dutch-only question for "Waar is…?": the part before the word strip.
    /// Nouns: "Waar is het" [loket] "?"; verbs: "Waar kun je iets" [invullen] "?"; adjectives: "Wat is hier" [geldig] "?".
    func promptLead(for word: Word) -> String {
        if let lead = promptOverrides[word.id] { return lead }
        switch word.pos {
        case .noun: return word.article == .none ? "Waar is" : "Waar is \(word.article.rawValue)"
        case .verb: return "Waar kun je iets"
        case .adjective: return "Wat is hier"
        case .other: return "Waar hangt het woord"
        }
    }

    /// The whole question as one sentence, for speech: "Waar is het loket?"
    func promptSentence(for word: Word) -> String {
        "\(promptLead(for: word)) \(word.nl)?"
    }
}

extension PalaceRoom {
    /// Builds the palace for a sheet, or `nil` when the sheet has no words yet.
    static func make(sheetNumber: Int, content: ContentStore) -> PalaceRoom? {
        guard let sheet = content.sheet(sheetNumber), !sheet.words.isEmpty else { return nil }
        if sheetNumber == 14, let hall = GemeentehuisRoom.make(words: sheet.words, lookup: content.word) {
            return hall
        }
        return PalaceGenericRoom.make(sheetNumber: sheetNumber, words: sheet.words)
    }

    /// An empty room for a place whose words aren't written yet (the friendly empty state).
    static func empty(sheetNumber: Int) -> PalaceRoom {
        PalaceGenericRoom.make(sheetNumber: sheetNumber, words: [])
    }
}
