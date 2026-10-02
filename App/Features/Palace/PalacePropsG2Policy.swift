import SwiftUI

/// More insurer props: the small print under a magnifying glass, a handshake over a signed paper,
/// an extra piece fitted onto a basic cover, and a dog owner who has to pay for a broken vase.
enum G2PolicyProps {
    // MARK: Small print

    /// A pinned sheet (90 × 80): a bold heading, a few lines, then a block of tiny print with a
    /// star; a magnifying glass makes the tiny print big: `lines` (two short lines) in the lens.
    static func smallPrint(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 90, height: 80))
        f.rect(5.5, 4, 76, 76, 0x1E1E1C, radius: 1.5, 0.15)
        f.rect(4, 2, 76, 76, 0xFFFDF6, radius: 1.5)
        f.dot(42, 4, 3, 0xC8261B)
        f.rect(10, 9, 44, 6, 0x1E1E1C, radius: 1)
        for k in 0..<3 { f.line(10, 21 + CGFloat(k) * 5, k == 2 ? 50 : 72, 21 + CGFloat(k) * 5, 0xB4B2A9, 1.6) }
        f.text("*", PropFont.heavy(10), 0xC8261B, at: CGPoint(x: 11, y: 40))
        var y: CGFloat = 38
        while y < 74 {
            f.line(15, y, y > 70 ? 44 : 74, y, 0xB4B2A9, 0.7)
            y += 2.4
        }
        // The magnifying glass
        f.svgLine("M64 62L82 78", 0x2E2117, 5)
        f.dot(52, 50, 19, 0x2E2117)
        f.dot(52, 50, 16.5, 0xFFFFFF)
        let lens = f.within(CGRect(x: 35.5, y: 33.5, width: 33, height: 33))
        var l = lens
        l.ctx.clip(to: Path(ellipseIn: CGRect(x: 0, y: 0, width: 33, height: 33)))
        let lines = p.lines ?? []
        if lines.isEmpty {
            l.line(3, 12, 30, 12, 0x5F5E5A, 2.2)
            l.line(3, 19, 26, 19, 0x5F5E5A, 2.2)
        }
        for (i, line) in lines.prefix(2).enumerated() {
            l.text(line, PropFont.heavy(7.5), i == 0 ? 0xC8261B : 0x1E1E1C, at: CGPoint(x: 16.5, y: 12 + CGFloat(i) * 9), maxWidth: 30)
        }
        f.svg("M41 40Q44 36 49 35", 0xFFFFFF, 0.8)
    }

    // MARK: Handshake

    /// Two hands shaking over a paper (80 × 84) with the first of `icons` and two signatures, and
    /// a green tick: the deal is done. `tone` the right-hand sleeve.
    static func handshake(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 80, height: 84))
        let tone = PropColor.named(p.tone, 0x0F6E56)
        let paper = CGRect(x: 12, y: 44, width: 56, height: 38)
        f.rect(paper.offsetBy(dx: 1.5, dy: 2), 0x1E1E1C, radius: 1, 0.15)
        f.rect(paper, 0xFFFDF6, radius: 1)
        if let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first {
            icon.draw(f, in: CGRect(x: paper.minX + 4, y: paper.minY + 4, width: 13, height: 13), color: tone, detail: 0xFFFDF6)
        }
        f.svgLine("M33 50H62M33 55H56M16 63H62", 0xD3D1C7, 1.3)
        f.svgLine("M16 76C19 70 21 78 24 73C26 70 27 76 34 74", 0x2F5BD3, 1.3)
        f.svgLine("M44 76C47 70 49 78 52 73C54 70 55 76 63 74", 0xC8261B, 1.3)
        // Sleeves and the clasp: two hands of different skin, the left thumb over the top.
        f.svg("M0 12L20 20L18 38L0 36Z", 0x3C3489)
        f.svg("M80 12L60 20L62 38L80 36Z", tone)
        f.rect(17, 21, 28, 16, 0xE8C4A0, radius: 7)
        f.rect(36, 20, 28, 18, 0x8C5A3C, radius: 8)
        f.svgLine("M38 24Q31 25 28 30M38 29Q32 30 29 34", 0x6B4426, 1.3)
        f.svg("M24 23Q30 15 40 19Q42 21 39 23Q32 21 28 26Z", 0xE8C4A0)
        f.svgLine("M28 25Q32 20 39 21", 0xC9A07E, 1)
        f.dot(68, 8, 8, 0x1E7A4C)
        f.svgLine("M64 8.5L67 11.5L72.5 5", 0xFFFFFF, 2.2)
    }

    // MARK: Add-on

    /// A basic cover drawn as a shield (84 × 86) with `text` on it and a notch; an extra piece in
    /// `tone` with a plus and the first of `icons` drops into the notch.
    static func addOn(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 86))
        let tone = PropColor.named(p.tone, 0x1E7A4C)
        f.svg("M8 30H40V48H66V56Q66 74 37 86Q8 74 8 56Z", 0x8C9499)
        f.svg("M12 34H36V52H62V56Q62 71 37 82Q12 71 12 56Z", 0xA9B3B8)
        var notch = Path(CGRect(x: 40, y: 30, width: 26, height: 18))
        notch = notch.strokedPath(StrokeStyle(lineWidth: 1.4, dash: [3, 2.5]))
        f.fill(notch, 0x5F5E5A)
        if let text = p.text {
            f.text(text, PropFont.heavy(11), 0xFFFDF6, at: CGPoint(x: 36, y: 64), maxWidth: 46)
        }
        PalaceIcon.g2Umbrella.draw(f, in: CGRect(x: 16, y: 37, width: 16, height: 16), color: 0xFFFDF6, detail: 0xA9B3B8)
        // The extra piece, on its way down
        var e = f
        e.ctx.translateBy(x: 58, y: 14)
        e.ctx.rotate(by: .degrees(-8))
        e.rect(-16, -12, 34, 26, 0x1E1E1C, radius: 3, 0.15)
        e.rect(-17, -13, 34, 26, tone, radius: 3)
        e.svgLine("M-13 0H-4M-8.5 -4.5V4.5", 0xFFFDF6, 2.6)
        if let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first {
            icon.draw(e, in: CGRect(x: -1, y: -10, width: 15, height: 18), color: 0xFFFDF6, detail: tone)
        }
        f.svgLine("M52 30V34M60 30V34", tone, 1.4)
    }

    // MARK: Liable

    /// A dog owner (110 × 112) holding the lead of a dog that knocked over a vase; a hand points at
    /// the owner, with `text` in a red bubble ("jij betaalt!"). `variant` the owner's look.
    static func liable(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 110, height: 112))
        let v = PalaceFigures.Look.at(p.variant ?? 0)
        let owner = f.within(CGRect(x: 0, y: 12, width: 56, height: 100)).fitted(CGSize(width: 64, height: 114))
        G2People.body(owner, v)
        G2People.head(owner, v, cx: 22, cy: 19, mood: "none")
        owner.svgLine("M25 27Q28 25 31 27", 0x8C5A3C, 1.2)
        owner.svg("M10 12Q8 16 10 18Q12 16 10 12Z", 0x5DCAA5)
        owner.svgLine("M31 42C36 50 38 56 38 62", v.coat, 6)
        owner.dot(38, 64, 3.2, v.skin)
        // The lead and the dog
        f.svgLine("M33 68Q44 82 56 80", 0xC8261B, 1.4)
        f.oval(50, 86, 34, 14, 0x9A6A42)
        f.svgLine("M54 98V108M60 99V109M74 99V109M80 98V108", 0x7A5230, 3)
        f.dot(54, 82, 8, 0x9A6A42)
        f.svg("M48 78Q44 88 50 90Z", 0x6B4A2E)
        f.oval(44, 82, 7, 5, 0x9A6A42)
        f.dot(45, 83, 1.6, 0x1E1E1C)
        f.dot(52, 80, 1.2, 0x1E1E1C)
        f.svgLine("M83 88Q90 82 88 76", 0x9A6A42, 2.6)
        f.rect(50, 86, 8, 2.6, 0xC8261B, radius: 1)
        // The broken vase, water and a flower on the floor
        f.oval(84, 104, 24, 5, 0x5E8C9A, 0.6)
        f.svg("M88 106L92 96L97 99L94 107Z M98 107L101 98L106 101L104 108Z", 0x2F5BD3)
        f.svg("M95 92L99 90L100 95Z", 0x2F5BD3)
        f.svgLine("M100 104Q104 98 108 97", 0x5E8C45, 1.4)
        f.dot(108, 96, 2.6, 0xF2711C)
        // The pointing hand and its bubble
        f.svg("M110 26V40L94 38Q90 37 90 33Q90 29 94 28Z", 0x1F3A6B)
        f.svg("M93 28Q86 26 84 30Q83 34 87 36L93 38Z", 0xC99A74)
        f.svgLine("M85 31L70 34", 0xC99A74, 3.2)
        guard let text = p.text else { return }
        let font = PropFont.heavy(9.5)
        let w = min(64, f.width(of: text, font) + 10)
        f.rect(108 - w, 2, w, 16, 0xC8261B, radius: 5)
        f.svg("M98 17L96 23L92 17Z", 0xC8261B)
        f.text(text, font, 0xFFFFFF, at: CGPoint(x: 108 - w / 2, y: 10), maxWidth: w - 6)
    }
}
