import SwiftUI

/// Map colours by day and by night (StadKaart `mapGeo`).
nonisolated struct KaartColors: Sendable {
    let ground, north, northEdge, meadow, fieldA, fieldB, sand, dike, runway: Color
    let streetCase, street, park, parkPath, water, edge, rail, jetty, mooredA, mooredB: Color
    let tree, treeDark, waterLabel, landLabel: Color

    init(night: Bool) {
        let h = { (v: UInt32) in StadInk.hex(v) }
        ground = h(night ? 0x20263A : 0xEDE7D6)
        north = h(night ? 0x262C3F : 0xE3DCC8)
        northEdge = h(night ? 0x3A3F4E : 0x6E6B64)
        meadow = h(night ? 0x263126 : 0xE1E6CF)
        fieldA = h(night ? 0x283528 : 0xDDE7C9)
        fieldB = h(night ? 0x2C3B2D : 0xCFDDB6)
        sand = h(night ? 0x3E3B33 : 0xEADFC2)
        dike = h(night ? 0x2B3B2E : 0xBCD1A3)
        runway = h(night ? 0x3A3E48 : 0x8E8B83)
        streetCase = h(night ? 0x3A3F4E : 0xD6CCB4)
        street = h(night ? 0x4B5163 : 0xFFFFFF)
        park = h(night ? 0x26392F : 0xCFE0C0)
        parkPath = h(night ? 0x3D4A3F : 0xE9DFC6)
        water = h(night ? 0x2B3A58 : 0xA9CBE0)
        edge = h(night ? 0x1D2A44 : 0x8FB6CF)
        rail = h(night ? 0x8A8F9E : 0xEFEBE2)
        jetty = h(night ? 0x2E2117 : 0x4A3524)
        mooredA = h(night ? 0x1F3328 : 0x2F4B3A)
        mooredB = h(night ? 0x4A1A1A : 0x7A1E1E)
        tree = h(night ? 0x2C4A32 : 0x6E9C52)
        treeDark = h(night ? 0x1F3526 : 0x4E7A3A)
        waterLabel = h(night ? 0x9FB4D4 : 0x2C5674)
        landLabel = h(night ? 0x8A9488 : 0x5F5E5A)
    }
}

/// The static map, drawn once per zoom level and day/night (not per frame).
struct KaartMapCanvas: View, Equatable {
    let night: Bool
    let zoom: CGFloat

    var body: some View {
        let colors = KaartColors(night: night)
        let showLabels = zoom > 0.8
        let waterFont = Fonts.readingItalic(14)
        let canalFont = Fonts.readingItalic(12)
        let landFont = Fonts.label(12)
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom, y: zoom)
            ctx.translateBy(x: 0, y: KaartData.north)
            Self.drawMap(&ctx, colors: colors, night: night)
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

    private static func drawMap(_ ctx: inout GraphicsContext, colors c: KaartColors, night: Bool) {
        let m = KaartMapPaths.shared
        ctx.fill(Path(CGRect(x: 0, y: -KaartData.north, width: 1000, height: KaartData.contentHeight)), with: .color(c.ground))
        ctx.fill(Path(CGRect(x: 0, y: -KaartData.north, width: 1000, height: KaartData.north)), with: .color(c.north))
        ctx.fill(Path(CGRect(x: 0, y: -5, width: 1000, height: 5)), with: .color(c.northEdge))

        ctx.fill(m.meadow, with: .color(c.meadow))
        ctx.fill(m.fieldsA, with: .color(c.fieldA))
        ctx.fill(m.fieldsB, with: .color(c.fieldB))
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
        ctx.stroke(m.shimmer, with: .color(.white.opacity(0.45)), style: StrokeStyle(lineWidth: 2, lineCap: .round))
        ctx.fill(m.treesDark, with: .color(c.treeDark))
        ctx.fill(m.trees, with: .color(c.tree))

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
/// (scaffolding), or an empty dashed plot with its number. Sized in world units × zoom.
struct KaartPlaceView: View, Equatable {
    let place: KaartPlace
    let status: SheetStatus
    let night: Bool
    let zoom: CGFloat
    let selected: Bool
    let name: String

    var body: some View {
        let k = zoom
        let locked = status == .locked
        let geo = KaartData.house(place.n)
        let width = locked ? 72 : geo.buttonWidth
        ZStack(alignment: .topLeading) {
            if locked {
                KaartPlotCanvas(outline: place.outline, night: night, zoom: k)
                    .offset(x: 6 * k, y: 8 * k)
                numberTag
                    .position(x: 36 * k, y: 44 * k + 8)
            } else {
                KaartHouseCanvas(n: place.n, status: status, night: night, zoom: k)
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
                    .position(x: width * k / 2, y: (locked ? -16 : geo.spriteOrigin.y - 28) * k + 2)
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

    private var numberTag: some View {
        Text("\(place.n)")
            .font(Fonts.label(11))
            .foregroundStyle(night ? StadInk.hex(0xC9CDD8) : Theme.muted)
            .padding(.horizontal, 4)
            .background(night ? StadInk.hex(0x2E3446) : Theme.note, in: RoundedRectangle(cornerRadius: 2))
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(night ? StadInk.hex(0x5A6175) : Theme.tapeOther, style: StrokeStyle(lineWidth: 1.5, dash: [3, 2]))
            )
            .fixedSize()
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
            snow: nil
        )
        let side = StadInk.hex(Gevelkit.shade(geo.color, night ? 0.42 : 0.74))
        let roof = StadInk.hex(Gevelkit.shade(geo.roofColor, night ? 0.6 : 1))
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

/// A dashed plot outline for a place that is still locked.
struct KaartPlotCanvas: View, Equatable {
    let outline: KaartOutline
    let night: Bool
    let zoom: CGFloat

    var body: some View {
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom, y: zoom)
            let base = KaartArt.base(outline)
            ctx.fill(base, with: .color(night ? StadInk.hex(0xA0AABE, 0.10) : StadInk.hex(0xC9C4B8, 0.28)))
            ctx.stroke(base, with: .color(StadInk.hex(night ? 0x6C7385 : 0xB4B2A9)), style: StrokeStyle(lineWidth: 1.4, dash: [3, 3]))
            let shape = KaartArt.outline(outline)
            ctx.fill(shape, with: .color(night ? Color.white.opacity(0.05) : StadInk.hex(0xFFFDF6, 0.6)))
            ctx.stroke(shape, with: .color(StadInk.hex(night ? 0x8A90A2 : 0x8E8A80)), style: StrokeStyle(lineWidth: 1.6, lineJoin: .round, dash: [4, 3]))
        }
        .frame(width: 60 * zoom, height: 60 * zoom)
        .allowsHitTesting(false)
    }
}
