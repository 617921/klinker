import SwiftUI

/// What a landmark layer is painted with. The painter turns paints into colours for day or
/// night, the season, and the locked look (windows become closed shutters).
nonisolated enum KaartPaint: Sendable, Hashable {
    /// The building's own colours (see `KaartLandmark`): front wall, its shaded side wall,
    /// roof, the roof's shaded slope, door, awning and one accent.
    case wall, side, roof, roofSide, door, awning, accent
    /// Windows: dark glass; `lit` glows warm at night once the place is built.
    case glass, lit
    /// Cream window frames, cornices, columns.
    case trim
    /// Dark wood and iron (beams, railings, signs), white, leaves, flowers (season colour).
    case ink, white, plant, bloom
    /// Any colour (darkened at night), and the same colour on a shaded side wall.
    case color(UInt32), darker(UInt32)

    /// The paint of the shaded side of a box painted with `self`.
    var shaded: KaartPaint {
        switch self {
        case .wall: .side
        case .roof: .roofSide
        case .color(let hex): .darker(hex)
        default: self
        }
    }

    /// Big surfaces: get depth shading and the outline.
    var isSurface: Bool {
        switch self {
        case .wall, .side, .roof, .roofSide, .color, .darker: true
        default: false
        }
    }
}

nonisolated struct KaartLayer: Sendable {
    var path: Path
    var paint: KaartPaint
    /// Line width for a stroke; nil fills the path.
    var line: Double?
}

/// A place's own building, in art units: the units of a canal-house front (a house is ~70 wide,
/// a floor 34 high, the side wall 30 deep). y grows downward and the ground is y = 0, so a
/// 100-high wall spans y −100...0. Drawn at 0.39 world units per art unit.
nonisolated struct KaartLandmark: Sendable {
    var wall: UInt32
    var roof: UInt32 = 0x5B3328
    var door: UInt32 = 0x1E1E1C
    var awning: UInt32 = 0xC8261B
    var accent: UInt32 = 0xF2711C
    var layers: [KaartLayer] = []
    /// The main front face: scaffolding goes round it.
    var front: CGRect = .zero
    /// The front door: the ribbon and padlock hang here while the place is locked.
    var doorRect: CGRect = .zero
    /// Top-left of the hanging shop sign (26 × 22 world units), if not the default spot.
    var signAt: CGPoint?
    /// The SF Symbol painted on the shop sign (default: `PlaceCatalog.symbol`). "" hangs no sign.
    var sign: String?

    var bounds: CGRect {
        layers.reduce(CGRect.null) { box, layer in
            let pad = (layer.line ?? 0) / 2
            return box.union(layer.path.boundingRect.insetBy(dx: -pad, dy: -pad))
        }
    }

    /// Everything solid, for the sun shadow.
    var silhouette: Path {
        var path = Path()
        for layer in layers where layer.line == nil && layer.paint.isSurface { path.addPath(layer.path) }
        return path
    }
}

/// How a building looks right now.
nonisolated struct KaartLook: Sendable {
    var night = false
    var season: GevelSeason = .zomer
    /// Not reached yet: shutters closed, no lights.
    var locked = false
    /// Built: the windows light up at night.
    var lightsOn = false
}

/// Paints a `KaartLandmark` into a context already scaled to art units.
nonisolated enum KaartLandmarkPainter {
    static func draw(_ art: KaartLandmark, look: KaartLook, in ctx: inout GraphicsContext) {
        for layer in art.layers {
            if look.locked && (layer.paint == .glass || layer.paint == .lit) {
                if layer.line == nil { KaartShutters.draw(layer.path, night: look.night, in: &ctx) }
                continue
            }
            let color = resolve(layer.paint, art: art, look: look)
            if let width = layer.line {
                ctx.stroke(layer.path, with: .color(color), style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
            } else {
                ctx.fill(layer.path, with: .color(color))
                if layer.paint.isSurface {
                    KaartDepth.shade(layer.path, night: look.night, in: &ctx)
                    // Outlined right away, so anything drawn later in front covers the line.
                    KaartDepth.outline(layer.path, night: look.night, in: &ctx)
                }
            }
        }
    }

    static func resolve(_ paint: KaartPaint, art: KaartLandmark, look: KaartLook) -> Color {
        let night = look.night
        let f = night ? 0.62 : 1
        let side = night ? 0.42 : 0.74
        let winter = look.season == .winter
        func hex(_ v: UInt32, _ k: Double = f) -> Color { StadInk.hex(Gevelkit.shade(v, k)) }
        switch paint {
        case .wall: return hex(art.wall)
        case .side: return hex(art.wall, side)
        case .roof: return winter ? StadInk.hex(night ? 0x8D93A6 : 0xF4F2EC) : hex(art.roof, night ? 0.6 : 1)
        case .roofSide: return winter ? StadInk.hex(night ? 0x6B7186 : 0xD9DCD8) : hex(art.roof, night ? 0.4 : 0.72)
        case .door: return hex(art.door)
        case .awning: return hex(art.awning)
        case .accent: return hex(art.accent)
        case .glass: return StadInk.hex(night ? 0x232B3B : 0x3E4C55)
        case .lit: return StadInk.hex(night && look.lightsOn ? 0xF6D27A : night ? 0x232B3B : 0x3E4C55)
        case .trim: return StadInk.hex(night ? 0xB9B4A8 : 0xEFEBE2)
        case .ink: return StadInk.hex(night ? 0x1A140E : 0x2E2117)
        case .white: return StadInk.hex(night ? 0xB9B4A8 : 0xFFFFFF)
        case .plant: return hex(0x5E8C45)
        case .bloom: return hex(look.season.bloom ?? 0xC8261B)
        case .color(let v): return hex(v)
        case .darker(let v): return hex(v, side)
        }
    }
}

/// Light from above: walls a touch lighter at the top and darker at the foot, and a thin
/// dark outline round the solid shapes, so places stand out from the flat background city.
nonisolated enum KaartDepth {
    static func shade(_ path: Path, night: Bool, in ctx: inout GraphicsContext) {
        let box = path.boundingRect
        guard box.width * box.height > 300 else { return }
        let gradient = Gradient(stops: [
            .init(color: .white.opacity(night ? 0.04 : 0.13), location: 0),
            .init(color: .white.opacity(0), location: 0.35),
            .init(color: .black.opacity(0), location: 0.6),
            .init(color: .black.opacity(night ? 0.12 : 0.1), location: 1),
        ])
        ctx.fill(path, with: .linearGradient(gradient, startPoint: CGPoint(x: box.midX, y: box.minY), endPoint: CGPoint(x: box.midX, y: box.maxY)))
    }

    static func outline(_ path: Path, night: Bool, in ctx: inout GraphicsContext) {
        ctx.stroke(path, with: .color(StadInk.hex(night ? 0x0A0C12 : 0x2E2117, night ? 0.6 : 0.42)), style: StrokeStyle(lineWidth: 1.8, lineJoin: .round))
    }
}

/// Closed wooden shutters over windows: green boards with slats.
nonisolated enum KaartShutters {
    static func draw(_ windows: Path, night: Bool, in ctx: inout GraphicsContext) {
        ctx.fill(windows, with: .color(StadInk.hex(Gevelkit.shade(0x2F5E46, night ? 0.55 : 1))))
        let box = windows.boundingRect
        var slats = Path()
        var y = box.minY + 2.2
        while y < box.maxY {
            slats.move(to: CGPoint(x: box.minX, y: y))
            slats.addLine(to: CGPoint(x: box.maxX, y: y))
            y += 3.2
        }
        var clipped = ctx
        clipped.clip(to: windows)
        clipped.stroke(slats, with: .color(StadInk.hex(0x1E3A2C, night ? 0.6 : 0.55)), lineWidth: 0.9)
    }
}
