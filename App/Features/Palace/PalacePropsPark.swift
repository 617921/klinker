import SwiftUI

/// Park props: a duck pond, a bench, a mown lawn with a goal, a playground, an event stage,
/// litter next to a bin, and a road sign on a pole (round or square, any pictogram).
enum PalaceParkProps {
    // MARK: Pond

    /// An oval pond with two ducks, a lily pad and reeds (140 × 60).
    static func duckPond(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 140, height: 60))
        f.oval(0, 9, 140, 50, 0xCDBF9E)
        f.oval(4, 12, 132, 44, 0x8FB6CF)
        f.oval(11, 16, 116, 35, 0xA9CBE0)
        f.svgLine("M24 40H38M76 46H94M54 25H66M98 30H108", 0xFFFFFF, 1.3, 0.75)
        f.oval(20, 36, 14, 7, 0x5E8C45)
        f.svg("M27 39.5L34 37.5L33 40.5Z", 0xA9CBE0)
        f.oval(104, 41, 11, 5.5, 0x6E9C52)
        duck(f, 48, 32, body: 0xFFFDF6, head: 0xFFFDF6, wing: 0xD3D1C7, left: false)
        duck(f, 86, 38, body: 0x8C5E38, head: 0x0F6E56, wing: 0x6B4A2E, left: true)
        f.svgLine("M122 42L120 10M127 43L129 6M132 44L136 14M117 44L113 18", 0x4E7A3A, 1.6)
        f.rect(118.5, 10, 3.6, 10, 0x6B4A2E, radius: 1.8)
        f.rect(127.4, 6, 3.6, 10, 0x6B4A2E, radius: 1.8)
        f.svg("M120 30Q126 22 128 14Q124 24 122 32Z", 0x5E8C45)
    }

    /// A floating duck centred on (x, y), facing right (or left).
    static func duck(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, body: UInt32, head: UInt32, wing: UInt32, left: Bool) {
        let s: CGFloat = left ? -1 : 1
        f.svgLine("M\(x - 12) \(y + 5)H\(x + 12)", 0xFFFFFF, 1.2, 0.7)
        f.svg("M\(x - 11 * s) \(y - 3)L\(x - 15 * s) \(y - 7)L\(x - 8 * s) \(y - 4)Z", body)
        f.oval(x - 11, y - 6, 22, 11, body)
        f.oval(x - 6 - (left ? 6 : 0), y - 4.5, 12, 6, wing)
        f.dot(x + 9 * s, y - 8, 4.6, head)
        f.svg("M\(x + 12.5 * s) \(y - 9)L\(x + 18 * s) \(y - 7.5)L\(x + 12.5 * s) \(y - 6)Z", 0xF2711C)
        f.dot(x + 10 * s, y - 9, 0.9, 0x1E1E1C)
        if head != body { f.svgLine("M\(x + 6 * s) \(y - 4)H\(x + 10 * s)", 0xFFFDF6, 1.4) }
    }

    // MARK: Bench

    /// A park bench with wooden slats and a dark iron frame (100 × 60).
    static func bench(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 60))
        f.oval(4, 53, 92, 7, 0x1E1E1C, 0.15)
        f.svgLine("M12 4V36M88 4V36", 0x2F4337, 3)
        for y in [6.0, 16.0] as [CGFloat] {
            f.rect(7, y, 86, 7, 0xC9965F, radius: 1.5)
            f.rect(7, y + 5.5, 86, 1.5, 0x9A6A42)
        }
        f.rect(3, 29, 94, 7, 0xC9965F, radius: 1.5)
        f.rect(3, 35, 94, 3, 0x9A6A42)
        f.svgLine("M12 38L9 56M88 38L91 56M22 38L24 53M78 38L76 53", 0x2F4337, 3)
        f.svgLine("M5 27Q9 22 17 24M95 27Q91 22 83 24", 0x2F4337, 3)
    }

    // MARK: Lawn

    /// A mown lawn in stripes with a little goal and a ball (124 × 62).
    static func lawn(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 124, height: 62))
        let n = 6
        for i in 0..<n {
            let t0 = CGFloat(i) / CGFloat(n), t1 = CGFloat(i + 1) / CGFloat(n)
            let d = "M\(16 + 92 * t0) 8H\(16 + 92 * t1)L\(124 * t1) 60H\(124 * t0)Z"
            f.svg(d, i % 2 == 0 ? 0x8DB061 : 0x7AA352)
        }
        f.svgLine("M16 8H108L124 60H0Z", 0xFFFDF6, 1.6)
        f.svgLine("M8 34H116", 0xFFFDF6, 1.2)
        f.svgLine("M50 8V0H74V8", 0xFFFDF6, 2.2)
        f.svgLine("M53 2H71M53 5H71M56 0V8M62 0V8M68 0V8", 0xD3D1C7, 0.8)
        f.dot(78, 44, 6, 0xFFFDF6)
        f.svg("M78 41.5L80.5 43.3L79.6 46.2H76.4L75.5 43.3Z", 0x1E1E1C)
        f.svgLine("M72.4 42L75.5 43.3M83.6 42L80.5 43.3M76.4 46.2L75 49.4M79.6 46.2L81 49.4M78 41.5V38.2", 0x1E1E1C, 0.9)
        f.oval(72, 49, 12, 3, 0x1E1E1C, 0.15)
    }

    // MARK: Playground

    /// A slide with its ladder and a swing frame on a patch of sand (120 × 100).
    static func playground(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 120, height: 100))
        f.oval(0, 82, 120, 16, 0xE8D6A8)
        f.svgLine("M14 92L22 30M28 92L34 30", 0x5E6B73, 2.6)
        f.svgLine("M16 80H27M17.6 68H28.6M19.2 56H30.2M20.8 44H31.8", 0x5E6B73, 2)
        f.rect(20, 26, 18, 5, 0x3E4C55, radius: 1)
        f.svgLine("M37 30Q48 32 53 56Q58 82 76 90", 0xC8261B, 8)
        f.svgLine("M38 28Q49 30 54 54", 0xF2711C, 2.4)
        f.svgLine("M80 94L88 24L96 94M98 94L106 24L114 94", 0x2F5BD3, 3)
        f.svgLine("M86 24H108", 0x1F3A6B, 3.4)
        f.svgLine("M93 25V68M101 25V68", 0x4A3524, 1.2)
        f.rect(90, 67, 14, 4, 0xF2711C, radius: 1)
    }

    // MARK: Stage

    /// An open-air stage under a truss with lights, speakers, a singer, music notes, bunting and
    /// a banner with `text` ("za 14 juli") (120 × 104).
    static func stage(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 120, height: 104))
        f.oval(2, 97, 116, 7, 0x1E1E1C, 0.14)
        f.rect(11, 22, 98, 50, 0x3C3489)
        f.svgLine("M30 24V70M50 24V70M70 24V70M90 24V70", 0x2E2870, 2)
        f.svg("M24 23L14 70H40Z M96 23L80 70H106Z", 0xFAC775, 0.28)
        f.rect(6, 16, 5, 82, 0x5E6B73)
        f.rect(109, 16, 5, 82, 0x5E6B73)
        f.rect(6, 14, 108, 8, 0x5E6B73)
        var zig = "M8 21"
        for x in stride(from: 14.0, through: 112, by: 6) { zig += "L\(x) \(x.truncatingRemainder(dividingBy: 12) == 2 ? 15 : 21)" }
        f.svgLine(zig, 0x8E8A80, 1)
        f.dot(24, 24, 3.2, 0x1E1E1C)
        f.dot(96, 24, 3.2, 0x1E1E1C)
        let notes: [(CGFloat, CGFloat)] = [(36, 38), (80, 32), (90, 48)]
        for (x, y) in notes {
            f.oval(x - 4, y + 6, 6.5, 5, 0xFAC775)
            f.svgLine("M\(x + 2) \(y + 8)V\(y - 2)L\(x + 7) \(y)", 0xFAC775, 1.6)
        }
        PalaceFigures.mini(f.within(CGRect(x: 48, y: 22, width: 24, height: 48), unit: 0.8), PalaceFigures.Look.at(5), walking: false, briefcase: false)
        f.svgLine("M64 40L66 30", 0x1E1E1C, 1.4)
        f.dot(66, 29, 1.8, 0x1E1E1C)
        f.rect(14, 48, 13, 22, 0x1E1E1C, radius: 1.5)
        f.rect(93, 48, 13, 22, 0x1E1E1C, radius: 1.5)
        f.ring(20.5, 61, 4, 0x5E6B73, 1.6)
        f.ring(99.5, 61, 4, 0x5E6B73, 1.6)
        f.rect(2, 70, 116, 6, 0x4A3524)
        f.rect(4, 76, 112, 22, 0x2E2117)
        let flags: [UInt32] = [0xC8261B, 0xFAC775, 0x2F5BD3, 0xF2711C, 0x0F6E56]
        for i in 0..<9 {
            let x = 14 + CGFloat(i) * 11.5
            f.svg("M\(x - 4) 22H\(x + 4)L\(x) 30Z", flags[i % flags.count])
        }
        if let text = p.text {
            f.svgLine("M30 0V8M90 0V8", 0x5E6B73, 1.4)
            f.rect(24, 0, 72, 15, 0xFFFDF6, radius: 1.5)
            f.stroke(Path(roundedRect: CGRect(x: 24, y: 0, width: 72, height: 15), cornerRadius: 1.5), 0xC8261B, 1.2)
            f.text(text, PropFont.heavy(10), 0xC8261B, at: CGPoint(x: 60, y: 7.8), maxWidth: 66)
        }
    }

    // MARK: Litter

    /// Paper, a can, a bottle and a crisp bag lying on the grass next to a park bin (92 × 66).
    static func litter(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 92, height: 66))
        f.oval(0, 50, 92, 10, 0x1E1E1C, 0.1)
        f.rect(70, 34, 4, 26, 0x2F4337)
        f.svg("M62 6H90L87.5 44H64.5Z", 0x3F5A4A)
        f.rect(60, 3, 32, 6, 0x2F4337, radius: 2)
        f.svgLine("M68 16V38M76 16V38M84 16V38", 0x2F4337, 1.4)
        f.svg("M24 14C22 8 29 4 35 7L43 11C45 16 43 22 38 24L30 23C27 22 25 19 24 14Z", 0xFAC775)
        f.svgLine("M29 11L39 18M27 17L33 21", 0xF2711C, 1.8)
        f.svg("M5 40C2 33 10 28 16 31C22 27 30 33 26 40C29 47 20 52 14 48C8 52 1 47 5 40Z", 0xFFFDF6)
        f.svgLine("M9 37L16 41L22 35M12 46L17 41", 0xB4B2A9, 1.2)
        let bottle = Path(roundedRect: CGRect(x: -14, y: -5, width: 28, height: 10), cornerRadius: 4.5)
            .applying(CGAffineTransform(rotationAngle: -0.25).concatenating(CGAffineTransform(translationX: 44, y: 32)))
        f.fill(bottle, 0x5E8C45, 0.9)
        f.svgLine("M57 27.6L62 26.3", 0x5E8C45, 3.6)
        f.svgLine("M38 30.6L48 28", 0xFFFFFF, 1.4)
        let can = Path(roundedRect: CGRect(x: -10, y: -5.5, width: 20, height: 11), cornerRadius: 2.5)
            .applying(CGAffineTransform(rotationAngle: 0.3).concatenating(CGAffineTransform(translationX: 40, y: 48)))
        f.fill(can, 0xC8261B)
        f.svgLine("M32.4 41.4L30.4 46.6", 0xD3D1C7, 3)
        f.svgLine("M2 58Q7 55 12 58M48 60Q52 57 56 60", 0x7FA650, 1.2)
    }

    // MARK: Road sign

    /// A road sign: `variant` 0 round, 1 square plate; `tone` "blue" | "white" | "yellow";
    /// `icons` in a row on it. `mount` "pole" (default) puts it on a grey pole down to the ground.
    static func roadSign(_ pen: PropPen, _ p: PalacePropParams) {
        let (w, h) = (pen.size.width, pen.size.height)
        let (back, border, ink): (UInt32, UInt32, UInt32) = switch p.tone {
        case "white": (0xFFFDF6, 0x1E1E1C, 0x1E1E1C)
        case "yellow": (0xFAC775, 0x1E1E1C, 0x1E1E1C)
        default: (0x2F5BD3, 0xFFFDF6, 0xFFFDF6)
        }
        let icons = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:))
        let round = (p.variant ?? 0) == 0
        let plateW = min(w - 2, round ? 46 : w - 2)
        let plateH = round ? plateW : min(h * 0.62, plateW * CGFloat(0.42 + 0.3 / Double(max(1, icons.count))))
        let plate = CGRect(x: (w - plateW) / 2, y: 1, width: plateW, height: plateH)
        if (p.mount ?? "pole") == "pole" {
            pen.oval(w / 2 - 9, h - 4, 18, 4, 0x1E1E1C, 0.16)
            pen.rect(w / 2 - 2, plate.midY, 4, h - plate.midY - 2, 0x5E6B73)
            pen.rect(w / 2 - 2, plate.midY, 1.4, h - plate.midY - 2, 0x7D8A92)
        }
        if round {
            pen.fill(Path(ellipseIn: plate), 0x1E1E1C, 0.25)
            pen.fill(Path(ellipseIn: plate.insetBy(dx: 0.8, dy: 0.8)), border)
            pen.fill(Path(ellipseIn: plate.insetBy(dx: 3.4, dy: 3.4)), back)
        } else {
            pen.rect(plate, border, radius: 3)
            pen.rect(plate.insetBy(dx: 2.4, dy: 2.4), back, radius: 2)
        }
        guard !icons.isEmpty else { return }
        let inner = plate.insetBy(dx: round ? plateW * 0.2 : 7, dy: round ? plateW * 0.2 : 5)
        let n = CGFloat(icons.count)
        let side = min(inner.height, (inner.width - 4 * (n - 1)) / n)
        var x = inner.midX - (side * n + 4 * (n - 1)) / 2
        for icon in icons {
            icon.draw(pen, in: CGRect(x: x, y: inner.midY - side / 2, width: side, height: side), color: ink, detail: back)
            x += side + 4
        }
    }
}
