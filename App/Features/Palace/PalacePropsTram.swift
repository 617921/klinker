import SwiftUI

/// Tram props: the destination display, an open tram door (someone stepping out, or a ramp with
/// a wheelchair), the buffer at the end of the track, and a clock right on the hour.
enum PalaceTramProps {
    // MARK: Destination display

    /// A dark display across the frame: line number `caption` in a yellow box, destination `text`
    /// and a big arrow pointing the way the tram goes.
    static func lineDisplay(_ pen: PropPen, _ p: PalacePropParams) {
        let w = pen.size.width, h: CGFloat = 28
        let panel = CGRect(x: 0, y: (pen.size.height - h) / 2, width: w, height: h)
        pen.rect(panel, 0x1E1E1C, radius: 3)
        let inner = panel.insetBy(dx: 2.5, dy: 2.5)
        pen.rect(inner, 0x232B3B, radius: 2)
        var x = inner.minX + 3
        if let line = p.caption {
            let box = CGRect(x: x, y: inner.minY + 2.5, width: 20, height: inner.height - 5)
            pen.rect(box, 0xFAC775, radius: 2)
            pen.text(line, PropFont.heavy(13), 0x1E1E1C, at: CGPoint(x: box.midX, y: box.midY + 0.5))
            x = box.maxX + 5
        }
        let arrow = CGRect(x: inner.maxX - 26, y: inner.midY - 11, width: 22, height: 22)
        PalaceIcon.arrow.draw(pen, in: arrow, color: 0xFAC775, detail: 0x232B3B)
        if let text = p.text {
            pen.text(text, PropFont.condensed(14), 0xFAC775, at: CGPoint(x: x, y: inner.midY + 0.5), anchor: .leading, maxWidth: arrow.minX - x - 3)
        }
    }

    // MARK: Tram door

    /// An open tram door (52 × 100). `accessory` "exit": someone stepping out under a green arrow;
    /// "ramp": a ramp folded down to the platform, a wheelchair coming out, the wheelchair sign.
    static func tramDoor(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 52, height: 100))
        f.rect(0, 0, 52, 100, 0x2F5BD3)
        f.rect(5, 3, 42, 95, 0x3E4C55)
        f.rect(5, 3, 42, 40, 0x5E6B73)
        f.rect(8, 6, 36, 22, 0xBCCDD6, 0.5)
        f.rect(1.5, 3, 3.5, 95, 0x21468B)
        f.rect(47, 3, 3.5, 95, 0x21468B)
        f.rect(4, 92, 44, 6, 0xB4B2A9)
        if p.accessory == "ramp" {
            f.rect(44, 6, 2.6, 86, 0xFAC775)
            f.svg("M4 82H48L56 101H-4Z", 0xB4B2A9)
            f.svgLine("M1 90H51M-1 95H53", 0x8E8A80, 1)
            wheelchair(f)
            f.rect(30, 6, 16, 16, 0x2F5BD3, radius: 2)
            f.stroke(Path(roundedRect: CGRect(x: 30, y: 6, width: 16, height: 16), cornerRadius: 2), 0xFFFDF6, 1.2)
            PalaceIcon.wheelchair.draw(f, in: CGRect(x: 32, y: 8, width: 12, height: 12), color: 0xFFFDF6, detail: 0x2F5BD3)
        } else {
            f.rect(14, 6, 2.6, 86, 0xFAC775)
            stepper(f)
            f.rect(30, 7, 16, 16, 0x1E7A4C, radius: 2)
            f.svgLine("M33.5 10.5L41.5 18.5M42 12V19H35", 0xFFFFFF, 2.2)
        }
    }

    /// Someone stepping down out of the door toward the viewer's right.
    private static func stepper(_ f: PropPen) {
        let v = PalaceFigures.Look.at(4)
        f.svgLine("M22 70L20 92M28 70L38 84L44 98", v.trousers, 4.6)
        f.svg("M15 89H24V94H15Z M40 95H50V100H40Z", 0x2E2117)
        f.svg("M15 73L16 42C17 36 20 33 25 33C30 33 33 36 34 42L35 73Z", v.coat)
        f.svgLine("M18 42C16 50 16 58 17 63", PalaceInk.shade(v.coat, 0.78), 5)
        f.svgLine("M32 42C36 48 40 52 44 54", v.coat, 5)
        f.dot(45, 55, 2.6, v.skin)
        f.rect(38, 52, 9, 8, v.bag, radius: 1.5)
        f.dot(25, 23, 8.5, v.skin)
        f.svg("M16.5 22C16 15 20 12.5 25 12.5C30.5 12.5 34 15.5 33.5 22C31.5 18 28.5 17 25 17C21.5 17 18.5 18 16.5 22Z", v.hair)
        f.dot(29.5, 23.5, 1.1, 0x2E2117)
    }

    /// A wheelchair user rolling out onto the ramp.
    private static func wheelchair(_ f: PropPen) {
        let v = PalaceFigures.Look.at(1)
        f.svgLine("M12 50V68H34L37 77", 0x3E4C55, 2.6)
        f.ring(20, 72, 11, 0x1E1E1C, 2.6)
        f.dot(20, 72, 1.8, 0x1E1E1C)
        f.dot(37, 80, 2.6, 0x1E1E1C)
        f.svg("M13 64L14 38C15 33 18 30 22 30C26 30 28.5 33 29 38L30 64Z", v.coat)
        f.svgLine("M22 64H34L35 77", v.trousers, 5)
        f.svg("M32 75H40V79H32Z", 0x2E2117)
        f.svgLine("M27 40L31 52L24 58", v.coat, 4.4)
        f.dot(23.5, 58, 2.4, v.skin)
        f.dot(21.5, 21, 8, v.skin)
        f.svg("M13.5 20C13 13 17 10.5 21.5 10.5C26.5 10.5 30 13.5 29.5 20C28 16 25 15 21.5 15C18 15 15.5 16 13.5 20Z", v.hair)
        f.dot(26, 21.5, 1.1, 0x2E2117)
    }

    // MARK: End of the track

    /// The buffer stop at the end of the rails (74 × 80): a striped beam on a steel block, a red
    /// lamp, and a little line map whose last stop is the big one.
    static func bufferStop(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 74, height: 80))
        f.svgLine("M36 2V30", 0x5E6B73, 2.4)
        f.rect(4, 2, 66, 18, 0xFFFDF6, radius: 2.5)
        f.stroke(Path(roundedRect: CGRect(x: 4, y: 2, width: 66, height: 18), cornerRadius: 2.5), 0x1F3A6B, 1.4)
        f.line(11, 11, 56, 11, 0x1F3A6B, 2.4)
        for x in [12.0, 24, 36] as [CGFloat] { f.dot(x, 11, 2.6, 0x1F3A6B) }
        f.dot(56, 11, 5.6, 0xC8261B)
        f.dot(56, 11, 2.4, 0xFFFDF6)
        f.line(64, 5, 64, 17, 0x1E1E1C, 2.6)
        f.oval(6, 74, 66, 6, 0x1E1E1C, 0.15)
        f.svg("M26 76L34 40H62L68 76Z", 0x5E6B73)
        f.svgLine("M34 40L48 76M62 40L48 76", 0x3E4C55, 1.6)
        f.dot(56, 34, 4.4, 0xC8261B)
        f.dot(56, 34, 7.5, 0xC8261B, 0.2)
        f.rect(53.5, 37, 5, 4, 0x3E4C55)
        let beam = CGRect(x: 12, y: 46, width: 44, height: 14)
        f.rect(beam, 0xFFFDF6)
        var stripes = f
        stripes.ctx.clip(to: Path(beam))
        for k in 0..<6 {
            let x = beam.minX - 8 + CGFloat(k) * 12
            stripes.svg("M\(x) 60L\(x + 8) 46H\(x + 14)L\(x + 6) 60Z", 0xC8261B)
        }
        f.stroke(Path(beam), 0x3E4C55, 1.2)
        f.rect(4, 48, 9, 10, 0x3E4C55, radius: 2)
    }

    // MARK: Right on time

    /// A clock on a bracket (70 × 86) showing exactly `time` (seconds hand on twelve too), with
    /// a small display under it: the same time and a green tick.
    static func punctual(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 70, height: 86), hanging: true)
        f.line(70, 6, 36, 6, 0x5E6B73, 3)
        f.line(36, 6, 36, 14, 0x5E6B73, 2.4)
        let c = CGPoint(x: 36, y: 36)
        f.dot(c.x, c.y, 22, 0x2E2117)
        f.dot(c.x, c.y, 18.5, 0xFFFDF6)
        var ticks = Path()
        for k in 0..<12 {
            let a = Double(k) * .pi / 6
            let inner = k % 3 == 0 ? 13.0 : 15.2
            ticks.move(to: CGPoint(x: c.x + sin(a) * inner, y: c.y - cos(a) * inner))
            ticks.addLine(to: CGPoint(x: c.x + sin(a) * 17, y: c.y - cos(a) * 17))
        }
        f.stroke(ticks, 0x2E2117, 1.6)
        let (hour, minute) = PalaceFigures.parse(p.time ?? "9:00")
        let hourAngle = (Double(hour % 12) + Double(minute) / 60) * 30 * .pi / 180
        let minuteAngle = Double(minute) * 6 * .pi / 180
        f.line(c.x, c.y, c.x + sin(hourAngle) * 10, c.y - cos(hourAngle) * 10, 0x1E1E1C, 3.4)
        f.line(c.x, c.y, c.x + sin(minuteAngle) * 15, c.y - cos(minuteAngle) * 15, 0x1E1E1C, 2.4)
        f.line(c.x, c.y + 4, c.x, c.y - 16, 0xC8261B, 1.2)
        f.dot(c.x, c.y, 2.3, 0xC8261B)
        f.rect(8, 63, 56, 21, 0x232B3B, radius: 3)
        f.text(p.time ?? "9:00", PropFont.mono(12), 0xFAC775, at: CGPoint(x: 30, y: 73.5))
        f.dot(53, 73.5, 6.5, 0x1E7A4C)
        f.svgLine("M49.8 73.8L52.2 76.2L56.4 71.2", 0xFFFFFF, 1.8)
    }
}
