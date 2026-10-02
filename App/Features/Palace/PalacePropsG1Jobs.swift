import SwiftUI

/// Temp-agency things: a job interview behind glass, a résumé, years of work on a timeline, a
/// board of job cards, two trial months under a magnifier.
enum G1Jobs {
    typealias Look = PalaceFigures.Look

    // MARK: Interview

    /// A glass room (110 × 150): across a little table the interviewer holds a résumé and asks
    /// (a "?" bubble), the candidate in a tie answers (a "…" bubble).
    static func interview(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 110, height: 150))
        f.rect(0, 0, 110, 150, 0x5E6B73, radius: 2)
        f.rect(3, 3, 104, 144, 0xE4ECEE)
        seated(f, x: 26, look: Look.at(p.variant ?? 2), facingRight: true, tie: nil)
        seated(f, x: 84, look: Look.at(5), facingRight: false, tie: 0xC8261B)
        // Résumé held up by the interviewer
        f.rect(32, 70, 16, 21, 0xFFFDF6, radius: 1)
        f.rect(34, 72, 5, 6, 0xB4B2A9)
        f.svgLine("M41 73H46M41 76H45M34 81H46M34 84H44M34 87H46", 0xB4B2A9, 1)
        f.dot(31, 84, 3, Look.at(p.variant ?? 2).skin)
        // Table
        f.oval(28, 100, 54, 12, 0x8C5E38)
        f.oval(28, 98, 54, 10, 0xC9965F)
        f.svgLine("M55 108V140", 0x3E4C55, 3)
        f.svgLine("M42 140H68", 0x3E4C55, 2.4)
        f.rect(58, 92, 6, 8, 0xBCCDD6, radius: 1)
        // Bubbles
        G1Props.bubble(f, CGRect(x: 8, y: 14, width: 26, height: 20), "?", tail: CGPoint(x: 24, y: 42), font: PropFont.heavy(14))
        G1Props.bubble(f, CGRect(x: 72, y: 14, width: 30, height: 20), "…", tail: CGPoint(x: 82, y: 42), font: PropFont.heavy(14))
        f.svg("M4 146L44 3H58L18 146Z", 0xFFFFFF, 0.16)
    }

    /// A person on a chair, seen from the side, centred on `x`, seat at y 104.
    private static func seated(_ f: PropPen, x: CGFloat, look v: Look, facingRight: Bool, tie: UInt32?) {
        let s: CGFloat = facingRight ? 1 : -1
        f.svgLine("M\(x - 10 * s) 104V140M\(x + 6 * s) 104V140", 0x3E4C55, 2)
        f.rect(min(x - 12 * s, x + 8 * s), 100, 20, 5, 0x3E4C55, radius: 1)
        f.svgLine("M\(x - 12 * s) 100V70", 0x3E4C55, 2.4)
        f.svg("M\(x - 9) 102L\(x - 8) 70Q\(x - 7) 62 \(x) 62Q\(x + 7) 62 \(x + 8) 70L\(x + 9) 102Z", v.coat)
        f.svg("M\(x - 2) 62L\(x) 68L\(x + 2) 62Z", 0xFFFDF6)
        if let tie { f.svg("M\(x - 1.2) 66H\(x + 1.2)L\(x + 2) 78L\(x) 81L\(x - 2) 78Z", tie) }
        f.svgLine("M\(x) 100H\(x + 16 * s)V128", v.trousers, 6)
        f.svg("M\(x + 12 * s) 126H\(x + 22 * s)V131H\(x + 12 * s)Z", 0x2E2117)
        f.dot(x + 1 * s, 50, 9, v.skin)
        f.svg("M\(x - 8) 49C\(x - 8) 40 \(x + 8) 40 \(x + 9) 48C\(x + 4) 45 \(x - 4) 45 \(x - 8) 49Z", v.hair)
        f.dot(x + 5 * s, 50, 1.2, 0x2E2117)
        f.svgLine("M\(x + 3 * s) 55Q\(x + 5.5 * s) 56.5 \(x + 7.5 * s) 54.5", 0x8C5A3C, 1)
    }

    // MARK: Résumé

    /// A résumé page (48 × 60): a photo, a name bar, and two sections with a little briefcase and
    /// a graduation cap, each with lines.
    static func resume(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 48, height: 60))
        f.rect(4, 3, 42, 56, 0x1E1E1C, radius: 1.5, 0.15)
        f.rect(2, 1, 42, 56, 0xFFFDF6, radius: 1.5)
        let v = Look.at(p.variant ?? 5)
        f.rect(6, 5, 13, 16, 0xD3E0E6, radius: 1)
        var photo = f
        photo.ctx.clip(to: Path(CGRect(x: 6, y: 5, width: 13, height: 16)))
        photo.svg("M7 22Q7 16 12.5 16Q18 16 18 22Z", v.coat)
        photo.dot(12.5, 11.5, 3.6, v.skin)
        photo.svg("M8.8 11C8.8 8 10.6 7 12.5 7C14.6 7 16.2 8 16.2 11C15 9.6 14 9.2 12.5 9.2C11 9.2 10 9.6 8.8 11Z", v.hair)
        f.rect(22, 7, 18, 4, 0x1F3A6B, radius: 1)
        f.svgLine("M22 15H38M22 19H34", 0xB4B2A9, 1.2)
        f.rect(6, 26, 7, 5, 0x7A5230, radius: 1)
        f.svgLine("M8 26V24.5H11V26", 0x7A5230, 1)
        f.svgLine("M16 27H39M16 31H34M16 35H38", 0xB4B2A9, 1.2)
        PalaceIcon.cap.draw(f, in: CGRect(x: 5, y: 40, width: 9, height: 9), color: 0x1F3A6B, detail: 0xFFFDF6)
        f.svgLine("M16 43H38M16 47H32M16 51H37", 0xB4B2A9, 1.2)
    }

    // MARK: Timeline

    /// Years of work (92 × 56): three past jobs (a broom, a crate, a cup) along an arrow from
    /// `labels[0]` to `labels[1]`, a star at its end and the total `text` ("5 jaar").
    static func timeline(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 92, height: 56))
        let r = G1BankPosters.frame(f, 92, 56, border: 0x1F3A6B)
        let y = r.minY + 30
        f.svgLine("M\(r.minX + 6) \(y)H\(r.maxX - 12)", 0x1F3A6B, 2.6)
        f.svg("M\(r.maxX - 13) \(y - 5)L\(r.maxX - 5) \(y)L\(r.maxX - 13) \(y + 5)Z", 0x1F3A6B)
        for x in [r.minX + 12, r.minX + 32, r.minX + 52] { f.dot(x, y, 2.6, 0xF2711C) }
        // Broom, crate, cup
        f.svgLine("M\(r.minX + 10) \(y - 22)L\(r.minX + 13) \(y - 9)", 0x7A5230, 1.8)
        f.svg("M\(r.minX + 9) \(y - 10)H\(r.minX + 18)L\(r.minX + 19) \(y - 5)H\(r.minX + 8)Z", 0xE0A93A)
        f.rect(r.minX + 26, y - 17, 13, 10, 0x2F5BD3, radius: 1)
        f.svgLine("M\(r.minX + 27) \(y - 13)H\(r.minX + 38)", 0x21468B, 1)
        f.svg("M\(r.minX + 47) \(y - 16)H\(r.minX + 56)V\(y - 10)Q\(r.minX + 56) \(y - 7) \(r.minX + 53) \(y - 7)H\(r.minX + 50)Q\(r.minX + 47) \(y - 7) \(r.minX + 47) \(y - 10)Z", 0xFFFDF6)
        f.stroke(PalaceSVG.path("M\(r.minX + 47) \(y - 16)H\(r.minX + 56)V\(y - 10)Q\(r.minX + 56) \(y - 7) \(r.minX + 53) \(y - 7)H\(r.minX + 50)Q\(r.minX + 47) \(y - 7) \(r.minX + 47) \(y - 10)Z"), 0x5E6B73, 1)
        f.svgLine("M\(r.minX + 56) \(y - 14)Q\(r.minX + 60) \(y - 13) \(r.minX + 56) \(y - 10)", 0x5E6B73, 1)
        f.svg(PalacePeople.star(cx: r.maxX - 12, cy: y - 14, r: 7), 0xFAC775)
        let labels = p.labels ?? ["2019", "2024"]
        if labels.count > 1 {
            f.text(labels[0], PropFont.demi(7.5), 0x5F5E5A, at: CGPoint(x: r.minX + 12, y: y + 8))
            f.text(labels[1], PropFont.demi(7.5), 0x5F5E5A, at: CGPoint(x: r.maxX - 16, y: y + 8))
        }
        f.text(p.text ?? "5 jaar", PropFont.heavy(10), 0x1F3A6B, at: CGPoint(x: r.midX, y: r.maxY - 6), maxWidth: 50)
    }

    // MARK: Job board

    /// A cork board (84 × 70) with three job cards: a red band (`caption`, "Gezocht"), a picture
    /// (a van, a broom, a crate) and lines.
    static func jobBoard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 70))
        f.rect(1.5, 2.5, 84, 68, 0x1E1E1C, radius: 2, 0.14)
        f.rect(0, 0, 84, 68, 0x7A5230, radius: 2)
        f.rect(3, 3, 78, 62, 0xC9965F)
        for (i, (x, y, a)) in [(5.0, 6.0, -0.04), (31.0, 9.0, 0.03), (57.0, 5.0, -0.02)].enumerated() {
            var c = f
            c.ctx.translateBy(x: x + 11, y: y + 27)
            c.ctx.rotate(by: .radians(a))
            c.rect(-11, -26, 22, 52, 0xFFFDF6, radius: 1)
            c.rect(-11, -26, 22, 9, 0xC8261B, radius: 1)
            c.text(p.caption ?? "Gezocht", PropFont.heavy(5.6), 0xFFFDF6, at: CGPoint(x: 0, y: -21.5), maxWidth: 20)
            switch i {
            case 0: G1Post.van(c, x: -10, y: -13, colour: 0x2F5BD3)
            case 1:
                c.svgLine("M-3 -14L0 -2", 0x7A5230, 1.4)
                c.svg("M-4 -3H4L5 2H-5Z", 0xE0A93A)
            default:
                c.rect(-6, -11, 12, 9, 0x2F5BD3, radius: 1)
            }
            c.svgLine("M-8 8H8M-8 13H6M-8 18H7", 0xB4B2A9, 1.2)
            c.dot(0, -27, 1.8, 0x2F5BD3)
        }
    }

    // MARK: Trial months

    /// Two month pages (58 × 68) marked 1 and 2 in orange, a magnifier looking at them, and a
    /// tick and a cross under them: will it work out?
    static func trialMonths(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 58, height: 68))
        for (i, x) in [3.0, 29].enumerated() {
            f.rect(x + 1, 6, 25, 32, 0x1E1E1C, radius: 1.5, 0.14)
            f.rect(x, 4, 25, 32, 0xFFFDF6, radius: 1.5)
            f.rect(x, 4, 25, 7, 0xF2711C, radius: 1.5)
            f.text(["1", "2"][i], PropFont.heavy(15), 0xF2711C, at: CGPoint(x: x + 12.5, y: 25))
            f.rect(x + 5, 1.5, 2, 5, 0x2E2117, radius: 1)
            f.rect(x + 18, 1.5, 2, 5, 0x2E2117, radius: 1)
        }
        f.ring(37, 32, 11, 0x3E4C55, 3)
        f.dot(37, 32, 9.5, 0xBCCDD6, 0.45)
        f.svgLine("M45 40L54 50", 0x3E4C55, 4.4)
        G1Props.tick(f, 14, 58, 6.5)
        f.dot(32, 58, 6.5, 0xC8261B)
        G1Props.cross(f, 32, 58, 2.6, 0xFFFDF6, width: 1.8)
        f.text("?", PropFont.heavy(11), 0x1E1E1C, at: CGPoint(x: 49, y: 59))
    }
}
