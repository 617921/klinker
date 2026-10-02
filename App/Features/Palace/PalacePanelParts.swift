import SwiftUI

/// Courier heading on the left, a count chip on the right ("VRAAG 3/11" · "2 goed").
struct PalacePanelHeading: View {
    let title: String
    let chip: String
    var done = false

    var body: some View {
        HStack(spacing: 10) {
            CourierLabel(text: title, size: 12)
                .accessibilityAddTraits(.isHeader)
            Spacer(minLength: 0)
            Text(chip)
                .font(.system(size: 14, weight: .heavy))
                .foregroundStyle(done ? Theme.okText : Theme.ink)
                .padding(.horizontal, 12)
                .frame(minHeight: 32)
                .background(done ? Theme.okBg : Color.white, in: Capsule())
                .contentTransition(.numericText())
        }
        .frame(minHeight: 32)
    }
}

/// A word's own strip with its article tape, at a given size and tilt.
struct PalaceWordStrip: View {
    let word: Word
    var size: CGFloat = 24
    var tilt: Double = 0

    var body: some View {
        WordStrip(word: word, size: size)
            .fixedSize()
            .rotationEffect(.degrees(tilt))
            .accessibilityLabel(word.spoken)
    }

    /// Long words get a smaller strip so they fit.
    static func size(for word: Word, normal: CGFloat, long: CGFloat) -> CGFloat {
        word.nl.count > 12 ? long : normal
    }
}

/// Black round speaker button.
struct PalaceSpeakerButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        CircleIconButton(systemName: "speaker.wave.2.fill", label: label, dark: true, action: action)
    }
}

/// The big end-of-game card: "9 VAN 11" and a line under it.
struct PalaceScoreCard: View {
    let score: Int
    let total: Int
    let line: String
    var tilt: Double = 1

    var body: some View {
        VStack(spacing: 4) {
            Text("\(score) van \(total)")
                .font(.custom("Futura-CondensedExtraBold", size: 40))
                .textCase(.uppercase)
                .foregroundStyle(Theme.ink)
            Text(line)
                .font(Fonts.body(15))
                .foregroundStyle(Theme.muted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .padding(.horizontal, 16)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
        .rotationEffect(.degrees(tilt))
        .accessibilityElement(children: .combine)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

/// Two buttons side by side: outline (left, smaller) and ink (right).
struct PalaceButtonPair: View {
    let secondary: String
    let primary: String
    let onSecondary: () -> Void
    let onPrimary: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button(secondary, action: onSecondary)
                .buttonStyle(OutlineButtonStyle())
            Button(primary, action: onPrimary)
                .buttonStyle(InkButtonStyle())
        }
    }
}

/// Feedback box under a question: dashed while waiting, green when right, red when wrong.
struct PalaceFeedbackBox: View {
    enum Tone { case waiting, right, wrong }
    let text: String
    let tone: Tone

    var body: some View {
        Text(text)
            .font(.system(size: 15, weight: tone == .waiting ? .medium : .heavy))
            .foregroundStyle(foreground)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, minHeight: 46)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(background, in: RoundedRectangle(cornerRadius: 3))
            .overlay {
                switch tone {
                case .waiting: RoundedRectangle(cornerRadius: 3).stroke(Theme.dashed, style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
                case .right: RoundedRectangle(cornerRadius: 3).stroke(Theme.okLine, lineWidth: 2)
                case .wrong: RoundedRectangle(cornerRadius: 3).stroke(Theme.badLine, lineWidth: 2)
                }
            }
            .accessibilityAddTraits(.updatesFrequently)
    }

    private var foreground: Color {
        switch tone {
        case .waiting: Theme.muted
        case .right: Theme.okText
        case .wrong: Theme.badText
        }
    }

    private var background: Color {
        switch tone {
        case .waiting: .clear
        case .right: Theme.okBg
        case .wrong: Theme.badBg
        }
    }
}
