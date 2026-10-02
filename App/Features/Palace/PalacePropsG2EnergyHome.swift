import SwiftUI

/// Energy at home: a thermostat turned down, a washing machine with its energy label, and a
/// solar panel on a stand under the sun.
enum G2EnergyHomeProps {
    // MARK: Thermostat

    /// A thermostat on a little stand (76 × 84): the old setting `caption` ("21°") struck out
    /// small, the new one `text` ("19°") big, a blue arrow down, and a piggy bank getting a coin.
    static func thermostat(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 84))
        f.oval(6, 78, 56, 6, 0x1E1E1C, 0.15)
        f.rect(28, 58, 10, 20, 0x8C9499)
        f.rect(16, 76, 34, 4, 0x5E6B73, radius: 1.5)
        f.rect(5, 3, 56, 56, 0x1E1E1C, radius: 10, 0.15)
        f.rect(4, 1, 56, 56, 0xFFFDF6, radius: 10)
        f.ring(32, 29, 21, 0xE2DED3, 4)
        var arc = Path()
        arc.addArc(center: CGPoint(x: 32, y: 29), radius: 21, startAngle: .degrees(140), endAngle: .degrees(240), clockwise: false)
        f.stroke(arc, 0x2F5BD3, 4)
        f.text(p.text ?? "", PropFont.heavy(15), 0x1F3A6B, at: CGPoint(x: 33, y: 32), maxWidth: 32)
        if let caption = p.caption {
            f.text(caption, PropFont.demi(8.5), 0x8C9499, at: CGPoint(x: 33, y: 17), maxWidth: 24)
            f.line(25, 18.5, 41, 15.5, 0xC8261B, 1.4)
        }
        f.svgLine("M10 10V24M5.5 19.5L10 25L14.5 19.5", 0x2F5BD3, 2.6)
        // Piggy bank with a coin going in
        PalaceIcon.g2Piggy.draw(f, in: CGRect(x: 50, y: 52, width: 26, height: 26), color: 0xE88FA8, detail: 0xFFFDF6)
        f.dot(63, 46, 4.5, G2Props.coin)
        f.ring(63, 46, 3, 0xC9A15B, 0.9)
    }

    // MARK: Energy label

    /// A washing machine (90 × 100) with an energy label stuck on: seven bars from green to red,
    /// A to G, and a black arrow at the `highlight` one (0 = A).
    static func energyLabel(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 90, height: 100))
        f.oval(2, 94, 70, 6, 0x1E1E1C, 0.15)
        f.rect(4, 22, 64, 74, 0xF4F1EA, radius: 3)
        f.rect(4, 22, 64, 12, 0xE2DED3, radius: 3)
        f.rect(8, 25, 18, 5, 0x5E6B73, radius: 1.5)
        f.dot(56, 28, 3, 0x8C9499)
        f.dot(34, 64, 21, 0xB4B2A9)
        f.dot(34, 64, 17, 0xBCCDD6)
        f.svg("M20 66Q34 58 48 66V72Q34 82 20 72Z", 0x5E8C9A, 0.5)
        f.dot(28, 58, 3, 0xFFFFFF, 0.6)
        // The label
        let label = CGRect(x: 50, y: 2, width: 38, height: 62)
        f.rect(label.offsetBy(dx: 1.5, dy: 2), 0x1E1E1C, radius: 2, 0.15)
        f.rect(label, 0xFFFFFF, radius: 2)
        let colours: [UInt32] = [0x1E7A4C, 0x4C9A3C, 0xB5C832, 0xF2D02E, 0xF2B33D, 0xF2711C, 0xC8261B]
        let letters = ["A", "B", "C", "D", "E", "F", "G"]
        let pick = max(0, min(p.highlight ?? 0, 6))
        for i in 0..<7 {
            let y = label.minY + 4 + CGFloat(i) * 8
            let w = 12 + CGFloat(i) * 2.6
            f.svg("M\(label.minX + 3) \(y)H\(label.minX + 3 + w)L\(label.minX + 6 + w) \(y + 3.2)L\(label.minX + 3 + w) \(y + 6.4)H\(label.minX + 3)Z", colours[i])
            f.text(letters[i], PropFont.heavy(5.5), 0xFFFFFF, at: CGPoint(x: label.minX + 6, y: y + 3.3))
        }
        let ay = label.minY + 4 + CGFloat(pick) * 8
        f.svg("M\(label.maxX - 1) \(ay - 2)H\(label.maxX - 12)L\(label.maxX - 17) \(ay + 3.2)L\(label.maxX - 12) \(ay + 8.4)H\(label.maxX - 1)Z", 0x1E1E1C)
        f.text(letters[pick], PropFont.heavy(8), 0xFFFFFF, at: CGPoint(x: label.maxX - 7, y: ay + 3.3))
    }

    // MARK: Solar panel

    /// A solar panel on a tilted stand (90 × 140) under a shining sun, a cable to a plug with a bolt.
    static func solarPanel(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 90, height: 140))
        PalaceIcon.sun.draw(f, in: CGRect(x: 46, y: 0, width: 42, height: 42), color: 0xF2B33D, detail: 0xFAC775)
        f.oval(4, 132, 80, 7, 0x1E1E1C, 0.15)
        f.svgLine("M20 100L14 134M68 82L74 134M14 120H74", 0x5E6B73, 3)
        // The panel, tilted towards the sun
        let panel = "M4 104L66 58L86 76L24 122Z"
        f.svg(panel, 0x8C9499)
        f.svg("M8 104L66 61L82 76L24 118Z", 0x1F3A6B)
        for k in 1..<4 {
            let t = CGFloat(k) / 4
            f.line(8 + 58 * t, 104 - 43 * t, 24 + 58 * t, 118 - 42 * t, 0x5E7FB8, 1)
        }
        for k in 1..<3 {
            let t = CGFloat(k) / 3
            f.line(8 + 16 * t, 104 + 14 * t, 66 + 16 * t, 61 + 15 * t, 0x5E7FB8, 1)
        }
        f.svg("M14 104L30 92L34 96L18 108Z", 0xFFFFFF, 0.25)
        // Cable to a plug
        f.svgLine("M74 82Q86 96 80 112", 0x1E1E1C, 1.6)
        f.rect(74, 112, 12, 9, 0x3E4C55, radius: 2)
        PalaceIcon.g2Bolt.draw(f, in: CGRect(x: 75, y: 112, width: 10, height: 10), color: 0xFAC775, detail: 0x3E4C55)
    }
}
