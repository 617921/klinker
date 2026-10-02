import Foundation

/// The 62 places of De Stad. Sheet n lives at place n.
enum PlaceCatalog {
    static let names: [String] = [
        "Station", "Bakker", "Jouw huis", "Supermarkt", "Markt", "Café", "Kantoor", "Bibliotheek",
        "Huisarts", "Apotheek", "Park", "Tramhalte", "School", "Gemeentehuis", "Bank", "Postkantoor",
        "Ziekenhuis", "Sportschool", "Fietsenmaker", "Woningcorporatie", "Politiebureau", "Museum",
        "Bioscoop", "Haven", "Kerk", "Theater", "Kapper", "Restaurant", "Universiteit", "Taalschool",
        "Uitzendbureau", "Rechtbank", "Tandarts", "Dierenarts", "Zwembad", "Kinderopvang", "Bouwmarkt",
        "Kringloopwinkel", "Belastingdienst", "Notaris", "Verzekeraar", "Energiebedrijf", "Garage",
        "Molen", "Boerderij", "Strand", "Camping", "Vliegveld", "Hotel", "Krantenkiosk", "Buurthuis",
        "Volkstuin", "Brandweer", "Stadhuisplein", "Concertzaal", "Galerie", "Studio", "Startup",
        "Rotonde", "Dijk", "Veerpont", "Uitkijktoren",
    ]

    static func name(_ number: Int) -> String {
        guard number >= 1, number <= names.count else { return "Plek \(number)" }
        return names[number - 1]
    }

    /// SF Symbol for a place badge.
    static func symbol(_ number: Int) -> String {
        switch name(number) {
        case "Station", "Tramhalte": "tram.fill"
        case "Bakker", "Restaurant", "Café": "cup.and.saucer.fill"
        case "Jouw huis", "Woningcorporatie": "house.fill"
        case "Supermarkt", "Markt", "Bouwmarkt", "Kringloopwinkel": "cart.fill"
        case "Kantoor", "Uitzendbureau", "Startup", "Studio": "briefcase.fill"
        case "Bibliotheek", "School", "Universiteit", "Taalschool": "book.fill"
        case "Huisarts", "Apotheek", "Ziekenhuis", "Tandarts", "Dierenarts": "cross.case.fill"
        case "Park", "Volkstuin", "Boerderij": "leaf.fill"
        case "Gemeentehuis", "Stadhuisplein", "Rechtbank", "Belastingdienst", "Notaris": "building.columns.fill"
        case "Bank", "Verzekeraar", "Energiebedrijf": "eurosign.circle.fill"
        case "Postkantoor", "Krantenkiosk": "envelope.fill"
        case "Haven", "Veerpont": "ferry.fill"
        case "Vliegveld": "airplane"
        case "Strand", "Zwembad", "Camping": "sun.max.fill"
        case "Molen", "Dijk": "wind"
        default: "mappin"
        }
    }
}
