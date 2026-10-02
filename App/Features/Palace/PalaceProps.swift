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

    // MARK: g6 — shops, culture and safety (drawn by `G6Props`, PalacePropsG6*.swift)

    /// A standing person (64 × 114) with a tool or a pose: `accessory` "wrench" (mechanic in overalls),
    /// "inspect" (clipboard and magnifier), "press" (notepad, pen, press card), "box" (carries a box of
    /// old things), "wow" (hands to cheeks, sparkles), "talk" (points; speech bubble `lines`); `variant`, `flip`.
    case g6Figure
    /// Round shop sign: two arrows circling a chair, a lamp and a shirt; `text` on its band.
    case g6CycleSign
    /// A shelf bay crammed with odds and ends: a clock, a teddy, a vase, books, a radio.
    case g6Jumble
    /// A matching dinner set: stacked plates, cups on saucers, a teapot. `tone` pattern colour.
    case g6Crockery
    /// A fine old clock with a tiny price tag (`text`) and a thumbs-up.
    case g6Bargain
    /// A chest of drawers with a tag: a red–yellow–green gauge, needle at `highlight` (0–2), `text`.
    case g6Condition
    /// A vase with a crack and a chip out of the rim, shards beside it.
    case g6Damaged
    /// A chair: one half old and scratched, the other freshly painted, a brush and a paint pot.
    case g6Refurbish
    /// A fringed lamp and a dial telephone on a side table with a doily.
    case g6Vintage
    /// A hatch in the wall (`text` above it); two hands push a box of old things in.
    case g6DropOff
    /// A cash box, an arrow and a heart over little houses; `text` the amount.
    case g6Proceeds
    /// A car seen from the side. `variant` colour; `accessory` "lift" (raised on lift arms, oil draining
    /// into a pan, an oil can and a filter), "sale" (card in the window: `text` price, `caption`), "plain".
    case g6Car
    /// A fuel pump; its hose ends in a car's filler; `text` on the display, `caption` under it.
    case g6FuelPump
    /// A yellow licence plate with `text`; `mount` "screen" shows it on a desk monitor.
    case g6Plate
    /// A car battery with + and − terminals, jump leads and an almost empty charge mark.
    case g6Battery
    /// An inspection report: rows `lines` "item|ok" / "item|no" and a big stamp:
    /// `accessory` "reject" (red cross) or "pass" (green tick).
    case g6Verdict
    /// A sign with `count` stars, a picture (`icons`), `text` big and `caption` small.
    case g6Rating
    /// A round seal with a car and a tick, ribbons, `text` on the band.
    case g6Badge
    /// Newspapers. `accessory` "stack" (a bundle and a strip of day boxes `labels`), "front" (front page:
    /// headline `text`, photo, `caption`), "article" (open page, one article ringed red, `text` its title),
    /// "fresh" (a new issue popping out of a box, burst `text`), "strings" (a paper walks free, its
    /// puppet strings cut).
    case g6Paper
    /// A phone with an absurd headline (`text`), its picture, a long nose and a red question mark.
    case g6Hoax
    /// A transmitter mast sending waves to a television and a radio.
    case g6Broadcast
    /// A television: a news reader at a desk, an inset picture (`icons` first), `caption` tag.
    case g6NewsTV
    /// One phone sends a message out along arrows to many phones.
    case g6Spread
    /// A screen with a red dot and timed rows `lines` "10:42|headline", `caption` on top.
    case g6Ticker
    /// Fire. `accessory` "blaze" (a house top ablaze, smoke rolling up), "burst" (flames shooting out
    /// through a breaking window), "hose" (a firefighter hosing water onto a burning bin).
    case g6Fire
    /// A ladder up to a window; a firefighter carries a child down.
    case g6Rescue
    /// `accessory` "flammable" (jerrycan with a flame diamond), "skull" (warning sign with a skull,
    /// `text` under it), "callPoint" (red break-glass alarm with a flashing light).
    case g6Hazard
    /// A smoke alarm on a ceiling plate, smoke rising into it, beeps and a red light.
    case g6SmokeAlarm
    /// A police car, an ambulance and a small fire car in a row, blue lights flashing.
    case g6Responders
    /// Green exit sign: a running figure through a door and an arrow. `mount` "hang" | "wall".
    case g6ExitSign
    /// An orchestra on chairs in two rows: violins, cellos, horns and a kettle drum.
    case g6Orchestra
    /// A musician. `accessory` "baton" (a conductor from behind on a little box, baton up), else a
    /// soloist playing the violin, notes rising; `variant`, `flip`.
    case g6Musician
    /// A violin, a trumpet, a flute and a drum together.
    case g6Instruments
    /// A ticket with a calendar: price rows `lines` "label|price", `highlight` ringed, `caption`.
    case g6Ticket
    /// Audience heads. `accessory` "clap" (clapping hands, bubble `text`), "sing" (open mouths, notes),
    /// "offkey" (one sings crooked red notes, the neighbour covers their ears).
    case g6Crowd
    /// A music stand with a score full of repeat signs, a pencil and a bubble (`text`).
    case g6Score
    /// A composer's bust with a curled wig on a pedestal, notes around it.
    case g6Bust
    /// The front of a stage: steps up, a spotlight cone, a microphone stand.
    case g6Podium
    /// A framed picture. `accessory` "portrait" | "abstract" | "landscape" | "empty" (ornate frame only);
    /// `tone` frame "gold" | "black" | "white".
    case g6Painting
    /// One tree painted three ways: true to life, in blocks, in dots.
    case g6Styles
    /// A row of small grey pictures and one big bright red one with rays.
    case g6Standout
    /// Three small pictures; a hand points at one, which gets a tick.
    case g6Choose
    /// A ribbon cut by scissors between two posts, two glasses clinking.
    case g6Ribbon
    /// An exhibition poster: three small pictures, `text` big, `caption` dates.
    case g6ExpoPoster
    /// An open book on a stand with hearts and handwritten `lines`.
    case g6Guestbook
    // MARK: g1 — bank, post office, housing office, police, temp agency, court (PalacePropsG1*.swift)

    /// A person (64 × 114, `variant` look, `flip`) whose `accessory` tells who they are; see
    /// `G1People.person` for the list ("clerk", "courier", "tenant", "witness", "officer", "judge" …).
    case g1Person
    /// Cash machine in the wall: `text` on its screen, notes coming out into a hand.
    case g1Atm
    /// Piggy bank with a coin dropping in.
    case g1PiggyBank
    /// Bank card held up in a hand: chip, contactless waves, `text` number, `tone` colour.
    case g1BankCard
    /// Note-counting machine with notes going through, the total `text` on its display.
    case g1MoneyCounter
    /// Banking screen. `accessory` "account": `caption` account number, rows `lines` "label|+12,50";
    /// "transfer": `lines` [from, to] with a coin (`text`) going along an arrow. `mount` "hang" | "stand".
    case g1BankApp
    /// Twelve little month pages, each with the same coin on its first day; `caption` the year.
    case g1MonthStrip
    /// Poster: a bundle of money (`text`) from the bank to a car (`accessory` "house"), coins paid back.
    case g1Loan
    /// Wall chart with a pie chart, bars, a calculator and coins.
    case g1Finance
    /// Standing poster: coin stacks growing along an arrow, big `text` ("2,5 %") and `caption`.
    case g1Growth
    /// A worried person on a chair beside a pile of bills with red stamps; the top one `text` in red.
    case g1Bills
    /// A parcel. `accessory` "label" (address `lines`, barcode), "fragile" (cracked-glass label,
    /// `text`), "return" (open, shoes inside, a U-turn arrow, `text` on a tag).
    case g1Parcel
    /// A parcel on a flat post scale, the weight `text` on its display.
    case g1PostScale
    /// A sheet of six stamps with a tulip and value `text`, one peeling off.
    case g1Stamps
    /// Back of an envelope: the sender's house and name/street `lines` on the flap, ringed.
    case g1EnvelopeBack
    /// Price list: a van and `caption` on top, rows `lines` "letter|€ 1,15" ("box", "bigBox").
    case g1RateBoard
    /// A letter with a yellow "R" sticker and barcode, a hand signing on a scanner.
    case g1Registered
    /// A hand holds something out to an open hand, an arrow over them. `accessory` "parcel" | "letter" | "key".
    case g1GiveAcross
    /// A letter box in the wall: a hand pushes a letter in, another letter flies off on a dotted line.
    case g1MailSlot
    /// A window with its right half swung open, blue air streaming in and out.
    case g1OpenWindow
    /// A tiled corner with a damp stain and black and green spots.
    case g1Mould
    /// A sink with a dripping pipe, a wrench on the nut, a toolbox.
    case g1Repair
    /// Screen with a home for rent (`lines`), a hand pointer clicks the green tick button (`text`).
    /// `accessory` "compare": two homes, the dear one (`lines[0]`) crossed out, the cheap one ticked.
    case g1HomeAd
    /// A decision letter with a red line (`text`) and a hand raised against it, bubble `caption`.
    case g1Objection
    /// Poster: four neighbours holding hands under one roof, a heart in the gable.
    case g1Community
    /// Hanging screen: a long queue of little people, a clock and the waiting time `text`.
    case g1QueueScreen
    /// Poster: at night a masked burglar climbs through a broken window with a crowbar.
    case g1BreakIn
    /// A hand with a megaphone shouting a bubble: a warning sign and `text`.
    case g1Megaphone
    /// Sign: a spray can crossed out in a red ring, an arrow, handcuffs.
    case g1Forbidden
    /// Photo on a cork board: a bike rack, a dashed outline where a bike stood, a cut chain lock.
    case g1CutLock
    /// Hanging camera screen: a hooded figure peering round a corner at night, question marks, `caption`.
    case g1Cctv
    /// An open handbag, a black-gloved hand sneaking a wallet out.
    case g1Pickpocket
    /// Glass room: an interviewer holds up a résumé and asks, a candidate in a tie answers.
    case g1Interview
    /// A résumé page: a photo, a name bar, a briefcase and a cap with lines.
    case g1Resume
    /// Years of work: three past jobs along an arrow from `labels[0]` to `labels[1]`, a star, `text` ("5 jaar").
    case g1Timeline
    /// Cork board with three job cards: a red band (`caption`, "Gezocht"), a picture and lines.
    case g1JobBoard
    /// Two month pages marked 1 and 2 under a magnifier, a tick and a cross: will it work out?
    case g1TrialMonths
    /// A laptop sending a letter with a résumé; a paper plane flies to a company.
    case g1Apply
    /// A card on the desk: a big handshake, `text` ("Welkom!"), confetti.
    case g1Welcome
    /// A puzzle with one gap and the last piece sliding in, a green tick.
    case g1Puzzle
    /// Gold scales on a wooden plaque, both pans level, a green tick.
    case g1Scales
    /// A gavel striking its block with bang lines over a stamped sheet.
    case g1Gavel
    /// Two thick books, a big § on the front one.
    case g1LawBook
    /// A small table with a sealed bag (knife, tag `text`) and a fingerprint under a magnifier.
    case g1Evidence
    /// Framed picture: a prisoner in stripes behind bars, tally marks on the wall.
    case g1Bars
    /// A thick file on a lectern: two faces glaring across a lightning bolt, names `lines`.
    case g1CaseFile
    /// A photo on an easel: a traffic light on red, a cyclist riding past it.
    case g1RedLight
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
            case .g6Figure, .g6CycleSign, .g6Jumble, .g6Crockery, .g6Bargain, .g6Condition, .g6Damaged, .g6Refurbish,
                 .g6Vintage, .g6DropOff, .g6Proceeds, .g6Car, .g6FuelPump, .g6Plate, .g6Battery, .g6Verdict, .g6Rating,
                 .g6Badge, .g6Paper, .g6Hoax, .g6Broadcast, .g6NewsTV, .g6Spread, .g6Ticker, .g6Fire, .g6Rescue,
                 .g6Hazard, .g6SmokeAlarm, .g6Responders, .g6ExitSign, .g6Orchestra, .g6Musician, .g6Instruments,
                 .g6Ticket, .g6Crowd, .g6Score, .g6Bust, .g6Podium, .g6Painting, .g6Styles, .g6Standout, .g6Choose,
                 .g6Ribbon, .g6ExpoPoster, .g6Guestbook:
                G6Props.draw(prop.kind, pen, p)
            case .g1Person, .g1Atm, .g1PiggyBank, .g1BankCard, .g1MoneyCounter, .g1BankApp, .g1MonthStrip, .g1Loan,
                 .g1Finance, .g1Growth, .g1Bills, .g1Parcel, .g1PostScale, .g1Stamps, .g1EnvelopeBack, .g1RateBoard,
                 .g1Registered, .g1GiveAcross, .g1MailSlot, .g1OpenWindow, .g1Mould, .g1Repair, .g1HomeAd, .g1Objection,
                 .g1Community, .g1QueueScreen, .g1BreakIn, .g1Megaphone, .g1Forbidden, .g1CutLock, .g1Cctv, .g1Pickpocket,
                 .g1Interview, .g1Resume, .g1Timeline, .g1JobBoard, .g1TrialMonths, .g1Apply, .g1Welcome, .g1Puzzle,
                 .g1Scales, .g1Gavel, .g1LawBook, .g1Evidence, .g1Bars, .g1CaseFile, .g1RedLight:
                G1Props.draw(prop.kind, pen, p)
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
