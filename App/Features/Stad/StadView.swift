import SwiftUI

/// The home screen: the city map fills the screen, with a small top bar (KLINKER, streak, menu)
/// and the Vandaag panel over the bottom (today's round, current place, post, house; pull up for more).
/// Day and night follow the clock unless set in the menu.
struct StadView: View {
    /// A round or a place interior is open over the map: parties wait until it closes.
    var covered = false

    @Environment(ProgressStore.self) private var progress
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
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
    @State private var parties: [KaartParty] = []
    @State private var party: KaartParty?
    @State private var previewBuilt = true
    /// Neighbourhoods just finished: Ria brings their postcards after the parties.
    @State private var postcards: [Buurt] = []
    @State private var postcard: Buurt?

    private var mood: KaartMood { KaartMood.at(now, light: light) }
    private var night: Bool { mood.night }

    private var statuses: [SheetStatus] {
        (1...ContentStore.totalSheets).map { progress.status(ofSheet: $0) }
    }

    /// Something sits over the map, so a party would play unseen.
    private var blocked: Bool {
        covered || picked != nil || lettersOpen || houseOpen || postcard != nil
    }

    var body: some View {
        let statuses = statuses
        GeometryReader { geo in
            let top = geo.safeAreaInsets.top
            ZStack(alignment: .top) {
                StadMapView(
                    statuses: statuses,
                    currentPlace: progress.currentSheetNumber,
                    mood: mood,
                    selected: $picked,
                    active: onScreen && !covered && detent != .full,
                    insets: EdgeInsets(top: top + topBarHeight, leading: 0, bottom: peekHeight, trailing: 0),
                    mail: LetterShelf(content: .shared, store: .shared, progress: progress).unreadCount,
                    onMail: { lettersOpen = true },
                    party: party,
                    flyIn: true
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
                    onReset: { confirmReset = true },
                    onParty: previewParty,
                    onPostcard: previewPostcard
                )
                .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { topBarHeight = $0 }

                if let party {
                    KaartPartyBanner(party: party)
                        .padding(.horizontal, 16)
                        .padding(.top, topBarHeight + 6)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .allowsHitTesting(false)
                }

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
        .sheet(item: $postcard) { buurt in
            AnsichtkaartView(buurt: buurt, isNew: true)
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
        .onChange(of: statuses) { old, new in noteChanges(from: old, to: new) }
        .onChange(of: blocked) { playNextParty() }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(60))
                now = .now
            }
        }
    }

    // MARK: Parties

    /// Places that opened, got built or came back from fading since the last look.
    /// Demo, reset and test mode change many places at once: those aren't celebrated.
    private func noteChanges(from old: [SheetStatus], to new: [SheetStatus]) {
        guard old.count == new.count else { return }
        let changed = old.indices.filter { old[$0] != new[$0] }
        guard !changed.isEmpty, changed.count <= 3 else { return }
        for i in changed {
            let kind: KaartParty.Kind? = switch (old[i], new[i]) {
            case (.locked, .current), (.locked, .growing): .opened
            case (.current, .built), (.growing, .built): .built
            case (.fading, .built): .restored
            default: nil
            }
            if let kind { parties.append(KaartParty(n: i + 1, kind: kind, words: words(i + 1))) }
        }
        postcards += Buurt.all.filter { $0.isComplete(new) && !$0.isComplete(old) }
        playNextParty()
    }

    private func words(_ n: Int) -> [Word] {
        progress.content.sheet(n)?.words ?? []
    }

    /// Test mode: build the current place, or open the next one, without earning it.
    private func previewParty() {
        let n = progress.currentSheetNumber
        let next = min(ContentStore.totalSheets, n + 1)
        parties.append(previewBuilt
            ? KaartParty(n: n, kind: .built, words: words(n))
            : KaartParty(n: next, kind: .opened, words: words(next)))
        previewBuilt.toggle()
        playNextParty()
    }

    /// Test mode: Ria brings the postcard of the neighbourhood you're in.
    private func previewPostcard() {
        postcards.append(Buurt.of(progress.currentSheetNumber) ?? Buurt.all[0])
        playNextParty()
    }

    private func playNextParty() {
        guard party == nil, !blocked else { return }
        guard !parties.isEmpty else {
            showNextPostcard()
            return
        }
        Task {
            // Let a closing round or sheet finish first.
            try? await Task.sleep(for: .milliseconds(650))
            guard party == nil, !blocked, !parties.isEmpty else { return }
            let next = parties.removeFirst()
            setDetent(.peek)
            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) { party = next }
            if next.kind == .opened { KlinkerAudio.shared.play(.snip) }
            Speech.shared.say(StadPlaces.spoken(next.n), after: next.kind == .opened ? 0.35 : 0)
            AccessibilityNotification.Announcement(announcement(next)).post()
            try? await Task.sleep(for: .seconds(reduceMotion ? 0.3 : next.payoff))
            switch next.kind {
            case .built: KlinkerAudio.shared.play(.built)
            case .opened: KlinkerAudio.shared.play(.applause)
            case .restored: KlinkerAudio.shared.play(.roundDone)
            }
            KlinkerAudio.shared.play(.pops, volume: 0.8)
            Haptics.success()
            try? await Task.sleep(for: .seconds(max(1.6, next.duration - next.payoff) + 0.6))
            withAnimation(.easeOut(duration: 0.3)) { party = nil }
            try? await Task.sleep(for: .milliseconds(350))
            playNextParty()
        }
    }

    /// After the parties: the next postcard, if a neighbourhood was finished.
    private func showNextPostcard() {
        guard postcard == nil, !postcards.isEmpty else { return }
        Task {
            try? await Task.sleep(for: .milliseconds(500))
            guard party == nil, !blocked, parties.isEmpty, !postcards.isEmpty else { return }
            postcard = postcards.removeFirst()
        }
    }

    private func announcement(_ party: KaartParty) -> String {
        let place = StadPlaces.spoken(party.n)
        return switch party.kind {
        case .opened: "Nieuwe plek: \(place) is open."
        case .built: "Gebouwd: \(place) staat."
        case .restored: "\(place) staat er weer fris bij."
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
    let onParty: () -> Void
    let onPostcard: () -> Void

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
                SettingsMenu(onDemo: onDemo, onReset: onReset, onParty: onParty, onPostcard: onPostcard)
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
