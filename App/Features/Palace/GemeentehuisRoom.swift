import SwiftUI

/// Vel 14: the town-hall hall from the StadGemeentehuis prototype. Same object boxes,
/// strip positions, question order and "Wat is weg?" rounds.
enum GemeentehuisRoom {
    /// id → (object box x, y, w, h; strip x, y, tilt; Dutch description of the object)
    private struct Anchor {
        let art: PalaceArt
        let box: CGRect
        let pin: (CGFloat, CGFloat, Double)
        let label: String
    }

    private static let anchors: [String: Anchor] = [
        "afspraak": Anchor(art: .calendar, box: CGRect(x: 176, y: 88, width: 44, height: 50), pin: (170, 140, -3), label: "De kalender aan de muur"),
        "aanvraag": Anchor(art: .inTray, box: CGRect(x: 174, y: 196, width: 44, height: 44), pin: (166, 246, -2), label: "Het bakje IN met papieren"),
        "formulier": Anchor(art: .form, box: CGRect(x: 220, y: 200, width: 44, height: 44), pin: (204, 272, 1.5), label: "Het formulier op de balie"),
        "verblijfsvergunning": Anchor(art: .permitCard, box: CGRect(x: 323, y: 132, width: 44, height: 44), pin: (226, 180, -1.5), label: "De pas in de hand van de man"),
        "loket": Anchor(art: .loketSign, box: CGRect(x: 284, y: 28, width: 72, height: 44), pin: (296, 4, 2), label: "Het bord van loket 4"),
        "handtekening": Anchor(art: .signature, box: CGRect(x: 268, y: 200, width: 44, height: 44), pin: (268, 246, 2), label: "Het papier met de pen"),
        "invullen": Anchor(art: .standingDesk, box: CGRect(x: 158, y: 266, width: 58, height: 44), pin: (148, 314, 2), label: "De statafel met een pen"),
        "afzeggen": Anchor(art: .wallPhone, box: CGRect(x: 221, y: 92, width: 44, height: 54), pin: (214, 70, 2), label: "De telefoon met een briefje"),
        "verlengen": Anchor(art: .passport, box: CGRect(x: 83, y: 300, width: 44, height: 44), pin: (52, 350, -2), label: "Het paspoort op de stoel"),
        "verplicht": Anchor(art: .idSign, box: CGRect(x: 104, y: 172, width: 56, height: 44), pin: (96, 220, -2), label: "Het bordje op de deur"),
        "geldig": Anchor(art: .stamp, box: CGRect(x: 312, y: 196, width: 52, height: 44), pin: (290, 272, -1.5), label: "Het stempel bij het papier"),
    ]

    /// The prototype's word order (the strip index order of `IDS`).
    private static let ids = ["afspraak", "aanvraag", "formulier", "verblijfsvergunning", "loket", "handtekening",
                              "invullen", "afzeggen", "verlengen", "verplicht", "geldig"]

    private static let order = ["loket", "afspraak", "geldig", "formulier", "verplicht", "handtekening",
                                "afzeggen", "aanvraag", "verlengen", "invullen", "verblijfsvergunning"]

    private static let rounds = [
        PalaceWegRound(target: "handtekening", options: ["formulier", "handtekening", "geldig"]),
        PalaceWegRound(target: "afspraak", options: ["afspraak", "afzeggen", "aanvraag"]),
        PalaceWegRound(target: "verplicht", options: ["geldig", "verlengen", "verplicht"]),
        PalaceWegRound(target: "aanvraag", options: ["verblijfsvergunning", "aanvraag", "formulier"]),
        PalaceWegRound(target: "loket", options: ["loket", "invullen", "handtekening"]),
    ]

    /// The town hall, if enough of its words exist in the content (otherwise the generic room is used).
    static func make(words: [Word], lookup: (String) -> Word?) -> PalaceRoom? {
        let sheetIDs = Set(words.map(\.id))
        let spots: [PalaceSpot] = ids.compactMap { id in
            guard sheetIDs.contains(id), let word = lookup(id), let a = anchors[id] else { return nil }
            return PalaceSpot(word: word, art: a.art, frame: a.box, pin: CGPoint(x: a.pin.0, y: a.pin.1),
                              align: .leading, tilt: a.pin.2, label: a.label)
        }
        guard spots.count >= 6 else { return nil }
        let present = Set(spots.map(\.id))
        let decor: [PalaceDecor] = ids.enumerated().compactMap { i, id in
            guard !present.contains(id), let a = anchors[id] else { return nil }
            return PalaceDecor(id: i, art: a.art, frame: a.box)
        }
        return PalaceRoom(
            sheetNumber: 14,
            placeName: PlaceCatalog.name(14),
            kind: .gemeentehuis,
            spots: spots,
            decor: decor,
            window: PalaceCanal.row(PalaceCanal.gemeentehuis),
            noor: CGPoint(x: 240, y: 292),
            hall: "zaal",
            sceneLabel: "De zaal van het gemeentehuis",
            waarOrder: order.filter { present.contains($0) },
            wegRounds: rounds.filter { r in r.options.allSatisfy { present.contains($0) } },
            promptOverrides: ["verlengen": "Wat kun je hier"]
        )
    }
}
