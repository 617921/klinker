import Foundation

// MARK: - letters.json

/// One of the four people who might be X.
nonisolated struct LetterSuspect: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let role: String
    let bio: String
    /// Strip style index for the name strip.
    let style: Int
}

nonisolated struct LetterQuestion: Codable, Hashable, Sendable {
    let q: String
    let options: [String]
    /// Index of the right option.
    let answer: Int
}

nonisolated struct LetterClue: Codable, Hashable, Sendable {
    let text: String
    /// Suspect id this clue points to, or nil for a neutral clue.
    let suspect: String?
    /// geur, papier, letters, handschrift, plek, tijd or voorwerp.
    let kind: String
}

/// One anonymous letter. Letter n arrives with sheet n.
nonisolated struct Letter: Codable, Identifiable, Hashable, Sendable {
    let number: Int
    let place: String
    let postmark: String
    /// Dutch text with `{surface|wordId}` markup for course words.
    let text: String
    let signature: String
    let questions: [LetterQuestion]
    let clue: LetterClue
    let teaser: String?

    var id: Int { number }

    enum CodingKeys: String, CodingKey {
        case number, place, postmark, text, signature, questions, clue, teaser
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        number = try c.decode(Int.self, forKey: .number)
        text = try c.decode(String.self, forKey: .text)
        place = (try? c.decodeIfPresent(String.self, forKey: .place)) ?? ""
        postmark = (try? c.decodeIfPresent(String.self, forKey: .postmark)) ?? "UTRECHT"
        signature = (try? c.decodeIfPresent(String.self, forKey: .signature)) ?? "— X"
        let all = (try? c.decodeIfPresent([LetterQuestion].self, forKey: .questions)) ?? []
        questions = all.filter { !$0.options.isEmpty && $0.options.indices.contains($0.answer) }
        clue = (try? c.decodeIfPresent(LetterClue.self, forKey: .clue))
            ?? LetterClue(text: "Nog een raadsel.", suspect: nil, kind: "papier")
        teaser = try? c.decodeIfPresent(String.self, forKey: .teaser)
    }

    /// The letter read aloud: plain text plus the name under it.
    var spokenText: String {
        let name = signature.trimmingCharacters(in: CharacterSet(charactersIn: "—–- ").union(.whitespaces))
        let body = LetterMarkup.plain(text)
        return name.isEmpty ? body : "\(body) \(name)."
    }
}

nonisolated struct LetterReveal: Codable, Hashable, Sendable {
    let sender: String
    let title: String
    let text: String
}

nonisolated struct LetterFile: Decodable, Sendable {
    let suspects: [LetterSuspect]
    let letters: [Letter]
    let reveal: LetterReveal?

    enum CodingKeys: String, CodingKey { case suspects, letters, reveal }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        suspects = (try? c.decodeIfPresent([LetterLossy<LetterSuspect>].self, forKey: .suspects))?.compactMap(\.value) ?? []
        letters = (try? c.decodeIfPresent([LetterLossy<Letter>].self, forKey: .letters))?.compactMap(\.value) ?? []
        reveal = try? c.decodeIfPresent(LetterReveal.self, forKey: .reveal)
    }
}

/// Decodes one array element, or nil when it is broken, so one bad letter doesn't hide the rest.
nonisolated struct LetterLossy<T: Decodable & Sendable>: Decodable, Sendable {
    let value: T?
    init(from decoder: Decoder) throws { value = try? T(from: decoder) }
}

// MARK: - Loader

/// The bundled letters (`letters.json`). Empty when the file is missing or broken.
final class LetterContent {
    static let shared = LetterContent()

    /// Letter 62 reveals the sender.
    static let finalNumber = 62
    /// Board order of the suspects: top left, top right, bottom left, bottom right.
    static let suspectOrder = ["henk", "ria", "sanne", "loket4"]

    let letters: [Letter]
    let suspects: [LetterSuspect]
    let reveal: LetterReveal?

    init(file: LetterFile?) {
        var seen = Set<Int>()
        letters = (file?.letters ?? [])
            .sorted { $0.number < $1.number }
            .filter { $0.number >= 1 && seen.insert($0.number).inserted }
        let given = file?.suspects ?? []
        suspects = Self.suspectOrder.compactMap { id in
            given.first { $0.id == id } ?? LetterSuspect.fallback.first { $0.id == id }
        }
        reveal = file?.reveal
    }

    convenience init(url: URL?) {
        guard let url, let data = try? Data(contentsOf: url),
              let file = try? JSONDecoder().decode(LetterFile.self, from: data) else {
            self.init(file: nil)
            return
        }
        self.init(file: file)
    }

    convenience init() {
        self.init(url: Bundle.main.url(forResource: "letters", withExtension: "json"))
    }

    var isEmpty: Bool { letters.isEmpty }

    func letter(_ number: Int) -> Letter? { letters.first { $0.number == number } }

    func suspect(_ id: String?) -> LetterSuspect? {
        guard let id else { return nil }
        return suspects.first { $0.id == id }
    }
}

extension LetterSuspect {
    /// Used only when letters.json leaves a suspect out.
    nonisolated static let fallback: [LetterSuspect] = [
        LetterSuspect(id: "henk", name: "Buurman Henk", role: "je buurman", bio: "Bromt veel, ziet alles.", style: 4),
        LetterSuspect(id: "ria", name: "Ria de postbode", role: "de postbode", bio: "Kent elk adres in de straat.", style: 1),
        LetterSuspect(id: "sanne", name: "Sanne", role: "je collega", bio: "Weet veel van de gemeente.", style: 8),
        LetterSuspect(id: "loket4", name: "De man van loket 4", role: "ambtenaar", bio: "Zag jouw formulier.", style: 5),
    ]
}

// MARK: - Clue kinds

nonisolated enum LetterClueKind: String, CaseIterable, Sendable {
    case geur, papier, letters, handschrift, plek, tijd, voorwerp

    init(_ raw: String) { self = LetterClueKind(rawValue: raw.lowercased()) ?? .voorwerp }

    var label: String {
        switch self {
        case .geur: "Geur"
        case .papier: "Papier"
        case .letters: "Letters"
        case .handschrift: "Handschrift"
        case .plek: "Plek"
        case .tijd: "Tijd"
        case .voorwerp: "Voorwerp"
        }
    }

    var symbol: String {
        switch self {
        case .geur: "nose"
        case .papier: "doc.text"
        case .letters: "textformat"
        case .handschrift: "signature"
        case .plek: "mappin.and.ellipse"
        case .tijd: "clock"
        case .voorwerp: "key"
        }
    }
}
