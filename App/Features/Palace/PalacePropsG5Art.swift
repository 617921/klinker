import SwiftUI

/// The museum: an exhibition banner, paintings in gilt frames (with a crowd taking photos, or a
/// tiny visitor in front of a huge canvas), and things on plinths (a marble statue, a Delft vase).
enum G5Art {
    private static let gold: UInt32 = 0xC9A15B

    // MARK: Banner

    /// A banner hanging from a rod (fills its frame): `tone` cloth, a small framed painting,
    /// `lines` title, `caption` (dates) near the swallowtail.
    static func banner(_ pen: PropPen, _ p: PalacePropParams) {
        let (w, h) = (pen.size.width, pen.size.height)
        let cloth = PropColor.named(p.tone, 0x7A1E1E)
        pen.line(w * 0.25, 0, w * 0.25, 6, 0x2E2117, 1)
        pen.line(w * 0.75, 0, w * 0.75, 6, 0x2E2117, 1)
        pen.rect(0, 6, w, 4, 0x2E2117, radius: 2)
        pen.svg("M4 10H\(w - 4)V\(h)L\(w / 2) \(h - 12)L4 \(h)Z", cloth)
        pen.svgLine("M8 14H\(w - 8)", gold, 1)
        let side = min(w - 18, h * 0.32)
        let pic = CGRect(x: (w - side) / 2, y: 18, width: side, height: side * 0.8)
        pen.rect(pic.insetBy(dx: -3, dy: -3), gold, radius: 1)
        picture(pen.within(pic), "landscape", pic.size)
        var y = pic.maxY + 13
        for line in (p.lines ?? []).prefix(3) {
            pen.text(line, PropFont.heavy(10), 0xFFFDF6, at: CGPoint(x: w / 2, y: y), maxWidth: w - 10)
            y += 12
        }
        if let caption = p.caption {
            pen.text(caption, PropFont.demi(8), 0xFAC775, at: CGPoint(x: w / 2, y: min(h - 26, y + 6)), maxWidth: w - 10)
        }
    }

    // MARK: Painting

    /// A painting in a gilt frame (fills its frame). `accessory` the picture: "landscape" (polder,
    /// windmill, canal), "portrait" (a girl in a blue headscarf with a pearl), "group" (a dark
    /// group portrait with hats and a lance). `count` people stand in front taking photos with
    /// flashes behind a rope; `variant` 1 puts one tiny visitor at the foot of the canvas.
    static func frame(_ pen: PropPen, _ p: PalacePropParams) {
        let (w, h) = (pen.size.width, pen.size.height)
        let crowd = max(0, min(p.count ?? 0, 4))
        let tiny = p.variant == 1
        let below: CGFloat = crowd > 0 ? h * 0.46 : (tiny ? min(48, h * 0.24) : 0)
        let outer = CGRect(x: 0, y: 0, width: w, height: h - below)
        let t = max(3, min(outer.width, outer.height) * 0.07)
        pen.rect(outer.offsetBy(dx: 1.5, dy: 2.5), 0x1E1E1C, radius: 1, 0.25)
        pen.rect(outer, gold, radius: 1)
        pen.stroke(Path(outer.insetBy(dx: t * 0.45, dy: t * 0.45)), PalaceInk.shade(gold, 1.2), max(1, t * 0.2))
        let canvas = outer.insetBy(dx: t, dy: t)
        var g = pen.within(canvas)
        g.ctx.clip(to: Path(CGRect(origin: .zero, size: canvas.size)))
        picture(g, p.accessory ?? "landscape", canvas.size)
        if crowd > 0 {
            let top = h - below
            pen.svgLine("M2 \(top + 14)Q\(w / 2) \(top + 22) \(w - 2) \(top + 14)", 0xA3221B, 2.2)
            pen.rect(0, top + 12, 3, 24, gold)
            pen.rect(w - 3, top + 12, 3, 24, gold)
            let step = w / CGFloat(crowd)
            for i in 0..<crowd {
                let v = PalaceFigures.Look.at(i * 3 + 2)
                let x = step * (CGFloat(i) + 0.5), headY = top + below * (i % 2 == 0 ? 0.5 : 0.58)
                pen.svg("M\(x - 12) \(h)L\(x - 10) \(headY + 10)Q\(x) \(headY + 5) \(x + 10) \(headY + 10)L\(x + 12) \(h)Z", v.coat)
                pen.dot(x, headY, 7.5, v.hair)
                let px = x + (i % 2 == 0 ? 5 : -5), py = headY - 18
                pen.line(x + (i % 2 == 0 ? 7 : -7), headY + 8, px, py + 6, v.coat, 4)
                pen.rect(px - 4, py - 5, 8, 12, 0x1E1E1C, radius: 1.5)
                pen.rect(px - 3, py - 4, 6, 9, 0xD3E0E6, radius: 1)
                G5Props.sparkle(pen, px + 2, py - 7, 4.5, 0xFFF6D8)
            }
        }
        if tiny {
            let foot = h - 2, s = below / 62
            let cx = w * 0.76
            let box = CGRect(x: cx - 15 * s, y: foot - 60 * s, width: 30 * s, height: 60 * s)
            pen.oval(box.minX - 2, foot - 2, box.width + 4, 4, 0x1E1E1C, 0.15)
            PalaceFigures.mini(pen.within(box, unit: s), PalaceFigures.Look.at(5), walking: false, briefcase: false)
            pen.text("!", PropFont.heavy(below * 0.42), 0xFAC775, at: CGPoint(x: cx + 14 * s + 6, y: foot - 52 * s))
        }
    }

    /// The picture inside a frame or on the banner.
    static func picture(_ g: PropPen, _ kind: String, _ s: CGSize) {
        let (w, h) = (s.width, s.height)
        switch kind {
        case "portrait":
            g.rect(0, 0, w, h, 0x2A2420)
            let r = min(w * 0.22, h * 0.2), cx = w * 0.5, cy = h * 0.42
            g.svg("M\(cx - r * 2) \(h)Q\(cx - r * 1.8) \(cy + r * 1.3) \(cx) \(cy + r * 1.2)Q\(cx + r * 1.8) \(cy + r * 1.3) \(cx + r * 2) \(h)Z", 0xC9A15B)
            g.dot(cx, cy, r, 0xF1D3B8)
            g.svg("M\(cx - r * 1.1) \(cy + r * 0.2)C\(cx - r * 1.3) \(cy - r * 1.4) \(cx + r * 1.2) \(cy - r * 1.6) \(cx + r * 0.9) \(cy - r * 0.2)L\(cx + r * 0.3) \(cy - r * 0.6)L\(cx - r * 0.7) \(cy - r * 0.2)Z", 0x2F5BD3)
            g.svg("M\(cx - r * 0.5) \(cy - r * 1.2)Q\(cx + r * 0.6) \(cy - r * 1.6) \(cx + r * 0.6) \(cy - r * 0.6)Z", 0xFAC775)
            g.svg("M\(cx - r * 1.1) \(cy)Q\(cx - r * 1.6) \(cy + r * 1.4) \(cx - r * 0.9) \(cy + r * 2)L\(cx - r * 0.8) \(cy + r * 0.4)Z", 0x2F5BD3)
            g.dot(cx + r * 0.25, cy + r * 0.05, r * 0.11, 0x2E2117)
            g.dot(cx + r * 0.7, cy + r * 0.05, r * 0.1, 0x2E2117)
            g.dot(cx - r * 0.25, cy + r * 0.75, r * 0.2, 0xFFFDF6)
            g.dot(cx + r * 0.45, cy + r * 0.55, r * 0.12, 0xC8261B)
        case "group":
            g.rect(0, 0, w, h, 0x3A2A1E)
            g.dot(w * 0.55, h * 0.45, min(w, h) * 0.32, 0xC9A15B, 0.25)
            g.svgLine("M\(w * 0.1) \(h * 0.95)L\(w * 0.8) \(h * 0.05)", 0x8C6A3A, max(1.4, w * 0.012))
            let people: [(CGFloat, CGFloat, UInt32)] = [(0.14, 0.62, 0x1E1E1C), (0.32, 0.56, 0x1E1E1C), (0.5, 0.5, 0xE2C48A), (0.68, 0.56, 0x1E1E1C), (0.86, 0.6, 0x2E2117)]
            for (fx, fy, coat) in people {
                let x = w * fx, y = h * fy, r = min(w, h) * 0.07
                g.svg("M\(x - r * 1.9) \(h)L\(x - r * 1.5) \(y + r * 1.4)Q\(x) \(y + r * 0.9) \(x + r * 1.5) \(y + r * 1.4)L\(x + r * 1.9) \(h)Z", coat)
                g.svg("M\(x - r * 1.3) \(y + r * 1.4)Q\(x) \(y + r * 2.2) \(x + r * 1.3) \(y + r * 1.4)L\(x + r) \(y + r)H\(x - r)Z", 0xEFEBE2)
                g.dot(x, y, r, 0xE0B48A)
                g.svg("M\(x - r * 1.8) \(y - r * 0.6)H\(x + r * 1.8)L\(x + r) \(y - r * 1.1)V\(y - r * 2)H\(x - r)V\(y - r * 1.1)Z", 0x1E1E1C)
            }
            g.svg("M\(w * 0.78) \(h * 0.04)L\(w * 0.95) \(h * 0.1)L\(w * 0.78) \(h * 0.18)Z", 0xA3221B)
        default:
            g.rect(0, 0, w, h * 0.62, 0xBCCDD6)
            g.oval(w * 0.08, h * 0.12, w * 0.34, h * 0.12, 0xFFFFFF, 0.8)
            g.oval(w * 0.55, h * 0.22, w * 0.3, h * 0.1, 0xFFFFFF, 0.7)
            g.rect(0, h * 0.62, w, h * 0.38, 0x7E9A4E)
            g.rect(0, h * 0.78, w, h * 0.07, 0x6FA3C7)
            let mx = w * 0.68, base = h * 0.66, mh = h * 0.34
            g.svg("M\(mx - mh * 0.18) \(base)L\(mx - mh * 0.1) \(base - mh * 0.7)H\(mx + mh * 0.1)L\(mx + mh * 0.18) \(base)Z", 0x6B4A2E)
            g.svg("M\(mx - mh * 0.12) \(base - mh * 0.7)Q\(mx) \(base - mh * 0.9) \(mx + mh * 0.12) \(base - mh * 0.7)Z", 0x4A3524)
            let hub = CGPoint(x: mx, y: base - mh * 0.72)
            for k in 0..<4 {
                let a = Double(k) * .pi / 2 + 0.5
                g.line(hub.x, hub.y, hub.x + cos(a) * mh * 0.62, hub.y + sin(a) * mh * 0.62, 0x3A2A1E, max(1, mh * 0.08))
            }
            g.dot(w * 0.22, h * 0.72, max(1.2, h * 0.025), 0xFFFDF6)
            g.dot(w * 0.3, h * 0.7, max(1.2, h * 0.025), 0x2E2117)
        }
    }

    // MARK: On a plinth

    /// Something on a stone plinth (fills its frame, standing on the bottom). `accessory` "statue"
    /// (a marble figure) or "vase" (a blue-and-white vase on a low plinth); `variant` 1 adds a small
    /// hand touching it from the side and a round sign with a crossed-out hand.
    static func statue(_ pen: PropPen, _ p: PalacePropParams) {
        let vase = p.accessory == "vase"
        let f = pen.fitted(CGSize(width: vase ? 90 : 60, height: vase ? 84 : 128))
        if vase {
            f.oval(12, 80, 50, 4, 0x1E1E1C, 0.14)
            f.rect(14, 50, 46, 32, 0xE2DED3)
            f.rect(12, 46, 50, 6, 0xEFEBE2)
            f.svg("M27 46C18 40 18 24 26 16V8H48V16C56 24 56 40 47 46Z", 0xFFFDF6)
            f.stroke(PalaceSVG.path("M27 46C18 40 18 24 26 16V8H48V16C56 24 56 40 47 46Z"), 0xB4B2A9, 0.8)
            f.rect(25, 6, 24, 4, 0x2F5BD3, radius: 1)
            f.svgLine("M23 22H51M22 40H52", 0x2F5BD3, 1.6)
            f.dot(37, 31, 5, 0x2F5BD3)
            f.svgLine("M37 26V36M32 31H42M33.5 27.5L40.5 34.5M40.5 27.5L33.5 34.5", 0xFFFDF6, 0.9)
            f.svgLine("M28 31Q30 27 32 31M42 31Q44 27 46 31", 0x2F5BD3, 1.2)
            if p.variant == 1 {
                f.svgLine("M90 30L62 30", 0xF2711C, 6)
                f.svg("M62 26Q56 25 54 28Q53 31 56 32L62 34Z", 0xE8C4A0)
                f.svgLine("M54 28.5L50.5 28.5M54.5 31L51 31.5", 0xE8C4A0, 2.2)
                f.svgLine("M48 24L46 21M47.5 33.5L45 36", 0xC8261B, 1.2)
                let c = CGPoint(x: 37, y: 66)
                f.dot(c.x, c.y, 10, 0xFFFDF6)
                f.ring(c.x, c.y, 10, 0xC8261B, 2.4)
                hand(f, c.x, c.y)
                f.line(c.x - 7, c.y + 7, c.x + 7, c.y - 7, 0xC8261B, 2.4)
            }
            return
        }
        f.oval(4, 124, 52, 4, 0x1E1E1C, 0.14)
        f.rect(8, 84, 44, 42, 0xE2DED3)
        f.rect(5, 80, 50, 6, 0xEFEBE2)
        f.rect(6, 120, 48, 6, 0xD3D1C7)
        let marble: UInt32 = 0xF4F1EA, shade: UInt32 = 0xD3D1C7
        f.svg("M24 80L22 58L19 40Q18 30 30 28Q42 30 41 40L39 58L37 80Z", marble)
        f.svg("M30 28Q36 29 38 36L36 56L32 80H37L39 58L41 40Q42 30 30 28Z", shade)
        f.svg("M22 42L14 30L12 22L16 21L20 30L26 38Z", marble)
        f.svg("M38 40L44 52L42 60L39 58L40 52L36 44Z", shade)
        f.dot(30, 20, 7, marble)
        f.svg("M23 19Q24 11 30 11Q37 11 37 19Q34 15 30 15Q26 15 23 19Z", shade)
        f.dot(30, 9.5, 3, shade)
        f.svgLine("M24 60Q30 64 36 60M23 70Q30 74 37 70", shade, 1.1)
    }

    /// A small open hand (palm and fingers) centred at (x, y).
    private static func hand(_ f: PropPen, _ x: CGFloat, _ y: CGFloat) {
        f.rect(x - 3.4, y - 1, 6.8, 6.5, 0x3E4C55, radius: 1.5)
        for (i, dx) in [-2.6, -0.9, 0.9, 2.6].enumerated() {
            f.line(x + dx, y - 1, x + dx, y - [4.5, 6, 6, 5][i], 0x3E4C55, 1.5)
        }
        f.line(x - 3.4, y + 2, x - 6, y - 1, 0x3E4C55, 1.5)
    }
}
