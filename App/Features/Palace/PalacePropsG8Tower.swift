import SwiftUI

/// Things at the railing of the lookout tower: coin binoculars with the view they show, an old
/// photo of the city, a progress board, an opinion board, and a signpost pointing ahead.
enum G8Tower {
    // MARK: Binoculars

    /// Coin binoculars on a post (58 × 122) and, over them, the two round windows of what you
    /// see through them: roofs, a tower and the sun.
    static func binoculars(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 58, height: 122))
        for cx in [17.0, 41] {
            f.dot(cx, 20, 16, 0x1E1E1C)
            f.dot(cx, 20, 14, 0xBCCDD6)
        }
        var view = f
        view.ctx.clip(to: Path(ellipseIn: CGRect(x: 3, y: 6, width: 28, height: 28)).union(Path(ellipseIn: CGRect(x: 27, y: 6, width: 28, height: 28))))
        view.dot(44, 14, 5, 0xFAC775)
        view.rect(0, 26, 58, 10, 0x8FB6CF)
        for (x, h, c) in [(4.0, 10.0, 0x9A5238), (12, 13, 0xE3D6BC), (20, 9, 0x3F5A4A), (34, 12, 0xC9A15B), (42, 8, 0x7B3F2E), (48, 11, 0x5E6B73)] as [(CGFloat, CGFloat, UInt32)] {
            view.rect(x, 27 - h, 7, h, c)
        }
        view.svg("M28 27V12L29.5 6L31 12V27Z", 0xC9A15B)
        f.svgLine("M29 38V44", 0x5E6B73, 2)
        G8Props.shadow(f, 16, 117, 26, 4)
        f.rect(26, 74, 6, 44, 0x3E4C55)
        f.rect(20, 116, 18, 4, 0x2E2117, radius: 1)
        f.rect(14, 52, 30, 22, 0x2F5BD3, radius: 6)
        f.rect(10, 50, 12, 14, 0x21468B, radius: 3)
        f.rect(36, 50, 12, 14, 0x21468B, radius: 3)
        f.rect(8, 52, 4, 10, 0x1E1E1C, radius: 1.5)
        f.rect(46, 52, 4, 10, 0x1E1E1C, radius: 1.5)
        f.rect(24, 64, 10, 6, 0xC9A15B, radius: 1)
        f.rect(27, 65.5, 4, 1.2, 0x2E2117)
    }

    // MARK: Old photo

    /// An old photo on a stand (72 × 100): canal houses and a horse and cart in brown sepia,
    /// a white border, the year (`text`) under it.
    static func oldPhoto(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 72, height: 100))
        G8Props.shadow(f, 22, 95, 28, 4)
        f.rect(33, 70, 6, 28, 0x5E6B73)
        f.rect(2, 4, 70, 72, 0x1E1E1C, radius: 1, 0.18)
        f.rect(0, 2, 70, 72, 0xFFFDF6, radius: 1)
        let photo = CGRect(x: 5, y: 7, width: 60, height: 48)
        f.rect(photo, 0xD9C29A)
        for (x, w, h) in [(7.0, 12.0, 30.0), (19, 10, 36), (29, 14, 28), (43, 10, 34), (53, 12, 30)] as [(CGFloat, CGFloat, CGFloat)] {
            f.rect(x, 48 - h, w, h, 0x9A7A52)
            f.svg("M\(x) \(48 - h)L\(x + w / 2) \(42 - h)L\(x + w) \(48 - h)Z", 0x7A5A3A)
            f.rect(x + 3, 52 - h, 2.4, 3, 0x5A3E28)
            f.rect(x + w - 5, 52 - h, 2.4, 3, 0x5A3E28)
        }
        f.rect(5, 48, 60, 7, 0xB89A6E)
        f.svg("M14 50H26V46H22L20 44H16L14 46Z", 0x5A3E28)
        f.svgLine("M16 50V54M24 50V54M27 47L32 44", 0x5A3E28, 1.2)
        f.ring(38, 51, 3.4, 0x5A3E28, 1.2)
        f.rect(29, 46, 10, 3, 0x5A3E28)
        f.rect(photo, 0x6B4A2E, 0.12)
        f.text(p.text ?? "1900", PropFont.heavy(11), 0x5A3E28, at: CGPoint(x: 35, y: 64.5), maxWidth: 60)
    }

    // MARK: Progress

    /// A board on a post (84 × 104): a progress bar filled `count` percent (default 85) from one
    /// level to the next (`labels`, e.g. A2 → B1), steps of stars rising over it.
    static func progressBoard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 104))
        let labels = p.labels ?? ["A2", "B1"]
        let fill = CGFloat(max(5, min(p.count ?? 85, 100))) / 100
        G8Props.shadow(f, 28, 99, 28, 4)
        f.rect(39, 62, 6, 40, 0x5E6B73)
        f.rect(0, 0, 84, 66, 0x0F6E56, radius: 4)
        f.rect(3, 3, 78, 60, 0xFFFDF6, radius: 3)
        for k in 0..<3 {
            let x = 14 + CGFloat(k) * 22, y = 30 - CGFloat(k) * 8
            G8Props.star(f, x, y, 5 + CGFloat(k) * 1.4, 0xF2B33D)
        }
        G8Props.arrow(f, CGPoint(x: 10, y: 36), CGPoint(x: 72, y: 12), 0x0F6E56, 2.2, head: 7)
        let bar = CGRect(x: 8, y: 42, width: 68, height: 10)
        f.rect(bar, 0xD3D1C7, radius: 5)
        f.rect(bar.minX, bar.minY, bar.width * fill, bar.height, 0x1E7A4C, radius: 5)
        f.text(labels.first ?? "", PropFont.heavy(7.5), 0x1E1E1C, at: CGPoint(x: 13, y: 58))
        f.text(labels.count > 1 ? labels[1] : "", PropFont.heavy(7.5), 0x1E1E1C, at: CGPoint(x: 71, y: 58))
    }

    // MARK: Opinions

    /// A board on two legs (96 × 108) asking `text` ("Wat vind jij?") with three speech bubbles
    /// pinned under it: a thumb up, a thumb down and a heart.
    static func opinionBoard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 108))
        G8Props.shadow(f, 10, 103, 76, 4)
        f.rect(16, 74, 4, 32, 0x6B4A2E)
        f.rect(76, 74, 4, 32, 0x6B4A2E)
        f.rect(0, 0, 96, 78, 0x8C5E38, radius: 3)
        f.rect(4, 4, 88, 70, 0xE8DCC2, radius: 2)
        f.text(p.text ?? "", PropFont.heavy(11), 0x1E1E1C, at: CGPoint(x: 48, y: 14), maxWidth: 82)
        let bubbles: [(CGRect, UInt32, Bool)] = [(CGRect(x: 8, y: 26, width: 36, height: 22), 0xFFFDF6, false),
                                                 (CGRect(x: 52, y: 28, width: 36, height: 22), 0xFFFDF6, true),
                                                 (CGRect(x: 28, y: 50, width: 36, height: 20), 0xFFFDF6, false)]
        for (i, (r, c, right)) in bubbles.enumerated() {
            f.rect(r, c, radius: 6)
            let tx = right ? r.maxX - 10 : r.minX + 8
            f.svg("M\(tx) \(r.maxY - 1)L\(tx + (right ? 6 : -2)) \(r.maxY + 5)L\(tx + (right ? 2 : 6)) \(r.maxY - 1)Z", c)
            f.dot(r.midX, r.minY - 1, 1.6, 0xC8261B)
            let c0 = CGPoint(x: r.midX, y: r.midY)
            switch i {
            case 0: thumb(f, c0, up: true)
            case 1: thumb(f, c0, up: false)
            default: PalaceIcon.heart.draw(f, in: CGRect(x: c0.x - 7, y: c0.y - 7, width: 14, height: 14), color: 0xC8261B, detail: 0xFFFDF6)
            }
        }
    }

    /// A thumb up (green) or down (red), centred on `c`.
    static func thumb(_ f: PropPen, _ c: CGPoint, up: Bool) {
        let g = up ? f : G8Props.turned(f, c, 180)
        let o = up ? c : .zero
        let colour: UInt32 = up ? 0x1E7A4C : 0xC8261B
        g.rect(o.x - 6, o.y - 1, 4, 8, colour, radius: 1)
        g.svg("M\(o.x - 1.5) \(o.y - 1)L\(o.x + 1) \(o.y - 7)Q\(o.x + 3.5) \(o.y - 8) \(o.x + 3.5) \(o.y - 5)L\(o.x + 3) \(o.y - 2)H\(o.x + 6)Q\(o.x + 8) \(o.y - 2) \(o.x + 7.5) \(o.y)L\(o.x + 6.5) \(o.y + 6)Q\(o.x + 6) \(o.y + 7) \(o.x + 4.5) \(o.y + 7)H\(o.x - 1.5)Z", colour)
    }

    // MARK: Signpost

    /// A wooden signpost (56 × 132): a big arrow board pointing ahead (right) with `text` (a year
    /// to come), and a sun rising on a little board under it.
    static func signpost(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 56, height: 132))
        let board = PalaceSVG.path("M0 14H42L56 30L42 46H0Z")
        G8Props.shadow(f, 4, 127, 30, 4)
        f.rect(14, 6, 6, 124, 0x7A5230)
        f.fill(board, 0xC9965F)
        f.stroke(board, 0x7A5230, 1.4)
        f.text(p.text ?? "2040", PropFont.heavy(13), 0x2E2117, at: CGPoint(x: 24, y: 30.5), maxWidth: 40)
        f.rect(0, 54, 34, 22, 0xFFFDF6, radius: 2)
        f.stroke(Path(roundedRect: CGRect(x: 0, y: 54, width: 34, height: 22), cornerRadius: 2), 0x7A5230, 1.2)
        f.svg("M9 70A8 8 0 0 1 25 70Z", 0xF2B33D)
        for k in 0..<5 {
            let a = Double.pi + Double(k + 1) * .pi / 6
            f.line(17 + cos(a) * 10, 70 + sin(a) * 10, 17 + cos(a) * 13, 70 + sin(a) * 13, 0xF2B33D, 1.6)
        }
        f.rect(4, 70, 26, 1.6, 0x7A5230)
    }
}
