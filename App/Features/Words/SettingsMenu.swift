import SwiftUI

/// The small "..." menu: jump to the demo moment, or start over.
struct SettingsMenu: View {
    let onDemo: () -> Void
    let onReset: () -> Void

    var body: some View {
        Menu {
            Button(action: onDemo) {
                Label("Demo: spring naar vel 14", systemImage: "forward.end")
            }
            Button(role: .destructive, action: onReset) {
                Label("Begin opnieuw", systemImage: "arrow.counterclockwise")
            }
        } label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Theme.ink)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .accessibilityLabel("Instellingen")
    }
}
