import SwiftUI

/// The static map, drawn once per zoom level, day/night and season (not per frame).
struct KaartMapCanvas: View, Equatable {
    let night: Bool
    var season: GevelSeason = .zomer
    let zoom: CGFloat

    var body: some View {
        let colors = KaartColors(night: night, season: season)
        let season = season
        let showLabels = zoom > 0.8
        let waterFont = Fonts.readingItalic(14)
        let canalFont = Fonts.readingItalic(12)
        let landFont = Fonts.label(12)
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom, y: zoom)
            ctx.translateBy(x: 0, y: KaartData.north)
            Self.drawMap(&ctx, colors: colors, night: night, season: season)
            guard showLabels else { return }
            let water = { (s: String) in Text(s).font(waterFont).foregroundStyle(colors.waterLabel) }
            ctx.draw(water("de rivier"), at: CGPoint(x: 250, y: 33), anchor: .bottomLeading)
            ctx.draw(water("het meer"), at: CGPoint(x: 770, y: 1165), anchor: .bottomLeading)
            for (name, x, y) in [("Singel", 464.0, 242.0), ("Herengracht", 430, 377), ("Keizersgracht", 396, 513), ("Prinsengracht", 362, 649)] {
                var c = ctx
                c.translateBy(x: x, y: y)
                c.rotate(by: .degrees(14))
                c.draw(Text(name).font(canalFont).foregroundStyle(colors.waterLabel), at: CGPoint(x: 0, y: 7), anchor: .bottom)
            }
            let land = { (s: String) in Text(s).font(landFont).tracking(2).foregroundStyle(colors.landLabel) }
            ctx.draw(land("POLDER"), at: CGPoint(x: 800, y: 1014), anchor: .bottomLeading)
            ctx.draw(land("STRAND"), at: CGPoint(x: 150, y: 1088), anchor: .bottomLeading)
        }
        .frame(width: KaartData.worldWidth * zoom, height: KaartData.contentHeight * zoom)
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }

    private static func drawMap(_ ctx: inout GraphicsContext, colors c: KaartColors, night: Bool, season: GevelSeason) {
        let m = KaartMapPaths.shared
        ctx.fill(Path(CGRect(x: 0, y: -KaartData.north, width: 1000, height: KaartData.contentHeight)), with: .color(c.ground))
        ctx.fill(Path(CGRect(x: 0, y: -KaartData.north, width: 1000, height: KaartData.north)), with: .color(c.north))
        ctx.fill(Path(CGRect(x: 0, y: -5, width: 1000, height: 5)), with: .color(c.northEdge))

        ctx.fill(m.meadow, with: .color(c.meadow))
        KaartSouth.drawFields(&ctx, rects: m.fieldRects, colors: c)
        ctx.fill(m.sand, with: .color(c.sand))
        ctx.fill(m.dike, with: .color(c.dike))
        ctx.fill(m.runway, with: .color(c.runway))
        ctx.stroke(m.runwayDash, with: .color(.white), style: StrokeStyle(lineWidth: 2, dash: [10, 8]))
        ctx.stroke(m.ditch, with: .color(c.edge), lineWidth: 3)

        let caseStyle = StrokeStyle(lineWidth: 14, lineCap: .round)
        let streetStyle = StrokeStyle(lineWidth: 10, lineCap: .round)
        ctx.stroke(m.streets, with: .color(c.streetCase), style: caseStyle)
        ctx.stroke(m.streets, with: .color(c.street), style: streetStyle)
        ctx.fill(m.park, with: .color(c.park))
        ctx.stroke(m.parkPath, with: .color(c.parkPath), lineWidth: 4)
        ctx.fill(m.water, with: .color(c.water))
        ctx.stroke(m.water, with: .color(c.edge), lineWidth: 3)
        ctx.stroke(m.canals, with: .color(c.edge), lineWidth: 22)
        ctx.stroke(m.canals, with: .color(c.water), lineWidth: 16)
        ctx.stroke(m.radials, with: .color(c.streetCase), style: caseStyle)
        ctx.stroke(m.radials, with: .color(c.street), style: streetStyle)
        ctx.stroke(m.rails, with: .color(c.rail), style: StrokeStyle(lineWidth: 2, lineCap: .round))
        ctx.fill(m.jetty, with: .color(c.jetty))
        ctx.fill(m.mooredA, with: .color(c.mooredA))
        ctx.fill(m.mooredB, with: .color(c.mooredB))
        if c.frozen {
            KaartSouth.drawIce(&ctx, night: night)
        } else {
            ctx.stroke(m.shimmer, with: .color(.white.opacity(0.45)), style: StrokeStyle(lineWidth: 2, lineCap: .round))
        }
        KaartSouth.drawCountryside(&ctx, night: night, season: season)
        ctx.fill(m.treesDark, with: .color(c.treeDark))
        ctx.fill(m.trees, with: .color(c.tree))
        ctx.fill(m.treesAlt, with: .color(c.treeAlt))

        let lampGreen = StadInk.hex(0x2B3A33)
        for q in m.lamps {
            if night {
                let glow = Gradient(colors: [StadInk.hex(0xF6D27A, 0.6), StadInk.hex(0xF6D27A, 0)])
                ctx.fill(
                    Path(ellipseIn: CGRect(x: q.x - 28, y: q.y - 28, width: 56, height: 56)),
                    with: .radialGradient(glow, center: q, startRadius: 0, endRadius: 27.7)
                )
            }
            let dot = Path(ellipseIn: CGRect(x: q.x - 2.25, y: q.y - 2.25, width: 4.5, height: 4.5))
            ctx.fill(dot, with: .color(StadInk.hex(night ? 0xF6D27A : 0xDDE6E8)))
            ctx.stroke(dot, with: .color(lampGreen), lineWidth: 1.5)
        }
        for (q, coat, skin) in m.people {
            var p = ctx
            p.translateBy(x: q.x - 6, y: q.y - 20)
            p.fill(Path(ellipseIn: CGRect(x: 2.6, y: 0.6, width: 6.8, height: 6.8)), with: .color(StadInk.hex(skin)))
            p.fill(KaartArt.personBody, with: .color(StadInk.hex(coat)))
        }
        for (q, frame) in m.bikes {
            var b = ctx
            b.translateBy(x: q.x - 12, y: q.y - 14)
            b.stroke(KaartArt.bikeWheels, with: .color(StadInk.hex(0x1E1E1C)), lineWidth: 1.4)
            b.stroke(KaartArt.bikeFrame, with: .color(StadInk.hex(frame)), style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round))
        }
    }
}

// MARK: - Places

/// One place on the map: a built house (colour), fading (grey + scaffolding), under construction
/// (scaffolding), or not reached yet (a pencil sketch of what it will be). Sized in world units × zoom.
struct KaartPlaceView: View, Equatable {
    let place: KaartPlace
    let status: SheetStatus
    let night: Bool
    var season: GevelSeason = .zomer
    let zoom: CGFloat
    let selected: Bool
    /// The place that opens after the current one (gets a "volgende" note).
    var next = false
    let name: String

    /// Mill, tower, ring and boat plots keep their own outline instead of a canal house.
    private var outlineOnly: Bool {
        [.mill, .tower, .ring, .boat].contains(place.outline)
    }

    var body: some View {
        let k = zoom
        let locked = status == .locked
        let geo = KaartData.house(place.n)
        let width = locked && outlineOnly ? 72 : geo.buttonWidth
        let tagTop = locked && outlineOnly ? -16 : geo.spriteOrigin.y - 28
        ZStack(alignment: .topLeading) {
            if locked {
                if outlineOnly {
                    KaartPlotSketch(outline: place.outline, night: night, zoom: k)
                        .offset(x: 6 * k, y: 8 * k)
                } else {
                    KaartSketchCanvas(n: place.n, night: night, zoom: k)
                        .offset(x: (geo.spriteOrigin.x - KaartHouseCanvas.pad) * k, y: (geo.spriteOrigin.y - KaartHouseCanvas.pad) * k)
                }
                if next {
                    KaartSketchLabel(n: place.n, next: true, night: night)
                        .position(x: width * k / 2, y: 66 * k + 9)
                } else {
                    // An architect's note at the foot of the drawing, left of the door.
                    KaartSketchLabel(n: place.n, next: false, night: night)
                        .position(x: (outlineOnly ? 8 : geo.spriteOrigin.x - 10) * k, y: 52 * k)
                }
            } else {
                KaartHouseCanvas(n: place.n, status: status, night: night, season: season, zoom: k)
                    .offset(x: (geo.spriteOrigin.x - KaartHouseCanvas.pad) * k, y: (geo.spriteOrigin.y - KaartHouseCanvas.pad) * k)
                badge
                    .frame(width: 22 * k, height: 22 * k)
                    .offset(x: geo.badge.x * k, y: geo.badge.y * k)
                if status == .current {
                    Text("VEL \(place.n) · NU")
                        .font(Fonts.label(11))
                        .foregroundStyle(Theme.ink)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 1)
                        .background(Theme.orange)
                        .fixedSize()
                        .rotationEffect(.degrees(1.5))
                        .position(x: width * k / 2, y: 66 * k + 9)
                }
            }
            if selected {
                nameTag
                    .position(x: width * k / 2, y: tagTop * k + 2)
            }
        }
        .frame(width: width * k, height: 70 * k, alignment: .topLeading)
        .contentShape(Rectangle())
    }

    private var badge: some View {
        let (fill, fg): (Color, Color) = switch status {
        case .current: (Theme.orange, Theme.ink)
        case .fading: (StadInk.hex(0xD9D6CC), Theme.muted)
        default: (Theme.note, Theme.ink)
        }
        return Circle()
            .fill(fill)
            .overlay(Circle().stroke(Theme.ink, lineWidth: 1.5))
            .overlay(
                Image(systemName: PlaceCatalog.symbol(place.n))
                    .font(.system(size: max(7, 11 * zoom), weight: .bold))
                    .foregroundStyle(fg)
            )
    }

    private var nameTag: some View {
        let article = KaartData.article(place.n)
        let tape: Color = article == "de" ? Theme.tapeDe : article == "het" ? Theme.tapeHet : Theme.tapeOther
        return Text(name.uppercased())
            .font(Fonts.cta(13))
            .foregroundStyle(Theme.onInk)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Theme.ink)
            .overlay(alignment: .topLeading) {
                Rectangle().fill(tape.opacity(0.9)).frame(width: 24, height: 10).rotationEffect(.degrees(-9)).offset(x: 6, y: -6)
            }
            .fixedSize()
            .rotationEffect(.degrees(-2))
            .allowsHitTesting(false)
    }
}

/// A place's 3/4 house with side wall, roof, shadow, extras and scaffolding.
struct KaartHouseCanvas: View, Equatable {
    let n: Int
    let status: SheetStatus
    let night: Bool
    var season: GevelSeason = .zomer
    let zoom: CGFloat

    static let pad: CGFloat = 6

    var body: some View {
        let geo = KaartData.house(n)
        let pad = Self.pad
        let fading = status == .fading
        let scaffold = status == .current ? geo.scaffoldFull : (fading || status == .growing) ? geo.scaffoldPart : nil
        let f = night ? 0.62 : 1
        let trim: UInt32 = night ? 0xB9B4A8 : 0xEFEBE2
        let glass: UInt32 = night ? 0x232B3B : 0x3E4C55
        let palette = GevelPalette(
            body: StadInk.hex(Gevelkit.shade(geo.color, f)),
            door: StadInk.hex(Gevelkit.shade(geo.door, f)),
            awning: StadInk.hex(Gevelkit.shade(geo.awning, f)),
            trim: StadInk.hex(trim),
            glass: StadInk.hex(glass),
            litGlass: StadInk.hex(night && status == .built ? 0xF6D27A : glass),
            box: StadInk.hex(0x3F5A4A),
            bloom: StadInk.hex(0xC8261B),
            snow: season == .winter ? StadInk.hex(night ? 0xC9CDD8 : 0xFFFFFF) : nil
        )
        let side = StadInk.hex(Gevelkit.shade(geo.color, night ? 0.42 : 0.74))
        // Winter puts snow on every roof.
        let roof = season == .winter
            ? StadInk.hex(night ? 0x8D93A6 : 0xF4F2EC)
            : StadInk.hex(Gevelkit.shade(geo.roofColor, night ? 0.6 : 1))
        let extras = geo.spFills.map { StadInk.hex(Gevelkit.shade($0, f)) }
        let poleColor = StadInk.hex(night ? 0xA8A69E : 0x5F5E5A)
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom, y: zoom)
            ctx.translateBy(x: pad, y: pad)
            ctx.scaleBy(x: geo.spriteSize.width / geo.viewBox.width, y: geo.spriteSize.height / geo.viewBox.height)
            ctx.translateBy(x: -geo.viewBox.minX, y: -geo.viewBox.minY)
            var house = ctx
            if fading {
                house.addFilter(.grayscale(1))
                house.addFilter(.contrast(0.82))
                house.addFilter(.brightness(0.04))
            }
            house.fill(geo.shadow, with: .color(StadInk.hex(0x1E1E1C, 0.16)))
            house.fill(geo.side, with: .color(side))
            house.fill(geo.roof, with: .color(roof))
            GevelPainter.draw(geo.gevel, palette: palette, in: &house)
            house.fill(geo.spA, with: .color(extras[0]))
            house.fill(geo.spB, with: .color(extras[1]))
            house.fill(geo.spC, with: .color(extras[2]))
            if let scaffold {
                ctx.fill(scaffold.net, with: .color(StadInk.hex(0xF2711C, 0.22)))
                ctx.stroke(scaffold.poles, with: .color(poleColor), style: StrokeStyle(lineWidth: 3.2, lineCap: .round))
                ctx.fill(scaffold.planks, with: .color(StadInk.hex(0xC9A15B)))
            }
        }
        .frame(width: (geo.spriteSize.width + 2 * pad) * zoom, height: (geo.spriteSize.height + 2 * pad) * zoom)
        .allowsHitTesting(false)
    }
}
