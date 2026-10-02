import SwiftUI

/// Hospital things: a door (to the operating theatre with its lamp lit, or ajar onto a changing
/// room), a patient on a drip, a hospital bed (recovering or seriously ill) and a weekly pill box
/// that has been in use for years.
enum G3Hospital {
    typealias Look = PalaceFigures.Look

    // MARK: Door

    /// A door in its frame (80 × 200). `tone` colours the leaf; `icons` sit on a plate above the
    /// frame. `accessory` "lamp": two swing doors with round windows onto an operating theatre and
    /// a red lamp lit above them, lettered `text`. "ajar": the leaf stands open onto a changing
    /// room with clothes on hooks and a bench.
    static func door(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 80, height: 200))
        let leaf = PropColor.named(p.tone, 0x9FB4BE)
        f.rect(0, 18, 80, 182, 0xEFEBE2)
        f.rect(0, 18, 80, 3, 0x1E1E1C, 0.08)
        let inner = CGRect(x: 6, y: 24, width: 68, height: 176)
        switch p.accessory {
        case "lamp":
            f.rect(14, -2, 52, 22, 0xC8261B, radius: 6, 0.16)
            f.rect(18, 0, 44, 17, 0x2E2117, radius: 3)
            f.rect(21, 3, 38, 11, 0xC8261B, radius: 2)
            f.svgLine("M12 4L6 0M11 11H4M68 4L74 0M69 11H76", 0xC8261B, 1.6)
            if let text = p.text {
                f.text(text, PropFont.heavy(9), 0xFFFDF6, at: CGPoint(x: 40, y: 8.8), maxWidth: 34)
            }
            let w = inner.width / 2 - 1
            for (i, x) in [inner.minX, inner.midX + 1].enumerated() {
                f.rect(x, inner.minY, w, inner.height, leaf)
                f.rect(x, inner.maxY - 28, w, 28, 0xB4B2A9)
                f.rect(i == 0 ? x + w - 7 : x + 3, 104, 4, 30, 0xD3D1C7, radius: 1)
                theatreWindow(f, cx: x + w / 2, cy: 66, left: i == 0)
            }
            f.line(inner.midX, inner.minY, inner.midX, inner.maxY, 0x5E6B73, 1.2)
        case "ajar":
            changingRoom(f, inner)
            f.svg("M6 24L28 32V192L6 200Z", leaf)
            f.svg("M6 24L28 32V36L6 29Z", 0xFFFFFF, 0.25)
            f.rect(22, 112, 3, 12, 0xC9A15B, radius: 1)
            plate(f, p)
        default:
            f.rect(inner, leaf)
            f.rect(inner.minX, inner.maxY - 28, inner.width, 28, 0xB4B2A9)
            f.rect(62, 108, 4, 14, 0xC9A15B, radius: 1)
            plate(f, p)
        }
    }

    /// A round window in a swing door: the theatre lamp (left) or the team in green (right).
    private static func theatreWindow(_ f: PropPen, cx: CGFloat, cy: CGFloat, left: Bool) {
        f.dot(cx, cy, 12.5, 0xD3D1C7)
        f.dot(cx, cy, 10.5, 0xDCEBEA)
        var w = f
        w.ctx.clip(to: Path(ellipseIn: CGRect(x: cx - 10.5, y: cy - 10.5, width: 21, height: 21)))
        if left {
            w.svg("M\(cx - 12) \(cy - 6)Q\(cx) \(cy - 15) \(cx + 12) \(cy - 6)Z", 0xB4B2A9)
            w.svg("M\(cx - 8) \(cy - 6)L\(cx - 12) \(cy + 12)H\(cx + 12)L\(cx + 8) \(cy - 6)Z", 0xFAC775, 0.45)
            w.dot(cx - 4, cy - 6, 2, 0xFFFDF6)
            w.dot(cx + 4, cy - 6, 2, 0xFFFDF6)
            w.dot(cx + 6, cy + 9, 5, 0x3F8A70)
        } else {
            for dx in [-5.0, 5.5] as [CGFloat] {
                w.svg("M\(cx + dx - 7) \(cy + 14)Q\(cx + dx - 7) \(cy + 4) \(cx + dx) \(cy + 4)Q\(cx + dx + 7) \(cy + 4) \(cx + dx + 7) \(cy + 14)Z", 0x3F8A70)
                w.dot(cx + dx, cy - 1, 4.6, 0xE8C4A0)
                w.svg("M\(cx + dx - 4.8) \(cy - 2)C\(cx + dx - 4.8) \(cy - 7) \(cx + dx + 4.8) \(cy - 7) \(cx + dx + 4.8) \(cy - 2)Z", 0x3F8A70)
                w.rect(cx + dx - 3.5, cy + 0.5, 7, 3.6, 0xA9CBE0, radius: 1)
            }
        }
        f.dot(cx - 4, cy - 5, 2.4, 0xFFFFFF, 0.5)
    }

    /// Behind an open door: tiles, clothes on hooks, a bench.
    private static func changingRoom(_ f: PropPen, _ r: CGRect) {
        f.rect(r, 0xE6EDEA)
        var tiles = ""
        for y in stride(from: r.minY + 14, to: r.maxY, by: 14) { tiles += "M\(r.minX) \(y)H\(r.maxX)" }
        for x in stride(from: r.minX + 14, to: r.maxX, by: 14) { tiles += "M\(x) \(r.minY)V\(r.maxY)" }
        f.svgLine(tiles, 0xD3DBD8, 0.8)
        f.rect(28, 58, 46, 4, 0x7A5230, radius: 1)
        for x in [36.0, 50, 64] as [CGFloat] { f.svgLine("M\(x) 62V66Q\(x) 69 \(x + 3) 68", 0x5E6B73, 1.4) }
        // A shirt, a towel and a sports bag on the hooks.
        f.svg("M30 68H42L46 74L42 76V100H30V76L26 74Z", 0x2F5BD3)
        f.rect(46, 68, 9, 30, 0xFFFDF6, radius: 1)
        f.svgLine("M46 92H55", 0xC8261B, 1.4)
        f.rect(58, 72, 15, 14, 0xF2711C, radius: 3)
        f.svgLine("M61 72Q65.5 64 70 72", 0x2E2117, 1.4)
        // Bench
        f.rect(28, 148, 46, 7, 0x9A6A42, radius: 1.5)
        f.svgLine("M33 155V176M70 155V176", 0x5E6B73, 2.4)
        f.rect(36, 141, 14, 7, 0xC9A15B, radius: 2)
    }

    /// A small white plate above the frame with the door's `icons` (or `text`).
    private static func plate(_ f: PropPen, _ p: PalacePropParams) {
        let icons = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:))
        guard !icons.isEmpty || p.text != nil else { return }
        f.rect(8, 0, 64, 17, 0x1E1E1C, radius: 2, 0.14)
        f.rect(7, -1, 64, 17, 0xFFFDF6, radius: 2)
        f.stroke(Path(roundedRect: CGRect(x: 8.5, y: 0.5, width: 61, height: 14), cornerRadius: 1.5), 0x1F3A6B, 1)
        var x = 39 - CGFloat(icons.count) * 7.5
        for icon in icons {
            icon.draw(f, in: CGRect(x: x + 1, y: 1.5, width: 12, height: 12), color: 0x1F3A6B, detail: 0xFFFDF6)
            x += 15
        }
        if icons.isEmpty, let text = p.text {
            f.text(text, PropFont.heavy(8.5), 0x1F3A6B, at: CGPoint(x: 39, y: 7.5), maxWidth: 56)
        }
    }

    // MARK: Drip

    /// A patient resting in a reclining chair (96 × 112), a drip on a stand running into the arm
    /// on the armrest. `variant` the patient's look.
    static func drip(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 112))
        let v = Look.at(p.variant ?? 2)
        let chair: UInt32 = 0x5E7A68
        f.oval(4, 104, 90, 6, 0x1E1E1C, 0.14)
        f.svg("M5 30Q5 20 13 20H25Q32 20 32 30V86H5Z", chair)
        f.rect(5, 74, 66, 13, PalaceInk.shade(chair, 0.86), radius: 5)
        f.svgLine("M12 87V102M62 87V102", 0x3E4C55, 2.4)
        // The patient
        f.svg("M12 76L13 50C14 43 18 40 24 40C30 40 34 43 35 50L36 76Z", v.coat)
        f.svg("M17 66H58Q63 66 63 71V77H17Z", v.trousers)
        f.svgLine("M58 74V97", v.trousers, 6)
        f.svg("M53 96H63Q67 96 67 99V101H53Z", 0x2E2117)
        f.svg("M18 40L24 46L30 40Z", 0xEFEBE2)
        f.dot(24, 28, 10.5, v.skin)
        f.svg("M13.5 27C13 19 18 16 24 16C30 16 35 19 34.5 27C32.5 22.5 29 21.5 24 21.5C19 21.5 15.5 22.5 13.5 27Z", v.hair)
        f.svgLine("M27.5 28.5Q29.5 30 31.5 28.5", 0x2E2117, 1.1)
        f.svgLine("M27.5 33Q29.5 34.4 31.5 33", 0x8C5A3C, 1.1)
        f.rect(26, 60, 38, 9, PalaceInk.shade(chair, 1.12), radius: 4)
        f.svgLine("M31 48C34 56 37 61 42 62L54 62", v.coat, 6)
        f.dot(56, 62, 3.2, v.skin)
        f.rect(46.5, 59, 6, 5.5, 0xFFFDF6, radius: 1)
        // The drip on its stand
        f.svgLine("M83 8V102", 0x5E6B73, 2.2)
        f.svgLine("M71 106L83 101L95 106", 0x5E6B73, 2)
        f.dot(71, 107, 2.2, 0x3E4C55)
        f.dot(95, 107, 2.2, 0x3E4C55)
        f.svgLine("M75 8H91", 0x5E6B73, 2)
        f.svgLine("M82 8V11", 0x5E6B73, 1.2)
        let bag = Path(roundedRect: CGRect(x: 75, y: 11, width: 15, height: 24), cornerRadius: 4)
        f.fill(bag, 0xEFEBE2)
        f.rect(77, 19, 11, 14, 0xFAC775, radius: 3, 0.75)
        f.stroke(bag, 0xB4B2A9, 1)
        f.rect(79, 22, 7, 5, 0xFFFDF6, radius: 0.8)
        f.rect(80.5, 35, 4, 9, 0xEFEBE2, radius: 1)
        f.dot(82.5, 39.5, 1.2, 0x8FB6CF)
        f.svgLine("M82.5 44C83 62 70 66 52 62", 0x9A9890, 1.3)
    }

    // MARK: Bed

    /// A hospital bed seen from the side (144 × 112), head on the left. `accessory` "recover": the
    /// patient sits up smiling with a thumb up, the chart on the foot of the bed goes up.
    /// "serious": the patient lies flat under an oxygen mask, a monitor flashes red. `variant` look.
    static func bed(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 144, height: 112))
        let v = Look.at(p.variant ?? 5)
        let serious = p.accessory == "serious"
        f.oval(8, 104, 130, 7, 0x1E1E1C, 0.15)
        f.svgLine("M18 84V102M126 84V102", 0x5E6B73, 3)
        f.dot(18, 104, 3.4, 0x3E4C55)
        f.dot(126, 104, 3.4, 0x3E4C55)
        f.rect(10, 78, 124, 7, 0xB4B2A9, radius: 2)
        f.rect(4, 42, 10, 46, 0xB4B2A9, radius: 3)
        f.rect(130, 52, 10, 36, 0xB4B2A9, radius: 3)
        f.rect(10, 66, 122, 13, 0xFFFDF6, radius: 4)
        f.stroke(Path(roundedRect: CGRect(x: 10, y: 66, width: 122, height: 13), cornerRadius: 4), 0xD3D1C7, 1)
        if serious {
            // Monitor with an alarm
            f.rect(0, 0, 50, 34, 0xC8261B, radius: 6, 0.14)
            f.svgLine("M10 34V44", 0x5E6B73, 2)
            f.rect(3, 4, 44, 28, 0x2E2117, radius: 3)
            f.rect(6, 7, 38, 19, 0x232B3B, radius: 1)
            f.svgLine("M7 18H14L17 10L21 25L25 13L28 18H43", 0xC8261B, 1.6)
            f.dot(41, 29, 1.6, 0xC8261B)
            f.svg("M58 4L66 18H50Z", 0xC8261B)
            f.svgLine("M58 8.5V13", 0xFFFDF6, 1.6)
            f.dot(58, 15.6, 0.9, 0xFFFDF6)
            f.svgLine("M52 2L49 -1M64 2L67 -1M69 12H73", 0xC8261B, 1.4)
            // Lying flat under a pale blanket, an oxygen mask on
            f.oval(14, 56, 30, 13, 0xEFEBE2)
            f.dot(30, 59, 9, v.skin)
            f.svg("M21.5 58C21 51 25 49 30 49C35 49 38.5 51 38.5 56C36 53.5 33 53 30 53C26 53 23.5 54.5 21.5 58Z", v.hair)
            f.svgLine("M31 58.5H35", 0x2E2117, 1.1)
            f.svg("M21.5 55C23 52 27 50.5 31 50.5C34 50.5 36.5 51.5 38 53L37 56.5C35 55 33 54.5 30 54.5C26.5 54.5 23.5 55.5 22 57.5Z", 0xFFFDF6)
            f.svgLine("M27 51.2L28 55", 0xD3D1C7, 0.8)
            let mask = PalaceSVG.path("M32.5 62.5Q33 55.5 40 56Q45.5 58 43.5 64.5Q39.5 69.5 34 67Z")
            f.fill(mask, 0x5DCAA5, 0.85)
            f.stroke(mask, 0x1E7A4C, 1)
            f.svgLine("M33 60L24 56", 0x1E7A4C, 0.9)
            f.svgLine("M42 66C50 74 44 82 32 86", 0x1E7A4C, 1.8)
            f.svg("M36 66Q46 60 58 61H128Q132 61 132 66V74H36Z", 0xA9CBE0)
            f.svgLine("M18 32C22 44 30 50 46 66", 0x5E6B73, 1)
        } else {
            // Sitting up against a raised backrest, a thumb up
            f.svg("M14 66L26 30H38L30 66Z", 0xD3D1C7)
            f.oval(22, 30, 18, 26, 0xEFEBE2)
            f.svg("M30 66L33 46C34 39 38 36 43 36C49 36 52 40 53 46L56 66Z", 0x9CC3DE)
            for (x, y) in [(38.0, 46.0), (46.0, 50.0), (40.0, 58.0), (50.0, 60.0)] { f.dot(x, y, 1.1, 0x5E8FB0) }
            f.svg("M44 58H126Q131 58 131 64V72H44Z", 0x5DCAA5)
            f.svg("M112 58Q118 48 124 58Z", 0x5DCAA5)
            f.dot(42, 25, 10, v.skin)
            f.svg("M32 24C31.5 16 36 13 42 13C48 13 52.5 16 52 24C50 19.5 46.5 18.5 42 18.5C37.5 18.5 34 19.5 32 24Z", v.hair)
            f.dot(47, 25, 1.3, 0x2E2117)
            f.dot(45, 30, 2.4, 0xE06A5A, 0.5)
            f.svgLine("M44.5 30.5Q47 33 49.5 30.5", 0x8C5A3C, 1.2)
            f.svgLine("M49 44C57 46 61 42 63 34", 0x7FA9C8, 6)
            f.dot(63.5, 32, 3.6, v.skin)
            f.svgLine("M63.5 29.5V25", v.skin, 2.6)
            // Chart on the foot of the bed: a line going up
            f.rect(112, 22, 32, 36, 0x1E1E1C, radius: 2, 0.14)
            f.rect(110, 20, 32, 36, 0xFFFDF6, radius: 2)
            f.stroke(Path(roundedRect: CGRect(x: 110, y: 20, width: 32, height: 36), cornerRadius: 2), 0xB4B2A9, 1)
            f.rect(120, 17, 12, 5, 0x5E6B73, radius: 1.5)
            f.svgLine("M114 48H138M114 40H138M114 32H138", 0xE2DED3, 0.8)
            f.svgLine("M114 50L121 46L127 47L137 30", 0x1E7A4C, 2.2)
            f.svg("M139 26L139.5 34L132.5 31Z", 0x1E7A4C)
        }
    }

    // MARK: Pill box

    /// A wall card (100 × 76): a row of calendar pages for the years `labels` with an arrow running
    /// on, over a pill box with a pill for each day of the week; `text` under it ("elke dag").
    static func pillWeek(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 76))
        f.rect(2, 3, 98, 73, 0x1E1E1C, radius: 4, 0.14)
        f.rect(0, 0, 98, 73, 0xFFFDF6, radius: 4)
        f.stroke(Path(roundedRect: CGRect(x: 2.5, y: 2.5, width: 93, height: 68), cornerRadius: 3), 0x1F3A6B, 1.4)
        let years = Array((p.labels ?? []).prefix(4))
        var x: CGFloat = 7
        for year in years {
            f.rect(x, 7, 17, 17, 0xEFEBE2, radius: 1.5)
            f.stroke(Path(roundedRect: CGRect(x: x, y: 7, width: 17, height: 17), cornerRadius: 1.5), 0xB4B2A9, 0.8)
            f.rect(x, 7, 17, 5, 0xC8261B, radius: 1.5)
            f.text(year, PropFont.condensed(7), 0x1E1E1C, at: CGPoint(x: x + 8.5, y: 18.5), maxWidth: 15)
            x += 19
        }
        f.svgLine("M\(x) 15.5H90", 0x1F3A6B, 1.8)
        f.svg("M92 15.5L86 11.5V19.5Z", 0x1F3A6B)
        // The week box
        let days = ["m", "d", "w", "d", "v", "z", "z"]
        let lids: [UInt32] = [0x5DCAA5, 0xFAC775, 0xA9CBE0, 0xED93B1, 0xF2711C, 0x5DCAA5, 0xFAC775]
        f.rect(6, 30, 87, 27, 0x5E6B73, radius: 3)
        for (i, day) in days.enumerated() {
            let cx = 6 + 2 + CGFloat(i) * 12 + 5.5
            f.rect(cx - 5.5, 32, 11, 23, 0xFFFDF6, radius: 2)
            f.rect(cx - 5.5, 32, 11, 7, lids[i], radius: 2)
            f.text(day, PropFont.heavy(6), 0x1E1E1C, at: CGPoint(x: cx, y: 35.6))
            f.oval(cx - 3.6, 44, 7.2, 4.4, 0xC8261B)
            f.oval(cx - 2.4, 49, 4.8, 4, 0xFFFDF6)
            f.stroke(Path(ellipseIn: CGRect(x: cx - 2.4, y: 49, width: 4.8, height: 4)), 0xB4B2A9, 0.8)
        }
        if let text = p.text {
            f.text(text, PropFont.heavy(8), 0x1F3A6B, at: CGPoint(x: 49, y: 64), maxWidth: 80)
        }
    }
}
