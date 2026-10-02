import SwiftUI

/// The envelope opening: the wax seal breaks, the flap flips up, the folded letter slides out.
/// (The unfold itself is the transition into `LetterPaper`.) Tap to skip.
struct LetterOpening: View {
    let letter: Letter
    let tokens: [LetterToken]
    let phase: LetterPhase
    let onSkip: () -> Void

    private let stage = CGSize(width: 340, height: 540)
    private let envelope = CGSize(width: 330, height: 210)
    private let folded = CGSize(width: 290, height: 168)
    private var envelopeTop: CGFloat { 300 }

    var body: some View {
        Button(action: onSkip) {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(LetterInk.envelope)
                    .frame(width: envelope.width, height: envelope.height)
                    .shadow(color: LetterInk.hex(0x3C280A, 0.2), radius: 8, y: 8)
                    .offset(y: envelopeTop)
                    .zIndex(1)
                flap.zIndex(phase >= .sliding ? 1.5 : 5)
                LetterFoldedNote(tokens: tokens)
                    .frame(width: folded.width, height: folded.height)
                    .offset(y: phase >= .sliding ? 70 : envelopeTop + 18)
                    .zIndex(2)
                pocket.zIndex(3)
                LetterWaxSeal(size: 60, broken: phase >= .unsealed)
                    .scaleEffect(phase >= .unsealed ? 1.5 : 1)
                    .rotationEffect(.degrees(phase >= .unsealed ? 25 : 0))
                    .opacity(phase >= .unsealed ? 0 : 1)
                    .offset(y: envelopeTop + envelope.height * 0.62 - 30)
                    .zIndex(6)
            }
            .frame(width: stage.width, height: stage.height, alignment: .top)
            .overlay(alignment: .bottom) {
                LetterCaption(text: "Brief \(letter.number) gaat open…", size: 13)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Brief \(letter.number) gaat open")
        .accessibilityHint("Tik om meteen te lezen.")
    }

    private var flap: some View {
        LetterPolygon.flapAlone
            .fill(phase >= .unsealed ? LetterInk.hex(0xC4AB7C) : LetterInk.flap)
            .frame(width: envelope.width, height: envelope.height * 0.62)
            .rotation3DEffect(.degrees(phase >= .unsealed ? 178 : 0), axis: (x: 1, y: 0, z: 0),
                              anchor: .top, perspective: 0.5)
            .offset(y: envelopeTop)
    }

    private var pocket: some View {
        LetterPolygon.pocket
            .fill(LetterInk.pocket)
            .frame(width: envelope.width, height: envelope.height)
            .overlay(alignment: .bottomLeading) {
                Text("Aan: Noor · Utrecht")
                    .font(Fonts.label(13))
                    .foregroundStyle(LetterInk.envelopeInk)
                    .padding(.leading, 18)
                    .padding(.bottom, 14)
            }
            .offset(y: envelopeTop)
    }
}

/// The letter still folded in three: creases and a few cut-outs showing through.
private struct LetterFoldedNote: View {
    let tokens: [LetterToken]

    var body: some View {
        Canvas { ctx, size in
            ctx.fill(Path(CGRect(origin: .zero, size: size)), with: .color(LetterInk.cream))
            var x: CGFloat = 16
            var y: CGFloat = 18
            for token in tokens.prefix(14) {
                let style = StripStyle.at(LetterMarkup.style(for: token.text))
                let w = CGFloat(min(70, 12 + token.text.count * 7))
                if x + w > size.width - 14 { x = 16; y += 22 }
                ctx.fill(Path(CGRect(x: x, y: y, width: w, height: 14)), with: .color(style.background))
                x += w + 6
            }
            for k in 1...2 {
                let cy = size.height * CGFloat(k) / 3
                ctx.fill(Path(CGRect(x: 0, y: cy - 0.5, width: size.width, height: 1.2)), with: .color(LetterInk.paperNote.opacity(0.35)))
                ctx.fill(Path(CGRect(x: 0, y: cy, width: size.width, height: 5)), with: .color(Color.black.opacity(0.04)))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .shadow(color: LetterInk.hex(0x3C280A, 0.18), radius: 6, y: 4)
        .accessibilityHidden(true)
    }
}
