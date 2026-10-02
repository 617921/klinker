import SwiftUI

extension PropPen {
    /// The same pen drawing mirrored left-to-right (a figure that faces left).
    func mirrored(_ on: Bool = true) -> PropPen {
        guard on else { return self }
        var c = ctx
        c.translateBy(x: size.width, y: 0)
        c.scaleBy(x: -1, y: 1)
        return PropPen(ctx: c, size: size)
    }

    /// A spiral stroke around a centre (dizziness, a swirl).
    func spiral(_ cx: CGFloat, _ cy: CGFloat, radius: CGFloat, turns: Double, _ hex: UInt32, _ width: CGFloat) {
        var path = Path()
        let steps = Int(turns * 24)
        for i in 0...steps {
            let t = Double(i) / Double(steps)
            let a = t * turns * 2 * .pi
            let point = CGPoint(x: cx + cos(a) * radius * t, y: cy + sin(a) * radius * t)
            if i == 0 { path.move(to: point) } else { path.addLine(to: point) }
        }
        stroke(path, hex, width)
    }
}

/// People at the GP: the doctor (at a desk or standing) and patients who show a complaint.
/// Figures face right; `flip` makes them face left.
enum PalaceCarePeople {
    typealias Look = PalaceFigures.Look

    // MARK: Doctor

    /// A GP in a white coat with a stethoscope and glasses (64 × 114). `mount` "desk" cuts the
    /// figure at the desk top (64 × 84) and reaches the near arm forward; `variant` look.
    static func doctor(_ pen: PropPen, _ p: PalacePropParams) {
        let desk = p.mount == "desk"
        let base = pen.fitted(CGSize(width: 64, height: desk ? 84 : 114))
        var f = base.mirrored(p.flip == true)
        let v = Look.at(p.variant ?? 4)
        if desk {
            f.ctx.clip(to: Path(CGRect(x: -10, y: -10, width: 84, height: 94)))
            f.rect(1, 38, 10, 46, 0x3E4C55, radius: 4)
        } else {
            f.oval(6, 106, 52, 6, 0x1E1E1C, 0.16)
            f.svgLine("M17 84V104M27 84V104", 0x3E4C55, 5)
            f.svg("M12 103H21V108H12Z M23 103H32V108H23Z", 0x2E2117)
        }
        let coat = PalaceSVG.path("M9 88L10.5 44C11.5 36 15.5 32 22 32C28.5 32 32.5 36 33.5 44L35 88Z")
        f.fill(coat, 0xFFFDF6)
        f.stroke(coat, 0xB4B2A9, 1)
        f.svg("M18 32.5L22 41L26 32.5Z", 0xA9CBE0)
        f.svgLine("M17 33.5L22 48L27 33.5", 0xD3D1C7, 1.2)
        f.svgLine("M15.5 35C13 47 17 53 21.5 53C26 53 29.5 47 28 35", 0x3E4C55, 1.6)
        f.dot(21.5, 55.5, 2.8, 0xB4B2A9)
        f.dot(21.5, 55.5, 1.2, 0x5E6B73)
        f.rect(24.5, 61, 6.5, 6, 0xEFEBE2)
        f.svgLine("M26.5 58V62M29 57.5V62", 0x2F5BD3, 1.2)
        if desk {
            f.svgLine("M30 42C34 52 44 60 64 62", 0xD3D1C7, 7.5)
            f.svgLine("M30 42C34 52 44 60 64 62", 0xFFFDF6, 5.5)
        } else {
            f.svgLine("M13 42C10 52 10 62 12 70", 0xD3D1C7, 6.5)
            f.svgLine("M13 42C10 52 10 62 12 70", 0xFFFDF6, 4.8)
            f.dot(12.5, 72, 3.1, v.skin)
            f.svgLine("M31 42C34 52 34 62 32 70", 0xD3D1C7, 6.5)
            f.svgLine("M31 42C34 52 34 62 32 70", 0xFFFDF6, 4.8)
            f.dot(32, 72, 3.1, v.skin)
        }
        f.dot(22, 19, 11, v.skin)
        f.svg("M11 18C10 10 15 6 22 6C29 6 34 10 33 18C31 13 27 11.5 22 11.5C17 11.5 13 13 11 18Z", 0xB4B2A9)
        f.ring(27.6, 19.5, 2.9, 0x2E2117, 1.1)
        f.svgLine("M24.7 19.2H22.5", 0x2E2117, 1.1)
        f.dot(28.2, 19.6, 1.1, 0x2E2117)
        f.svgLine("M25.5 25.5Q27.5 27 29.5 25.5", 0x8C5A3C, 1.1)
    }

    // MARK: Patient

    /// A patient with a complaint, seated on a chair (64 × 100) or standing (`mount` "stand", 64 × 124).
    /// `accessory`: "cough" (into the elbow, puffs), "nauseous" (green face, hand on the belly),
    /// "dizzy" (spirals and stars round the head), "pain" (hand on a sore knee), "fever"
    /// (thermometer in the mouth, red cheeks). `text` is a speech bubble; `variant` the look.
    static func patient(_ pen: PropPen, _ p: PalacePropParams) {
        let stand = p.mount == "stand"
        let bubble = p.text != nil
        let size = CGSize(width: bubble ? 84 : 64, height: stand ? 124 : 100)
        let base = pen.fitted(size)
        let f = base.mirrored(p.flip == true)
        let v = Look.at(p.variant ?? 1)
        let symptom = p.accessory ?? "none"
        let skin: UInt32 = symptom == "nauseous" ? 0xB7CF8F : v.skin
        let head: CGPoint, shoulder: CGPoint
        if stand {
            head = CGPoint(x: 22, y: 29)
            shoulder = CGPoint(x: 31, y: 52)
            f.oval(6, 116, 52, 6, 0x1E1E1C, 0.16)
            f.svgLine("M17 94V114M27 94V114", v.trousers, 5)
            f.svg("M12 113H21V118H12Z M23 113H32V118H23Z", 0x2E2117)
            f.svg("M9 98L10.5 54C11.5 46 15.5 42 22 42C28.5 42 32.5 46 33.5 54L35 98Z", v.coat)
            f.svgLine("M13 52C10 62 10 72 12 80", PalaceInk.shade(v.coat, 0.78), 6)
            f.dot(12.5, 82, 3.1, skin)
            f.svg("M17 42L22 49L27 42Z", 0xEFEBE2)
        } else {
            head = CGPoint(x: 23, y: 26)
            shoulder = CGPoint(x: 28, y: 46)
            f.oval(4, 95, 52, 5, 0x1E1E1C, 0.14)
            f.svgLine("M8 76V97M41 76V97", 0x2E2117, 2.4)
            f.svgLine("M8 88H41", 0x2E2117, 1.6)
            f.svg("M5 44H10V76H5Z", 0x1F3A6B)
            f.svg("M5 70H44V76H5Z", 0x2B4C86)
            f.svg("M11 72L12 48C13 41 17 38 23 38C29 38 33 41 34 48L35 72Z", v.coat)
            f.svg("M18 38L23 44L28 38Z", 0xEFEBE2)
            f.svg("M15 64H47Q51 64 51 68V73H15Z", v.trousers)
            f.svgLine("M41 72V93", PalaceInk.shade(v.trousers, 0.8), 5.5)
            f.svgLine("M47 70V93", v.trousers, 6)
            f.svg("M38 92H47Q50 92 50 95V97H38Z M44 92H53Q56 92 56 95V97H44Z", 0x2E2117)
        }
        // Head
        let (hx, hy) = (head.x, head.y)
        f.dot(hx, hy, 11, skin)
        f.svg("M\(hx - 11) \(hy - 1)C\(hx - 12) \(hy - 9) \(hx - 7) \(hy - 13) \(hx) \(hy - 13)C\(hx + 7) \(hy - 13) \(hx + 12) \(hy - 9) \(hx + 11) \(hy - 1)C\(hx + 9) \(hy - 6) \(hx + 5) \(hy - 7.5) \(hx) \(hy - 7.5)C\(hx - 5) \(hy - 7.5) \(hx - 9) \(hy - 6) \(hx - 11) \(hy - 1)Z", v.hair)
        let eye = CGPoint(x: hx + 5.5, y: hy + 0.5)
        let arm = PalaceInk.shade(v.coat, 0.86)
        let (sx, sy) = (shoulder.x, shoulder.y)
        switch symptom {
        case "cough":
            f.svgLine("M\(eye.x - 1.8) \(eye.y - 0.6)Q\(eye.x) \(eye.y + 1) \(eye.x + 1.8) \(eye.y - 0.6)", 0x2E2117, 1.2)
            f.svgLine("M\(sx) \(sy)L\(hx + 16) \(hy + 11)L\(hx + 8) \(hy + 4.5)", arm, 6.2)
            for (dx, dy, r) in [(23.0, 5.0, 3.4), (28.5, 0.0, 2.7), (29.0, 9.5, 2.4), (34.0, 4.5, 1.9)] {
                f.dot(hx + dx, hy + dy, r, 0xEFEBE2)
                f.ring(hx + dx, hy + dy, r, 0x5E6B73, 1)
            }
            f.svgLine("M\(hx + 20) \(hy - 4)L\(hx + 24) \(hy - 7.5)M\(hx + 21) \(hy + 14)L\(hx + 25.5) \(hy + 16.5)", 0x5E6B73, 1.2)
        case "nauseous":
            f.svgLine("M\(eye.x - 2) \(eye.y)H\(eye.x + 1.8)", 0x2E2117, 1.2)
            f.svgLine("M\(hx + 1) \(hy + 6.5)Q\(hx + 2.3) \(hy + 5.3) \(hx + 3.6) \(hy + 6.5)T\(hx + 6.2) \(hy + 6.5)T\(hx + 8.8) \(hy + 6.5)", 0x4E7A3A, 1.1)
            f.svgLine("M\(sx) \(sy)C\(sx + 6) \(sy + 7) \(sx + 5) \(sy + 14) \(sx + 1) \(sy + 17)", arm, 6)
            f.dot(sx, sy + 17.5, 3.2, skin)
            f.svgLine("M\(hx + 14) \(hy - 10)q2.5 -2.5 5 0t5 0M\(hx + 16) \(hy - 4)q2.5 -2.5 5 0t5 0", 0x6E9C52, 1.5)
            f.svg("M\(hx + 9) \(hy - 9)Q\(hx + 11) \(hy - 5.5) \(hx + 9) \(hy - 4)Q\(hx + 7) \(hy - 5.5) \(hx + 9) \(hy - 9)Z", 0xA9CBE0)
        case "dizzy":
            f.spiral(eye.x, eye.y, radius: 2.4, turns: 2, 0x2E2117, 0.9)
            f.svgLine("M\(sx) \(sy)C\(hx + 18) \(hy + 18) \(hx + 17) \(hy + 2) \(hx + 10) \(hy - 6)", arm, 6)
            f.dot(hx + 9, hy - 7, 3.2, skin)
            f.stroke(Path(ellipseIn: CGRect(x: hx - 17, y: hy - 22, width: 34, height: 10)), 0x5E6B73, 1)
            for (dx, dy) in [(-15.0, -16.0), (1.0, -23.0), (15.0, -15.0)] { star(f, hx + dx, hy + dy, 3.2) }
            f.spiral(hx - 17, hy + 4, radius: 5, turns: 2.2, 0x3C3489, 1.2)
            f.spiral(hx + 19, hy + 1, radius: 5, turns: 2.2, 0x3C3489, 1.2)
        case "pain":
            f.dot(eye.x, eye.y, 1.3, 0x2E2117)
            f.svgLine("M\(eye.x - 2.5) \(eye.y - 3.5)L\(eye.x + 1.5) \(eye.y - 2.2)", 0x2E2117, 1)
            f.svgLine("M\(hx + 2.5) \(hy + 7)Q\(hx + 5) \(hy + 5.4) \(hx + 7.5) \(hy + 7)", 0x8C5A3C, 1.1)
            f.svgLine("M\(sx) \(sy)C\(sx + 6) \(sy + 8) \(sx + 13) \(sy + 14) \(sx + 19) \(sy + 18)", arm, 6)
            f.dot(sx + 20, sy + 18.5, 3.2, skin)
            f.svgLine("M\(sx + 23) \(sy + 9)L\(sx + 26) \(sy + 5)L\(sx + 28) \(sy + 10)L\(sx + 31) \(sy + 6)", 0xC8261B, 1.6)
            f.svgLine("M\(sx + 27) \(sy + 16)L\(sx + 32) \(sy + 15)M\(sx + 26) \(sy + 22)L\(sx + 31) \(sy + 25)", 0xC8261B, 1.5)
        case "fever":
            f.svgLine("M\(eye.x - 2) \(eye.y)H\(eye.x + 1.8)", 0x2E2117, 1.2)
            f.dot(hx + 2, hy + 4, 2.8, 0xE06A5A, 0.6)
            f.svgLine("M\(hx + 8) \(hy + 6)L\(hx + 19) \(hy + 1)", 0x9A9890, 3)
            f.svgLine("M\(hx + 8) \(hy + 6)L\(hx + 19) \(hy + 1)", 0xFFFDF6, 1.8)
            f.dot(hx + 19.3, hy + 0.8, 1.8, 0xC8261B)
            f.svg("M\(hx + 8) \(hy - 10)Q\(hx + 10) \(hy - 6.5) \(hx + 8) \(hy - 5)Q\(hx + 6) \(hy - 6.5) \(hx + 8) \(hy - 10)Z", 0xA9CBE0)
            rest(f, sx, sy, stand: stand, arm, skin)
        default:
            f.dot(eye.x, eye.y, 1.3, 0x2E2117)
            rest(f, sx, sy, stand: stand, arm, skin)
        }
        if let text = p.text {
            // The bubble's lettering is never mirrored.
            let b = CGRect(x: p.flip == true ? 0 : 34, y: 0, width: 50, height: 17)
            base.rect(b, 0xFFFDF6, radius: 6)
            base.stroke(Path(roundedRect: b, cornerRadius: 6), 0x5E6B73, 1)
            let tail = p.flip == true ? "M\(b.maxX - 16) \(b.maxY - 0.6)L\(b.maxX - 10) \(b.maxY + 6)L\(b.maxX - 22) \(b.maxY - 0.6)Z"
                : "M\(b.minX + 8) \(b.maxY - 0.6)L\(b.minX + 4) \(b.maxY + 6)L\(b.minX + 14) \(b.maxY - 0.6)Z"
            base.svg(tail, 0xFFFDF6)
            base.text(text, PropFont.demi(8), 0x1E1E1C, at: CGPoint(x: b.midX, y: b.midY), maxWidth: b.width - 6)
        }
    }

    private static func rest(_ f: PropPen, _ sx: CGFloat, _ sy: CGFloat, stand: Bool, _ arm: UInt32, _ skin: UInt32) {
        if stand {
            f.svgLine("M\(sx) \(sy)C\(sx + 3) \(sy + 10) \(sx + 3) \(sy + 20) \(sx + 1) \(sy + 28)", arm, 6)
            f.dot(sx + 1, sy + 30, 3.1, skin)
        } else {
            f.svgLine("M\(sx) \(sy)C\(sx + 4) \(sy + 8) \(sx + 10) \(sy + 14) \(sx + 14) \(sy + 17)", arm, 6)
            f.dot(sx + 15, sy + 18, 3.1, skin)
        }
    }

    /// A small four-pointed star.
    static func star(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ r: CGFloat) {
        let k = r * 0.32
        f.svg("M\(x) \(y - r)L\(x + k) \(y - k)L\(x + r) \(y)L\(x + k) \(y + k)L\(x) \(y + r)L\(x - k) \(y + k)L\(x - r) \(y)L\(x - k) \(y - k)Z", 0xF2711C)
    }
}
