import SwiftUI

/// The look of each game's title strip (matches its button on the wall).
enum RoundGameLook {
    case match, balloons, ransom

    var title: String {
        switch self {
        case .match: "Match rush"
        case .balloons: "Ballonnen"
        case .ransom: "Knip & plak"
        }
    }

    var background: Color {
        switch self {
        case .match: Color(hex: 0xFAC775)
        case .balloons: Color(hex: 0xF4C0D1)
        case .ransom: Color(hex: 0x0F6E56)
        }
    }

    var foreground: Color {
        switch self {
        case .match: Color(hex: 0x412402)
        case .balloons: Color(hex: 0x4B1528)
        case .ransom: Color(hex: 0xE1F5EE)
        }
    }

    func font(_ size: CGFloat) -> Font {
        switch self {
        case .match: Fonts.label(size)
        case .balloons: .custom("Futura-CondensedExtraBold", size: size)
        case .ransom: .custom("Baskerville-SemiBold", size: size)
        }
    }

    var uppercase: Bool { self == .balloons }
}

/// A game's name as a cut-out strip, e.g. "Match rush" on amber.
struct RoundTitleStrip: View {
    let look: RoundGameLook
    var size: CGFloat = 22
    var tilt: Double = -1.5

    var body: some View {
        Text(look.uppercase ? look.title.uppercased() : look.title)
            .font(look.font(size))
            .foregroundStyle(look.foreground)
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .background(look.background)
            .rotationEffect(.degrees(tilt))
            .accessibilityAddTraits(.isHeader)
    }
}

/// Close (x): just leaves. Every answer is already saved.
struct RoundCloseButton: View {
    let action: () -> Void

    var body: some View {
        CircleIconButton(systemName: "xmark", label: "Stoppen", action: action)
    }
}

/// Small white count chip, e.g. "4 paren".
struct RoundCountChip: View {
    let text: String
    var accessibilityText: String? = nil

    var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .heavy))
            .monospacedDigit()
            .foregroundStyle(Theme.ink)
            .padding(.horizontal, 12)
            .frame(height: 32)
            .background(Color.white, in: Capsule())
            .contentTransition(.numericText())
            .accessibilityLabel(accessibilityText ?? text)
    }
}

/// "x3" combo chip: turns orange from 2 and bumps when it grows.
struct RoundComboChip: View {
    let combo: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let hot = combo >= 2
        let bumps = hot && !reduceMotion
        Text("x\(max(1, combo))")
            .font(.system(size: 14, weight: .heavy))
            .monospacedDigit()
            .foregroundStyle(hot ? Theme.ink : Theme.muted)
            .padding(.horizontal, 12)
            .frame(height: 32)
            .background(hot ? Theme.orange : Color.white, in: Capsule())
            .contentTransition(.numericText())
            .keyframeAnimator(initialValue: 1.0, trigger: combo) { content, scale in
                content.scaleEffect(bumps ? scale : 1)
            } keyframes: { _ in
                KeyframeTrack {
                    SpringKeyframe(1.28, duration: 0.12)
                    SpringKeyframe(1.0, duration: 0.3, spring: .bouncy)
                }
            }
            .animation(.easeOut(duration: 0.2), value: hot)
            .accessibilityLabel("Combo \(max(1, combo))")
    }
}

/// Black solid button used on game cards ("Volgende: Ballonnen", "Plak vast").
struct RoundSolidButtonStyle: ButtonStyle {
    var height: CGFloat = 56

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .heavy))
            .foregroundStyle(Theme.onInk)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, minHeight: height)
            .background(Theme.ink, in: RoundedRectangle(cornerRadius: 3))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// A tilted white card on a paper veil, over the game board (start and end cards).
struct RoundOverlayCard<Content: View>: View {
    var tilt: Double = -1
    var veil: Double = 0.9
    /// Shown top-left so you can always leave, even before the game starts.
    var onClose: (() -> Void)? = nil
    @ViewBuilder let content: Content

    var body: some View {
        ZStack {
            Theme.paper.opacity(veil)
                .ignoresSafeArea()
                .accessibilityHidden(true)
            if let onClose {
                RoundCloseButton(action: onClose)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
            }
            VStack(alignment: .leading, spacing: 14) {
                content
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 26)
            .frame(maxWidth: 460)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
            .shadow(color: Theme.ink.opacity(0.08), radius: 18, y: 8)
            .rotationEffect(.degrees(tilt))
            .padding(24)
        }
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
    }
}

/// Start card: title strip, how it works, START.
struct RoundStartCard: View {
    let look: RoundGameLook
    let text: String
    var tilt: Double = -1
    var onClose: (() -> Void)? = nil
    let onStart: () -> Void

    var body: some View {
        RoundOverlayCard(tilt: tilt, onClose: onClose) {
            RoundTitleStrip(look: look, size: look == .match ? 28 : 32, tilt: 0)
            Text(text)
                .font(.body)
                .foregroundStyle(Theme.ink)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
            Button("Start") {
                Haptics.thump()
                onStart()
            }
            .buttonStyle(InkButtonStyle(tilt: 0))
        }
        .transition(.opacity.combined(with: .scale(scale: 0.94)))
    }
}

/// End card: a big headline, some numbers, and the button to go on.
struct RoundEndCard<Stats: View>: View {
    let headline: String
    var tilt: Double = 1
    let buttonTitle: String
    var onClose: (() -> Void)? = nil
    @ViewBuilder let stats: Stats
    let onNext: () -> Void

    var body: some View {
        RoundOverlayCard(tilt: tilt, veil: 0.92, onClose: onClose) {
            VStack(spacing: 14) {
                Text(headline.uppercased())
                    .font(.custom("Futura-CondensedExtraBold", size: 44))
                    .foregroundStyle(Theme.ink)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                    .lineLimit(2)
                    .accessibilityAddTraits(.isHeader)
                stats
                Button(buttonTitle) {
                    Haptics.tap()
                    onNext()
                }
                .buttonStyle(RoundSolidButtonStyle())
            }
            .frame(maxWidth: .infinity)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.9)))
    }
}

/// A number with a caption on a paper tile ("12 paren").
struct RoundStatTile: View {
    let value: String
    let caption: String
    var valueColor: Color = Theme.ink
    var background: Color = Theme.paper
    var foreground: Color = Theme.muted
    var tilt: Double = 0
    var valueSize: CGFloat = 30

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.system(size: valueSize, weight: .heavy))
                .monospacedDigit()
                .foregroundStyle(valueColor)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(caption)
                .font(.system(size: 13))
                .foregroundStyle(foreground)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(background)
        .rotationEffect(.degrees(tilt))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(value) \(caption)")
    }
}

/// Small horizontal shake for a wrong answer.
struct RoundShake: ViewModifier {
    let trigger: Int
    let active: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        let shakes = active && !reduceMotion
        return content.keyframeAnimator(initialValue: 0.0, trigger: trigger) { view, x in
            view.offset(x: shakes ? x : 0)
        } keyframes: { _ in
            KeyframeTrack {
                LinearKeyframe(-9, duration: 0.06)
                LinearKeyframe(8, duration: 0.07)
                LinearKeyframe(-6, duration: 0.07)
                LinearKeyframe(4, duration: 0.06)
                LinearKeyframe(0, duration: 0.06)
            }
        }
    }
}

extension View {
    func roundShake(trigger: Int, active: Bool) -> some View {
        modifier(RoundShake(trigger: trigger, active: active))
    }
}
