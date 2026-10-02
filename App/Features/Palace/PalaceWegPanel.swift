import SwiftUI

/// Wat is weg?: look at the room, one object and its strip vanish, pick the missing word. Five rounds.
struct PalaceWegPanel: View {
    let game: PalaceGame
    let onClose: () -> Void

    @Environment(ProgressStore.self) private var progress

    var body: some View {
        let rounds = game.wegRounds.count
        VStack(alignment: .leading, spacing: 10) {
            PalacePanelHeading(
                title: "Wat is weg? · ronde \(min(game.wegIndex + 1, max(1, rounds)))/\(rounds)",
                chip: "\(game.wegScore) goed"
            )
            if rounds == 0 {
                Text("Hier hangen nog te weinig woorden voor dit spel.")
                    .font(Fonts.body(15))
                    .foregroundStyle(Theme.muted)
            } else if game.wegDone {
                PalaceScoreCard(score: game.wegScore, total: rounds, line: game.wegScore == rounds
                    ? "Alles goed. Wat een geheugen!"
                    : "rondes goed geraden", tilt: -1)
                PalaceButtonPair(secondary: "Nog een keer", primary: "Naar de stad", onSecondary: {
                    game.setMode(.weg)
                }, onPrimary: onClose)
            } else if let round = game.wegRound {
                if game.wegPhase == .look {
                    PalaceLookCard(hall: game.room.hall)
                        .id(game.wegIndex)
                        .transition(.opacity)
                } else {
                    ask(round)
                }
            }
        }
        .animation(.easeOut(duration: 0.3), value: game.wegPhase)
        .animation(.easeOut(duration: 0.3), value: game.wegDone)
    }

    @ViewBuilder private func ask(_ round: PalaceWegRound) -> some View {
        let answered = game.wegPhase == .answered
        let right = answered && game.wegPick.map { round.options[$0] == round.target } == true
        Text(answered ? (right ? "Goed gezien!" : "Helaas, dat was het niet.") : "Wat is weg?")
            .font(.system(size: 20, weight: .heavy))
            .foregroundStyle(answered ? (right ? Theme.okText : Theme.badText) : Theme.ink)
            .frame(maxWidth: .infinity)
            .accessibilityAddTraits(.isHeader)
        PalaceFlow(spacing: 10, lineSpacing: 12, centered: true) {
            ForEach(Array(round.options.enumerated()), id: \.offset) { k, id in
                if let word = game.word(id) {
                    option(word, index: k, round: round)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        if answered {
            Text(right ? "Ja! Het hangt weer op zijn plek." : "Het was \(game.word(round.target)?.spoken ?? ""). Kijk: het is terug.")
                .font(Fonts.body(14))
                .foregroundStyle(Theme.muted)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            Button(game.wegIndex + 1 >= game.wegRounds.count ? "Bekijk je score" : "Volgende ronde") {
                game.nextWeg()
            }
            .buttonStyle(InkButtonStyle(tilt: 0))
        } else {
            Text("Welk woord hing op de lege plek?")
                .font(Fonts.body(14))
                .foregroundStyle(Theme.muted)
                .frame(maxWidth: .infinity)
        }
    }

    private func option(_ word: Word, index k: Int, round: PalaceWegRound) -> some View {
        let answered = game.wegPhase == .answered
        let isTarget = word.id == round.target
        let picked = game.wegPick == k
        let tilts: [Double] = [-1.5, 1, -0.5]
        let outline: Color = !answered ? .clear : isTarget ? Theme.okLine : picked ? Theme.badLine : .clear
        return Button {
            game.pickWeg(k, progress: progress)
        } label: {
            WordStrip(word: word, size: PalaceWordStrip.size(for: word, normal: 20, long: 16))
                .fixedSize()
                .frame(minHeight: 46)
                .overlay(Rectangle().stroke(outline, lineWidth: 3).padding(-3))
                .opacity(answered && !isTarget ? (picked ? 0.6 : 0.45) : 1)
                .rotationEffect(.degrees(tilts[k % tilts.count]))
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(answered)
        .accessibilityLabel(word.spoken)
        .accessibilityValue(answered ? (isTarget ? "Goed antwoord" : picked ? "Jouw keuze, fout" : "") : "")
    }
}

/// "Kijk goed…" with a two-second bar that runs out.
private struct PalaceLookCard: View {
    let hall: String
    @State private var left: CGFloat = 1

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Kijk goed naar de \(hall)…")
                .font(.system(size: 20, weight: .heavy))
                .foregroundStyle(Theme.ink)
            Text("Zo meteen verdwijnt er één ding met zijn woord.")
                .font(Fonts.body(14))
                .foregroundStyle(Theme.muted)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Theme.hairline)
                    Capsule().fill(Theme.ink).frame(width: geo.size.width * left)
                }
            }
            .frame(height: 10)
            .accessibilityHidden(true)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
        .rotationEffect(.degrees(-0.6))
        .onAppear {
            withAnimation(.linear(duration: 2)) { left = 0 }
        }
    }
}
