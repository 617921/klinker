import SwiftUI

/// Group g6 (kringloopwinkel, garage, kiosk, brandweer, concertzaal, galerie): routes every g6 prop
/// and holds the small drawing helpers they share (speech bubbles, arrows, sparkles, notes).
enum G6Props {
    static func draw(_ kind: PalacePropKind, _ pen: PropPen, _ p: PalacePropParams) {
        switch kind {
        case .g6Figure: G6People.figure(pen, p)
        case .g6CycleSign: G6Thrift.cycleSign(pen, p)
        case .g6Jumble: G6Thrift.jumble(pen, p)
        case .g6Crockery: G6Thrift.crockery(pen, p)
        case .g6Bargain: G6Thrift.bargain(pen, p)
        case .g6Condition: G6Thrift.condition(pen, p)
        case .g6Damaged: G6Thrift.damaged(pen, p)
        case .g6Refurbish: G6ThriftFloor.refurbish(pen, p)
        case .g6Vintage: G6ThriftFloor.vintage(pen, p)
        case .g6DropOff: G6ThriftFloor.dropOff(pen, p)
        case .g6Proceeds: G6ThriftFloor.proceeds(pen, p)
        case .g6Car: G6Cars.car(pen, p)
        case .g6FuelPump: G6Cars.fuelPump(pen, p)
        case .g6Plate: G6Garage.plate(pen, p)
        case .g6Battery: G6Garage.battery(pen, p)
        case .g6Verdict: G6Garage.verdict(pen, p)
        case .g6Rating: G6Garage.rating(pen, p)
        case .g6Badge: G6Garage.badge(pen, p)
        case .g6Paper: G6Papers.paper(pen, p)
        case .g6Hoax: G6Screens.hoax(pen, p)
        case .g6Broadcast: G6Screens.broadcast(pen, p)
        case .g6NewsTV: G6Screens.newsTV(pen, p)
        case .g6Spread: G6Screens.spread(pen, p)
        case .g6Ticker: G6Screens.ticker(pen, p)
        case .g6Fire: G6Fire.fire(pen, p)
        case .g6Rescue: G6Fire.rescue(pen, p)
        case .g6Hazard: G6Safety.hazard(pen, p)
        case .g6SmokeAlarm: G6Safety.smokeAlarm(pen, p)
        case .g6Responders: G6Safety.responders(pen, p)
        case .g6ExitSign: G6Safety.exitSign(pen, p)
        case .g6Orchestra: G6Music.orchestra(pen, p)
        case .g6Musician: G6Music.musician(pen, p)
        case .g6Instruments: G6Music.instruments(pen, p)
        case .g6Ticket: G6Hall.ticket(pen, p)
        case .g6Crowd: G6Hall.crowd(pen, p)
        case .g6Score: G6Hall.score(pen, p)
        case .g6Bust: G6Hall.bust(pen, p)
        case .g6Podium: G6Hall.podium(pen, p)
        case .g6Painting: G6Art.painting(pen, p)
        case .g6Styles: G6Art.styles(pen, p)
        case .g6Standout: G6Art.standout(pen, p)
        case .g6Choose: G6Art.choose(pen, p)
        case .g6Ribbon: G6ArtFloor.ribbon(pen, p)
        case .g6ExpoPoster: G6ArtFloor.expoPoster(pen, p)
        case .g6Guestbook: G6ArtFloor.guestbook(pen, p)
        default: break
        }
    }

    // MARK: Shared bits

    /// A rounded speech bubble with a tail to `tail`, and up to three short lines of text.
    static func bubble(_ f: PropPen, _ r: CGRect, tail: CGPoint, lines: [String], size: CGFloat = 9, ink: UInt32 = 0x1E1E1C) {
        let base = CGPoint(x: min(max(tail.x, r.minX + 8), r.maxX - 8), y: tail.y > r.midY ? r.maxY - 1 : r.minY + 1)
        f.rect(r.offsetBy(dx: 1, dy: 1.5), 0x1E1E1C, radius: 6, 0.12)
        f.svg("M\(base.x - 5) \(base.y)L\(tail.x) \(tail.y)L\(base.x + 5) \(base.y)Z", 0xFFFDF6)
        f.rect(r, 0xFFFDF6, radius: 6)
        f.stroke(Path(roundedRect: r, cornerRadius: 6), 0xB4B2A9, 0.8)
        let shown = Array(lines.prefix(3))
        let lineH = (r.height - 6) / CGFloat(max(1, shown.count))
        for (i, line) in shown.enumerated() {
            f.text(line, PropFont.demi(size), ink, at: CGPoint(x: r.midX, y: r.minY + 3 + lineH * (CGFloat(i) + 0.5)), maxWidth: r.width - 8)
        }
    }

    /// A straight arrow from `a` to `b` with a filled head.
    static func arrow(_ f: PropPen, _ a: CGPoint, _ b: CGPoint, _ hex: UInt32, _ width: CGFloat = 2.4) {
        let angle = atan2(b.y - a.y, b.x - a.x)
        let head = width * 3
        let back = CGPoint(x: b.x - cos(angle) * head, y: b.y - sin(angle) * head)
        f.line(a.x, a.y, back.x, back.y, hex, width)
        var p = Path()
        p.move(to: b)
        p.addLine(to: CGPoint(x: back.x + cos(angle + .pi / 2) * head * 0.6, y: back.y + sin(angle + .pi / 2) * head * 0.6))
        p.addLine(to: CGPoint(x: back.x - cos(angle + .pi / 2) * head * 0.6, y: back.y - sin(angle + .pi / 2) * head * 0.6))
        p.closeSubpath()
        f.fill(p, hex)
    }

    /// A four-pointed sparkle.
    static func sparkle(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ r: CGFloat, _ hex: UInt32 = 0xFAC775) {
        let k = r * 0.28
        f.svg("M\(x) \(y - r)L\(x + k) \(y - k)L\(x + r) \(y)L\(x + k) \(y + k)L\(x) \(y + r)L\(x - k) \(y + k)L\(x - r) \(y)L\(x - k) \(y - k)Z", hex)
    }

    /// An eighth note whose head sits at (x, y); `crooked` bends its stem and flag.
    static func note(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ hex: UInt32, scale s: CGFloat = 1, crooked: Bool = false) {
        f.oval(x - 3.6 * s, y - 2.6 * s, 7.2 * s, 5.2 * s, hex)
        let stem = crooked ? "M\(x + 3 * s) \(y)L\(x + 5 * s) \(y - 6 * s)L\(x + 1.5 * s) \(y - 11 * s)" : "M\(x + 3.2 * s) \(y)V\(y - 12 * s)"
        f.svgLine(stem, hex, 1.5 * s)
        let top = crooked ? CGPoint(x: x + 1.5 * s, y: y - 11 * s) : CGPoint(x: x + 3.2 * s, y: y - 12 * s)
        f.svgLine("M\(top.x) \(top.y)Q\(top.x + 5 * s) \(top.y + 2 * s) \(top.x + (crooked ? 2 : 5) * s) \(top.y + 7 * s)", hex, 1.5 * s)
    }

    /// A five-pointed star, filled or as an outline.
    static func star(_ f: PropPen, _ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat, _ hex: UInt32, filled: Bool = true) {
        let d = PalacePeople.star(cx: cx, cy: cy, r: r)
        if filled { f.svg(d, hex) } else { f.svgLine(d, hex, 1) }
    }

    /// A little red heart centred at (x, y).
    static func heart(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ r: CGFloat, _ hex: UInt32 = 0xC8261B) {
        f.svg("M\(x) \(y + r)C\(x - r * 1.6) \(y) \(x - r * 1.1) \(y - r * 1.2) \(x) \(y - r * 0.45)C\(x + r * 1.1) \(y - r * 1.2) \(x + r * 1.6) \(y) \(x) \(y + r)Z", hex)
    }
}
