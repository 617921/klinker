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
        case .current: "in aanbouw"
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

/// "Jouw kaart": the illustrated canal-ring city with the 62 places, pannable in both
/// directions, two zoom levels (buttons or pinch), day/night, and Ria on her round.
struct StadMapView: View {
    let statuses: [SheetStatus]
    let currentPlace: Int
    @Binding var night: Bool
    @Binding var selected: StadPlacePick?
    var active = true

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var zoom: CGFloat = Self.near
    @State private var zoomAnchor = CGPoint(x: 500, y: 400)
    @State private var tracker = KaartScrollTracker()
    @State private var riaFrozen: Double?
    @State private var riaShift: Double = 0
    @State private var riaToken = 0
    @State private var appeared = false
    @State private var centered = false

    static let viewportHeight: CGFloat = 480
    private static let near: CGFloat = 1
    private static let far: CGFloat = 0.62
    private static let anchorID = "kaart-anchor"

    private func placeID(_ n: Int) -> String { "kaart-\(n)" }

    private func status(_ n: Int) -> SheetStatus {
        n >= 1 && n <= statuses.count ? statuses[n - 1] : .locked
    }

    private var riaMessage: String {
        "Er is post voor je! Vel \(currentPlace) ligt klaar."
    }

    var body: some View {
        ScrollViewReader { proxy in
            VStack(alignment: .leading, spacing: 10) {
                header(proxy)
                    .padding(.horizontal, 16)
                viewport(proxy)
            }
            .onChange(of: zoom) {
                proxy.scrollTo(Self.anchorID, anchor: .center)
            }
            .onAppear {
                appeared = true
                guard !centered else { return }
                centered = true
                Task { proxy.scrollTo(placeID(currentPlace), anchor: .center) }
            }
            .onDisappear { appeared = false }
        }
    }

    // MARK: Header

    private func header(_ proxy: ScrollViewProxy) -> some View {
        let fading = (1...ContentStore.totalSheets).filter { status($0) == .fading }
        let fresh = fading.isEmpty
        let label = fresh ? "Alles fris" : fading.count == 1 ? "1 verbleekt" : "\(fading.count) verbleken"
        return HStack(spacing: 10) {
            Text("Jouw kaart")
                .font(.system(size: 26, weight: .heavy))
                .tracking(-0.6)
                .accessibilityAddTraits(.isHeader)
            Spacer(minLength: 8)
            Button {
                goToFading(fading, proxy)
            } label: {
                Label(label, systemImage: fresh ? "checkmark" : "exclamationmark")
                    .font(.system(size: 14, weight: .heavy))
                    .lineLimit(1)
                    .padding(.horizontal, 14)
                    .frame(minHeight: 44)
                    .foregroundStyle(fresh ? Theme.okText : Theme.orangeText)
                    .background(fresh ? Theme.okBg : Ink.hex(0xFCE3CF), in: Capsule())
                    .overlay(Capsule().stroke(fresh ? Theme.okLine : Theme.orange, lineWidth: 2))
                    .contentShape(Capsule())
            }
            .buttonStyle(.plain)
            .rotationEffect(.degrees(1))
            .accessibilityLabel(fresh
                ? "Alles staat er fris bij. Toon je huidige plek."
                : "\(label). Toon ze op de kaart.")
        }
    }

    // MARK: Map viewport

    private func viewport(_ proxy: ScrollViewProxy) -> some View {
        let k = zoom
        let running = active && appeared
        let currentKaart = status(currentPlace) == .current ? KaartData.byNumber[currentPlace] : nil
        return ScrollView([.horizontal, .vertical], showsIndicators: false) {
            ZStack(alignment: .topLeading) {
                KaartMapCanvas(night: night, zoom: k)
                    .equatable()
                KaartBelowMotion(zoom: k, current: currentKaart, night: night, active: running, reduceMotion: reduceMotion)
                ForEach(KaartData.places) { place in
                    placeButton(place)
                }
                KaartAboveMotion(
                    zoom: k, bangs: bangs, mill: millSails, night: night, active: running,
                    reduceMotion: reduceMotion, riaFrozen: riaFrozen, riaShift: riaShift,
                    riaMessage: riaMessage, onRia: riaTapped
                )
                Color.clear
                    .frame(width: 1, height: 1)
                    .id(Self.anchorID)
                    .position(kaartPoint(zoomAnchor.x, zoomAnchor.y, k))
                    .accessibilityHidden(true)
            }
            .frame(width: KaartData.worldWidth * k, height: KaartData.contentHeight * k, alignment: .topLeading)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.25), value: selected)
            .onGeometryChange(for: CGRect.self) { $0.frame(in: .named("kaart")) } action: { tracker.contentFrame = $0 }
        }
        .coordinateSpace(.named("kaart"))
        .onGeometryChange(for: CGSize.self) { $0.size } action: { tracker.viewport = $0 }
        .frame(height: Self.viewportHeight)
        .background(KaartColors(night: night).ground)
        .overlay {
            if night {
                RadialGradient(
                    colors: [Ink.hex(0x0A0E1E, 0), Ink.hex(0x0A0E1E, 0.42)],
                    center: .center, startRadius: 120, endRadius: 360
                )
                .allowsHitTesting(false)
                .accessibilityHidden(true)
            }
        }
        .overlay(alignment: .topLeading) {
            StadDayNightToggle(night: $night, shadow: true)
                .padding(12)
        }
        .overlay(alignment: .bottomLeading) {
            KaartLegend()
                .padding(12)
        }
        .overlay(alignment: .bottomTrailing) {
            controls(proxy)
                .padding(12)
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
            KaartPlaceView(place: place, status: st, night: night, zoom: k, selected: isSelected, name: name)
                .equatable()
        }
        .buttonStyle(KaartPlaceButtonStyle())
        .offset(y: isSelected ? -4 * k : 0)
        .id(placeID(n))
        .position(kaartPoint(place.point.x, place.point.y - 23, k))
        .zIndex(isSelected ? 1 : 0)
        .accessibilityLabel("\(name), vel \(n), \(StadPlaces.statusWord(st))")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

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

    private func focus(_ n: Int, _ proxy: ScrollViewProxy) {
        if reduceMotion {
            proxy.scrollTo(placeID(n), anchor: .center)
        } else {
            withAnimation(.easeInOut(duration: 0.45)) { proxy.scrollTo(placeID(n), anchor: .center) }
        }
        pick(n)
    }

    private func goToFading(_ fading: [Int], _ proxy: ScrollViewProxy) {
        guard let first = fading.first else {
            focus(currentPlace, proxy)
            return
        }
        var next = first
        if let now = selected?.n, let i = fading.firstIndex(of: now) {
            next = fading[(i + 1) % fading.count]
        }
        focus(next, proxy)
    }

    private func setZoom(_ newZoom: CGFloat) {
        guard newZoom != zoom else { return }
        let frame = tracker.contentFrame
        let size = tracker.viewport
        zoomAnchor = CGPoint(
            x: (-frame.minX + size.width / 2) / zoom,
            y: (-frame.minY + size.height / 2) / zoom - KaartData.north
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

private struct KaartPlaceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// The note in the corner: what the four looks mean (shapes, not just colour).
private struct KaartLegend: View {
    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 5) {
            GridRow {
                item(.built, "Gebouwd")
                item(.current, "In aanbouw")
            }
            GridRow {
                item(.fading, "Verbleekt")
                item(.locked, "Op slot")
            }
        }
        .padding(.horizontal, 11)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(Theme.note, in: RoundedRectangle(cornerRadius: 3))
        .overlay(alignment: .topLeading) {
            Rectangle().fill(Theme.tapeDe.opacity(0.9)).frame(width: 36, height: 12).rotationEffect(.degrees(-6)).offset(x: 16, y: -6)
        }
        .rotationEffect(.degrees(-1))
        .shadow(color: Theme.ink.opacity(0.18), radius: 4, y: 2)
        .allowsHitTesting(false)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Legenda: gebouwd, in aanbouw, verbleekt, op slot")
    }

    private func item(_ status: SheetStatus, _ text: String) -> some View {
        HStack(spacing: 6) {
            KaartLegendIcon(status: status)
                .frame(width: 14, height: 14)
            Text(text.uppercased())
                .font(Fonts.label(11))
                .foregroundStyle(Theme.ink)
        }
    }
}

private struct KaartLegendIcon: View {
    let status: SheetStatus

    private static let house = SVGPath.parse("M2 13V6l5-4 5 4v7z")
    private static let window = SVGPath.parse("M5.5 8h3v3h-3z")

    var body: some View {
        switch status {
        case .built:
            ZStack {
                Self.house.fill(Ink.hex(0x9A5238))
                Self.window.fill(Ink.hex(0xF6D27A))
            }
        case .current:
            Ellipse()
                .strokeBorder(Theme.orange, lineWidth: 2.5)
                .frame(width: 14, height: 9)
        case .fading:
            ZStack(alignment: .topTrailing) {
                Self.house.fill(Theme.tapeOther)
                Circle().fill(Theme.orange).frame(width: 6, height: 6).offset(x: 2, y: -2)
            }
        case .locked:
            RoundedRectangle(cornerRadius: 2)
                .strokeBorder(Ink.hex(0x8E8A80), style: StrokeStyle(lineWidth: 1.5, dash: [3, 2]))
                .frame(width: 14, height: 12)
        }
    }
}

private struct KaartCompass: View {
    var body: some View {
        VStack(spacing: 2) {
            Text("N")
                .font(Fonts.label(12))
                .foregroundStyle(Theme.ink)
                .padding(.horizontal, 5)
                .background(Theme.note, in: RoundedRectangle(cornerRadius: 2))
            ZStack {
                Circle().fill(Theme.note)
                Circle().stroke(Theme.ink, lineWidth: 1.5)
                SVGPath.parse("M17 5l4.25 11.9h-8.5z").fill(Theme.ink)
                SVGPath.parse("M17 29l-4.25-11.9h8.5z").fill(Theme.dashed)
            }
            .frame(width: 34, height: 34)
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
