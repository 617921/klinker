import SwiftUI

/// The home screen: the city map fills the screen, with a small top bar (KLINKER, streak, menu)
/// and the Vandaag panel over the bottom (today's round, current place, post, house; pull up for more).
/// Day and night follow the clock unless set in the menu.
struct StadView: View {
    @Environment(ProgressStore.self) private var progress
    @Environment(\.enterPlace) private var enterPlace
    @Environment(\.startRound) private var startRound
    @AppStorage(StadLight.storageKey) private var light: StadLight = .auto

    @State private var now = Date.now
    @State private var picked: StadPlacePick?
    @State private var pendingRound: RoundKind?
    @State private var pendingVisit: Int?
    @State private var pendingHouse = false
    @State private var houseOpen = false
    @State private var lettersOpen = false
    @State private var confirmReset = false
    @State private var onScreen = false
    @State private var detent: VandaagDetent = .peek
    @State private var topBarHeight: CGFloat = 60
    @State private var peekHeight: CGFloat = 200

    private var mood: KaartMood { KaartMood.at(now, light: light) }
    private var night: Bool { mood.night }

    var body: some View {
        let statuses = (1...ContentStore.totalSheets).map { progress.status(ofSheet: $0) }
        GeometryReader { geo in
            let top = geo.safeAreaInsets.top
            ZStack(alignment: .top) {
                StadMapView(
                    statuses: statuses,
                    currentPlace: progress.currentSheetNumber,
                    mood: mood,
                    selected: $picked,
                    active: onScreen && detent != .full,
                    insets: EdgeInsets(top: top + topBarHeight, leading: 0, bottom: peekHeight, trailing: 0),
                    mail: LetterShelf(content: .shared, store: .shared, progress: progress).unreadCount,
                    onMail: { lettersOpen = true }
                )
                .ignoresSafeArea()

                // Keeps the (dark) clock and battery readable over the busy map, day or night.
                LinearGradient(
                    colors: [Theme.paper.opacity(night ? 0.8 : 0.9), Theme.paper.opacity(0)],
                    startPoint: .top, endPoint: .bottom
                )
                .frame(height: top + 16)
                .ignoresSafeArea(edges: .top)
                .allowsHitTesting(false)
                .accessibilityHidden(true)

                if detent == .full {
                    Theme.ink.opacity(0.28)
                        .ignoresSafeArea()
                        .onTapGesture { setDetent(.half) }
                        .accessibilityHidden(true)
                        .transition(.opacity)
                }

                StadTopBar(
                    streak: progress.streak(),
                    onDemo: { withAnimation(.spring) { progress.seedDemo() } },
                    onReset: { confirmReset = true }
                )
                .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { topBarHeight = $0 }

                VandaagPanel(
                    detent: $detent,
                    maxHeight: geo.size.height + geo.safeAreaInsets.bottom - 8,
                    bottomInset: geo.safeAreaInsets.bottom,
                    night: night,
                    onOpenPlace: openPlace,
                    onPeekHeight: { peekHeight = $0 }
                )
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .background(Theme.paper)
        .sheet(item: $picked, onDismiss: runPendingRound) { pick in
            StadPlaceSheet(
                n: pick.n,
                night: night,
                onRepair: { start(.match) },
                onPlay: { start(.full) },
                onEnter: { pendingVisit = pick.n; picked = nil },
                onHouse: { pendingHouse = true; picked = nil }
            )
        }
        .letterCover(isPresented: $lettersOpen) {
            LettersView()
                .environment(progress)
        }
        .houseCover(isPresented: $houseOpen) {
            HouseView()
                .environment(progress)
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
            now = .now
        }
        .onDisappear { onScreen = false }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(60))
                now = .now
            }
        }
    }

    /// From the panel: fold it away and show the place on the map with its sheet.
    private func openPlace(_ n: Int) {
        setDetent(.peek)
        picked = StadPlacePick(n: n)
        Speech.shared.say(StadPlaces.spoken(n))
        Haptics.tap()
    }

    private func setDetent(_ value: VandaagDetent) {
        withAnimation(.spring(response: 0.36, dampingFraction: 0.86)) { detent = value }
    }

    /// Rounds start after the sheet has gone, so the full-screen cover can present.
    private func start(_ kind: RoundKind) {
        pendingRound = kind
        picked = nil
    }

    private func runPendingRound() {
        if pendingHouse {
            pendingHouse = false
            houseOpen = true
            return
        }
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

/// Floating over the top of the map: the KLINKER strip, the streak and the menu,
/// plus a badge while test mode is on.
private struct StadTopBar: View {
    let streak: Int
    let onDemo: () -> Void
    let onReset: () -> Void

    @Environment(ProgressStore.self) private var progress

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("KLINKER")
                    .font(Fonts.cta(24))
                    .foregroundStyle(Theme.onInk)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(Theme.ink)
                    .rotationEffect(.degrees(-2))
                    .shadow(color: Theme.ink.opacity(0.25), radius: 3, y: 2)
                    .accessibilityAddTraits(.isHeader)
                Spacer(minLength: 8)
                if streak > 0 {
                    Chip(text: streak == 1 ? "1 dag" : "\(streak) dagen", systemImage: "bicycle")
                        .shadow(color: Theme.ink.opacity(0.2), radius: 3, y: 2)
                        .accessibilityLabel("\(streak) \(streak == 1 ? "dag" : "dagen") op rij")
                }
                SettingsMenu(onDemo: onDemo, onReset: onReset)
            }
            if progress.unlockAll {
                Button {
                    withAnimation(.spring) { progress.setUnlockAll(false) }
                } label: {
                    Label("Testmodus aan · zet uit", systemImage: "lock.open")
                        .font(.system(size: 13, weight: .heavy))
                        .foregroundStyle(Theme.orangeText)
                        .padding(.horizontal, 12)
                        .frame(minHeight: 32)
                        .background(Color(hex: 0xFCE3CF), in: Capsule())
                        .shadow(color: Theme.ink.opacity(0.15), radius: 3, y: 2)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Testmodus aan: alle plekken zijn open.")
                .accessibilityHint("Tik om de testmodus uit te zetten.")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
        .padding(.bottom, 4)
    }
}
