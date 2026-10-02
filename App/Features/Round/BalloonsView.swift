import SwiftUI

/// Ballonnen: hear a Dutch word, pop the balloon with its meaning before it flies away.
struct BalloonsView: View {
    let round: RoundModel
    let onClose: () -> Void
    @State private var game: BalloonsGame
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(round: RoundModel, onClose: @escaping () -> Void) {
        self.round = round
        self.onClose = onClose
        _game = State(initialValue: BalloonsGame(round: round))
    }

    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                header
                wordArea
                sky
            }
            .padding(.top, 16)

            switch game.phase {
            case .ready:
                RoundStartCard(
                    look: .balloons,
                    text: "\(game.questions.count) woorden. Drie ballonnen stijgen op. Knal de goede betekenis. Hoe langer je combo, hoe sneller ze vliegen.",
                    tilt: 1,
                    onClose: onClose
                ) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) { game.start() }
                }
            case .playing:
                EmptyView()
            case .done:
                RoundEndCard(headline: "\(game.score) van \(game.questions.count)", tilt: -1, buttonTitle: round.nextLabel, onClose: onClose) {
                    Text("ballonnen geknald")
                        .font(.body)
                        .foregroundStyle(Theme.muted)
                } onNext: {
                    round.advance()
                }
            }
        }
        .onDisappear { game.stop() }
        .onChange(of: game.outcome) { _, outcome in
            guard let outcome, let question = game.question else { return }
            AccessibilityNotification.Announcement(message(for: outcome, question: question)).post()
        }
    }

    // MARK: - Parts

    private var header: some View {
        HStack(spacing: 10) {
            RoundCloseButton(action: onClose)
            RoundTitleStrip(look: .balloons)
            Spacer(minLength: 4)
            RoundCountChip(
                text: "\(min(game.index + 1, max(1, game.questions.count)))/\(game.questions.count)",
                accessibilityText: "Woord \(game.index + 1) van \(game.questions.count)"
            )
            .animation(.snappy, value: game.index)
            RoundComboChip(combo: game.combo)
                .animation(.snappy, value: game.combo)
        }
        .padding(.horizontal, 20)
    }

    private var wordArea: some View {
        VStack(spacing: 10) {
            if let question = game.question {
                Button {
                    Haptics.tap()
                    Speech.shared.say(question.word.spoken)
                } label: {
                    WordStrip(word: question.word, size: question.word.nl.count > 12 ? 22 : 30)
                        .rotationEffect(.degrees(-1.5))
                        .padding(.vertical, 6)
                }
                .buttonStyle(MatchPressStyle())
                .accessibilityHint("Tik om het woord te horen")
                .id(game.index)
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.6).combined(with: .opacity),
                    removal: .opacity
                ))
            }
            Text("Knal de goede betekenis voordat hij wegvliegt.")
                .font(.subheadline)
                .foregroundStyle(Theme.muted)
                .multilineTextAlignment(.center)
        }
        .frame(minHeight: 84)
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    private var sky: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                BalloonPalette.sky
                BalloonClouds(size: proxy.size)
                if game.phase != .ready, let question = game.question {
                    TimelineView(.animation(paused: game.phase != .playing || game.frozenAt != nil)) { context in
                        ZStack {
                            ForEach(Array(question.options.enumerated()), id: \.offset) { k, option in
                                balloon(k, option, question: question, date: context.date, size: proxy.size)
                            }
                        }
                        .frame(width: proxy.size.width, height: proxy.size.height)
                    }
                    .id(game.index)
                }
                if let outcome = game.outcome, let question = game.question {
                    banner(outcome, question: question)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28))
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private func balloon(_ k: Int, _ option: String, question: BalloonsGame.Question, date: Date, size: CGSize) -> some View {
        let columns = CGFloat(max(1, question.options.count))
        let column: CGFloat = size.width / columns
        let width: CGFloat = min(108, column - 10)
        let total: CGFloat = BalloonView.totalHeight(width: width)
        let startTop: CGFloat = size.height + 16
        let endTop: CGFloat = -total - 20
        let rise = CGFloat(game.rise(of: k, at: date))
        let top: CGFloat = startTop + (endTop - startTop) * rise
        let elapsed: Double = (game.frozenAt ?? date).timeIntervalSince(game.launchDate)
        let wave: Double = sin(elapsed * 1.7 + Double(k) * 2.1) * 6
        let sway: CGFloat = reduceMotion ? 0 : CGFloat(wave)
        let bodyCenter: CGFloat = top + width * 0.59
        let tappable = game.outcome == nil && bodyCenter > 0 && bodyCenter < size.height
        let x: CGFloat = column * (CGFloat(k) + 0.5) + sway
        let y: CGFloat = top + total / 2

        return Button {
            game.pop(k)
        } label: {
            BalloonView(label: option, color: BalloonPalette.color(k), width: width, look: look(k, question: question))
        }
        .buttonStyle(.plain)
        .allowsHitTesting(tappable)
        .accessibilityLabel(option)
        .accessibilityHidden(!tappable)
        .position(x: x, y: y)
    }

    private func look(_ k: Int, question: BalloonsGame.Question) -> BalloonLook {
        switch game.outcome {
        case nil: .flying
        case .hit: k == game.picked ? .popped : .idle
        case .wrong: k == game.picked ? .wrong : (k == question.correct ? .ringed : .idle)
        case .missed: k == question.correct ? .ringed : .idle
        }
    }

    private func banner(_ outcome: BalloonsGame.Outcome, question: BalloonsGame.Question) -> some View {
        let ok = outcome == .hit
        return Text(message(for: outcome, question: question))
            .font(.system(size: 17, weight: .heavy))
            .foregroundStyle(ok ? Theme.okText : Theme.badText)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(ok ? Theme.okBg : Theme.badBg, in: RoundedRectangle(cornerRadius: 3))
            .accessibilityAddTraits(.isStaticText)
    }

    private func message(for outcome: BalloonsGame.Outcome, question: BalloonsGame.Question) -> String {
        switch outcome {
        case .hit: "Knal! +1"
        case .wrong: "Mis. Het is: \(question.word.en)"
        case .missed: "Weg! Het was: \(question.word.en)"
        }
    }
}
