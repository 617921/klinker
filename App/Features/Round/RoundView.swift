import SwiftUI

/// A round, shown full screen by `RootView`.
/// `.full` plays Match rush → Ballonnen → Knip & plak → results; a single kind plays that game, then results.
struct RoundView: View {
    let kind: RoundKind

    @Environment(ProgressStore.self) private var progress
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var model: RoundModel?

    init(kind: RoundKind) {
        self.kind = kind
    }

    var body: some View {
        ZStack {
            Theme.paper.ignoresSafeArea()
            if let model {
                if model.isEmpty {
                    RoundEmptyView(onClose: close)
                } else {
                    stageView(model)
                        .id(model.stageIndex)
                        .transition(stageTransition)
                }
            }
        }
        .onAppear {
            if model == nil { model = RoundModel(kind: kind, progress: progress) }
        }
        .onDisappear { Speech.shared.stop() }
    }

    @ViewBuilder
    private func stageView(_ model: RoundModel) -> some View {
        switch model.stage {
        case .match:
            MatchRushView(round: model, onClose: close)
        case .balloons:
            BalloonsView(round: model, onClose: close)
        case .ransom:
            RansomView(round: model, onClose: close)
        case .results:
            RoundResultsView(round: model, onDone: close)
        }
    }

    private var stageTransition: AnyTransition {
        if reduceMotion { return .opacity }
        return .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }

    private func close() {
        Speech.shared.stop()
        dismiss()
    }
}

/// No words to play with (no content yet).
struct RoundEmptyView: View {
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                RoundCloseButton(action: onClose)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 10) {
                    Doodle(kind: .zigzag, color: Theme.doodles[0])
                    Doodle(kind: .dots, color: Theme.doodles[2])
                }
                .accessibilityHidden(true)
                Text("Nog geen woorden")
                    .font(Fonts.cta(28))
                    .foregroundStyle(Theme.onInk)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 3)
                    .background(Theme.ink)
                    .rotationEffect(.degrees(-1.5))
                    .accessibilityAddTraits(.isHeader)
                Text("Er staan nu geen woorden klaar voor een ronde. Kom terug als je volgende vel er is.")
                    .font(.body)
                    .foregroundStyle(Theme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            Button("Terug naar je stad", action: onClose)
                .buttonStyle(InkButtonStyle())
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
    }
}
