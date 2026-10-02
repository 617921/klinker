import Foundation

/// All bundled learning content. Read-only; loaded once from `sheets.json`.
final class ContentStore {
    static let shared = ContentStore()

    /// Total sheets in the full course (content may cover fewer while it is being written).
    static let totalSheets = 62
    static let totalWords = 682

    let sheets: [Sheet]
    let wordsByID: [String: Word]

    init(sheets: [Sheet]) {
        let numbered = sheets.sorted { $0.number < $1.number }.map { sheet -> Sheet in
            var s = sheet
            s.words = sheet.words.map { w in
                var word = w
                word.sheet = sheet.number
                return word
            }
            return s
        }
        self.sheets = numbered
        var index: [String: Word] = [:]
        for sheet in numbered {
            for word in sheet.words { index[word.id] = word }
        }
        self.wordsByID = index
    }

    convenience init() {
        guard
            let url = Bundle.main.url(forResource: "sheets", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let file = try? JSONDecoder().decode(ContentFile.self, from: data)
        else {
            self.init(sheets: [])
            return
        }
        self.init(sheets: file.sheets)
    }

    var allWords: [Word] { sheets.flatMap(\.words) }

    func sheet(_ number: Int) -> Sheet? { sheets.first { $0.number == number } }

    func word(_ id: String) -> Word? { wordsByID[id] }
}
