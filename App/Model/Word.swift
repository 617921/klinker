import Foundation

enum Article: String, Codable, Hashable, Sendable {
    case de, het, none
}

enum PartOfSpeech: String, Codable, Hashable, Sendable {
    case noun, verb, adjective, other
}

/// One of the 682 words.
struct Word: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let nl: String
    let article: Article
    let pos: PartOfSpeech
    let en: String
    /// Plural or verb forms, e.g. "mv. afspraken" or "zei af · heeft afgezegd".
    let forms: String
    /// Common partner words, e.g. "een afspraak maken · afzeggen".
    let partners: String
    let example: String
    /// Index into `StripStyle.all`.
    let style: Int
    /// Sheet (vel) number 1...62. Filled in by `ContentStore`.
    var sheet: Int = 0

    enum CodingKeys: String, CodingKey {
        case id, nl, article, pos, en, forms, partners, example, style
    }

    /// "de afspraak", "het loket", or just "afzeggen".
    var spoken: String { article == .none ? nl : "\(article.rawValue) \(nl)" }
}

/// A "Knip & plak" sentence: build `nl` from cut-out strips to match `en`.
struct SentenceTask: Codable, Hashable, Sendable {
    let en: String
    let nl: [String]
    let distractors: [String]
    let tip: String
    /// Word ids this sentence practises.
    let words: [String]
}

/// One vel: 11 words around one place in the city.
struct Sheet: Codable, Identifiable, Hashable, Sendable {
    let number: Int
    let title: String
    let place: String
    var words: [Word]
    let sentences: [SentenceTask]

    var id: Int { number }
}

struct ContentFile: Codable {
    let sheets: [Sheet]
}
