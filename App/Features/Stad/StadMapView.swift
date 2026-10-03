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
/// pannable in both directions, two zoom levels (buttons or pinch), day/night, and Ria on her round.
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

    private static let near: CGFloat = 1
    private static let far: CGFloat = 0.62
    private static let anchorID = "kaart-anchor"

    private func placeID(_ n: Int) -> String { "kaart-\(n)" }

    private var night: Bool { mood.night }

    private func status(_ n: Int) -> SheetStatus {
        n >= 1 && n <= statuses.count ? statuses[n - 1] : .locked
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
                .onChange(of: currentPlace) { _, place in
                    // A new place just opened: walk the map over to it.
                    scroll(to: place, anchor: UnitPoint(x: 0.5, y: 0.5), proxy)
                }
                .onAppear {
                    appeared = true
                    guard !centered else { return }
                    centered = true
                    Task { scroll(to: currentPlace, anchor: UnitPoint(x: 0.5, y: 0.5), animated: false, proxy) }
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
                KaartMapCanvas(night: night, season: mood.season, zoom: k)
                    .equatable()
                KaartBelowMotion(
                    zoom: k, current: currentKaart, night: night, frozen: mood.season == .winter,
                    active: running, reduceMotion: reduceMotion
                )
                ForEach(KaartData.places) { place in
                    placeButton(place)
                }
                mailbox(k)
                // One-point targets for scrolling: anchors are exact on a 1 × 1 view.
                ForEach(KaartData.places) { place in
                    Color.clear
                        .frame(width: 1, height: 1)
                        .id(placeID(place.n))
                        .position(kaartPoint(place.point.x, place.point.y - 30, k))
                        .accessibilityHidden(true)
                }
                KaartAboveMotion(
                    zoom: k, bangs: bangs, mill: millSails, night: night, active: running,
                    reduceMotion: reduceMotion, riaFrozen: riaFrozen, riaShift: riaShift,
                    riaMessage: riaMessage, onRia: riaTapped
                )
                KaartLifeMotion(zoom: k, mood: mood, active: running, reduceMotion: reduceMotion)
                Color.clear
                    .frame(width: 1, height: 1)
                    .id(Self.anchorID)
                    .position(kaartPoint(zoomAnchor.x, zoomAnchor.y, k))
                    .accessibilityHidden(true)
            }
            .frame(width: KaartData.worldWidth * k, height: KaartData.contentHeight * k, alignment: .topLeading)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.25), value: selected)
            .onGeometryChange(for: CGRect.self) { $0.frame(in: .named("kaart")) } action: { tracker.contentFrame = $0 }
            // Room above and below the world so its edges can scroll clear of the top bar and the panel.
            // (Padding, not content margins: `scrollTo` anchors ignore those.)
            .padding(.top, insets.top)
            .padding(.bottom, insets.bottom)
        }
        .modifier(KaartScrollDriver(request: scrollRequest))
        .coordinateSpace(.named("kaart"))
        .onGeometryChange(for: CGSize.self) { $0.size } action: { tracker.viewport = $0 }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(KaartColors(night: night, season: mood.season).ground)
        .overlay {
            KaartWeatherOverlay(mood: mood, active: running, reduceMotion: reduceMotion)
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
                if value.magnification > 1.12 { setZoom(Self.near) }
                if value.magnification < 0.9 { setZoom(Self.far) }
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

    /// The red brievenbus on the quay left of the station, with a count when post is waiting.
    private func mailbox(_ k: CGFloat) -> some View {
        Button {
            Haptics.tap()
            onMail()
        } label: {
            LetterMailbox(hasMail: mail > 0)
                .frame(width: 30 * k, height: 41 * k)
                .overlay(alignment: .topTrailing) {
                    if mail > 0 {
                        Text("\(min(mail, 99))")
                            .font(.system(size: 12, weight: .heavy))
                            .foregroundStyle(Theme.ink)
                            .padding(.horizontal, 5)
                            .frame(minWidth: 20, minHeight: 20)
                            .background(Theme.orange, in: Capsule())
                            .overlay(Capsule().stroke(Color.white, lineWidth: 1.5))
                            .offset(x: 12, y: -8)
                    }
                }
                .frame(width: max(44, 30 * k), height: max(48, 41 * k))
                .contentShape(Rectangle())
        }
        .buttonStyle(KaartPlaceButtonStyle())
        .position(kaartPoint(Self.mailboxPoint.x, Self.mailboxPoint.y, k))
        .accessibilityLabel(mail > 0
            ? "Brievenbus: \(mail) \(mail == 1 ? "nieuwe brief" : "nieuwe brieven")"
            : "Brievenbus: geen nieuwe post")
        .accessibilityHint("Open de anonieme brieven.")
    }

    private static let mailboxPoint = CGPoint(x: 392, y: 74)

    private func controls(_ proxy: ScrollViewProxy) -> some View {
        VStack(spacing: 8) {
            StadRoundButton(systemName: "plus", label: "Inzoomen", dimmed: zoom == Self.near) {
                setZoom(Self.near)
            }
            StadRoundButton(systemName: "minus", label: "Uitzoomen", dimmed: zoom == Self.far) {
                setZoom(Self.far)
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

    /// The empty mill plot (place 44) turns its dashed sails.
    private var millSails: CGPoint? {
        guard status(44) == .locked, let mill = KaartData.byNumber[44] else { return nil }
        return CGPoint(x: mill.point.x - 22, y: mill.point.y - 48)
    }

    // MARK: Actions

    private func pick(_ n: Int) {
        selected = StadPlacePick(n: n)
        Speech.shared.say(StadPlaces.spoken(n))
        Haptics.tap()
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
