import SwiftUI

/// Knip & plak: build the Dutch sentence from cut-out strips.
struct RansomView: View {
    let round: RoundModel
    let onClose: () -> Void
    @State private var game: RansomGame
    @Namespace private var strips

    init(round: RoundModel, onClose: @escaping () -> Void) {
        self.round = round
        self.onClose = onClose
        _game = State(initialValue: RansomGame(round: round))
    }

    private let move = Animation.spring(response: 0.42, dampingFraction: 0.78)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                if let task = game.task {
                    prompt(task)
                    note
                    tray
                    if game.showEmptyError {
                        Text("Plak eerst een paar woorden.")
                            .font(.footnote)
                            .foregroundStyle(Theme.badLine)
                            .frame(maxWidth: .infinity)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                } else {
                    noSentences
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)
        }
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .bottom) {
            if let task = game.task {
                footer(task)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 12)
                    .background(Theme.paper)
            }
        }
    }

    // MARK: - Parts

    private var header: some View {
        HStack(spacing: 10) {
            RoundCloseButton(action: onClose)
            RoundTitleStrip(look: .ransom, size: 24, tilt: 1)
            Spacer(minLength: 4)
            if !game.tasks.isEmpty {
                RoundCountChip(
                    text: "zin \(game.index + 1)/\(game.tasks.count)",
                    accessibilityText: "Zin \(game.index + 1) van \(game.tasks.count)"
                )
                .animation(.snappy, value: game.index)
            }
        }
    }

    private func prompt(_ task: SentenceTask) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Plak deze zin in het Nederlands")
                .font(.footnote)
                .foregroundStyle(Theme.muted)
            Text(task.en)
                .font(Fonts.readingItalic(25))
                .foregroundStyle(Theme.ink)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
                .id(game.index)
                .transition(.push(from: .trailing))
        }
        .accessibilityElement(children: .combine)
    }

    /// The cream note card where strips get glued.
    private var note: some View {
        RansomFlow(spacing: 6, lineSpacing: 12) {
            ForEach(game.gluedTiles) { tile in
                Button {
                    withAnimation(move) { game.unglue(tile) }
                } label: {
                    RansomTileView(tile: tile)
                        .matchedGeometryEffect(id: tile.id, in: strips)
                        .frame(minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(RansomPressStyle())
                .disabled(game.answer != nil)
                .accessibilityLabel(tile.text)
                .accessibilityHint(game.answer == nil ? "Tik om los te halen" : "")
            }
        }
        .frame(maxWidth: .infinity, minHeight: 102, alignment: .topLeading)
        .overlay(alignment: .topLeading) {
            if game.gluedTiles.isEmpty {
                Text("tik op de knipsels hieronder…")
                    .font(Fonts.label(14))
                    .foregroundStyle(Color(hex: 0x888780))
                    .padding(.top, 12)
                    .accessibilityHidden(true)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(Theme.note, in: RoundedRectangle(cornerRadius: 2))
        .overlay {
            RoundedRectangle(cornerRadius: 2)
                .strokeBorder(noteBorder, style: game.answer == nil
                    ? StrokeStyle(lineWidth: 2, dash: [7, 5])
                    : StrokeStyle(lineWidth: 3))
        }
        .rotationEffect(.degrees(-0.8))
        .animation(.easeOut(duration: 0.25), value: game.answer)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(game.gluedTiles.isEmpty ? "Je zin is nog leeg" : "Je zin")
    }

    private var noteBorder: Color {
        switch game.answer {
        case nil: Theme.dashed
        case .right: Theme.okLine
        case .wrong: Theme.badLine
        }
    }

    /// Loose strips to pick from.
    private var tray: some View {
        RansomFlow(spacing: 10, lineSpacing: 6, centered: true) {
            ForEach(game.trayTiles) { tile in
                Button {
                    withAnimation(move) { game.glue(tile) }
                } label: {
                    RansomTileView(tile: tile)
                        // A darker shadow lifts every strip off the green mat, including green ones.
                        .shadow(color: .black.opacity(0.35), radius: 2, x: 1, y: 2)
                        .matchedGeometryEffect(id: tile.id, in: strips)
                        .frame(minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(RansomPressStyle())
                .disabled(game.answer != nil)
                .accessibilityLabel(tile.text)
                .accessibilityHint("Tik om te plakken")
            }
        }
        .frame(maxWidth: .infinity, minHeight: 250)
        .padding(.horizontal, 12)
        .padding(.vertical, 22)
        .background { RansomCuttingMat() }
        .opacity(game.answer == nil ? 1 : 0.45)
    }

    @ViewBuilder
    private func footer(_ task: SentenceTask) -> some View {
        if let answer = game.answer {
            RansomFeedback(
                ok: answer == .right,
                sentence: roundSentenceText(task.nl),
                tip: task.tip,
                buttonTitle: game.isLast ? round.nextLabel : "Volgende zin"
            ) {
                Haptics.tap()
                withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                    if !game.next() { round.advance() }
                }
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
        } else {
            HStack(spacing: 10) {
                Button("Wis") {
                    withAnimation(move) { game.clear() }
                }
                .buttonStyle(OutlineButtonStyle())
                Button("Plak vast") {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { game.check() }
                }
                .buttonStyle(RoundSolidButtonStyle())
            }
            .transition(.opacity)
        }
    }

    /// Shown when there are no sentences for these words (yet).
    private var noSentences: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Nog geen zinnen")
                .font(Fonts.heading(26))
                .foregroundStyle(Theme.ink)
            Text("Voor deze woorden zijn nog geen zinnen om te plakken. Speel de andere spelletjes, of kom later terug.")
                .font(.body)
                .foregroundStyle(Theme.muted)
                .fixedSize(horizontal: false, vertical: true)
            Button(round.nextLabel) {
                round.advance()
            }
            .buttonStyle(RoundSolidButtonStyle())
            .padding(.top, 6)
        }
        .padding(22)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
        .rotationEffect(.degrees(-0.6))
        .padding(.top, 24)
    }
}

/// Green or red panel after "Plak vast": the right sentence and a grammar tip.
struct RansomFeedback: View {
    let ok: Bool
    let sentence: String
    let tip: String
    let buttonTitle: String
    let onNext: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(ok ? "Perfect geplakt!" : "Bijna. Zo moet het:")
                .font(.system(size: 19, weight: .heavy))
                .accessibilityAddTraits(.isHeader)
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text(sentence)
                    .font(.custom("Baskerville-SemiBold", size: 19))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    Speech.shared.say(sentence)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Luister naar de zin")
            }
            if !tip.isEmpty {
                Text(tip)
                    .font(.subheadline)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Button(buttonTitle, action: onNext)
                .buttonStyle(RoundSolidButtonStyle(height: 54))
                .padding(.top, 4)
        }
        .foregroundStyle(ok ? Theme.okText : Theme.badText)
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ok ? Theme.okBg : Theme.badBg, in: RoundedRectangle(cornerRadius: 3))
    }
}
