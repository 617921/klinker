import SwiftUI

/// The four seasons of the street: tree crowns, flower boxes, snow.
nonisolated enum GevelSeason: String, CaseIterable, Identifiable, Hashable, Sendable {
    case lente, zomer, herfst, winter

    var id: String { rawValue }

    var label: String {
        switch self {
        case .lente: "Lente"
        case .zomer: "Zomer"
        case .herfst: "Herfst"
        case .winter: "Winter"
        }
    }

    /// Tree crown colours c1, c2, c3. `nil` in winter: bare branches.
    var crowns: [UInt32]? {
        switch self {
        case .lente: [0x8DBE5A, 0xA7CF6E, 0xF4C0D1]
        case .zomer: [0x4E7A3A, 0x5E8C45, 0x6E9C52]
        case .herfst: [0xC7772E, 0xD9A441, 0xA3410A]
        case .winter: nil
        }
    }

    var bloom: UInt32? {
        switch self {
        case .lente: 0xE24B4A
        case .zomer: 0xC8261B
        case .herfst: 0xD9A441
        case .winter: nil
        }
    }

    var box: UInt32? {
        switch self {
        case .lente: 0x4A3524
        case .zomer: 0x3F5A4A
        case .herfst: 0x4A3524
        case .winter: nil
        }
    }

    /// The season of a date (March–May lente, June–August zomer, ...).
    static func of(_ date: Date) -> GevelSeason {
        switch Calendar.current.component(.month, from: date) {
        case 3...5: .lente
        case 6...8: .zomer
        case 9...11: .herfst
        default: .winter
        }
    }
}

/// Fill colours for one house's path set.
nonisolated struct GevelPalette: Sendable {
    var body: Color
    var door: Color
    var awning: Color
    var trim: Color
    var glass: Color
    var litGlass: Color
    var box: Color?
    var bloom: Color?
    var snow: Color?
    /// Mortar lines (brick fronts only).
    var mortar: Color? = nil
    var curtain: Color = StadInk.hex(0xF4EEDC)
    var iron: Color = StadInk.hex(0x1E1E1C)
    var stone: Color = StadInk.hex(0xCFC8BA)

    static let deco = StadInk.hex(0x2E2117)

    /// Faint light mortar; fainter still on dark tarred brick, so it stays dark.
    static func mortar(_ facade: UInt32, night: Bool) -> Color? {
        guard Gevelkit.isBrick(facade) else { return nil }
        let dark = (facade >> 16 & 0xFF) < 70
        return Color.white.opacity(night ? 0.05 : dark ? 0.08 : 0.15)
    }

    static func curtain(night: Bool) -> Color { StadInk.hex(night ? 0xFFF0C4 : 0xF4EEDC) }
    static let stripes = Color.white.opacity(0.85)

    /// The street colours: night darkens facades (×0.62), lights the lit windows; seasons recolour flowers and snow.
    static func street(_ spec: HouseSpec, night: Bool, season: GevelSeason) -> GevelPalette {
        let f = night ? 0.62 : 1
        return GevelPalette(
            body: StadInk.hex(Gevelkit.shade(spec.color, f)),
            door: StadInk.hex(Gevelkit.shade(spec.door, f)),
            awning: StadInk.hex(Gevelkit.shade(spec.awning, f)),
            trim: StadInk.hex(night ? 0xB9B4A8 : 0xEFEBE2),
            glass: StadInk.hex(night ? 0x232B3B : 0x3E4C55),
            litGlass: StadInk.hex(night ? 0xF6D27A : 0x3E4C55),
            box: season.box.map { StadInk.hex($0) },
            bloom: season.bloom.map { StadInk.hex($0) },
            snow: season == .winter ? .white : nil,
            mortar: mortar(spec.color, night: night),
            curtain: curtain(night: night),
            iron: StadInk.hex(night ? 0x0B0C10 : 0x1E1E1C),
            stone: StadInk.hex(night ? 0x7D7A72 : 0xCFC8BA)
        )
    }
}

/// Draws a `GevelGeometry` into a GraphicsContext, in the prototype's fixed path order.
nonisolated enum GevelPainter {
    static func draw(_ g: GevelGeometry, palette p: GevelPalette, in ctx: inout GraphicsContext) {
        ctx.fill(g.body, with: .color(p.body))
        if let mortar = p.mortar {
            var wall = ctx
            wall.clip(to: g.body)
            wall.stroke(g.brick, with: .color(mortar), lineWidth: 0.45)
        }
        ctx.stroke(g.edge, with: .color(p.trim), style: StrokeStyle(lineWidth: 3, lineJoin: .round))
        ctx.fill(g.trim, with: .color(p.trim))
        ctx.fill(g.steps, with: .color(p.stone))
        ctx.fill(g.glass, with: .color(p.glass))
        ctx.stroke(g.glass, with: .color(p.trim), lineWidth: 2.5)
        ctx.fill(g.lit, with: .color(p.litGlass))
        ctx.fill(g.curtains, with: .color(p.curtain))
        ctx.stroke(g.lit, with: .color(p.trim), lineWidth: 2.5)
        ctx.stroke(g.mull, with: .color(p.trim), lineWidth: 1.1)
        ctx.fill(g.shutters, with: .color(p.door))
        ctx.stroke(g.shutters, with: .color(p.trim), lineWidth: 1)
        ctx.stroke(g.ornament, with: .color(p.trim), style: StrokeStyle(lineWidth: 2.2, lineCap: .round, lineJoin: .round))
        ctx.fill(g.door, with: .color(p.door))
        ctx.fill(g.awning, with: .color(p.awning))
        ctx.fill(g.stripes, with: .color(GevelPalette.stripes))
        if let box = p.box { ctx.fill(g.box, with: .color(box)) }
        if let bloom = p.bloom { ctx.fill(g.bloom, with: .color(bloom)) }
        if let snow = p.snow { ctx.fill(g.snow, with: .color(snow)) }
        ctx.fill(g.deco, with: .color(GevelPalette.deco))
        ctx.stroke(g.iron, with: .color(p.iron), style: StrokeStyle(lineWidth: 1.1, lineCap: .round, lineJoin: .round))
    }

    /// The water reflection keeps only body, trim, glass, lit and door (as in the prototype).
    static func drawReflection(_ g: GevelGeometry, palette p: GevelPalette, in ctx: inout GraphicsContext) {
        ctx.fill(g.body, with: .color(p.body))
        ctx.fill(g.trim, with: .color(p.trim))
        ctx.fill(g.glass, with: .color(p.glass))
        ctx.stroke(g.glass, with: .color(p.trim), lineWidth: 2.5)
        ctx.fill(g.lit, with: .color(p.litGlass))
        ctx.stroke(g.lit, with: .color(p.trim), lineWidth: 2.5)
        ctx.fill(g.door, with: .color(p.door))
    }
}

/// Builds each house's paths once and keeps them.
enum GevelCache {
    private static var store: [HouseSpec: GevelGeometry] = [:]

    static func geometry(for spec: HouseSpec) -> GevelGeometry {
        if let cached = store[spec] { return cached }
        let built = Gevelkit.gevel(spec)
        if store.count > 300 { store.removeAll(keepingCapacity: true) }
        store[spec] = built
        return built
    }
}

/// One canal house from the gevelkit. Scales to the frame it's given, keeping its aspect ratio.
struct CanalHouseView: View, Equatable {
    let spec: HouseSpec
    var night = false
    var season: GevelSeason = .zomer

    init(spec: HouseSpec, night: Bool = false, season: GevelSeason = .zomer) {
        self.spec = spec
        self.night = night
        self.season = season
    }

    var body: some View {
        let geometry = GevelCache.geometry(for: spec)
        let palette = GevelPalette.street(spec, night: night, season: season)
        Canvas { ctx, size in
            ctx.scaleBy(x: size.width / geometry.size.width, y: size.height / geometry.size.height)
            GevelPainter.draw(geometry, palette: palette, in: &ctx)
        }
        .aspectRatio(geometry.size, contentMode: .fit)
        .accessibilityHidden(true)
    }
}
