import SwiftUI

/// Harbour props: a moored ship, lock gates, a sailing boat, a tossing boat with a seasick
/// passenger, a bollard on the quay edge, goods on a pallet, a container truck and a finger post.
enum G7HarbourProps {
    // MARK: Ship

    /// A moored ship (190 × 130): hull (`variant` 0 navy, 1 green, 2 red) with a red band at the
    /// waterline, white bridge, funnel, hatches, a mast and an anchor at the bow.
    static func ship(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 190, height: 130))
        let hull: UInt32 = [0x1F3A6B, 0x0F6E56, 0x7A1E1E][((p.variant ?? 0) % 3 + 3) % 3]
        f.oval(4, 116, 182, 10, 0x1E3A55, 0.25)
        f.svgLine("M150 70V12M150 22L178 66M150 22L122 66", 0x3E4C55, 1.6)
        f.svg("M144 14H156L150 6Z", 0xFAC775)
        f.rect(84, 60, 26, 16, 0x3F5A4A, radius: 1)
        f.rect(114, 60, 26, 16, 0x3F5A4A, radius: 1)
        f.svgLine("M90 60V76M97 60V76M104 60V76M120 60V76M127 60V76M134 60V76", 0x2F4337, 1)
        // Bridge and funnel
        f.rect(36, 6, 18, 28, 0xF2711C, radius: 1.5)
        f.rect(36, 6, 18, 6, 0x1E1E1C, radius: 1.5)
        f.rect(36, 18, 18, 4, 0xFFFDF6)
        f.rect(18, 30, 60, 46, 0xFFFDF6, radius: 2)
        f.rect(12, 30, 72, 6, 0xEFEBE2, radius: 1.5)
        f.rect(22, 40, 52, 8, 0x3E4C55, radius: 1)
        f.svgLine("M30 40V48M40 40V48M50 40V48M60 40V48M70 40V48", 0xFFFDF6, 1.4)
        f.rect(22, 54, 52, 5, 0x8FB6CF, radius: 1)
        f.rect(22, 63, 52, 5, 0x8FB6CF, radius: 1)
        // Hull
        f.svg("M2 74H160L188 60L178 114H12Z", hull)
        f.svg("M6 102H182L178 114H12Z", 0xC8261B)
        f.svg("M2 74H160L188 60L187 66L161 80H3Z", 0xFFFDF6)
        for x in stride(from: CGFloat(24), to: 150, by: 18) { f.dot(x, 90, 2.6, 0xA9CBE0) }
        f.ring(170, 84, 2.4, 0xD3D1C7, 1.4)
        f.svgLine("M170 86.4V96M166 92Q170 98 174 92M167 89H173", 0xD3D1C7, 1.6)
        f.svgLine("M10 120H60M80 122H140M150 119H180", 0xFFFFFF, 1.4)
    }

    // MARK: Lock

    /// Lock gates seen from the low side (96 × 118): stone walls, two wooden gates under a walkway
    /// with white balance beams, the high water showing above them, a red and green light, and
    /// a little boat waiting on the low water.
    static func lock(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 118))
        f.rect(14, 26, 68, 12, 0x8FB6CF)
        f.rect(14, 26, 68, 3, 0xA9CBE0)
        f.svg("M0 30H16V118H0Z M80 30H96V118H80Z", 0xA19E95)
        f.svgLine("M0 46H16M0 62H16M0 78H16M0 94H16M80 46H96M80 62H96M80 78H96M80 94H96", 0x8E8A80, 1.2)
        f.svgLine("M8 30V46M4 46V62M10 62V78M80 30V46M88 46V62M84 62V78", 0x8E8A80, 1)
        f.rect(16, 36, 32, 66, 0x4A3524)
        f.rect(48, 36, 32, 66, 0x5C4230)
        f.svgLine("M18 52H78M18 68H78M18 84H78", 0x2E2117, 1.6)
        f.svgLine("M18 100L46 38M50 100L78 38", 0x2E2117, 1.4)
        f.svgLine("M48 36V102", 0x1E1E1C, 1.4)
        f.svgLine("M47 98Q46 104 45 108M50 98Q51 104 52 108", 0xFFFFFF, 1.2)
        // Walkway and balance beams
        f.rect(12, 32, 72, 5, 0x6B4A2E)
        f.svgLine("M12 28H84", 0x2E2117, 1.2)
        f.svgLine("M14 28V32M30 28V32M48 28V32M66 28V32M82 28V32", 0x2E2117, 1)
        f.svgLine("M18 34L-2 20M78 34L98 20", 0xFFFDF6, 5)
        f.svgLine("M10 28.5L6 25.8M2 23L-2 20.4M86 28.5L90 25.8M94 23L98 20.4", 0xC8261B, 5)
        // Lights on a post
        f.rect(84, 2, 12, 22, 0x2E2117, radius: 2)
        f.dot(90, 8, 3.4, 0xC8261B)
        f.dot(90, 18, 3.4, 0x1E7A4C, 0.45)
        f.rect(88.5, 24, 3, 8, 0x3E4C55)
        // Low water with a waiting boat
        f.rect(16, 102, 64, 16, 0x7FA7C0)
        f.svg("M24 104H64L60 114H28Z", 0xC8261B)
        f.rect(32, 96, 16, 8, 0xFFFDF6, radius: 1)
        f.rect(34, 98, 5, 3, 0x3E4C55)
        f.svgLine("M18 116H78", 0xFFFFFF, 1, 0.7)
    }

    // MARK: Boats

    /// A small sailing boat under way (76 × 88): two sails (`variant` jib colour), a sailor at the
    /// helm, a wake and spray.
    static func sailboat(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 88))
        let jib: UInt32 = [0xC8261B, 0x2F5BD3, 0xF2711C][((p.variant ?? 0) % 3 + 3) % 3]
        f.svgLine("M2 82Q10 78 18 80M0 74Q8 72 14 73", 0xFFFFFF, 1.6, 0.85)
        f.svgLine("M38 4V70", 0x4A3524, 2)
        f.svg("M36 6L36 66H6Z", 0xFFFDF6)
        f.svg("M40 10L40 64H66Z", jib)
        f.svgLine("M36 40H18", 0xD3D1C7, 1)
        f.svg("M4 70H72L64 84H12Z", 0xFFFDF6)
        f.svg("M6 74H70L68 78H8Z", 0x2F5BD3)
        f.dot(18, 64, 4.6, 0xE8C4A0)
        f.svg("M13 63Q13 57 18 57Q23 57 23 63Z", 0xFAC775)
        f.rect(13, 66, 10, 6, 0xF2711C, radius: 2)
        f.svgLine("M68 84Q72 80 76 82M58 86Q66 82 72 86", 0xFFFFFF, 1.6, 0.85)
    }

    /// A little boat tossed by high waves (86 × 72), a passenger with a green face hanging over
    /// the rail, dizzy swirls over the head.
    static func seasickBoat(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 86, height: 72))
        var b = f
        b.ctx.translateBy(x: 43, y: 44)
        b.ctx.rotate(by: .degrees(-12))
        b.ctx.translateBy(x: -43, y: -44)
        b.rect(18, 22, 40, 18, 0xFFFDF6, radius: 2)
        b.rect(22, 26, 9, 6, 0x3E4C55, radius: 1)
        b.rect(35, 26, 9, 6, 0x3E4C55, radius: 1)
        b.svgLine("M10 40V30H62", 0x5E6B73, 1.6)
        b.svg("M4 40H78L70 56H12Z", 0xC8261B)
        b.svg("M5 44H77L75 48H7Z", 0xFFFDF6)
        // Passenger leaning over the rail
        b.svg("M54 40L50 22Q52 16 58 18L64 36Z", 0x2F5BD3)
        b.dot(66, 26, 7, 0xA9C47F)
        b.svg("M59 23Q60 17 66 17Q72 17 72 23Q69 20 66 20Q62 20 59 23Z", 0x4A3524)
        b.svgLine("M66 33L72 40", 0x2F5BD3, 4.5)
        b.dot(73, 41, 2.6, 0xA9C47F)
        b.svgLine("M64.5 24.5L67.5 27.5M67.5 24.5L64.5 27.5", 0x2E2117, 1.2)
        f.svgLine("M58 6Q62 1 66 6Q70 11 74 6M62 12Q65 9 68 12", 0x5E8C45, 1.6)
        f.svg("M0 56Q12 44 24 56Q36 68 48 56Q60 44 72 56Q80 64 86 58V72H0Z", 0x7FA7C0)
        f.svgLine("M0 56Q12 44 24 56Q36 68 48 56Q60 44 72 56Q80 64 86 58", 0xFFFFFF, 2, 0.85)
    }

    // MARK: Quay

    /// The quay edge (58 × 66): a stretch of coping stones with a black iron bollard and a thick
    /// rope looped round it, running up and away to a ship.
    static func bollard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 58, height: 66))
        f.rect(0, 24, 58, 11, 0xC9C6BC)
        f.rect(0, 24, 58, 2, 0xE3E1D8)
        f.svgLine("M20 24V35M44 24V35", 0x8E8A80, 1)
        f.oval(12, 26, 30, 6, 0x1E1E1C, 0.25)
        f.svg("M16 29V16Q16 12 20 10H34Q38 12 38 16V29Z", 0x2E2117)
        f.oval(12, 4, 30, 10, 0x2E2117)
        f.oval(14, 4, 26, 6, 0x4A4A44)
        f.svgLine("M15 19Q27 26 39 19", 0xC9A15B, 4.5)
        f.svgLine("M15 19Q27 13 39 19", 0xD9B26B, 4.5)
        f.svgLine("M39 19Q48 12 58 1", 0xC9A15B, 4.5)
        f.svgLine("M20 21L22 18M26 22L28 19M32 21L34 18M45 14L47 11M51 8L53 5", 0x9A7A3E, 1.2)
    }

    /// Goods on a pallet (100 × 86): cardboard boxes, a crate, sacks and barrels.
    static func goods(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 86))
        f.oval(0, 78, 100, 8, 0x1E1E1C, 0.15)
        f.rect(2, 74, 96, 7, 0xC9965F)
        f.svgLine("M10 81V74M50 81V74M90 81V74", 0x8A5C38, 3)
        for (x, y, w, h) in [(4.0, 46.0, 26.0, 28.0), (30, 52, 22, 22), (8, 20, 22, 26), (12, 0, 16, 20)] as [(CGFloat, CGFloat, CGFloat, CGFloat)] {
            f.rect(x, y, w, h, 0xC9965F, radius: 1)
            f.rect(x + w / 2 - 2.5, y, 5, h, 0xE2D6BC)
            f.rect(x, y, w, 3, 0xB07F4E)
        }
        f.svg("M54 74Q52 56 58 50Q64 46 70 50Q76 56 74 74Z", 0xD9C08F)
        f.svg("M61 51L58 44H70L67 51Z", 0xC9AE7A)
        f.svgLine("M58 63H70", 0xB49A66, 1.2)
        for x in [76.0, 87] as [CGFloat] {
            f.rect(x, 44, 12, 30, 0x9A6A42, radius: 4)
            f.svgLine("M\(x) 50H\(x + 12)M\(x) 67H\(x + 12)", 0x5E6B73, 2)
        }
        f.rect(56, 26, 42, 18, 0x5E8C45, radius: 1)
        f.svgLine("M62 26V44M70 26V44M78 26V44M86 26V44M92 26V44", 0x4E7A3A, 1.4)
        f.svg("M58 24Q56 10 64 6Q72 10 70 24Z", 0xD9C08F)
        f.svg("M61 9L59 3H69L67 9Z", 0xC9AE7A)
    }

    /// A truck taking a container away (130 × 72): `variant` container colour, speed lines and an
    /// arrow above.
    static func truck(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 130, height: 72))
        let box: UInt32 = [0x2F5BD3, 0x0F6E56, 0xF2711C, 0xC8261B][((p.variant ?? 0) % 4 + 4) % 4]
        f.oval(10, 64, 118, 8, 0x1E1E1C, 0.16)
        f.svgLine("M0 34H12M2 44H16M0 54H10", 0xB4B2A9, 2)
        f.rect(16, 54, 112, 6, 0x3E4C55)
        f.rect(18, 20, 76, 34, box, radius: 1.5)
        f.svgLine("M26 22V52M34 22V52M42 22V52M50 22V52M58 22V52M66 22V52M74 22V52M82 22V52", PalaceInk.shade(box, 0.8), 1.6)
        f.svg("M98 30H116Q120 30 122 36L128 46V58H98Z", 0xC8261B)
        f.svg("M104 34H115L120 44H104Z", 0x3E4C55)
        f.rect(124, 50, 4, 4, 0xFAC775)
        for x in [32.0, 48, 112] as [CGFloat] {
            f.dot(x, 62, 7.5, 0x1E1E1C)
            f.dot(x, 62, 3, 0x7D8A92)
        }
        f.svgLine("M40 8H86", 0xF2711C, 3.4)
        f.svg("M84 1L96 8L84 15Z", 0xF2711C)
    }

    // MARK: Finger post

    /// A finger post (70 × 116; 116 × 116 with `mount` "road"): arms from `lines` "place|distance"
    /// pointing alternately right and left, an `icons` picture on top of the pole.
    static func signpost(_ pen: PropPen, _ p: PalacePropParams) {
        let road = p.mount == "road"
        let f = pen.fitted(CGSize(width: road ? 116 : 70, height: 116))
        let x: CGFloat = road ? 30 : 35
        if road {
            f.svg("M54 116C62 98 96 96 100 84C102 76 94 72 101 64H102.5C98 72 106 78 104 86C98 100 74 102 80 116Z", 0xE2D6BC)
            f.rect(98, 58, 9, 6, 0xD9CDB4)
            f.svg("M96.5 58.5L102.5 53.5L108.5 58.5Z", 0x9A5238)
            f.rect(101.5, 61, 2, 3, 0x4A3524)
            f.dot(112, 61, 3, 0x5E8C45)
        }
        f.oval(x - 10, 111, 20, 5, 0x1E1E1C, 0.15)
        f.rect(x - 2.5, 16, 5, 98, 0xEFEBE2)
        f.rect(x - 2.5, 16, 1.6, 98, 0xFFFDF6)
        if let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first {
            f.dot(x, 10, 10, 0x2F5BD3)
            icon.draw(f, in: CGRect(x: x - 8, y: 2, width: 16, height: 16), color: 0xFFFDF6, detail: 0x2F5BD3)
        }
        let colors: [UInt32] = [0xFFFDF6, 0xFAC775, 0xFFFDF6, 0xFAC775]
        for (i, line) in (p.lines ?? []).prefix(4).enumerated() {
            let cells = line.split(separator: "|").map(String.init)
            let right = i % 2 == 0
            let y = 24 + CGFloat(i) * 19
            let (x0, x1) = right ? (x - 6, x + 34) : (x - 34, x + 6)
            let tip = right ? "M\(x0) \(y)H\(x1)L\(x1 + 6) \(y + 7.5)L\(x1) \(y + 15)H\(x0)Z" : "M\(x1) \(y)H\(x0)L\(x0 - 6) \(y + 7.5)L\(x0) \(y + 15)H\(x1)Z"
            f.svg(tip, 0x1E1E1C, 0.2)
            f.svg(tip, colors[i])
            f.svgLine(tip, 0x1F3A6B, 1)
            let mid = (x0 + x1) / 2 + (right ? 2 : -2)
            f.text(cells[0], PropFont.condensed(8.5), 0x1F3A6B, at: CGPoint(x: mid, y: y + 5), maxWidth: 38)
            if cells.count > 1 { f.text(cells[1], PropFont.mono(6.5), 0xC8261B, at: CGPoint(x: mid, y: y + 11.5), maxWidth: 38) }
        }
    }
}
