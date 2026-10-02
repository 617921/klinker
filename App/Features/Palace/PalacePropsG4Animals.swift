import SwiftUI

/// Pets for any place: a dog, a cat and a rabbit sitting and facing right, each drawn in its own
/// design box and fitted into a rect with `G4Animals.sit`. A mood changes the face; `fluffy` gives
/// the coat long tufts. Anchor points (head, neck, front paw) are in the design box.
enum G4Animals {
    enum Kind: Int { case dog = 0, cat, rabbit }
    enum Mood { case calm, sad, pain, happy, sick }

    static func kind(_ variant: Int?) -> Kind { Kind(rawValue: (variant ?? 0) % 3) ?? .dog }

    /// The design box of each animal.
    static func design(_ kind: Kind) -> CGSize {
        switch kind {
        case .dog: CGSize(width: 54, height: 50)
        case .cat: CGSize(width: 44, height: 50)
        case .rabbit: CGSize(width: 42, height: 50)
        }
    }

    static func defaultCoat(_ kind: Kind) -> UInt32 {
        switch kind {
        case .dog: 0xC9A15B
        case .cat: 0x5E6B73
        case .rabbit: 0xD9CDB4
        }
    }

    /// Head centre, neck (collar / scruff) and the near front paw, in design points.
    static func anchors(_ kind: Kind) -> (head: CGPoint, neck: CGPoint, paw: CGPoint) {
        switch kind {
        case .dog: (CGPoint(x: 38, y: 14), CGPoint(x: 33, y: 22), CGPoint(x: 37, y: 47))
        case .cat: (CGPoint(x: 27, y: 15), CGPoint(x: 23, y: 24), CGPoint(x: 29, y: 47))
        case .rabbit: (CGPoint(x: 29, y: 25), CGPoint(x: 23, y: 31), CGPoint(x: 29, y: 47))
        }
    }

    /// A pen whose units are the animal's design points, the animal standing on `rect`'s bottom
    /// edge, centred (or mirrored to face left).
    static func pen(_ kind: Kind, _ pen: PropPen, in rect: CGRect, left: Bool = false) -> PropPen {
        let d = design(kind)
        let s = min(rect.width / d.width, rect.height / d.height)
        let box = CGRect(x: rect.midX - d.width * s / 2, y: rect.maxY - d.height * s, width: d.width * s, height: d.height * s)
        return pen.within(box, unit: s).mirrored(left)
    }

    /// Draws the animal sitting in `rect` and returns its design pen (for things added on top).
    @discardableResult
    static func sit(_ kind: Kind, _ pen: PropPen, in rect: CGRect, coat: UInt32? = nil, mood: Mood = .calm,
                    fluffy: Bool = false, left: Bool = false, shadow: Bool = true) -> PropPen {
        let f = Self.pen(kind, pen, in: rect, left: left)
        let c = coat ?? defaultCoat(kind)
        if shadow { f.oval(4, 46.5, design(kind).width - 6, 4, 0x1E1E1C, 0.14) }
        switch kind {
        case .dog: dog(f, c, mood, fluffy)
        case .cat: cat(f, c, mood, fluffy)
        case .rabbit: rabbit(f, c, mood)
        }
        return f
    }

    /// The colour a coat turns when the animal is ill.
    static let sickTint: UInt32 = 0xA9C48A

    private static func dog(_ f: PropPen, _ c: UInt32, _ mood: Mood, _ fluffy: Bool) {
        let dark = PalaceInk.shade(c, 0.72)
        f.svgLine("M12 41Q2 37 5 26", c, 3.6)
        f.oval(7, 26, 27, 23, c)
        f.oval(7, 43, 17, 6, dark)
        if fluffy {
            f.stroke(PalaceSVG.path("M22 47V27Q22 18 30 18H35Q41 20 41 30V47Z"), c, 6)
            f.stroke(Path(ellipseIn: CGRect(x: 7, y: 26, width: 27, height: 23)), c, 6)
            tufts(f, c, [(5, 30), (9, 24), (18, 20), (25, 16), (43, 26), (44, 34), (3, 38)])
        }
        f.svg("M22 47V27Q22 18 30 18H35Q41 20 41 30V47Z", c)
        f.svgLine("M30 35V47M37 35V47", PalaceInk.shade(c, 0.9), 4.4)
        f.oval(26.5, 45, 8, 4, dark)
        f.oval(33.5, 45, 8, 4, dark)
        let head = CGPoint(x: 38, y: 14)
        f.dot(head.x, head.y, 9.5, c)
        f.rect(41, 13, 13, 9, PalaceInk.shade(c, 1.15), radius: 4.5)
        f.dot(52.5, 15, 2.1, 0x1E1E1C)
        let ear = mood == .sad || mood == .pain ? "M31 8Q25 12 27 22Q29 25 32 20Q33 13 31 8Z" : "M31 5Q24 7 25 17Q27 21 31 17Q33 11 31 5Z"
        f.svg(ear, dark)
        face(f, eye: CGPoint(x: 41, y: 11), mouth: CGPoint(x: 48, y: 20), mood)
        f.svgLine("M31.5 21.5L38.5 23.5", 0xC8261B, 2.6)
    }

    private static func cat(_ f: PropPen, _ c: UInt32, _ mood: Mood, _ fluffy: Bool) {
        f.svgLine("M12 46Q1 45 3 33Q4.5 27 2 22", c, fluffy ? 6 : 3.4)
        if fluffy {
            f.stroke(PalaceSVG.path("M8 48C5 34 10 24 20 23C30 23 35 32 33 48Z"), c, 7)
            tufts(f, c, [(4, 36), (6, 27), (12, 21), (35, 28), (37, 37), (3, 44), (36, 45)])
        }
        f.svg("M8 48C5 34 10 24 20 23C30 23 35 32 33 48Z", c)
        f.svg("M23 48C22 39 24 31 28 29C31.5 33 33 40 32 48Z", PalaceInk.shade(c, 1.25))
        f.oval(19, 45, 7.5, 4.2, PalaceInk.shade(c, 1.12))
        f.oval(26, 45, 7.5, 4.2, PalaceInk.shade(c, 1.12))
        let ears = mood == .sad ? "M18 13L16 5L23 9Z M29 8L37 6L35 13Z" : "M18.5 11L18.5 2L25 7.5Z M28.5 7L35 1.5L35.5 11Z"
        f.svg(ears, c)
        f.dot(27, 15, 9, c)
        if fluffy { tufts(f, c, [(19, 20), (35, 19), (21, 9)]) }
        f.svg("M20.5 8L20.8 4.6L23 7Z M31 6.6L33.6 4.2L33.6 8Z", 0xE6A6A0)
        face(f, eye: CGPoint(x: 29.5, y: 13.5), mouth: CGPoint(x: 31, y: 19.5), mood, second: CGPoint(x: 23.5, y: 13.5))
        f.svg("M30 16.4H33L31.5 18.2Z", 0xE6A6A0)
        f.svgLine("M33 18L41 16M33 19.5L41 20.5", 0xFFFDF6, 0.7)
    }

    private static func rabbit(_ f: PropPen, _ c: UInt32, _ mood: Mood) {
        f.dot(7, 38, 4.4, 0xFFFDF6)
        f.oval(6, 26, 27, 23, c)
        f.oval(7, 44, 16, 5, PalaceInk.shade(c, 0.85))
        let ears = mood == .sad ? "M21 22C12 18 9 14 11 12C14 11 19 15 24 20Z M24 19C18 13 17 9 19 8C22 8 25 12 27 18Z"
            : "M23 19C20 10 20 2 23 2C26 2 27 9 26 19Z M27 19C27 10 30 4 32.5 5C35 6 33 12 30 19Z"
        f.svg(ears, c)
        f.svgLine(mood == .sad ? "M14 14Q18 16 21 19" : "M23.5 6V16M30.8 8.5L29 16", 0xE6A6A0, 1.4)
        f.dot(29, 25, 8.5, c)
        f.oval(26, 44, 8, 4.5, PalaceInk.shade(c, 1.1))
        face(f, eye: CGPoint(x: 31.5, y: 23), mouth: CGPoint(x: 35, y: 29.5), mood)
        f.dot(36.6, 26.4, 1.5, 0xE6A6A0)
    }

    /// Eyes and mouth for a mood (`eye` is the near eye, `second` the far one if visible).
    private static func face(_ f: PropPen, eye: CGPoint, mouth: CGPoint, _ mood: Mood, second: CGPoint? = nil) {
        let eyes = [eye] + (second.map { [$0] } ?? [])
        for e in eyes {
            switch mood {
            case .happy:
                f.svgLine("M\(e.x - 1.6) \(e.y + 0.6)Q\(e.x) \(e.y - 1.4) \(e.x + 1.6) \(e.y + 0.6)", 0x1E1E1C, 1)
            case .pain, .sick:
                f.svgLine("M\(e.x - 1.6) \(e.y - 1)L\(e.x + 1.4) \(e.y)L\(e.x - 1.6) \(e.y + 1)", 0x1E1E1C, 0.9)
            case .sad:
                f.dot(e.x, e.y, 1.8, 0x1E1E1C)
                f.dot(e.x + 0.6, e.y - 0.6, 0.6, 0xFFFFFF)
                f.svgLine("M\(e.x - 2.2) \(e.y - 3.4)L\(e.x + 1.4) \(e.y - 2.4)", 0x1E1E1C, 0.8)
            case .calm:
                f.dot(e.x, e.y, 1.3, 0x1E1E1C)
            }
        }
        switch mood {
        case .happy: f.svgLine("M\(mouth.x - 2) \(mouth.y - 0.5)Q\(mouth.x) \(mouth.y + 1.8) \(mouth.x + 2) \(mouth.y - 0.5)", 0x1E1E1C, 0.9)
        case .sad, .pain: f.svgLine("M\(mouth.x - 2) \(mouth.y + 0.8)Q\(mouth.x) \(mouth.y - 1.2) \(mouth.x + 2) \(mouth.y + 0.8)", 0x1E1E1C, 0.9)
        default: break
        }
    }

    /// Long hair: little pointed tufts at the given points.
    private static func tufts(_ f: PropPen, _ c: UInt32, _ points: [(CGFloat, CGFloat)]) {
        for (i, (x, y)) in points.enumerated() {
            let dx: CGFloat = i % 2 == 0 ? -3.5 : 3.5
            f.svg("M\(x - 3) \(y)Q\(x + dx) \(y - 6) \(x + 3) \(y)Q\(x) \(y + 3) \(x - 3) \(y)Z", c)
        }
    }

    /// A tear running from an eye.
    static func tear(_ f: PropPen, _ x: CGFloat, _ y: CGFloat) {
        f.svg("M\(x) \(y)Q\(x + 2.4) \(y + 4) \(x) \(y + 5)Q\(x - 2.4) \(y + 4) \(x) \(y)Z", 0x8FB6CF)
    }
}
