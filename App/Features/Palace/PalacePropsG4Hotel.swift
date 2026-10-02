import SwiftUI

/// Hotel things: a guest room's bed (a double bed for two, or someone woken by an alarm clock),
/// the key rack, the receptionist with a desk bell, and a price board with what's included.
enum G4Hotel {
    typealias Look = PalaceFigures.Look

    // MARK: Beds

    /// A guest room's furniture (168 × 112). `accessory` "double": a wide bed with two pillows,
    /// two bedside lamps and a plaque with two people. "wake": a single bed, a man sitting bolt
    /// upright, an alarm clock ringing at `time` on the bedside table.
    static func hotelBed(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 168, height: 112))
        f.oval(4, 104, 160, 7, 0x1E1E1C, 0.12)
        if p.accessory == "wake" { return wake(f, p) }
        for x in [6.0, 140] as [CGFloat] {
            f.rect(x, 74, 22, 32, 0x9A6A42, radius: 2)
            f.rect(x + 2, 86, 18, 2, 0x7A5230)
            f.rect(x + 9, 62, 4, 12, 0xC9A15B)
            f.svg("M\(x + 3) 62L\(x + 6) 48H\(x + 16)L\(x + 19) 62Z", 0xFAC775)
            f.svg("M\(x + 4) 62L\(x - 4) 76H\(x + 26)L\(x + 18) 62Z", 0xFAC775, 0.18)
        }
        f.rect(32, 40, 104, 34, 0x7A5230, radius: 6)
        f.rect(36, 44, 96, 26, 0x8C5E38, radius: 4)
        f.rect(30, 66, 108, 34, 0xFFFDF6, radius: 3)
        f.rect(30, 78, 108, 22, 0x8FB6CF, radius: 3)
        f.svgLine("M32 80H136", 0xFFFDF6, 1.4)
        f.rect(32, 100, 6, 6, 0x6B4A2E)
        f.rect(130, 100, 6, 6, 0x6B4A2E)
        for x in [40.0, 88] as [CGFloat] {
            f.rect(x, 58, 40, 16, 0xFFFDF6, radius: 6)
            f.stroke(Path(roundedRect: CGRect(x: x, y: 58, width: 40, height: 16), cornerRadius: 6), 0xD3D1C7, 1)
        }
        // The plaque: two people
        f.rect(70, 8, 28, 24, 0xC9A15B, radius: 2)
        f.rect(72, 10, 24, 20, 0xFFFDF6, radius: 1)
        for x in [79.0, 89] as [CGFloat] {
            f.dot(x, 16, 3, 0x1F3A6B)
            f.svg("M\(x - 4.5) 28V24Q\(x - 4.5) 20 \(x) 20Q\(x + 4.5) 20 \(x + 4.5) 24V28Z", 0x1F3A6B)
        }
    }

    private static func wake(_ f: PropPen, _ p: PalacePropParams) {
        let v = Look.at(p.variant ?? 0)
        f.rect(8, 44, 14, 58, 0x7A5230, radius: 3)
        f.rect(12, 74, 104, 26, 0xFFFDF6, radius: 3)
        f.rect(12, 100, 6, 6, 0x6B4A2E)
        f.rect(108, 100, 6, 6, 0x6B4A2E)
        f.rect(18, 64, 26, 12, 0xFFFDF6, radius: 5)
        f.stroke(Path(roundedRect: CGRect(x: 18, y: 64, width: 26, height: 12), cornerRadius: 5), 0xD3D1C7, 1)
        // Sitting bolt upright, eyes wide, hair on end
        f.svg("M30 82L32 52C33 46 37 44 42 44C47 44 51 46 52 52L54 82Z", 0x8FB6CF)
        f.svgLine("M34 50L26 40M50 50L60 40", v.skin, 4.4)
        f.dot(25, 38, 3, v.skin)
        f.dot(61, 38, 3, v.skin)
        f.dot(42, 32, 10, v.skin)
        f.svgLine("M33 24L30 16M38 22L37 13M44 22L46 13M49 25L54 18", v.hair, 2.4)
        f.dot(38.5, 31, 2.6, 0xFFFFFF)
        f.dot(46, 31, 2.6, 0xFFFFFF)
        f.dot(38.5, 31, 1.2, 0x2E2117)
        f.dot(46, 31, 1.2, 0x2E2117)
        f.oval(39, 36, 6, 5, 0x8C2A1E)
        f.svgLine("M58 22L62 16M62 28H68", 0xC8261B, 1.6)
        f.svg("M44 80Q60 70 116 76V100H44Z", 0xC8261B)
        f.svgLine("M50 86H112M50 92H112", 0xA81E15, 1)
        // Bedside table and the ringing alarm clock
        f.rect(124, 74, 36, 32, 0x9A6A42, radius: 2)
        f.rect(126, 86, 32, 2, 0x7A5230)
        let c = CGPoint(x: 142, y: 54)
        f.svgLine("M134 70L130 76M150 70L154 76", 0x3E4C55, 2.4)
        f.dot(132, 38, 6, 0xC9A15B)
        f.dot(152, 38, 6, 0xC9A15B)
        f.dot(c.x, c.y, 15, 0xC8261B)
        f.dot(c.x, c.y, 11.5, 0xFFFDF6)
        let (h, m) = PalaceFigures.parse(p.time ?? "7:00")
        let ha = (Double(h % 12) + Double(m) / 60) * 30 * .pi / 180, ma = Double(m) * 6 * .pi / 180
        f.line(c.x, c.y, c.x + sin(ha) * 6.5, c.y - cos(ha) * 6.5, 0x1E1E1C, 2.2)
        f.line(c.x, c.y, c.x + sin(ma) * 9.5, c.y - cos(ma) * 9.5, 0x1E1E1C, 1.6)
        f.svgLine("M122 40Q118 50 122 60M116 36Q110 50 116 64M162 40Q166 50 162 60M168 36Q174 50 168 64", 0x1E1E1C, 1.4)
    }

    // MARK: Key rack

    /// A wooden key rack (100 × 62): numbered hooks in two rows, keys on the first `count` only,
    /// and a red board with `text` ("vol") hanging across its left half.
    static func keyRack(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 62))
        f.rect(2, 3, 98, 59, 0x1E1E1C, radius: 3, 0.18)
        f.rect(0, 0, 98, 58, 0x9A6A42, radius: 3)
        f.rect(4, 4, 90, 50, 0x7A5230, radius: 2)
        let keys = max(0, p.count ?? 0)
        for r in 0..<2 {
            for c in 0..<6 {
                let x = 12 + CGFloat(c) * 15, y = 10 + CGFloat(r) * 24
                f.rect(x - 4, y, 8, 4, 0xEFEBE2, radius: 0.8)
                f.svgLine("M\(x) \(y + 6)V\(y + 11)Q\(x) \(y + 13) \(x + 2) \(y + 12)", 0xC9A15B, 1.4)
                if r * 6 + c < keys {
                    f.rect(x - 1.5, y + 12, 3, 8, 0xC9A15B, radius: 1)
                    f.rect(x - 3, y + 18, 6, 4, 0xC8261B, radius: 1)
                }
            }
        }
        if let text = p.text {
            f.svgLine("M14 0L22 18M54 0L44 18", 0x2E2117, 1)
            var g = f
            g.ctx.translateBy(x: 32, y: 30)
            g.ctx.rotate(by: .degrees(-8))
            g.rect(-26, -12, 52, 24, 0xC8261B, radius: 3)
            g.stroke(Path(roundedRect: CGRect(x: -23.5, y: -9.5, width: 47, height: 19), cornerRadius: 2), 0xFFFDF6, 1.2)
            g.text(text, PropFont.heavy(16), 0xFFFDF6, at: CGPoint(x: 0, y: 0.5), maxWidth: 44)
        }
    }

    // MARK: Receptionist

    /// The receptionist behind the desk (78 × 84, the desk top at y 76): navy jacket, a gold name
    /// badge, a smile, and a desk bell ringing on the counter. `flip` faces left (bell on the left).
    static func receptionist(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 78, height: 84)).mirrored(p.flip == true)
        let v = Look.at(p.variant ?? 5)
        let jacket: UInt32 = 0x1F3A6B
        f.svg("M12 80L14 46C15 38 20 34 28 34C36 34 41 38 42 46L44 80Z", jacket)
        f.svg("M23 34L28 44L33 34Z", 0xFFFDF6)
        f.svg("M26.5 36H29.5L30 46L28 48L26 46Z", 0xC8261B)
        f.rect(33, 48, 7, 4, 0xC9A15B, radius: 1)
        f.svgLine("M16 46C12 58 14 66 20 72", PalaceInk.shade(jacket, 0.8), 6)
        f.svgLine("M40 46C46 56 50 64 56 70", jacket, 6)
        f.dot(57, 71, 3.4, v.skin)
        G4Draw.head(f, 28, 20, v)
        f.dot(17, 14, 5, v.hair)
        G4Draw.smile(f, 28, 20)
        // Desk top and the bell
        f.rect(0, 76, 78, 8, 0xC9965F)
        f.rect(58, 72, 16, 4, 0x3E4C55, radius: 1)
        f.svg("M59 72Q59 62 66 62Q73 62 73 72Z", 0xD3D1C7)
        f.svgLine("M62 66Q64 64 66 64", 0xFFFFFF, 1)
        f.rect(65, 58, 2, 4, 0x5E6B73)
        f.svgLine("M58 56L55 52M66 52V47M74 56L77 52", 0xF2B33D, 1.6)
    }

    // MARK: Price board

    /// A standing board (150 × 80): a big price `text`, an equals sign, then `icons` (a bed, a cup,
    /// wifi …) each with a green tick: all in the price.
    static func priceCard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 150, height: 80))
        f.oval(14, 74, 122, 6, 0x1E1E1C, 0.14)
        f.svgLine("M40 60L32 78M110 60L118 78", 0x3E4C55, 2.6)
        f.rect(4, 2, 142, 60, 0x3E4C55, radius: 4)
        f.rect(8, 6, 134, 52, 0xFFFDF6, radius: 2)
        f.text(p.text ?? "", PropFont.heavy(17), 0x1F3A6B, at: CGPoint(x: 31, y: 32), maxWidth: 42)
        f.svgLine("M55 28H63M55 35H63", 0x1F3A6B, 2.2)
        let icons = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:))
        for (i, icon) in icons.prefix(3).enumerated() {
            let x = 70 + CGFloat(i) * 24
            icon.draw(f, in: CGRect(x: x, y: 18, width: 20, height: 20), color: 0x1F3A6B, detail: 0xFFFDF6)
            f.dot(x + 10, 47, 6, 0x1E7A4C)
            f.svgLine("M\(x + 7) 47L\(x + 9.4) 49.4L\(x + 13.4) 44.4", 0xFFFDF6, 1.8)
        }
    }
}
