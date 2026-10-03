import SwiftUI

/// A place the learner tapped on the map (drives the bottom sheet).
struct StadPlacePick: Identifiable, Hashable {
    let n: Int
    var id: Int { n }
}

/// Names and words for places.
enum StadPlaces {
    /// "het gemeentehuis", "de bakker", "jouw huis".
    static func spoken(_ n: Int) -> String {
        n == 3 ? "jouw huis" : "\(KaartData.article(n)) \(PlaceCatalog.name(n).lowercased())"
    }

    static func statusWord(_ status: SheetStatus) -> String {
        switch status {
        case .built: "gebouwd"
        case .growing: "in aanbouw"
        case .current: "nu bezig"
        case .fading: "verbleekt"
        case .locked: "op slot"
        }
    }
}

/// Remembers the map's scroll geometry without causing redraws.
final class KaartScrollTracker {
    var contentFrame: CGRect = .zero
    var viewport: CGSize = .zero
}

/// The home screen's city: the illustrated canal ring with the 62 places, full screen and
/// pannable in both directions, three zoom levels (buttons or pinch), day/night, Ria on her
/// round, and little Amsterdam details to find when you zoom in close.
/// `insets` keeps the top bar and the Vandaag panel from covering places.
struct StadMapView: View {
    let statuses: [SheetStatus]
    let currentPlace: Int
    let mood: KaartMood
    @Binding var selected: StadPlacePick?
    var active = true
    var insets = EdgeInsets()
    /// Unread letters: the brievenbus by the station shows them and opens the post.
    var mail = 0
    var onMail: () -> Void = {}
    /// A place opening or being built: the map goes there and celebrates.
    var party: KaartParty?
    /// Swoop in from far above on the first appearance.
    var flyIn = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var zoom: CGFloat = Self.near
    @State private var zoomAnchor = CGPoint(x: 500, y: 400)
    @State private var tracker = KaartScrollTracker()
    @State private var riaFrozen: Double?
    @State private var riaShift: Double = 0
    @State private var riaToken = 0
    @State private var appeared = false
    @State private var centered = false
    @State private var scrollRequest: KaartScrollRequest?
    /// Scale of the whole map around the current place: below 1 while flying in.
    @State private var camera: CGFloat = 1
    @State private var revealed = true
    /// Map tiles near the screen (indexes into `tiles`), and the world on screen for details.
    @State private var shownTiles: Set<Int> = []
    @State private var visibleWorld = CGRect(x: 0, y: 0, width: 1000, height: 1200)
    @State private var bubble: KaartBubble?

    private static let near: CGFloat = 1
    private static let far: CGFloat = 0.62
    private static let close: CGFloat = 1.8
    private static let levels: [CGFloat] = [far, near, close]
    /// Map tiles, in content units (world x, world y + north).
    private static let tileSize: CGFloat = 200
    private static let tiles: [CGRect] = {
        var rects: [CGRect] = []
        var y: CGFloat = 0
        while y < KaartData.contentHeight {
            var x: CGFloat = 0
            while x < KaartData.worldWidth {
                rects.append(CGRect(x: x, y: y, width: min(tileSize, KaartData.worldWidth - x), height: min(tileSize, KaartData.contentHeight - y)))
                x += tileSize
            }
            y += tileSize
        }
        return rects
    }()
    private static let anchorID = "kaart-anchor"

    private func placeID(_ n: Int) -> String { "kaart-\(n)" }

    private var night: Bool { mood.night }

    private func status(_ n: Int) -> SheetStatus {
        // During a party the place already looks the way it ends up (also for the test-mode preview).
        if let party, party.n == n {
            return party.kind == .opened ? .current : .built
        }
        return n >= 1 && n <= statuses.count ? statuses[n - 1] : .locked
    }

    private var riaMessage: String {
        "Er is post voor je! Vel \(currentPlace) ligt klaar."
    }

    var body: some View {
        ScrollViewReader { proxy in
            viewport(proxy)
                .onChange(of: zoom) {
                    request(world: zoomAnchor, anchor: UnitPoint(x: 0.5, y: 0.5), animated: false) {
                        proxy.scrollTo(Self.anchorID, anchor: .center)
                    }
                }
                .onChange(of: selected) { _, pick in
                    // A picked place moves up into the part its sheet leaves free.
                    guard let pick else { return }
                    scroll(to: pick.n, anchor: UnitPoint(x: 0.5, y: 0.27), proxy)
                }
                .onChange(of: party?.id) {
                    guard let party else { return }
                    // Parties are close-ups: zoom in first, then go to the place.
                    zoom = Self.near
                    Task {
                        try? await Task.sleep(for: .milliseconds(80))
                        scroll(to: party.n, anchor: UnitPoint(x: 0.5, y: 0.55), proxy)
                    }
                }
                .onChange(of: currentPlace) { _, place in
                    // A new place just opened: walk the map over to it.
                    scroll(to: place, anchor: UnitPoint(x: 0.5, y: 0.5), proxy)
                }
                .onAppear {
                    appeared = true
                    guard !centered else { return }
                    centered = true
                    let swoop = flyIn && !reduceMotion
                    if swoop {
                        camera = 0.42
                        revealed = false
                    }
                    Task {
                        scroll(to: currentPlace, anchor: UnitPoint(x: 0.5, y: 0.5), animated: false, proxy)
                        guard swoop else { return }
                        try? await Task.sleep(for: .milliseconds(150))
                        withAnimation(.easeOut(duration: 0.35)) { revealed = true }
                        withAnimation(.easeInOut(duration: 1.8).delay(0.3)) { camera = 1 }
                    }
                }
                .onDisappear { appeared = false }
        }
    }

    // MARK: Map viewport

    private func viewport(_ proxy: ScrollViewProxy) -> some View {
        let k = zoom
        let running = active && appeared
        let currentKaart = status(currentPlace) == .current ? KaartData.byNumber[currentPlace] : nil
        return ScrollView([.horizontal, .vertical], showsIndicators: false) {
            ZStack(alignment: .topLeading) {
                mapTiles(k)
                KaartBelowMotion(
                    zoom: k, current: currentKaart, night: night, frozen: mood.season == .winter,
                    active: running, reduceMotion: reduceMotion
                )
                ForEach(KaartData.places) { place in
                    placeButton(place)
                }
                KaartMailboxButton(mail: mail, zoom: k, onMail: onMail)
                // One-point targets for scrolling: anchors are exact on a 1 × 1 view.
                ForEach(KaartData.places) { place in
                    Color.clear
                        .frame(width: 1, height: 1)
                        .id(placeID(place.n))
                        .position(kaartPoint(place.point.x, place.point.y - 30, k))
                        .accessibilityHidden(true)
                }
                KaartAboveMotion(
                    zoom: k, bangs: bangs, night: night, active: running,
                    reduceMotion: reduceMotion, riaFrozen: riaFrozen, riaShift: riaShift,
                    riaMessage: riaMessage, onRia: riaTapped
                )
                KaartLifeMotion(zoom: k, mood: mood, active: running, reduceMotion: reduceMotion)
                KaartDetailsLayer(zoom: k, mood: mood, visible: visibleWorld, active: running, reduceMotion: reduceMotion, onTap: found)
                if let bubble {
                    KaartWordBubble(detail: bubble.detail, isNew: bubble.isNew, found: KaartDiscoveries.shared.count, total: KaartDiscoveries.shared.total)
                        .position(kaartPoint(min(910, max(90, bubble.point.x)), bubble.point.y - 52 / k, k))
                        .transition(.scale(scale: 0.6, anchor: .bottom).combined(with: .opacity))
                        .onTapGesture { withAnimation(.easeOut(duration: 0.2)) { self.bubble = nil } }
                        .id(bubble.id)
                }
                if let party, !reduceMotion {
                    KaartPartyLayer(party: party, night: night, season: mood.season, zoom: k)
                        .id(party.id)
                }
                Color.clear
                    .frame(width: 1, height: 1)
                    .id(Self.anchorID)
                    .position(kaartPoint(zoomAnchor.x, zoomAnchor.y, k))
                    .accessibilityHidden(true)
            }
            .frame(width: KaartData.worldWidth * k, height: KaartData.contentHeight * k, alignment: .topLeading)
            .scaleEffect(camera, anchor: cameraAnchor)
            .opacity(revealed ? 1 : 0)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.25), value: selected)
            .onGeometryChange(for: CGRect.self) { $0.frame(in: .named("kaart")) } action: {
                tracker.contentFrame = $0
                updateVisible()
            }
            // Room above and below the world so its edges can scroll clear of the top bar and the panel.
            // (Padding, not content margins: `scrollTo` anchors ignore those.)
            .padding(.top, insets.top)
            .padding(.bottom, insets.bottom)
        }
        .modifier(KaartScrollDriver(request: scrollRequest))
        .coordinateSpace(.named("kaart"))
        .onGeometryChange(for: CGSize.self) { $0.size } action: {
            tracker.viewport = $0
            updateVisible()
        }
        .onChange(of: camera) { updateVisible() }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(KaartColors(night: night, season: mood.season).ground)
        .overlay {
            KaartWeatherOverlay(mood: mood, active: running, reduceMotion: reduceMotion)
        }
        .overlay {
            if !night {
                // Aged-paper edges, like a printed map in a frame.
                RadialGradient(
                    colors: [StadInk.hex(0x6B4A2E, 0), StadInk.hex(0x6B4A2E, 0.13)],
                    center: .center, startRadius: 220, endRadius: 520
                )
                .blendMode(.multiply)
                .allowsHitTesting(false)
                .accessibilityHidden(true)
            }
        }
        .overlay {
            if night {
                RadialGradient(
                    colors: [StadInk.hex(0x0A0E1E, 0), StadInk.hex(0x0A0E1E, 0.42)],
                    center: .center, startRadius: 120, endRadius: 360
                )
                .allowsHitTesting(false)
                .accessibilityHidden(true)
            }
        }
        .overlay(alignment: .topTrailing) {
            controls(proxy)
                .padding(.trailing, 16)
                .padding(.top, insets.top + 8)
        }
        .simultaneousGesture(
            MagnifyGesture().onEnded { value in
                if value.magnification > 1.12 { stepZoom(1) }
                if value.magnification < 0.9 { stepZoom(-1) }
            }
        )
        .clipped()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Jouw kaart van de stad")
    }

    private func placeButton(_ place: KaartPlace) -> some View {
        let n = place.n
        let st = status(n)
        let k = zoom
        let isSelected = selected?.n == n
        let name = PlaceCatalog.name(n)
        return Button {
            pick(n)
        } label: {
            KaartPlaceView(
                place: place, status: st, night: night, season: mood.season, zoom: k, selected: isSelected,
                next: st == .locked && n == currentPlace + 1, name: name
            )
                .equatable()
        }
        .buttonStyle(KaartPlaceButtonStyle())
        .offset(y: isSelected ? -4 * k : 0)
        .position(kaartPoint(place.point.x, place.point.y - 23, k))
        .zIndex(isSelected ? 1 : 0)
        .accessibilityLabel("\(name), vel \(n), \(StadPlaces.statusWord(st))")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }


    private func controls(_ proxy: ScrollViewProxy) -> some View {
        VStack(spacing: 8) {
            StadRoundButton(systemName: "plus", label: "Inzoomen", dimmed: zoom == Self.close) {
                stepZoom(1)
            }
            StadRoundButton(systemName: "minus", label: "Uitzoomen", dimmed: zoom == Self.far) {
                stepZoom(-1)
            }
            StadRoundButton(systemName: "scope", label: "Naar \(PlaceCatalog.name(currentPlace)), vel \(currentPlace)", fill: Theme.orange) {
                focus(currentPlace, proxy)
            }
            KaartCompass()
        }
    }

    /// World top-left of the "!" on each fading place.
    private var bangs: [CGPoint] {
        KaartData.places.compactMap { place in
            guard status(place.n) == .fading else { return nil }
            let geo = KaartData.house(place.n)
            return CGPoint(
                x: place.point.x - geo.buttonWidth / 2 + geo.bang.x,
                y: place.point.y - 58 + geo.bang.y
            )
        }
    }

    // MARK: Actions

    private func pick(_ n: Int) {
        selected = StadPlacePick(n: n)
        Speech.shared.say(StadPlaces.spoken(n))
        Haptics.tap()
    }

    /// The current place as a point of the world, for the fly-in.
    private var cameraAnchor: UnitPoint {
        guard let place = KaartData.byNumber[currentPlace] else { return .center }
        let p = kaartPoint(place.point.x, place.point.y - 30, zoom)
        return UnitPoint(x: p.x / (KaartData.worldWidth * zoom), y: p.y / (KaartData.contentHeight * zoom))
    }

    /// Picking scrolls the place into view (see `onChange(of: selected)`).
    private func focus(_ n: Int, _ proxy: ScrollViewProxy) {
        pick(n)
    }

    /// Scrolls so a place sits at `anchor` of the part of the map that isn't covered.
    private func scroll(to n: Int, anchor: UnitPoint, animated: Bool = true, _ proxy: ScrollViewProxy) {
        guard let place = KaartData.byNumber[n] else { return }
        request(world: CGPoint(x: place.point.x, y: place.point.y - 30), anchor: anchor, animated: animated) {
            proxy.scrollTo(placeID(n), anchor: anchor)
        }
    }

    /// iOS 18+ scrolls to an exact offset. iOS 17 falls back to `ScrollViewReader`, which
    /// lines up the whole map rather than the target (the targets sit inside `.position`).
    private func request(world p: CGPoint, anchor: UnitPoint, animated: Bool, fallback: () -> Void) {
        let animated = animated && !reduceMotion
        if #available(iOS 18, *) {
            guard let offset = offset(world: p, anchor: anchor) else { return }
            scrollRequest = KaartScrollRequest(offset: offset, animated: animated, token: (scrollRequest?.token ?? 0) + 1)
        } else if animated {
            withAnimation(.easeInOut(duration: 0.45)) { fallback() }
        } else {
            fallback()
        }
    }

    /// The content offset that puts world point `p` at `anchor` of the uncovered area.
    private func offset(world p: CGPoint, anchor: UnitPoint) -> CGPoint? {
        let size = tracker.viewport
        guard size.width > 0, size.height > 0 else { return nil }
        let k = zoom
        let c = kaartPoint(p.x, p.y, k)
        let free = max(1, size.height - insets.top - insets.bottom)
        let maxX = max(0, KaartData.worldWidth * k - size.width)
        let maxY = max(0, KaartData.contentHeight * k + insets.top + insets.bottom - size.height)
        return CGPoint(
            x: min(maxX, max(0, c.x - anchor.x * size.width)),
            y: min(maxY, max(0, c.y - anchor.y * free))
        )
    }

    private func stepZoom(_ step: Int) {
        let i = Self.levels.firstIndex(of: zoom) ?? 1
        setZoom(Self.levels[min(Self.levels.count - 1, max(0, i + step))])
    }

    // MARK: Tiles and details

    /// Only the map tiles near the screen are drawn; while flying in, all of them.
    private func mapTiles(_ k: CGFloat) -> some View {
        let standing = statuses.indices.filter { statuses[$0] != .locked }.map { $0 + 1 }
        let built = statuses.indices.filter { statuses[$0] == .built }.map { $0 + 1 }
        let show = camera < 1 || shownTiles.isEmpty ? Set(Self.tiles.indices) : shownTiles
        return ZStack(alignment: .topLeading) {
            ForEach(Self.tiles.indices.filter { show.contains($0) }, id: \.self) { i in
                let tile = Self.tiles[i]
                KaartMapCanvas(
                    night: night, season: mood.season, zoom: k, lean: mood.lean,
                    standing: standing, built: built, tile: tile
                )
                .equatable()
                .offset(x: tile.minX * k, y: tile.minY * k)
            }
        }
        .frame(width: KaartData.worldWidth * k, height: KaartData.contentHeight * k, alignment: .topLeading)
    }

    /// Recomputes which tiles and details are near the screen; state changes only when they do.
    private func updateVisible() {
        let frame = tracker.contentFrame, size = tracker.viewport
        guard size.width > 0, frame.width > 0 else { return }
        let k = zoom
        let content = CGRect(x: -frame.minX / k, y: -frame.minY / k, width: size.width / k, height: size.height / k)
        let margin = Self.tileSize * 0.4
        let tiles = Set(Self.tiles.indices.filter { Self.tiles[$0].intersects(content.insetBy(dx: -margin, dy: -margin)) })
        if tiles != shownTiles { shownTiles = tiles }
        // Details: world units, rounded to 40 so small scrolls don't redraw anything.
        let q: CGFloat = 40
        let world = CGRect(
            x: (content.minX / q).rounded(.down) * q, y: ((content.minY - KaartData.north) / q).rounded(.down) * q,
            width: (content.width / q).rounded(.up) * q + q, height: (content.height / q).rounded(.up) * q + q
        )
        if world != visibleWorld { visibleWorld = world }
    }

    private func found(_ detail: KaartDetail, at point: CGPoint) {
        let isNew = KaartDiscoveries.shared.mark(detail.id)
        Speech.shared.say(detail.spoken)
        if isNew { Haptics.success() } else { Haptics.tap() }
        let next = KaartBubble(detail: detail, point: point, isNew: isNew)
        withAnimation(reduceMotion ? nil : .spring(response: 0.3, dampingFraction: 0.7)) { bubble = next }
        Task {
            try? await Task.sleep(for: .seconds(4))
            if bubble?.id == next.id { withAnimation(.easeOut(duration: 0.25)) { bubble = nil } }
        }
    }

    private func setZoom(_ newZoom: CGFloat) {
        guard newZoom != zoom else { return }
        let frame = tracker.contentFrame
        let size = tracker.viewport
        // The world point in the middle of the uncovered area stays put.
        let free = max(1, size.height - insets.top - insets.bottom)
        zoomAnchor = CGPoint(
            x: (-frame.minX + size.width / 2) / zoom,
            y: (-frame.minY + insets.top + free / 2) / zoom - KaartData.north
        )
        zoom = newZoom
        Haptics.tap()
    }

    private func riaTapped(_ phase: Double) {
        if riaFrozen != nil {
            resumeRia()
            return
        }
        withAnimation(.easeOut(duration: 0.2)) { riaFrozen = phase }
        riaToken += 1
        let token = riaToken
        Speech.shared.say(riaMessage)
        Haptics.tap()
        Task {
            try? await Task.sleep(for: .seconds(5.2))
            if riaToken == token { resumeRia() }
        }
    }

    private func resumeRia() {
        guard let frozen = riaFrozen else { return }
        riaShift = Date.now.timeIntervalSinceReferenceDate - frozen * KaartRia.period
        withAnimation(.easeOut(duration: 0.2)) { riaFrozen = nil }
    }
}
