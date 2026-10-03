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
    /// Light mortar lines on brick, and curtains behind lit windows.
    case mortar, curtain
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
    /// Only drawn inside this shape (mortar inside its wall).
    var clip: Path? = nil
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
    /// Where the Gevelplaat can point at each named part (art units).
    var marks: [GevelDeel: CGRect] = [:]
    /// The gable type, when the front is a canal house (the plate names it: "de klokgevel").
    var gable: GableType?

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
        // While locked, what's behind the glass (bread, books, bottles) is hidden by the shutters.
        var windows: [CGRect] = []
        for layer in art.layers {
            if look.locked && (layer.paint == .glass || layer.paint == .lit) {
                if layer.line == nil {
                    KaartShutters.draw(layer.path, night: look.night, in: &ctx)
                    windows += subpathBounds(layer.path).map { $0.insetBy(dx: -1, dy: -1) }
                }
                continue
            }
            if look.locked, layer.paint != .trim, !windows.isEmpty {
                let box = layer.path.boundingRect
                if windows.contains(where: { $0.contains(box) }) { continue }
            }
            let color = resolve(layer.paint, art: art, look: look)
            if let clip = layer.clip, let width = layer.line {
                var inside = ctx
                inside.clip(to: clip)
                inside.stroke(layer.path, with: .color(color), lineWidth: width)
            } else if let width = layer.line {
                ctx.stroke(layer.path, with: .color(color), style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
            } else {
                ctx.fill(layer.path, with: .color(color))
                if layer.paint.isSurface {
                    // Watercolour pooling at the edges, then the ink line right away, so anything
                    // drawn later in front covers it.
                    KaartInk.pool(layer.path, color, rim: 7, in: &ctx)
                    KaartDepth.outline(layer.path, night: look.night, in: &ctx)
                } else if layer.paint == .door || layer.paint == .awning || layer.paint == .accent {
                    KaartDepth.outline(layer.path, night: look.night, in: &ctx, width: 1.6)
                }
            }
        }
    }

    /// The bounding box of each separate shape in a path (each window of a window layer).
    static func subpathBounds(_ path: Path) -> [CGRect] {
        var boxes: [CGRect] = []
        var current = Path()
        path.forEach { element in
            if case .move = element, !current.isEmpty {
                boxes.append(current.boundingRect)
                current = Path()
            }
            switch element {
            case .move(let p): current.move(to: p)
            case .line(let p): current.addLine(to: p)
            case .quadCurve(let p, let c): current.addQuadCurve(to: p, control: c)
            case .curve(let p, let c1, let c2): current.addCurve(to: p, control1: c1, control2: c2)
            case .closeSubpath: current.closeSubpath()
            }
        }
        if !current.isEmpty { boxes.append(current.boundingRect) }
        return boxes
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
        case .mortar: return GevelPalette.mortar(art.wall, night: night) ?? .clear
        case .curtain: return GevelPalette.curtain(night: night)
        case .color(let v): return hex(v)
        case .darker(let v): return hex(v, side)
        }
    }
}

/// The ink line round the solid shapes, so places stand out from the background city.
nonisolated enum KaartDepth {
    /// The ink line round a shape (art units; about 1 world unit on the map).
    static func outline(_ path: Path, night: Bool, in ctx: inout GraphicsContext, width: Double = 2.5) {
        ctx.stroke(path, with: .color(KaartInk.line(night: night)), style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
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
