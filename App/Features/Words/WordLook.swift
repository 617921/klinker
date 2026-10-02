import SwiftUI

/// One word of a place: a calm paper strip, with five dots for how well you know it.
/// Words you're forgetting look a little sun-bleached and get a "bijna weg" tag.
struct LevelStrip: View {
    let word: Word
    let index: Int
    let look: WordLook
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                WordStrip(word: word, size: 19)
                    .modifier(SunBleach(amount: look.bleach))
                    .overlay(alignment: .topTrailing) {
                        if look.fading { FadingTag().offset(x: 10, y: -12) }
                    }
                    .rotationEffect(.degrees(Tilt.at(index) * 0.4))
                LevelDots(level: look.level, dot: 5)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: look.level)
            }
            .frame(minWidth: 44, minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(PressStyle())
        .accessibilityLabel(accessibilityText)
        .accessibilityHint("Tik voor de betekenis.")
    }

    private var accessibilityText: String {
        let stage = WallScale.stageNames[max(0, min(4, look.level))]
        return "\(word.spoken), \(stage)" + (look.fading ? ", bijna weg" : "")
    }
}

/// How one word looks on the wall right now: its size level and how sun-bleached it is.
struct WordLook: Equatable {
    let level: Int
    let fading: Bool
    /// 0 = fresh ... 0.9 = very bleached. Only words under the fading line bleach.
    let bleach: Double

    init(level: Int, retrievability: Double?, fading: Bool) {
        self.level = max(0, min(4, level))
        self.fading = fading
        self.bleach = fading ? min(0.9, max(0.35, (1 - (retrievability ?? 0)) / 0.55)) : 0
    }

    init(word: Word, progress: ProgressStore) {
        self.init(level: progress.level(word.id), retrievability: progress.retrievability(word.id), fading: progress.isFading(word.id))
    }
}

/// Sun-bleached paper: colours drain, go warm and a yellow haze sits on top.
struct SunBleach: ViewModifier {
    /// 0 (fresh) ... 0.9 (almost white).
    let amount: Double

    func body(content: Content) -> some View {
        content
            .saturation(1 - 0.8 * amount)
            .contrast(1 - 0.36 * amount)
            .brightness(0.06 * amount)
            .colorMultiply(amount > 0 ? Color(hex: 0xFFF3D6) : .white)
            .overlay {
                Rectangle()
                    .fill(Color(hex: 0xF7E6B2).opacity(0.42 * amount))
                    .allowsHitTesting(false)
            }
    }
}

/// A gentle, irregular flicker like a loose strip catching the wind.
struct FadeFlicker: ViewModifier {
    let active: Bool
    let seed: Int

    func body(content: Content) -> some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30, paused: !active)) { context in
            content.opacity(active ? Self.opacity(at: context.date.timeIntervalSinceReferenceDate, seed: seed) : 1)
        }
    }

    /// Mostly still, then a quick double dip — each strip on its own rhythm.
    nonisolated static func opacity(at time: TimeInterval, seed: Int) -> Double {
        let period = 2.3 + Double(seed % 4) * 0.45
        let shifted = time + Double(seed) * 0.7
        let u = shifted.truncatingRemainder(dividingBy: period) / period
        let keys: [(Double, Double)] = [(0, 1), (0.44, 1), (0.48, 0.55), (0.51, 0.95), (0.55, 0.65), (0.6, 1), (1, 1)]
        for k in 1..<keys.count where u <= keys[k].0 {
            let (u0, v0) = keys[k - 1]
            let (u1, v1) = keys[k]
            let t = (u - u0) / max(0.0001, u1 - u0)
            return v0 + (v1 - v0) * t
        }
        return 1
    }
}

/// Small "bijna weg" label on a fading strip.
struct FadingTag: View {
    var body: some View {
        Text("bijna weg")
            .font(Fonts.label(10))
            .foregroundStyle(Color(hex: 0xFAC775))
            .lineLimit(1)
            .fixedSize()
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Theme.ink)
            .rotationEffect(.degrees(4))
            .accessibilityHidden(true)
    }
}

/// Press feedback for collage strips: a small squash.
struct PressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.93 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
