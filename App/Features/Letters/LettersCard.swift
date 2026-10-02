import SwiftUI

/// The home card for De Anonieme Brieven: a red brievenbus (with an envelope in the slot when
/// there's unread mail), "Post voor Noor" and how many letters are new. Opens `LettersView`.
struct LettersCard: View {
    @Environment(ProgressStore.self) private var progress
    @State private var isOpen = false

    private let store: LetterStore
    private let content: LetterContent

    init(store: LetterStore = .shared, content: LetterContent = .shared) {
        self.store = store
        self.content = content
    }

    var body: some View {
        let shelf = LetterShelf(content: content, store: store, progress: progress)
        let unread = shelf.unreadCount
        Button { isOpen = true } label: {
            HStack(alignment: .center, spacing: 14) {
                LetterMailbox(hasMail: unread > 0)
                    .frame(width: 72, height: 96)
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        CourierLabel(text: "De anonieme brieven", size: 12)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        Spacer(minLength: 0)
                        if unread > 0 { LetterNewBadge(count: unread) }
                    }
                    Text("Post voor Noor")
                        .font(.system(size: 22, weight: .heavy))
                        .tracking(-0.4)
                        .foregroundStyle(Theme.ink)
                    Text(line(shelf))
                        .font(Fonts.body(14))
                        .foregroundStyle(Theme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Image(systemName: "chevron.right")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Theme.muted)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("De anonieme brieven: post voor Noor. \(line(shelf)).\(unread > 0 ? " \(unread) nieuw." : "")")
        .accessibilityHint("Open de brieven.")
        .accessibilityAddTraits(.isButton)
        .letterCover(isPresented: $isOpen) {
            LettersView(store: store, content: content)
                .environment(progress)
        }
    }

    private func line(_ shelf: LetterShelf) -> String {
        if let next = shelf.unread.first { return "Brief \(next.number) is er" }
        return "Geen nieuwe post"
    }
}
