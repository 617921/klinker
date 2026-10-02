import SwiftUI

/// Shared figure parts for group g5's people: the same build as `PalaceFigures.person`
/// (64 × 114 standing, 64 × 100 seated, facing right) with faces that show a feeling.
enum G5Body {
    typealias Look = PalaceFigures.Look

    enum Face {
        case calm, smile, laugh, bliss, wow, sad, cry, scared, sing, shut
    }

    static let ink: UInt32 = 0x2E2117

    /// Legs, shoes, coat and collar of a standing person (arms and head are drawn by the caller).
    static func standing(_ f: PropPen, _ v: Look, coat: UInt32? = nil, collar: UInt32 = 0xEFEBE2) {
        f.oval(6, 106, 52, 6, 0x1E1E1C, 0.16)
        f.svgLine("M17 84V104M27 84V104", v.trousers, 5)
        f.svg("M12 103H21V108H12Z M23 103H32V108H23Z", ink)
        f.svg("M9 88L10.5 44C11.5 36 15.5 32 22 32C28.5 32 32.5 36 33.5 44L35 88Z", coat ?? v.coat)
        f.svg("M17 32L22 39L27 32Z", collar)
    }

    /// A person seated facing right (64 × 100): `seat` "plush" (a red theatre seat), "pew"
    /// (a wooden church bench) or "none" (the caller draws the chair). Head at (23, 26), shoulder (28, 46).
    static func seated(_ f: PropPen, _ v: Look, seat: String, coat: UInt32? = nil) {
        let plush = seat == "plush"
        let back: UInt32 = plush ? 0x9E2A20 : 0x8C5E38
        f.oval(2, 95, 54, 5, 0x1E1E1C, 0.14)
        if plush {
            f.svgLine("M10 80V97M34 80V97", 0x2E2117, 2.4)
            f.rect(1, 36, 14, 46, back, radius: 6)
            f.rect(3, 39, 4, 38, PalaceInk.shade(back, 1.2), radius: 2)
        } else if seat == "pew" {
            f.svgLine("M4 78V97M44 78V97", 0x5E4A36, 3)
            f.rect(0, 40, 9, 40, back, radius: 1.5)
            f.svgLine("M0 52H9M0 64H9", PalaceInk.shade(back, 0.8), 1)
        }
        if seat == "plush" || seat == "pew" {
            f.rect(2, 72, plush ? 46 : 52, 9, PalaceInk.shade(back, plush ? 0.85 : 1.1), radius: plush ? 4 : 1)
        }
        f.svg("M11 72L12 48C13 41 17 38 23 38C29 38 33 41 34 48L35 72Z", coat ?? v.coat)
        f.svg("M18 38L23 44L28 38Z", 0xEFEBE2)
        f.svg("M15 64H47Q51 64 51 68V73H15Z", v.trousers)
        f.svgLine("M41 72V93", PalaceInk.shade(v.trousers, 0.8), 5.5)
        f.svgLine("M47 70V93", v.trousers, 6)
        f.svg("M38 92H47Q50 92 50 95V97H38Z M44 92H53Q56 92 56 95V97H44Z", ink)
        if plush { f.rect(8, 60, 30, 4.5, 0x4A3524, radius: 2) }
    }

    /// A head of radius 11 centred at (cx, cy), the look's hair, and a face facing right.
    static func head(_ f: PropPen, _ v: Look, _ cx: CGFloat, _ cy: CGFloat, face: Face, hair: UInt32? = nil) {
        f.dot(cx, cy, 11, v.skin)
        f.svg("M\(cx - 11) \(cy - 1)C\(cx - 12) \(cy - 9) \(cx - 7) \(cy - 13) \(cx) \(cy - 13)C\(cx + 7) \(cy - 13) \(cx + 12) \(cy - 9) \(cx + 11) \(cy - 1)C\(cx + 9) \(cy - 6) \(cx + 5) \(cy - 7.5) \(cx) \(cy - 7.5)C\(cx - 5) \(cy - 7.5) \(cx - 9) \(cy - 6) \(cx - 11) \(cy - 1)Z", hair ?? v.hair)
        let (ex, ey) = (cx + 5.5, cy + 0.5)
        let (mx, my) = (cx + 5.5, cy + 6.2)
        let lip = PalaceInk.shade(v.skin, 0.62)
        func dotEye() { f.dot(ex, ey, 1.4, ink) }
        func closedHappy() { f.svgLine("M\(ex - 2) \(ey + 0.6)Q\(ex) \(ey - 1.8) \(ex + 2) \(ey + 0.6)", ink, 1.2) }
        func closedDown() { f.svgLine("M\(ex - 2) \(ey - 0.4)Q\(ex) \(ey + 1.8) \(ex + 2) \(ey - 0.4)", ink, 1.2) }
        func openMouth(_ h: CGFloat) {
            f.svg("M\(mx - 3.4) \(my - 1.4)H\(mx + 3.4)Q\(mx + 3) \(my + h) \(mx) \(my + h)Q\(mx - 3) \(my + h) \(mx - 3.4) \(my - 1.4)Z", 0x7A2A20)
        }
        switch face {
        case .calm:
            dotEye()
            f.svgLine("M\(mx - 2) \(my)Q\(mx) \(my + 1) \(mx + 2) \(my - 0.4)", lip, 1.1)
        case .smile:
            dotEye()
            f.svgLine("M\(mx - 3) \(my - 1)Q\(mx) \(my + 2.4) \(mx + 3) \(my - 1.4)", lip, 1.2)
        case .laugh:
            closedHappy()
            openMouth(4.2)
        case .bliss:
            closedHappy()
            f.svgLine("M\(mx - 3) \(my - 1)Q\(mx) \(my + 2.6) \(mx + 3) \(my - 1.4)", lip, 1.3)
            f.dot(cx + 1.5, cy + 4, 2.4, 0xE88B7A, 0.55)
        case .wow:
            f.dot(ex, ey - 0.4, 2.4, 0xFFFDF6)
            f.ring(ex, ey - 0.4, 2.4, ink, 0.6)
            f.dot(ex + 0.6, ey - 0.4, 1.2, ink)
            f.oval(mx - 1.8, my - 1.2, 3.6, 4.4, 0x7A2A20)
        case .sad:
            dotEye()
            f.svgLine("M\(ex - 2.6) \(ey - 3)L\(ex + 1.8) \(ey - 4.6)", ink, 1)
            f.svgLine("M\(mx - 3) \(my + 1.6)Q\(mx) \(my - 1.4) \(mx + 3) \(my + 1.6)", lip, 1.3)
        case .cry:
            closedDown()
            f.svgLine("M\(ex - 2.6) \(ey - 3)L\(ex + 1.8) \(ey - 4.6)", ink, 1)
            f.svgLine("M\(mx - 3) \(my + 1.2)Q\(mx - 1.5) \(my - 0.6) \(mx) \(my + 0.8)Q\(mx + 1.5) \(my - 0.6) \(mx + 3) \(my + 1.2)", lip, 1.2)
            f.svgLine("M\(ex) \(ey + 2)Q\(ex - 1) \(ey + 6) \(ex) \(ey + 9)", 0x6FA3C7, 1.6)
        case .scared:
            f.dot(ex, ey - 0.6, 2.6, 0xFFFDF6)
            f.ring(ex, ey - 0.6, 2.6, ink, 0.6)
            f.dot(ex + 0.9, ey - 0.6, 0.9, ink)
            f.svgLine("M\(ex - 2.8) \(ey - 5)Q\(ex) \(ey - 7) \(ex + 2.8) \(ey - 5.2)", ink, 1)
            f.oval(mx - 2.2, my - 1.6, 4.4, 6, 0x7A2A20)
        case .sing:
            closedHappy()
            f.oval(mx - 2, my - 1.6, 4.2, 5, 0x7A2A20)
        case .shut:
            closedDown()
            f.svgLine("M\(mx - 2) \(my)H\(mx + 2)", lip, 1.1)
        }
    }

    /// An arm: a sleeve along the SVG path `d`, the hand at `hand`.
    static func arm(_ f: PropPen, _ d: String, hand: CGPoint, sleeve: UInt32, skin: UInt32, width: CGFloat = 6) {
        f.svgLine(d, sleeve, width)
        f.dot(hand.x, hand.y, 3.2, skin)
    }

    /// A small tear drop.
    static func tear(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ r: CGFloat = 1.8) {
        f.svg("M\(x) \(y - r * 2)Q\(x + r) \(y - r * 0.4) \(x + r) \(y)A\(r) \(r) 0 0 1 \(x - r) \(y)Q\(x - r) \(y - r * 0.4) \(x) \(y - r * 2)Z", 0x6FA3C7)
    }
}
