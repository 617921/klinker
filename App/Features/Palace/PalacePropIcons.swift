import SwiftUI

/// Pictograms for signs, screens and posters, drawn in a 24 × 24 box in one colour with a
/// cut-out ("detail") colour. Raw values are the names used in `anchors.json` (`icons`).
nonisolated enum PalaceIcon: String, CaseIterable, Sendable {
    case train, bus, arrow, link, warning, brokenTrack, walk, change, pass, check
    // Outdoor places (PalacePropsOutdoor.swift)
    case banknote, noCard, tram, detour, wheelchair, dogLeash, bike, allowed

    /// Paints the icon into a square `rect`.
    @MainActor func draw(_ pen: PropPen, in rect: CGRect, color c: UInt32, detail d: UInt32) {
        let p = pen.within(rect, unit: rect.width / 24)
        switch self {
        case .train:
            p.svg("M7 2H17Q21 2 21 6V18Q21 20 19 20H5Q3 20 3 18V6Q3 2 7 2Z", c)
            p.rect(6, 5, 12, 6.5, d, radius: 1.2)
            p.dot(7.5, 15.5, 1.6, d)
            p.dot(16.5, 15.5, 1.6, d)
            p.svgLine("M7 20.5L5 23M17 20.5L19 23", c, 1.8)
        case .bus:
            p.svg("M5.5 2H18.5Q21 2 21 4.5V19H3V4.5Q3 2 5.5 2Z", c)
            p.rect(5, 5, 14, 7.5, d, radius: 1)
            p.dot(6.6, 15.8, 1.4, d)
            p.dot(17.4, 15.8, 1.4, d)
            p.rect(4.5, 18.5, 4, 4, c, radius: 1)
            p.rect(15.5, 18.5, 4, 4, c, radius: 1)
            p.svgLine("M3 6.5H1.5V10M21 6.5H22.5V10", c, 1.2)
        case .arrow:
            p.svgLine("M3 12H20M14 6L20 12L14 18", c, 2.6)
        case .link:
            p.stroke(Self.capsule(8.6, 15.4), c, 2.4)
            p.stroke(Self.capsule(15.4, 8.6), c, 2.4)
        case .warning:
            let triangle = PalaceSVG.path("M12 2.5L22.5 21H1.5Z")
            p.fill(triangle, c)
            p.stroke(triangle, c, 2)
            p.svg("M10.9 8H13.1L12.7 15H11.3Z", d)
            p.dot(12, 17.7, 1.35, d)
        case .brokenTrack:
            p.svgLine("M3.5 6V19M7.5 6V19M16.5 6V19M20.5 6V19", c, 1.6, 0.6)
            p.svgLine("M1 9H9.5M14.5 9H23M1 16H9.5M14.5 16H23", c, 2.2)
            p.svgLine("M12.5 4L10.5 8.5L13.5 12.5L10.5 16.5L12.5 21", d, 2)
        case .walk:
            Self.walker(p, c)
        case .change:
            // The arc reaches over the neighbouring icons: from one train to the other.
            p.svgLine("M-8 6Q12 -12 32 6", c, 2.2)
            p.svgLine("M27.6 5.6L32 6L32.2 1.6", c, 2.2)
            Self.walker(p.within(CGRect(x: 2.4, y: 4, width: 19.2, height: 19.2), unit: 0.8), c)
        case .pass:
            p.rect(1.5, 5, 21, 14.5, c, radius: 2)
            p.svg("M3.5 5H20.5Q22.5 5 22.5 7V8.8H1.5V7Q1.5 5 3.5 5Z", d)
            p.rect(4, 10.6, 5.6, 6.6, d, radius: 0.6, 0.5)
            p.dot(6.8, 12.8, 1.4, d)
            p.svgLine("M12 12.2H19.5M12 15.2H17.5", d, 1.3)
        case .check:
            p.svgLine("M5 12.5L10 17.5L19.5 7", c, 3)
        case .banknote, .noCard, .tram, .detour, .wheelchair, .dogLeash, .bike, .allowed:
            PalaceOutdoorIcons.draw(self, p, c, d)
        }
    }

    /// One link of a chain, slanted.
    @MainActor private static func capsule(_ cx: CGFloat, _ cy: CGFloat) -> Path {
        Path(roundedRect: CGRect(x: -6, y: -3.3, width: 12, height: 6.6), cornerRadius: 3.3)
            .applying(CGAffineTransform(rotationAngle: -.pi / 4).concatenating(CGAffineTransform(translationX: cx, y: cy)))
    }

    /// The walking person of station signs.
    @MainActor private static func walker(_ p: PropPen, _ c: UInt32) {
        p.dot(13.6, 3.6, 2.6, c)
        p.svgLine("M13 7.6L11.4 14", c, 2.8)
        p.svgLine("M11.4 14L8.2 21.5M11.4 14L15 17.2L16.2 22", c, 2.5)
        p.svgLine("M12.7 9.2L8.8 12.2M12.7 9.2L16.6 11.8", c, 2.1)
    }
}

/// Colour schemes for signs and screens: background, border, lettering, icon detail.
struct PropTone {
    let back: UInt32
    let border: UInt32
    let ink: UInt32
    let detail: UInt32

    static func named(_ name: String?) -> PropTone {
        switch name {
        case "yellow": PropTone(back: 0xFAC775, border: 0x1F3A6B, ink: 0x1F3A6B, detail: 0xFAC775)
        case "white": PropTone(back: 0xFFFDF6, border: 0x1F3A6B, ink: 0x1F3A6B, detail: 0xFFFDF6)
        case "dark": PropTone(back: 0x232B3B, border: 0x2E2117, ink: 0xFAC775, detail: 0x232B3B)
        default: PropTone(back: 0x1F3A6B, border: 0xF4F1EA, ink: 0xF4F1EA, detail: 0x1F3A6B)
        }
    }
}
