import SwiftUI

/// One flat vector shape of a drawing: a path with a fill or a stroke, like one SVG `<path>`.
nonisolated struct PalaceMark: Sendable {
    enum Paint: Sendable {
        case fill(Color, evenOdd: Bool)
        case stroke(Color, width: CGFloat, round: Bool)
    }

    var path: Path
    var paint: Paint
    var opacity: Double = 1

    // MARK: Builders (SVG path strings are copied verbatim from the prototype)

    static func f(_ d: String, _ hex: UInt32, _ opacity: Double = 1) -> PalaceMark {
        PalaceMark(path: SVGPath.parse(d), paint: .fill(Ink.hex(hex), evenOdd: false), opacity: opacity)
    }

    static func eo(_ d: String, _ hex: UInt32) -> PalaceMark {
        PalaceMark(path: SVGPath.parse(d), paint: .fill(Ink.hex(hex), evenOdd: true))
    }

    static func s(_ d: String, _ hex: UInt32, _ width: CGFloat, round: Bool = false, _ opacity: Double = 1) -> PalaceMark {
        PalaceMark(path: SVGPath.parse(d), paint: .stroke(Ink.hex(hex), width: width, round: round), opacity: opacity)
    }

    static func dot(_ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat, _ hex: UInt32, _ opacity: Double = 1) -> PalaceMark {
        PalaceMark(path: Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: 2 * r, height: 2 * r)),
                   paint: .fill(Ink.hex(hex), evenOdd: false), opacity: opacity)
    }

    static func ring(_ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat, _ hex: UInt32, _ width: CGFloat) -> PalaceMark {
        PalaceMark(path: Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: 2 * r, height: 2 * r)),
                   paint: .stroke(Ink.hex(hex), width: width, round: false))
    }

    static func oval(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ hex: UInt32, _ opacity: Double = 1) -> PalaceMark {
        PalaceMark(path: Path(ellipseIn: CGRect(x: x, y: y, width: w, height: h)),
                   paint: .fill(Ink.hex(hex), evenOdd: false), opacity: opacity)
    }

    static func box(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ hex: UInt32, _ opacity: Double = 1) -> PalaceMark {
        PalaceMark(path: Path(CGRect(x: x, y: y, width: w, height: h)), paint: .fill(Ink.hex(hex), evenOdd: false), opacity: opacity)
    }

    static func rounded(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ r: CGFloat, _ hex: UInt32) -> PalaceMark {
        PalaceMark(path: Path(roundedRect: CGRect(x: x, y: y, width: w, height: h), cornerRadius: r),
                   paint: .fill(Ink.hex(hex), evenOdd: false))
    }

    // MARK: Drawing

    static func draw(_ marks: [PalaceMark], in ctx: inout GraphicsContext) {
        for mark in marks {
            var c = ctx
            c.opacity = mark.opacity
            switch mark.paint {
            case let .fill(color, evenOdd):
                c.fill(mark.path, with: .color(color), style: FillStyle(eoFill: evenOdd))
            case let .stroke(color, width, round):
                c.stroke(mark.path, with: .color(color), style: StrokeStyle(
                    lineWidth: width, lineCap: round ? .round : .butt, lineJoin: round ? .round : .miter
                ))
            }
        }
    }
}

/// Draws a list of marks at their own coordinates in a fixed-size canvas.
struct PalaceArtwork: View {
    let marks: [PalaceMark]
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Canvas { ctx, _ in
            PalaceMark.draw(marks, in: &ctx)
        }
        .frame(width: width, height: height)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// A small text label painted onto a drawing (sign lettering, stamps).
struct PalaceLettering: View {
    let lines: [String]
    let font: Font
    let color: Color
    var width: CGFloat
    var height: CGFloat
    var spacing: CGFloat = 0
    var tracking: CGFloat = 0

    var body: some View {
        VStack(spacing: spacing) {
            ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                Text(line).font(font).tracking(tracking).foregroundStyle(color)
                    .lineLimit(1).minimumScaleFactor(0.6)
            }
        }
        .frame(width: width, height: height)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

extension View {
    /// Places a view at a top-left point of the 370 × 408 scene.
    func palaceAt(_ x: CGFloat, _ y: CGFloat) -> some View {
        offset(x: x, y: y)
    }
}
