import SwiftUI

/// Brief: opens the letter (first time: seal, flap, slide, unfold), then shows the ransom note with
/// a word card and the way on to the questions.
struct LetterReadScreen: View {
    let letter: Letter
    let store: LetterStore
    let session: LetterSession
    let words: ContentStore
    let onQuiz: () -> Void
    let onDossier: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let tokens = LetterMarkup.tokens(letter.text)
        ZStack {
            if session.phase == .open {
                VStack(spacing: 0) {
                    LetterReadHeader(letter: letter)
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                    LetterScroll {
                        LetterPaper(letter: letter, tokens: tokens, words: words, selected: session.selectedToken) { tap($0) }
                            .rotationEffect(.degrees(-0.6))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                    }
                    LetterReadFooter(letter: letter, tokens: tokens, words: words, session: session,
                                     solved: store.solved.contains(letter.number), onQuiz: onQuiz, onDossier: onDossier)
                }
                .transition(reduceMotion ? .opacity : .letterUnfold)
            } else {
                LetterOpening(letter: letter, tokens: tokens, phase: session.phase) { finishOpening(animated: true) }
                    .transition(.opacity)
            }
        }
        .task(id: letter.number) { await runOpening() }
    }

    private func tap(_ token: LetterToken) {
        session.selectedToken = token.id
        Haptics.tap()
        if let id = token.wordID, let word = words.word(id) {
            Speech.shared.say(word.spoken)
        } else {
            Speech.shared.say(token.core)
        }
    }

    private func runOpening() async {
        guard session.phase == .sealed else { return }
        let steps: [(UInt64, LetterPhase, Animation)] = [
            (450, .unsealed, .easeOut(duration: 0.45)),
            (700, .sliding, .easeInOut(duration: 0.75)),
            (850, .open, .spring(duration: 0.6, bounce: 0.15)),
        ]
        for (delay, phase, animation) in steps {
            try? await Task.sleep(nanoseconds: delay * 1_000_000)
            guard !Task.isCancelled, session.phase < phase else {
                finishOpening(animated: false)
                return
            }
            if phase == .unsealed { Haptics.thump() }
            withAnimation(animation) { session.phase = phase }
        }
    }

    private func finishOpening(animated: Bool) {
        guard session.phase != .open else { return }
        if animated && !reduceMotion {
            withAnimation(.spring(duration: 0.5, bounce: 0.15)) { session.phase = .open }
        } else {
            session.phase = .open
        }
    }
}

/// "Brief 14" title strip and the Lees voor button.
private struct LetterReadHeader: View {
    let letter: Letter

    var body: some View {
        HStack(spacing: 10) {
            Text("Brief \(letter.number)")
                .font(.custom("Didot-Bold", size: 24))
                .foregroundStyle(LetterInk.hex(0xC8261B))
                .padding(.horizontal, 10)
                .background(LetterInk.hex(0xF6EBD9))
                .rotationEffect(.degrees(-1.5))
                .accessibilityAddTraits(.isHeader)
            Spacer(minLength: 8)
            Button {
                Speech.shared.say(letter.spokenText, rate: 0.42)
            } label: {
                Label("Lees voor", systemImage: "speaker.wave.2.fill")
                    .font(.system(size: 15, weight: .heavy))
                    .foregroundStyle(Theme.onInk)
                    .padding(.horizontal, 14)
                    .frame(minHeight: 44)
                    .background(Theme.ink, in: Capsule())
            }
            .buttonStyle(.plain)
            .accessibilityHint("Leest de hele brief voor.")
        }
    }
}

/// The word card (meaning of the tapped cut-out) and the call to action.
private struct LetterReadFooter: View {
    let letter: Letter
    let tokens: [LetterToken]
    let words: ContentStore
    let session: LetterSession
    let solved: Bool
    let onQuiz: () -> Void
    let onDossier: () -> Void

    var body: some View {
        let styles = LetterPaper.styles(tokens, words: words)
        let selected = tokens.first { $0.id == session.selectedToken }
        VStack(spacing: 12) {
            LetterWordCard(token: selected, words: words,
                           style: selected.flatMap { styles.indices.contains($0.id) ? styles[$0.id] : nil })
            Button(solved ? "Naar het dossier" : "Ontcijfer de brief") {
                Speech.shared.stop()
                solved ? onDossier() : onQuiz()
            }
            .buttonStyle(InkButtonStyle())
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Theme.paper)
    }
}

/// Meaning of a tapped cut-out: English for a course word, "los knipsel" for the rest.
struct LetterWordCard: View {
    let token: LetterToken?
    let words: ContentStore
    var style: Int?

    var body: some View {
        HStack(spacing: 12) {
            if let token {
                let word = token.wordID.flatMap { words.word($0) }
                HStack(spacing: 12) {
                    StripView(text: word?.nl ?? token.text, style: word?.style ?? style ?? 0, size: 18, tape: word?.article)
                        .rotationEffect(.degrees(-2))
                        .fixedSize()
                    VStack(alignment: .leading, spacing: 2) {
                        Text(word?.en ?? "Los knipsel")
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundStyle(Theme.ink)
                            .lineLimit(2)
                        LetterCaption(text: word.map { "Vel \($0.sheet) · \($0.spoken)" } ?? "Tik om te horen", size: 11)
                    }
                    Spacer(minLength: 0)
                }
                .accessibilityElement(children: .combine)
                Button {
                    Speech.shared.say(word?.spoken ?? token.core)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Theme.ink)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Nog eens horen")
            } else {
                Text("Tik op een knipsel om het te horen. Met tape = een woord van je vellen.")
                    .font(Fonts.body(14))
                    .foregroundStyle(Theme.muted)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
    }
}
