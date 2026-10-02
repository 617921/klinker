import SwiftUI

/// The prop library: objects that *mean* their word (a departure board with a red "+10" for
/// vertraging). Raw values are the names used in `anchors.json`.
nonisolated enum PalacePropKind: String, Codable, Sendable, CaseIterable {
    /// Departure board. `lines` "08:12|Utrecht|+10" (third cell = red tag), `highlight`.
    case board
    /// Flat sign. `caption` (small, top), `text` (big), `icons` + `labels`, `tone`.
    case sign
    /// Dark screen in a bezel. Same content as `sign`; `text` is a line under the icons.
    case screen
    /// Wall map with one bold straight route. `labels` [from, to].
    case routeMap
    /// Standing poster display. `icons` (picture), `text` (big), `caption` (under it).
    case poster
    /// A standing person. `variant` (colours), `accessory` "suitcase" | "backpack" | "none".
    case person
    /// Clock on a pole. `time` "8:15", `count` people crowding at its foot (0 = none).
    case clock
    /// Card-reader pole with a card held to it, a green light and a beep.
    case reader
    /// A train window packed with heads. `count` heads.
    case crowdedWindow

    // Shops (bakery, supermarket, pharmacy): drawn in PalacePropsShop/Grocer/Bakery/Pharmacy*.swift,
    // where each one's params are described.
    case shelfGoods, shopper
    case cardTerminal, tillReceipt, weighScale, produceCrate, priceTag, offerPoster
    case bottleReturn, shoppingCart, datedPack, overPacked
    case pastryCase, doughBoard, toppings, ingredientRow, warningSign, orderSlip, tastingPlate, breadLoaf
    case pillJar, medLeaflet, effectPoster, measureCup, medBox, syrupBottle
    case insuranceCard, refundSlip, otcRack, breakfastTable
    // Outdoor props, drawn by `PalaceOutdoorProps` (PalacePropsOutdoor.swift).
    // Market (PalacePropsMarket.swift, PalacePropsMarketTrade.swift)
    /// A whole market stall. `variant` awning colour, `accessory` "cheese" | "flowers".
    case stall
    /// A shop scale with cherries in the dish; `text` on its display ("500 g").
    case scale
    /// Round sign with the four seasons; `highlight` 0 spring … 3 winter.
    case seasonWheel
    /// Prize rosette with `count` stars (1–3).
    case rosette
    /// A green punnet heaped with strawberries.
    case punnet
    /// Three tomatoes from green to red, a tick over the red one.
    case ripeness
    /// A crate of apples, a hand lifting the best one out.
    case pickCrate
    /// An open cash box with trays of coins.
    case cashBox
    /// A hand dropping coins into another hand, with an arrow. `variant` giver's sleeve.
    case handover
    /// Two speech bubbles bargaining. `lines` [seller, buyer], `highlight` strikes one.
    case haggle

    // Park (PalacePropsPark.swift, PalacePropsParkPeople.swift)
    /// An oval pond with ducks, a lily pad and reeds.
    case duckPond
    /// A park bench, wooden slats on an iron frame.
    case bench
    /// A mown lawn in stripes with a little goal and a ball.
    case lawn
    /// A slide and a swing on a patch of sand.
    case playground
    /// An open-air stage with a singer, lights and bunting; `text` on its banner.
    case stage
    /// Litter on the grass next to a bin.
    case litter
    /// A road sign: `variant` 0 round, 1 square; `tone` blue | white | yellow; `icons`; `mount` "pole" | "none".
    case roadSign
    /// A runner mid-stride. `variant` look.
    case runner
    /// Someone walking a dog on a lead. `variant` look.
    case dogWalker
    /// Two people strolling arm in arm. `variant` look.
    case strollers

    // Tram stop (PalacePropsTram.swift, PalacePropsTramStop.swift)
    /// A destination display: line `caption`, destination `text`, a big arrow.
    case lineDisplay
    /// An open tram door. `accessory` "exit" (someone stepping out) | "ramp" (wheelchair on a ramp).
    case tramDoor
    /// The buffer stop at the end of the rails, with a line map whose last stop is big.
    case bufferStop
    /// A clock right on `time` with a small display: the same time and a green tick.
    case punctual
    /// Road works: a digger behind a striped barrier, sand and a cone.
    case roadworks
    /// A printed timetable on a post: `caption` line, `lines` "7|05 20 35 50".
    case timetable
    /// A ticket machine: card, arrow up and `text` ("+ € 20") on screen, a hand on a button.
    case ticketMachine
    /// A card reader on a pole whose screen shows a card and `text` ("€ 2,40").
    case cardReader
    /// A person in uniform with a peaked cap and a ticket printer. `variant` 0 navy, 1 green, 2 grey.
    case uniform
}

/// Settings that make a prop say something specific. Every field is optional; each prop
/// reads the ones it understands (see `PalacePropKind`).
nonisolated struct PalacePropParams: Codable, Hashable, Sendable {
    var text: String?
    var caption: String?
    var lines: [String]?
    var highlight: Int?
    var icons: [String]?
    var labels: [String]?
    var time: String?
    var tone: String?
    var variant: Int?
    var accessory: String?
    var count: Int?
    /// How a panel is fixed: "hang" (rods from the ceiling), "wall" (flat on the wall).
    var mount: String?
}

/// One prop with its settings.
nonisolated struct PalaceProp: Hashable, Sendable {
    let kind: PalacePropKind
    var params = PalacePropParams()

    /// Every text the prop paints in the scene (checked so it never spells a word of the sheet).
    var paintedTexts: [String] {
        let p = params
        let cells = (p.lines ?? []).flatMap { $0.split(separator: "|").map(String.init) }
        return [p.text, p.caption, p.time].compactMap { $0 } + cells + (p.labels ?? [])
    }
}

/// Draws a prop to fill whatever frame it is given. Equatable, so it only redraws when its
/// settings change (not on every game tick).
struct PalacePropView: View, Equatable {
    let prop: PalaceProp

    var body: some View {
        Canvas { ctx, size in
            let pen = PropPen(ctx: ctx, size: size)
            let p = prop.params
            switch prop.kind {
            case .board: PalacePanels.board(pen, p)
            case .sign: PalacePanels.sign(pen, p)
            case .screen: PalacePanels.screen(pen, p)
            case .routeMap: PalacePanels.routeMap(pen, p)
            case .poster: PalacePanels.poster(pen, p)
            case .person: PalaceFigures.person(pen, p)
            case .clock: PalaceFigures.clock(pen, p)
            case .reader: PalaceFigures.reader(pen, p)
            case .crowdedWindow: PalaceFigures.crowdedWindow(pen, p)
            case .shelfGoods, .shopper, .cardTerminal, .tillReceipt, .weighScale, .produceCrate, .priceTag,
                 .offerPoster, .bottleReturn, .shoppingCart, .datedPack, .overPacked, .pastryCase, .doughBoard,
                 .toppings, .ingredientRow, .warningSign, .orderSlip, .tastingPlate, .breadLoaf, .pillJar,
                 .medLeaflet, .effectPoster, .measureCup, .medBox, .syrupBottle, .insuranceCard, .refundSlip,
                 .otcRack, .breakfastTable:
                PalaceShopProps.draw(prop.kind, pen, p)
            case .stall, .scale, .seasonWheel, .rosette, .punnet, .ripeness, .pickCrate, .cashBox, .handover, .haggle,
                 .duckPond, .bench, .lawn, .playground, .stage, .litter, .roadSign, .runner, .dogWalker, .strollers,
                 .lineDisplay, .tramDoor, .bufferStop, .punctual, .roadworks, .timetable, .ticketMachine, .cardReader, .uniform:
                PalaceOutdoorProps.draw(prop.kind, pen, p)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// A small pen over a canvas, in the gevelkit's flat style: filled shapes, round strokes,
/// SVG path strings and short lettering. Coordinates are the prop's own points.
struct PropPen {
    var ctx: GraphicsContext
    var size: CGSize

    // MARK: Shapes

    func fill(_ path: Path, _ hex: UInt32, _ opacity: Double = 1) {
        ctx.fill(path, with: .color(PalaceInk.hex(hex, opacity)))
    }

    func rect(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ hex: UInt32, radius: CGFloat = 0, _ opacity: Double = 1) {
        let r = CGRect(x: x, y: y, width: w, height: h)
        fill(radius > 0 ? Path(roundedRect: r, cornerRadius: radius) : Path(r), hex, opacity)
    }

    func rect(_ r: CGRect, _ hex: UInt32, radius: CGFloat = 0, _ opacity: Double = 1) {
        rect(r.minX, r.minY, r.width, r.height, hex, radius: radius, opacity)
    }

    func stroke(_ path: Path, _ hex: UInt32, _ width: CGFloat, round: Bool = true, _ opacity: Double = 1) {
        ctx.stroke(path, with: .color(PalaceInk.hex(hex, opacity)), style: StrokeStyle(
            lineWidth: width, lineCap: round ? .round : .butt, lineJoin: round ? .round : .miter
        ))
    }

    func line(_ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat, _ hex: UInt32, _ width: CGFloat, round: Bool = true) {
        var p = Path()
        p.move(to: CGPoint(x: x1, y: y1))
        p.addLine(to: CGPoint(x: x2, y: y2))
        stroke(p, hex, width, round: round)
    }

    func dot(_ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat, _ hex: UInt32, _ opacity: Double = 1) {
        fill(Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: 2 * r, height: 2 * r)), hex, opacity)
    }

    func ring(_ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat, _ hex: UInt32, _ width: CGFloat) {
        stroke(Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: 2 * r, height: 2 * r)), hex, width)
    }

    func oval(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ hex: UInt32, _ opacity: Double = 1) {
        fill(Path(ellipseIn: CGRect(x: x, y: y, width: w, height: h)), hex, opacity)
    }

    /// Fills SVG path data (same syntax as the prototype's drawings).
    func svg(_ d: String, _ hex: UInt32, _ opacity: Double = 1) {
        fill(PalaceSVG.path(d), hex, opacity)
    }

    func svgLine(_ d: String, _ hex: UInt32, _ width: CGFloat, _ opacity: Double = 1) {
        stroke(PalaceSVG.path(d), hex, width, opacity)
    }

    // MARK: Lettering

    /// Paints one line of text, shrunk to `maxWidth` if needed.
    func text(_ string: String, _ font: Font, _ hex: UInt32, at point: CGPoint, anchor: UnitPoint = .center, maxWidth: CGFloat? = nil) {
        guard !string.isEmpty else { return }
        let resolved = ctx.resolve(Text(string).font(font).foregroundColor(PalaceInk.hex(hex)))
        let natural = resolved.measure(in: CGSize(width: 1000, height: 200))
        let scale = maxWidth.map { min(1, $0 / max(1, natural.width)) } ?? 1
        var c = ctx
        c.translateBy(x: point.x, y: point.y)
        c.scaleBy(x: scale, y: scale)
        c.draw(resolved, at: .zero, anchor: anchor)
    }

    /// Width of a line of text at its natural size.
    func width(of string: String, _ font: Font) -> CGFloat {
        ctx.resolve(Text(string).font(font)).measure(in: CGSize(width: 1000, height: 200)).width
    }

    // MARK: Placing

    /// A pen that draws a `design`-sized drawing scaled to fit this pen's size, standing on the
    /// bottom edge (people, poles) or hanging from the top edge.
    func fitted(_ design: CGSize, hanging: Bool = false) -> PropPen {
        let s = min(size.width / design.width, size.height / design.height)
        var c = ctx
        let dx = (size.width - design.width * s) / 2
        let dy = hanging ? 0 : size.height - design.height * s
        c.translateBy(x: dx, y: dy)
        c.scaleBy(x: s, y: s)
        return PropPen(ctx: c, size: design)
    }

    /// A pen whose origin is moved to `rect`'s corner and whose units are `unit` points per point.
    func within(_ rect: CGRect, unit: CGFloat = 1) -> PropPen {
        var c = ctx
        c.translateBy(x: rect.minX, y: rect.minY)
        c.scaleBy(x: unit, y: unit)
        return PropPen(ctx: c, size: CGSize(width: rect.width / unit, height: rect.height / unit))
    }
}

/// Fonts used for lettering inside props (all ship with iOS).
enum PropFont {
    static func heavy(_ size: CGFloat) -> Font { .custom("AvenirNext-Heavy", fixedSize: size) }
    static func demi(_ size: CGFloat) -> Font { .custom("AvenirNext-DemiBold", fixedSize: size) }
    static func condensed(_ size: CGFloat) -> Font { .custom("AvenirNextCondensed-DemiBold", fixedSize: size) }
    static func mono(_ size: CGFloat) -> Font { .custom("CourierNewPS-BoldMT", fixedSize: size) }
}
