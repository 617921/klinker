import SwiftUI

/// Sound in a home: someone's loud music bothering a person, and a wall so thin you hear the neighbours.
enum PalaceHomeSound {
    // MARK: Loud speaker

    /// A big speaker blasting jagged red sound and notes at a person who holds their ears (112 × 88).
    static func loudSpeaker(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 88))
        f.oval(0, 82, 112, 6, 0x1E1E1C, 0.15)
        f.rect(4, 22, 32, 62, 0x2E2117, radius: 3)
        f.rect(6, 24, 28, 58, 0x3E3A36, radius: 2)
        f.dot(20, 38, 7.5, 0x1E1E1C)
        f.dot(20, 38, 4, 0x5E6B73)
        f.dot(20, 63, 11.5, 0x1E1E1C)
        f.dot(20, 63, 6.5, 0x5E6B73)
        f.dot(20, 63, 2.4, 0x1E1E1C)
        f.svgLine("M40 34L45 30L48 36L53 31L56 37L61 33", 0xC8261B, 2.4)
        f.svgLine("M41 52L46 47L49 54L54 48L57 55L62 50L65 56", 0xC8261B, 2.6)
        f.svgLine("M40 70L45 66L48 72L53 67L56 73L61 69", 0xC8261B, 2.4)
        note(f, 46, 18)
        note(f, 58, 12)
        // The bothered person, facing the speaker.
        let skin: UInt32 = 0xE8C4A0
        f.svgLine("M83 70V84M93 70V84", 0x3E4C55, 4.6)
        f.svg("M78 84H87V88H78Z M89 84H98V88H89Z", 0x2E2117)
        f.svg("M74 74L76 46C77 40 81 37 88 37C95 37 99 40 100 46L102 74Z", 0x7F77DD)
        f.svgLine("M75 52H101M75 60H101M75 68H101", 0xEEEDFE, 1.4)
        f.svgLine("M77 44C72 38 72 30 76 26M99 44C104 38 104 30 100 26", 0x7F77DD, 5.5)
        f.dot(88, 24, 11, skin)
        f.svg("M77 22C77 14 82 11 88 11C94 11 99 14 99 22C96 17 92 16 88 16C84 16 80 17 77 22Z", 0x4A3524)
        f.dot(76.5, 25, 3.6, skin)
        f.dot(99.5, 25, 3.6, skin)
        f.svgLine("M80.5 20.5L85.5 22.5M95.5 20.5L90.5 22.5", 0x2E2117, 1.5)
        f.dot(84, 25, 1.2, 0x2E2117)
        f.dot(92, 25, 1.2, 0x2E2117)
        f.svgLine("M84 31.5Q88 28.5 92 31.5", 0x2E2117, 1.5)
        f.svgLine("M80 6C82 2 85 7 88 3C91 0 92 6 95 3", 0x2E2117, 1.4)
    }

    /// A small music note.
    static func note(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, color: UInt32 = 0x1E1E1C) {
        f.oval(x - 4, y + 7, 6, 4.5, color)
        f.line(x + 1.5, y + 9, x + 1.5, y - 1, color, 1.4)
        f.svgLine("M\(x + 1.5) \(y - 1)Q\(x + 5) \(y + 1) \(x + 5) \(y + 5)", color, 1.4)
    }

    // MARK: Thin wall

    /// A cut-open wall (100 × 74): next door two neighbours talk (`text` in a bubble), the wall
    /// between is paper-thin, and their voices reach a big ear on this side.
    static func thinWall(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 74))
        let hole = Path(roundedRect: CGRect(x: 2, y: 2, width: 96, height: 70), cornerRadius: 6)
        f.fill(hole.offsetBy(dx: 1.5, dy: 2), 0x1E1E1C, 0.14)
        f.fill(hole, 0xF6EDDC)
        var g = f
        g.ctx.clip(to: hole)
        g.rect(2, 2, 46, 70, 0xC9DBE6)
        g.svgLine("M10 2V72M22 2V72M34 2V72", 0xB7CCD9, 2)
        // Neighbours
        g.svg("M8 74C8 62 12 56 19 56C26 56 30 62 30 74Z", 0xC8261B)
        g.dot(19, 47, 8, 0x8C5A3C)
        g.svg("M11 46C11 40 14 37 19 37C24 37 27 40 27 46C25 42 22 41.5 19 41.5C16 41.5 13 42 11 46Z", 0x1E1E1C)
        g.svg("M28 74C28 64 31 59 37 59C43 59 46 64 46 74Z", 0x1F3A6B)
        g.dot(37, 51, 7, 0xF1D3B8)
        g.svg("M30 50C30 44 33 42 37 42C41 42 44 44 44 50C42 47 40 46 37 46C34 46 32 47 30 50Z", 0xC9A15B)
        g.oval(21.5, 48.5, 4, 3, 0x7A1A12)
        // The thin wall
        g.rect(47, 2, 4, 70, 0xD9CDB4)
        g.svgLine("M47 2V72M51 2V72", 0xB4A58C, 0.8)
        // Voices passing through
        for r in [7.0, 13, 19] as [CGFloat] {
            var arc = Path()
            arc.addArc(center: CGPoint(x: 44, y: 38), radius: r, startAngle: .degrees(-40), endAngle: .degrees(40), clockwise: false)
            g.stroke(arc, 0x2F5BD3, 1.8)
        }
        if let text = p.text {
            let bubble = CGRect(x: 5, y: 6, width: 40, height: 17)
            g.rect(bubble, 0xFFFDF6, radius: 6)
            g.svg("M15 22L13 29L21 22Z", 0xFFFDF6)
            g.text(text, PropFont.demi(9.5), 0x1E1E1C, at: CGPoint(x: bubble.midX, y: bubble.midY + 0.5), maxWidth: bubble.width - 5)
        }
        // A head on this side, its big ear to the wall
        g.dot(90, 40, 18, 0xC99A74)
        g.svg("M74 30C72 22 80 14 90 14C100 14 104 22 104 30C99 25 95 24 90 24C84 24 78 26 74 30Z", 0x2E2117)
        g.svg("M68 30C68 24 72 21 76 21C81 21 83 25 83 30C83 36 79 38 78 44C77 50 73 53 69 50C67 48 69 45 71 43C73 40 68 36 68 30Z", 0xE0B48E)
        g.svgLine("M72 30C72 26 74 25 76.5 25C79 25 80 27 80 30C80 33 77 34 76 38", 0xA8785A, 1.6)
        f.stroke(hole, 0xB4A58C, 2.4)
        f.svgLine("M2 14L8 10L6 4M98 60L92 64L95 70", 0xB4A58C, 1.2)
    }
}
