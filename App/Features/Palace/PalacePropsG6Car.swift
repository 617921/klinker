import SwiftUI

/// A side-view car for any street or garage (on a lift for a service, or for sale), and a fuel
/// pump filling one up.
enum G6Cars {
    static let paints: [UInt32] = [0xC8261B, 0x2F5BD3, 0x0F6E56, 0xF2B33D, 0x5E6B73, 0xEFEBE2]

    static func car(_ pen: PropPen, _ p: PalacePropParams) {
        let colour = paints[((p.variant ?? 0) % paints.count + paints.count) % paints.count]
        switch p.accessory ?? "plain" {
        case "lift":
            let f = pen.fitted(CGSize(width: 168, height: 104))
            serviced(f, colour)
        case "sale":
            let f = pen.fitted(CGSize(width: 156, height: 100))
            f.oval(8, 92, 140, 8, 0x1E1E1C, 0.18)
            body(f.within(CGRect(x: 6, y: 34, width: 144, height: 66), unit: 144 / 140), colour)
            forSale(f, p)
        default:
            let f = pen.fitted(CGSize(width: 140, height: 64))
            f.oval(6, 57, 128, 7, 0x1E1E1C, 0.18)
            body(f, colour)
        }
    }

    // MARK: Car body

    /// A small hatchback facing right in a 140 × 64 box, wheels touching the bottom.
    static func body(_ f: PropPen, _ c: UInt32) {
        let dark = PalaceInk.shade(c, 0.78)
        f.svg("M8 50V36Q8 30 16 29L38 26L52 10Q56 6 64 6H96Q104 6 110 12L124 27Q134 29 136 36V50Q136 54 132 54H12Q8 54 8 50Z", c)
        f.svg("M56 12Q58 10 62 10H78V27H44Z", 0xBFD9E6)
        f.svg("M82 10H96Q101 10 105 14L117 27H82Z", 0xBFD9E6)
        f.svg("M60 12L52 26H56L64 12Z M90 12L84 26H88L94 12Z", 0xFFFFFF, 0.4)
        f.svgLine("M80 8V52M44 28V50", dark, 1.2)
        f.rect(68, 32, 8, 2.4, dark, radius: 1)
        f.rect(98, 32, 8, 2.4, dark, radius: 1)
        f.svg("M118 22L124 22L123 27H117Z", dark)
        f.svg("M128 32H136V38H130Z", 0xFAC775)
        f.svg("M8 33H13V40H8Z", 0xC8261B)
        f.rect(6, 44, 132, 5, PalaceInk.shade(c, 0.6), radius: 2)
        f.rect(18, 46, 16, 4, 0xF2C230, radius: 0.8)
        for x in [32.0, 110] as [CGFloat] {
            f.dot(x, 52, 12, 0x2E2117)
            f.dot(x, 52, 6, 0xB4B2A9)
            f.dot(x, 52, 2.4, 0x5E6B73)
        }
    }

    // MARK: Service

    /// On lift arms (168 × 104): the car up high, oil running from its engine into a pan on a
    /// stand, a fresh can of oil and a new filter beside it.
    private static func serviced(_ f: PropPen, _ c: UInt32) {
        body(f.within(CGRect(x: 14, y: 0, width: 140, height: 64)), c)
        f.rect(0, 64, 168, 5, 0xF2C230, radius: 1.5)
        f.rect(36, 60, 10, 6, 0x1E1E1C, radius: 1)
        f.rect(118, 60, 10, 6, 0x1E1E1C, radius: 1)
        // oil stream into a pan on a stand
        f.svgLine("M124 66Q125 74 124 84", 0x7A4A10, 2.6)
        f.oval(108, 82, 32, 8, 0x3E4C55)
        f.oval(111, 83, 26, 4.5, 0x7A4A10)
        f.rect(122, 90, 4, 12, 0x3E4C55)
        f.rect(114, 100, 20, 3, 0x3E4C55, radius: 1)
        // new oil can and filter
        f.svg("M40 102V84L46 78H60V102Z", 0xFAC775)
        f.svg("M46 78L44 72H50L52 78Z", 0x1E1E1C)
        f.svg("M50 86C50 86 54 91 54 94A4 4 0 0 1 46 94C46 91 50 86 50 86Z", 0x7A4A10)
        f.rect(64, 88, 14, 14, 0x1F3A6B, radius: 2)
        f.svgLine("M64 92H78M64 98H78", 0x2F5BD3, 1.2)
        f.rect(67, 85, 8, 3, 0x8E9AA0, radius: 1)
        PalaceIcon.check.draw(f, in: CGRect(x: 80, y: 78, width: 16, height: 16), color: 0x1E7A4C, detail: 0xFFFDF6)
    }

    // MARK: For sale

    /// A card behind the windscreen with a red header (`caption`) and a big price (`text`).
    private static func forSale(_ f: PropPen, _ p: PalacePropParams) {
        let card = CGRect(x: 54, y: 0, width: 62, height: 40)
        f.svgLine("M70 40L66 46M100 40L104 46", 0x5E6B73, 1.2)
        f.rect(card.offsetBy(dx: 1.5, dy: 2), 0x1E1E1C, radius: 2, 0.15)
        f.rect(card, 0xFFFDF6, radius: 2)
        f.stroke(Path(roundedRect: card, cornerRadius: 2), 0xC8261B, 1.4)
        f.rect(card.minX, card.minY, card.width, 13, 0xC8261B, radius: 2)
        if let caption = p.caption {
            f.text(caption, PropFont.heavy(9), 0xFFFFFF, at: CGPoint(x: card.midX, y: 7), maxWidth: card.width - 6)
        }
        if let text = p.text {
            f.text(text, PropFont.heavy(15), 0xC8261B, at: CGPoint(x: card.midX, y: 26.5), maxWidth: card.width - 6)
        }
    }

    // MARK: Fuel pump

    /// A fuel pump (120 × 168): the display shows `text` (and `caption` under it); its hose runs to
    /// the filler of a car's back end, the nozzle in.
    static func fuelPump(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 120, height: 168))
        f.oval(0, 160, 120, 8, 0x1E1E1C, 0.16)
        // the pump on an island
        f.rect(0, 152, 56, 10, 0xD3D1C7, radius: 1.5)
        f.rect(6, 38, 42, 116, 0xEFEBE2, radius: 4)
        f.rect(6, 38, 42, 18, 0x0F6E56, radius: 4)
        f.svg("M27 41C27 41 33 47 33 50.5A6 6 0 0 1 21 50.5C21 47 27 41 27 41Z", 0xFFFDF6)
        f.rect(10, 62, 34, 30, 0x232B3B, radius: 2)
        if let text = p.text { f.text(text, PropFont.mono(9.5), 0xFAC775, at: CGPoint(x: 27, y: 72), maxWidth: 31) }
        if let caption = p.caption { f.text(caption, PropFont.mono(7), 0x5DCAA5, at: CGPoint(x: 27, y: 84), maxWidth: 31) }
        f.rect(12, 98, 30, 16, 0xD3D1C7, radius: 1.5)
        for i in 0..<3 { f.rect(15 + CGFloat(i) * 9, 102, 6, 8, 0x5E6B73, radius: 1) }
        f.rect(46, 100, 8, 16, 0x1E1E1C, radius: 2)
        // hose to the car
        f.svgLine("M50 112C62 150 76 150 80 118", 0x1E1E1C, 3)
        // the car's back end, facing right, cut by the frame
        var car = f
        car.ctx.clip(to: Path(CGRect(x: 58, y: 0, width: 62, height: 168)))
        body(car.within(CGRect(x: 60, y: 92, width: 140, height: 64)), 0x2F5BD3)
        f.rect(76, 108, 10, 9, 0x1E1E1C, radius: 1)
        f.svg("M72 104L84 112L80 120L70 114Z", 0x0F6E56)
        f.svg("M84 112L90 114L88 117L82 116Z", 0x3E4C55)
    }
}
