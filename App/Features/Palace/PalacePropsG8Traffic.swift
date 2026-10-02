import SwiftUI

/// Traffic on the road: busy traffic round a ring, a car giving way, a car overtaking a cyclist,
/// and a parked car with a fine under its wiper. Vehicles are drawn side-on by small helpers that
/// other road scenes can reuse.
enum G8Traffic {
    typealias Look = PalaceFigures.Look

    // MARK: Vehicles

    /// A car side-on, its wheels standing on `y`, from `x` to `x + w`; `left` = driving left.
    static func car(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ colour: UInt32, left: Bool) {
        let h = w * 0.44
        let front: CGFloat = left ? x : x + w, s: CGFloat = left ? 1 : -1
        f.oval(x + 1, y - 1.5, w - 2, 3, 0x1E1E1C, 0.18)
        f.svg("M\(front + s * w * 0.2) \(y - h * 0.58)L\(front + s * w * 0.34) \(y - h)H\(front + s * w * 0.78)L\(front + s * w * 0.9) \(y - h * 0.58)Z", colour)
        f.svg("M\(front + s * w * 0.27) \(y - h * 0.62)L\(front + s * w * 0.37) \(y - h * 0.9)H\(front + s * w * 0.55)V\(y - h * 0.62)Z M\(front + s * w * 0.59) \(y - h * 0.62)V\(y - h * 0.9)H\(front + s * w * 0.75)L\(front + s * w * 0.83) \(y - h * 0.62)Z", 0xBCCDD6)
        f.rect(x, y - h * 0.62, w, h * 0.46, colour, radius: h * 0.16)
        f.rect(x + w * 0.04, y - h * 0.3, w * 0.92, 1.2, PalaceInk.shade(colour, 0.75))
        f.rect(left ? x : x + w - 3, y - h * 0.5, 3, 2.4, 0xFAC775, radius: 1)
        f.rect(left ? x + w - 2.5 : x - 0.5, y - h * 0.5, 3, 2.4, 0xC8261B, radius: 1)
        for wx in [x + w * 0.22, x + w * 0.78] {
            f.dot(wx, y - h * 0.16, h * 0.21, 0x1E1E1C)
            f.dot(wx, y - h * 0.16, h * 0.09, 0x9A9A92)
        }
    }

    /// A city bus side-on (`w` long), wheels on `y`; `left` = driving left.
    static func bus(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ colour: UInt32, left: Bool) {
        let h = w * 0.42
        f.oval(x + 1, y - 1.5, w - 2, 3, 0x1E1E1C, 0.18)
        f.rect(x, y - h, w, h * 0.86, colour, radius: 3)
        f.rect(x, y - h * 0.34, w, h * 0.2, 0xEFEBE2)
        var windows = ""
        for k in 0..<5 {
            let wx = x + 4 + CGFloat(k) * (w - 8) / 5
            windows += "M\(wx) \(y - h * 0.9)h\((w - 8) / 5 - 2)v\(h * 0.36)h-\((w - 8) / 5 - 2)Z"
        }
        f.svg(windows, 0x3E4C55)
        f.rect(left ? x + 1 : x + w - 7, y - h * 0.9, 6, h * 0.5, 0x3E4C55, radius: 1.5)
        f.rect(left ? x + 2 : x + w - 12, y - h * 0.99, 10, h * 0.08, 0xFAC775)
        for wx in [x + w * 0.18, x + w * 0.8] {
            f.dot(wx, y - h * 0.12, h * 0.15, 0x1E1E1C)
            f.dot(wx, y - h * 0.12, h * 0.06, 0x9A9A92)
        }
    }

    /// A cyclist side-on, wheels on `y`, about 30 × 34 at scale `s`; `left` = riding left.
    static func cyclist(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ s: CGFloat, _ v: Look, left: Bool) {
        let g = left ? G8Props.mirrored(f.within(CGRect(x: x, y: y - 34 * s, width: 30 * s, height: 34 * s), unit: s))
            : f.within(CGRect(x: x, y: y - 34 * s, width: 30 * s, height: 34 * s), unit: s)
        g.ring(6, 27, 6, 0x1E1E1C, 1.6)
        g.ring(24, 27, 6, 0x1E1E1C, 1.6)
        g.svgLine("M6 27L12 18H22L24 27M12 18L15 27H6M22 18L21 14H24M11 15H15", 0x2F5BD3, 1.6)
        g.svgLine("M13 15L15 27", v.trousers, 3)
        g.svg("M10 16L14 5C15 3 18 3 19 5L17 16Z", v.coat)
        g.svgLine("M17 7L22 14", v.coat, 2.6)
        g.dot(17, 1.5, 3.6, v.skin)
        g.svg("M13.6 1C14 -2.5 20 -3 20.6 0.6Z", v.hair)
    }

    // MARK: Traffic round the ring

    /// Busy traffic going round a roundabout (170 × 84): a bus and a car on the far side, three
    /// cars and two cyclists on the near side, little arrows showing the way round.
    static func ring(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 170, height: 84))
        bus(f, 36, 24, 52, 0xC8261B, left: true)
        car(f, 96, 24, 30, 0x2F5BD3, left: true)
        car(f, 130, 30, 28, 0xF4F1EA, left: true)
        car(f, 6, 72, 32, 0x3E4C55, left: false)
        car(f, 66, 80, 34, 0xFAC775, left: false)
        car(f, 120, 74, 30, 0x0F6E56, left: false)
        cyclist(f, 40, 82, 0.7, Look.at(3), left: false)
        cyclist(f, 102, 84, 0.7, Look.at(6), left: false)
        f.svgLine("M150 44Q160 50 154 58", 0xFFFDF6, 1.6)
        G8Props.head(f, tip: CGPoint(x: 152, y: 60), dx: -1, dy: 1.2, 5, 0xFFFDF6)
        f.svgLine("M20 52Q10 46 16 38", 0xFFFDF6, 1.6)
        G8Props.head(f, tip: CGPoint(x: 18, y: 36), dx: 1, dy: -1.2, 5, 0xFFFDF6)
    }

    // MARK: Giving way

    /// A car waiting at shark's teeth (104 × 80) before it may drive on: the give-way triangle on
    /// a pole, and a cyclist on the ring riding past first under a green arrow.
    static func giveWay(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 104, height: 80))
        var teeth = ""
        for y in stride(from: 40.0, to: 80, by: 7) { teeth += "M78 \(y)L84 \(y + 3)L78 \(y + 6)Z" }
        f.svg(teeth, 0xFFFDF6)
        car(f, 34, 70, 40, 0x2F5BD3, left: false)
        cyclist(f, 86, 52, 0.62, Look.at(1), left: false)
        f.svgLine("M88 64Q95 52 90 40", 0x1E7A4C, 2.4)
        G8Props.head(f, tip: CGPoint(x: 89, y: 37), dx: -0.3, dy: -1, 6, 0x1E7A4C)
        f.rect(14.5, 18, 3, 62, 0x5E6B73)
        sign(f.within(CGRect(x: 1, y: 0, width: 30, height: 30)), "giveWay")
    }

    // MARK: Overtaking

    /// A car overtaking a cyclist (104 × 72): the cyclist in the near lane, the car swinging out
    /// past them, a curved arrow from behind to in front.
    static func overtake(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 104, height: 72))
        cyclist(f, 14, 68, 0.95, Look.at(2), left: true)
        car(f, 34, 46, 50, 0xC8261B, left: true)
        f.svgLine("M100 62C98 38 72 22 40 22C20 22 8 34 6 48", 0xFFFDF6, 2.4)
        G8Props.head(f, tip: CGPoint(x: 6, y: 54), dx: -0.2, dy: 1, 7, 0xFFFDF6)
    }

    // MARK: Fine

    /// A parked car (110 × 96) with a slip under its wiper, and the slip drawn big in a round
    /// close-up: a red band, the amount (`text`) and a few lines.
    static func fine(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 110, height: 96))
        car(f, 4, 94, 100, 0x5E6B73, left: true)
        f.svg("M30 63L34 60L40 62L36 66Z", 0xFAC775)
        f.svgLine("M28 70L44 58", 0x1E1E1C, 1.4)
        f.svgLine("M38 60L58 40", 0xFFFDF6, 1.4)
        let c = CGPoint(x: 72, y: 26)
        f.dot(c.x, c.y, 27, 0x1E1E1C, 0.14)
        f.dot(c.x, c.y, 26, 0xFFFDF6)
        f.ring(c.x, c.y, 26, 0x3E4C55, 1.6)
        f.rect(c.x - 15, c.y - 18, 30, 36, 0xFAC775, radius: 1.5)
        f.rect(c.x - 15, c.y - 18, 30, 9, 0xC8261B, radius: 1.5)
        f.text(p.text ?? "€ 95", PropFont.heavy(11), 0x1E1E1C, at: CGPoint(x: c.x, y: c.y + 0.5), maxWidth: 28)
        f.svgLine("M\(c.x - 11) \(c.y + 9)H\(c.x + 11)M\(c.x - 11) \(c.y + 13)H\(c.x + 6)", 0x9A8A5A, 1.2)
    }

    // MARK: Road signs

    /// A Dutch road sign filling `f`'s box: "giveWay" (white triangle point down, red rim),
    /// "noEntry" (red disc, white bar), "zebra" (blue square, walker on a crossing),
    /// "roundabout" (blue disc, three arrows round).
    static func sign(_ f: PropPen, _ kind: String) {
        let (w, h) = (f.size.width, f.size.height)
        switch kind {
        case "giveWay":
            let tri = PalaceSVG.path("M1 2H\(w - 1)L\(w / 2) \(h - 1)Z")
            f.fill(tri, 0xC8261B)
            f.stroke(tri, 0xC8261B, 2)
            f.svg("M\(w * 0.2) \(h * 0.17)H\(w * 0.8)L\(w / 2) \(h * 0.72)Z", 0xFFFDF6)
        case "noEntry":
            f.dot(w / 2, h / 2, min(w, h) / 2, 0xFFFDF6)
            f.dot(w / 2, h / 2, min(w, h) / 2 - 1.2, 0xC8261B)
            f.rect(w * 0.18, h / 2 - h * 0.1, w * 0.64, h * 0.2, 0xFFFDF6, radius: 1)
        case "zebra":
            f.rect(0, 0, w, h, 0xFFFDF6, radius: 2)
            f.rect(1.5, 1.5, w - 3, h - 3, 0x2F5BD3, radius: 1.5)
            f.svg("M\(w / 2) \(h * 0.12)L\(w * 0.9) \(h * 0.86)H\(w * 0.1)Z", 0xFFFDF6)
            for k in 0..<4 {
                let x = w * (0.26 + 0.13 * CGFloat(k))
                f.rect(x, h * 0.72, w * 0.07, h * 0.1, 0x1E1E1C)
            }
            PalaceIcon.walk.draw(f, in: CGRect(x: w * 0.32, y: h * 0.32, width: w * 0.36, height: h * 0.36), color: 0x1E1E1C, detail: 0xFFFDF6)
        default:
            f.dot(w / 2, h / 2, min(w, h) / 2, 0xFFFDF6)
            f.dot(w / 2, h / 2, min(w, h) / 2 - 1.2, 0x2F5BD3)
            for k in 0..<3 {
                let a = Double(k) * 2 * .pi / 3
                let r = min(w, h) * 0.24
                f.svgLine("M\(w / 2 + cos(a) * r) \(h / 2 + sin(a) * r)A\(r) \(r) 0 0 1 \(w / 2 + cos(a + 1.6) * r) \(h / 2 + sin(a + 1.6) * r)", 0xFFFDF6, 2.4)
            }
        }
    }
}
