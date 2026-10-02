import SwiftUI

/// The audience: one person whose face and hands show a feeling, and rows of seats full of heads.
enum G5People {
    typealias Look = PalaceFigures.Look

    // MARK: One person with a feeling

    /// A person showing a feeling. `accessory` the mood: "scared" (wide eyes, hair on end, popcorn
    /// flying), "crying" (a tissue to the eye, tears, a heart), "bliss" (eyes closed, smiling, a hand
    /// on the heart, notes), "pray" (eyes closed, hands folded, a book on the lap), "cheer" (both arms
    /// up), "down" (a frown, thumb down, a grey cloud), "admire" (hands clasped, hearts and sparkles),
    /// "clap" (hands clapping; `count` people side by side). `mount` "seat" (red theatre seat),
    /// "pew", "stand", or "box" (seated in a theatre box, cut off at the chest by the box's rail).
    /// `text` a speech bubble (never mirrored), `variant` the look, `flip` faces left.
    static func fan(_ pen: PropPen, _ p: PalacePropParams) {
        let mood = p.accessory ?? "bliss"
        let standingMoods: Set = ["cheer", "down", "admire", "clap"]
        let mount = p.mount ?? (standingMoods.contains(mood) ? "stand" : "seat")
        if mood == "clap" { return clappers(pen, p) }
        let standing = mount == "stand", box = mount == "box"
        let body = CGSize(width: 64, height: standing ? 114 : 100)
        let shown: CGFloat = box ? 64 : body.height
        let design = CGSize(width: body.width + 26, height: shown + 22)
        let base = pen.fitted(design, hanging: box)
        let f = base.mirrored(p.flip == true)
        let v = Look.at(p.variant ?? 0)
        var fig = f.within(CGRect(x: 0, y: 22, width: body.width, height: body.height))
        if box { fig.ctx.clip(to: Path(CGRect(x: -30, y: -40, width: 140, height: shown + 40))) }
        let head = standing ? CGPoint(x: 22, y: 19) : CGPoint(x: 23, y: 26)
        let sh = standing ? CGPoint(x: 31, y: 42) : CGPoint(x: 28, y: 46)
        let back = standing ? CGPoint(x: 13, y: 42) : CGPoint(x: 15, y: 46)
        let hair: UInt32? = mood == "pray" ? 0xD3D1C7 : nil
        if standing { G5Body.standing(fig, v) } else { G5Body.seated(fig, v, seat: box ? "none" : (mount == "pew" ? "pew" : "plush")) }
        let sleeve = v.coat, dark = PalaceInk.shade(v.coat, 0.8)
        let (hx, hy, sx, sy) = (head.x, head.y, sh.x, sh.y)
        switch mood {
        case "scared":
            fig.svgLine("M\(hx - 7) \(hy - 10)L\(hx - 10) \(hy - 16)M\(hx) \(hy - 12)V\(hy - 19)M\(hx + 7) \(hy - 10)L\(hx + 10) \(hy - 16)", v.hair, 2.2)
            G5Body.head(fig, v, hx, hy, face: .scared)
            G5Body.tear(fig, hx + 11, hy - 6, 1.8)
            fig.svg("M\(sx + 8) \(sy + 6)H\(sx + 22)L\(sx + 20) \(sy + 22)H\(sx + 10)Z", 0xFFFDF6)
            fig.svgLine("M\(sx + 11) \(sy + 6)L\(sx + 12.5) \(sy + 22)M\(sx + 15) \(sy + 6)V\(sy + 22)M\(sx + 19) \(sy + 6)L\(sx + 17.5) \(sy + 22)", 0xC8261B, 1.6)
            G5Body.arm(fig, "M\(sx) \(sy)C\(sx + 4) \(sy + 8) \(sx + 8) \(sy + 12) \(sx + 11) \(sy + 13)", hand: CGPoint(x: sx + 11, y: sy + 13), sleeve: sleeve, skin: v.skin)
            for (dx, dy) in [(12.0, -2.0), (20, -10), (26, 0), (16, -20), (28, -18), (8, -12)] as [(CGFloat, CGFloat)] {
                fig.dot(sx + dx, sy + dy, 2.6, 0xFFF6D8)
                fig.dot(sx + dx + 0.8, sy + dy - 0.6, 1.2, 0xF6D27A)
            }
            fig.svgLine("M\(sx + 30) \(sy - 6)L\(sx + 34) \(sy - 10)M\(sx + 31) \(sy + 2)L\(sx + 36) \(sy + 1)", 0x5E6B73, 1.2)
        case "crying":
            G5Body.head(fig, v, hx, hy, face: .cry)
            G5Body.arm(fig, "M\(sx) \(sy)C\(sx + 9) \(sy + 2) \(sx + 10) \(sy - 12) \(sx + 6) \(sy - 18)", hand: CGPoint(x: sx + 6, y: sy - 18.5), sleeve: sleeve, skin: v.skin)
            fig.svg("M\(sx + 2) \(sy - 22)Q\(sx + 6) \(sy - 27) \(sx + 10) \(sy - 22)Q\(sx + 13) \(sy - 18) \(sx + 9) \(sy - 15)Q\(sx + 5) \(sy - 13) \(sx + 3) \(sy - 17)Z", 0xFFFDF6)
            G5Body.tear(fig, hx + 14, hy + 2, 2)
            G5Body.tear(fig, hx + 17, hy + 9, 1.6)
            G5Props.heart(fig, hx + 22, hy - 16, 4.5, 0xE0607A)
        case "bliss":
            G5Body.head(fig, v, hx, hy, face: .bliss)
            G5Body.arm(fig, "M\(sx) \(sy)C\(sx + 4) \(sy + 6) \(sx + 1) \(sy + 10) \(sx - 4) \(sy + 9)", hand: CGPoint(x: sx - 4.5, y: sy + 9), sleeve: sleeve, skin: v.skin)
            G5Props.note(fig, hx + 20, hy - 6, 0xC9A15B)
            G5Props.note(fig, hx + 29, hy - 16, 0xC9A15B, scale: 0.8)
            G5Props.heart(fig, hx + 30, hy + 2, 3.4, 0xE0607A)
        case "pray":
            G5Body.head(fig, v, hx, hy, face: .shut, hair: hair)
            fig.rect(sx + 6, sy + 16, 15, 6, 0x2E2117, radius: 1)
            fig.rect(sx + 6, sy + 16, 15, 1.6, 0xC9A15B)
            G5Body.arm(fig, "M\(sx) \(sy)C\(sx + 6) \(sy + 2) \(sx + 9) \(sy - 2) \(sx + 9) \(sy - 8)", hand: CGPoint(x: sx + 9, y: sy - 9), sleeve: sleeve, skin: v.skin)
            fig.svg("M\(sx + 7) \(sy - 6)L\(sx + 8.6) \(sy - 18)Q\(sx + 9.6) \(sy - 20) \(sx + 10.6) \(sy - 18)L\(sx + 12) \(sy - 6)Z", v.skin)
            fig.svgLine("M\(sx + 9.6) \(sy - 17)V\(sy - 7)", PalaceInk.shade(v.skin, 0.8), 0.8)
        case "cheer":
            G5Body.arm(fig, "M\(back.x) \(back.y)C\(back.x - 7) \(back.y - 8) \(back.x - 9) \(back.y - 16) \(back.x - 9) \(back.y - 26)", hand: CGPoint(x: back.x - 9, y: back.y - 28), sleeve: dark, skin: v.skin)
            G5Body.head(fig, v, hx, hy, face: .laugh)
            G5Body.arm(fig, "M\(sx) \(sy)C\(sx + 7) \(sy - 8) \(sx + 10) \(sy - 16) \(sx + 10) \(sy - 26)", hand: CGPoint(x: sx + 10, y: sy - 28), sleeve: sleeve, skin: v.skin)
            for (dx, dy, c) in [(-16.0, -30.0, 0xFAC775), (18, -36, 0xF2711C), (26, -18, 0x5DCAA5), (-6, -40, 0x2F5BD3)] as [(CGFloat, CGFloat, UInt32)] {
                G5Props.sparkle(fig, hx + dx, hy + dy, 3, c)
            }
        case "down":
            G5Body.arm(fig, "M\(back.x) \(back.y)C\(back.x - 3) \(back.y + 10) \(back.x - 3) \(back.y + 20) \(back.x - 1) \(back.y + 28)", hand: CGPoint(x: back.x - 0.5, y: back.y + 30), sleeve: dark, skin: v.skin)
            G5Body.head(fig, v, hx, hy + 2, face: .sad)
            G5Body.arm(fig, "M\(sx) \(sy)C\(sx + 6) \(sy + 6) \(sx + 9) \(sy + 10) \(sx + 10) \(sy + 14)", hand: CGPoint(x: sx + 10, y: sy + 15), sleeve: sleeve, skin: v.skin)
            fig.rect(sx + 8.6, sy + 16, 3, 6, v.skin, radius: 1.5)
            fig.svg("M\(hx - 12) \(hy - 20)Q\(hx - 12) \(hy - 28) \(hx - 4) \(hy - 28)Q\(hx) \(hy - 34) \(hx + 7) \(hy - 29)Q\(hx + 14) \(hy - 29) \(hx + 13) \(hy - 21)Z", 0x8A8A82)
            fig.svgLine("M\(hx - 6) \(hy - 17)L\(hx - 8) \(hy - 13)M\(hx + 1) \(hy - 17)L\(hx - 1) \(hy - 13)M\(hx + 8) \(hy - 17)L\(hx + 6) \(hy - 13)", 0x6FA3C7, 1.2)
        default:
            G5Body.arm(fig, "M\(back.x) \(back.y)C\(back.x + 3) \(back.y + 8) \(back.x + 9) \(back.y + 12) \(back.x + 15) \(back.y + 11)", hand: CGPoint(x: back.x + 15, y: back.y + 11), sleeve: dark, skin: v.skin)
            G5Body.head(fig, v, hx, hy, face: .smile)
            G5Body.arm(fig, "M\(sx) \(sy)C\(sx + 4) \(sy + 6) \(sx + 2) \(sy + 10) \(sx - 2) \(sy + 11)", hand: CGPoint(x: sx - 2, y: sy + 11), sleeve: sleeve, skin: v.skin)
            G5Props.heart(fig, hx + 20, hy - 10, 4, 0xE0607A)
            G5Props.heart(fig, hx + 30, hy - 20, 3, 0xE0607A)
            G5Props.sparkle(fig, hx + 32, hy - 4, 3.5)
            G5Props.sparkle(fig, hx + 18, hy - 24, 2.6)
        }
        if let text = p.text {
            let w = min(design.width - 4, max(34, base.width(of: text, PropFont.demi(8.5)) + 12))
            let x: CGFloat = p.flip == true ? 2 : design.width - w - 2
            G5Props.bubble(base, CGRect(x: x, y: 1, width: w, height: 15), text, tail: CGPoint(x: p.flip == true ? x + w - 10 : x + 10, y: 22), size: 8.5)
        }
    }

    /// `count` people side by side clapping, motion marks around their hands, `text` above.
    private static func clappers(_ pen: PropPen, _ p: PalacePropParams) {
        let n = max(1, min(p.count ?? 2, 3))
        let design = CGSize(width: 46 + CGFloat(n) * 26, height: 132)
        let f = pen.fitted(design)
        for i in (0..<n).reversed() {
            let v = Look.at((p.variant ?? 0) + i * 3)
            let fig = f.within(CGRect(x: CGFloat(i) * 26, y: CGFloat(18 - (i % 2) * 4), width: 64, height: 114))
            G5Body.standing(fig, v)
            G5Body.arm(fig, "M13 42C16 50 24 52 32 48", hand: CGPoint(x: 33, y: 47), sleeve: PalaceInk.shade(v.coat, 0.8), skin: v.skin)
            G5Body.head(fig, v, 22, 19, face: .laugh)
            G5Body.arm(fig, "M31 42C35 46 37 46 37 44", hand: CGPoint(x: 36.5, y: 43), sleeve: v.coat, skin: v.skin)
            fig.svgLine("M41 36L45 32M43 42L48 41M40 49L44 52", 0xC8261B, 1.3)
        }
        if let text = p.text {
            f.text(text, PropFont.heavy(11), 0xC8261B, at: CGPoint(x: design.width / 2 + 6, y: 7), maxWidth: design.width - 4)
        }
    }

    // MARK: Rows of seats

    /// Rows of seats seen from behind (fills its frame): `count` rows, heads in most seats,
    /// `tone` seat colour, and one `highlight` row (0 = back) lit up with a number plate `text`.
    static func seats(_ pen: PropPen, _ p: PalacePropParams) {
        let (w, h) = (pen.size.width, pen.size.height)
        let rows = max(1, min(p.count ?? 3, 4))
        let seat = PropColor.named(p.tone, 0x9E2A20)
        let rowH = h / CGFloat(rows)
        let pitch: CGFloat = 23
        for r in 0..<rows {
            let top = CGFloat(r) * rowH
            let backTop = top + rowH * 0.42
            let lit = r == p.highlight
            let offset: CGFloat = r % 2 == 0 ? 2 : 13
            if lit {
                pen.rect(0, backTop - 14, w, rowH * 0.6 + 14, 0xFAC775, radius: 4, 0.45)
                pen.stroke(Path(roundedRect: CGRect(x: 1, y: backTop - 14, width: w - 2, height: rowH * 0.6 + 14), cornerRadius: 4), 0xFAC775, 1.6)
            }
            var x = offset
            var i = r * 5
            while x < w - 8 {
                let gap = abs(x + 10 - w / 2) < 14
                if !gap {
                    let v = Look.at(i * 3 + r)
                    if (i * 7 + r) % 6 != 2 {
                        pen.dot(x + 10, backTop - 2, 8, v.hair)
                        pen.dot(x + 2.4, backTop + 1, 2, v.skin)
                        pen.dot(x + 17.6, backTop + 1, 2, v.skin)
                    }
                    pen.rect(x, backTop, 20, rowH * 0.6, lit ? PalaceInk.shade(seat, 1.25) : seat, radius: 5)
                    pen.rect(x + 2, backTop + 2, 16, 2.4, PalaceInk.shade(seat, 1.35), radius: 1.2)
                }
                x += pitch
                i += 1
            }
            if lit, let text = p.text {
                pen.dot(12, backTop + rowH * 0.25, 9, 0xFAC775)
                pen.ring(12, backTop + rowH * 0.25, 9, 0x2E2117, 1.4)
                pen.text(text, PropFont.heavy(11), 0x2E2117, at: CGPoint(x: 12, y: backTop + rowH * 0.25 + 0.5))
            }
        }
    }
}
