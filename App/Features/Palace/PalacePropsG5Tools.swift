import SwiftUI

/// The DIY store: tools on the shelves and the counter, and a sturdy shelf next to a flimsy one.
enum G5Tools {
    private static let metal: UInt32 = 0xB4B2A9
    private static let metalDark: UInt32 = 0x8A8A82
    private static let wood: UInt32 = 0xC9965F

    /// One tool scene (76 × 50 on a shelf, 78 × 54 on the counter). `accessory`:
    /// "drill" (a cordless drill with a bit, a plank with a fresh hole), "screw" (a big screw with
    /// its thread and cross head, a box of them), "nail" (a nail driven into a plank, the hammer
    /// coming down), "paint" (tins, one open with a drip, and a fan of colour cards), "brushes"
    /// (brushes in a jar, a wet one in front), "toolbox" (an open toolbox full of tools), "tighten"
    /// (a hand turning a screwdriver into a hinge, a round arrow). `tone` the main colour.
    static func tool(_ pen: PropPen, _ p: PalacePropParams) {
        let item = p.accessory ?? "drill"
        let counter = item == "toolbox" || item == "tighten"
        let f = pen.fitted(CGSize(width: counter ? 78 : 76, height: counter ? 54 : 50))
        let tone = PropColor.named(p.tone, 0xF2711C)
        switch item {
        case "screw":
            f.rect(50, 3, 25, 22, 0xC99A6A, radius: 1.5)
            f.rect(50, 3, 25, 5, 0xB0835A, radius: 1.5)
            f.rect(53, 11, 19, 10, 0xFFFDF6, radius: 1)
            f.svgLine("M56 16H68", metalDark, 2)
            f.svgLine("M68 16L71 16", metalDark, 1)
            screw(f, from: CGPoint(x: 14, y: 12), to: CGPoint(x: 58, y: 44), head: 8)
            screw(f, from: CGPoint(x: 52, y: 29), to: CGPoint(x: 70, y: 34), head: 3.2)
        case "nail":
            f.rect(2, 34, 72, 14, wood, radius: 1.5)
            f.svgLine("M6 39H30M38 43H70M10 45H24", 0xA87A4A, 1)
            f.rect(36.5, 14, 3, 21, metal)
            f.rect(36.5, 14, 1, 21, 0xD3D1C7)
            f.oval(31, 11, 14, 4.5, metalDark)
            f.svgLine("M44 6L72 -2", 0x8C5E38, 4)
            f.rect(30, 0, 16, 9, 0x3E4C55, radius: 1.5)
            f.svgLine("M26 7L22 5M27 12L22 13M50 12L55 14", 0xC8261B, 1.3)
            for y in [24.0, 29.0] as [CGFloat] {
                f.line(6, y, 22, y, metal, 1.6)
                f.rect(4, y - 2.2, 2.2, 4.4, metalDark, radius: 0.6)
            }
        case "paint":
            tin(f, x: 2, top: 14, w: 26, h: 34, label: tone, open: tone)
            tin(f, x: 30, top: 20, w: 22, h: 28, label: 0x2F5BD3, open: nil)
            for (i, c) in [0x5DCAA5, 0xFAC775, 0xC8261B, 0x2F5BD3].enumerated() as EnumeratedSequence<[UInt32]> {
                var card = f.within(CGRect(x: 60, y: 30, width: 16, height: 20))
                card.ctx.rotate(by: .degrees(Double(i) * 16 - 40))
                card.rect(-2, -26, 7, 26, 0xFFFDF6, radius: 1)
                card.rect(-1.2, -25, 5.4, 14, c, radius: 0.6)
            }
        case "brushes":
            f.rect(6, 22, 30, 26, 0xD3E0E6, radius: 3, 0.85)
            for (i, x) in [12.0, 21, 30].enumerated() {
                let lean = CGFloat(i - 1) * 3
                f.svgLine("M\(x - lean) 44L\(x) 16", 0x9A6A42, 3)
                f.rect(x - 4, 8, 8, 6, metal, radius: 0.8)
                f.svg("M\(x - 4.5) 8V1Q\(x) -1 \(x + 4.5) 1V8Z", [0xE2C9A0, 0xC9A15B, 0xE2C9A0][i])
            }
            f.stroke(Path(roundedRect: CGRect(x: 6, y: 22, width: 30, height: 26), cornerRadius: 3), 0x8A9AA0, 1)
            f.svgLine("M42 42L58 30", 0x9A6A42, 4.2)
            f.svg("M57 26L63 23L70 33L64 36Z", metal)
            f.svg("M64 36L70 33L76 42Q74 46 70 46Z", 0xE2C9A0)
            f.svg("M70 39L76 42Q74 46 70 46L68 42Z", tone)
            f.dot(71, 48.5, 1.6, tone)
        case "toolbox":
            f.svg("M8 18L4 4H74L70 18Z", 0xA3221B)
            f.svg("M4 26H74V52H4Z", 0xC8261B)
            f.rect(4, 26, 70, 5, 0xA3221B)
            f.svgLine("M16 36L54 14", 0x8C5E38, 3.6)
            f.rect(48, 9, 15, 7, 0x3E4C55, radius: 1)
            f.svg("M18 34L38 6L46 10L28 36Z", metal)
            f.svgLine("M38 6L28 36", metalDark, 1)
            f.svgLine("M58 34L66 12", 0xFAC775, 4)
            f.svgLine("M66 12L69 4", metalDark, 1.6)
            f.svgLine("M44 34L50 18M47 34L56 19", metalDark, 2.4)
            f.rect(4, 28, 70, 24, 0xC8261B, radius: 1.5)
            f.rect(30, 34, 18, 6, 0x7A1E1E, radius: 2)
            f.svgLine("M4 40H74", 0xA3221B, 1)
        case "tighten":
            f.rect(2, 8, 40, 44, wood, radius: 1.5)
            f.svgLine("M6 20H36M8 34H38M5 46H22", 0xA87A4A, 1)
            f.rect(24, 16, 12, 26, metal, radius: 1.5)
            f.dot(30, 21, 2.2, metalDark)
            f.dot(30, 37, 2.2, metalDark)
            f.dot(30, 29, 3, metalDark)
            f.svgLine("M28.4 29H31.6M30 27.4V30.6", 0x5E6B73, 0.9)
            f.svgLine("M31 29H50", metalDark, 2.4)
            f.rect(48, 23, 24, 12, tone, radius: 5)
            f.svgLine("M54 24V34M60 24V34M66 24V34", PalaceInk.shade(tone, 0.8), 1)
            f.svg("M50 34C49 40 53 44 60 44C66 44 70 41 70 36L68 33H52Z", 0xC99A74)
            f.svgLine("M54 37H66M55 40.5H65", PalaceInk.shade(0xC99A74, 0.82), 0.9)
            f.svgLine("M70 42L78 50", 0x2F5BD3, 6)
            f.svgLine("M48 13A15 15 0 0 1 74 16", 0x1E7A4C, 2.2)
            f.svg("M72 10L77 18L69 18Z", 0x1E7A4C)
        default:
            f.svgLine("M58 15H72", metalDark, 1.4)
            f.svgLine("M60 15L62 13M63 15L65 13M66 15L68 13M69 15L71 13", metalDark, 0.9)
            f.svg("M56 11L60 12V18L56 19Z", metalDark)
            f.svg("M10 6H46Q54 6 54 15Q54 24 46 24H10Q6 24 6 15Q6 6 10 6Z", tone)
            f.svgLine("M14 10V20M18 10V20", PalaceInk.shade(tone, 0.8), 1.2)
            f.svg("M24 23H36L32 41H18Z", 0x3E4C55)
            f.svg("M36 23Q38 26 35 29L33 27Z", 0x2E2117)
            f.rect(12, 40, 26, 9, 0x2E2117, radius: 2)
            f.rect(14, 42, 8, 2, tone, radius: 1)
            f.rect(62, 30, 14, 18, wood, radius: 1)
            f.dot(69, 36, 2.6, 0x5E4A36)
            for (x, y) in [(66.0, 44.0), (72, 45), (69, 47)] as [(CGFloat, CGFloat)] { f.dot(x, y, 0.9, 0xE2C9A0) }
        }
    }

    /// A screw from its head to its tip, with a thread and a cross in the head.
    private static func screw(_ f: PropPen, from a: CGPoint, to b: CGPoint, head r: CGFloat) {
        let dx = b.x - a.x, dy = b.y - a.y, len = hypot(dx, dy)
        let (ux, uy) = (dx / len, dy / len)
        let w = r * 0.55
        f.svg("M\(a.x - uy * w) \(a.y + ux * w)L\(b.x - ux * r * 0.6 - uy * w * 0.6) \(b.y - uy * r * 0.6 + ux * w * 0.6)L\(b.x) \(b.y)L\(b.x - ux * r * 0.6 + uy * w * 0.6) \(b.y - uy * r * 0.6 - ux * w * 0.6)L\(a.x + uy * w) \(a.y - ux * w)Z", metal)
        var thread = Path()
        var t = r * 1.2
        while t < len - r * 0.8 {
            let c = CGPoint(x: a.x + ux * t, y: a.y + uy * t)
            thread.move(to: CGPoint(x: c.x - uy * w * 1.15 - ux * r * 0.25, y: c.y + ux * w * 1.15 - uy * r * 0.25))
            thread.addLine(to: CGPoint(x: c.x + uy * w * 1.15 + ux * r * 0.25, y: c.y - ux * w * 1.15 + uy * r * 0.25))
            t += r * 0.62
        }
        f.stroke(thread, metalDark, max(0.7, r * 0.16))
        f.dot(a.x, a.y, r, metal)
        f.ring(a.x, a.y, r, metalDark, max(0.6, r * 0.12))
        f.svgLine("M\(a.x - r * 0.5) \(a.y)H\(a.x + r * 0.5)M\(a.x) \(a.y - r * 0.5)V\(a.y + r * 0.5)", 0x5E6B73, max(0.8, r * 0.2))
    }

    /// A paint tin; `open` shows the paint inside and a drip down the side.
    private static func tin(_ f: PropPen, x: CGFloat, top: CGFloat, w: CGFloat, h: CGFloat, label: UInt32, open: UInt32?) {
        f.rect(x, top, w, h, metal, radius: 1.5)
        f.rect(x, top + h * 0.3, w, h * 0.45, label)
        f.rect(x + w * 0.2, top + h * 0.4, w * 0.6, h * 0.22, 0xFFFDF6, radius: 1)
        f.oval(x, top - 3, w, 6, open == nil ? metalDark : metal)
        if let open {
            f.oval(x + 1.5, top - 2, w - 3, 4.2, open)
            f.svg("M\(x + w * 0.62) \(top)H\(x + w * 0.84)V\(top + h * 0.5)Q\(x + w * 0.73) \(top + h * 0.62) \(x + w * 0.62) \(top + h * 0.5)Z", open)
        }
    }

    // MARK: Sturdy

    /// A thick shelf on big brackets holding a heavy weight without bending (green tick), next to a
    /// thin shelf that sags and cracks under the same weight (red cross). 78 × 54; `text` the weight.
    static func sturdy(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 78, height: 54))
        f.rect(0, 2, 78, 50, 0xE2DED3, radius: 2)
        f.rect(3, 26, 36, 7, 0x9A6A42, radius: 1)
        f.svg("M7 33H13V48L7 40Z M29 33H35V48L29 40Z", 0x3E4C55)
        weight(f, cx: 21, bottom: 26, text: p.text ?? "50 kg")
        f.svgLine("M44 26Q58 40 74 26", 0xC9A87A, 2)
        f.svgLine("M58 33L56 30M60 33L62 30", 0x7A5230, 0.9)
        f.svg("M45 29H48V36L45 33Z M71 29H74V36L71 33Z", metalDark)
        weight(f, cx: 59, bottom: 32.5, text: p.text ?? "50 kg")
        G5Props.tick(f, 33, 9, 6)
        G5Props.cross(f, 72, 9, 6)
    }

    private static func weight(_ f: PropPen, cx: CGFloat, bottom: CGFloat, text: String) {
        f.ring(cx, bottom - 18, 4.5, 0x3E4C55, 2.4)
        f.svg("M\(cx - 11) \(bottom)L\(cx - 8) \(bottom - 14)H\(cx + 8)L\(cx + 11) \(bottom)Z", 0x3E4C55)
        f.text(text, PropFont.heavy(6), 0xFFFDF6, at: CGPoint(x: cx, y: bottom - 6), maxWidth: 18)
    }
}
