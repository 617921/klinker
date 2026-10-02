import Foundation

// anchors.json — which word of a sheet sits on which prop, so every object *means* its word.
//
// {
//   "version": 1,
//   "rooms": [{
//     "sheet": 1,
//     "type": "stationHall",                 // a PalaceRoomType: the backdrop and its named slots
//     "hall": "hal",                         // optional: "Verken de hal" (else the type's word)
//     "noor": [246, 292],                    // optional: where Noor stands; [] = not in the room
//     "order": ["perron", "vertraging"],     // optional: first "Waar is…?" order (rest follows)
//     "prompts": {"inchecken": "Waar kun je"},                  // optional: words before the strip
//     "weg": [{"target": "storing", "options": ["storing", "perron", "spitsuur"]}],
//     "anchors": [{
//       "word": "vertraging",
//       "prop": "board",                     // a PalacePropKind
//       "slot": "boardLeft",                 // a named slot of the room type …
//       "frame": [10, 14, 122, 76],          // … or/and an explicit tap box (scene points, 370 × 408)
//       "pin": [18, 80], "align": "leading", "tilt": -2,          // optional strip overrides
//       "label": "Het vertrekbord …",        // VoiceOver: what the object is (never the word itself)
//       "params": {"lines": ["08:12|Utrecht|+10"], "highlight": 0}
//     }],
//     "decor": [{"prop": "person", "frame": [0, 0, 64, 114], "params": {}}]   // optional, no word
//   }]
// }
//
// Rule: painted text and labels may help but never spell a word of the sheet.
// Unknown props, slots or rooms are skipped, never fatal: a sheet without a usable room falls
// back to the prikbord.

/// One sheet's anchored room as written in anchors.json.
nonisolated struct PalaceRoomSpec: Decodable, Sendable {
    let sheet: Int
    let type: String
    var hall: String?
    var noor: [Double]?
    var order: [String]?
    var prompts: [String: String]?
    var weg: [PalaceWegSpec]?
    var anchors: [PalaceAnchorSpec]
    var decor: [PalaceDecorSpec]
    /// Entries that could not be read (unknown prop, missing label …).
    var unreadable = 0

    enum CodingKeys: String, CodingKey {
        case sheet, type, hall, noor, order, prompts, weg, anchors, decor
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        sheet = try c.decode(Int.self, forKey: .sheet)
        type = try c.decode(String.self, forKey: .type)
        hall = try? c.decodeIfPresent(String.self, forKey: .hall)
        noor = try? c.decodeIfPresent([Double].self, forKey: .noor)
        order = try? c.decodeIfPresent([String].self, forKey: .order)
        prompts = try? c.decodeIfPresent([String: String].self, forKey: .prompts)
        let weg = (try? c.decodeIfPresent([PalaceLossy<PalaceWegSpec>].self, forKey: .weg)) ?? []
        self.weg = weg.compactMap(\.value)
        let anchors = (try? c.decodeIfPresent([PalaceLossy<PalaceAnchorSpec>].self, forKey: .anchors)) ?? []
        self.anchors = anchors.compactMap(\.value)
        let decor = (try? c.decodeIfPresent([PalaceLossy<PalaceDecorSpec>].self, forKey: .decor)) ?? []
        self.decor = decor.compactMap(\.value)
        unreadable = anchors.count - self.anchors.count + decor.count - self.decor.count
    }
}

nonisolated struct PalaceWegSpec: Decodable, Sendable {
    let target: String
    let options: [String]
}

/// A word on a prop.
nonisolated struct PalaceAnchorSpec: Decodable, Sendable {
    let word: String
    let prop: PalacePropKind
    var slot: String?
    var frame: [Double]?
    var pin: [Double]?
    var align: String?
    var tilt: Double?
    let label: String
    var params: PalacePropParams?
}

/// A prop that carries no word.
nonisolated struct PalaceDecorSpec: Decodable, Sendable {
    let prop: PalacePropKind
    var slot: String?
    var frame: [Double]?
    var params: PalacePropParams?
}

/// Decodes one element of an array without failing the whole array.
nonisolated struct PalaceLossy<T: Decodable & Sendable>: Decodable, Sendable {
    let value: T?

    init(from decoder: Decoder) throws {
        value = try? T(from: decoder)
    }
}

/// All anchored rooms, by sheet. Empty when the file is missing or unreadable.
nonisolated struct PalaceAnchorBook: Sendable {
    private struct File: Decodable {
        let rooms: [PalaceLossy<PalaceRoomSpec>]
    }

    let rooms: [Int: PalaceRoomSpec]

    static let empty = PalaceAnchorBook(rooms: [:])

    /// anchors.json from the app bundle.
    static let bundled: PalaceAnchorBook = {
        guard let url = Bundle.main.url(forResource: "anchors", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return .empty }
        return PalaceAnchorBook(data: data)
    }()

    init(rooms: [Int: PalaceRoomSpec]) {
        self.rooms = rooms
    }

    init(data: Data) {
        let file = try? JSONDecoder().decode(File.self, from: data)
        let specs = (file?.rooms ?? []).compactMap(\.value)
        self.init(rooms: Dictionary(specs.map { ($0.sheet, $0) }, uniquingKeysWith: { first, _ in first }))
    }

    func room(for sheet: Int) -> PalaceRoomSpec? { rooms[sheet] }

    /// What is wrong with a sheet's anchors, in plain words (for authors; empty = all good).
    @MainActor func problems(for sheet: Sheet) -> [String] {
        guard let spec = rooms[sheet.number] else { return [] }
        var out: [String] = []
        let type = PalaceRoomType(rawValue: spec.type)
        if type == nil { out.append("unknown room type \(spec.type)") }
        if spec.unreadable > 0 { out.append("\(spec.unreadable) entries could not be read") }
        let ids = Set(sheet.words.map(\.id))
        let anchored = Set(spec.anchors.map(\.word))
        for word in sheet.words where !anchored.contains(word.id) { out.append("no anchor for \(word.id)") }
        for anchor in spec.anchors {
            if !ids.contains(anchor.word) { out.append("\(anchor.word) is not on sheet \(sheet.number)") }
            if let slot = anchor.slot, type?.slots[slot] == nil { out.append("\(anchor.word): unknown slot \(slot)") }
            if anchor.slot == nil, anchor.frame?.count != 4 { out.append("\(anchor.word): needs a slot or a frame") }
            if let f = anchor.frame, f.count == 4, min(f[2], f[3]) < 44 { out.append("\(anchor.word): tap box under 44 pt") }
            for icon in anchor.params?.icons ?? [] where PalaceIcon(rawValue: icon) == nil {
                out.append("\(anchor.word): unknown icon \(icon)")
            }
            let texts = PalaceProp(kind: anchor.prop, params: anchor.params ?? PalacePropParams()).paintedTexts + [anchor.label]
            for word in sheet.words {
                let spelled = texts.first { $0.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)
                    .contains(word.nl.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)) }
                if let spelled { out.append("\(anchor.word): \"\(spelled)\" spells \(word.nl)") }
            }
        }
        return out
    }
}
