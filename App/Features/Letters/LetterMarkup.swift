import Foundation

/// One cut-out of a letter: a word with its punctuation, e.g. "afspraak." or "Dinsdag,".
nonisolated struct LetterToken: Identifiable, Hashable, Sendable {
    /// Position in the letter (0, 1, 2 …).
    let id: Int
    /// As printed on the strip, punctuation included.
    let text: String
    /// What to say when tapped: the word without punctuation.
    let core: String
    /// Course word id (`{surface|id}`), nil for plain words.
    let wordID: String?
    /// Starts a new line (after the greeting, or a newline in the text).
    var breakBefore = false
}

/// Turns letter markup into tokens. `{surface|wordId}` marks a course word; everything else is
/// plain Dutch split on spaces, with punctuation staying attached to its word.
nonisolated enum LetterMarkup {
    static func tokens(_ text: String) -> [LetterToken] {
        var tokens: [LetterToken] = []
        var pendingBreak = false
        for (lineIndex, line) in text.components(separatedBy: "\n").enumerated() {
            if lineIndex > 0 { pendingBreak = true }
            for chunk in chunks(line) {
                for piece in pieces(chunk) {
                    tokens.append(LetterToken(
                        id: tokens.count, text: piece.text, core: core(of: piece.surface),
                        wordID: piece.id, breakBefore: pendingBreak && !tokens.isEmpty
                    ))
                    pendingBreak = false
                }
            }
        }
        // A greeting ("Noor." / "Lieve Noor,") gets its own line.
        if let end = tokens.prefix(2).firstIndex(where: { [",", ".", "!"].contains($0.text.last.map(String.init) ?? "") }),
           end + 1 < tokens.count {
            tokens[end + 1].breakBefore = true
        }
        return tokens
    }

    /// The text without markup, for reading aloud: `{af|afzeggen}` becomes "af".
    static func plain(_ text: String) -> String {
        var out = ""
        var inside = false
        var surface = ""
        var pastBar = false
        for ch in text {
            switch ch {
            case "{" where !inside:
                inside = true; surface = ""; pastBar = false
            case "}" where inside:
                inside = false; out += surface
            case "|" where inside:
                pastBar = true
            default:
                if inside { if !pastBar { surface.append(ch) } } else { out.append(ch) }
            }
        }
        if inside { out += surface }
        return out.replacingOccurrences(of: "\n", with: " ")
    }

    /// FNV-1a (32-bit) over UTF-8: a hash that is the same on every launch, unlike `hashValue`.
    static func fnv1a(_ text: String) -> UInt32 {
        var hash: UInt32 = 0x811C_9DC5
        for byte in text.utf8 {
            hash ^= UInt32(byte)
            hash = hash &* 0x0100_0193
        }
        return hash
    }

    /// The strip style for a plain token, derived from its text.
    static func style(for text: String) -> Int {
        Int(fnv1a(text.lowercased()) % 10)
    }

    // MARK: - Private

    /// Splits on whitespace, but never inside `{…}` (a surface may hold a space).
    private static func chunks(_ line: String) -> [String] {
        var chunks: [String] = []
        var current = ""
        var depth = 0
        for ch in line {
            if ch == "{" { depth += 1 }
            if ch == "}" { depth = max(0, depth - 1) }
            if ch.isWhitespace && depth == 0 {
                if !current.isEmpty { chunks.append(current) }
                current = ""
            } else {
                current.append(ch)
            }
        }
        if !current.isEmpty { chunks.append(current) }
        return chunks
    }

    private struct Piece {
        var text: String
        var surface: String
        var id: String?
    }

    /// One chunk is usually one piece. With markup, text before the first `{` is a prefix and
    /// text after a `}` sticks to that course word ("{afspraak|afspraak}." → "afspraak.").
    private static func pieces(_ chunk: String) -> [Piece] {
        guard chunk.contains("{") else { return [Piece(text: chunk, surface: chunk, id: nil)] }
        var pieces: [Piece] = []
        var prefix = ""
        var rest = Substring(chunk)
        while let open = rest.firstIndex(of: "{") {
            let before = String(rest[..<open])
            if pieces.isEmpty { prefix += before } else { pieces[pieces.count - 1].text += before }
            let afterOpen = rest[rest.index(after: open)...]
            guard let close = afterOpen.firstIndex(of: "}") else {
                // Unclosed brace: keep the words, drop the brace.
                let tail = String(afterOpen).trimmingCharacters(in: .whitespaces)
                if pieces.isEmpty { prefix += tail } else { pieces[pieces.count - 1].text += tail }
                rest = ""
                break
            }
            let inner = afterOpen[..<close]
            let parts = inner.split(separator: "|", maxSplits: 1, omittingEmptySubsequences: false)
            let surface = String(parts.first ?? "").trimmingCharacters(in: .whitespaces)
            let id = parts.count > 1 ? String(parts[1]).trimmingCharacters(in: .whitespaces) : ""
            let lead = pieces.isEmpty ? prefix : ""
            pieces.append(Piece(text: lead + surface, surface: surface, id: id.isEmpty ? nil : id))
            rest = afterOpen[afterOpen.index(after: close)...]
        }
        if pieces.isEmpty { return [Piece(text: prefix, surface: prefix, id: nil)] }
        pieces[pieces.count - 1].text += String(rest)
        return pieces.filter { !$0.text.isEmpty }
    }

    private static func core(of text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .punctuationCharacters.union(.symbols).union(.whitespaces))
        return trimmed.isEmpty ? text : trimmed
    }
}
