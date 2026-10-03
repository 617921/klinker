import SwiftUI

/// The kinds of details, each with its own little drawing.
nonisolated enum KaartDetailKind: String, Sendable {
    // Cats (this file)
    case kat, poes, poezenboot, katje
    // Birds and animals (KaartDetailArtAnimals.swift)
    case eend, gans, zwaan, reiger, meerkoet, duif, ooievaar, kip, konijn, lam, hond, egel
    // Stands and street life (KaartDetailArtStreet.swift)
    case stroopwafel, friet, haring, kaas, oliebol, ijsje, draaiorgel, bloemenfiets, bakfiets, paaltje, tulp, hengel
    // Boats (KaartDetailArtStreet.swift)
    case rondvaartboot, sloep, waterfiets, roeiboot
    // Out of town and the seasons (KaartDetailArtStreet.swift)
    case trekker, luchtballon, sneeuwman, ligstoel, zandkasteel, vlieger, paddenstoel
}

/// Draws one detail into a context scaled to world units, origin at the sprite's top-left,
/// facing right. `t` is the clock for little movements (a tail, wings, paddling).
nonisolated enum KaartDetailArt {
    static func draw(_ kind: KaartDetailKind, size: CGSize, t: Double, night: Bool, season: GevelSeason, in ctx: inout GraphicsContext) {
        switch kind {
        case .kat: kat(size: size, t: t, night: night, in: &ctx)
        case .poes: poes(KaartDetailPen(ctx, size: size, box: CGSize(width: 40, height: 30), night: night), t: t)
        case .poezenboot: poezenboot(KaartDetailPen(ctx, size: size, box: CGSize(width: 56, height: 28), night: night), t: t, winter: season == .winter)
        case .katje: katje(KaartDetailPen(ctx, size: size, box: CGSize(width: 24, height: 16), night: night), t: t)
        case .eend: eend(KaartDetailPen(ctx, size: size, box: CGSize(width: 46, height: 14), night: night), t: t)
        case .gans: gans(KaartDetailPen(ctx, size: size, box: CGSize(width: 44, height: 24), night: night), t: t)
        case .zwaan: zwaan(KaartDetailPen(ctx, size: size, box: CGSize(width: 44, height: 26), night: night), t: t)
        case .reiger: reiger(KaartDetailPen(ctx, size: size, box: CGSize(width: 22, height: 34), night: night), t: t)
        case .meerkoet: meerkoet(KaartDetailPen(ctx, size: size, box: CGSize(width: 28, height: 18), night: night), t: t)
        case .duif: duif(KaartDetailPen(ctx, size: size, box: CGSize(width: 40, height: 16), night: night), t: t)
        case .ooievaar: ooievaar(KaartDetailPen(ctx, size: size, box: CGSize(width: 28, height: 54), night: night), t: t)
        case .kip: kip(KaartDetailPen(ctx, size: size, box: CGSize(width: 34, height: 20), night: night), t: t)
        case .konijn: konijn(KaartDetailPen(ctx, size: size, box: CGSize(width: 20, height: 18), night: night), t: t)
        case .lam: lam(KaartDetailPen(ctx, size: size, box: CGSize(width: 34, height: 20), night: night), t: t)
        case .hond: hond(KaartDetailPen(ctx, size: size, box: CGSize(width: 22, height: 18), night: night), t: t)
        case .egel: egel(KaartDetailPen(ctx, size: size, box: CGSize(width: 22, height: 14), night: night), t: t)
        case .stroopwafel: stroopwafel(KaartDetailPen(ctx, size: size, box: CGSize(width: 40, height: 40), night: night), t: t, winter: season == .winter)
        case .friet: friet(KaartDetailPen(ctx, size: size, box: CGSize(width: 36, height: 46), night: night), t: t, winter: season == .winter)
        case .haring: haring(KaartDetailPen(ctx, size: size, box: CGSize(width: 46, height: 38), night: night), t: t, winter: season == .winter)
        case .kaas: kaas(KaartDetailPen(ctx, size: size, box: CGSize(width: 34, height: 28), night: night), winter: season == .winter)
        case .oliebol: oliebol(KaartDetailPen(ctx, size: size, box: CGSize(width: 46, height: 38), night: night), t: t)
        case .ijsje: ijsje(KaartDetailPen(ctx, size: size, box: CGSize(width: 36, height: 38), night: night), t: t)
        case .draaiorgel: draaiorgel(KaartDetailPen(ctx, size: size, box: CGSize(width: 52, height: 42), night: night), t: t, winter: season == .winter)
        case .bloemenfiets: bloemenfiets(KaartDetailPen(ctx, size: size, box: CGSize(width: 40, height: 28), night: night), season: season)
        case .bakfiets: bakfiets(KaartDetailPen(ctx, size: size, box: CGSize(width: 50, height: 32), night: night), t: t)
        case .paaltje: paaltje(KaartDetailPen(ctx, size: size, box: CGSize(width: 46, height: 16), night: night), winter: season == .winter)
        case .tulp: tulp(KaartDetailPen(ctx, size: size, box: CGSize(width: 40, height: 26), night: night), t: t)
        case .hengel: hengel(KaartDetailPen(ctx, size: size, box: CGSize(width: 30, height: 24), night: night), t: t)
        case .rondvaartboot: rondvaartboot(KaartDetailPen(ctx, size: size, box: CGSize(width: 70, height: 20), night: night), t: t)
        case .sloep: sloep(KaartDetailPen(ctx, size: size, box: CGSize(width: 46, height: 20), night: night), t: t)
        case .waterfiets: waterfiets(KaartDetailPen(ctx, size: size, box: CGSize(width: 30, height: 20), night: night), t: t)
        case .roeiboot: roeiboot(KaartDetailPen(ctx, size: size, box: CGSize(width: 34, height: 16), night: night), t: t)
        case .trekker: trekker(KaartDetailPen(ctx, size: size, box: CGSize(width: 46, height: 34), night: night), t: t)
        case .luchtballon: luchtballon(KaartDetailPen(ctx, size: size, box: CGSize(width: 32, height: 44), night: night), t: t)
        case .sneeuwman: sneeuwman(KaartDetailPen(ctx, size: size, box: CGSize(width: 22, height: 30), night: night), t: t)
        case .ligstoel: ligstoel(KaartDetailPen(ctx, size: size, box: CGSize(width: 42, height: 22), night: night))
        case .zandkasteel: zandkasteel(KaartDetailPen(ctx, size: size, box: CGSize(width: 30, height: 22), night: night), t: t)
        case .vlieger: vlieger(KaartDetailPen(ctx, size: size, box: CGSize(width: 36, height: 56), night: night), t: t)
        case .paddenstoel: paddenstoel(KaartDetailPen(ctx, size: size, box: CGSize(width: 20, height: 16), night: night))
        }
    }

    // MARK: Cats

    /// A black cat sitting, tail swishing.
    private static func kat(size: CGSize, t: Double, night: Bool, in ctx: inout GraphicsContext) {
        let fur = StadInk.hex(night ? 0x0E0F14 : 0x1E1E1C)
        let w = size.width, h = size.height
        let swish = sin(t * 2.2) * 1.4
        var tail = Path()
        tail.move(to: CGPoint(x: w * 0.62, y: h * 0.92))
        tail.addQuadCurve(to: CGPoint(x: w * 0.98 + swish * 0.3, y: h * 0.35), control: CGPoint(x: w * 1.05, y: h * 0.95 + swish))
        ctx.stroke(tail, with: .color(fur), style: StrokeStyle(lineWidth: 1.3, lineCap: .round))
        ctx.fill(Path(ellipseIn: CGRect(x: w * 0.15, y: h * 0.4, width: w * 0.55, height: h * 0.6)), with: .color(fur))
        ctx.fill(Path(ellipseIn: CGRect(x: w * 0.08, y: h * 0.12, width: w * 0.42, height: h * 0.42)), with: .color(fur))
        ctx.fill(KaartPen.polygon([(w * 0.1, h * 0.25), (w * 0.12, 0), (w * 0.24, h * 0.16)]), with: .color(fur))
        ctx.fill(KaartPen.polygon([(w * 0.32, h * 0.16), (w * 0.44, 0), (w * 0.47, h * 0.26)]), with: .color(fur))
        let eye = StadInk.hex(0xF2C53D)
        ctx.fill(Path(ellipseIn: CGRect(x: w * 0.16, y: h * 0.27, width: w * 0.08, height: h * 0.09)), with: .color(eye))
        ctx.fill(Path(ellipseIn: CGRect(x: w * 0.31, y: h * 0.27, width: w * 0.08, height: h * 0.09)), with: .color(eye))
    }

    /// A black cat curled up, or sitting, at (x, y) = the middle of its feet; `scale` 1 is about 12 units tall.
    static func blackCat(_ p: KaartDetailPen, x: Double, y: Double, scale s: Double = 1, t: Double, lying: Bool = false) {
        let fur: UInt32 = p.night ? 0x0B0C10 : 0x1E1E1C
        let swish = sin(t * 2.2) * 1.6
        if lying {
            p.oval(x - 7 * s, y - 5 * s, 13 * s, 5 * s, fur)
            p.dot(x + 5 * s, y - 4.5 * s, 2.8 * s, fur)
            p.poly([(x + 3 * s, y - 6 * s), (x + 3.6 * s, y - 9 * s), (x + 5.4 * s, y - 6.8 * s)], fur)
            p.poly([(x + 5.8 * s, y - 6.8 * s), (x + 7.4 * s, y - 9 * s), (x + 7.8 * s, y - 5.8 * s)], fur)
            p.curve((x - 6 * s, y - 1 * s), control: (x - 11 * s, y + 0.5 * s + swish * 0.3 * s), to: (x - 9 * s, y - 4 * s + swish * 0.4 * s), fur, width: 1.4 * s)
            p.glow.dot(x + 6.2 * s, y - 4.8 * s, 0.6 * s, 0xF2C53D)
            return
        }
        p.curve((x - 1 * s, y), control: (x - 7 * s, y + 0.5 * s), to: (x - 6 * s + swish * 0.4 * s, y - 6 * s), fur, width: 1.5 * s)
        p.oval(x - 4 * s, y - 7.5 * s, 7.5 * s, 7.5 * s, fur)
        p.dot(x + 2 * s, y - 9 * s, 3.2 * s, fur)
        p.poly([(x - 0.6 * s, y - 10 * s), (x - 0.4 * s, y - 13.4 * s), (x + 1.6 * s, y - 11.6 * s)], fur)
        p.poly([(x + 2.6 * s, y - 11.8 * s), (x + 4.4 * s, y - 13.4 * s), (x + 4.6 * s, y - 9.8 * s)], fur)
        p.glow.dot(x + 1.1 * s, y - 9.4 * s, 0.65 * s, 0xF2C53D)
        p.glow.dot(x + 3.3 * s, y - 9.4 * s, 0.65 * s, 0xF2C53D)
    }

    /// A black cat sitting on the saddle of a parked bike, tail hanging down and swinging.
    private static func poes(_ p: KaartDetailPen, t: Double) {
        p.shadow(20, 28, 34)
        bike(p, rear: (9, 23), front: (31, 23), frame: 0x1F3A6B)
        p.rect(25, 7.5, 9, 5, 0xB08850, corner: 1)
        p.line([(25, 9.5), (34, 9.5)], 0x8A6240, width: 0.6)
        // The cat sits on the saddle; its tail hangs and swings.
        let swing = sin(t * 1.8) * 2.4
        let fur: UInt32 = p.night ? 0x0B0C10 : 0x1E1E1C
        p.curve((10, 11), control: (8, 16), to: (8.5 + swing, 19), fur, width: 1.7)
        p.oval(9, 3.5, 10, 9, fur)
        p.dot(18, 4.5, 4, fur)
        p.poly([(14.6, 2.6), (15, -1.4), (17.4, 1.2)], fur)
        p.poly([(18.8, 1), (21.4, -1.2), (21.8, 3.2)], fur)
        p.glow.dot(17.2, 4, 0.8, 0xF2C53D)
        p.glow.dot(20, 4, 0.8, 0xF2C53D)
    }

    /// The cat boat: a houseboat with a cabin, pot plants, and black cats on the roof and deck.
    private static func poezenboot(_ p: KaartDetailPen, t: Double, winter: Bool) {
        p.wake(2, 54, 25.5)
        // Hull.
        p.poly([(1, 17), (55, 17), (52, 25), (5, 25)], 0x2C3A33)
        p.rect(2, 17, 52, 2, 0x7A1E1E)
        // Cabin with windows that glow at night.
        p.rect(8, 9, 34, 8, 0xEFE6D6)
        p.rect(6, 7.5, 38, 2.2, 0x3A3632)
        for x in [11.0, 18, 25, 32] {
            p.window(x, 11, 4.2, 3.6)
        }
        p.rect(37, 11, 3.6, 6, 0x24533F)
        if winter { p.rect(6, 6.4, 38, 1.6, 0xF6F7F4, corner: 0.8) }
        // Plants at the bow.
        p.rect(46, 13.5, 3.5, 3.5, 0x8C4A3A)
        p.dot(47.7, 12, 2.6, winter ? 0x6E7A70 : 0x5E8C45)
        p.rect(50.5, 14, 3, 3, 0x8C4A3A)
        p.dot(52, 12.8, 2.1, winter ? 0x6E7A70 : 0x3F6E3A)
        // Cats: one sits on the roof, one dozes, one keeps watch on the deck.
        blackCat(p, x: 14, y: 7.6, scale: 0.55, t: t)
        blackCat(p, x: 31, y: 7.6, scale: 0.5, t: t + 1.3, lying: true)
        blackCat(p, x: 4.5, y: 17, scale: 0.42, t: t + 2.1)
    }

    /// A black kitten batting a ball of red wool.
    private static func katje(_ p: KaartDetailPen, t: Double) {
        let bat = max(0, sin(t * 2.6))
        let roll = sin(t * 1.3) * 0.8
        p.shadow(11, 15, 18)
        // The ball and its loose thread.
        p.curve((19 + roll, 13), control: (13, 16.5), to: (6, 14.8), 0xC8261B, width: 0.6)
        p.dot(19.5 + roll, 12.6, 2.6, 0xC8261B)
        p.line([(18.2 + roll, 11.4), (20.6 + roll, 13.8)], 0x8E1A12, width: 0.5)
        p.line([(18 + roll, 13), (20.4 + roll, 11)], 0x8E1A12, width: 0.5)
        let fur: UInt32 = p.night ? 0x0B0C10 : 0x1E1E1C
        // Tail up in a question mark.
        p.curve((4, 10.5), control: (0.5, 8), to: (2.5, 4), fur, width: 1.5)
        // Crouched body, head low, one paw reaching for the ball.
        p.oval(3, 8, 10, 6.5, fur)
        p.dot(13.4, 10, 3.2, fur)
        p.poly([(10.6, 8.4), (10.8, 5), (12.8, 7.2)], fur)
        p.poly([(14.2, 7), (16.4, 5.2), (16.4, 8.8)], fur)
        p.line([(13, 13.4), (15.4 + bat * 1.4, 12.4 - bat * 1.6)], fur, width: 1.4)
        p.line([(6, 13.6), (5.4, 15)], fur, width: 1.3)
        p.glow.dot(13.3, 9.4, 0.7, 0xF2C53D)
        p.glow.dot(15.4, 9.6, 0.7, 0xF2C53D)
    }

    /// A parked Dutch bike (side view): wheels, frame, saddle and handlebar.
    static func bike(_ p: KaartDetailPen, rear: (Double, Double), front: (Double, Double), frame: UInt32, flowers: Bool = false) {
        let r = 6.4
        let tire: UInt32 = 0x1E1E1C
        p.ring(rear.0, rear.1, r, tire, width: 1.5)
        p.ring(front.0, front.1, r, tire, width: 1.5)
        let crank = (rear.0 + 8, rear.1)
        let seat = (rear.0 + 5, rear.1 - 11)
        let head = (front.0 - 5, rear.1 - 11.5)
        p.line([rear, crank, seat, rear], frame, width: 1.6)
        p.line([crank, head, front], frame, width: 1.6)
        p.line([seat, (seat.0 - 0.5, seat.1 - 2)], frame, width: 1.4)
        p.rect(seat.0 - 3.5, seat.1 - 3, 6, 1.8, 0x6B4A2E, corner: 0.9)
        p.line([head, (head.0 + 0.5, head.1 - 4), (head.0 - 2, head.1 - 4.6)], frame, width: 1.4)
        p.line([(rear.0 - 1, rear.1 - 5), (crank.0 - 1, rear.1 - 7.5)], 0x5F5E5A, width: 1)
        p.dot(crank.0, crank.1, 1.4, 0x5F5E5A)
    }
}

/// A small brush for detail drawings: design units scaled to the sprite, colours darkened at night.
nonisolated struct KaartDetailPen {
    let ctx: GraphicsContext
    let night: Bool
    /// Paint as is (lights, eyes): not darkened at night.
    private var glows = false

    init(_ base: GraphicsContext, size: CGSize, box: CGSize, night: Bool) {
        var c = base
        c.scaleBy(x: size.width / box.width, y: size.height / box.height)
        ctx = c
        self.night = night
    }

    /// The same pen, painting colours untouched by the night (lights, eyes).
    var glow: KaartDetailPen {
        var pen = self
        pen.glows = true
        return pen
    }

    func color(_ hex: UInt32, _ opacity: Double = 1) -> Color {
        StadInk.hex(night && !glows ? Gevelkit.shade(hex, 0.55) : hex, opacity)
    }

    func rect(_ x: Double, _ y: Double, _ w: Double, _ h: Double, _ hex: UInt32, corner: Double = 0) {
        let r = CGRect(x: x, y: y, width: w, height: h)
        ctx.fill(corner > 0 ? Path(roundedRect: r, cornerRadius: corner) : Path(r), with: .color(color(hex)))
    }

    func oval(_ x: Double, _ y: Double, _ w: Double, _ h: Double, _ hex: UInt32) {
        ctx.fill(Path(ellipseIn: CGRect(x: x, y: y, width: w, height: h)), with: .color(color(hex)))
    }

    func dot(_ cx: Double, _ cy: Double, _ r: Double, _ hex: UInt32) {
        oval(cx - r, cy - r, r * 2, r * 2, hex)
    }

    func ring(_ cx: Double, _ cy: Double, _ r: Double, _ hex: UInt32, width: Double) {
        ctx.stroke(Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2)), with: .color(color(hex)), lineWidth: width)
    }

    func poly(_ points: [(Double, Double)], _ hex: UInt32, opacity: Double = 1) {
        ctx.fill(KaartPen.polygon(points), with: .color(color(hex, opacity)))
    }

    func line(_ points: [(Double, Double)], _ hex: UInt32, width: Double, opacity: Double = 1) {
        ctx.stroke(KaartPen.polygonLine(points), with: .color(color(hex, opacity)), style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
    }

    func curve(_ from: (Double, Double), control: (Double, Double), to: (Double, Double), _ hex: UInt32, width: Double) {
        var path = Path()
        path.move(to: CGPoint(x: from.0, y: from.1))
        path.addQuadCurve(to: CGPoint(x: to.0, y: to.1), control: CGPoint(x: control.0, y: control.1))
        ctx.stroke(path, with: .color(color(hex)), style: StrokeStyle(lineWidth: width, lineCap: .round))
    }

    func fill(_ path: Path, _ hex: UInt32) {
        ctx.fill(path, with: .color(color(hex)))
    }

    /// A soft shadow on the ground, centred at x, `w` wide.
    func shadow(_ cx: Double, _ y: Double, _ w: Double) {
        ctx.fill(Path(ellipseIn: CGRect(x: cx - w / 2, y: y - w * 0.09, width: w, height: w * 0.18)), with: .color(StadInk.hex(0x1E1E1C, 0.16)))
    }

    /// Ripples along the waterline from x0 to x1.
    func wake(_ x0: Double, _ x1: Double, _ y: Double) {
        ctx.fill(Path(ellipseIn: CGRect(x: x0, y: y - 1.6, width: x1 - x0, height: 3.2)), with: .color(StadInk.hex(0x1E3A5C, night ? 0.25 : 0.14)))
        var marks = Path()
        marks.move(to: CGPoint(x: x0 - 2, y: y + 0.8))
        marks.addLine(to: CGPoint(x: x0 + (x1 - x0) * 0.3, y: y + 0.8))
        marks.move(to: CGPoint(x: x0 + (x1 - x0) * 0.55, y: y + 1.2))
        marks.addLine(to: CGPoint(x: x1 + 2, y: y + 1.2))
        ctx.stroke(marks, with: .color(.white.opacity(night ? 0.3 : 0.75)), style: StrokeStyle(lineWidth: 0.8, lineCap: .round))
    }

    /// A small window: glass by day, warm light at night.
    func window(_ x: Double, _ y: Double, _ w: Double, _ h: Double) {
        let r = CGRect(x: x, y: y, width: w, height: h)
        ctx.fill(Path(r), with: .color(night ? StadInk.hex(0xF6D27A) : StadInk.hex(0x5E6B73)))
    }

    /// A person seen from the side from the waist up (in a boat or behind a counter): head at (x, y).
    func head(_ x: Double, _ y: Double, r: Double = 2.2, skin: UInt32, hair: UInt32, shirt: UInt32? = nil) {
        if let shirt { rect(x - r * 1.1, y + r * 0.7, r * 2.2, r * 2.4, shirt, corner: r * 0.8) }
        dot(x, y, r, skin)
        var top = ctx
        top.clip(to: Path(CGRect(x: x - r - 0.5, y: y - r - 0.5, width: r * 2 + 1, height: r * 0.95)))
        top.fill(Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2)), with: .color(color(hair)))
    }
}
