import SwiftUI

/// The ransom note: every token a cut-out strip on cream paper, then the signature and a postmark.
/// Course words keep their own strip style and article tape; other words get a style from FNV-1a.
struct LetterPaper: View {
    let letter: Letter
    let tokens: [LetterToken]
    let words: ContentStore
    var selected: Int?
    var onTap: (LetterToken) -> Void = { _ in }

    var body: some View {
        let styles = LetterPaper.styles(tokens, words: words)
        VStack(alignment: .leading, spacing: 14) {
            LetterCaption(text: "Brief \(letter.number) · \(letter.place)", color: LetterInk.paperNote, size: 11)
            LetterFlowLayout(spacing: 6, lineSpacing: 2) {
                ForEach(tokens) { token in
                    LetterTokenButton(token: token, word: word(token), style: styles[token.id],
                                      selected: selected == token.id) { onTap(token) }
                        .letterLineBreak(token.breakBefore)
                }
            }
            HStack(alignment: .bottom) {
                LetterPostmark(text: letter.postmark)
                Spacer(minLength: 8)
                StripView(text: letter.signature, style: 5, size: 22)
                    .rotationEffect(.degrees(-3))
                    .accessibilityLabel("Getekend: \(letter.signature)")
            }
            .padding(.top, 4)
        }
        .padding(.horizontal, 18)
        .padding(.top, 18)
        .padding(.bottom, 20)
        .background(LetterRuledPaper())
        .compositingGroup()
        .shadow(color: LetterInk.hex(0x3C280A, 0.18), radius: 9, y: 6)
    }

    private func word(_ token: LetterToken) -> Word? {
        token.wordID.flatMap { words.word($0) }
    }

    /// One style per token: the word's own, or FNV-1a of the text (never twice in a row).
    static func styles(_ tokens: [LetterToken], words: ContentStore) -> [Int] {
        var styles: [Int] = []
        for token in tokens {
            if let id = token.wordID, let word = words.word(id) {
                styles.append(word.style)
                continue
            }
            var style = LetterMarkup.style(for: token.text)
            if let previous = styles.last, previous == style { style = (style + 3) % 10 }
            styles.append(style)
        }
        return styles
    }
}

/// One tappable cut-out on the letter.
struct LetterTokenButton: View {
    let token: LetterToken
    let word: Word?
    let style: Int
    let selected: Bool
    let action: () -> Void

    private static let sizes: [CGFloat] = [18, 16, 20, 17, 19]

    var body: some View {
        let size = word == nil ? Self.sizes[token.id % Self.sizes.count] : 21
        Button(action: action) {
            StripView(text: token.text, style: style, size: size, tape: word?.article)
                .compositingGroup()
                .shadow(color: StripStyle.at(style).edge ? .clear : Theme.ink.opacity(0.14), radius: 0, x: 1, y: 2)
                .overlay {
                    Rectangle()
                        .stroke(selected ? Theme.orange : .clear, lineWidth: 3)
                        .padding(-4)
                }
                .frame(minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .rotationEffect(.degrees(Tilt.at(token.id) * 1.2))
        .offset(y: CGFloat((token.id * 7) % 5) - 2)
        .accessibilityLabel(accessibilityText)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }

    private var accessibilityText: String {
        guard let word else { return token.core }
        return "\(token.core), woord van je lijst: \(word.spoken), \(word.en)"
    }
}

/// Cream writing paper with faint rules.
struct LetterRuledPaper: View {
    var body: some View {
        Canvas { ctx, size in
            ctx.fill(Path(CGRect(origin: .zero, size: size)), with: .color(LetterInk.cream))
            var y: CGFloat = 28
            while y < size.height {
                ctx.fill(Path(CGRect(x: 0, y: y, width: size.width, height: 1)), with: .color(LetterInk.paperNote.opacity(0.08)))
                y += 28
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .accessibilityHidden(true)
    }
}
