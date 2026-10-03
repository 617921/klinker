import SwiftUI

/// The small "..." menu: day or night, test mode (all places open), jump to the demo moment, or start over.
struct SettingsMenu: View {
    let onDemo: () -> Void
    let onReset: () -> Void

    @Environment(ProgressStore.self) private var progress
    @AppStorage(StadLight.storageKey) private var light: StadLight = .auto

    var body: some View {
        Menu {
            Picker(selection: $light) {
                ForEach(StadLight.allCases) { option in
                    Label(option.label, systemImage: option.systemImage).tag(option)
                }
            } label: {
                Label("Dag en nacht", systemImage: "sun.and.horizon")
            }
            .pickerStyle(.menu)
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
                .background(Color.white, in: Circle())
                .shadow(color: Theme.ink.opacity(0.2), radius: 3, y: 2)
                .contentShape(Circle())
        }
        .accessibilityLabel("Instellingen")
    }
}
