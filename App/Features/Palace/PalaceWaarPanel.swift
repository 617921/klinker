import SwiftUI

/// Waar is…?: a Dutch-only question made of strips; tap the right object in the room.
struct PalaceWaarPanel: View {
    let game: PalaceGame
    let onNext: () -> Void

    var body: some View {
        let total = game.waarOrder.count
        VStack(alignment: .leading, spacing: 10) {
            PalacePanelHeading(
                title: "Waar is…? · vraag \(min(game.waarIndex + 1, max(1, total)))/\(total)",
                chip: "\(game.waarScore) goed"
            )
            if game.waarDone {
                PalaceScoreCard(score: game.waarScore, total: total, line: game.waarScore == total
                    ? "Alles in één keer goed. Je paleis staat!"
                    : "in één keer goed gevonden")
                PalaceButtonPair(secondary: "Nog een keer", primary: "Wat is weg?", onSecondary: {
                    game.setMode(.waar)
                }, onPrimary: onNext)
            } else if let target = game.waarTarget {
                question(target)
                    .id(target.id)
                    .transition(.asymmetric(insertion: .offset(x: 24).combined(with: .opacity), removal: .opacity))
                PalaceFeedbackBox(text: feedback, tone: tone)
            }
        }
        .animation(.easeOut(duration: 0.3), value: game.waarIndex)
        .animation(.easeOut(duration: 0.3), value: game.waarDone)
    }

    private func question(_ word: Word) -> some View {
        HStack(alignment: .center, spacing: 10) {
            PalaceFlow(spacing: 6, lineSpacing: 10) {
                StripView(text: game.room.promptLead(for: word), style: 0, size: 16)
                    .fixedSize()
                    .rotationEffect(.degrees(-1.5))
                PalaceWordStrip(word: word, size: PalaceWordStrip.size(for: word, normal: 24, long: 19), tilt: 1.5)
                StripView(text: "?", style: 7, size: 22)
                    .fixedSize()
                    .rotationEffect(.degrees(4))
            }
            .padding(.top, 4)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(game.room.promptSentence(for: word))
            .accessibilityAddTraits(.isHeader)
            PalaceSpeakerButton(label: "Luister naar de vraag") { game.sayPrompt() }
        }
        .padding(.leading, 14)
        .padding(.trailing, 12)
        .padding(.top, 16)
        .padding(.bottom, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
        .rotationEffect(.degrees(-0.8))
    }

    private var tone: PalaceFeedbackBox.Tone {
        guard let tap = game.waarTap else { return .waiting }
        return tap.right ? .right : .wrong
    }

    private var feedback: String {
        guard let tap = game.waarTap else { return "Tik op het goede ding in de \(game.room.hall)." }
        if tap.right { return "Goed zo! Dit is de goede plek." }
        let tapped = game.word(tap.id)?.spoken ?? "iets anders"
        return "Nee, dat is \(tapped). Het goede ding knippert."
    }
}
