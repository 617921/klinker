import SwiftUI

/// Things in a home that mean their word: a leak dripping into a bucket, moving boxes,
/// a vacuum cleaner, a furnished corner with its tag, a framed floor plan.
enum PalaceHomeProps {
    // MARK: Leak

    /// A wet stain on the ceiling (top of the frame), drops falling, a bucket on the floor (bottom).
    /// Fills its frame, so a tall narrow box gives a long fall.
    static func ceilingLeak(_ pen: PropPen, _ p: PalacePropParams) {
        let (w, h) = (pen.size.width, pen.size.height)
        let cx = w / 2
        pen.oval(cx - w * 0.5, 0, w, 22, 0x6B5A3E, 0.5)
        pen.oval(cx - w * 0.34, 3, w * 0.68, 14, 0x4A3A28, 0.45)
        pen.svgLine("M\(cx - 14) 8L\(cx - 7) 12L\(cx) 7L\(cx + 6) 12L\(cx + 13) 8", 0x2E2117, 1.3)
        drop(pen, cx, 25, 3.8)
        let bw = min(w - 2, 42), bh: CGFloat = 32
        let top = h - bh - 4
        let n = max(2, min(p.count ?? 4, 7))
        for i in 0..<n {
            let t = CGFloat(i + 1) / CGFloat(n + 1)
            drop(pen, cx, 34 + t * (top - 40), 3.4)
        }
        pen.oval(cx - bw / 2 - 2, h - 7, bw + 4, 6, 0x1E1E1C, 0.16)
        pen.svg("M\(cx - bw / 2) \(top + 3)L\(cx + bw / 2) \(top + 3)L\(cx + bw / 2 - 5) \(h - 4)L\(cx - bw / 2 + 5) \(h - 4)Z", 0x7F95A1)
        pen.svg("M\(cx - bw / 2 + 3) \(top + 3)L\(cx - bw / 2 + 9) \(top + 3)L\(cx - bw / 2 + 12) \(h - 4)L\(cx - bw / 2 + 7) \(h - 4)Z", 0xA9BCC6)
        pen.line(cx - bw / 2 + 2, top + 13, cx + bw / 2 - 2, top + 13, 0x5E7380, 1.2)
        pen.oval(cx - bw / 2, top, bw, 8, 0xB4C3CB)
        pen.oval(cx - bw / 2 + 3, top + 1.6, bw - 6, 5, 0x4E8FC4)
        pen.svgLine("M\(cx - 7) \(top + 4)Q\(cx) \(top + 1.6) \(cx + 7) \(top + 4)", 0xC9E6F2, 1.1)
        pen.svgLine("M\(cx - 4) \(top - 2)L\(cx - 7) \(top - 6)M\(cx + 4) \(top - 2)L\(cx + 7) \(top - 6)M\(cx) \(top - 3)V\(top - 7)", 0x4E8FC4, 1.3)
        pen.svgLine("M\(cx - bw / 2 + 1) \(top + 4)Q\(cx) \(top - 16) \(cx + bw / 2 - 1) \(top + 4)", 0x5E7380, 1.4)
    }

    /// A falling drop, point up.
    static func drop(_ pen: PropPen, _ x: CGFloat, _ y: CGFloat, _ r: CGFloat) {
        pen.svg("M\(x) \(y - r * 2.3)C\(x + r * 0.5) \(y - r * 1.1) \(x + r) \(y - r * 0.5) \(x + r) \(y + r * 0.1)A\(r) \(r) 0 1 1 \(x - r) \(y + r * 0.1)C\(x - r) \(y - r * 0.5) \(x - r * 0.5) \(y - r * 1.1) \(x) \(y - r * 2.3)Z",
                0x4E8FC4)
        pen.dot(x - r * 0.35, y, r * 0.3, 0xFFFFFF, 0.8)
    }

    // MARK: Moving boxes

    /// Cardboard boxes stacked high (80 × 124), tape across, "this side up" arrows, a plant sticking out.
    static func movingBoxes(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 80, height: 124))
        let labels = p.labels ?? []
        let n = max(2, min(p.count ?? 3, 3))
        let boxes: [CGRect] = [CGRect(x: 3, y: 80, width: 74, height: 40), CGRect(x: 8, y: 46, width: 62, height: 35),
                               CGRect(x: 18, y: 18, width: 46, height: 29)]
        f.oval(0, 116, 80, 7, 0x1E1E1C, 0.16)
        if n == 3 {
            f.svg("M30 20C26 10 30 2 36 0C36 8 34 14 33 20Z M38 20C40 10 46 6 52 6C48 12 44 16 41 20Z", 0x5E8C45)
            f.svg("M34 20C31 13 24 10 18 11C22 15 27 18 31 20Z", 0x4E7A3A)
        }
        for (i, b) in boxes.prefix(n).enumerated() {
            f.rect(b, 0xC9965F, radius: 1)
            f.rect(b.minX, b.minY, b.width, 4, 0xA87B4F)
            f.rect(b.midX - 4, b.minY, 8, b.height * 0.42, 0xE2C48E)
            if i == 2 {
                f.svg("M\(b.minX) \(b.minY)L\(b.minX - 8) \(b.minY - 7)L\(b.minX + 12) \(b.minY - 7)L\(b.minX + 16) \(b.minY)Z", 0xB4834F)
                f.svg("M\(b.maxX) \(b.minY)L\(b.maxX + 7) \(b.minY - 8)L\(b.maxX - 12) \(b.minY - 8)L\(b.maxX - 16) \(b.minY)Z", 0xB4834F)
            }
            if i < labels.count {
                f.text(labels[i], PropFont.heavy(9), 0x2E2117, at: CGPoint(x: b.midX, y: b.maxY - b.height * 0.28), maxWidth: b.width - 8)
            }
        }
        f.svgLine("M10 98V88M7 91L10 88L13 91M17 98V88M14 91L17 88L20 91", 0x2E2117, 1.4)
        f.svg("M62 88H70L68.6 95H63.4Z", 0xFFFDF6)
        f.svgLine("M66 95V99M63.5 99H68.5", 0xFFFDF6, 1.2)
    }

    // MARK: Vacuum

    /// A canister vacuum cleaner (64 × 92): hose up to the handle, the nozzle on a dusty floor.
    static func vacuum(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 64, height: 92))
        f.oval(0, 85, 64, 6, 0x1E1E1C, 0.15)
        f.svgLine("M18 66C10 50 18 30 34 26C42 24 46 18 46 10", 0x3E4C55, 4)
        f.svgLine("M46 8L50 84", 0xB4B2A9, 3.2)
        f.rect(42, 3, 8, 8, 0x2E2117, radius: 2)
        f.svg("M42 82H62Q64 82 64 85V88H40V85Q40 82 42 82Z", 0x2E2117)
        f.svg("M2 70C2 62 8 58 16 58H26C33 58 36 64 36 72V82H2Z", 0xC8261B)
        f.svg("M6 62C8 60 11 59 15 59H20V64H8Z", 0xE8534A)
        f.dot(9, 84, 4.2, 0x1E1E1C)
        f.dot(30, 84, 4.2, 0x1E1E1C)
        f.dot(9, 84, 1.5, 0x8A8A82)
        f.dot(30, 84, 1.5, 0x8A8A82)
        f.dot(24, 70, 3, 0x7A1A12)
        for (x, y) in [(56.0, 77.0), (60, 74), (58, 71), (62, 78)] as [(CGFloat, CGFloat)] { f.dot(x + 4, y, 1.1, 0x8A6A3E) }
        f.svgLine("M38 76L40 72M34 76L35 71", 0xFAC775, 1.2)
    }

    // MARK: Furnished corner

    /// A lamp, a sofa with cushions and a side table (144 × 100), all tied to one tag (`text`).
    static func furnitureSet(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 144, height: 100))
        f.oval(0, 92, 144, 8, 0x1E1E1C, 0.14)
        f.dot(14, 22, 16, 0xFAC775, 0.25)
        f.rect(13, 22, 2.4, 72, 0x2E2117)
        f.oval(5, 92, 18, 4, 0x2E2117)
        f.svg("M5 22L9 6H19L23 22Z", 0xF2B33D)
        f.svg("M30 52Q30 40 40 40H106Q116 40 116 52V62H30Z", 0x0F6E56)
        f.rect(26, 58, 94, 22, 0x0F6E56, radius: 5)
        f.rect(36, 60, 36, 10, 0x13866A, radius: 3)
        f.rect(74, 60, 36, 10, 0x13866A, radius: 3)
        f.rect(22, 52, 12, 28, 0x0B5A46, radius: 5)
        f.rect(112, 52, 12, 28, 0x0B5A46, radius: 5)
        f.svg("M38 46L52 44L54 58L40 59Z", 0xF2711C)
        f.svg("M92 45L105 47L103 59L90 58Z", 0xFAC775)
        f.svgLine("M30 80V90M116 80V90", 0x2E2117, 3)
        f.oval(122, 64, 22, 5, 0x7A5230)
        f.rect(131.5, 67, 3, 24, 0x4A3524)
        f.oval(125, 89, 16, 3.5, 0x4A3524)
        f.rect(128.5, 54, 9, 11, 0xC8261B, radius: 2)
        f.svg("M133 54C128 46 130 40 133 36C136 40 138 46 133 54Z", 0x5E8C45)
        guard let text = p.text else { return }
        let font = PropFont.heavy(10)
        let tw = max(40, f.width(of: text, font) + 22)
        let tag = CGRect(x: 104 - tw / 2, y: 6, width: tw, height: 20)
        f.svgLine("M116 52Q118 36 \(tag.maxX - 6) \(tag.midY)", 0x5F5E5A, 1)
        f.svg("M\(tag.minX + 7) \(tag.minY)H\(tag.maxX)V\(tag.maxY)H\(tag.minX + 7)L\(tag.minX) \(tag.midY)Z", 0xFFFDF6)
        f.stroke(PalaceSVG.path("M\(tag.minX + 7) \(tag.minY)H\(tag.maxX)V\(tag.maxY)H\(tag.minX + 7)L\(tag.minX) \(tag.midY)Z"), 0x1E7A4C, 1.4)
        f.dot(tag.minX + 6, tag.midY, 1.6, 0x5F5E5A)
        PalaceIcon.check.draw(f, in: CGRect(x: tag.minX + 9, y: tag.minY + 3.5, width: 13, height: 13), color: 0x1E7A4C, detail: 0xFFFDF6)
        f.text(text, font, 0x1E7A4C, at: CGPoint(x: tag.minX + 23, y: tag.midY + 0.5), anchor: .leading, maxWidth: tw - 26)
    }

    // MARK: Floor plan

    /// A framed drawing of a home (74 × 66): a roof over a floor plan with a bed, a sofa, a table.
    static func floorPlan(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 74, height: 68))
        f.rect(1.5, 3, 72, 65, 0x1E1E1C, radius: 2, 0.15)
        f.rect(0, 0, 72, 65, 0x4A3524, radius: 2)
        f.rect(4, 4, 64, 57, 0xFFFDF6)
        let ink: UInt32 = 0x1F3A6B
        f.svgLine("M11 23L36 9L61 23", ink, 2.2)
        f.svgLine("M14 23V46H58V23Z", ink, 2.2)
        f.svgLine("M36 23V31M36 37V46M36 34H42M48 34H58", ink, 1.5)
        f.rect(18, 27, 13, 9, 0xA9CBE0, radius: 1)
        f.rect(18, 27, 4, 9, 0xFFFDF6)
        f.stroke(Path(roundedRect: CGRect(x: 18, y: 27, width: 13, height: 9), cornerRadius: 1), ink, 0.9)
        f.rect(40, 25.5, 14, 5, 0xF2B33D, radius: 1.5)
        f.dot(47, 40.5, 3.2, 0xC9A15B)
        f.svg("M21 46V40H27V46Z", 0xFFFDF6)
        f.svgLine("M21 46A6 6 0 0 1 27 40", ink, 0.9)
        if let text = p.text {
            f.text(text, PropFont.heavy(9.5), ink, at: CGPoint(x: 36, y: 54), maxWidth: 58)
        }
    }
}
