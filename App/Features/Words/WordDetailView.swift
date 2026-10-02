import SwiftUI

/// What you see when you tap a strip: the word, how to say and use it, and how well you know it.
struct WordDetailView: View {
    let word: Word

    @Environment(ProgressStore.self) private var progress
    @Environment(\.dismiss) private var dismiss

    private static let sheetPaper = Color(hex: 0xFBFAF7)

    var body: some View {
        let level = max(0, min(4, progress.level(word.id)))
        let retrievability = progress.retrievability(word.id)
        let look = WordLook(word: word, progress: progress)

        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header(bleach: look.bleach)
                nameRow
                Text(word.en)
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundStyle(Theme.ink)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityLabel("Betekenis: \(word.en)")
                usage
                WordStageBar(level: level)
                WordMemoryLine(retrievability: retrievability, fading: look.fading)
            }
            .padding(.horizontal, 24)
            .padding(.top, 30)
            .padding(.bottom, 30)
        }
        .scrollBounceBehavior(.basedOnSize)
        .background(Self.sheetPaper)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Self.sheetPaper)
        .presentationCornerRadius(28)
    }

    // MARK: - Parts

    private func header(bleach: Double) -> some View {
        HStack(alignment: .top, spacing: 12) {
            WordStrip(word: word, size: word.nl.count > 12 ? 24 : 34)
                .modifier(SunBleach(amount: bleach))
                .rotationEffect(.degrees(-2))
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            CircleIconButton(systemName: "xmark", label: "Sluiten") { dismiss() }
        }
    }

    private var nameRow: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(word.spoken)
                    .font(.system(size: 22, weight: .heavy))
                    .foregroundStyle(Theme.ink)
                if !word.forms.isEmpty {
                    Text(word.forms)
                        .font(Fonts.body(14))
                        .foregroundStyle(Theme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityElement(children: .combine)

            Button {
                Haptics.tap()
                Speech.shared.say(word.spoken)
            } label: {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(Theme.onInk)
                    .frame(width: 48, height: 48)
                    .background(Theme.ink, in: Circle())
            }
            .buttonStyle(PressStyle())
            .accessibilityLabel("Luister naar het woord")
        }
    }

    @ViewBuilder
    private var usage: some View {
        if !word.partners.isEmpty || !word.example.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                WordDottedRule()
                if !word.partners.isEmpty {
                    VStack(alignment: .leading, spacing: 2) {
                        CourierLabel(text: "Plakt vaak aan", size: 12)
                        Text(word.partners)
                            .font(Fonts.body(16))
                            .foregroundStyle(Theme.ink)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .accessibilityElement(children: .combine)
                }
                if !word.example.isEmpty {
                    Button {
                        Speech.shared.say(word.example, rate: 0.42)
                    } label: {
                        HStack(alignment: .firstTextBaseline, spacing: 10) {
                            Image(systemName: "speaker.wave.1.fill")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Theme.muted)
                            Text(word.example)
                                .font(Fonts.readingItalic(18))
                                .foregroundStyle(Theme.ink)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Voorbeeldzin: \(word.example)")
                    .accessibilityHint("Tik om te luisteren.")
                }
            }
        }
    }
}

/// The dotted line between the word and how it's used.
private struct WordDottedRule: View {
    var body: some View {
        Line()
            .stroke(Color(hex: 0xD3D1C7), style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [0.1, 7]))
            .frame(height: 3)
            .accessibilityHidden(true)
    }
}

/// Five segments for Nieuw ... Beheerst, and what that means on the wall.
private struct WordStageBar: View {
    let level: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                ForEach(0..<5, id: \.self) { k in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(k <= level ? Theme.ink : Theme.hairline)
                        .frame(height: 8)
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: level)
            Text("Fase: \(WallScale.stageNames[level]) · \(note)")
                .font(Fonts.body(13))
                .foregroundStyle(Theme.muted)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Fase \(level + 1) van 5: \(WallScale.stageNames[level]). \(note).")
    }

    private var note: String {
        switch level {
        case 0: "nog een losse steen"
        case 4: "staat vast in je stad"
        default: "wordt steviger als je oefent"
        }
    }
}

/// "Je onthoudt dit nu voor 93%", or "Nieuw woord".
private struct WordMemoryLine: View {
    let retrievability: Double?
    let fading: Bool

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(fading ? Theme.orange : Theme.muted)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Theme.ink)
                if fading {
                    Text("Dit woord verbleekt. Oefen het in je ronde.")
                        .font(Fonts.body(14))
                        .foregroundStyle(Theme.orangeText)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }

    private var title: String {
        guard let retrievability else { return "Nieuw woord" }
        let percent = Int((retrievability * 100).rounded())
        return "Je onthoudt dit nu voor \(percent)%"
    }

    private var icon: String {
        if retrievability == nil { return "sparkles" }
        return fading ? "sun.max.fill" : "brain.head.profile"
    }
}
