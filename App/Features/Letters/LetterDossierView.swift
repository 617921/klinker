import SwiftUI

/// Dossier: who is X? The corkboard, your verdict, the next-letter teaser and every clue so far.
struct LetterDossierScreen: View {
    let content: LetterContent
    let store: LetterStore
    let shelf: LetterShelf
    let session: LetterSession
    var animateStrings = true
    let onReveal: () -> Void

    @Environment(ProgressStore.self) private var progress

    var body: some View {
        LetterScroll {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    Text("WIE IS X?")
                        .font(.custom("AvenirNext-Heavy", size: 22))
                        .foregroundStyle(Theme.onInk)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 1)
                        .background(Theme.ink)
                        .rotationEffect(.degrees(-1.5))
                        .accessibilityAddTraits(.isHeader)
                    Spacer(minLength: 0)
                    Chip(text: store.clues.count == 1 ? "1 aanwijzing" : "\(store.clues.count) aanwijzingen",
                         systemImage: "pin.fill")
                }
                Text(verdict)
                    .font(.system(size: 15, weight: session.lastSuspect == nil ? .regular : .bold))
                    .foregroundStyle(session.lastSuspect == nil ? Theme.muted : Theme.ink)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityAddTraits(.updatesFrequently)
                LetterBoard(content: content, store: store, highlight: session.showClue ? session.number : nil, pending: pending,
                            animateStrings: animateStrings) { tap($0) }
                    .frame(maxWidth: .infinity)
                if canReveal {
                    Button("Lees wie X is", action: onReveal)
                        .buttonStyle(InkButtonStyle())
                        .padding(.top, 4)
                }
                teaser
                LetterClueList(content: content, store: store)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
        }
    }

    private var canReveal: Bool {
        content.reveal != nil && store.solved.contains(LetterContent.finalNumber)
    }

    /// The newest letter that is here but not decoded yet.
    private var pending: Int? {
        shelf.available.last { !store.solved.contains($0.number) }?.number
    }

    private var verdict: String {
        let levels = content.suspects.map { ($0, store.level(of: $0.id)) }
        let top = levels.map(\.1).max() ?? 0
        guard top > 0 else { return "Je verdenkt nog niemand. Tik op een kaart: meer loepjes = meer verdenking." }
        let names = levels.filter { $0.1 == top }.map(\.0.name)
        if names.count == 1 { return "Jij verdenkt nu: \(names[0])." }
        return "Je twijfelt nog tussen \(names.dropLast().joined(separator: ", ")) en \(names.last ?? "")."
    }

    private func tap(_ suspect: LetterSuspect) {
        store.cycleSuspicion(suspect.id)
        session.lastSuspect = suspect.id
        Haptics.tap()
    }

    @ViewBuilder
    private var teaser: some View {
        if let upcoming = shelf.upcoming.first {
            let current = progress.currentSheetNumber
            let total = progress.content.sheet(current)?.words.count ?? 11
            HStack(spacing: 12) {
                Image(systemName: "envelope")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Theme.orangeText)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text(shelf.latest?.teaser ?? "Volgende brief: als vel \(upcoming.number) op je muur hangt.")
                        .font(.system(size: 15, weight: .heavy))
                        .foregroundStyle(Theme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    LetterCaption(text: "Nu vel \(current) · \(progress.learnedCount(inSheet: current)) / \(total) woorden", size: 12)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(LetterInk.cream)
            .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Theme.dashed, style: StrokeStyle(lineWidth: 2, dash: [6, 4])))
            .rotationEffect(.degrees(-0.5))
            .accessibilityElement(children: .combine)
        }
    }
}

/// Every clue earned so far, newest first.
private struct LetterClueList: View {
    let content: LetterContent
    let store: LetterStore

    var body: some View {
        let earned = content.letters.reversed().filter { store.clues.contains($0.number) }
        if !earned.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                LetterCaption(text: "Alle aanwijzingen · \(earned.count)", size: 12)
                    .padding(.top, 8)
                ForEach(earned) { letter in
                    let kind = LetterClueKind(letter.clue.kind)
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: kind.symbol)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Theme.label)
                            .frame(width: 24)
                            .accessibilityHidden(true)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(letter.clue.text)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Theme.ink)
                                .fixedSize(horizontal: false, vertical: true)
                            LetterCaption(text: caption(letter, kind: kind), size: 11)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(12)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }

    private func caption(_ letter: Letter, kind: LetterClueKind) -> String {
        let who = content.suspect(letter.clue.suspect)?.name ?? "niemand"
        return "Brief \(letter.number) · \(kind.label) · wijst naar \(who)"
    }
}
