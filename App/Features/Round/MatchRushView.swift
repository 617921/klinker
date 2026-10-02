import SwiftUI

/// Match rush: 45 seconds to pair Dutch strips with their meanings.
struct MatchRushView: View {
    let round: RoundModel
    let onClose: () -> Void
    @State private var game: MatchRushGame

    init(round: RoundModel, onClose: @escaping () -> Void) {
        self.round = round
        self.onClose = onClose
        _game = State(initialValue: MatchRushGame(round: round))
    }

    var body: some View {
        ZStack {
            VStack(spacing: 14) {
                topBar
                titleRow
                board
                Text("Tik een Nederlands woord en de betekenis.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.muted)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 22)

            switch game.phase {
            case .ready:
                RoundStartCard(
                    look: .match,
                    text: "45 seconden. Zoek steeds het Nederlandse woord en zijn betekenis. Elk goed paar bouwt mee aan je stad.",
                    onClose: onClose
                ) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) { game.start() }
                }
            case .playing:
                EmptyView()
            case .done:
                RoundEndCard(headline: "Tijd!", buttonTitle: round.nextLabel, onClose: onClose) {
                    HStack(spacing: 10) {
                        RoundStatTile(value: "\(game.pairs)", caption: game.pairs == 1 ? "paar" : "paren")
                        RoundStatTile(value: "x\(max(1, game.best))", caption: "beste combo", valueColor: Theme.orangeText)
                    }
                } onNext: {
                    round.advance()
                }
            }
        }
        .onDisappear { game.stop() }
    }

    // MARK: - Parts

    private var topBar: some View {
        HStack(spacing: 12) {
            RoundCloseButton(action: onClose)
            TimelineView(.animation(minimumInterval: 0.1, paused: game.phase != .playing)) { context in
                let remaining = game.remaining(at: context.date)
                MatchTimerBar(remaining: remaining, total: MatchRushGame.duration, running: game.phase == .playing)
            }
        }
    }

    private var titleRow: some View {
        HStack {
            RoundTitleStrip(look: .match)
            Spacer()
            HStack(spacing: 8) {
                RoundCountChip(text: "\(game.pairs) \(game.pairs == 1 ? "paar" : "paren")")
                    .animation(.snappy, value: game.pairs)
                RoundComboChip(combo: game.combo)
                    .animation(.snappy, value: game.combo)
            }
        }
    }

    private var board: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 14) {
                ForEach(Array(game.left.enumerated()), id: \.element.id) { index, slot in
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) { game.pick(.dutch, index) }
                    } label: {
                        MatchDutchCard(word: slot.word, look: look(side: .dutch, index: index))
                    }
                    .buttonStyle(MatchPressStyle())
                    .roundShake(trigger: game.misses, active: game.flash?.left == index && game.flash?.ok == false)
                    .transition(.scale(scale: 0.5).combined(with: .opacity))
                    .accessibilityLabel(slot.word.spoken)
                    .accessibilityAddTraits(game.selectedLeft == index ? .isSelected : [])
                }
            }
            .frame(maxHeight: .infinity)
            VStack(spacing: 14) {
                ForEach(Array(game.right.enumerated()), id: \.element.id) { index, slot in
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) { game.pick(.english, index) }
                    } label: {
                        MatchMeaningCard(text: slot.word.en, look: look(side: .english, index: index))
                    }
                    .buttonStyle(MatchPressStyle())
                    .roundShake(trigger: game.misses, active: game.flash?.right == index && game.flash?.ok == false)
                    .transition(.scale(scale: 0.5).combined(with: .opacity))
                    .accessibilityLabel(slot.word.en)
                    .accessibilityAddTraits(game.selectedRight == index ? .isSelected : [])
                }
            }
            .frame(maxHeight: .infinity)
        }
        // The cards grow to fill the screen, so the board never leaves half of it empty.
        .frame(maxHeight: .infinity)
        .disabled(game.phase != .playing)
    }

    private func look(side: MatchRushGame.Side, index: Int) -> MatchCardLook {
        let flashIndex = side == .dutch ? game.flash?.left : game.flash?.right
        if let flash = game.flash, flashIndex == index {
            return flash.ok ? .right : .wrong
        }
        let selected = side == .dutch ? game.selectedLeft : game.selectedRight
        return selected == index ? .selected : .idle
    }
}

// MARK: - Cards

enum MatchCardLook: Equatable {
    case idle, selected, right, wrong

    var outline: Color {
        switch self {
        case .idle: .clear
        case .selected: Theme.ink
        case .right: Theme.okLine
        case .wrong: Theme.badLine
        }
    }
}

/// A Dutch word as a full-width collage strip with its article tape.
struct MatchDutchCard: View {
    let word: Word
    let look: MatchCardLook

    var body: some View {
        let style = StripStyle.at(word.style)
        Text(style.uppercase ? word.nl.uppercased() : word.nl)
            .font(.custom(style.fontName, size: word.nl.count > 12 ? 17 : 23))
            .tracking(style.tracking)
            .foregroundStyle(style.foreground)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .minimumScaleFactor(0.55)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, minHeight: 64, maxHeight: 112)
            .background(style.background)
            .overlay {
                if style.edge { Rectangle().stroke(Color(hex: 0xD3D1C7), lineWidth: 1) }
            }
            .overlay(alignment: .topLeading) {
                Tape(article: word.article, width: 26).offset(x: 8, y: -7)
            }
            .overlay {
                Rectangle().strokeBorder(look.outline, lineWidth: 3).padding(-5)
            }
            .scaleEffect(scale)
            .rotationEffect(.degrees(look == .wrong ? -3 : 0))
            .opacity(look == .right ? 0.35 : 1)
            .animation(.spring(response: 0.22, dampingFraction: 0.65), value: look)
    }

    private var scale: CGFloat {
        switch look {
        case .selected: 1.03
        case .right: 0.92
        default: 1
        }
    }
}

/// An English meaning card.
struct MatchMeaningCard: View {
    let text: String
    let look: MatchCardLook

    var body: some View {
        Text(text)
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(foreground)
            .multilineTextAlignment(.center)
            .lineLimit(3)
            .minimumScaleFactor(0.65)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, minHeight: 64, maxHeight: 112)
            .background(background, in: RoundedRectangle(cornerRadius: 3))
            .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(border, lineWidth: 2))
            .scaleEffect(look == .selected ? 1.03 : look == .right ? 0.94 : 1)
            .rotationEffect(.degrees(look == .wrong ? 2 : 0))
            .animation(.spring(response: 0.22, dampingFraction: 0.65), value: look)
    }

    private var background: Color {
        switch look {
        case .right: Theme.okBg
        case .wrong: Theme.badBg
        default: .white
        }
    }

    private var border: Color {
        switch look {
        case .idle: Theme.hairline
        case .selected: Theme.ink
        case .right: Theme.okLine
        case .wrong: Theme.badLine
        }
    }

    private var foreground: Color {
        switch look {
        case .right: Theme.okText
        case .wrong: Theme.badText
        default: Theme.ink
        }
    }
}

struct MatchPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// 45-second bar: ink, red in the last 10 seconds.
struct MatchTimerBar: View {
    let remaining: TimeInterval
    let total: TimeInterval
    let running: Bool

    var body: some View {
        let seconds = Int(remaining.rounded(.up))
        let urgent = running && seconds <= 10
        let fraction = CGFloat(max(0, min(1, remaining / total)))
        HStack(spacing: 12) {
            GeometryReader { proxy in
                Capsule()
                    .fill(Theme.hairline)
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(urgent ? Color(hex: 0xE24B4A) : Theme.ink)
                            .frame(width: proxy.size.width * fraction)
                    }
            }
            .frame(height: 10)
            Text("\(seconds)s")
                .font(Fonts.label(16))
                .monospacedDigit()
                .foregroundStyle(urgent ? Theme.badLine : Theme.ink)
                .frame(minWidth: 40, alignment: .trailing)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Tijd")
        .accessibilityValue("\(seconds) seconden over")
    }
}
