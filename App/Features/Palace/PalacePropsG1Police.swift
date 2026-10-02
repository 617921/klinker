import SwiftUI

/// Police front-desk pictures: a break-in at night, a megaphone warning, forbidden-and-punished,
/// a stolen bike (an empty rack and a cut lock), a camera picture of someone sneaking, and a
/// hand lifting a wallet out of a bag.
enum G1Police {
    // MARK: Break-in

    /// A framed poster (84 × 58): at night a burglar in a mask climbs through a broken window
    /// with a crowbar.
    static func breakIn(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 58))
        let r = G1BankPosters.frame(f, 84, 58, border: 0x1F3A6B)
        f.rect(r, 0x232B3B, radius: 1.5)
        f.dot(r.minX + 7, r.minY + 9, 5, 0xFAC775)
        f.dot(r.minX + 9, r.minY + 7.5, 4.4, 0x232B3B)
        f.rect(r.minX + 14, r.minY + 6, r.width - 14, r.height - 6, 0x7B3F2E)
        f.rect(r.minX + 22, r.minY + 12, 36, 30, 0x0F1A2A)
        f.svg("M\(r.minX + 22) \(r.minY + 12)H\(r.minX + 40)L\(r.minX + 34) \(r.minY + 20)L\(r.minX + 42) \(r.minY + 24)L\(r.minX + 30) \(r.minY + 30)L\(r.minX + 36) \(r.minY + 22)L\(r.minX + 22) \(r.minY + 26)Z", 0xBCCDD6, 0.8)
        f.stroke(Path(CGRect(x: r.minX + 22, y: r.minY + 12, width: 36, height: 30)), 0xEFEBE2, 2)
        // The burglar, half in: striped shirt, mask, a crowbar
        let x = r.minX + 46, y = r.minY + 16
        f.svg("M\(x - 4) \(y + 30)L\(x - 2) \(y + 14)Q\(x) \(y + 8) \(x + 7) \(y + 8)Q\(x + 14) \(y + 8) \(x + 15) \(y + 14)L\(x + 17) \(y + 30)Z", 0xFFFDF6)
        f.svgLine("M\(x - 2.6) \(y + 18)H\(x + 15.6)M\(x - 3) \(y + 23)H\(x + 16)M\(x - 3.4) \(y + 28)H\(x + 16.4)", 0x1E1E1C, 2.2)
        f.dot(x + 7, y + 2, 6, 0xE8C4A0)
        f.svg("M\(x + 1) \(y + 1)H\(x + 13)V\(y + 4.6)H\(x + 1)Z", 0x1E1E1C)
        f.svg("M\(x + 1) \(y - 0.5)C\(x + 1) \(y - 6) \(x + 13) \(y - 6) \(x + 13) \(y - 0.5)Z", 0x1E1E1C)
        f.dot(x + 4.6, y + 2.6, 1.1, 0xFFFDF6)
        f.dot(x + 9.6, y + 2.6, 1.1, 0xFFFDF6)
        f.svgLine("M\(x + 14) \(y + 14)L\(x + 26) \(y + 4)", 0x1E1E1C, 3)
        f.svgLine("M\(x + 24) \(y + 2)L\(x + 30) \(y - 4)Q\(x + 34) \(y - 6) \(x + 33) \(y - 1)", 0xC8261B, 2.4)
        f.svg("M\(r.minX + 62) \(r.maxY - 6)L\(r.minX + 70) \(r.maxY - 2)H\(r.minX + 56)Z", 0xBCCDD6, 0.7)
    }

    // MARK: Megaphone

    /// A hand with a megaphone (112 × 58) shouting a bubble with a warning sign and `text`.
    static func megaphone(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 58))
        let r = G1BankPosters.frame(f, 112, 58, border: 0xE0A93A)
        f.rect(r, 0xFAC775, radius: 1.5)
        f.svg("M\(r.minX + 8) \(r.minY + 24)H\(r.minX + 16)L\(r.minX + 40) \(r.minY + 10)V\(r.minY + 46)L\(r.minX + 16) \(r.minY + 32)H\(r.minX + 8)Z", 0xC8261B)
        f.rect(r.minX + 4, r.minY + 22, 6, 12, 0xFFFDF6, radius: 2)
        f.oval(r.minX + 36, r.minY + 8, 8, 40, 0xFFFDF6)
        f.svgLine("M\(r.minX + 20) \(r.minY + 34)L\(r.minX + 20) \(r.minY + 44)", 0x3E4C55, 3)
        f.svg("M\(r.minX + 14) \(r.minY + 40)C\(r.minX + 14) \(r.minY + 36) \(r.minX + 26) \(r.minY + 36) \(r.minX + 26) \(r.minY + 42)L\(r.minX + 24) \(r.minY + 50)H\(r.minX + 16)Z", 0xC99A74)
        f.svgLine("M\(r.minX + 48) \(r.minY + 16)L\(r.minX + 52) \(r.minY + 12)M\(r.minX + 49) \(r.minY + 28)H\(r.minX + 54)M\(r.minX + 48) \(r.minY + 40)L\(r.minX + 52) \(r.minY + 44)", 0x1E1E1C, 1.8)
        let bubble = CGRect(x: r.minX + 56, y: r.minY + 6, width: r.maxX - r.minX - 60, height: 42)
        f.rect(bubble, 0xFFFDF6, radius: 10)
        f.svg("M\(bubble.minX + 2) \(bubble.midY - 4)L\(bubble.minX - 5) \(bubble.midY)L\(bubble.minX + 2) \(bubble.midY + 4)Z", 0xFFFDF6)
        PalaceIcon.warning.draw(f, in: CGRect(x: bubble.midX - 8, y: bubble.minY + 3, width: 16, height: 16), color: 0xF2711C, detail: 0xFFFDF6)
        f.text(p.text ?? "Pas op!", PropFont.heavy(10), 0xC8261B, at: CGPoint(x: bubble.midX, y: bubble.maxY - 11), maxWidth: bubble.width - 6)
    }

    // MARK: Forbidden

    /// A sign (112 × 58): a spray can and a scribble crossed out in a red ring, an arrow, handcuffs.
    static func forbidden(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 58))
        let r = G1BankPosters.frame(f, 112, 58, border: 0x1F3A6B)
        let c = CGPoint(x: r.minX + 24, y: r.midY)
        f.rect(c.x - 6, c.y - 6, 10, 18, 0x2F5BD3, radius: 2)
        f.rect(c.x - 4, c.y - 10, 6, 5, 0x3E4C55, radius: 1)
        f.svgLine("M\(c.x + 4) \(c.y - 12)Q\(c.x + 8) \(c.y - 16) \(c.x + 12) \(c.y - 10)T\(c.x + 14) \(c.y + 2)", 0x993556, 2)
        f.ring(c.x, c.y, 19, 0xC8261B, 4)
        f.line(c.x - 13, c.y - 13, c.x + 13, c.y + 13, 0xC8261B, 4)
        f.svgLine("M\(r.minX + 50) \(r.midY)H\(r.minX + 62)", 0x1E1E1C, 2.4)
        f.svg("M\(r.minX + 61) \(r.midY - 5)L\(r.minX + 68) \(r.midY)L\(r.minX + 61) \(r.midY + 5)Z", 0x1E1E1C)
        // Handcuffs
        let h = CGPoint(x: r.maxX - 22, y: r.midY)
        f.ring(h.x - 8, h.y + 2, 8, 0x8C9499, 3.2)
        f.ring(h.x + 10, h.y + 2, 8, 0x8C9499, 3.2)
        f.svgLine("M\(h.x - 1) \(h.y - 4)Q\(h.x + 1) \(h.y - 10) \(h.x + 3) \(h.y - 4)", 0x5E6B73, 2)
        f.rect(h.x - 18, h.y - 2, 5, 4, 0x5E6B73)
        f.rect(h.x + 17, h.y - 2, 5, 4, 0x5E6B73)
    }

    // MARK: Stolen bike

    /// A photo pinned to a cork board (94 × 92): a bike rack with one bike and a dashed outline
    /// where the other one stood, a cut chain lock lying on the ground.
    static func cutLock(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 94, height: 92))
        f.rect(0, 0, 94, 92, 0x7A5230, radius: 3)
        f.rect(4, 4, 86, 84, 0xC9965F, radius: 1.5)
        var photo = f
        photo.ctx.translateBy(x: 47, y: 46)
        photo.ctx.rotate(by: .radians(-0.04))
        photo.rect(-38, -36, 78, 76, 0x1E1E1C, radius: 1, 0.16)
        photo.rect(-40, -38, 78, 76, 0xFFFDF6, radius: 1)
        photo.rect(-36, -34, 70, 62, 0xD8DCDD)
        photo.rect(-36, 8, 70, 20, 0xB4B2A9)
        photo.svgLine("M-30 18V0A8 8 0 0 1 -14 0V18M8 18V0A8 8 0 0 1 24 0V18", 0x5E6B73, 2.6)
        bike(photo, x: -38, y: -2, colour: 0x2F5BD3, dashed: false)
        bike(photo, x: 0, y: -2, colour: 0xC8261B, dashed: true)
        photo.svgLine("M-2 24Q4 18 10 24T22 24", 0x3E4C55, 2.4)
        photo.svgLine("M22 24L26 22M27 26L31 24", 0xC8261B, 1.6)
        photo.rect(-6, 21, 7, 7, 0xE0A93A, radius: 1.5)
        photo.dot(1, -38, 3.2, 0xC8261B)
    }

    /// A bicycle about 36 × 24, its top-left at (x, y); `dashed` draws only a dotted outline.
    static func bike(_ f: PropPen, x: CGFloat, y: CGFloat, colour: UInt32, dashed: Bool) {
        let frame = "M\(x + 8) \(y + 16)L\(x + 15) \(y + 6)H\(x + 27)L\(x + 28) \(y + 16)M\(x + 15) \(y + 6)L\(x + 19) \(y + 16)L\(x + 27) \(y + 6)M\(x + 13) \(y + 3)H\(x + 18)M\(x + 26) \(y + 6)L\(x + 25) \(y + 1)H\(x + 30)"
        if dashed {
            var d = f
            d.ctx.opacity = 0.9
            d.ctx.stroke(PalaceSVG.path(frame), with: .color(PalaceInk.hex(colour)), style: StrokeStyle(lineWidth: 1.6, lineCap: .round, dash: [3, 2.5]))
            for cx in [x + 8, x + 28] {
                d.ctx.stroke(Path(ellipseIn: CGRect(x: cx - 7.5, y: y + 8.5, width: 15, height: 15)), with: .color(PalaceInk.hex(colour)),
                             style: StrokeStyle(lineWidth: 1.6, dash: [3, 2.5]))
            }
            return
        }
        f.ring(x + 8, y + 16, 7.5, 0x1E1E1C, 2)
        f.ring(x + 28, y + 16, 7.5, 0x1E1E1C, 2)
        f.svgLine(frame, colour, 2.2)
    }

    // MARK: Camera picture

    /// A hanging camera screen (110 × 74): at night a hooded figure peers round a corner, looking
    /// sideways, question marks over the head; a red dot and `caption` ("CAM 2").
    static func cctv(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 110, height: 74))
        f.line(22, 0, 22, 8, 0x2E2117, 2)
        f.line(88, 0, 88, 8, 0x2E2117, 2)
        f.rect(0, 6, 110, 68, 0x2E2117, radius: 5)
        f.rect(4, 10, 102, 60, 0x1F2B3A, radius: 2)
        f.rect(4, 52, 102, 18, 0x2B3A4A, radius: 2)
        f.rect(60, 14, 46, 56, 0x3E4C55)
        f.rect(66, 22, 14, 14, 0xFAC775, 0.5)
        // The hooded figure peering from behind the corner
        f.svg("M44 70V42Q44 30 54 30Q62 30 62 40V70Z", 0x1E1E1C)
        f.svg("M45 40Q45 24 55 24Q64 24 63 38L60 44H48Z", 0x2E3A42)
        f.oval(50, 32, 10, 10, 0xA87B4F)
        f.rect(50, 34.5, 10, 3.2, 0x1E1E1C, radius: 1.5)
        f.dot(52, 36, 0.9, 0xFFFDF6)
        f.text("?", PropFont.heavy(13), 0xFAC775, at: CGPoint(x: 38, y: 22))
        f.text("?", PropFont.heavy(10), 0xFAC775, at: CGPoint(x: 30, y: 30))
        f.dot(12, 17, 3, 0xC8261B)
        f.text(p.caption ?? "CAM 2", PropFont.mono(7), 0xF4F1EA, at: CGPoint(x: 18, y: 17.5), anchor: .leading)
    }

    // MARK: Pickpocket

    /// An open handbag (82 × 60) and a black-gloved hand sneaking a wallet out of it.
    static func pickpocket(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 82, height: 60))
        f.oval(4, 55, 60, 5, 0x1E1E1C, 0.15)
        f.svgLine("M14 34Q16 6 34 6Q52 6 54 34", 0x7A1E1E, 3)
        f.svg("M6 30H62L58 58H10Z", 0xC8261B)
        f.svg("M6 30H62L60 36H8Z", 0x962A2A)
        f.dot(34, 40, 2.4, 0xC9A15B)
        // The wallet on its way out, the gloved hand, sneaky lines
        var w = f
        w.ctx.translateBy(x: 46, y: 22)
        w.ctx.rotate(by: .radians(-0.5))
        w.rect(-10, -7, 20, 14, 0x7A5230, radius: 2)
        w.rect(-10, -2, 20, 3, 0x5A3D25)
        f.svg("M48 12C52 6 60 6 64 10L66 18C62 22 56 22 52 20Z", 0x1E1E1C)
        f.svg("M62 8L82 0V18L66 18Z", 0x3E4C55)
        f.svgLine("M70 4L80 0M70 10L82 6M70 16L82 12", 0xFFFDF6, 1.2)
        f.svgLine("M36 2L40 6M30 6L36 8M60 26L64 30", 0x5E6B73, 1.4)
    }
}
