import SwiftUI

/// Street and platform props: road works with a digger, a printed timetable on a post, a ticket
/// machine for topping up a card, a card reader showing an amount, and a person in uniform.
enum PalaceStreetProps {
    // MARK: Road works

    /// Road works (96 × 88): a small digger behind a striped barrier with a lamp, a heap of sand
    /// and a traffic cone.
    static func roadworks(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 88))
        f.oval(0, 80, 96, 8, 0x1E1E1C, 0.15)
        f.svg("M0 82Q16 52 40 82Z", 0xC9965F)
        f.svg("M8 82Q18 66 30 82Z", 0xB07F4E)
        f.rect(44, 52, 42, 12, 0x1E1E1C, radius: 6)
        for x in [50.0, 58, 66, 74, 80] as [CGFloat] { f.dot(x, 58, 2.6, 0x5E6B73) }
        f.rect(48, 30, 30, 22, 0xFAC775, radius: 2)
        f.rect(52, 22, 16, 16, 0xFAC775, radius: 2)
        f.rect(55, 25, 10, 9, 0x3E4C55, radius: 1)
        f.svgLine("M74 36L86 14L94 30", 0xE0A93A, 5)
        f.svg("M89 28H96L95 38H88Z", 0x3E4C55)
        f.rect(4, 56, 4, 26, 0x5E6B73)
        f.rect(80, 56, 4, 26, 0x5E6B73)
        let board = CGRect(x: 2, y: 58, width: 84, height: 13)
        f.rect(board, 0xFFFDF6)
        var stripes = f
        stripes.ctx.clip(to: Path(board))
        for k in 0..<9 {
            let x = board.minX - 10 + CGFloat(k) * 12
            stripes.svg("M\(x) 71L\(x + 10) 58H\(x + 16)L\(x + 6) 71Z", 0xC8261B)
        }
        f.stroke(Path(board), 0x3E4C55, 1)
        f.dot(44, 52, 6.5, 0xFAC775, 0.35)
        f.dot(44, 52, 3.8, 0xF2711C)
        f.rect(42.5, 55, 3, 4, 0x3E4C55)
        f.svg("M84 86L89 62H93L98 86Z", 0xF2711C)
        f.svg("M86.6 74H95.4L96.4 79H85.6Z", 0xFFFDF6)
    }

    // MARK: Timetable

    /// A printed timetable on a post (64 × 106): a header with a tram and the line `caption`,
    /// then rows of `lines` "7|05 20 35 50" (hour, minutes).
    static func timetable(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 64, height: 106))
        f.oval(18, 101, 28, 5, 0x1E1E1C, 0.15)
        f.rect(30, 50, 4, 54, 0x5E6B73)
        f.rect(1, 0, 62, 60, 0x1F3A6B, radius: 2.5)
        f.rect(4, 3, 56, 54, 0xFFFDF6, radius: 1)
        f.rect(4, 3, 56, 12, 0xFAC775)
        PalaceIcon.tram.draw(f, in: CGRect(x: 8, y: 4, width: 10, height: 10), color: 0x1F3A6B, detail: 0xFAC775)
        if let line = p.caption {
            f.text(line, PropFont.heavy(10), 0x1F3A6B, at: CGPoint(x: 24, y: 9.5), anchor: .leading, maxWidth: 32)
        }
        let rows = Array((p.lines ?? []).prefix(5))
        guard !rows.isEmpty else { return }
        let top: CGFloat = 17, rowH = min(9, 38 / CGFloat(rows.count))
        f.rect(4, top, 12, rowH * CGFloat(rows.count), 0xE2DED3)
        for (i, row) in rows.enumerated() {
            let y = top + CGFloat(i) * rowH + rowH / 2
            let cells = row.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
            if i > 0 { f.line(4, y - rowH / 2, 60, y - rowH / 2, 0xD3D1C7, 0.8, round: false) }
            f.text(cells[0], PropFont.heavy(7.5), 0x1E1E1C, at: CGPoint(x: 10, y: y))
            if cells.count > 1 {
                f.text(cells[1], PropFont.mono(7.5), 0x1E1E1C, at: CGPoint(x: 19, y: y), anchor: .leading, maxWidth: 39)
            }
        }
    }

    // MARK: Ticket machine

    /// A blue ticket machine (62 × 108): its screen shows a card with an arrow up and `text`
    /// ("+ € 20"), a card in the slot, and a hand pressing one of the two amount buttons.
    static func ticketMachine(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 62, height: 108))
        f.oval(4, 102, 54, 6, 0x1E1E1C, 0.15)
        f.rect(4, 0, 50, 104, 0x2F5BD3, radius: 4)
        f.rect(4, 0, 6, 104, 0x21468B, radius: 3)
        f.rect(9, 7, 40, 34, 0x232B3B, radius: 2)
        PalaceIcon.pass.draw(f, in: CGRect(x: 12, y: 8, width: 18, height: 18), color: 0xF4F1EA, detail: 0x232B3B)
        f.svgLine("M38 22V11M33.5 15L38 10.5L42.5 15", 0x5DCAA5, 2.4)
        f.text(p.text ?? "+ € 20", PropFont.heavy(10.5), 0x5DCAA5, at: CGPoint(x: 29, y: 33), maxWidth: 36)
        f.rect(15, 46, 28, 8, 0x1E1E1C, radius: 2)
        f.rect(20, 40, 18, 9, 0xFFFDF6, radius: 1)
        f.rect(20, 40, 18, 2.4, 0xC8261B)
        for (i, x) in [10.0, 31].enumerated() {
            f.rect(x, 60, 17, 13, i == 1 ? 0xFAC775 : 0xF4F1EA, radius: 2)
            f.text(i == 0 ? "10" : "20", PropFont.heavy(8), 0x1E1E1C, at: CGPoint(x: x + 8.5, y: 66.8))
        }
        f.rect(16, 82, 26, 12, 0x1E1E1C, radius: 2)
        f.rect(19, 85, 20, 6, 0x3E4C55, radius: 1)
        f.svg("M62 74L52 70L49 76L60 82Z", 0x993556)
        f.svg("M51 70.5C47 68.5 43 68 41 69.5L39.5 69C38 68.6 37.4 70.2 38.6 71L42 73C42.6 75.5 46 77 50 76Z", 0xC99A74)
    }

    // MARK: Card reader

    /// A card reader on a pole (48 × 96) whose screen shows a card and `text` ("€ 2,40").
    static func cardReader(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 48, height: 96))
        f.oval(10, 90, 28, 6, 0x1E1E1C, 0.16)
        f.rect(20, 50, 8, 42, 0x5E6B73)
        f.rect(20, 50, 2.4, 42, 0x7D8A92)
        f.rect(14, 90, 20, 4, 0x3E4C55, radius: 1)
        f.rect(2, 2, 44, 52, 0x5E6B73, radius: 8)
        f.rect(4, 4, 40, 48, 0xF4F1EA, radius: 6.5)
        f.rect(8, 9, 32, 30, 0x232B3B, radius: 2)
        PalaceIcon.pass.draw(f, in: CGRect(x: 17, y: 9, width: 14, height: 14), color: 0xF4F1EA, detail: 0x232B3B)
        f.text(p.text ?? "€ 2,40", PropFont.heavy(10), 0xFAC775, at: CGPoint(x: 24, y: 31), maxWidth: 30)
        f.rect(12, 43, 24, 4, 0x1E7A4C, radius: 2)
    }

    // MARK: Uniform

    /// A person in uniform (64 × 114): peaked cap with a badge, dark jacket with gold buttons and a
    /// ticket printer on a strap, a ticket in hand. `variant` 0 navy, 1 dark green, 2 grey.
    static func uniform(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 64, height: 114))
        let coats: [UInt32] = [0x1F3A6B, 0x2F4B3A, 0x3E4C55]
        let coat = coats[((p.variant ?? 0) % coats.count + coats.count) % coats.count]
        let skin: UInt32 = 0xC99A74, dark = PalaceInk.shade(coat, 0.75)
        f.oval(6, 106, 52, 6, 0x1E1E1C, 0.16)
        f.svgLine("M17 84V104M27 84V104", 0x1E1E1C, 5)
        f.svg("M12 103H21V108H12Z M23 103H32V108H23Z", 0x1E1E1C)
        f.svg("M9 88L10.5 44C11.5 36 15.5 32 22 32C28.5 32 32.5 36 33.5 44L35 88Z", coat)
        f.svg("M17 32L22 40L27 32Z", 0xFFFDF6)
        f.svgLine("M22 34V40", 0xC8261B, 2)
        f.svgLine("M22 41V86", dark, 1.2)
        for y in [50.0, 60, 70] as [CGFloat] { f.dot(24.5, y, 1.5, 0xE0A93A) }
        f.svgLine("M15 34L33 66", 0x2E2117, 2.2)
        f.rect(26, 62, 14, 14, 0x5E6B73, radius: 2)
        f.rect(28, 64, 10, 4, 0x232B3B, radius: 1)
        f.svgLine("M13 42C10 52 10 62 12 70", dark, 6)
        f.dot(12.5, 72, 3.1, skin)
        f.svgLine("M31 42C37 48 42 52 46 54", coat, 6)
        f.dot(47, 54.5, 3.2, skin)
        f.rect(46, 44, 12, 8, 0xFFFDF6, radius: 1)
        f.svgLine("M48.5 47H55.5M48.5 49.5H53", 0xB4B2A9, 0.9)
        f.dot(22, 19, 11, skin)
        f.svg("M11 19C10.5 15 12 13 14 12H32C34 13 35 15 34 19C31 15.5 27 14.5 22 14.5C17 14.5 13 15.5 11 19Z", 0x2E2117)
        f.svg("M10 12C10 5 15 2 22 2C29 2 34 5 34 12Z", coat)
        f.svg("M9 11H38Q39 14 35 14H9Z", 0x1E1E1C)
        f.dot(22, 7.5, 2.4, 0xE0A93A)
        f.dot(28, 19.5, 1.3, 0x2E2117)
    }
}
