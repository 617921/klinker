import SwiftUI

/// Verken: tap objects to find their words. Shows the found count, coloured bars, and a word card.
struct PalaceVerkenPanel: View {
    let game: PalaceGame
    let onNext: () -> Void

    var body: some View {
        let total = game.total
        let count = game.foundCount
        let all = count == total && total > 0
        VStack(alignment: .leading, spacing: 10) {
            PalacePanelHeading(
                title: "Verken de \(game.room.hall)",
                chip: all ? "Alle \(total) gevonden!" : "\(count) van \(total) gevonden",
                done: all
            )
            bars
            if let id = game.selected, let word = game.word(id) {
                PalaceWordCard(word: word)
                    .id(word.id)
                    .transition(.asymmetric(insertion: .offset(y: 8).combined(with: .opacity), removal: .opacity))
            } else {
                hint
            }
            if all {
                PalaceButtonPair(secondary: "Opnieuw", primary: "Waar is…?", onSecondary: {
                    withAnimation(.easeInOut(duration: 0.25)) { game.resetVerken() }
                }, onPrimary: onNext)
                .transition(.opacity)
            }
        }
        .animation(.easeOut(duration: 0.3), value: game.selected)
        .animation(.easeOut(duration: 0.3), value: all)
    }

    private var bars: some View {
        HStack(spacing: 4) {
            ForEach(game.room.spots) { spot in
                RoundedRectangle(cornerRadius: 2)
                    .fill(game.found.contains(spot.id) ? Theme.tape(spot.word.article) : Theme.hairline)
                    .frame(height: 8)
                    .animation(.easeInOut(duration: 0.3), value: game.found.contains(spot.id))
            }
        }
        .accessibilityHidden(true)
    }

    private var hint: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Tik op iets in de \(game.room.hall).")
                .font(.system(size: 19, weight: .heavy))
                .foregroundStyle(Theme.ink)
            Text("Elk ding draagt een woord. Een oranje stip betekent: hier wacht nog een woord.")
                .font(Fonts.body(14))
                .foregroundStyle(Theme.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Theme.note, in: RoundedRectangle(cornerRadius: 3))
        .overlay(RoundedRectangle(cornerRadius: 3).stroke(Theme.dashed, style: StrokeStyle(lineWidth: 2, dash: [6, 4])))
        .rotationEffect(.degrees(0.6))
    }
}

/// The found word: big strip, speaker, "de afspraak · appointment", and the example to listen to.
struct PalaceWordCard: View {
    let word: Word

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center, spacing: 10) {
                PalaceWordStrip(word: word, size: PalaceWordStrip.size(for: word, normal: 26, long: 20), tilt: -2)
                    .padding(.top, 6)
                    .layoutPriority(1)
                Spacer(minLength: 0)
                PalaceSpeakerButton(label: "Luister naar het woord") { Speech.shared.say(word.spoken) }
            }
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(word.spoken)
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundStyle(Theme.ink)
                Text(word.en)
                    .font(Fonts.body(15))
                    .foregroundStyle(Theme.muted)
            }
            if !word.example.isEmpty {
                Button {
                    Speech.shared.say(word.example)
                } label: {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Image(systemName: "speaker.wave.1.fill")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Theme.muted)
                        Text(word.example)
                            .font(Fonts.readingItalic(16))
                            .foregroundStyle(Theme.ink)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Voorbeeld: \(word.example)")
                .accessibilityHint("Tik om de zin te horen.")
            }
        }
        .padding(.horizontal, 14)
        .padding(.top, 14)
        .padding(.bottom, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
        .rotationEffect(.degrees(-0.6))
    }
}
