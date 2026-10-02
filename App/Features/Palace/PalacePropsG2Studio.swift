import SwiftUI

/// TV-studio props: the news desk, a camera that is on air, a viewer on the sofa, a film strip of
/// numbered episodes, and an idea board full of colour.
enum G2StudioProps {
    // MARK: News desk

    /// The news desk (146 × 120): a newsreader behind a curved desk, a screen behind with a globe,
    /// a clock showing `time` and a red news ticker.
    static func newsDesk(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 146, height: 120))
        f.rect(6, 2, 134, 74, 0x1E1E1C, radius: 3)
        f.rect(9, 5, 128, 68, 0x1F3A6B, radius: 1.5)
        PalaceIcon.globe.draw(f, in: CGRect(x: 14, y: 10, width: 46, height: 46), color: 0x3E6FB0, detail: 0x1F3A6B)
        f.rect(98, 12, 34, 20, 0x0E1A33, radius: 2)
        f.text(p.time ?? "", PropFont.mono(11), 0xFAC775, at: CGPoint(x: 115, y: 22.5), maxWidth: 32)
        f.rect(9, 60, 128, 9, 0xC8261B)
        f.svgLine("M14 64.5H40M46 64.5H80M86 64.5H130", 0xFFFDF6, 1.6)
        // The newsreader
        let v = PalaceFigures.Look.at(p.variant ?? 5)
        f.svg("M50 92V70C50 60 60 56 73 56C86 56 96 60 96 70V92Z", v.coat)
        f.svg("M66 56L73 66L80 56Z", 0xFFFDF6)
        f.rect(69, 48, 8, 9, v.skin)
        G2People.head(f, v, cx: 73, cy: 40, r: 11, mood: "smile")
        f.rect(56, 78, 34, 10, 0xFFFDF6, radius: 1)
        f.svgLine("M60 82H86M60 85H80", 0xB4B2A9, 0.8)
        // The desk
        f.svg("M2 84Q73 74 144 84V120H2Z", 0x232B3B)
        f.svg("M2 84Q73 74 144 84V89Q73 79 2 89Z", 0x8C9499)
        f.svgLine("M10 104Q73 96 136 104", 0x5E9BD6, 2.4)
    }

    // MARK: Broadcast

    /// A TV camera on a tripod (88 × 116) with a red lamp reading `text` ("LIVE") on top and
    /// signal waves going out from it.
    static func broadcast(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 88, height: 116))
        f.oval(6, 110, 64, 6, 0x1E1E1C, 0.25)
        f.svgLine("M36 70L10 112M36 70L62 112M36 70V112", 0xB4B2A9, 2.6)
        f.rect(30, 62, 12, 10, 0x8C9499, radius: 2)
        f.rect(6, 34, 46, 30, 0x1E1E1C, radius: 4)
        f.rect(6, 34, 46, 6, 0x8C9499, radius: 3)
        f.rect(12, 46, 22, 10, 0x5E6B73, radius: 1.5)
        f.dot(42, 51, 2.4, 0x5DCAA5)
        f.rect(52, 38, 14, 22, 0x2E2117, radius: 2)
        f.dot(66, 49, 9, 0x1E1E1C)
        f.dot(66, 49, 5.5, 0x2F5BD3)
        f.dot(64, 47, 1.6, 0xFFFFFF, 0.7)
        f.rect(0, 40, 8, 14, 0x5E6B73, radius: 1.5)
        f.svgLine("M8 64Q0 70 4 80", 0x1E1E1C, 1.6)
        f.rect(12, 18, 32, 14, 0xC8261B, radius: 3)
        f.dot(28, 25, 16, 0xC8261B, 0.18)
        f.text(p.text ?? "", PropFont.heavy(9), 0xFFFFFF, at: CGPoint(x: 28, y: 25), maxWidth: 28)
        for (k, r) in ([10, 17, 24] as [CGFloat]).enumerated() {
            var arc = Path()
            arc.addArc(center: CGPoint(x: 66, y: 22), radius: r, startAngle: .degrees(-70), endAngle: .degrees(20), clockwise: false)
            f.stroke(arc, 0xFAC775, 2.4 - CGFloat(k) * 0.4)
        }
    }

    // MARK: Viewer

    /// Someone on a sofa (94 × 96) with a remote control and popcorn, looking at a TV whose screen
    /// lights them up.
    static func viewer(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 94, height: 96))
        let v = PalaceFigures.Look.at(p.variant ?? 7)
        f.oval(2, 90, 90, 6, 0x1E1E1C, 0.25)
        // TV on a stand, turned towards the sofa
        f.svgLine("M80 74V90M72 90H88", 0x5E6B73, 2.4)
        f.svg("M70 40L92 34V74L70 70Z", 0x1E1E1C)
        f.svg("M72 42L90 37V71L72 68Z", 0x8FC1E8)
        f.svg("M68 48L40 40V62L68 62Z", 0x8FC1E8, 0.25)
        // Sofa
        f.rect(2, 44, 12, 46, 0x993556, radius: 4)
        f.rect(4, 64, 58, 18, 0xB4426A, radius: 4)
        f.rect(2, 80, 62, 8, 0x993556, radius: 2)
        f.rect(54, 60, 10, 28, 0x993556, radius: 4)
        // Viewer
        f.svg("M18 66V44C18 36 23 33 29 33C35 33 40 36 40 44V66Z", v.coat)
        f.svgLine("M30 66H52V86", v.trousers, 7)
        f.rect(48, 84, 9, 5, 0x2E2117, radius: 1.5)
        G2People.head(f, v, cx: 30, cy: 22, r: 10, mood: "smile")
        f.svgLine("M36 44Q44 50 52 46", v.coat, 5)
        f.dot(53, 45, 2.8, v.skin)
        f.rect(53, 41, 9, 4, 0x1E1E1C, radius: 1.5)
        f.dot(61, 43, 1, 0xC8261B)
        f.svgLine("M64 40L67 38M64 43H68", 0xFAC775, 1)
        // Popcorn
        f.svg("M6 58H18L16 70H8Z", 0xFFFDF6)
        f.svgLine("M9 58L10 70M12 58V70M15 58L14 70", 0xC8261B, 1.2)
        for (x, y) in [(8.0, 56.0), (12, 54), (16, 56), (10, 53)] as [(CGFloat, CGFloat)] { f.dot(x, y, 2.4, 0xFAC775) }
    }

    // MARK: Film strip

    /// A film strip (100 × 76) of five numbered frames under a label (`caption`); the `highlight`
    /// frame is lit, bigger and has a play button.
    static func filmStrip(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 76))
        if let caption = p.caption {
            let font = PropFont.heavy(9.5)
            let w = min(90, f.width(of: caption, font) + 14)
            f.rect(50 - w / 2, 0, w, 15, 0xFAC775, radius: 3)
            f.text(caption, font, 0x1E1E1C, at: CGPoint(x: 50, y: 7.5), maxWidth: w - 6)
        }
        f.rect(0, 22, 100, 46, 0x1E1E1C, radius: 2)
        for k in 0..<12 {
            f.rect(3 + CGFloat(k) * 8.2, 25, 4, 3.4, 0xD3D1C7, radius: 0.8)
            f.rect(3 + CGFloat(k) * 8.2, 61.6, 4, 3.4, 0xD3D1C7, radius: 0.8)
        }
        let pick = p.highlight ?? 2
        let scenes: [UInt32] = [0x5E8C9A, 0x9A6A42, 0x5E8C45, 0x3C3489, 0xC8261B]
        for i in 0..<5 {
            let lit = i == pick
            let r = CGRect(x: 2.5 + CGFloat(i) * 19.2, y: 31, width: 17, height: 28)
            f.rect(r, lit ? 0xFFFDF6 : scenes[i], radius: 1)
            if !lit {
                f.rect(r, 0x1E1E1C, radius: 1, 0.35)
                f.text("\(i + 1)", PropFont.heavy(10), 0xFFFDF6, at: CGPoint(x: r.midX, y: r.midY))
            }
        }
        // The lit frame, bigger
        let big = CGRect(x: 2.5 + CGFloat(pick) * 19.2 - 4, y: 18, width: 25, height: 54)
        f.rect(big.insetBy(dx: -2, dy: -2), 0xFAC775, radius: 2)
        f.rect(big, scenes[pick % scenes.count], radius: 1)
        f.text("\(pick + 1)", PropFont.heavy(13), 0xFFFDF6, at: CGPoint(x: big.midX, y: big.minY + 11))
        f.dot(big.midX, big.maxY - 16, 8, 0xFFFDF6)
        f.svg("M\(big.midX - 2.5) \(big.maxY - 20.5)L\(big.midX + 4) \(big.maxY - 16)L\(big.midX - 2.5) \(big.maxY - 11.5)Z", 0xC8261B)
    }

    // MARK: Idea board

    /// A board (90 × 80) full of colour: sticky notes, sketches, colour swatches, a paint palette and
    /// a big glowing light bulb.
    static func ideaBoard(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 90, height: 80))
        f.rect(1.5, 3, 88, 77, 0x1E1E1C, radius: 3, 0.18)
        f.rect(0, 0, 88, 76, 0xFFFDF6, radius: 3)
        f.rect(6, 8, 18, 16, 0xFAC775, radius: 1)
        f.rect(26, 6, 18, 16, 0xF4C0D1, radius: 1)
        f.rect(8, 28, 18, 16, 0xC9E6E2, radius: 1)
        f.svgLine("M9 13H20M9 17H17M29 11H40M29 15H36M11 33H22M11 37H19", 0x5F5E5A, 1)
        f.svgLine("M30 32Q36 26 40 32T50 32", 0x2F5BD3, 1.8)
        f.svg(PalacePeople.star(cx: 38, cy: 44, r: 6), 0xF2711C)
        for (i, c) in ([0xC8261B, 0xF2B33D, 0x1E7A4C, 0x2F5BD3, 0x3C3489] as [UInt32]).enumerated() {
            f.rect(6 + CGFloat(i) * 9, 56, 8, 14, c, radius: 1)
        }
        PalaceIcon.paint.draw(f, in: CGRect(x: 50, y: 50, width: 24, height: 24), color: 0xC9965F, detail: 0xFFFDF6)
        // Light bulb with rays
        for k in 0..<7 {
            let a = Double(k) * .pi / 6 + .pi
            f.line(68 + CGFloat(cos(a)) * 15, 24 + CGFloat(sin(a)) * 15, 68 + CGFloat(cos(a)) * 20, 24 + CGFloat(sin(a)) * 20, 0xF2B33D, 1.8)
        }
        f.dot(68, 24, 11, 0xFAC775)
        f.rect(63, 33, 10, 8, 0x8C9499, radius: 1.5)
        f.svgLine("M64 36H72M64 39H72", 0x5E6B73, 0.9)
        f.svgLine("M65 28Q68 20 71 28", 0xF2711C, 1.2)
    }
}
