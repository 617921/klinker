import SwiftUI

/// Farm props: a barn with cows looking out, a fenced meadow, wide fields, dairy, a farm-gate
/// stall and a tractor on a lane.
enum G7FarmProps {
    // MARK: Barn

    /// A red barn (140 × 160) under a big grey roof with a white owl board, its doors wide open:
    /// hay inside and two cows looking out over a half door.
    static func barn(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 140, height: 160))
        f.oval(2, 152, 136, 8, 0x1E1E1C, 0.15)
        f.rect(10, 70, 120, 86, 0x8C3A2E)
        f.svgLine("M10 84H130M10 98H130M10 112H130M10 126H130M10 140H130", 0x7A3226, 1)
        f.svg("M0 76L70 6L140 76H128L70 20L12 76Z", 0x3E4C55)
        f.svg("M12 76L70 20L128 76Z", 0x8C3A2E)
        f.svg("M0 76L70 6L140 76L132 80L70 16L8 80Z", 0x2E3A42)
        f.svg("M66 8H74V30L70 34L66 30Z", 0xFFFDF6)
        f.svg("M50 46H90V68H50Z", 0x2E2117)
        f.svg("M52 56Q60 48 70 54Q80 48 88 56V68H52Z", 0xE0A93A)
        // Open doors and the dark inside
        f.rect(34, 92, 72, 64, 0x2E2117)
        f.svg("M20 92H34V156H16Z M106 92H120L124 156H106Z", 0xFFFDF6)
        f.svgLine("M20 92L34 156M34 92L18 156M106 92L122 156M120 92L106 156", 0x8C3A2E, 2)
        f.svg("M36 130Q50 118 64 128Q78 116 104 130V156H36Z", 0xE0A93A)
        f.svgLine("M40 136L48 128M60 140L66 130M80 138L88 128M94 142L98 132", 0xC9A15B, 1.2)
        for (x, flip) in [(52.0, false), (88, true)] as [(CGFloat, Bool)] {
            G7FarmAnimals.cowHead(f, x: x, y: 110, flip: flip)
        }
        f.rect(34, 124, 72, 6, 0x9A6A42)
        f.svgLine("M44 130V156M70 130V156M96 130V156", 0x9A6A42, 3)
    }

    // MARK: Meadow

    /// A fenced green pasture (112 × 86): wooden posts and rails, a five-bar gate, daisies and a
    /// water trough.
    static func meadow(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 86))
        f.svg("M0 30H112V86H0Z", 0x8DB061)
        f.svg("M0 30H112V40H0Z", 0x7FA650)
        for x in stride(from: CGFloat(4), to: 112, by: 22) {
            f.rect(x, 14, 5, 40, 0x8A5C38)
            f.rect(x, 14, 5, 3, 0x6B4A2E)
        }
        f.svgLine("M0 24H74M0 38H74", 0xB07F4E, 3)
        // Gate
        f.rect(100, 14, 5, 42, 0x8A5C38)
        f.svgLine("M76 18H100M76 26H100M76 34H100M76 42H100M76 50H100M76 18L100 50", 0xEFEBE2, 2.2)
        f.svgLine("M76 16V52", 0xEFEBE2, 2.6)
        for (x, y) in [(12.0, 62.0), (30, 74), (52, 60), (70, 78), (90, 66), (40, 50)] as [(CGFloat, CGFloat)] {
            for k in 0..<5 {
                let a = Double(k) * .pi * 0.4
                f.dot(x + cos(a) * 2.4, y + sin(a) * 2.4, 1.8, 0xFFFDF6)
            }
            f.dot(x, y, 1.4, 0xFAC775)
        }
        f.svgLine("M6 84l2 -5l2 5l2 -6l2 6M84 84l2 -5l2 5l2 -6l2 6", 0x6E9C52, 1.3)
    }

    // MARK: Fields

    /// The countryside to the horizon (106 × 110): a row of poplars, a far farm and church spire,
    /// crop rows running away, round hay bales.
    static func fields(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 106, height: 110))
        f.rect(0, 40, 106, 70, 0xB9C77A)
        f.svg("M0 40H106V52H0Z", 0x8DB061)
        for x in stride(from: CGFloat(4), to: 106, by: 9) {
            f.oval(x - 2.5, 20, 5, 22, 0x4E7A3A)
        }
        f.rect(70, 32, 14, 9, 0xD9CDB4)
        f.svg("M68 33L77 26L86 33Z", 0x8C3A2E)
        f.svg("M24 41V24L26 16L28 24V41Z", 0x7D8A92)
        var rows = ""
        for k in 0..<9 {
            let x0 = CGFloat(k) * 13 - 4
            rows += "M\(53 + (x0 - 53) * 0.15) 54L\(x0) 110"
        }
        f.svg("M0 54H106V110H0Z", 0xD9C08F)
        f.svgLine(rows, 0xB49A66, 2.2)
        for (x, y, r) in [(16.0, 64.0, 7.0), (40, 60, 5.5), (86, 70, 8), (66, 96, 11)] as [(CGFloat, CGFloat, CGFloat)] {
            f.oval(x - r, y + r * 0.7, 2 * r, r * 0.6, 0x1E1E1C, 0.12)
            f.dot(x, y, r, 0xE0A93A)
            f.ring(x, y, r * 0.55, 0xC9A15B, 1.2)
        }
    }

    // MARK: Dairy

    /// A metal milk churn, a bottle of milk, a round cheese with a slice cut, butter and a yoghurt pot (82 × 74).
    static func dairy(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 82, height: 74))
        f.oval(0, 66, 82, 8, 0x1E1E1C, 0.14)
        f.svg("M4 70V30Q4 24 10 22V14H26V22Q32 24 32 30V70Z", 0xB4B2A9)
        f.rect(8, 8, 20, 7, 0x8E8A80, radius: 2)
        f.rect(4, 40, 28, 4, 0x8E8A80)
        f.rect(7, 26, 4, 40, 0xD3D1C7)
        f.svg("M38 70V36Q38 30 42 28V20H48V28Q52 30 52 36V70Z", 0xFFFDF6)
        f.rect(41, 16, 8, 5, 0x2F5BD3, radius: 1)
        f.rect(38, 44, 14, 12, 0x2F5BD3)
        f.oval(52, 46, 30, 24, 0xE0A93A)
        f.svg("M67 58L82 54Q82 62 80 66Z", 0xFAD98A)
        f.oval(56, 52, 4, 3, 0xF2C04E)
        f.rect(18, 58, 18, 12, 0xFAD98A, radius: 1)
        f.svg("M18 58L22 54H38L36 58Z", 0xFFFDF6)
        f.svg("M56 66H72L71 74H57Z", 0xFFFDF6)
    }

    // MARK: Farm stall

    /// A farm-gate stall (76 × 104): a little roof, a sign with `text`, eggs, honey jars and a sack
    /// of potatoes, and a money tin.
    static func farmStall(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 104))
        f.oval(2, 98, 72, 6, 0x1E1E1C, 0.15)
        f.rect(6, 30, 64, 70, 0x9A6A42)
        f.rect(10, 34, 56, 62, 0x6B4A2E)
        f.svg("M0 32L38 14L76 32Z", 0x8C3A2E)
        if let text = p.text {
            f.rect(10, 0, 56, 16, 0xFFFDF6, radius: 2)
            f.stroke(Path(roundedRect: CGRect(x: 10, y: 0, width: 56, height: 16), cornerRadius: 2), 0x1E7A4C, 1.4)
            f.text(text, PropFont.heavy(9.5), 0x1E7A4C, at: CGPoint(x: 38, y: 8.5), maxWidth: 50)
        }
        // Shelf 1: eggs in a box
        f.rect(10, 52, 56, 3, 0x9A6A42)
        f.rect(14, 44, 26, 8, 0xD9C08F, radius: 1)
        for x in [18.0, 24, 30, 36] as [CGFloat] { f.oval(x - 2.6, 40, 5.2, 7, 0xFFF4E2) }
        // Honey jars
        for x in [46.0, 56] as [CGFloat] {
            f.rect(x - 4, 40, 8, 12, 0xE0A93A, radius: 2)
            f.rect(x - 4.4, 37, 8.8, 4, 0xC8261B, radius: 1)
        }
        // Shelf 2: potatoes and a money tin
        f.rect(10, 76, 56, 3, 0x9A6A42)
        f.svg("M14 76Q12 62 20 60H32Q38 62 36 76Z", 0xD9C08F)
        for (x, y) in [(20.0, 60.0), (27, 58), (33, 61)] as [(CGFloat, CGFloat)] { f.oval(x - 3.5, y - 3, 7, 5.5, 0xC9965F) }
        f.rect(46, 64, 16, 12, 0x5E6B73, radius: 2)
        f.rect(50, 66, 8, 2, 0x1E1E1C)
        f.dot(54, 72, 2, 0xC9A15B)
        f.rect(10, 80, 56, 16, 0x8A5C38)
    }

    // MARK: Tractor

    /// A green tractor on a muddy lane with a hen crossing in front of it (92 × 76).
    static func tractor(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 92, height: 76))
        f.oval(0, 62, 92, 12, 0xB49A66)
        f.oval(8, 64, 26, 6, 0x8A5C38, 0.6)
        f.rect(22, 30, 46, 22, 0x2F7A3A, radius: 3)
        f.rect(46, 8, 24, 26, 0x2F7A3A, radius: 2)
        f.rect(50, 12, 16, 14, 0xBCCDD6, radius: 1)
        f.rect(28, 20, 4, 12, 0x3E4C55)
        f.svgLine("M30 20Q28 14 32 10", 0xB4B2A9, 2)
        f.rect(16, 40, 10, 10, 0x2F7A3A, radius: 2)
        f.dot(28, 58, 10, 0x1E1E1C)
        f.dot(28, 58, 4, 0xFAC775)
        f.dot(60, 52, 17, 0x1E1E1C)
        f.dot(60, 52, 7, 0xFAC775)
        f.svgLine("M48 62L46 66M70 64L72 68M60 69V72", 0x8A5C38, 2)
        G7FarmAnimals.hen(f, x: 10, y: 60)
    }
}
