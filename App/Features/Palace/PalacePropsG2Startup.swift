import SwiftUI

/// Startup props: a dartboard hit dead centre, a climber near a flag on a summit, a puzzle whose
/// last piece goes in, coins growing into a plant, and an app that is still being built.
enum G2StartupProps {
    // MARK: Target

    /// A dartboard on a nail (80 × 80) with a dart right in the bullseye.
    static func target(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 80, height: 80))
        f.dot(40, 4, 2, 0x2E2117)
        f.dot(41.5, 44, 34, 0x1E1E1C, 0.2)
        for (r, c) in [(34.0, 0x2E2117), (31, 0xC8261B), (24, 0xFFFDF6), (17, 0xC8261B), (10, 0xFFFDF6), (4.5, 0xC8261B)] as [(CGFloat, UInt32)] {
            f.dot(40, 42, r, c)
        }
        f.svgLine("M41 41L66 16", 0x3E4C55, 2.4)
        f.svg("M62 14L72 6L70 16L78 14L68 22L64 20Z", 0x2F5BD3)
        f.svgLine("M38.5 43.5L41 41", 0xB4B2A9, 1.6)
        f.svgLine("M28 52L24 56M52 54L56 58M30 30L26 26", 0xFAC775, 1.6)
    }

    // MARK: Climb

    /// A card (90 × 80): a high mountain with snow and a red flag on top; a climber high on the
    /// zigzag path reaching up, an arrow pointing to the summit.
    static func climb(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 90, height: 80))
        f.rect(1.5, 3, 88, 77, 0x1E1E1C, radius: 4, 0.14)
        f.rect(0, 0, 88, 76, 0xD9E8F0, radius: 4)
        f.svg("M0 76L22 46L34 58L52 14L88 76Z", 0x5E6B73)
        f.svg("M44 30L52 14L60 30L56 27L52 31L48 27Z", 0xFFFDF6)
        f.svg("M0 76L22 46L30 56L16 76Z", 0x8C9499)
        f.svgLine("M52 14V2", 0x2E2117, 1.4)
        f.svg("M52 2L64 5L52 9Z", 0xC8261B)
        f.svgLine("M20 74L40 62L30 52L46 40L40 34", 0xFFFDF6, 1.2, 0.8)
        // The climber, near the top
        f.dot(44, 30, 2.6, 0xF2711C)
        f.svgLine("M44 33V39M44 39L41 44M44 39L47 43M44 35L48 31", 0xF2711C, 1.8)
        f.svgLine("M12 30V12M7 17L12 11L17 17", 0x1E7A4C, 2.6)
    }

    // MARK: Puzzle

    /// A puzzle (90 × 80): three pieces in place, the last one held over its gap by a hand, and a
    /// green tick.
    static func puzzle(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 90, height: 80))
        f.rect(4, 14, 64, 64, 0x1E1E1C, radius: 3, 0.18)
        f.rect(2, 12, 64, 64, 0xEFEBE2, radius: 3)
        piece(f, x: 4, y: 14, c: 0x2F5BD3)
        piece(f, x: 34, y: 14, c: 0xF2B33D)
        piece(f, x: 4, y: 44, c: 0x1E7A4C)
        f.rect(34, 44, 30, 30, 0x5F5E5A, 0.25)
        // The last piece, coming in from the top right with a hand
        piece(f, x: 50, y: 28, c: 0xC8261B)
        f.svg("M70 30Q78 26 86 30L90 34V50L80 48Q74 46 72 40Z", 0xC99A74)
        f.svgLine("M72 36L66 37M73 41L67 43", 0xC99A74, 3)
        f.svgLine("M60 66L56 74", 0xC8261B, 1.2)
        f.dot(78, 10, 9, 0x1E7A4C)
        f.svgLine("M73.5 10.5L77 14L83 6.5", 0xFFFFFF, 2.4)
    }

    /// One square jigsaw piece (30 × 30) with a knob on the right and the bottom.
    private static func piece(_ f: PropPen, x: CGFloat, y: CGFloat, c: UInt32) {
        f.rect(x, y, 28, 28, c, radius: 2)
        f.dot(x + 29, y + 14, 4.5, c)
        f.dot(x + 14, y + 29, 4.5, c)
        f.rect(x + 3, y + 3, 10, 3, 0xFFFFFF, radius: 1.5, 0.3)
    }

    // MARK: Money plant

    /// A pot (80 × 90) with a plant whose leaves are gold coins, a hand dropping one more coin in,
    /// and a green arrow going up.
    static func moneyPlant(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 80, height: 90))
        f.oval(10, 84, 54, 6, 0x1E1E1C, 0.15)
        f.svg("M14 60H60L54 88H20Z", 0xA3410A)
        f.rect(12, 56, 50, 8, 0xC2582A, radius: 2)
        f.svgLine("M37 58V24M37 46Q26 42 22 34M37 38Q48 34 52 26M37 30Q30 24 30 16", 0x5E8C45, 2.4)
        for (x, y) in [(22.0, 32.0), (52, 24), (30, 14), (37, 22), (46, 44)] as [(CGFloat, CGFloat)] {
            f.dot(x, y, 6, G2Props.coin)
            f.ring(x, y, 4, 0xC9A15B, 1)
            f.text("€", PropFont.heavy(6), 0xA37E3B, at: CGPoint(x: x, y: y + 0.3))
        }
        f.dot(24, 52, 4.5, G2Props.coin)
        f.svgLine("M24 44V40", 0xC9A15B, 1)
        f.svg("M10 30Q8 36 14 40L22 44Q26 42 24 38L18 32Q14 28 10 30Z", 0xC99A74)
        f.svg("M0 22L10 30L6 36L0 34Z", 0x1F3A6B)
        f.svgLine("M70 70V20M64 27L70 19L76 27", 0x1E7A4C, 3)
    }

    // MARK: Build

    /// An app being built (80 × 90): a phone whose screen is half finished (the rest dashed), a
    /// gear and a spanner, and a progress bar at `count` percent.
    static func build(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 80, height: 90))
        f.rect(12, 2, 46, 76, 0x1E1E1C, radius: 7)
        f.rect(15, 8, 40, 64, 0xF4F1EA, radius: 2)
        f.rect(15, 8, 40, 10, 0x2F5BD3, radius: 2)
        f.rect(18, 21, 34, 12, 0xF2B33D, radius: 2)
        f.rect(18, 36, 16, 12, 0x5DCAA5, radius: 2)
        var dashed = Path()
        dashed.addRoundedRect(in: CGRect(x: 36, y: 36, width: 16, height: 12), cornerSize: CGSize(width: 2, height: 2))
        dashed.addRoundedRect(in: CGRect(x: 18, y: 51, width: 34, height: 18), cornerSize: CGSize(width: 2, height: 2))
        f.fill(dashed.strokedPath(StrokeStyle(lineWidth: 1.2, dash: [3, 2])), 0x8C9499)
        PalaceIcon.g2Gear.draw(f, in: CGRect(x: 48, y: 46, width: 30, height: 30), color: 0x5E6B73, detail: 0xF4F1EA)
        f.svgLine("M6 70L22 54", 0x8C9499, 4)
        f.svg("M20 50L28 52L26 60L18 58Z", 0x8C9499)
        f.dot(6, 70, 3.4, 0x8C9499)
        let progress = CGFloat(max(0, min(p.count ?? 60, 100))) / 100
        f.rect(8, 82, 64, 7, 0xD3D1C7, radius: 3.5)
        f.rect(8, 82, 64 * progress, 7, 0x1E7A4C, radius: 3.5)
    }
}
