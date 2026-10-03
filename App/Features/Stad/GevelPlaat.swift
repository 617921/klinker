import SwiftUI

/// The Gevelplaat: a place's building drawn large on cream paper, like an architectural plate,
/// with a tree and a passer-by for scale and numbered labels for its parts. Tap a label to hear
/// the Dutch word ("de klokgevel", "het uithangbord").
struct GevelPlaat: View {
    let n: Int
    let status: SheetStatus

    @State private var picked: GevelDeel?
    @State private var width: CGFloat = 353

    private static let column: CGFloat = 84

    var body: some View {
        let layout = GevelPlaatLayout(n: n, status: status, width: width, column: Self.column)
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 4)
                .fill(StadInk.hex(0xF4EEE2))
                .overlay(RoundedRectangle(cornerRadius: 4).strokeBorder(StadInk.hex(0x2E2117, 0.18), lineWidth: 1))
            title(width: width)
            GevelPlaatScene(layout: layout, status: status)
            leaders(layout)
            ForEach(layout.spots) { spot in
                label(spot, layout: layout)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: layout.height)
        .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { width = $0 }
    }

    private func title(width: CGFloat) -> some View {
        VStack(spacing: 4) {
            Text(PlaceCatalog.name(n).uppercased())
                .font(.custom("Baskerville-SemiBold", size: 17))
                .tracking(5)
                .foregroundStyle(StadInk.hex(0x2E2117))
            Text("KLINKERSTAD · VEL \(n)")
                .font(Fonts.label(9))
                .tracking(2)
                .foregroundStyle(StadInk.hex(0x2E2117, 0.6))
        }
        .frame(width: width)
        .padding(.top, 14)
        .accessibilityElement(children: .combine)
    }

    /// Dotted lines from each label to its part, with a numbered dot on the part.
    private func leaders(_ layout: GevelPlaatLayout) -> some View {
        Canvas { ctx, _ in
            let ink = StadInk.hex(0x2E2117, 0.55)
            for spot in layout.spots {
                var line = Path()
                line.move(to: CGPoint(x: spot.left ? layout.column - 2 : layout.width - layout.column + 2, y: spot.labelY))
                line.addLine(to: spot.point)
                ctx.stroke(line, with: .color(ink), style: StrokeStyle(lineWidth: 0.8, dash: [1.5, 2.5]))
                let dot = CGRect(x: spot.point.x - 3.5, y: spot.point.y - 3.5, width: 7, height: 7)
                ctx.fill(Path(ellipseIn: dot), with: .color(.white))
                ctx.stroke(Path(ellipseIn: dot), with: .color(spot.part == picked ? Theme.orange : StadInk.hex(0x2E2117)), lineWidth: 1.4)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func label(_ spot: GevelPlaatLayout.Spot, layout: GevelPlaatLayout) -> some View {
        let on = picked == spot.part
        let align: HorizontalAlignment = spot.left ? .trailing : .leading
        return Button {
            picked = spot.part
            KlinkerAudio.shared.play(.tap)
            Speech.shared.say(spot.spoken)
            Haptics.tap()
        } label: {
            VStack(alignment: align, spacing: 1) {
                Text(String(format: "%02d", spot.number))
                    .font(Fonts.label(9))
                    .foregroundStyle(on ? Theme.orangeText : StadInk.hex(0x2E2117, 0.55))
                Text(spot.spoken)
                    .font(.custom("Baskerville-SemiBold", size: 13))
                    .foregroundStyle(on ? Theme.orangeText : StadInk.hex(0x2E2117))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(spot.part == .gevel && spot.spoken != "de gevel" ? "\(spot.english) (facade)" : spot.english)
                    .font(.custom("Baskerville-Italic", size: 10))
                    .foregroundStyle(StadInk.hex(0x2E2117, 0.6))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(width: layout.column - 10, alignment: spot.left ? .trailing : .leading)
            .frame(minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .position(x: spot.left ? layout.column / 2 + 2 : layout.width - layout.column / 2 - 2, y: spot.labelY)
        .accessibilityLabel("\(spot.spoken), \(spot.english)")
        .accessibilityHint("Tik: hoor het woord.")
    }
}

/// Where everything goes on a plate: the building's scale and position, and the labels.
struct GevelPlaatLayout {
    struct Spot: Identifiable {
        let part: GevelDeel
        let number: Int
        let spoken: String
        let english: String
        let point: CGPoint
        let left: Bool
        var labelY: CGFloat
        var id: GevelDeel { part }
    }

    let n: Int
    let width: CGFloat
    let height: CGFloat
    let column: CGFloat
    let groundY: CGFloat
    /// World units → plate points.
    let k: CGFloat
    /// The plate point of the place's frame origin (world 0, 0 of its tap frame).
    let origin: CGPoint
    /// The building's footprint on the plate.
    let building: CGRect
    let spots: [Spot]

    init(n: Int, status: SheetStatus, width: CGFloat, column: CGFloat) {
        self.n = n
        self.width = width
        self.column = column
        let geo = KaartData.house(n)
        let top: CGFloat = 70
        let signShown = geo.landmark?.sign != ""
        let sign = GevelPlaatLayout.sign(geo)
        var bounds = CGRect(origin: geo.spriteOrigin, size: geo.spriteSize)
        if signShown { bounds = bounds.union(sign) }
        bounds = bounds.union(CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: 58 - bounds.minY))
        // As big as the room between the label columns allows, up to 270 points tall
        // (wide low places like the market may grow larger).
        let tall = max(1, 58 - bounds.minY)
        k = min(max(60, width - 2 * column - 12) / bounds.width, 270 / tall, 6.5)
        // Tall enough for the building and for six stacked labels.
        height = max(top + tall * k + 34, 260)
        groundY = height - 30
        let cx = width / 2
        origin = CGPoint(x: cx - bounds.midX * k, y: groundY - 58 * k)
        building = CGRect(x: origin.x + bounds.minX * k, y: origin.y + bounds.minY * k, width: bounds.width * k, height: (58 - bounds.minY) * k)

        // The parts to name, most useful first.
        let marks = geo.marks
        let gableWord = geo.landmark?.gable?.word ?? (geo.landmark == nil && geo.kind == .gevel ? KaartData.building(n).type.word : nil)
        var chosen: [(GevelDeel, CGPoint)] = []
        for part in GevelDeel.priority {
            let local: CGPoint
            if part == .uithangbord {
                guard signShown else { continue }
                local = CGPoint(x: sign.minX + 13.5, y: sign.minY + 12.5)
            } else if part == .wiek, let rect = marks[part] {
                local = geo.framePoint(CGPoint(x: rect.midX, y: rect.midY))
            } else if part == .steiger {
                guard status == .current, let wall = marks[.gevel] else { continue }
                local = geo.framePoint(CGPoint(x: wall.minX - 4, y: wall.midY))
            } else if let rect = marks[part] {
                let p: CGPoint = switch part {
                case .gevel: CGPoint(x: rect.minX + min(5, rect.width * 0.1), y: rect.midY + rect.height * 0.12)
                case .baksteen: CGPoint(x: rect.maxX - min(5, rect.width * 0.08), y: rect.maxY - rect.height * 0.1)
                default: CGPoint(x: rect.midX, y: rect.midY)
                }
                local = geo.framePoint(p)
            } else {
                continue
            }
            let plate = CGPoint(x: origin.x + local.x * k, y: origin.y + local.y * k)
            // Two labels shouldn't point at the same spot.
            if chosen.contains(where: { hypot($0.1.x - plate.x, $0.1.y - plate.y) < 10 }) { continue }
            chosen.append((part, plate))
            if chosen.count == 6 { break }
        }

        // Left or right by where the part is; keep the sides balanced.
        var sides = chosen.map { $0.1.x < cx }
        while sides.filter({ $0 }).count > 4, let i = sides.indices.filter({ sides[$0] }).max(by: { chosen[$0].1.x < chosen[$1].1.x }) { sides[i] = false }
        while sides.filter({ !$0 }).count > 4, let i = sides.indices.filter({ !sides[$0] }).min(by: { chosen[$0].1.x < chosen[$1].1.x }) { sides[i] = true }

        var spots: [Spot] = []
        for (i, (part, point)) in chosen.enumerated() {
            let word = part == .gevel ? (gableWord ?? part.nl) : part.nl
            let english = part == .gevel ? Self.gableEnglish(gableWord) : part.en
            spots.append(Spot(part: part, number: i + 1, spoken: "\(part.article.rawValue) \(word)", english: english, point: point, left: sides[i], labelY: point.y))
        }
        // Stack each side's labels top to bottom, a label's height (44) apart, inside the plate.
        for left in [true, false] {
            let ids = spots.indices.filter { spots[$0].left == left }.sorted { spots[$0].point.y < spots[$1].point.y }
            var y = top
            for i in ids {
                spots[i].labelY = max(spots[i].point.y, y)
                y = spots[i].labelY + 44
            }
            let overflow = (ids.last.map { spots[$0].labelY } ?? 0) - (height - 26)
            if overflow > 0 { for i in ids { spots[i].labelY -= overflow } }
        }
        self.spots = spots.sorted { $0.number < $1.number }
    }

    /// The shop sign's frame in the place's tap frame, kept above the ground line.
    static func sign(_ geo: KaartHouseGeometry) -> CGRect {
        CGRect(x: geo.badge.x - 6, y: min(geo.badge.y + 6, 58 - 30), width: 26, height: 22)
    }

    private static func gableEnglish(_ word: String?) -> String {
        switch word {
        case "trapgevel": "step gable"
        case "halsgevel": "neck gable"
        case "klokgevel": "bell gable"
        case "tuitgevel": "spout gable"
        case "lijstgevel": "cornice gable"
        default: "facade"
        }
    }
}

/// The drawing on a plate: ground, shadow, the building with its sign (and ribbon when locked),
/// a tree in this season's colours and a passer-by.
private struct GevelPlaatScene: View {
    let layout: GevelPlaatLayout
    let status: SheetStatus

    var body: some View {
        let geo = KaartData.house(layout.n)
        let k = layout.k
        let pad = KaartHouseCanvas.pad
        let season = GevelSeason.of(.now)
        let signShown = geo.landmark?.sign != ""
        ZStack(alignment: .topLeading) {
            GevelPlaatGround(layout: layout, season: season)
            KaartHouseCanvas(n: layout.n, status: status, night: false, season: season, zoom: k)
                .offset(x: layout.origin.x + (geo.spriteOrigin.x - pad) * k, y: layout.origin.y + (geo.spriteOrigin.y - pad) * k)
            if signShown {
                let sign = GevelPlaatLayout.sign(geo)
                KaartShopSign(n: layout.n, faded: status == .fading, night: false, zoom: k)
                    .offset(x: layout.origin.x + sign.minX * k, y: layout.origin.y + sign.minY * k)
            }
            if status == .locked {
                KaartRibbon(door: geo.doorFrame, zoom: k)
                    .offset(x: layout.origin.x, y: layout.origin.y)
            }
        }
        .frame(width: layout.width, height: layout.height, alignment: .topLeading)
        .allowsHitTesting(false)
        .accessibilityElement()
        .accessibilityLabel("Tekening van \(StadPlaces.spoken(layout.n))")
    }
}

/// Paving, the shadow under the building, a tree and a passer-by.
private struct GevelPlaatGround: View {
    let layout: GevelPlaatLayout
    let season: GevelSeason

    var body: some View {
        let ink = StadInk.hex(0x2E2117)
        let colors = KaartColors(night: false, season: season)
        let b = layout.building, g = layout.groundY, k = layout.k
        Canvas { ctx, size in
            // Pavement: a band with a fine ink edge.
            let street = CGRect(x: layout.column - 6, y: g, width: size.width - 2 * layout.column + 12, height: 8)
            ctx.fill(Path(street), with: .color(StadInk.hex(0xE6DCCB)))
            var edge = Path()
            edge.move(to: CGPoint(x: street.minX, y: g)); edge.addLine(to: CGPoint(x: street.maxX, y: g))
            ctx.stroke(edge, with: .color(ink.opacity(0.7)), lineWidth: 1)
            ctx.fill(Path(ellipseIn: CGRect(x: b.minX - 6, y: g - 3, width: b.width + 30, height: 7)), with: .color(ink.opacity(0.12)))

            // A tree right of the building, its height a little over two floors, kept out of the labels.
            let treeX = b.maxX + 10
            let treeH = min(g - 90, 44 * k, b.height * 0.8)
            if treeX + treeH * 0.3 <= size.width - layout.column + 4 {
            var trunk = Path()
            trunk.move(to: CGPoint(x: treeX, y: g)); trunk.addLine(to: CGPoint(x: treeX, y: g - treeH * 0.55))
            trunk.move(to: CGPoint(x: treeX, y: g - treeH * 0.35)); trunk.addLine(to: CGPoint(x: treeX - treeH * 0.14, y: g - treeH * 0.62))
            trunk.move(to: CGPoint(x: treeX, y: g - treeH * 0.42)); trunk.addLine(to: CGPoint(x: treeX + treeH * 0.16, y: g - treeH * 0.7))
            ctx.stroke(trunk, with: .color(StadInk.hex(0x4A3524)), style: StrokeStyle(lineWidth: max(1.5, k * 0.9), lineCap: .round))
            if season != .winter {
                let r = treeH * 0.2
                var crown = Path()
                for (dx, dy, f) in [(0.0, -0.78, 1.0), (-0.16, -0.66, 0.8), (0.17, -0.68, 0.85), (0.02, -0.92, 0.75), (-0.1, -0.86, 0.7)] {
                    crown.addEllipse(in: CGRect(x: treeX + dx * treeH - r * f, y: g + dy * treeH - r * f, width: 2 * r * f, height: 2 * r * f))
                }
                KaartInk.wash(crown, colors.tree, rim: 4, in: &ctx, strength: 1.2)
                ctx.stroke(crown, with: .color(ink.opacity(0.55)), lineWidth: 0.8)
            }
            }

            // A passer-by on the left, for scale.
            let px = max(layout.column + 8, b.minX - 14), ph = 17 * 0.39 * k
            ctx.fill(Path(ellipseIn: CGRect(x: px - ph * 0.09, y: g - ph, width: ph * 0.18, height: ph * 0.18)), with: .color(ink))
            ctx.fill(KaartPen.polygon([(px - ph * 0.13, g - ph * 0.8), (px + ph * 0.13, g - ph * 0.8), (px + ph * 0.17, g - ph * 0.32), (px - ph * 0.17, g - ph * 0.32)]), with: .color(StadInk.hex(0x8A6A4A)))
            var legs = Path()
            legs.move(to: CGPoint(x: px - ph * 0.06, y: g - ph * 0.33)); legs.addLine(to: CGPoint(x: px - ph * 0.08, y: g))
            legs.move(to: CGPoint(x: px + ph * 0.06, y: g - ph * 0.33)); legs.addLine(to: CGPoint(x: px + ph * 0.1, y: g))
            ctx.stroke(legs, with: .color(ink), style: StrokeStyle(lineWidth: max(1, ph * 0.07), lineCap: .round))
        }
        .frame(width: layout.width, height: layout.height)
    }
}
