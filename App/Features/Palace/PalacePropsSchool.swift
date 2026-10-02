import SwiftUI

/// School props: a parents' evening at a little table under a dark window, a report booklet, a test
/// sheet with an hourglass, a framed certificate and a timetable of subjects.
enum PalaceSchoolProps {
    typealias Look = PalaceFigures.Look

    // MARK: Parents' evening

    /// A meeting (104 × 156): a window (`mount` "night": dark with a moon and lit houses), a low
    /// table with a lamp and coffee, the teacher on a chair and `count` parents (1–2) on tiny chairs.
    static func meeting(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 104, height: 156))
        let night = p.mount != "day"
        // Window
        f.rect(12, 0, 80, 64, 0xEFEBE2)
        f.rect(16, 4, 72, 56, night ? 0x232B3B : 0xBCCDD6)
        if night {
            f.svg("M16 60V46L23 40L30 46V60Z M32 60V50H44V60Z M58 60V44L66 37L74 44V60Z M76 60V48H88V60Z", 0x1E1E1C, 0.6)
            for (x, y) in [(21.0, 50.0), (37.0, 54.0), (63.0, 49.0), (80.0, 53.0)] { f.rect(x, y, 3, 3, 0xFAC775) }
            f.dot(70, 17, 8, 0xFAC775)
            f.dot(74.5, 13.5, 7, 0x232B3B)
            for (x, y) in [(26.0, 13.0), (42.0, 24.0), (56.0, 9.0), (30.0, 33.0), (84.0, 32.0)] { f.dot(x, y, 1.1, 0xFAC775) }
        }
        f.svgLine("M52 4V60M16 32H88", 0xEFEBE2, 2.5)
        f.rect(8, 62, 88, 5, 0xEFEBE2)
        // A lamp over a low children's table with coffee
        f.svg("M70 88L50 120H90Z", 0xFAC775, 0.25)
        f.svgLine("M70 67V81", 0x3E4C55, 1.2)
        f.svg("M62 88L70 80L78 88Z", 0xF2711C)
        f.rect(52, 120, 34, 4, 0xC9965F, radius: 1)
        f.svgLine("M55 124V150M83 124V150", 0x5E6B73, 2.2)
        f.rect(56, 112, 6, 8, 0xFFFDF6, radius: 1)
        f.rect(56, 112, 6, 2, 0x6B4A2E)
        f.rect(66, 117, 10, 3, 0xFFFDF6)
        // Teacher on a grown-up chair, facing the parents
        let t = Look.at(1)
        f.rect(98, 96, 5, 40, 0x3E4C55, radius: 2)
        f.svgLine("M86 133V152M96 133V152", 0x2E2117, 2)
        f.svg("M82 128H100V133H82Z", 0x2B4C86)
        f.svg("M80 128L81 106C82 100 85 98 90 98C95 98 98 100 99 106L100 128Z", t.coat)
        f.svg("M72 125H92V131H72Z", t.trousers)
        f.svgLine("M73 129V150", t.trousers, 5)
        f.svg("M66 148H75V152H66Z", 0x2E2117)
        f.svgLine("M84 106C80 112 76 116 71 118", PalaceInk.shade(t.coat, 0.85), 5)
        f.dot(70, 118.5, 2.8, t.skin)
        f.dot(90, 88, 8.5, t.skin)
        f.svg("M81.5 87C81 80 85 77.5 90 77.5C95 77.5 99 80 98.5 87C97 83 94 82 90 82C86 82 83.5 83 81.5 87Z", t.hair)
        f.svg("M97 82C101 84 102 90 99 94C98 90 97.5 86 97 82Z", t.hair)
        f.dot(86, 88.5, 1.1, 0x2E2117)
        f.svgLine("M84 93Q86 94.5 88 93", 0x8C5A3C, 1)
        // Parents on tiny chairs, knees up against the table
        let n = max(1, min(p.count ?? 2, 2))
        if n == 2 { parent(f, x: 26, look: Look.at(3)) }
        parent(f, x: 0, look: Look.at(0))
    }

    /// A grown-up on a tiny chair (40 × 52, head above), knees up, hands on the knees.
    private static func parent(_ f: PropPen, x: CGFloat, look: Look) {
        let g = f.within(CGRect(x: x, y: 104, width: 40, height: 52))
        g.rect(2, 24, 3.5, 12, 0xFAC775, radius: 1)
        g.rect(2, 34, 17, 3, 0xFAC775, radius: 1)
        g.svgLine("M4 37V48M17 37V48", 0x5E6B73, 1.6)
        g.svg("M6 36L7 12C8 6 11 4 15 4C19 4 22 6 23 12L24 36Z", look.coat)
        g.svgLine("M14 33L30 22L32 46", look.trousers, 6)
        g.svg("M28 44H37V48H28Z", 0x2E2117)
        g.svgLine("M18 12C22 18 26 20 29 20", PalaceInk.shade(look.coat, 0.85), 5)
        g.dot(30, 20, 2.8, look.skin)
        g.dot(15, -5, 8.5, look.skin)
        g.svg("M6.5 -6C6 -13 10 -15.5 15 -15.5C20 -15.5 24 -13 23.5 -6C22 -10 19 -11 15 -11C11 -11 8.5 -10 6.5 -6Z", look.hair)
        g.dot(19.5, -4.5, 1.1, 0x2E2117)
        g.svgLine("M18 0.5Q20 2 22 0.5", 0x8C5A3C, 1)
    }

    // MARK: School desk

    /// A pupil's desk under a drawing that is `size` wide, returning the pen to draw on its top.
    private static func onDesk(_ pen: PropPen, _ p: PalacePropParams, _ size: CGSize) -> PropPen {
        guard p.mount == "desk" else { return pen.fitted(size) }
        let total = CGSize(width: size.width, height: size.height + 30)
        let f = pen.fitted(total)
        f.oval(4, total.height - 5, size.width - 8, 5, 0x1E1E1C, 0.14)
        f.svgLine("M10 \(size.height + 2)V\(total.height - 2)M\(size.width - 10) \(size.height + 2)V\(total.height - 2)", 0x5E6B73, 2.6)
        f.rect(0, size.height - 4, size.width, 6, 0xC9965F, radius: 1.5)
        f.rect(0, size.height + 2, size.width, 2, 0x9A6A42)
        return f
    }

    // MARK: Report booklet

    /// An open report booklet (80 × 56): the school and `caption` on the left page, grades
    /// "subject|grade" (`lines`) on the right and a star sticker. `tone` cover, `mount` "desk".
    static func reportCard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = onDesk(pen, p, CGSize(width: 80, height: 56))
        let tone = PropColor.named(p.tone, 0x1F3A6B)
        f.rect(2, 4, 76, 50, PalaceInk.shade(tone, 0.8), radius: 2)
        f.rect(5, 6, 35, 45, 0xFFFDF6)
        f.rect(40, 6, 35, 45, 0xFFFDF6)
        f.line(40, 6, 40, 51, 0xD3D1C7, 1.2)
        PalaceIcon.school.draw(f, in: CGRect(x: 14, y: 10, width: 16, height: 16), color: tone, detail: 0xFFFDF6)
        if let caption = p.caption {
            f.text(caption, PropFont.heavy(7), tone, at: CGPoint(x: 22.5, y: 32), maxWidth: 30)
        }
        f.svgLine("M10 39H35M10 44H30", 0xD3D1C7, 1.4)
        for (i, row) in (p.lines ?? []).prefix(4).enumerated() {
            let cells = row.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
            let y = 13 + CGFloat(i) * 9.5
            f.text(cells.first ?? "", PropFont.demi(6.5), 0x5E6B73, at: CGPoint(x: 43, y: y), anchor: .leading, maxWidth: 20)
            if cells.count > 1 {
                f.text(cells[1], PropFont.heavy(9), 0x2F5BD3, at: CGPoint(x: 70, y: y), maxWidth: 10)
            }
            f.line(43, y + 4.5, 73, y + 4.5, 0xE2DED3, 0.8)
        }
        PalaceCarePeople.star(f, 33, 45, 5.5)
    }

    // MARK: Test sheet

    /// A test sheet (84 × 60): a title bar, numbered questions `lines` with empty answer boxes, a
    /// pencil and (`accessory` "timer") an hourglass. `mount` "desk".
    static func testPaper(_ pen: PropPen, _ p: PalacePropParams) {
        let f = onDesk(pen, p, CGSize(width: 84, height: 60))
        f.rect(6, 3, 52, 55, 0x1E1E1C, radius: 1, 0.14)
        f.rect(4, 1, 52, 55, 0xFFFDF6, radius: 1)
        f.rect(8, 5, 30, 4, 0x1E1E1C, radius: 1)
        f.svgLine("M42 7H52", 0xD3D1C7, 1.4)
        for (i, q) in (p.lines ?? []).prefix(4).enumerated() {
            let y = 16 + CGFloat(i) * 10
            f.text(q, PropFont.mono(7), 0x1E1E1C, at: CGPoint(x: 8, y: y), anchor: .leading, maxWidth: 34)
            f.stroke(Path(CGRect(x: 44, y: y - 3.5, width: 8, height: 7)), 0x5E6B73, 0.9)
        }
        f.line(30, 50, 52, 36, 0xFAC775, 3.4)
        f.line(30, 50, 32.5, 48.4, 0xE8C4A0, 3.4)
        f.line(29, 50.8, 30.2, 50, 0x1E1E1C, 1.6)
        f.line(50, 37.3, 52, 36, 0xC8261B, 3.4)
        if p.accessory == "timer" {
            f.rect(62, 10, 18, 3, 0x7A5230, radius: 1)
            f.rect(62, 49, 18, 3, 0x7A5230, radius: 1)
            let glass = PalaceSVG.path("M64 13H78C78 22 72 27 71 31C72 35 78 40 78 49H64C64 40 70 35 71 31C70 27 64 22 64 13Z")
            f.fill(glass, 0xEFEBE2)
            f.stroke(glass, 0xB4B2A9, 1)
            f.svg("M67 19H75C74 23 72 25 71 27C70 25 68 23 67 19Z", 0xD9A440)
            f.svg("M65.5 47C66.5 42 69 41 71 40C73 41 75.5 42 76.5 47Z", 0xD9A440)
            f.svgLine("M71 29V39", 0xD9A440, 1)
        }
    }

    // MARK: Certificate

    /// A framed certificate on a nail (92 × 72): `caption` at the top, a big `text` ("NT2 · B1"),
    /// a name line, a signature and a red seal with ribbons.
    static func certificate(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 92, height: 72))
        f.svgLine("M46 1L22 10M46 1L70 10", 0x2E2117, 1)
        f.dot(46, 1.5, 1.8, 0x3E4C55)
        f.rect(6, 10, 84, 62, 0x1E1E1C, radius: 2, 0.14)
        f.rect(4, 8, 84, 62, 0xC9A15B, radius: 2)
        f.rect(8, 12, 76, 54, 0x9A6A42, radius: 1)
        f.rect(10, 14, 72, 50, 0xFFFDF6)
        f.stroke(Path(CGRect(x: 13, y: 17, width: 66, height: 44)), 0xC9A15B, 0.8)
        if let caption = p.caption {
            f.text(caption, PropFont.demi(6.5), 0x5E6B73, at: CGPoint(x: 46, y: 23), maxWidth: 58)
        }
        if let text = p.text {
            f.text(text, PropFont.heavy(12), 0x1F3A6B, at: CGPoint(x: 46, y: 35), maxWidth: 60)
        }
        f.svgLine("M18 48H50", 0xB4B2A9, 1.2)
        f.svgLine("M19 56C22 51 24 58 27 54C29 51 30 57 33 55", 0x2F5BD3, 1.1)
        f.svg("M62 54L58 66L62 63.5L64 67Z M68 54L72 66L68 63.5L66 67Z", 0xC8261B)
        f.dot(65, 51, 7.5, 0xC8261B)
        f.ring(65, 51, 5, 0xFAC775, 1)
        PalaceCarePeople.star(f, 65, 51, 3)
    }

    // MARK: Timetable

    /// A timetable (140 × 92): day `labels` on top, subject `icons` in the cells (row by row), the
    /// `highlight` cell circled with a heart. `mount` "board" draws it in chalk on a blackboard.
    static func timetable(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 140, height: 92))
        let board = p.mount == "board"
        let ink: UInt32 = board ? 0xF4F1EA : 0x1F3A6B
        f.rect(2, 2, 138, 84, 0x1E1E1C, radius: 3, 0.14)
        f.rect(0, 0, 138, 84, board ? 0x7A5230 : 0x1F3A6B, radius: 3)
        let r = CGRect(x: 4, y: 4, width: 130, height: 76)
        f.rect(r, board ? 0x2F4B3A : 0xFFFDF6, radius: 1)
        if board {
            f.rect(6, 84, 126, 5, 0x9A6A42, radius: 1)
            f.rect(30, 82, 8, 3, 0xFFFDF6, radius: 1)
            f.rect(96, 82, 10, 3, 0xFAC775, radius: 1)
        }
        let labels = p.labels ?? []
        let cols = max(1, labels.count)
        let icons = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:))
        let rows = max(1, (icons.count + cols - 1) / cols)
        let cw = (r.width - 8) / CGFloat(cols)
        let header: CGFloat = 13
        let ch = (r.height - header - 6) / CGFloat(rows)
        let chalk: [UInt32] = board ? [0xF4F1EA, 0xFAC775, 0xA9CBE0, 0x5DCAA5, 0xF4F1EA] : [0x1F3A6B, 0xC8261B, 0x0F6E56, 0x2F5BD3, 0x3C3489]
        for (c, label) in labels.enumerated() {
            f.text(label, PropFont.heavy(8), ink, at: CGPoint(x: r.minX + 4 + cw * (CGFloat(c) + 0.5), y: r.minY + 8), maxWidth: cw - 2)
        }
        f.line(r.minX + 4, r.minY + header, r.maxX - 4, r.minY + header, ink, 0.8)
        for c in 1..<cols {
            let x = r.minX + 4 + cw * CGFloat(c)
            f.line(x, r.minY + 3, x, r.maxY - 3, ink, 0.6)
        }
        for (i, icon) in icons.enumerated() {
            let (row, col) = (i / cols, i % cols)
            let side = min(cw, ch) - 7
            let cx = r.minX + 4 + cw * (CGFloat(col) + 0.5)
            let cy = r.minY + header + 3 + ch * (CGFloat(row) + 0.5)
            icon.draw(f, in: CGRect(x: cx - side / 2, y: cy - side / 2, width: side, height: side),
                      color: chalk[i % chalk.count], detail: board ? 0x2F4B3A : 0xFFFDF6)
            if i == p.highlight {
                f.stroke(Path(ellipseIn: CGRect(x: cx - cw / 2 + 1, y: cy - ch / 2 + 1, width: cw - 2, height: ch - 2)), 0xED93B1, 1.6)
                PalaceIcon.heart.draw(f, in: CGRect(x: cx + side / 2 - 4, y: cy - ch / 2 - 1, width: 10, height: 10),
                                      color: 0xC8261B, detail: 0xC8261B)
            }
        }
    }
}
