import SwiftUI

/// The word behind a placed object: strip, meaning, where it is, listen, an example, and "Terug naar je spullen".
struct HouseItemSheet: View {
    let item: HouseItem
    let room: HouseRoom?
    let onBack: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            HouseWordCard(item: item, room: room, onClose: { dismiss() }, onBack: onBack)
        }
        .scrollBounceBehavior(.basedOnSize)
        .background(HouseInk.hex(0xFBFAF7))
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationBackground(HouseInk.hex(0xFBFAF7))
    }
}

/// The sheet's content.
struct HouseWordCard: View {
    let item: HouseItem
    let room: HouseRoom?
    let onClose: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 14) {
                HouseItemArt(item: item, onFloor: false)
                    .frame(width: 88, height: 66)
                    .frame(width: 104, height: 84)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
                    .rotationEffect(.degrees(-2))
                VStack(alignment: .leading, spacing: 8) {
                    StripView(text: item.word, style: item.style, size: 26, tape: item.article)
                        .rotationEffect(.degrees(-2))
                        .accessibilityLabel(item.spoken)
                    Text(item.en)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Theme.ink)
                }
                .padding(.top, 10)
                Spacer(minLength: 0)
                CircleIconButton(systemName: "xmark", label: "Sluiten", action: onClose)
            }

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.spoken)
                        .font(.system(size: 21, weight: .heavy))
                        .foregroundStyle(Theme.ink)
                    Text(whereText)
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.muted)
                }
                Spacer(minLength: 0)
                Button { Speech.shared.say(item.spoken) } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundStyle(Theme.onInk)
                        .frame(width: 48, height: 48)
                        .background(Theme.ink, in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Luister naar het woord")
            }

            Button { Speech.shared.say(item.example, rate: 0.42) } label: {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "speaker.wave.1")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Theme.muted)
                        .padding(.top, 4)
                    Text(item.example)
                        .font(Fonts.readingItalic(19))
                        .foregroundStyle(Theme.ink)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 0)
                }
                .padding(.top, 12)
                .overlay(alignment: .top) {
                    Line()
                        .stroke(HouseInk.hex(0xD3D1C7), style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [0.1, 6]))
                        .frame(height: 3)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Voorbeeldzin: \(item.example)")
            .accessibilityHint("Tik om te luisteren.")

            Button(action: onBack) {
                Label("Terug naar je spullen", systemImage: "arrow.uturn.backward")
            }
            .buttonStyle(OutlineButtonStyle())
        }
        .padding(.horizontal, 22)
        .padding(.top, 26)
        .padding(.bottom, 20)
    }

    private var whereText: String {
        guard let room else { return "Ligt bij je spullen" }
        let verb = item.verb.rawValue
        return "\(verb.prefix(1).uppercased())\(verb.dropFirst()) \(room.prep)"
    }
}
