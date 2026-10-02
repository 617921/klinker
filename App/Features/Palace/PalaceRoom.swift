import SwiftUI

/// Which object an anchor spot draws.
enum PalaceArt: Hashable {
    // Gemeentehuis (vel 14)
    case calendar, wallPhone, loketSign, permitCard, inTray, form, signature, stamp, idSign, passport, standingDesk
    /// A prop from the prop library that means its word (anchored rooms, see anchors.json).
    case prop(PalaceProp)
    /// A plain note on the prikbord (fallback rooms): colour variant.
    case note(Int)
}

/// How a strip lines up with its anchor point.
nonisolated enum PalacePinAlign: Sendable {
    case leading, center, trailing

    /// "leading" | "center" | "trailing" (anchors.json).
    init?(name: String) {
        switch name {
        case "leading": self = .leading
        case "center": self = .center
        case "trailing": self = .trailing
        default: return nil
        }
    }
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
        /// Vel 14, hand-drawn from the prototype.
        case gemeentehuis
        /// A room type with props from anchors.json: every object means its word.
        case anchored(PalaceRoomType)
        /// No anchors yet: the words hang as notes on a prikbord, so no false links are taught.
        case noticeBoard(PalaceRoomStyle)
    }

    let sheetNumber: Int
    let placeName: String
    let kind: Kind
    let spots: [PalaceSpot]
    var decor: [PalaceDecor] = []
    var window: [PalaceWindowHouse] = []
    /// Pre-built wall and floor paths (prikbord rooms).
    var backdrop: [PalaceMark] = []
    /// Where Noor stands (top-left of her 44 × 112 figure), if she is in the room.
    var noor: CGPoint?
    var noorFacesLeft = false
    /// "zaal" for the town hall, "hal" for the station, "ruimte" elsewhere.
    var hall = "ruimte"
    /// What a word hangs on, for the hints: "Elk ding draagt een woord", "Elk briefje …".
    var thing = "ding"
    /// VoiceOver name of the whole scene.
    var sceneLabel = ""
    /// The first "Waar is…?" order (word ids).
    var waarOrder: [String]
    /// Fixed first "Wat is weg?" rounds, if the room has them.
    var wegRounds: [PalaceWegRound] = []
    /// Per-word prompt overrides: id → words before the strip ("Wat kun je hier").
    var promptOverrides: [String: String] = [:]
    /// Nudge strips apart when they would overlap (rooms not placed by hand).
    var spreadPins = false

    var ids: [String] { spots.map(\.id) }

    func spot(_ id: String) -> PalaceSpot? { spots.first { $0.id == id } }

    /// "Waar is…?" only makes sense where each object means its word (not on the prikbord).
    var playsWaar: Bool {
        if case .noticeBoard = kind { return false }
        return true
    }

    /// The modes this room offers, in order.
    var modes: [PalaceMode] { playsWaar ? PalaceMode.allCases : [.verken, .weg] }

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
    /// Builds the palace for a sheet, or `nil` when the sheet has no words yet:
    /// the hand-drawn town hall for vel 14, an anchored room when anchors.json describes the
    /// sheet, and otherwise the neutral prikbord.
    static func make(sheetNumber: Int, content: ContentStore, anchors: PalaceAnchorBook = .bundled) -> PalaceRoom? {
        guard let sheet = content.sheet(sheetNumber), !sheet.words.isEmpty else { return nil }
        if sheetNumber == 14, let hall = GemeentehuisRoom.make(words: sheet.words, lookup: content.word) {
            return hall
        }
        if let spec = anchors.room(for: sheetNumber) {
            #if DEBUG
            for problem in anchors.problems(for: sheet) { print("anchors.json, vel \(sheetNumber): \(problem)") }
            #endif
            if let room = PalaceAnchoredRoom.make(sheetNumber: sheetNumber, words: sheet.words, spec: spec) {
                return room
            }
        }
        return PalaceNoticeRoom.make(sheetNumber: sheetNumber, words: sheet.words)
    }

    /// An empty room for a place whose words aren't written yet (the friendly empty state).
    static func empty(sheetNumber: Int) -> PalaceRoom {
        PalaceNoticeRoom.make(sheetNumber: sheetNumber, words: [])
    }
}
