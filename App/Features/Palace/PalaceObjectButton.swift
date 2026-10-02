import SwiftUI

/// Draws any palace object, town hall or generic.
struct PalaceObjectArt: View {
    let art: PalaceArt

    var body: some View {
        switch art {
        case .calendar, .wallPhone, .loketSign, .permitCard, .inTray, .form, .signature, .stamp, .idSign, .passport, .standingDesk:
            GemeentehuisObjectArt(art: art)
        default:
            PalaceGenericObjectArt(art: art)
        }
    }
}

/// One tappable object in the room, with its feedback look (selected, right, wrong, pulse, hidden).
struct PalaceObjectButton: View {
    let spot: PalaceSpot
    let look: PalaceLook
    let showsDot: Bool
    let dotDelay: Double
    let shakes: Int
    let accessibilityText: String
    let hint: String
    let action: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Button(action: action) {
            PalaceObjectArt(art: spot.art)
                .frame(width: spot.frame.width, height: spot.frame.height)
                .background { background }
                .overlay { ring }
                .overlay(alignment: .topTrailing) {
                    if showsDot { PalaceDot(delay: dotDelay).offset(x: 3, y: -3) }
                }
                .contentShape(Rectangle().inset(by: -3))
        }
        .buttonStyle(PalaceObjectPressStyle())
        .modifier(PalaceShake(travel: CGFloat(shakes)))
        .animation(reduceMotion ? nil : .linear(duration: 0.45), value: shakes)
        .opacity(look == .hidden ? 0 : 1)
        .animation(.easeInOut(duration: 0.8), value: look == .hidden)
        .animation(.easeOut(duration: 0.3), value: look)
        .allowsHitTesting(look != .hidden)
        .accessibilityLabel(accessibilityText)
        .accessibilityHint(hint)
        .accessibilityHidden(look == .hidden)
    }

    @ViewBuilder private var background: some View {
        if look == .right {
            RoundedRectangle(cornerRadius: 8)
                .fill(Theme.okBg.opacity(0.7))
                .shadow(color: Theme.okLine.opacity(0.35), radius: 8)
        }
    }

    @ViewBuilder private var ring: some View {
        switch look {
        case .selected:
            RoundedRectangle(cornerRadius: 9)
                .stroke(Theme.orange, style: StrokeStyle(lineWidth: 2.5, dash: [6, 4]))
                .padding(-3)
        case .right:
            RoundedRectangle(cornerRadius: 8).stroke(Theme.okLine, lineWidth: 3)
        case .wrong:
            RoundedRectangle(cornerRadius: 8).stroke(Theme.badLine, lineWidth: 3)
        case .pulse:
            ZStack {
                RoundedRectangle(cornerRadius: 9).stroke(Theme.okLine, lineWidth: 3).padding(-2)
                if !reduceMotion { PalacePulseRing() }
            }
        case .plain, .hidden:
            EmptyView()
        }
    }
}

/// A small press feedback for room objects.
private struct PalaceObjectPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// The orange "a word waits here" dot, softly breathing.
private struct PalaceDot: View {
    let delay: Double
    @State private var breathe = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Circle()
            .fill(Theme.orange)
            .frame(width: 12, height: 12)
            .overlay(Circle().stroke(Color.white, lineWidth: 2))
            .scaleEffect(breathe ? 1.45 : 1)
            .opacity(breathe ? 0.55 : 0.95)
            .allowsHitTesting(false)
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(delay)) { breathe = true }
            }
    }
}

/// A green ring that keeps expanding and fading: "here it is".
private struct PalacePulseRing: View {
    @State private var out = false

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Theme.okLine, lineWidth: 3)
            .padding(-2)
            .scaleEffect(out ? 1.35 : 1)
            .opacity(out ? 0 : 0.8)
            .onAppear {
                withAnimation(.easeOut(duration: 1).repeatForever(autoreverses: false)) { out = true }
            }
            .allowsHitTesting(false)
    }
}

/// Shakes left and right with a little rotation (wrong answer).
struct PalaceShake: GeometryEffect {
    var travel: CGFloat

    nonisolated var animatableData: CGFloat {
        get { travel }
        set { travel = newValue }
    }

    nonisolated func effectValue(size: CGSize) -> ProjectionTransform {
        let wave = sin(travel * .pi * 4)
        let x = 6 * wave
        let angle = 3 * wave * .pi / 180
        let t = CGAffineTransform(translationX: size.width / 2 + x, y: size.height / 2)
            .rotated(by: angle)
            .translatedBy(x: -size.width / 2, y: -size.height / 2)
        return ProjectionTransform(t)
    }
}
