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
    // MARK: Home, café and office (drawn in PalacePropsLiving.swift and its siblings)

    /// A sheet of paper. `icons` + `tone` (header band), `text` (big), `caption`,
    /// `lines` "label|value" (filled-in fields), `accessory` "pen" | "signature", `mount` "wall" (pinned) |
    /// "clipboard", `variant` 1 (the first icon drawn big as the sheet's picture).
    case paperSheet
    /// An envelope. `icons` (the sender's mark), `lines` (address).
    case envelope
    /// A phone in a hand. `lines` "in|…" / "out|…" chat bubbles, or a call: `icons`, `time`.
    case smartphone
    /// A wall calendar. `caption` (month), `highlight` (week row), `icons` (that week's picture).
    case wallCalendar
    /// A person holding something. `variant`, `accessory` "keys" | "tray" | "badge" | "stool" (seated, `text` on the mug).
    case personHolding
    /// A stain on the ceiling dripping into a bucket. `count` drops.
    case ceilingLeak
    /// Stacked moving boxes. `count` boxes, `labels` written on them.
    case movingBoxes
    /// A vacuum cleaner at work.
    case vacuum
    /// A sofa, lamp and side table with a tag. `text` on the tag.
    case furnitureSet
    /// A framed floor plan of a home. `text` (floor area).
    case floorPlan
    /// A loud speaker blasting at a person who holds their ears.
    case loudSpeaker
    /// A paper-thin wall: the neighbours' talk (`text`) comes through to an ear.
    case thinWall
    /// A sunny terrace with parasols, seen through a window.
    case terraceView
    /// A tip jar with coins. `text` (label), `count` coins.
    case tipJar
    /// A bottle and a full glass. `text` (label), `tone` "green" | "brown".
    case bottleAndGlass
    /// A glass with a straw on a coaster. `variant` (drink colour).
    case drinkGlass
    /// A high table with snacks and drinks.
    case snackTable
    /// A gramophone playing notes under a string of warm lights.
    case gramophone
    /// Two friends toasting at a table with a candle.
    case candleTable
    /// A card terminal with the bill. `text` (amount).
    case payTerminal
    /// People around a table with a flip chart. `count` people.
    case meetingTable
    /// An organisation chart with its top box highlighted.
    case orgChart
    /// A board of sticky task notes with tick boxes. `count` notes ticked.
    case taskBoard
    /// A hand putting a report into a tray. `text` (report title).
    case handIn
    /// An hourglass with a tag. `text` (tag).
    case hourglass
    /// Pass card with a photo. `caption` header, `text` name, `tone`, `variant` face, `accessory` "hand".
    case card
    /// Date slip with stamped `lines` (`highlight` red), a red `caption` stamp, a coin with `text`.
    case dueSlip
    /// A book. `accessory` "stand" (novel on an easel: `text` title, `caption` author) or "shelf"
    /// (between other books, a paper band with `text` name and `caption` date). `tone` cover.
    case book
    /// Wall rack of `count` magazines with mastheads `labels`.
    case magazines
    /// Slot in the wall with a book (or `accessory` "letter") going in and an arrow.
    case returnSlot
    /// Clipboard with `caption` and numbered names `lines`; a hand writes the last one.
    case clipboard
    /// Catalogue screen: rows "title|ok" / "title|no" (green or red dot), `highlight`, `mount` "hang".
    case catalog
    /// Tablet on a little table with an e-book page (`text` on top), wifi and bits.
    case tablet
    /// GP in a white coat with a stethoscope. `mount` "desk" (cut at the desk top) or standing; `flip`.
    case doctor
    /// Patient on a chair (`mount` "stand": standing) with `accessory` "cough" | "nauseous" | "dizzy" |
    /// "pain" | "fever"; `text` a speech bubble; `variant`, `flip`.
    case patient
    /// Wall card with a thermometer high in the red, the reading `text` and a hot face.
    case thermometer
    /// Letter with header `tone`/`caption`, `icons`, lines and a signature. `accessory` "printer" |
    /// "pills" | "envelope" (else pinned).
    case letter
    /// A hand writing on a pad; the pad shows the first of `icons`; sleeve `tone`.
    case writingPad
    /// Examination couch with a patient in a blood-pressure cuff, a monitor with `text`, a lamp.
    case examCouch
    /// Meeting at a low table under a window (`mount` "night" | "day"), teacher and `count` parents
    /// on tiny chairs.
    case meeting
    /// Open report booklet: `caption`, grades `lines` "subject|grade", a star. `mount` "desk".
    case reportCard
    /// Test sheet with questions `lines`, answer boxes, a pencil, `accessory` "timer". `mount` "desk".
    case testPaper
    /// Framed certificate: `caption`, big `text`, a red seal with ribbons.
    case certificate
    /// Timetable: day `labels`, subject `icons` per cell, `highlight` cell with a heart; `mount` "board".
    case classTimetable
    /// School child: `accessory` "bag" (badge `text`), "cheer" (green tick), "slump" (red cross); `variant`.
    case pupil
    /// Strict teacher: arm across, raised finger, frown. `variant`, `flip`.
    case teacher

    // MARK: City outdoors and the finale (g8: PalacePropsG8*.swift, routed by `G8Props`)

    // Allotment (PalacePropsG8Garden.swift)
    /// A wooden garden shed, door open on a spade and a rake. `variant` 0 green, 1 brown.
    case g8Shed
    /// A small greenhouse with tomato plants behind the glass.
    case g8Greenhouse
    /// A clubhouse with the club's flag, a notice (`text`, `caption`) and members in club shirts.
    case g8Clubhouse
    /// A fenced garden plot with a gate; `text` on the gate's number plate.
    case g8Plot
    /// A bed overgrown with dandelions and thistles, a hand pulling one out by the roots.
    case g8Weeds
    /// A gardener in a straw hat holding up a crate of vegetables; `text` on the crate's tag.
    case g8Gardener
    /// A path being laid: tiles, a string between pegs, a hand lowering the next tile, a barrow.
    case g8LayPath
    /// A hand scattering seeds into a furrow.
    case g8Sowing
    /// A slice of ground: grass, dark earth with a worm and roots, clay and stones, a spade.
    case g8SoilCut
    /// A seed packet (`icons` picture) pouring seeds into a hand.
    case g8SeedPacket
    /// Two patches side by side: dry cracked ground with a wilted sprout (cross) and dark rich
    /// ground with a laden plant (tick).
    case g8Fertile

    // Town hall square (PalacePropsG8Square.swift, PalacePropsG8SquarePeople.swift)
    /// A doorway open on two voting booths and a ballot box, a ballot-box sign over it.
    case g8PollingStation
    /// An election poster board on two posts: `text` (date) on top, `count` numbered posters.
    case g8ElectionBoard
    /// A campaign stand under a parasol: `text` on the cloth, `tone` the party colour, balloons.
    case g8PartyStand
    /// People marching with a long banner and placards; `icons` the placards' pictures.
    case g8March
    /// An open birdcage on a plinth, a bird flying out of it.
    case g8Cage
    /// A cloth banner hanging from a rod: `icons` (first one big), `tone` the cloth.
    case g8Banner
    /// A person with the gold chain of office, waving. `variant` skin and hair.
    case g8Mayor
    /// A hand holding a card: `tone` header with `icons` and `caption`, `lines` printed, a barcode.
    case g8PollCard
    /// A ballot paper with lists of boxes, a hand colouring box `highlight` with a red pencil.
    case g8Ballot
    /// Someone with a megaphone, the other arm shielding a smaller person behind them.
    case g8Megaphone
    /// A notice board with a poster: two different people, a big equals sign between them.
    case g8Equal

    // Roundabout (PalacePropsG8Traffic.swift, PalacePropsG8Street.swift)
    /// A traffic light on a pole; `highlight` the lit lamp (0 red, 1 amber, 2 green).
    case g8TrafficLight
    /// A road sign on a pole: `accessory` "noEntry" | "giveWay" | "zebra" | "roundabout".
    case g8TrafficSign
    /// A blue direction sign: a ring with three exits `labels`, exit `highlight` bold with an arrow.
    case g8ExitSign
    /// Someone walking with a shopping bag under the round blue footpath sign. `variant`.
    case g8Pedestrian
    /// A parent and child at the kerb looking both ways, an arrow showing the way across.
    case g8KerbCross
    /// A zebra crossing in perspective (`count` bars) with the blue crossing sign at the kerb.
    case g8Zebra
    /// A board: a muddled junction under a red cross beside a tidy roundabout with an eye and a tick.
    case g8Overview
    /// Busy traffic round a roundabout: a bus, cars and cyclists.
    case g8RingTraffic
    /// A car waiting at shark's teeth under the give-way sign while a cyclist rides past first.
    case g8GiveWay
    /// A car overtaking a cyclist, a curved arrow from behind to in front.
    case g8Overtake
    /// A parked car with a slip under the wiper, shown big in a close-up with the amount `text`.
    case g8Fine

    // Dike (PalacePropsG8Water.swift, PalacePropsG8Polder.swift)
    /// A dark storm cloud with lightning and thick slanting rain.
    case g8Storm
    /// A farm and a tree standing in floodwater up to the windows.
    case g8FloodedFarm
    /// A water-level gauge in the water, its middle mark (`labels` +1, 0, -1) at the surface.
    case g8Gauge
    /// Old water levels as dashed lines with years (`labels`) and a big arrow up to the surface.
    case g8RisingWater
    /// A dike in cross-section: stones on the water side, a road with a cyclist on top, sheep.
    case g8Dike
    /// A pumping station with the water board's badge on its door and flag, a pipe carrying water away.
    case g8PumpStation
    /// A house far below a dashed water line, a double arrow with the depth `text`.
    case g8LowLand
    /// A rain gauge on a post under a raining cloud; `text` the amount on a tag.
    case g8RainGauge
    /// An information board on legs: `caption`, `icons`, `labels`, `text` as on a sign.
    case g8InfoBoard
    /// A grown-up holding an umbrella over a child in the rain. `variant`.
    case g8Umbrella
    /// Sandbags stopping water before a door, a hand laying the last one, a tick on the dry side.
    case g8Sandbags
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
    /// Mirrors a figure so it faces left (its lettering stays readable).
    var flip: Bool?
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
            case .paperSheet, .envelope, .smartphone, .wallCalendar, .personHolding, .ceilingLeak, .movingBoxes,
                 .vacuum, .furnitureSet, .floorPlan, .loudSpeaker, .thinWall, .terraceView, .tipJar, .bottleAndGlass,
                 .drinkGlass, .snackTable, .gramophone, .candleTable, .payTerminal, .meetingTable, .orgChart, .taskBoard,
                 .handIn, .hourglass:
                PalaceLivingProps.draw(prop.kind, pen, p)
            case .card, .dueSlip, .book, .magazines, .returnSlot, .clipboard, .catalog, .tablet,
                 .doctor, .patient, .thermometer, .letter, .writingPad, .examCouch,
                 .meeting, .reportCard, .testPaper, .certificate, .classTimetable, .pupil, .teacher:
                PalaceLearningProps.draw(prop.kind, pen, p)
            case .g8Shed, .g8Greenhouse, .g8Clubhouse, .g8Plot, .g8Weeds, .g8Gardener, .g8LayPath, .g8Sowing, .g8SoilCut,
                 .g8SeedPacket, .g8Fertile, .g8PollingStation, .g8ElectionBoard, .g8PartyStand, .g8March, .g8Cage, .g8Banner,
                 .g8Mayor, .g8PollCard, .g8Ballot, .g8Megaphone, .g8Equal, .g8TrafficLight, .g8TrafficSign, .g8ExitSign,
                 .g8Pedestrian, .g8KerbCross, .g8Zebra, .g8Overview, .g8RingTraffic, .g8GiveWay, .g8Overtake, .g8Fine,
                 .g8Storm, .g8FloodedFarm, .g8Gauge, .g8RisingWater, .g8Dike, .g8PumpStation, .g8LowLand, .g8RainGauge,
                 .g8InfoBoard, .g8Umbrella, .g8Sandbags:
                G8Props.draw(prop.kind, pen, p)
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
