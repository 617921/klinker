import SwiftUI

/// Two people doing something together (110 × 120 unless noted), in the build of
/// `PalaceFigures.person`: carrying one house, one on crutches handing a paper to the other, or two
/// seated people talking. `variant` picks the first person's look; the second one is three further.
enum G2Pairs {
    typealias Look = PalaceFigures.Look

    /// A pen for the right-hand person: mirrored so they face left.
    static func mirrored(_ f: PropPen, width: CGFloat) -> PropPen {
        var g = f
        g.ctx.translateBy(x: width, y: 0)
        g.ctx.scaleBy(x: -1, y: 1)
        return g
    }

    // MARK: Together

    /// Two people face each other and hold one little house up between them.
    static func together(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 110, height: 120))
        let looks = [Look.at(p.variant ?? 0), Look.at((p.variant ?? 0) + 3)]
        for (i, look) in looks.enumerated() {
            let side = i == 0 ? f : mirrored(f, width: 110)
            let me = side.within(CGRect(x: 0, y: 26, width: 56, height: 94)).fitted(CGSize(width: 64, height: 114))
            G2People.body(me, look)
            G2People.head(me, look, cx: 22, cy: 19)
            me.svgLine("M30 42C34 32 36 24 37 15", look.coat, 6)
            me.dot(37.5, 12.5, 3.4, look.skin)
        }
        // The house they carry
        f.svg("M30 18L55 0L80 18Z", 0x9A5238)
        f.rect(34, 17, 42, 21, 0xE9DFC9)
        f.rect(51, 25, 8, 13, 0x1F3A6B)
        f.rect(39, 22, 7, 7, 0xBCCDD6)
        f.rect(64, 22, 7, 7, 0xBCCDD6)
    }

    // MARK: Proxy

    /// Someone on crutches with a leg in plaster hands a paper (`text`, two lines: "namens Anna")
    /// to someone else, who holds a pen ready to sign in their place.
    static func proxy(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 110, height: 120))
        let looks = [Look.at(p.variant ?? 0), Look.at((p.variant ?? 0) + 3)]
        let left = f.within(CGRect(x: 0, y: 14, width: 60, height: 106)).fitted(CGSize(width: 64, height: 114))
        left.svgLine("M10 46L4 108", 0x8C9499, 2.6)
        left.svgLine("M6 46H14", 0x8C9499, 2.6)
        G2People.body(left, looks[0])
        left.svgLine("M27 82V100", 0xFFFDF6, 8)
        left.svgLine("M27 82V100", 0xD3D1C7, 1)
        G2People.head(left, looks[0], cx: 22, cy: 19, mood: "none")
        left.svgLine("M25 26Q28 24 31 26", 0x8C5A3C, 1.1)
        left.svgLine("M31 42C38 46 46 48 52 46", looks[0].coat, 6)
        left.dot(53, 45.5, 3.2, looks[0].skin)
        let right = mirrored(f, width: 110).within(CGRect(x: 0, y: 14, width: 60, height: 106)).fitted(CGSize(width: 64, height: 114))
        G2People.body(right, looks[1])
        G2People.head(right, looks[1], cx: 22, cy: 19)
        right.svgLine("M31 42C36 40 40 36 42 30", looks[1].coat, 6)
        right.dot(42.5, 28, 3.2, looks[1].skin)
        right.svgLine("M42 30L47 18", 0x1E1E1C, 2.2)
        // The paper between them
        let paper = CGRect(x: 40, y: 30, width: 30, height: 38)
        f.rect(paper.offsetBy(dx: 1, dy: 1.5), 0x1E1E1C, radius: 1, 0.15)
        f.rect(paper, 0xFFFDF6, radius: 1)
        let parts = (p.text ?? "").split(separator: " ", maxSplits: 1).map(String.init)
        for (i, part) in parts.enumerated() {
            f.text(part, i == 0 ? PropFont.demi(7) : PropFont.heavy(8), 0x1F3A6B,
                   at: CGPoint(x: paper.midX, y: paper.minY + 7 + CGFloat(i) * 9), maxWidth: paper.width - 3)
        }
        f.svgLine("M44 58C46 53 48 60 50 56C52 53 53 59 58 57", 0x2F5BD3, 1.2)
        f.line(43, 62, 66, 62, 0x5F5E5A, 0.8)
        f.svgLine("M28 24Q55 6 82 22", 0xF2711C, 1.8)
        f.svgLine("M76 16L83 22L75 26", 0xF2711C, 1.8)
    }

    // MARK: Talk

    /// Two people on chairs facing each other (120 × 100). `accessory` "mic": the left one holds a
    /// microphone out to the right one, with a question bubble; "coffee": a little table with two cups
    /// between them and a speech bubble from each side.
    static func talk(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 120, height: 100))
        let looks = [Look.at(p.variant ?? 0), Look.at((p.variant ?? 0) + 3)]
        let mic = p.accessory == "mic"
        f.oval(4, 94, 112, 6, 0x1E1E1C, 0.2)
        for (i, look) in looks.enumerated() {
            let side = (i == 0 ? f : mirrored(f, width: 120)).within(CGRect(x: 0, y: 4, width: 56, height: 96))
            seated(side, look)
            if i == 0 && mic {
                side.svgLine("M28 36C36 40 42 40 47 35", look.coat, 5)
                side.dot(48, 34.5, 2.8, look.skin)
                side.svgLine("M49 33L55 27", 0x1E1E1C, 2.2)
                side.dot(56, 26, 2.8, 0x3E4C55)
            } else {
                side.svgLine("M28 36C34 44 38 50 41 54", look.coat, 5)
                side.dot(42, 55, 2.8, look.skin)
            }
        }
        if !mic {
            f.svgLine("M60 70V94M52 94H68", 0x5E6B73, 2.2)
            f.oval(46, 66, 28, 7, 0xC9965F)
            for x in [52.0, 63] as [CGFloat] {
                f.rect(x, 58, 6, 8, 0xFFFDF6, radius: 1.2)
                f.svgLine("M\(x + 6) 60.5H\(x + 8)V63.5H\(x + 6)", 0xFFFDF6, 1)
            }
        }
        bubble(f, x: 36, text: mic ? "?" : "…", tailLeft: true)
        bubble(f, x: 64, text: "…", tailLeft: false)
    }

    /// A small speech bubble (20 × 14) at the top, its tail towards one side.
    private static func bubble(_ f: PropPen, x: CGFloat, text: String, tailLeft: Bool) {
        f.rect(x, 0, 20, 14, 0xFFFDF6, radius: 5)
        f.svg(tailLeft ? "M\(x + 4) 13L\(x) 19L\(x + 10) 13Z" : "M\(x + 16) 13L\(x + 20) 19L\(x + 10) 13Z", 0xFFFDF6)
        f.text(text, PropFont.heavy(text == "?" ? 11 : 10), text == "?" ? 0xC8261B : 0x5F5E5A, at: CGPoint(x: x + 10, y: 6.5))
    }

    /// A person on a chair facing right, in a 56 × 96 box (no front arm).
    private static func seated(_ f: PropPen, _ v: Look) {
        f.rect(4, 30, 6, 36, 0x3E4C55, radius: 2)
        f.svgLine("M8 66V94M36 66V94", 0x3E4C55, 2.2)
        f.rect(4, 60, 36, 6, 0x5E6B73, radius: 2)
        f.svg("M10 62V38C10 30 15 27 21 27C27 27 32 30 32 38V62Z", v.coat)
        f.svgLine("M18 62H42", v.trousers, 8)
        f.svgLine("M42 62L44 88", v.trousers, 7)
        f.rect(40, 86, 12, 5, 0x2E2117, radius: 1.5)
        G2People.head(f, v, cx: 21, cy: 16, r: 10)
    }
}
