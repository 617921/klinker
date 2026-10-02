import SwiftUI

/// Postbus: the next letter as a big envelope (sealed and wobbling when it's new), every other
/// letter that has arrived as a small tile, and faint outlines of letters still on their way.
struct LetterPostbusScreen: View {
    let shelf: LetterShelf
    let store: LetterStore
    let onOpen: (Letter) -> Void
    let onDossier: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        LetterScroll {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    CourierLabel(text: "De anonieme brieven")
                    Text("Post voor Noor")
                        .font(.system(size: 28, weight: .heavy))
                        .tracking(-0.6)
                        .foregroundStyle(Theme.ink)
                        .accessibilityAddTraits(.isHeader)
                    Text("Iemand stuurt Noor brieven van knipsels. Elke brief is gemaakt van jouw woorden.")
                        .font(Fonts.body(14))
                        .foregroundStyle(Theme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                if let hero = shelf.next {
                    heroEnvelope(hero)
                } else {
                    LetterEmptyPost()
                }
                let others = shelf.available.filter { $0.number != shelf.next?.number }
                if !others.isEmpty {
                    LetterCaption(text: "Je brieven · \(shelf.available.count)", size: 13)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 10) {
                        ForEach(Array(others.enumerated()), id: \.element.id) { k, letter in
                            LetterTile(letter: letter, state: state(of: letter)) { onOpen(letter) }
                                .rotationEffect(.degrees(Tilt.at(k)))
                        }
                    }
                }
                if !shelf.upcoming.isEmpty {
                    LetterCaption(text: "Nog onderweg", size: 13)
                    HStack(spacing: 10) {
                        ForEach(shelf.upcoming.prefix(2)) { LetterLockedTile(letter: $0) }
                    }
                }
                if !shelf.available.isEmpty {
                    Button(store.clues.count == 1 ? "Open het dossier · 1 aanwijzing" : "Open het dossier · \(store.clues.count) aanwijzingen",
                           action: onDossier)
                        .buttonStyle(OutlineButtonStyle())
                        .padding(.top, 4)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }

    private func state(of letter: Letter) -> LetterTile.Status {
        if store.solved.contains(letter.number) { return .solved }
        return store.opened.contains(letter.number) ? .read : .new
    }

    private func heroEnvelope(_ letter: Letter) -> some View {
        let isNew = !store.opened.contains(letter.number)
        return VStack(spacing: 12) {
            Button { onOpen(letter) } label: {
                LetterEnvelopeFace(sealed: isNew, tag: isNew ? "NIEUW" : "GELEZEN")
                    .modifier(LetterWobble(active: isNew && !reduceMotion))
                    .rotationEffect(.degrees(isNew ? 0 : -1.5))
                    .padding(.vertical, 10)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isNew ? "Open brief \(letter.number), nieuw" : "Lees brief \(letter.number) opnieuw")
            VStack(spacing: 2) {
                Text(isNew ? "Brief \(letter.number) · tik om te openen" : "Brief \(letter.number) · tik om opnieuw te lezen")
                    .font(.system(size: 15, weight: .heavy))
                    .foregroundStyle(Theme.ink)
                LetterCaption(text: "Vel \(letter.number) · \(letter.place)", size: 11)
            }
            .accessibilityHidden(true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(alignment: .topLeading) {
            Doodle(kind: .zigzag, color: Theme.doodles[0]).offset(x: -4, y: 2)
        }
        .background(alignment: .bottomTrailing) {
            Doodle(kind: .rings, color: Theme.doodles[2]).offset(y: -44)
        }
    }
}

/// The gentle wobble of a new letter (rest, then a little shake, every 2.6 s).
private struct LetterWobble: ViewModifier {
    let active: Bool

    func body(content: Content) -> some View {
        if active {
            content.keyframeAnimator(initialValue: -1.5, repeating: true) { view, angle in
                view.rotationEffect(.degrees(angle))
            } keyframes: { _ in
                KeyframeTrack {
                    LinearKeyframe(-1.5, duration: 1.6)
                    CubicKeyframe(2.5, duration: 0.16)
                    CubicKeyframe(-3, duration: 0.16)
                    CubicKeyframe(2, duration: 0.16)
                    CubicKeyframe(-1, duration: 0.16)
                    CubicKeyframe(-1.5, duration: 0.36)
                }
            }
        } else {
            content.rotationEffect(.degrees(-1.5))
        }
    }
}

/// A small tile for a letter that has arrived.
private struct LetterTile: View {
    enum Status { case new, read, solved }
    let letter: Letter
    let state: Status
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                LetterMiniEnvelope()
                Text("\(letter.number)")
                    .font(Fonts.label(12))
                    .foregroundStyle(Theme.muted)
            }
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 2))
            .overlay(alignment: .topTrailing) { badge.offset(x: 4, y: -4) }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Brief \(letter.number), \(label)")
    }

    @ViewBuilder
    private var badge: some View {
        switch state {
        case .new:
            Circle().fill(Theme.orange).frame(width: 12, height: 12)
                .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
        case .solved:
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Theme.okLine, Color.white)
                .background(Circle().fill(Color.white).padding(1))
        case .read:
            EmptyView()
        }
    }

    private var label: String {
        switch state {
        case .new: "nieuw"
        case .read: "gelezen, nog niet ontcijferd"
        case .solved: "ontcijferd"
        }
    }
}

/// A faint outline for a letter that's still on its way.
private struct LetterLockedTile: View {
    let letter: Letter

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "envelope")
                .font(.system(size: 16))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 0) {
                Text("Brief \(letter.number)").font(.system(size: 14, weight: .heavy))
                LetterCaption(text: "na vel \(max(1, letter.number - 1))", color: Theme.muted, size: 11)
            }
            Spacer(minLength: 0)
        }
        .foregroundStyle(Theme.muted)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
        .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Theme.dashed, style: StrokeStyle(lineWidth: 1.5, dash: [5, 4])))
        .opacity(0.75)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Brief \(letter.number) komt na vel \(max(1, letter.number - 1)).")
    }
}

/// No letters yet (letters.json missing or empty).
private struct LetterEmptyPost: View {
    var body: some View {
        VStack(spacing: 10) {
            LetterMailbox(hasMail: false).frame(width: 90, height: 120)
            Text("Nog geen post")
                .font(.system(size: 20, weight: .heavy))
                .foregroundStyle(Theme.ink)
            Text("De brieven zijn onderweg. Kom straks terug.")
                .font(Fonts.body(15))
                .foregroundStyle(Theme.muted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }
}
