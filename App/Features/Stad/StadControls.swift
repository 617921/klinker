import SwiftUI

/// Small black strip button ("NIEUWE STRAAT").
struct StadInkPillStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Fonts.cta(14))
            .textCase(.uppercase)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .foregroundStyle(Theme.onInk)
            .padding(.horizontal, 12)
            .frame(minHeight: 44)
            .background(Theme.ink, in: RoundedRectangle(cornerRadius: 3))
            .rotationEffect(.degrees(-1))
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// White 44pt round map button with a shadow.
struct StadRoundButton: View {
    let systemName: String
    let label: String
    var fill: Color = .white
    var dimmed = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Theme.ink)
                .frame(width: 44, height: 44)
                .background(fill, in: Circle())
                .shadow(color: Theme.ink.opacity(0.2), radius: 3, y: 2)
                .opacity(dimmed ? 0.45 : 1)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}

/// Night follows the sun in Amsterdam: from half an hour after sunset to half an hour before sunrise.
enum StadClock {
    static func isNight(_ date: Date = .now) -> Bool {
        KaartSun.phase(at: date) == .night
    }
}
