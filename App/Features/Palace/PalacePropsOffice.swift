import SwiftUI

/// Office things that mean their word: a meeting behind glass, the organisation chart with its
/// top box lit, a board of task notes, a report going into a tray, an hourglass with a date.
enum PalaceOfficeProps {
    typealias Look = PalaceFigures.Look

    // MARK: Meeting

    /// A glass meeting room (110 × 150): one person points at a flip chart, the others sit at
    /// the table with their laptops. `count` people at the table (2–4).
    static func meetingTable(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 110, height: 150))
        f.rect(0, 0, 110, 150, 0x5E6B73, radius: 2)
        f.rect(3, 3, 104, 144, 0xE4ECEE)
        // Flip chart on its easel
        f.svgLine("M14 96L22 30M38 96L30 30M26 30V100", 0x3E4C55, 2)
        f.rect(9, 18, 34, 42, 0xFFFDF6, radius: 1)
        f.rect(9, 16, 34, 4, 0x3E4C55, radius: 1)
        f.rect(14, 44, 6, 10, 0x2F5BD3)
        f.rect(22, 38, 6, 16, 0xF2711C)
        f.rect(30, 30, 6, 24, 0x1E7A4C)
        f.svgLine("M13 40L22 34L30 27L38 22M34 22H38V26", 0xC8261B, 1.6)
        // The presenter, pointing
        let v = Look.at(5)
        f.svgLine("M50 120V140M57 120V140", v.trousers, 4.4)
        f.svg("M45 124L46 92C47 86 50 83 54 83C58 83 61 86 62 92L63 124Z", v.coat)
        f.svgLine("M47 92L36 70", v.coat, 5)
        f.dot(35.5, 68.5, 2.8, v.skin)
        f.svgLine("M35 68L30 60", 0x1E1E1C, 1.2)
        f.dot(54, 74, 8, v.skin)
        f.svg("M46 73C46 67 49 65 54 65C59 65 62 67 62 73C60 70 57 69.5 54 69.5C51 69.5 48 70 46 73Z", v.hair)
        f.svgLine("M50 77Q53 79 56 77", 0x2E2117, 1.1)
        // People at the table
        let n = max(2, min(p.count ?? 3, 4))
        let seats: [CGFloat] = [70, 84, 98, 76]
        for i in 0..<n {
            let x = seats[i], l = Look.at(i * 2 + 1)
            let y: CGFloat = i == 3 ? 104 : 92
            f.svg("M\(x - 8) \(y + 22)V\(y + 8)Q\(x - 8) \(y + 1) \(x) \(y + 1)Q\(x + 8) \(y + 1) \(x + 8) \(y + 8)V\(y + 22)Z", l.coat)
            f.dot(x, y - 6, 6.5, l.skin)
            f.svg("M\(x - 6.5) \(y - 6.5)C\(x - 6.5) \(y - 11) \(x - 3.5) \(y - 13) \(x) \(y - 13)C\(x + 3.5) \(y - 13) \(x + 6.5) \(y - 11) \(x + 6.5) \(y - 6.5)C\(x + 4) \(y - 9) \(x - 4) \(y - 9) \(x - 6.5) \(y - 6.5)Z", l.hair)
        }
        f.oval(56, 104, 52, 14, 0x8C5E38)
        f.oval(56, 102, 52, 12, 0xC9965F)
        f.svgLine("M64 116V140M100 116V140", 0x3E4C55, 2.4)
        f.svg("M66 106H76L78 101H68Z M86 106H96L98 101H88Z", 0x3E4C55)
        f.rect(80, 104, 6, 4, 0xFFFDF6, radius: 1)
        f.svg("M4 146L44 3H58L18 146Z", 0xFFFFFF, 0.18)
        f.svg("M70 146L104 26V60L84 146Z", 0xFFFFFF, 0.14)
    }

    // MARK: Organisation chart

    /// A whiteboard (88 × 72): one lit box on top with a person in a tie, lines down to three
    /// grey boxes with people.
    static func orgChart(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 88, height: 72))
        f.rect(1.5, 3, 86, 69, 0x1E1E1C, radius: 2, 0.15)
        f.rect(0, 0, 86, 68, 0xB4B2A9, radius: 2)
        f.rect(3, 3, 80, 62, 0xFFFDF6)
        f.svgLine("M43 28V36M15 36H71M15 36V42M43 36V42M71 36V42", 0x3E4C55, 1.6)
        f.rect(26, 5, 34, 23, 0xF2711C, radius: 2.5)
        person(f, cx: 43, top: 8, colour: 0xFFFDF6, tie: 0xC8261B)
        for x in [15.0, 43, 71] as [CGFloat] {
            f.rect(x - 11, 42, 22, 18, 0xD3D1C7, radius: 2)
            person(f, cx: x, top: 44.5, colour: 0x5E6B73, tie: nil, small: true)
        }
        f.rect(64, 64, 14, 3, 0x2F5BD3, radius: 1)
    }

    private static func person(_ f: PropPen, cx: CGFloat, top: CGFloat, colour: UInt32, tie: UInt32?, small: Bool = false) {
        let s: CGFloat = small ? 0.75 : 1
        f.dot(cx, top + 5 * s, 4.6 * s, colour)
        f.svg("M\(cx - 9 * s) \(top + 19 * s)Q\(cx - 9 * s) \(top + 10.5 * s) \(cx) \(top + 10.5 * s)Q\(cx + 9 * s) \(top + 10.5 * s) \(cx + 9 * s) \(top + 19 * s)Z", colour)
        if let tie { f.svg("M\(cx - 1.4) \(top + 11)H\(cx + 1.4)L\(cx + 2) \(top + 17)L\(cx) \(top + 19)L\(cx - 2) \(top + 17)Z", tie) }
    }

    // MARK: Task board

    /// A board of sticky notes (68 × 78), each with a tick box and a line; `count` of them ticked.
    static func taskBoard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 68, height: 78))
        f.rect(1.5, 3, 66, 75, 0x1E1E1C, radius: 2, 0.15)
        f.rect(0, 0, 66, 74, 0x8C9499, radius: 2)
        f.rect(3, 3, 60, 68, 0xF4F1EA)
        let colours: [UInt32] = [0xFAC775, 0xF4C0D1, 0xC9E6E2, 0xFAC775, 0xC9E6E2, 0xF4C0D1]
        let ticked = max(0, min(p.count ?? 2, 6))
        for i in 0..<6 {
            let x = 6 + CGFloat(i % 2) * 29, y = 6 + CGFloat(i / 2) * 21.5
            let tilt = i % 3 == 1 ? 1.2 : -0.8
            f.rect(x + tilt, y, 26, 19, colours[i], radius: 0.8)
            f.rect(x + tilt + 3, y + 4, 6.5, 6.5, 0xFFFDF6, radius: 1)
            f.stroke(Path(roundedRect: CGRect(x: x + tilt + 3, y: y + 4, width: 6.5, height: 6.5), cornerRadius: 1), 0x3E4C55, 1)
            if i < ticked { PalaceIcon.check.draw(f, in: CGRect(x: x + tilt + 2.5, y: y + 2, width: 9, height: 9), color: 0x1E7A4C, detail: 0xFFFDF6) }
            f.line(x + tilt + 12, y + 6, x + tilt + 23, y + 6, 0x3E4C55, 1.2)
            f.line(x + tilt + 12, y + 10, x + tilt + 20, y + 10, 0x3E4C55, 1.2)
            f.line(x + tilt + 3, y + 15, x + tilt + 21, y + 15, 0xB4B2A9, 1)
            f.dot(x + tilt + 13, y + 1, 1.4, 0xC8261B)
        }
    }

    // MARK: Hand in

    /// A hand slides a report (title `text`) into a letter tray on the desk (96 × 72).
    static func handIn(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 96, height: 72))
        f.oval(2, 66, 64, 6, 0x1E1E1C, 0.15)
        f.svg("M4 46H62L66 66H0Z", 0x3E4C55)
        f.svg("M6 50H60L62 62H4Z", 0x5E6B73)
        f.rect(8, 42, 50, 6, 0xFFFDF6)
        f.rect(10, 38, 46, 5, 0xF4F1EA)
        // The report going in, the hand behind it
        let doc = Path(roundedRect: CGRect(x: -17, y: -22, width: 34, height: 44), cornerRadius: 1.5)
            .applying(CGAffineTransform(rotationAngle: -0.42).concatenating(CGAffineTransform(translationX: 52, y: 26)))
        f.fill(doc.offsetBy(dx: 1.5, dy: 2), 0x1E1E1C, 0.15)
        f.fill(doc, 0xFFFDF6)
        var d = f
        d.ctx.translateBy(x: 52, y: 26)
        d.ctx.rotate(by: .radians(-0.42))
        d.rect(-14, -19, 28, 9, 0x2F5BD3, radius: 1)
        d.text(p.text ?? "", PropFont.heavy(7.5), 0xFFFDF6, at: CGPoint(x: 0, y: -14.5), maxWidth: 26)
        d.svgLine("M-12 -5H12M-12 0H10M-12 5H12M-12 10H6", 0xB4B2A9, 1.3)
        d.rect(5, 12, 7, 6, 0x1E7A4C, radius: 1)
        f.svg("M66 30C70 24 78 22 84 24L96 30V46L84 44C78 44 72 40 68 38Z", 0xC99A74)
        f.svgLine("M68 32L62 30M67 36L60 35", 0xC99A74, 3.4)
        f.rect(88, 26, 8, 22, 0x1F3A6B)
        f.svgLine("M22 12Q34 0 46 6", 0xF2711C, 2)
        f.svgLine("M18 16L22 12L18 7", 0xF2711C, 2)
    }

    // MARK: Hourglass

    /// An hourglass (56 × 80), sand running, a tag (`text`) hanging from it.
    static func hourglass(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 56, height: 80))
        f.oval(2, 74, 46, 6, 0x1E1E1C, 0.16)
        f.svg("M10 8H40Q40 26 28 36V40Q40 50 40 70H10Q10 50 22 40V36Q10 26 10 8Z", 0xE9F1F4)
        f.svg("M13.5 18H36.5Q35 27 27 33H23Q15 27 13.5 18Z", 0xE8B32C)
        f.svg("M12 70Q14 56 25 54Q36 56 38 70Z", 0xE8B32C)
        f.line(25, 34, 25, 54, 0xE8B32C, 1.4)
        f.svg("M13 10H16Q16 26 24 34H22Q13 26 13 10Z", 0xFFFFFF, 0.6)
        f.rect(4, 2, 42, 7, 0x7A5230, radius: 2)
        f.rect(4, 69, 42, 7, 0x7A5230, radius: 2)
        f.svgLine("M8 9V69M42 9V69", 0x4A3524, 2.2)
        guard let text = p.text else { return }
        f.svgLine("M42 14Q50 18 48 30", 0x5F5E5A, 1)
        let tag = CGRect(x: 30, y: 30, width: 26, height: 30)
        f.svg("M\(tag.minX + 4) \(tag.minY)H\(tag.maxX - 4)L\(tag.maxX) \(tag.minY + 5)V\(tag.maxY)H\(tag.minX)V\(tag.minY + 5)Z", 0xFAC775)
        f.dot(tag.midX, tag.minY + 4, 1.6, 0x7A5230)
        let parts = text.split(separator: " ", maxSplits: 1).map(String.init)
        f.text(parts[0], PropFont.demi(8), 0x412402, at: CGPoint(x: tag.midX, y: tag.minY + 13), maxWidth: tag.width - 3)
        if parts.count > 1 {
            f.text(parts[1], PropFont.heavy(8.5), 0x412402, at: CGPoint(x: tag.midX, y: tag.minY + 23), maxWidth: tag.width - 3)
        }
    }
}
