import SwiftUI

/// A moment worth a little party on the map: a place opens, a place is built, or a fading
/// place is fresh again.
struct KaartParty: Equatable, Identifiable {
    enum Kind: Equatable {
        case opened, built, restored
    }

    let n: Int
    let kind: Kind
    let words: [Word]
    let id = UUID()

    /// How long the map animation runs.
    var duration: Double {
        switch kind {
        case .opened: 2.6
        case .built: 3.4
        case .restored: 2.2
        }
    }

    /// When the words have flown in and the confetti goes off.
    var payoff: Double {
        switch kind {
        case .opened: 1.1
        case .built: 2.25
        case .restored: 0.6
        }
    }
}

/// The party itself, in world space over the place:
/// - opened: the shutters open, the ribbon is cut and the padlock drops, then confetti;
/// - built: the scaffolding drops, the place's words fly in as paper strips, then confetti;
/// - restored: a ring and confetti.
struct KaartPartyLayer: View {
    let party: KaartParty
    let night: Bool
    let season: GevelSeason
    let zoom: CGFloat

    @State private var start = Date.now

    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSince(start)
            if t < party.duration, let place = KaartData.byNumber[party.n] {
                frame(place: place, t: t)
            }
        }
        .frame(width: KaartData.worldWidth * zoom, height: KaartData.contentHeight * zoom, alignment: .topLeading)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func frame(place: KaartPlace, t: Double) -> some View {
        let k = zoom
        let geo = KaartData.house(place.n)
        let door = CGPoint(x: place.point.x, y: place.point.y - 8)
        // The place's own frame (as in `StadMapView.placeButton`), so layers line up with the place.
        let origin = kaartPoint(place.point.x - geo.buttonWidth / 2, place.point.y - 58, k)
        let house = CGSize(
            width: (geo.spriteOrigin.x - KaartHouseCanvas.pad) * k,
            height: (geo.spriteOrigin.y - KaartHouseCanvas.pad) * k
        )
        return ZStack(alignment: .topLeading) {
            ZStack(alignment: .topLeading) {
                switch party.kind {
                case .opened:
                    // The shutters open, the ribbon parts and the padlock drops.
                    KaartHouseCanvas(n: place.n, status: .locked, night: night, season: season, zoom: k)
                        .offset(house)
                        .opacity(1 - ease(min(1, max(0, (t - 0.45) / 0.55))))
                    KaartRibbon(door: geo.doorFrame, zoom: k, cut: ease(min(1, t / 0.9)))
                case .built:
                    let fall = ease(min(1, t / 0.9))
                    KaartScaffoldCanvas(n: place.n, night: night, zoom: k)
                        .offset(house)
                        .offset(y: 70 * k * fall * fall)
                        .opacity(1 - fall)
                case .restored:
                    EmptyView()
                }
            }
            .frame(width: geo.buttonWidth * k, height: 70 * k, alignment: .topLeading)
            .offset(x: origin.x, y: origin.y)
            if party.kind == .built {
                ForEach(party.words.indices, id: \.self) { i in
                    strip(i, t: t, door: door)
                }
            }
            ring(at: door, t: t - party.payoff)
            confetti(at: door, t: t - party.payoff)
        }
        .frame(width: KaartData.worldWidth * k, height: KaartData.contentHeight * k, alignment: .topLeading)
    }

    /// Word `i` flies in from a circle above the house to the door, on an arc, getting smaller.
    @ViewBuilder
    private func strip(_ i: Int, t: Double, door: CGPoint) -> some View {
        let count = max(1, party.words.count)
        let begin = 0.45 + Double(i) * 0.09
        let p = (t - begin) / 0.9
        if p > 0 && p < 1 {
            let word = party.words[i]
            let angle = (200 + 140 * Double(i) / Double(max(1, count - 1))) * .pi / 180
            let from = CGPoint(x: door.x + 170 * cos(angle), y: door.y - 40 + 120 * sin(angle))
            let control = CGPoint(x: (from.x + door.x) / 2, y: min(from.y, door.y) - 90)
            let e = ease(p)
            let x = (1 - e) * (1 - e) * from.x + 2 * (1 - e) * e * control.x + e * e * door.x
            let y = (1 - e) * (1 - e) * from.y + 2 * (1 - e) * e * control.y + e * e * door.y
            PaperStrip(text: word.nl, size: 12, tape: word.article == .none ? nil : word.article)
                .fixedSize()
                .rotationEffect(.degrees((1 - e) * (Double(i % 3) - 1) * 12))
                .scaleEffect(1 - 0.75 * e)
                .opacity(min(1, p / 0.15) * min(1, (1 - p) / 0.2))
                .position(kaartPoint(x, y, zoom))
        }
    }

    @ViewBuilder
    private func ring(at p: CGPoint, t: Double) -> some View {
        if t > 0 && t < 1.2 {
            let e = 1 - (1 - t / 1.2) * (1 - t / 1.2)
            Ellipse()
                .strokeBorder(Theme.orange, lineWidth: 3 * zoom)
                .frame(width: 120 * zoom, height: 50 * zoom)
                .scaleEffect(0.5 + 1.2 * e)
                .opacity(1 - e)
                .position(kaartPoint(p.x, p.y, zoom))
        }
    }

    private static let confettiColors: [UInt32] = [0xF2711C, 0x2F5BD3, 0xC8261B, 0xF2C53D, 0xFFFDF6, 0x5DCAA5, 0xE58BB0]

    @ViewBuilder
    private func confetti(at p: CGPoint, t: Double) -> some View {
        if t > 0 && t < 1.3 {
            ForEach(0..<24, id: \.self) { i in
                var rnd = GevelRandom(seed: i * 131 + party.n)
                let angle = (200 + rnd.next() * 140) * .pi / 180
                let speed = 120 + rnd.next() * 110
                let x = p.x + cos(angle) * speed * t
                let y = p.y - 30 + sin(angle) * speed * t + 160 * t * t
                let spin = (rnd.next() - 0.5) * 900 * t
                Rectangle()
                    .fill(StadInk.hex(Self.confettiColors[i % Self.confettiColors.count]))
                    .frame(width: 7, height: 3.5)
                    .rotationEffect(.degrees(spin))
                    .opacity(min(1, (1.3 - t) / 0.4))
                    .position(kaartPoint(x, y, zoom))
            }
        }
    }

    private func ease(_ x: Double) -> Double {
        x < 0.5 ? 2 * x * x : 1 - pow(-2 * x + 2, 2) / 2
    }
}

/// Only the full scaffolding of a place, drawn like `KaartHouseCanvas` draws it.
struct KaartScaffoldCanvas: View, Equatable {
    let n: Int
    let night: Bool
    let zoom: CGFloat

    var body: some View {
        let geo = KaartData.house(n)
        let pad = KaartHouseCanvas.pad
        let poleColor = StadInk.hex(night ? 0xA8A69E : 0x5F5E5A)
        Canvas { ctx, _ in
            guard let scaffold = geo.scaffoldFull else { return }
            ctx.scaleBy(x: zoom, y: zoom)
            ctx.translateBy(x: pad, y: pad)
            ctx.scaleBy(x: geo.spriteSize.width / geo.viewBox.width, y: geo.spriteSize.height / geo.viewBox.height)
            ctx.translateBy(x: -geo.viewBox.minX, y: -geo.viewBox.minY)
            ctx.fill(scaffold.net, with: .color(StadInk.hex(0xF2711C, 0.22)))
            ctx.stroke(scaffold.poles, with: .color(poleColor), style: StrokeStyle(lineWidth: 3.2, lineCap: .round))
            ctx.fill(scaffold.planks, with: .color(StadInk.hex(0xC9A15B)))
        }
        .frame(width: (geo.spriteSize.width + 2 * pad) * zoom, height: (geo.spriteSize.height + 2 * pad) * zoom)
        .allowsHitTesting(false)
    }
}

/// The note that drops in under the top bar during a party.
struct KaartPartyBanner: View {
    let party: KaartParty

    var body: some View {
        let place = StadPlaces.spoken(party.n)
        let title = place.prefix(1).uppercased() + place.dropFirst()
        let count = party.words.count
        let (label, headline, line): (String, String, String) = switch party.kind {
        case .opened: ("Nieuwe plek · vel \(party.n)", "\(title) is open!", "\(count) nieuwe woorden wachten op je.")
        case .built: ("Gebouwd · vel \(party.n)", "\(title) staat!", "Alle \(count) woorden zitten vast.")
        case .restored: ("Weer fris · vel \(party.n)", "\(title) staat er weer fris bij!", "Je woorden zitten weer vast.")
        }
        HStack(spacing: 12) {
            Image(systemName: party.kind == .opened ? "lock.open.fill" : party.kind == .built ? "building.columns.fill" : "sparkles")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Theme.ink)
                .frame(width: 44, height: 44)
                .background(Theme.orange, in: RoundedRectangle(cornerRadius: 3))
                .rotationEffect(.degrees(-3))
            VStack(alignment: .leading, spacing: 2) {
                CourierLabel(text: label, size: 12)
                Text(headline)
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundStyle(Theme.ink)
                Text(line)
                    .font(Fonts.body(13))
                    .foregroundStyle(Theme.muted)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(Theme.note, in: RoundedRectangle(cornerRadius: 3))
        .overlay(alignment: .topLeading) {
            Rectangle().fill(Theme.tapeDe.opacity(0.9)).frame(width: 40, height: 12).rotationEffect(.degrees(-6)).offset(x: 18, y: -6)
        }
        .rotationEffect(.degrees(-0.8))
        .shadow(color: Theme.ink.opacity(0.22), radius: 10, y: 6)
        .accessibilityElement(children: .combine)
    }
}
