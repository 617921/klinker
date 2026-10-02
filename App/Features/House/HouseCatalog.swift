import SwiftUI

// "Jouw huis": Noor's canal house that furnishes itself as you learn. Every object is an extra
// "huiswoord" (not one of the 682 course words) that you earn by finishing a sheet.

/// The four kinds of typed spots in the house.
enum HouseKind: String, CaseIterable {
    /// Big furniture on the floor. Above the ground floor it goes up via de hijsbalk.
    case groot
    /// Small things standing on the floor.
    case klein
    /// Things that hang on the wall (or from the ceiling).
    case muur
    /// Small things on a counter, a shelf or the floor.
    case op

    /// Used in "Geen plek meer voor ...": the family of spots in Dutch.
    var family: String {
        switch self {
        case .groot: "grote spullen"
        case .klein: "kleine spullen op de vloer"
        case .muur: "spullen aan de muur"
        case .op: "kleine dingen"
        }
    }
}

/// The Dutch position verb for an object: staan, hangen, liggen, zitten.
enum HouseVerb: String {
    case staat, hangt, ligt, zit

    /// The little grammar tip in the toast.
    var tip: String {
        switch self {
        case .staat: "Rechtop, op de grond of op een kast? Dan staat het."
        case .hangt: "Aan de muur of aan het plafond? Dan hangt het."
        case .ligt: "Plat neergelegd? Dan ligt het."
        case .zit: "Een kat zit (of ligt) waar hij wil."
        }
    }
}

/// The four rooms of the cutaway.
enum HouseRoom: String, CaseIterable, Identifiable {
    case keuken, woonkamer, slaapkamer, zolder

    var id: String { rawValue }
    /// "de keuken"
    var name: String { "de \(rawValue)" }
    /// "in de keuken", "op de zolder"
    var prep: String { self == .zolder ? "op de zolder" : "in de \(rawValue)" }
    /// 0 = ground floor. Big things for floor 1 and up go via de hijsbalk.
    var floor: Int {
        switch self {
        case .keuken: 0
        case .woonkamer: 1
        case .slaapkamer: 2
        case .zolder: 3
        }
    }
}

/// A typed spot in the cutaway, in the 390 x 440 scene (the prototype's stage).
struct HouseSlot: Identifiable, Hashable {
    let id: String
    let room: HouseRoom
    let kind: HouseKind
    let rect: CGRect

    /// Floor objects stand on the bottom edge; wall objects hang centred.
    var onFloor: Bool { kind != .muur }
    /// Big furniture above the ground floor can't go up the steep stairs.
    var needsHoist: Bool { kind == .groot && room.floor >= 1 }
}

/// One household object: an extra word you earn when sheet `unlockSheet` is finished.
struct HouseItem: Identifiable, Hashable {
    let id: String
    let word: String
    let article: Article
    let en: String
    /// Index into `StripStyle.all`.
    let style: Int
    let kind: HouseKind
    let verb: HouseVerb
    let example: String
    let unlockSheet: Int

    /// "de bank"
    var spoken: String { article == .none ? word : "\(article.rawValue) \(word)" }
    /// "De bank"
    var spokenCapitalized: String {
        switch article {
        case .de: "De \(word)"
        case .het: "Het \(word)"
        case .none: word.prefix(1).uppercased() + word.dropFirst()
        }
    }
    var layers: [HouseLayer] { HouseArt.layers(id) }

    static func == (a: HouseItem, b: HouseItem) -> Bool { a.id == b.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

enum HouseCatalog {
    /// 24 objects, spread over the course: one every sheet early on, then further apart.
    static let items: [HouseItem] = [
        HouseItem(id: "bank", word: "bank", article: .de, en: "sofa, couch", style: 0, kind: .groot, verb: .staat,
                  example: "We zitten samen op de bank.", unlockSheet: 1),
        HouseItem(id: "lamp", word: "lamp", article: .de, en: "lamp", style: 6, kind: .klein, verb: .staat,
                  example: "Doe de lamp maar aan.", unlockSheet: 2),
        HouseItem(id: "bed", word: "bed", article: .het, en: "bed", style: 5, kind: .groot, verb: .staat,
                  example: "Ik ga vroeg naar bed.", unlockSheet: 3),
        HouseItem(id: "tafel", word: "tafel", article: .de, en: "table", style: 8, kind: .groot, verb: .staat,
                  example: "Het eten staat op tafel.", unlockSheet: 4),
        HouseItem(id: "stoel", word: "stoel", article: .de, en: "chair", style: 2, kind: .klein, verb: .staat,
                  example: "Pak een stoel en kom erbij zitten.", unlockSheet: 5),
        HouseItem(id: "plant", word: "plant", article: .de, en: "plant", style: 3, kind: .klein, verb: .staat,
                  example: "De plant staat bij het raam.", unlockSheet: 6),
        HouseItem(id: "klok", word: "klok", article: .de, en: "clock", style: 4, kind: .muur, verb: .hangt,
                  example: "De klok loopt vijf minuten voor.", unlockSheet: 7),
        HouseItem(id: "prikbord", word: "prikbord", article: .het, en: "noticeboard, pinboard", style: 1, kind: .muur, verb: .hangt,
                  example: "Ik hang een briefje op het prikbord.", unlockSheet: 8),
        HouseItem(id: "kast", word: "kast", article: .de, en: "cupboard, wardrobe", style: 7, kind: .groot, verb: .staat,
                  example: "Mijn kleren liggen in de kast.", unlockSheet: 9),
        HouseItem(id: "kussen", word: "kussen", article: .het, en: "cushion, pillow", style: 9, kind: .op, verb: .ligt,
                  example: "Ik slaap met twee kussens.", unlockSheet: 10),
        HouseItem(id: "kat", word: "kat", article: .de, en: "cat", style: 1, kind: .klein, verb: .zit,
                  example: "De kat slaapt de hele dag.", unlockSheet: 11),
        HouseItem(id: "boek", word: "boek", article: .het, en: "book", style: 3, kind: .op, verb: .ligt,
                  example: "Ik lees een boek in het Nederlands.", unlockSheet: 12),
        HouseItem(id: "koffiepot", word: "koffiepot", article: .de, en: "coffee pot", style: 2, kind: .op, verb: .staat,
                  example: "De koffiepot is leeg.", unlockSheet: 13),
        HouseItem(id: "spiegel", word: "spiegel", article: .de, en: "mirror", style: 9, kind: .muur, verb: .hangt,
                  example: "Ze kijkt in de spiegel.", unlockSheet: 15),
        HouseItem(id: "tapijt", word: "tapijt", article: .het, en: "rug, carpet", style: 8, kind: .groot, verb: .ligt,
                  example: "Het tapijt ligt op de vloer.", unlockSheet: 17),
        HouseItem(id: "fiets", word: "fiets", article: .de, en: "bike", style: 5, kind: .klein, verb: .staat,
                  example: "Mijn fiets staat in de gang.", unlockSheet: 19),
        HouseItem(id: "bureau", word: "bureau", article: .het, en: "desk", style: 4, kind: .groot, verb: .staat,
                  example: "Ik werk thuis aan mijn bureau.", unlockSheet: 22),
        HouseItem(id: "gordijn", word: "gordijn", article: .het, en: "curtain", style: 3, kind: .muur, verb: .hangt,
                  example: "Doe het gordijn even dicht.", unlockSheet: 25),
        HouseItem(id: "waterkoker", word: "waterkoker", article: .de, en: "kettle", style: 5, kind: .op, verb: .staat,
                  example: "Zet de waterkoker even aan.", unlockSheet: 28),
        HouseItem(id: "fotolijstje", word: "fotolijstje", article: .het, en: "photo frame", style: 7, kind: .op, verb: .staat,
                  example: "In het fotolijstje zit een foto van mijn moeder.", unlockSheet: 31),
        HouseItem(id: "boekenkast", word: "boekenkast", article: .de, en: "bookcase", style: 6, kind: .groot, verb: .staat,
                  example: "De boekenkast zit vol boeken.", unlockSheet: 35),
        HouseItem(id: "piano", word: "piano", article: .de, en: "piano", style: 0, kind: .groot, verb: .staat,
                  example: "Mijn buurman speelt elke avond piano.", unlockSheet: 40),
        HouseItem(id: "schommelstoel", word: "schommelstoel", article: .de, en: "rocking chair", style: 8, kind: .klein, verb: .staat,
                  example: "Opa zit graag in de schommelstoel.", unlockSheet: 48),
        HouseItem(id: "kroonluchter", word: "kroonluchter", article: .de, en: "chandelier", style: 9, kind: .muur, verb: .hangt,
                  example: "De kroonluchter geeft veel licht.", unlockSheet: 62),
    ]

    /// 17 typed spots (the prototype's 15, a second spot on the kitchen counter and a second wall in
    /// the bedroom). Fewer spots than objects on purpose: a canal house is narrow, so you choose.
    static let slots: [HouseSlot] = [
        HouseSlot(id: "k-op-1", room: .keuken, kind: .op, rect: CGRect(x: 74, y: 349, width: 32, height: 27)),
        HouseSlot(id: "k-op-2", room: .keuken, kind: .op, rect: CGRect(x: 108, y: 349, width: 32, height: 27)),
        HouseSlot(id: "k-groot", room: .keuken, kind: .groot, rect: CGRect(x: 148, y: 356, width: 80, height: 54)),
        HouseSlot(id: "k-muur", room: .keuken, kind: .muur, rect: CGRect(x: 236, y: 334, width: 46, height: 32)),
        HouseSlot(id: "k-klein", room: .keuken, kind: .klein, rect: CGRect(x: 238, y: 370, width: 42, height: 40)),
        HouseSlot(id: "w-op", room: .woonkamer, kind: .op, rect: CGRect(x: 80, y: 262, width: 44, height: 30)),
        HouseSlot(id: "w-groot", room: .woonkamer, kind: .groot, rect: CGRect(x: 134, y: 266, width: 94, height: 58)),
        HouseSlot(id: "w-muur", room: .woonkamer, kind: .muur, rect: CGRect(x: 176, y: 240, width: 50, height: 32)),
        HouseSlot(id: "w-klein", room: .woonkamer, kind: .klein, rect: CGRect(x: 236, y: 272, width: 46, height: 52)),
        HouseSlot(id: "s-muur-2", room: .slaapkamer, kind: .muur, rect: CGRect(x: 78, y: 166, width: 46, height: 28)),
        HouseSlot(id: "s-op", room: .slaapkamer, kind: .op, rect: CGRect(x: 80, y: 198, width: 46, height: 32)),
        HouseSlot(id: "s-groot", room: .slaapkamer, kind: .groot, rect: CGRect(x: 138, y: 172, width: 92, height: 58)),
        HouseSlot(id: "s-muur", room: .slaapkamer, kind: .muur, rect: CGRect(x: 238, y: 150, width: 44, height: 32)),
        HouseSlot(id: "s-klein", room: .slaapkamer, kind: .klein, rect: CGRect(x: 240, y: 184, width: 42, height: 46)),
        HouseSlot(id: "z-muur", room: .zolder, kind: .muur, rect: CGRect(x: 134, y: 56, width: 48, height: 32)),
        HouseSlot(id: "z-groot", room: .zolder, kind: .groot, rect: CGRect(x: 94, y: 88, width: 76, height: 50)),
        HouseSlot(id: "z-klein", room: .zolder, kind: .klein, rect: CGRect(x: 176, y: 96, width: 40, height: 42)),
    ]

    private static let itemsByID: [String: HouseItem] = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })
    private static let slotsByID: [String: HouseSlot] = Dictionary(uniqueKeysWithValues: slots.map { ($0.id, $0) })

    static func item(_ id: String) -> HouseItem? { itemsByID[id] }
    static func slot(_ id: String) -> HouseSlot? { slotsByID[id] }
}
