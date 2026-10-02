import SwiftUI

/// Day/night segmented switch: "Dag" | "Nacht" in a white capsule.
struct StadDayNightToggle: View {
    @Binding var night: Bool
    var shadow = false

    var body: some View {
        HStack(spacing: 0) {
            segment("Dag", icon: "sun.max.fill", on: !night) { night = false }
            segment("Nacht", icon: "moon.fill", on: night) { night = true }
        }
        .padding(2)
        .background(Color.white, in: Capsule())
        .shadow(color: shadow ? Theme.ink.opacity(0.2) : .clear, radius: 3, y: 2)
    }

    private func segment(_ title: String, icon: String, on: Bool, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) { action() }
            Haptics.tap()
        } label: {
            Label(title, systemImage: icon)
                .font(.system(size: 14, weight: .heavy))
                .lineLimit(1)
                .padding(.horizontal, 10)
                .frame(minHeight: 40)
                .foregroundStyle(on ? Theme.onInk : Theme.ink)
                .background(on ? Theme.ink : Color.clear, in: Capsule())
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(on ? .isSelected : [])
    }
}

/// Rounded choice pill (season picker): black when chosen, outlined otherwise.
struct StadPillStyle: ButtonStyle {
    let selected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .heavy))
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, minHeight: 44)
            .foregroundStyle(selected ? Theme.onInk : Theme.ink)
            .background(selected ? Theme.ink : Color.white.opacity(0.7), in: Capsule())
            .overlay { if !selected { Capsule().stroke(Theme.ink, lineWidth: 2) } }
            .contentShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

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
