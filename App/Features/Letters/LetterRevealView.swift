import SwiftUI

/// Onthulling: after letter 62 the sender steps forward. Title in cut-outs, portrait, their
/// letter, and paper strips raining down (still when Reduce Motion is on).
struct LetterRevealScreen: View {
    let reveal: LetterReveal
    let suspect: LetterSuspect?
    let store: LetterStore
    var animated = true
    let onClose: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack(alignment: .top) {
            Theme.paper.ignoresSafeArea()
            LetterConfetti(animated: animated && !reduceMotion)
                .ignoresSafeArea()
            LetterScroll {
                VStack(spacing: 18) {
                    HStack {
                        LetterCaption(text: "Brief \(LetterContent.finalNumber) · ontcijferd", size: 12)
                        Spacer()
                        CircleIconButton(systemName: "xmark", label: "Terug naar het dossier", action: onClose)
                    }
                    title
                    portrait
                    Text(reveal.text)
                        .font(Fonts.reading(18))
                        .foregroundStyle(Theme.ink)
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(LetterRuledPaper())
                        .shadow(color: LetterInk.hex(0x3C280A, 0.15), radius: 6, y: 4)
                        .rotationEffect(.degrees(0.6))
                    Button("Naar het dossier", action: onClose)
                        .buttonStyle(InkButtonStyle())
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
            }
        }
        .onAppear {
            store.markRevealSeen()
            Haptics.success()
        }
    }

    private var title: some View {
        let tokens = LetterMarkup.tokens(reveal.title)
        return LetterFlowLayout(spacing: 6, lineSpacing: 6, alignment: .center) {
            ForEach(tokens) { token in
                StripView(text: token.text, style: LetterMarkup.style(for: token.text), size: token.id == 0 ? 40 : 30)
                    .rotationEffect(.degrees(Tilt.at(token.id) * 1.5))
            }
        }
        .padding(.top, 6)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(reveal.title)
        .accessibilityAddTraits(.isHeader)
    }

    private var portrait: some View {
        VStack(spacing: 8) {
            LetterPortrait(suspectID: suspect?.id ?? reveal.sender)
                .frame(width: 168, height: 150)
                .padding(10)
                .padding(.bottom, 26)
                .background(Color.white)
                .overlay(alignment: .bottom) {
                    if let suspect {
                        StripView(text: suspect.name, style: suspect.style, size: 15)
                            .padding(.bottom, 8)
                    }
                }
                .shadow(color: LetterInk.hex(0x281400, 0.25), radius: 6, y: 4)
                .overlay(alignment: .top) { LetterPin(size: 18).offset(y: -6) }
                .rotationEffect(.degrees(-2.5))
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(suspect.map { "Foto van \($0.name)" } ?? "Foto van X")
    }
}

/// Paper strips falling like confetti, in the ten strip colours.
struct LetterConfetti: View {
    var animated: Bool
    var count = 42

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 30, paused: !animated)) { timeline in
            let t = animated ? timeline.date.timeIntervalSinceReferenceDate : 0
            Canvas { ctx, size in
                for i in 0..<count {
                    let seed = Double(LetterMarkup.fnv1a("strip\(i)") % 10_000) / 10_000
                    let seed2 = Double(LetterMarkup.fnv1a("sway\(i)") % 10_000) / 10_000
                    let speed = 40 + seed * 60
                    let span = size.height + 60
                    let y = (seed2 * span + t * speed).truncatingRemainder(dividingBy: span) - 30
                    let x = seed * size.width + sin(t * (0.8 + seed2) + seed * 6) * 18
                    let angle = Angle.degrees((t * (60 + seed2 * 120) + seed * 360).truncatingRemainder(dividingBy: 360))
                    var strip = ctx
                    strip.translateBy(x: x, y: y)
                    strip.rotate(by: angle)
                    let w = 7 + seed2 * 6, h = 16 + seed * 12
                    strip.fill(Path(CGRect(x: -w / 2, y: -h / 2, width: w, height: h)),
                               with: .color(StripStyle.at(i).background.opacity(0.9)))
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
