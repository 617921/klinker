import SwiftUI

/// De Anonieme Brieven, full screen: Postbus → Brief (open, read) → Ontcijfer → Dossier, and the
/// Onthulling after letter 62. One state machine (`LetterSession`); close with the X.
struct LettersView: View {
    @Environment(ProgressStore.self) private var progress
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var session: LetterSession
    private let store: LetterStore
    private let content: LetterContent
    private let animated: Bool

    init(store: LetterStore = .shared, content: LetterContent = .shared,
         session: LetterSession? = nil, animated: Bool = true) {
        self.store = store
        self.content = content
        self.animated = animated
        _session = State(initialValue: session ?? LetterSession())
    }

    var body: some View {
        let shelf = LetterShelf(content: content, store: store, progress: progress)
        VStack(spacing: 0) {
            if session.screen != .reveal {
                LetterTabBar(selected: tab, briefTitle: session.number.map { "Brief \($0)" } ?? "Brief",
                             briefEnabled: shelf.next != nil || session.number != nil,
                             onClose: close) { go($0, shelf: shelf) }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
            }
            screen(shelf)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Theme.paper.ignoresSafeArea())
        .onAppear {
            if store.solved.contains(LetterContent.finalNumber), !store.revealSeen, content.reveal != nil {
                session.screen = .reveal
            }
        }
        .onDisappear { Speech.shared.stop() }
    }

    @ViewBuilder
    private func screen(_ shelf: LetterShelf) -> some View {
        switch session.screen {
        case .postbus:
            LetterPostbusScreen(shelf: shelf, store: store, onOpen: open) { switchTo(.dossier) }
        case .letter:
            if let letter = currentLetter {
                LetterReadScreen(letter: letter, store: store, session: session, words: progress.content,
                                 onQuiz: { switchTo(.quiz) }, onDossier: { switchTo(.dossier) })
            } else {
                LetterPostbusScreen(shelf: shelf, store: store, onOpen: open) { switchTo(.dossier) }
            }
        case .quiz:
            if let letter = currentLetter {
                LetterQuizScreen(letter: letter, store: store, content: content, session: session,
                                 onBack: { switchTo(.letter) }, onDossier: { switchTo(.dossier) },
                                 onReveal: { switchTo(.reveal) })
            }
        case .dossier:
            LetterDossierScreen(content: content, store: store, shelf: shelf, session: session,
                                animateStrings: animated) { switchTo(.reveal) }
        case .reveal:
            if let reveal = content.reveal {
                LetterRevealScreen(reveal: reveal, suspect: content.suspect(reveal.sender), store: store,
                                   animated: animated) { switchTo(.dossier) }
            }
        }
    }

    private var currentLetter: Letter? { session.number.flatMap { content.letter($0) } }

    private var tab: LetterTab {
        switch session.screen {
        case .postbus: .postbus
        case .letter, .quiz: .brief
        case .dossier, .reveal: .dossier
        }
    }

    // MARK: - Moves

    private func open(_ letter: Letter) {
        let firstTime = !store.opened.contains(letter.number)
        session.show(letter.number, firstTime: firstTime, reduceMotion: reduceMotion || !animated)
        store.markOpened(letter.number)
    }

    private func go(_ tab: LetterTab, shelf: LetterShelf) {
        switch tab {
        case .postbus: switchTo(.postbus)
        case .dossier: switchTo(.dossier)
        case .brief:
            if let number = session.number, content.letter(number) != nil {
                if session.screen != .letter && session.screen != .quiz { switchTo(.letter) }
            } else if let next = shelf.next {
                open(next)
            }
        }
    }

    private func switchTo(_ screen: LetterScreen) {
        Speech.shared.stop()
        if screen == .letter, session.phase != .open { session.phase = .open }
        if screen == .quiz { session.startQuiz(); return }
        session.screen = screen
    }

    private func close() {
        Speech.shared.stop()
        dismiss()
    }
}

enum LetterTab: CaseIterable {
    case postbus, brief, dossier
}

/// Close button and the Postbus · Brief · Dossier switch.
private struct LetterTabBar: View {
    let selected: LetterTab
    let briefTitle: String
    let briefEnabled: Bool
    let onClose: () -> Void
    let onSelect: (LetterTab) -> Void

    var body: some View {
        HStack(spacing: 10) {
            CircleIconButton(systemName: "xmark", label: "Sluiten", action: onClose)
            HStack(spacing: 4) {
                ForEach(LetterTab.allCases, id: \.self) { tab in
                    let on = tab == selected
                    Button { onSelect(tab) } label: {
                        Text(title(tab))
                            .font(.system(size: 15, weight: .heavy))
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                            .foregroundStyle(on ? Theme.onInk : Theme.ink)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(on ? Theme.ink : Color.clear, in: RoundedRectangle(cornerRadius: 3))
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .disabled(tab == .brief && !briefEnabled)
                    .opacity(tab == .brief && !briefEnabled ? 0.4 : 1)
                    .accessibilityAddTraits(on ? .isSelected : [])
                }
            }
            .padding(3)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 5))
        }
    }

    private func title(_ tab: LetterTab) -> String {
        switch tab {
        case .postbus: "Postbus"
        case .brief: briefTitle
        case .dossier: "Dossier"
        }
    }
}
