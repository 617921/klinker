import Foundation

// What the street teaches about its houses: the gable names and facts, and the gevelsteen words.

nonisolated extension GableType {
    var name: String {
        switch self {
        case .trap: "Trapgevel"
        case .hals: "Halsgevel"
        case .klok: "Klokgevel"
        case .tuit: "Tuitgevel"
        case .lijst: "Lijstgevel"
        }
    }

    /// The Dutch word (always a de-word): "trapgevel".
    var word: String { name.lowercased() }

    var fact: String {
        switch self {
        case .trap: "De top gaat omhoog als een trap. Vooral gebouwd rond 1600–1665."
        case .hals: "Een smalle hals met krullen opzij. Populair vanaf ongeveer 1640."
        case .klok: "De top heeft de vorm van een klok. Vooral in de achttiende eeuw."
        case .tuit: "Smal en spits, vaak bij pakhuizen aan het water. Met een hijsbalk boven."
        case .lijst: "Een rechte bovenkant met een kroonlijst. Mode vanaf het eind van de zeventiende eeuw."
        }
    }

    var factEnglish: String {
        switch self {
        case .trap: "Step gable: the top climbs like a staircase. Mostly built around 1600–1665."
        case .hals: "Neck gable: a narrow neck with scrolls on the sides. Popular from about 1640."
        case .klok: "Bell gable: the top is shaped like a bell. Mostly 18th century."
        case .tuit: "Spout gable: narrow and pointed, often on warehouses by the water, with a hoist beam."
        case .lijst: "Cornice gable: a straight top with a cornice. Fashionable from the late 17th century."
        }
    }
}

nonisolated extension HouseSpec {
    static let stones: [(nl: String, en: String)] = [
        ("de gracht", "canal"), ("de brug", "bridge"), ("de boot", "boat"), ("het raam", "window"), ("de deur", "door"),
        ("het dak", "roof"), ("de trap", "stairs"), ("de fiets", "bike"), ("de sleutel", "key"), ("de bloem", "flower"),
        ("de vis", "fish"), ("het schip", "ship"), ("de buurman", "neighbour"), ("het loket", "service counter"),
        ("de afspraak", "appointment"), ("de gemeente", "municipality"), ("de huur", "rent"),
    ]

    /// The gevelsteen word on this house: ("de gracht", "canal").
    var stoneWord: (nl: String, en: String) {
        Self.stones[((stone % Self.stones.count) + Self.stones.count) % Self.stones.count]
    }
}
