import SwiftUI

/// Hotel guests and a laptop: a guest leaving with a suitcase under the exit sign, a guest holding
/// up a phone with a mail that says "yes" (a big green tick), and a laptop where dates and a bed
/// are chosen and the button clicked.
enum G4HotelGuests {
    typealias Look = PalaceFigures.Look

    /// A hotel guest (see `PalacePropKind.g4Guest`).
    static func guest(_ pen: PropPen, _ p: PalacePropParams) {
        let v = Look.at(p.variant ?? 2)
        if p.accessory == "phone" {
            phone(pen.fitted(CGSize(width: 90, height: 166)), v, p)
        } else {
            leaving(pen.fitted(CGSize(width: 84, height: 166)), v, p)
        }
    }

    /// Walking right with a suitcase in tow under a green exit sign; a clock shows `time`.
    private static func leaving(_ f: PropPen, _ v: Look, _ p: PalacePropParams) {
        f.rect(10, 4, 50, 24, 0x1E7A4C, radius: 3)
        PalaceIcon.walk.draw(f, in: CGRect(x: 14, y: 6, width: 20, height: 20), color: 0xFFFDF6, detail: 0x1E7A4C)
        PalaceIcon.arrow.draw(f, in: CGRect(x: 34, y: 6, width: 22, height: 20), color: 0xFFFDF6, detail: 0x1E7A4C)
        let c = CGPoint(x: 72, y: 16)
        f.dot(c.x, c.y, 10.5, 0x2E2117)
        f.dot(c.x, c.y, 8.5, 0xFFFDF6)
        let (h, m) = PalaceFigures.parse(p.time ?? "11:00")
        let ha = (Double(h % 12) + Double(m) / 60) * 30 * .pi / 180, ma = Double(m) * 6 * .pi / 180
        f.line(c.x, c.y, c.x + sin(ha) * 4.8, c.y - cos(ha) * 4.8, 0x1E1E1C, 1.8)
        f.line(c.x, c.y, c.x + sin(ma) * 7, c.y - cos(ma) * 7, 0x1E1E1C, 1.3)
        let g = f.within(CGRect(x: 16, y: 46, width: 64, height: 114))
        // The suitcase, pulled along behind
        g.svgLine("M14 72L-2 84", 0x3E4C55, 2)
        g.rect(-16, 82, 22, 26, 0xC8261B, radius: 3)
        g.svgLine("M-10 86V104M0 86V104", 0xA81E15, 1.2)
        g.dot(-12, 109, 2.2, 0x1E1E1C)
        g.dot(2, 109, 2.2, 0x1E1E1C)
        PalaceParkPeople.walker(g, x: 0, v, hair: v.hair, hat: false)
        G4Draw.smile(g, 24, 19)
        g.svgLine("M33 42C38 52 44 54 50 52", v.coat, 6)
        g.dot(51, 52, 3.2, v.skin)
        g.rect(50, 46, 11, 7, 0xFFFDF6, radius: 1)
        g.rect(50, 48, 11, 1.6, 0x1F3A6B)
        f.svgLine("M0 120H8M2 130H10", 0xB4B2A9, 1.6)
    }

    /// Standing by a suitcase, holding up a phone; a bubble shows the mail with a big green tick.
    private static func phone(_ f: PropPen, _ v: Look, _ p: PalacePropParams) {
        let g = f.within(CGRect(x: 4, y: 52, width: 64, height: 114))
        g.rect(40, 80, 22, 26, 0x2F5BD3, radius: 3)
        g.svgLine("M45 80V74H57V80", 0x1F3A6B, 2)
        G4Draw.adult(g, v)
        G4Draw.smile(g, 22, 19)
        g.svgLine("M31 42C38 40 40 30 38 22", v.coat, 6)
        g.dot(38, 20, 3.2, v.skin)
        g.rect(35, 6, 9, 15, 0x1E1E1C, radius: 2)
        g.rect(36.5, 8, 6, 10, 0x5DCAA5, radius: 1)
        // The bubble: a mail with a big tick
        let b = CGRect(x: 6, y: 0, width: 80, height: 50)
        f.rect(b.offsetBy(dx: 1, dy: 2), 0x1E1E1C, radius: 6, 0.14)
        f.rect(b, 0xFFFDF6, radius: 6)
        f.stroke(Path(roundedRect: b, cornerRadius: 6), 0x5E6B73, 1)
        f.svg("M40 50L44 58L50 50Z", 0xFFFDF6)
        f.rect(b.minX, b.minY, b.width, 12, 0x1F3A6B, radius: 6)
        f.rect(b.minX, b.minY + 6, b.width, 6, 0x1F3A6B)
        f.rect(12, 3, 9, 6.5, 0xFFFDF6, radius: 1)
        f.svgLine("M12.5 3.6L16.5 7L20.5 3.6", 0x1F3A6B, 0.9)
        f.dot(28, 31, 11, 0x1E7A4C)
        f.svgLine("M22 31L26.5 35.5L34 26", 0xFFFDF6, 3)
        for (k, line) in (p.lines ?? []).prefix(2).enumerated() {
            f.text(line, PropFont.demi(8), 0x1E1E1C, at: CGPoint(x: 44, y: 25 + CGFloat(k) * 12), anchor: .leading, maxWidth: 40)
        }
    }

    // MARK: Laptop

    /// A laptop on a desk (56 × 46): a bed, a little calendar with two days chosen, and a pointer
    /// clicking the green button.
    static func laptop(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 56, height: 46))
        f.svg("M0 40H56L52 45H4Z", 0x9A9890)
        f.rect(6, 2, 44, 38, 0x2E2117, radius: 3)
        f.rect(9, 5, 38, 31, 0xFFFDF6, radius: 1)
        f.rect(9, 5, 38, 5, 0x1F3A6B, radius: 1)
        PalaceIcon.g4Bed.draw(f, in: CGRect(x: 10, y: 12, width: 12, height: 12), color: 0x1F3A6B, detail: 0xFFFDF6)
        for r in 0..<3 {
            for c in 0..<4 {
                let chosen = r == 1 && (c == 1 || c == 2)
                f.rect(24 + CGFloat(c) * 5.6, 12 + CGFloat(r) * 5, 4.4, 3.8, chosen ? 0xF2711C : 0xD3D1C7, radius: 0.6)
            }
        }
        f.rect(28, 28, 17, 6, 0x1E7A4C, radius: 2)
        f.svgLine("M33.5 31L35.5 33L39.5 29", 0xFFFDF6, 1.2)
        f.svg("M40 30L40 41L43 38.5L45.5 43L47.5 42L45 37.5L49 37.5Z", 0x1E1E1C)
        f.svgLine("M40 30L40 41L43 38.5L45.5 43L47.5 42L45 37.5L49 37.5Z", 0xFFFDF6, 0.7)
    }
}
