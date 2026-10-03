import SwiftUI

/// The Stad tab: header with progress, "Jouw straat" (the gevelkit street) and "Jouw kaart"
/// (the canal-ring map with the 62 places). Day/night follows the clock unless toggled.
struct StadView: View {
    @Environment(ProgressStore.self) private var progress
    @Environment(\.startRound) private var startRound
    @Environment(\.enterPlace) private var enterPlace

    @State private var nightOverride: Bool?
    @State private var clockNight = StadClock.isNight()
    @State private var picked: StadPlacePick?
    @State private var pendingRound: RoundKind?
    @State private var pendingVisit: Int?
    @State private var confirmReset = false
    @State private var onScreen = false
    @State private var streetVisible = true
    @State private var mapVisible = false

    private var night: Bool { nightOverride ?? clockNight }

    /// Toggling back to what the clock says hands control back to the clock.
    private var nightBinding: Binding<Bool> {
        Binding(
            get: { nightOverride ?? clockNight },
            set: { value in nightOverride = value == clockNight ? nil : value }
        )
    }

    var body: some View {
        let statuses = (1...ContentStore.totalSheets).map { progress.status(ofSheet: $0) }
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                StadHeader(
                    statuses: statuses,
                    wordsOnWall: progress.wordsOnWall,
                    streak: progress.streak(),
                    onDemo: { withAnimation(.spring) { progress.seedDemo() } },
                    onReset: { confirmReset = true }
                )
                .padding(.horizontal, 16)

                NowCard(onOpen: { picked = StadPlacePick(n: progress.currentSheetNumber) })
                    .padding(.horizontal, 16)

                LettersCard()
                    .padding(.horizontal, 16)

                HouseCard()
                    .padding(.horizontal, 16)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Jouw straat")
                        .font(.system(size: 26, weight: .heavy))
                        .tracking(-0.6)
                        .accessibilityAddTraits(.isHeader)
                    StraatView(night: nightBinding, active: onScreen && streetVisible)
                }
                .padding(.horizontal, 16)
                .onGeometryChange(for: Bool.self) { Self.isVisible($0) } action: { streetVisible = $0 }

                StadMapView(
                    statuses: statuses,
                    currentPlace: progress.currentSheetNumber,
                    night: nightBinding,
                    selected: $picked,
                    active: onScreen && mapVisible
                )
                .onGeometryChange(for: Bool.self) { Self.isVisible($0) } action: { mapVisible = $0 }
            }
            .padding(.top, 12)
            .padding(.bottom, 32)
        }
        .coordinateSpace(.named("stad"))
        .background(Theme.paper)
        .sheet(item: $picked, onDismiss: runPendingRound) { pick in
            StadPlaceSheet(
                n: pick.n,
                night: night,
                onRepair: { start(.match) },
                onPlay: { start(.full) },
                onEnter: { pendingVisit = pick.n; picked = nil }
            )
        }
        .confirmationDialog("Opnieuw beginnen?", isPresented: $confirmReset, titleVisibility: .visible) {
            Button("Alles wissen en opnieuw beginnen", role: .destructive) {
                withAnimation(.spring) { progress.reset() }
            }
        } message: {
            Text("Al je woorden en je stad gaan terug naar het begin.")
        }
        .onAppear {
            onScreen = true
            clockNight = StadClock.isNight()
        }
        .onDisappear { onScreen = false }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(60))
                clockNight = StadClock.isNight()
            }
        }
    }

    /// Whether a view intersects the visible part of the Stad scroll view.
    nonisolated private static func isVisible(_ proxy: GeometryProxy) -> Bool {
        guard let bounds = proxy.bounds(of: .named("stad")) else { return true }
        return bounds.intersects(CGRect(origin: .zero, size: proxy.size))
    }

    /// Rounds start after the sheet has gone, so the full-screen cover can present.
    private func start(_ kind: RoundKind) {
        pendingRound = kind
        picked = nil
    }

    private func runPendingRound() {
        if let place = pendingVisit {
            pendingVisit = nil
            enterPlace(place)
            return
        }
        guard let kind = pendingRound else { return }
        pendingRound = nil
        startRound(kind)
    }
}

/// "DE STAD" strip, streak, "x van 62 plekken gebouwd · n / 682 woorden" and a 62-segment bar.
private struct StadHeader: View {
    let statuses: [SheetStatus]
    let wordsOnWall: Int
    let streak: Int
    let onDemo: () -> Void
    let onReset: () -> Void

    @Environment(ProgressStore.self) private var progress

    var body: some View {
        let built = statuses.filter { $0 == .built || $0 == .fading }.count
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Text("KLINKER")
                    .font(Fonts.cta(26))
                    .foregroundStyle(Theme.onInk)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(Theme.ink)
                    .rotationEffect(.degrees(-2))
                    .accessibilityAddTraits(.isHeader)
                Spacer(minLength: 8)
                if streak > 0 {
                    Chip(text: streak == 1 ? "1 dag" : "\(streak) dagen", systemImage: "bicycle")
                        .accessibilityLabel("\(streak) \(streak == 1 ? "dag" : "dagen") op rij")
                }
                SettingsMenu(onDemo: onDemo, onReset: onReset)
            }
            Text("\(built) van \(ContentStore.totalSheets) plekken gebouwd · \(wordsOnWall) / \(ContentStore.totalWords) woorden")
                .font(Fonts.body(14))
                .foregroundStyle(Theme.muted)
                .fixedSize(horizontal: false, vertical: true)
            if progress.unlockAll {
                Button {
                    withAnimation(.spring) { progress.setUnlockAll(false) }
                } label: {
                    Label("Testmodus aan · alle plekken open · zet uit", systemImage: "lock.open")
                        .font(.system(size: 13, weight: .heavy))
                        .foregroundStyle(Theme.orangeText)
                        .padding(.horizontal, 12)
                        .frame(minHeight: 32)
                        .background(Color(hex: 0xFCE3CF), in: Capsule())
                }
                .buttonStyle(.plain)
                .accessibilityHint("Tik om de testmodus uit te zetten.")
            }
            HStack(spacing: 1) {
                ForEach(statuses.indices, id: \.self) { i in
                    Rectangle()
                        .fill(color(statuses[i]))
                        .clipShape(RoundedRectangle(cornerRadius: 1))
                }
            }
            .frame(height: 8)
            .accessibilityHidden(true)
        }
    }

    private func color(_ status: SheetStatus) -> Color {
        switch status {
        case .built: Theme.ink
        case .growing: Theme.orange.opacity(0.45)
        case .current: Theme.orange
        case .fading: Theme.tapeOther
        case .locked: Theme.hairline
        }
    }
}

/// "Nu in aanbouw": the current place, its progress and the round buttons.
private struct NowCard: View {
    let onOpen: () -> Void

    @Environment(ProgressStore.self) private var progress

    var body: some View {
        let n = progress.currentSheetNumber
        let sheet = progress.content.sheet(n)
        let total = sheet?.words.count ?? 11
        let met = min(total, progress.metCount(inSheet: n))
        let left = total - met
        let next = n < ContentStore.totalSheets ? PlaceCatalog.name(n + 1) : nil
        VStack(alignment: .leading, spacing: 16) {
            Button(action: onOpen) {
                HStack(alignment: .center, spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 3).fill(Theme.orange)
                        Image(systemName: PlaceCatalog.symbol(n))
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(Theme.ink)
                    }
                    .frame(width: 52, height: 52)
                    .rotationEffect(.degrees(-3))
                    .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 3) {
                        CourierLabel(text: "Nu bezig · vel \(n)")
                        Text(sheet?.title ?? PlaceCatalog.name(n))
                            .font(.system(size: 22, weight: .heavy))
                            .tracking(-0.4)
                            .foregroundStyle(Theme.ink)
                            .multilineTextAlignment(.leading)
                        Text(next.map { "Nog \(left) \(left == 1 ? "woord" : "woorden") goed, dan gaat \($0) open" } ?? "Nog \(left) \(left == 1 ? "woord" : "woorden") te gaan")
                            .font(Fonts.body(14))
                            .foregroundStyle(Theme.muted)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Theme.muted)
                        .accessibilityHidden(true)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityHint("Bekijk de woorden van deze plek.")

            HStack(spacing: 4) {
                ForEach(0..<total, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(i < met ? Theme.orange : Theme.hairline)
                }
            }
            .frame(height: 10)
            .accessibilityHidden(true)

            PlayButtons()
        }
        .padding(16)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
    }
}
