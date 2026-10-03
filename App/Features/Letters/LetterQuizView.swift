import SwiftUI

/// Ontcijfer: two questions about the letter. Wrong → shake and try again; both right → a clue.
struct LetterQuizScreen: View {
    let letter: Letter
    let store: LetterStore
    let content: LetterContent
    let session: LetterSession
    let onBack: () -> Void
    let onDossier: () -> Void
    let onReveal: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var questions: [LetterQuestion] { letter.questions }
    private var isFinal: Bool { letter.number == LetterContent.finalNumber && content.reveal != nil }

    var body: some View {
        LetterScroll {
            VStack(alignment: .leading, spacing: 14) {
                header
                LetterRecap(letter: letter)
                if session.showClue || questions.isEmpty {
                    LetterClueCard(clue: letter.clue, number: letter.number, suspect: content.suspect(letter.clue.suspect))
                        .transition(reduceMotion ? .opacity : .scale(scale: 0.5).combined(with: .opacity))
                        .padding(.top, 8)
                    Button(isFinal ? "Wie is X?" : "Naar het dossier") { isFinal ? onReveal() : onDossier() }
                        .buttonStyle(InkButtonStyle())
                } else if questions.indices.contains(session.question) {
                    questionView(questions[session.question])
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
        }
        .onAppear {
            if questions.isEmpty { store.markSolved(letter.number) }
        }
    }

    private var header: some View {
        HStack(spacing: 10) {
            CircleIconButton(systemName: "chevron.left", label: "Terug naar de brief", action: onBack)
            Text("Ontcijfer")
                .font(.custom("Futura-CondensedExtraBold", size: 24))
                .textCase(.uppercase)
                .foregroundStyle(LetterInk.hex(0x04342C))
                .padding(.horizontal, 10)
                .background(LetterInk.hex(0xC9E6E2))
                .rotationEffect(.degrees(1))
                .accessibilityAddTraits(.isHeader)
            Spacer(minLength: 0)
            if !questions.isEmpty {
                Chip(text: "vraag \(min(session.question + 1, questions.count))/\(questions.count)")
            }
        }
    }

    @ViewBuilder
    private func questionView(_ question: LetterQuestion) -> some View {
        Text(question.q)
            .font(.system(size: 22, weight: .heavy))
            .tracking(-0.4)
            .foregroundStyle(Theme.ink)
            .fixedSize(horizontal: false, vertical: true)
        VStack(spacing: 10) {
            ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                Button(option) { pick(index, in: question) }
                    .buttonStyle(LetterOptionStyle(look: look(index, in: question)))
                    .modifier(LetterShake(travel: CGFloat(session.shakes[index] ?? 0)))
                    .disabled(session.answeredRight)
            }
        }
        .id(session.question)
        if session.answeredRight {
            Text("Ja! Goed gelezen.")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Theme.okText)
            Button("Volgende vraag") {
                withAnimation(.easeOut(duration: 0.2)) { session.nextQuestion() }
            }
            .buttonStyle(InkButtonStyle())
        } else if !session.wrongPicks.isEmpty {
            Text("Nee. Lees de brief nog eens en probeer opnieuw.")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Theme.badText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func look(_ index: Int, in question: LetterQuestion) -> LetterOptionStyle.Look {
        if session.answeredRight { return index == question.answer ? .right : .dimmed }
        return session.wrongPicks.contains(index) ? .wrong : .normal
    }

    private func pick(_ index: Int, in question: LetterQuestion) {
        guard !session.answeredRight else { return }
        if index == question.answer {
            KlinkerAudio.shared.play(.correct)
            Haptics.success()
            Speech.shared.say(question.options[index])
            if session.question >= questions.count - 1 {
                store.markSolved(letter.number)
                withAnimation(reduceMotion ? .easeOut(duration: 0.2) : .spring(duration: 0.55, bounce: 0.35)) {
                    session.answeredRight = true
                    session.showClue = true
                }
            } else {
                withAnimation(.easeOut(duration: 0.2)) { session.answeredRight = true }
            }
        } else {
            KlinkerAudio.shared.play(.wrong)
            Haptics.error()
            session.wrongPicks.insert(index)
            session.lastWrong = index
            withAnimation(reduceMotion ? nil : .linear(duration: 0.4)) { session.shakes[index, default: 0] += 1 }
        }
    }
}

/// The letter as plain text, to look back at while answering.
private struct LetterRecap: View {
    let letter: Letter

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            LetterCaption(text: "De brief", size: 12)
            Text("\(LetterMarkup.plain(letter.text)) \(letter.signature)")
                .font(Fonts.readingItalic(16))
                .foregroundStyle(Theme.ink)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LetterInk.cream, in: RoundedRectangle(cornerRadius: 2))
        .shadow(color: LetterInk.hex(0x3C280A, 0.08), radius: 3, y: 2)
        .rotationEffect(.degrees(-0.6))
    }
}

/// An answer button: white, then green (right), red (wrong) or faded.
struct LetterOptionStyle: ButtonStyle {
    enum Look { case normal, right, wrong, dimmed }
    let look: Look

    func makeBody(configuration: Configuration) -> some View {
        let (fill, line, text): (Color, Color, Color) = switch look {
        case .normal: (.white, Theme.hairline, Theme.ink)
        case .right: (Theme.okBg, Theme.okLine, Theme.okText)
        case .wrong: (Theme.badBg, Theme.badLine, Theme.badText)
        case .dimmed: (.white, Theme.hairline, Theme.muted)
        }
        return HStack(spacing: 10) {
            configuration.label
                .frame(maxWidth: .infinity, alignment: .leading)
            if look == .right { Image(systemName: "checkmark").accessibilityHidden(true) }
            if look == .wrong { Image(systemName: "xmark").accessibilityHidden(true) }
        }
        .font(.system(size: 17, weight: .bold))
        .foregroundStyle(text)
        .multilineTextAlignment(.leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
        .background(fill, in: RoundedRectangle(cornerRadius: 3))
        .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(line, lineWidth: 2))
        .contentShape(Rectangle())
        .scaleEffect(configuration.isPressed ? 0.98 : 1)
        .accessibilityValue(look == .right ? "Goed" : look == .wrong ? "Fout" : "")
    }
}

/// A clue pinned on a white card: AANWIJZING strip, the clue, its kind and who it points to.
struct LetterClueCard: View {
    let clue: LetterClue
    let number: Int
    let suspect: LetterSuspect?

    var body: some View {
        let kind = LetterClueKind(clue.kind)
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                StripView(text: "Aanwijzing", style: 0, size: 14)
                    .rotationEffect(.degrees(-2))
                Spacer(minLength: 0)
                Label(kind.label, systemImage: kind.symbol)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Theme.label)
            }
            Text(clue.text)
                .font(.custom("Didot-Bold", size: 21))
                .foregroundStyle(Theme.ink)
                .fixedSize(horizontal: false, vertical: true)
            Text(suspect.map { "Wijst naar: \($0.name)" } ?? "Wijst nog naar niemand.")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Theme.okText)
            LetterCaption(text: "Brief \(number) · hangt nu in je dossier", size: 11)
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 2))
        .shadow(color: LetterInk.hex(0x3C280A, 0.15), radius: 6, y: 4)
        .overlay(alignment: .top) { LetterPin(size: 16).offset(y: -7) }
        .rotationEffect(.degrees(-1))
        .accessibilityElement(children: .combine)
    }
}
