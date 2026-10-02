import SwiftUI

/// After the round: scores and how the wall changed.
struct RoundResultsView: View {
    let round: RoundModel
    let onDone: () -> Void
    @Environment(ProgressStore.self) private var progress
    @State private var shown = false
    @State private var changes: [RoundModel.Change] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("RONDE KLAAR!")
                    .font(Fonts.cta(32))
                    .foregroundStyle(Theme.onInk)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                    .background(Theme.ink)
                    .rotationEffect(.degrees(-2))
                    .scaleEffect(shown ? 1 : 0.6)
                    .opacity(shown ? 1 : 0)
                    .frame(maxWidth: .infinity)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityLabel("Ronde klaar!")

                Text(streakLine)
                    .font(.subheadline)
                    .foregroundStyle(Theme.muted)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                statTiles

                Text("Zo groeiden je woorden")
                    .font(.system(size: 17, weight: .heavy))
                    .foregroundStyle(Theme.ink)
                    .padding(.top, 4)
                    .accessibilityAddTraits(.isHeader)

                if changes.isEmpty {
                    unchanged
                } else {
                    VStack(spacing: 10) {
                        ForEach(Array(changes.enumerated()), id: \.element.id) { index, change in
                            RoundChangeRow(change: change, index: index)
                        }
                    }
                }
            }
            .padding(.horizontal, 22)
            .padding(.top, 30)
            .padding(.bottom, 16)
        }
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .bottom) {
            Button("Terug naar je stad") {
                Haptics.tap()
                onDone()
            }
            .buttonStyle(InkButtonStyle())
            .padding(.horizontal, 22)
            .padding(.top, 10)
            .padding(.bottom, 12)
            .background(Theme.paper)
        }
        .onAppear {
            changes = round.changes
            Haptics.success()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) { shown = true }
        }
    }

    private var streakLine: String {
        let days = progress.streak()
        let streak = days == 1 ? "1 dag op rij" : "\(days) dagen op rij"
        return changes.isEmpty ? streak : "\(streak) · je stad groeit weer"
    }

    /// Only the games that were played this round get a tile.
    private var statTiles: some View {
        HStack(spacing: 8) {
            if let pairs = round.pairs {
                RoundStatTile(
                    value: "\(pairs)",
                    caption: pairs == 1 ? "paar" : "paren",
                    valueColor: Color(hex: 0x412402),
                    background: Color(hex: 0xFAC775),
                    foreground: Color(hex: 0x412402),
                    tilt: -1,
                    valueSize: 26
                )
            }
            if let balloons = round.balloons {
                RoundStatTile(
                    value: "\(balloons.right)/\(balloons.total)",
                    caption: "ballonnen",
                    valueColor: Color(hex: 0x4B1528),
                    background: Color(hex: 0xF4C0D1),
                    foreground: Color(hex: 0x4B1528),
                    tilt: 1,
                    valueSize: 26
                )
            }
            if let sentences = round.sentenceScore {
                RoundStatTile(
                    value: "\(sentences.right)/\(sentences.total)",
                    caption: "zinnen geplakt",
                    valueColor: Color(hex: 0x04342C),
                    background: Color(hex: 0xC9E6E2),
                    foreground: Color(hex: 0x04342C),
                    tilt: -0.5,
                    valueSize: 26
                )
            }
        }
        .offset(y: shown ? 0 : 24)
        .opacity(shown ? 1 : 0)
    }

    private var unchanged: some View {
        HStack(alignment: .top, spacing: 12) {
            Doodle(kind: .rings, color: Theme.doodles[1])
                .padding(.top, 6)
                .accessibilityHidden(true)
            Text("Je woorden staan nog waar ze stonden. Dat is oké: een woord zit pas vast als je het vaker goed weet. Morgen weer een ronde?")
                .font(.body)
                .foregroundStyle(Theme.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
    }
}

/// One word on the wall: its strip at the new size, and what happened.
struct RoundChangeRow: View {
    let change: RoundModel.Change
    let index: Int
    @State private var settled = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private func note(_ stage: String) -> String {
        switch change.outcome {
        case .stronger: "sterker · \(stage)"
        case .seen: "gezien · oefen nog"
        case .weaker: "zwakker · oefen nog"
        }
    }

    private var noteColor: Color {
        switch change.outcome {
        case .stronger: Theme.okLine
        case .seen: Theme.muted
        case .weaker: Theme.orangeText
        }
    }

    var body: some View {
        let stage = WallScale.stageNames[max(0, min(4, change.to))]
        HStack(spacing: 12) {
            // The dots start at the old level and spring to the new one.
            VStack(alignment: .leading, spacing: 7) {
                WordStrip(word: change.word, size: 19)
                    .rotationEffect(.degrees(-1))
                LevelDots(level: settled ? change.to : change.from)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(note(stage))
                .font(.system(size: 13, weight: .heavy))
                .foregroundStyle(noteColor)
                .multilineTextAlignment(.trailing)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(minHeight: 68)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(change.word.spoken)
        .accessibilityValue(note(stage))
        .onAppear {
            guard !settled else { return }
            if reduceMotion {
                settled = true
            } else {
                withAnimation(.spring(response: 0.55, dampingFraction: 0.62).delay(0.35 + Double(min(index, 8)) * 0.12)) {
                    settled = true
                }
            }
        }
    }
}
