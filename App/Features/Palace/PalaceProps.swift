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

    // MARK: g7 · outdoors, water and travel (drawn by `G7Props`, PalacePropsG7*.swift)

    // Harbour
    /// A moored ship: hull, white bridge, funnel, mast, anchor. `variant` hull colour.
    case g7Ship
    /// Lock gates between two stone walls, higher water behind, a red and green light.
    case g7Lock
    /// A small sailing boat under way with its wake. `variant` sail colour.
    case g7Sailboat
    /// A little boat tossing on waves, a green-faced passenger over the rail.
    case g7SeasickBoat
    /// The stone quay edge with a bollard and a mooring rope running up to the right.
    case g7Bollard
    /// Workers standing side by side: `count` 1–3, `accessory` "sailor" | "vest" | "farmer" | "miller";
    /// `text` on a small board they hold up; `variant` first look.
    case g7Worker
    /// An officer with a peaked cap and a torch, a sniffer dog at an open suitcase.
    case g7Customs
    /// A truck carrying a container, speed lines and an arrow. `variant` container colour.
    case g7Truck
    /// A finger post: `lines` "place|distance" per arm (up to 4, alternately left and right);
    /// `mount` "road" puts it by a long lane to a lone house.
    case g7Signpost
    /// Crates, sacks and barrels stacked on a pallet.
    case g7Goods
    // Windmill
    /// The four lattice sails of a windmill on its cap (placed over the mill in the backdrop).
    case g7MillSails
    /// Sheaves of ripe grain on a stubble field, a few loose ears.
    case g7Wheat
    /// A blue and white shield plaque with `caption` (small) and `text` (a year).
    case g7Shield
    /// A couple in traditional costume dancing to an accordion.
    case g7Dancers
    /// A workbench with old tools and a wooden cogwheel being carved.
    case g7Workbench
    /// Two millstones: grain pours in from a hopper, flour runs out into a sack.
    case g7Millstones
    /// Wind: `variant` 0 a tree bending and a windsock straight out with gusts, 1 no wind at all
    /// (limp windsock, upright tree mirrored in still water).
    case g7Wind
    /// Two cupped hands holding a small windmill safe under a heart.
    case g7Hands
    /// Clogs, a cheese and tulips together.
    case g7DutchSet
    // Farm
    /// A barn with open doors, cows' heads looking out over the hay.
    case g7Barn
    /// A cow, a sheep and a goat together.
    case g7Livestock
    /// A fenced green field with a gate, daisies and a ditch.
    case g7Meadow
    /// Wide fields in rows to the horizon, hay bales and a row of trees.
    case g7Fields
    /// Someone on a stool milking a cow into a bucket.
    case g7Milking
    /// A child holding out a bottle and hay to a goat.
    case g7Feeding
    /// Milk churn, a cheese, butter and a yoghurt pot.
    case g7Dairy
    /// A farm-gate stall with eggs, honey and potatoes; `text` on its sign.
    case g7FarmStall
    /// A tractor on a muddy lane with a hen crossing.
    case g7Tractor
    // Beach
    /// A big curling wave with foam.
    case g7Wave
    /// A sun cream bottle with a sun and `text` (a factor).
    case g7Sunscreen
    /// A wooden beach pavilion on posts with a terrace and parasols.
    case g7BeachCafe
    /// A lifeguard chair with a red and yellow flag, a lifebuoy and a lifeguard.
    case g7Lifeguard
    /// Sea with big curved arrows pulling a ball away.
    case g7Current
    /// A jellyfish on the wet sand.
    case g7Jellyfish
    /// A seafront promenade: railing, lamps, a bench and a strolling couple.
    case g7Promenade
    /// A beachgoer: `accessory` "cream" (rubbing cream into an arm), "paddle" (trousers rolled up,
    /// feet in the sea) or "burnt" (lying on a towel, red as a lobster); `variant` look.
    case g7Beachgoer
    /// A striped windbreak, wind lines stopped by it, someone sitting snug behind.
    case g7Windscreen
    // Camping
    /// A numbered pitch: a lawn edged by hedges with a post and a number plate (`text`).
    case g7Pitch
    /// A wash block with toilet and shower pictograms.
    case g7Washblock
    /// A mummy sleeping bag lying open on a mat.
    case g7SleepingBag
    /// A tent peg hammered into the ground with a mallet, the guy line taut.
    case g7TentPeg
    /// A campfire in a ring of stones with sparks and a marshmallow stick.
    case g7Campfire
    /// A notice board on two posts: `caption`, `icons` (with `labels`), `text`; `tone` like `sign`.
    case g7PostBoard
    /// An air mattress with a foot pump.
    case g7AirBed
    /// A dome tent: `accessory` "up" (someone raising it, arrow up), "down" (taking it down, arrow
    /// down, packed bag) or "rain" (rain bouncing off, a dry camper inside with a tick).
    case g7Tent
    /// A wooden outhouse with a heart in the door and an old hand pump.
    case g7Outhouse
    // Airport
    /// A gate screen: `caption` (gate), `text` (time and city), a plane; `accessory` "cancel" turns it red
    /// with the plane crossed out and the time struck through.
    case g7FlightScreen
    /// A boarding pass in a hand: `text` (seat), `caption` (gate), a barcode.
    case g7BoardingPass
    /// A small wheelie case inside a size frame with `text` ("55 × 40 × 20").
    case g7CabinCase
    /// A glass booth with an officer stamping a passport.
    case g7PassportBooth
    /// A walk-through scanner arch with a tray of things on a belt.
    case g7SecurityArch
    /// A poster with a sunny city under a big red map pin at the end of a dotted line; `text` city.
    case g7Destination
    /// An open plane door: the view down the aisle between the rows of seats.
    case g7Aisle
    /// A plane over a runway: `accessory` "up" (climbing, arrow up) or "down" (wheels out, arrow down).
    case g7Plane
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
            case .g7Ship, .g7Lock, .g7Sailboat, .g7SeasickBoat, .g7Bollard, .g7Worker, .g7Customs, .g7Truck, .g7Signpost,
                 .g7Goods, .g7MillSails, .g7Wheat, .g7Shield, .g7Dancers, .g7Workbench, .g7Millstones, .g7Wind, .g7Hands,
                 .g7DutchSet, .g7Barn, .g7Livestock, .g7Meadow, .g7Fields, .g7Milking, .g7Feeding, .g7Dairy, .g7FarmStall,
                 .g7Tractor, .g7Wave, .g7Sunscreen, .g7BeachCafe, .g7Lifeguard, .g7Current, .g7Jellyfish, .g7Promenade,
                 .g7Beachgoer, .g7Windscreen, .g7Pitch, .g7Washblock, .g7SleepingBag, .g7TentPeg, .g7Campfire, .g7PostBoard,
                 .g7AirBed, .g7Tent, .g7Outhouse, .g7FlightScreen, .g7BoardingPass, .g7CabinCase, .g7PassportBooth,
                 .g7SecurityArch, .g7Destination, .g7Aisle, .g7Plane:
                G7Props.draw(prop.kind, pen, p)
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
