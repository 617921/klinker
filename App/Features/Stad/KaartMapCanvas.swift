import SwiftUI

/// The static map, drawn once per zoom level, day/night, season, sun and progress (not per frame).
struct KaartMapCanvas: View, Equatable {
    let night: Bool
    var season: GevelSeason = .zomer
    let zoom: CGFloat
    /// Sun shadows lean this way (nil: none).
    var lean: Double? = nil
    /// Places with a building (they cast shadows), and those fully built (their windows glow at night).
    var standing: [Int] = []
    var built: [Int] = []
    /// The part of the content to draw (content units: world x, world y + north). The map is
    /// drawn in tiles so close zoom doesn't need one huge bitmap.
    var tile = CGRect(x: 0, y: 0, width: KaartData.worldWidth, height: KaartData.contentHeight)

    var body: some View {
        let colors = KaartColors(night: night, season: season)
        let season = season
        let lean = lean
        let standing = standing
        let built = built
        let tile = tile
        let paper = KaartOldMap.paperTile
        let showLabels = zoom > 0.8
        let waterFont = Fonts.readingItalic(14)
        let canalFont = Fonts.readingItalic(12)
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom, y: zoom)
            ctx.translateBy(x: -tile.minX, y: KaartData.north - tile.minY)
            defer { Self.drawPaper(paper, in: &ctx, tile: tile, zoom: zoom, night: night) }
            Self.drawMap(&ctx, colors: colors, night: night, season: season, lean: lean, standing: standing, built: built)
            KaartOldMap.drawDistricts(&ctx, night: night)
            KaartOldMap.drawCountryNames(&ctx, night: night, paper: colors.ground)
            KaartOldMap.drawCartouche(&ctx, night: night)
            KaartOldMap.drawFrame(&ctx, night: night)
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
        }
        .frame(width: tile.width * zoom, height: tile.height * zoom)
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }

    /// Paper grain over the ground, the same size on screen at every zoom, lined up across tiles.
    private static func drawPaper(_ paper: Image, in ctx: inout GraphicsContext, tile: CGRect, zoom: CGFloat, night: Bool) {
        var grain = ctx
        grain.translateBy(x: 0, y: -KaartData.north)
        grain.blendMode = .multiply
        grain.opacity = night ? 0.5 : 1
        let resolved = grain.resolve(paper)
        let step = 180 / zoom
        var y = (tile.minY / step).rounded(.down) * step
        while y < tile.maxY {
            var x = (tile.minX / step).rounded(.down) * step
            while x < tile.maxX {
                grain.draw(resolved, in: CGRect(x: x, y: y, width: step, height: step))
                x += step
            }
            y += step
        }
    }

    private static func drawMap(
        _ ctx: inout GraphicsContext, colors c: KaartColors, night: Bool, season: GevelSeason,
        lean: Double?, standing: [Int], built: [Int]
    ) {
        let m = KaartMapPaths.shared
        ctx.fill(Path(CGRect(x: 0, y: -KaartData.north, width: 1000, height: KaartData.contentHeight)), with: .color(c.ground))
        ctx.fill(Path(CGRect(x: 0, y: -KaartData.north, width: 1000, height: KaartData.north)), with: .color(c.north))
        ctx.fill(Path(CGRect(x: 0, y: -5, width: 1000, height: 5)), with: .color(c.northEdge))

        let ink = KaartInk.line(night: night)
        let hairline = StrokeStyle(lineWidth: 1.1, lineCap: .round, lineJoin: .round)

        // The countryside: watercolour washes, inked edges.
        KaartInk.wash(m.meadow, c.meadow, rim: 10, in: &ctx, strength: 0.7)
        KaartInk.blooms(m.meadow, c.meadow, spots: KaartInk.bloomSpots, in: &ctx)
        KaartSouth.drawFields(&ctx, rects: m.fieldRects, colors: c)
        ctx.stroke(m.fieldInk, with: .color(ink), style: StrokeStyle(lineWidth: 0.9, lineJoin: .round))
        ctx.stroke(m.meadowEdge, with: .color(ink), style: hairline)
        KaartInk.wash(m.sand, c.sand, rim: 6, in: &ctx)
        ctx.stroke(m.sand, with: .color(ink), style: hairline)
        KaartInk.wash(m.dike, c.dike, rim: 6, in: &ctx)
        ctx.stroke(m.dike, with: .color(ink), style: hairline)
        ctx.fill(m.runway, with: .color(c.runway))
        ctx.stroke(m.runway, with: .color(ink), style: hairline)
        ctx.stroke(m.runwayDash, with: .color(.white), style: StrokeStyle(lineWidth: 2, dash: [10, 8]))
        ctx.stroke(m.ditch, with: .color(ink), lineWidth: 3.6)
        ctx.stroke(m.ditch, with: .color(c.water), lineWidth: 2.2)

        // Streets, then the park and all the water over them, then bridges where streets cross canals.
        KaartCity.drawStreets(m.allStreets, in: &ctx, colors: c, night: night)
        KaartInk.wash(m.park, c.park, rim: 7, in: &ctx)
        ctx.stroke(m.parkPath, with: .color(c.parkPath), lineWidth: 4)
        ctx.stroke(m.park, with: .color(ink), style: hairline)
        KaartInk.wash(m.waterAll, c.water, rim: 5, in: &ctx, strength: c.frozen ? 0.5 : 1.2)
        if !c.frozen { KaartInk.blooms(m.waterAll, c.water, spots: KaartInk.bloomSpots, in: &ctx) }
        ctx.stroke(m.waterAll, with: .color(ink), style: StrokeStyle(lineWidth: 1.2, lineCap: .round, lineJoin: .round))
        KaartCity.drawBridges(m.bridges, in: &ctx, colors: c, night: night)
        ctx.fill(m.jetty, with: .color(c.jetty))
        ctx.fill(m.mooredA, with: .color(c.mooredA))
        ctx.fill(m.mooredB, with: .color(c.mooredB))
        if c.frozen {
            KaartSouth.drawIce(&ctx, night: night)
        } else {
            ctx.stroke(m.shimmer, with: .color(.white.opacity(0.45)), style: StrokeStyle(lineWidth: 2, lineCap: .round))
            ctx.stroke(m.ripples, with: .color(.white.opacity(night ? 0.18 : 0.5)), style: StrokeStyle(lineWidth: 1, lineCap: .round))
            KaartCity.drawHouseboats(m.houseboats, in: &ctx, night: night)
        }
        KaartSouth.drawCountryside(&ctx, night: night, season: season)

        if let lean {
            KaartCity.drawPlaceShadows(standing, lean: lean, in: &ctx)
        }
        if night {
            KaartCity.drawPlaceGlows(built, in: &ctx)
        }
        KaartFiller.shared.draw(&ctx, night: night, season: season, lean: lean)
        if let lean {
            // Tree shadows on the ground, away from the sun.
            var shade = ctx
            shade.translateBy(x: lean * 7, y: 4)
            shade.fill(m.treesDark, with: .color(StadInk.hex(0x1E1E1C, 0.12)))
        }
        ctx.fill(m.treesDark, with: .color(c.treeDark))
        KaartInk.wash(m.trees, c.tree, rim: 2.6, in: &ctx, strength: 1.2)
        KaartInk.wash(m.treesAlt, c.treeAlt, rim: 2.6, in: &ctx, strength: 1.2)
        ctx.stroke(m.trees, with: .color(ink.opacity(0.7)), lineWidth: 0.7)
        ctx.stroke(m.treesAlt, with: .color(ink.opacity(0.7)), lineWidth: 0.7)

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
        // People and bikes at house scale.
        for (q, coat, skin) in m.people {
            var p = ctx
            p.translateBy(x: q.x - 3.6, y: q.y - 12)
            p.scaleBy(x: 0.6, y: 0.6)
            p.fill(Path(ellipseIn: CGRect(x: 2.6, y: 0.6, width: 6.8, height: 6.8)), with: .color(StadInk.hex(skin)))
            p.fill(KaartArt.personBody, with: .color(StadInk.hex(coat)))
        }
        for (q, frame) in m.bikes {
            var b = ctx
            b.translateBy(x: q.x - 7.8, y: q.y - 9)
            b.scaleBy(x: 0.65, y: 0.65)
            b.stroke(KaartArt.bikeWheels, with: .color(StadInk.hex(0x1E1E1C)), lineWidth: 1.4)
            b.stroke(KaartArt.bikeFrame, with: .color(StadInk.hex(frame)), style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round))
        }
    }
}

// MARK: - Places

/// One place on the map: built (colour), fading (grey + scaffolding), under construction
/// (scaffolding), or not reached yet (closed shutters, a ribbon and a padlock on the door).
/// Sized in world units × zoom.
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

    var body: some View {
        let k = zoom
        let locked = status == .locked
        let geo = KaartData.house(place.n)
        let width = geo.buttonWidth
        let tagTop = geo.spriteOrigin.y - 28
        ZStack(alignment: .topLeading) {
            if locked {
                KaartHouseCanvas(n: place.n, status: status, night: night, season: season, zoom: k)
                    .offset(x: (geo.spriteOrigin.x - KaartHouseCanvas.pad) * k, y: (geo.spriteOrigin.y - KaartHouseCanvas.pad) * k)
                KaartRibbon(door: geo.doorFrame, zoom: k)
                if next {
                    KaartSketchLabel(n: place.n, next: true, night: night)
                        .position(x: width * k / 2, y: 66 * k + 9)
                }
            } else {
                KaartHouseCanvas(n: place.n, status: status, night: night, season: season, zoom: k)
                    .offset(x: (geo.spriteOrigin.x - KaartHouseCanvas.pad) * k, y: (geo.spriteOrigin.y - KaartHouseCanvas.pad) * k)
                if status == .current {
                    badge
                        .frame(width: 22 * k, height: 22 * k)
                        .offset(x: geo.badge.x * k, y: geo.badge.y * k)
                } else if geo.landmark?.sign != "" {
                    // A hanging shop sign instead of a round icon: part of the drawing.
                    KaartShopSign(n: place.n, faded: status == .fading, night: night, zoom: k)
                        .offset(x: (geo.badge.x - 6) * k, y: (geo.badge.y + 6) * k)
                }
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
                Image(systemName: Self.symbol(place.n))
                    .font(.system(size: max(7, 11 * zoom), weight: .bold))
                    .foregroundStyle(fg)
            )
    }

    /// The place's own sign symbol, else the catalog's.
    static func symbol(_ n: Int) -> String {
        if let sign = KaartData.house(n).landmark?.sign, !sign.isEmpty { return sign }
        return PlaceCatalog.symbol(n)
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
        let locked = status == .locked
        let scaffold = status == .current ? geo.scaffoldFull : (fading || status == .growing) ? geo.scaffoldPart : nil
        let look = KaartLook(night: night, season: season, locked: locked, lightsOn: status == .built)
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
            if let landmark = geo.landmark {
                KaartLandmarkPainter.draw(landmark, look: look, in: &house)
            } else {
                KaartInk.wash(geo.side, side, rim: 7, in: &house)
                KaartDepth.outline(geo.side, night: night, in: &house)
                KaartInk.wash(geo.roof, roof, rim: 7, in: &house)
                KaartDepth.outline(geo.roof, night: night, in: &house)
                GevelPainter.draw(geo.gevel, palette: palette, in: &house)
                KaartInk.pool(geo.gevel.body, palette.body, rim: 7, in: &house)
                KaartDepth.outline(geo.gevel.body, night: night, in: &house)
                KaartDepth.outline(geo.gevel.door, night: night, in: &house, width: 1.6)
                KaartDepth.outline(geo.gevel.awning, night: night, in: &house, width: 1.6)
                if locked {
                    var windows = geo.gevel.glass
                    windows.addPath(geo.gevel.lit)
                    KaartShutters.draw(windows, night: night, in: &house)
                }
                house.fill(geo.spA, with: .color(extras[0]))
                house.fill(geo.spB, with: .color(extras[1]))
                house.fill(geo.spC, with: .color(extras[2]))
            }
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
