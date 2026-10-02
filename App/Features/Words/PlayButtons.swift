import SwiftUI

/// "tape = de / het / overig" with the three tape colours.
struct TapeLegend: View {
    var body: some View {
        HStack(spacing: 14) {
            Text("tape =")
            swatch(Theme.tapeDe, "de")
            swatch(Theme.tapeHet, "het")
            swatch(Theme.tapeOther, "overig")
        }
        .font(.system(size: 13))
        .foregroundStyle(Theme.muted)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Kleur van de tape: blauw is de, oranje is het, grijs is overig.")
    }

    private func swatch(_ color: Color, _ label: String) -> some View {
        HStack(spacing: 6) {
            Rectangle()
                .fill(color)
                .frame(width: 22, height: 10)
                .rotationEffect(.degrees(-8))
            Text(label)
        }
    }
}

/// The big "Speel je ronde" CTA and the three single-game strips.
struct PlayButtons: View {
    @Environment(\.startRound) private var startRound

    var body: some View {
        VStack(spacing: 14) {
            Button("Speel je ronde · 6 min") {
                Haptics.thump()
                startRound(.full)
            }
            .buttonStyle(InkButtonStyle())
            .accessibilityHint("Match rush, Ballonnen en Knip & plak na elkaar.")

            HStack(spacing: 8) {
                game(.match, style: StripStyle.at(6), font: Fonts.label(15), uppercase: false, tilt: 1)
                game(.balloons, style: StripStyle.at(2), font: .custom(StripStyle.at(2).fontName, size: 16), uppercase: true, tilt: -1)
                game(.ransom, style: StripStyle.at(3), font: .custom(StripStyle.at(3).fontName, size: 17), uppercase: false, tilt: 1.5)
            }
        }
    }

    private func game(_ kind: RoundKind, style: StripStyle, font: Font, uppercase: Bool, tilt: Double) -> some View {
        Button {
            Haptics.tap()
            startRound(kind)
        } label: {
            Text(uppercase ? kind.title.uppercased() : kind.title)
                .font(font)
                .tracking(uppercase ? 0.5 : 0)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .padding(.horizontal, 6)
        }
        .buttonStyle(GameButtonStyle(background: style.background, foreground: style.foreground, tilt: tilt))
        .accessibilityLabel(kind.title)
        .accessibilityHint("Speel alleen dit spel.")
    }
}

/// A small cut-out strip button.
private struct GameButtonStyle: ButtonStyle {
    let background: Color
    let foreground: Color
    let tilt: Double

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foreground)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(background, in: RoundedRectangle(cornerRadius: 2))
            .rotationEffect(.degrees(configuration.isPressed ? tilt * 2.5 : tilt))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
