import SwiftUI

/// The small "..." menu: test mode (all places open), jump to the demo moment, or start over.
struct SettingsMenu: View {
    let onDemo: () -> Void
    let onReset: () -> Void

    @Environment(ProgressStore.self) private var progress

    var body: some View {
        Menu {
            Toggle(isOn: Binding(get: { progress.unlockAll }, set: { on in
                withAnimation(.spring) { progress.setUnlockAll(on) }
            })) {
                Label("Testmodus: alle plekken open", systemImage: "lock.open")
            }
            Divider()
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
