import SwiftUI

/// Airport props: a gate screen (or a cancelled one), a boarding pass in a hand, a cabin case in
/// its size frame, the passport booth and the security scanner arch.
enum G7AirportProps {
    // MARK: Gate screen

    /// A gate screen (90 × 104; `mount` "hang" from rods, else on a stand): `caption` the gate in a
    /// yellow box, a big plane, `text` "07:10 Istanbul". `accessory` "cancel": red, the plane
    /// crossed out and the time struck through.
    static func flightScreen(_ pen: PropPen, _ p: PalacePropParams) {
        let hang = p.mount == "hang"
        let f = pen.fitted(CGSize(width: 90, height: hang ? 76 : 104))
        let cancel = p.accessory == "cancel"
        let top: CGFloat = hang ? 10 : 0
        if hang {
            f.svgLine("M20 0V12M70 0V12", 0x2E2117, 2)
        } else {
            f.oval(25, 98, 40, 6, 0x1E1E1C, 0.15)
            f.rect(42, 60, 6, 42, 0x5E6B73)
            f.rect(32, 99, 26, 4, 0x3E4C55, radius: 1)
        }
        let panel = CGRect(x: 0, y: top, width: 90, height: 64)
        f.rect(panel, 0x2E2117, radius: 4)
        let screen = panel.insetBy(dx: 4, dy: 4)
        f.rect(screen, cancel ? 0x7A1E1E : 0x1F3A6B, radius: 2)
        if let gate = p.caption {
            f.rect(screen.minX + 3, screen.minY + 3, 22, 13, 0xFAC775, radius: 2)
            f.text(gate, PropFont.heavy(9), 0x1E1E1C, at: CGPoint(x: screen.minX + 14, y: screen.minY + 9.8), maxWidth: 20)
        }
        let plane = CGRect(x: screen.midX - 13, y: screen.minY + 4, width: 26, height: 26)
        PalaceIcon.g7Plane.draw(f, in: plane, color: 0xF4F1EA, detail: 0x1F3A6B)
        let parts = (p.text ?? "").split(separator: " ", maxSplits: 1).map(String.init)
        let y = screen.minY + 42
        if let time = parts.first {
            f.text(time, PropFont.mono(10), 0xF4F1EA, at: CGPoint(x: screen.minX + 4, y: y), anchor: .leading)
            if cancel { f.line(screen.minX + 3, y, screen.minX + 38, y, 0xFAC775, 1.6) }
        }
        if parts.count > 1 {
            f.text(parts[1], PropFont.condensed(11), 0xF4F1EA, at: CGPoint(x: screen.maxX - 4, y: y), anchor: .trailing, maxWidth: 40)
        }
        if cancel {
            f.line(plane.minX - 4, plane.minY - 2, plane.maxX + 4, plane.maxY + 2, 0x7A1E1E, 7)
            f.line(plane.maxX + 4, plane.minY - 2, plane.minX - 4, plane.maxY + 2, 0x7A1E1E, 7)
            f.line(plane.minX - 4, plane.minY - 2, plane.maxX + 4, plane.maxY + 2, 0xFF5A4E, 4)
            f.line(plane.maxX + 4, plane.minY - 2, plane.minX - 4, plane.maxY + 2, 0xFF5A4E, 4)
        }
    }

    // MARK: Boarding pass

    /// A boarding pass held in a hand (84 × 90): a blue header with a plane, `text` (seat) big,
    /// `caption` (gate), a barcode.
    static func boardingPass(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 90))
        var c = f
        c.ctx.translateBy(x: 42, y: 40)
        c.ctx.rotate(by: .degrees(-8))
        c.ctx.translateBy(x: -42, y: -40)
        c.rect(5, 10, 76, 50, 0x1E1E1C, radius: 4, 0.15)
        c.rect(2, 6, 76, 50, 0xFFFDF6, radius: 4)
        c.rect(2, 6, 76, 14, 0x2F5BD3, radius: 4)
        c.rect(2, 14, 76, 6, 0x2F5BD3)
        PalaceIcon.g7Plane.draw(c, in: CGRect(x: 6, y: 7, width: 12, height: 12), color: 0xFFFDF6, detail: 0x2F5BD3)
        c.svgLine("M22 13H44", 0xFFFDF6, 2)
        c.svgLine("M8 28H30M8 34H24", 0xB4B2A9, 2)
        if let seat = p.text { c.text(seat, PropFont.heavy(15), 0x1E1E1C, at: CGPoint(x: 20, y: 46)) }
        if let gate = p.caption {
            c.rect(36, 38, 22, 14, 0xFAC775, radius: 2)
            c.text(gate, PropFont.heavy(9), 0x1E1E1C, at: CGPoint(x: 47, y: 45.5), maxWidth: 20)
        }
        var bars = ""
        for (i, x) in stride(from: 62.0, to: 76, by: 1.6).enumerated() where i % 3 != 1 { bars += "M\(x) 26V52" }
        c.svgLine(bars, 0x1E1E1C, 1)
        // Hand
        let skin: UInt32 = 0xC99A74
        f.svg("M20 90L24 64Q26 56 34 56H46Q50 58 48 62L40 64L38 90Z", skin)
        f.rect(34, 50, 14, 8, skin, radius: 4)
        f.rect(16, 86, 26, 4, 0x2F5BD3)
    }

    // MARK: Cabin case

    /// A small wheelie case standing in a size frame (84 × 104): a plate with `text` ("55 × 40 × 20")
    /// and a green tick.
    static func cabinCase(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 104))
        f.oval(2, 98, 80, 6, 0x1E1E1C, 0.15)
        f.svgLine("M8 30V100M72 30V100M8 30H72M8 100H72M18 22V30M62 22V30M18 22H82M82 22V92M72 100L82 92", 0x5E6B73, 3)
        // Case inside
        f.svgLine("M30 44V34H50V44", 0x3E4C55, 2.4)
        f.rect(18, 44, 46, 50, 0xC8261B, radius: 5)
        f.svgLine("M30 48V90M42 48V90M54 48V90", 0xA81E15, 1.4)
        f.dot(24, 96, 3, 0x1E1E1C)
        f.dot(58, 96, 3, 0x1E1E1C)
        if let text = p.text {
            f.rect(10, 4, 64, 14, 0x1F3A6B, radius: 2)
            f.text(text, PropFont.heavy(8.5), 0xFFFDF6, at: CGPoint(x: 42, y: 11.5), maxWidth: 60)
        }
        f.dot(74, 56, 8, 0x1E7A4C)
        f.svgLine("M70 56.5L73 59.5L78 53", 0xFFFFFF, 2.2)
    }

    // MARK: Passport booth

    /// A glass booth (112 × 114): an officer with a peaked cap stamps a passport; a sign with a
    /// passport over the booth; a traveller's hand hands another one in.
    static func passportBooth(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 114))
        f.oval(2, 108, 108, 6, 0x1E1E1C, 0.14)
        // Sign
        f.rect(30, 0, 52, 22, 0x1F3A6B, radius: 2)
        passport(f, x: 46, y: 3, w: 20)
        f.svgLine("M44 22V30M68 22V30", 0x3E4C55, 1.6)
        // Booth
        f.rect(6, 30, 100, 78, 0x5E6B73, radius: 3)
        f.rect(12, 36, 88, 42, 0xD3E0E6)
        // Officer behind the glass
        let v = PalaceFigures.Look.at(p.variant ?? 7)
        var o = f.within(CGRect(x: 34, y: 34, width: 44, height: 78), unit: 0.68)
        o.ctx.clip(to: Path(CGRect(x: -40, y: 0, width: 120, height: 64)))
        G7People.body(o, skin: v.skin, hair: v.hair, coat: 0x1F3A6B, trousers: 0x1F3A6B, hat: .peaked, shadow: false)
        f.rect(12, 36, 88, 42, 0xFFFFFF, radius: 0, 0.18)
        f.svg("M16 36L34 36L22 78H12Z", 0xFFFFFF, 0.2)
        // Counter with the passport and the stamp
        f.rect(4, 76, 104, 8, 0x8E8A80, radius: 1)
        passport(f, x: 44, y: 66, w: 18, open: true)
        f.rect(70, 62, 10, 10, 0x2E2117, radius: 2)
        f.rect(72, 54, 6, 9, 0x9A6A42, radius: 2)
        f.svgLine("M82 60L88 56M84 66L90 66", 0x8E8A80, 1.4)
        f.rect(12, 86, 88, 20, 0x3E4C55, radius: 2)
    }

    /// A passport booklet: dark red with a gold circle, `open` shows two pale pages with a stamp.
    private static func passport(_ f: PropPen, x: CGFloat, y: CGFloat, w: CGFloat, open: Bool = false) {
        let h = w * 0.8
        if open {
            f.rect(x - w / 2, y, w * 2, h, 0x7A1E1E, radius: 1.5)
            f.rect(x - w / 2 + 1.5, y + 1.5, w - 2, h - 3, 0xF4F1EA)
            f.rect(x + w / 2 + 0.5, y + 1.5, w - 2, h - 3, 0xF4F1EA)
            f.ring(x + w, y + h / 2, w * 0.22, 0x2F5BD3, 1.2)
            f.rect(x - w / 2 + 3, y + 3, w * 0.3, h * 0.45, 0xC99A74, radius: 1)
        } else {
            f.rect(x, y, w * 0.8, w, 0x7A1E1E, radius: 1.5)
            f.ring(x + w * 0.4, y + w * 0.45, w * 0.2, 0xC9A15B, 1.4)
            f.rect(x + w * 0.15, y + w * 0.78, w * 0.5, 1.6, 0xC9A15B)
        }
    }

    // MARK: Security arch

    /// A walk-through scanner (98 × 124): a grey arch with a green light, a belt running into an
    /// x-ray tunnel with curtains, a tray holding a bag, keys and a phone.
    static func securityArch(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 98, height: 124))
        f.oval(2, 116, 94, 8, 0x1E1E1C, 0.15)
        // Arch
        f.rect(4, 12, 46, 108, 0xB4B2A9, radius: 3)
        f.rect(12, 22, 30, 98, 0xDAD6CA)
        f.rect(4, 12, 46, 10, 0x8E8A80, radius: 3)
        f.dot(27, 17, 3.2, 0x1E7A4C)
        f.dot(27, 17, 6, 0x5DCAA5, 0.3)
        f.svgLine("M8 36V108M46 36V108", 0x8E8A80, 1.2)
        f.svgLine("M18 50h2M18 66h2M18 82h2M34 58h2M34 74h2M34 90h2", 0x8E8A80, 2)
        // Belt and tunnel
        f.rect(52, 84, 46, 8, 0x3E4C55, radius: 2)
        f.svgLine("M54 92V114M94 92V114", 0x5E6B73, 2.4)
        f.rect(70, 54, 28, 32, 0x8E8A80, radius: 3)
        f.rect(72, 60, 24, 24, 0x2E2117)
        f.svgLine("M75 60V84M79 60V84M83 60V84M87 60V84M91 60V84", 0x3E4C55, 2)
        // Tray going in
        f.svg("M50 72H72L70 84H52Z", 0x7D8A92)
        f.rect(53, 66, 10, 8, 0x9A6A42, radius: 2)
        f.rect(64, 68, 5, 8, 0x1E1E1C, radius: 1)
        f.ring(58, 63, 2, 0xC9A15B, 1.2)
    }
}
