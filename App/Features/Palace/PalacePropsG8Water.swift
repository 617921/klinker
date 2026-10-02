import SwiftUI

/// The water side of a dike: a storm cloud, a farm standing in floodwater, a water-level gauge,
/// rising water marks, and the dike itself in cross-section.
enum G8Water {
    nonisolated static let water: UInt32 = 0x8FB6CF
    nonisolated static let deep: UInt32 = 0x6F9BB8

    // MARK: Storm

    /// A heavy storm (120 × 96): a dark cloud, a lightning bolt and thick slanting rain.
    static func storm(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 120, height: 96), hanging: true)
        var rain = ""
        for (i, x) in stride(from: 8.0, to: 116, by: 7).enumerated() {
            let y0 = 40.0 + Double(i % 3) * 6
            rain += "M\(x) \(y0)L\(x - 9) \(y0 + 26)M\(x - 12) \(y0 + 32)L\(x - 18) \(y0 + 48)"
        }
        f.svgLine(rain, 0x5E7FA0, 2.4)
        f.svg("M58 34L46 58H56L48 82L72 50H60L68 34Z", 0xFAC775)
        f.dot(30, 30, 20, 0x3E4C55)
        f.dot(58, 22, 22, 0x3E4C55)
        f.dot(88, 28, 20, 0x3E4C55)
        f.rect(12, 28, 96, 20, 0x3E4C55, radius: 10)
        f.dot(50, 18, 12, 0x5E6B73)
        f.dot(78, 20, 10, 0x5E6B73)
        f.svgLine("M100 8Q110 10 116 4M104 16Q112 18 118 14", 0x9A9A92, 1.6)
    }

    // MARK: Flooded farm

    /// A farm in floodwater (92 × 84): the house and a tree stand in water up to the windows,
    /// the water's surface at `y` 50 with waves.
    static func floodedFarm(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 92, height: 84))
        f.rect(16, 34, 44, 50, 0xE3D6BC)
        f.svg("M10 36L38 14L66 36Z", 0x9A5238)
        f.rect(22, 42, 10, 10, 0x3E4C55)
        f.rect(44, 42, 10, 10, 0x3E4C55)
        f.rect(70, 38, 4, 46, 0x6B4A2E)
        f.dot(72, 30, 13, 0x5E8C45)
        f.dot(64, 36, 8, 0x4E7A3A)
        f.svgLine("M84 40L90 34M88 44L92 42", 0x9A6A42, 2)
        f.rect(-4, 47, 100, 40, water)
        f.svgLine("M2 47Q8 43 14 47T26 47T38 47T50 47T62 47T74 47T86 47", 0xFFFDF6, 1.6)
        f.svgLine("M22 58V68M54 58V68", PalaceInk.shade(water, 0.9), 6)
        f.svgLine("M10 58H24M50 62H66M30 72H44", 0xFFFDF6, 1.1)
        f.svg("M76 44H90L88 49H78Z", 0xC8261B)
        f.rect(79, 40, 8, 4, 0xBCCDD6, radius: 1)
    }

    // MARK: Gauge

    /// A water-level gauge (40 × 140) standing in the water: a white board with marks and
    /// `labels` (+1, 0, -1), the water's surface touching the middle mark, a dashed level line.
    static func gauge(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 40, height: 140))
        let labels = p.labels ?? ["+1", "0", "-1"]
        f.rect(18, 4, 5, 136, 0x5E6B73)
        f.rect(10, 6, 22, 116, 0xFFFDF6, radius: 1.5)
        f.stroke(Path(roundedRect: CGRect(x: 10, y: 6, width: 22, height: 116), cornerRadius: 1.5), 0x3E4C55, 1)
        for k in 0..<11 {
            let y = 13.2 + CGFloat(k) * 9.6
            f.rect(10, y - 1.2, k % 2 == 0 ? 12 : 7, 2.4, k == 6 ? 0xC8261B : 0x1E1E1C)
        }
        for (i, label) in labels.prefix(3).enumerated() {
            f.text(label, PropFont.heavy(i == 1 ? 9 : 7.5), i == 1 ? 0xC8261B : 0x1E1E1C, at: CGPoint(x: 27, y: 20 + CGFloat(i) * 46), maxWidth: 10)
        }
        f.rect(18, 72, 5, 68, water, 0.55)
        f.rect(10, 72, 22, 50, water, 0.55)
        f.svgLine("M-2 72H8M34 72H42", 0xC8261B, 2)
        f.svgLine("M0 72Q5 69 10 72M30 72Q35 69 40 72", 0xFFFDF6, 1.4)
    }

    // MARK: Rising water

    /// Marks of the water rising (88 × 150), drawn in the water from its surface down: old levels
    /// as dashed lines with their years (`labels`, lowest first), a big arrow up to the surface.
    static func rising(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 88, height: 150), hanging: true)
        let labels = p.labels ?? ["1900", "1950", "2000"]
        for (i, label) in labels.prefix(3).enumerated() {
            let y = 118 - CGFloat(i) * 34
            var dash = Path()
            dash.move(to: CGPoint(x: 4, y: y))
            dash.addLine(to: CGPoint(x: 54, y: y))
            f.ctx.stroke(dash, with: .color(PalaceInk.hex(0xFFFDF6)), style: StrokeStyle(lineWidth: 2.2, dash: [5, 4]))
            f.text(label, PropFont.heavy(9), 0x1F3A6B, at: CGPoint(x: 29, y: y - 7), maxWidth: 46)
        }
        f.svg("M66 140V30H58L74 6L90 30H82V140Z", 0xFFFDF6, 0.9)
        f.svg("M70 136V34H64L74 18L84 34H78V136Z", 0x2F5BD3)
    }

    // MARK: Dike

    /// A dike in cross-section (156 × 196): stone blocks on the water side, grass above them, a
    /// road on the crest with a cyclist, sheep grazing on the land side.
    static func dike(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 156, height: 196))
        let body = "M0 196L54 6H110L156 166V196Z"
        f.svg(body, 0x7FA650)
        f.svg("M0 196L54 6H62L20 196Z", 0x95B36B, 0.6)
        var stones = ""
        for y in stride(from: 196.0, to: 70, by: -12) {
            let xl = (196 - y) * 54 / 190
            stones += "M\(xl) \(y)L\(xl + 3.4) \(y - 12)M\(xl + 13) \(y)L\(xl + 16.4) \(y - 12)M\(xl) \(y)H\(xl + 28)"
        }
        f.svg("M0 196L36 70H64L28 196Z", 0x9A9A92)
        f.svgLine(stones, 0x7D7A72, 1)
        f.svg("M52 6H112V12H50Z", 0x5E6B73)
        f.svgLine("M58 9H66M76 9H84M94 9H102", 0xFFFDF6, 1)
        G8Traffic.cyclist(f, 70, 6, 0.62, PalaceFigures.Look.at(5), left: false)
        for (x, y) in [(118.0, 82.0), (134, 122)] as [(CGFloat, CGFloat)] { sheep(f, x, y) }
        f.svgLine("M74 40l2 -5l2 5M96 64l2 -5l2 5M88 120l2 -5l2 5M120 150l2 -5l2 5", 0x5E8C45, 1.2)
    }

    /// A sheep standing at (x, y) (its feet), facing left.
    static func sheep(_ f: PropPen, _ x: CGFloat, _ y: CGFloat) {
        f.svgLine("M\(x - 5) \(y - 6)V\(y)M\(x + 5) \(y - 6)V\(y)", 0x2E2117, 1.6)
        f.oval(x - 9, y - 15, 18, 11, 0xF4F1EA)
        f.dot(x - 6, y - 15, 4.4, 0xF4F1EA)
        f.oval(x - 13, y - 15, 6, 5, 0x2E2117)
    }
}
