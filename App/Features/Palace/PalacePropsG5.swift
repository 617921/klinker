import SwiftUI

/// Group g5's props (bike shop, DIY store, cinema, theatre, museum, church). `draw` dispatches
/// every g5 kind, so the shared switch in `PalacePropView` stays one line; the drawings live in
/// PalacePropsG5Bike/Tools/People/Makers/Stage/Art/Church.swift, each documented there.
enum G5Props {
    static func draw(_ kind: PalacePropKind, _ pen: PropPen, _ p: PalacePropParams) {
        switch kind {
        case .g5Bike: G5Bike.bike(pen, p)
        case .g5BikePart: G5Bike.part(pen, p)
        case .g5TubePatch: G5Bike.tubePatch(pen, p)
        case .g5Swap: G5Bike.swap(pen, p)
        case .g5Checklist: G5Bike.checklist(pen, p)
        case .g5Tool: G5Tools.tool(pen, p)
        case .g5Sturdy: G5Tools.sturdy(pen, p)
        case .g5Fan: G5People.fan(pen, p)
        case .g5Seats: G5People.seats(pen, p)
        case .g5Maker: G5Makers.maker(pen, p)
        case .g5Group: G5Groups.group(pen, p)
        case .g5Couple: G5Groups.couple(pen, p)
        case .g5Poster: G5Stage.poster(pen, p)
        case .g5Print: G5Stage.print(pen, p)
        case .g5Cloakroom: G5Stage.cloakroom(pen, p)
        case .g5DatePage: G5ChurchProps.datePage(pen, p)
        case .g5Screen: G5Stage.screen(pen, p)
        case .g5Emblem: G5Stage.emblem(pen, p)
        case .g5Banner: G5Art.banner(pen, p)
        case .g5Frame: G5Art.frame(pen, p)
        case .g5Statue: G5Art.statue(pen, p)
        case .g5Memorial: G5ChurchProps.memorial(pen, p)
        case .g5Candles: G5ChurchProps.candles(pen, p)
        case .g5Coffin: G5ChurchProps.coffin(pen, p)
        case .g5Cake: G5ChurchProps.cake(pen, p)
        default: break
        }
    }

    // MARK: Shared marks

    /// A round badge with a green tick (good, new, done).
    static func tick(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ r: CGFloat = 6) {
        f.dot(x, y, r, 0x1E7A4C)
        f.svgLine("M\(x - r * 0.45) \(y + r * 0.05)L\(x - r * 0.1) \(y + r * 0.4)L\(x + r * 0.5) \(y - r * 0.38)", 0xFFFDF6, max(1.2, r * 0.3))
    }

    /// A round badge with a red cross (old, wrong, broken).
    static func cross(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ r: CGFloat = 6) {
        f.dot(x, y, r, 0xC8261B)
        let k = r * 0.38
        f.svgLine("M\(x - k) \(y - k)L\(x + k) \(y + k)M\(x + k) \(y - k)L\(x - k) \(y + k)", 0xFFFDF6, max(1.2, r * 0.28))
    }

    /// A speech bubble with `text`, its tail pointing to `tail`.
    static func bubble(_ f: PropPen, _ b: CGRect, _ text: String, tail: CGPoint, fill: UInt32 = 0xFFFDF6, ink: UInt32 = 0x1E1E1C, size: CGFloat = 8) {
        let side: CGFloat = tail.x < b.midX ? -1 : 1
        let base = CGPoint(x: min(max(tail.x, b.minX + 7), b.maxX - 7), y: tail.y > b.midY ? b.maxY - 0.6 : b.minY + 0.6)
        f.svg("M\(base.x - 4 * side) \(base.y)L\(tail.x) \(tail.y)L\(base.x + 3 * side) \(base.y)Z", fill)
        f.rect(b, fill, radius: min(7, b.height / 2))
        f.stroke(Path(roundedRect: b, cornerRadius: min(7, b.height / 2)), 0x5E6B73, 0.9)
        f.text(text, PropFont.demi(size), ink, at: CGPoint(x: b.midX, y: b.midY + 0.3), maxWidth: b.width - 6)
    }

    /// A music note.
    static func note(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ hex: UInt32, scale s: CGFloat = 1) {
        f.oval(x - 3 * s, y - 2 * s, 5.4 * s, 4 * s, hex)
        f.line(x + 2 * s, y, x + 2 * s, y - 10 * s, hex, 1.3 * s)
        f.svgLine("M\(x + 2 * s) \(y - 10 * s)Q\(x + 6 * s) \(y - 8 * s) \(x + 5 * s) \(y - 4.5 * s)", hex, 1.3 * s)
    }

    /// A small heart centred at (x, y).
    static func heart(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ r: CGFloat, _ hex: UInt32 = 0xC8261B) {
        f.svg("M\(x) \(y + r)C\(x - r * 1.6) \(y - r * 0.1) \(x - r * 0.9) \(y - r * 1.3) \(x) \(y - r * 0.45)C\(x + r * 0.9) \(y - r * 1.3) \(x + r * 1.6) \(y - r * 0.1) \(x) \(y + r)Z", hex)
    }

    /// A four-pointed sparkle.
    static func sparkle(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ r: CGFloat, _ hex: UInt32 = 0xFAC775) {
        let k = r * 0.3
        f.svg("M\(x) \(y - r)L\(x + k) \(y - k)L\(x + r) \(y)L\(x + k) \(y + k)L\(x) \(y + r)L\(x - k) \(y + k)L\(x - r) \(y)L\(x - k) \(y - k)Z", hex)
    }

    /// A dashed stroke (chains, perforations).
    static func dashed(_ f: PropPen, _ path: Path, _ hex: UInt32, _ width: CGFloat, dash: [CGFloat]) {
        f.ctx.stroke(path, with: .color(PalaceInk.hex(hex)), style: StrokeStyle(lineWidth: width, lineCap: .butt, dash: dash))
    }
}
