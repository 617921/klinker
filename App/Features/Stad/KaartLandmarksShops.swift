import SwiftUI

/// Shops and services in the centre: canal houses (and a few bigger fronts) that tell what they are.
nonisolated extension KaartLandmarks {
    static func shops(_ n: Int) -> KaartLandmark? {
        switch n {
        case 2: bakker()
        case 3: jouwHuis()
        case 4: supermarkt()
        case 6: cafe()
        case 7: kantoor()
        case 8: bibliotheek()
        case 9: huisarts()
        case 10: apotheek()
        case 13: school()
        case 14: gemeentehuis()
        case 15: bank()
        case 16: postkantoor()
        case 19: fietsenmaker()
        default: nil
        }
    }

    /// De bakker: a cream step-gable bakery with a red-and-white awning, loaves and a pretzel in the window and a bread bike.
    private static func bakker() -> KaartLandmark {
        var pen = KaartPen(wall: 0xE3D6BC, door: 0x7A1E1E, awning: 0xC8261B, accent: 0xC98A3E)
        let front = pen.canalHouse(x: 0, type: .trap, width: 72, floors: 1, shop: true, flowers: true, seed: 2)
        // The shop window (x 6...44, y -34...-6): buns round a pretzel on a shelf, loaves on the sill.
        pen.rect(7, -21.4, 36, 1.4, .ink)
        pen.blob(9.5, -24.6, 13, -24.6, .accent, width: 4.6)
        pen.blob(37, -24.6, 40.5, -24.6, .accent, width: 4.6)
        var pretzel = Path()
        pretzel.move(to: CGPoint(x: 21, y: -23))
        pretzel.addCurve(to: CGPoint(x: 25, y: -31.5), control1: CGPoint(x: 16.5, y: -26.5), control2: CGPoint(x: 19.5, y: -32))
        pretzel.addCurve(to: CGPoint(x: 29, y: -23), control1: CGPoint(x: 30.5, y: -32), control2: CGPoint(x: 33.5, y: -26.5))
        pretzel.move(to: CGPoint(x: 21, y: -23))
        pretzel.addLine(to: CGPoint(x: 27.5, y: -28.5))
        pretzel.move(to: CGPoint(x: 29, y: -23))
        pretzel.addLine(to: CGPoint(x: 22.5, y: -28.5))
        pen.line(pretzel, .color(0xA8642A), width: 2.1)
        pen.blob(10, -10.5, 16, -10.5, .accent, width: 6)
        pen.blob(21, -11, 29, -11, .accent, width: 7)
        pen.blob(34, -10.5, 40, -10.5, .accent, width: 6)
        var cuts = Path()
        for x in [11.5, 14.5, 22.5, 25.5, 28.5, 35.5, 38.5] {
            cuts.move(to: CGPoint(x: x - 0.8, y: -9))
            cuts.addLine(to: CGPoint(x: x + 0.8, y: -12.5))
        }
        pen.line(cuts, .color(0x8A5226), width: 0.8)
        // The baker's bike with a crate of baguettes on the front.
        pen.bicycle(x: -30, frame: 0x2E2117)
        pen.rect(-17, -17.5, 11, 6, .color(0x9A6A3A))
        pen.blob(-15, -18.5, -12.5, -25, .accent, width: 2.4)
        pen.blob(-11.5, -18.5, -9.5, -24, .accent, width: 2.4)
        pen.blob(-8.5, -18.5, -7.5, -23, .accent, width: 2.4)
        pen.art.signAt = CGPoint(x: front.maxX - 4, y: front.minY - 4)
        pen.art.sign = "birthday.cake.fill"
        return pen.art
    }

    /// Jouw huis: Noor's brick bell gable from the House, with its hoist beam and cat stone, flower boxes, her blue bike and a plant.
    private static func jouwHuis() -> KaartLandmark {
        var pen = KaartPen(wall: 0x9A5238, door: 0x1F3A6B)
        let front = pen.canalHouse(x: 0, type: .klok, width: 84, floors: 2, flowers: true, seed: 3)
        let cx = front.midX
        // De hijsbalk with its hook under the bell top, as on Noor's house in the House.
        pen.poly([(cx - 5.5, -177.5), (cx + 5.5, -177.5), (cx + 7, -172.5), (cx - 7, -172.5)], .ink)
        var hook = Path()
        hook.move(to: CGPoint(x: cx, y: -172.5))
        hook.addLine(to: CGPoint(x: cx, y: -164.5))
        hook.addCurve(to: CGPoint(x: cx - 3.4, y: -163.9), control1: CGPoint(x: cx, y: -161.3), control2: CGPoint(x: cx - 3.4, y: -161.3))
        pen.line(hook, .ink, width: 1)
        // The gevelsteen "In de Kat" over the band.
        pen.rect(cx - 11, -58.5, 22, 11, .trim)
        pen.line(Path(CGRect(x: cx - 10.4, y: -57.9, width: 20.8, height: 9.8)), .color(0xC9A15B), width: 0.8)
        let cat = StadSVG.path(
            "M60.6 151.5c0-3.2 1.3-4.6 3-4.6s3 1.4 3 4.6z M61.9 145.3a1.7 1.7 0 1 0 3.4 0a1.7 1.7 0 1 0 -3.4 0z M62 144.4l0.4-2 1.1 1.2z M65.2 144.4l-0.4-2-1.1 1.2z M66.4 151.2c1.6 0 2.4-1 2.2-2.6l-0.7 0.1c0.1 1-0.3 1.6-1.5 1.6z"
        )
        pen.fill(cat.applying(CGAffineTransform(translationX: cx - 63, y: -200)), .ink)
        // Noor's blue bike against the house, and a plant by the door.
        pen.bicycle(x: 13, frame: 0x2F5BD3)
        pen.rect(78.5, -7, 7, 7, .color(0xB5552E))
        pen.oval(76.5, -17, 11, 11, .plant)
        pen.dot(79, -14, 2.4, .bloom)
        pen.dot(83.5, -12.5, 2.4, .bloom)
        pen.art.signAt = CGPoint(x: -34, y: -100)
        pen.art.sign = "house.fill"
        return pen.art
    }

    /// De supermarkt: a wide brick shop with a green fascia, big windows full of shelves, crates of fruit and trolleys outside.
    private static func supermarkt() -> KaartLandmark {
        var pen = KaartPen(wall: 0x5B3328, roof: 0x6E6B64, door: 0x3E4C55, awning: 0x2F4B3A, accent: 0xF2711C)
        let front = pen.box(x: 0, w: 100, h: 86, depth: 30)
        pen.rect(-3, -89, 106, 6, .trim)
        pen.windows(in: CGRect(x: 2, y: -84, width: 96, height: 32), cols: 4, rows: 1, w: 14, h: 18, seed: 4)
        // The fascia over the shop front, and two big windows with shelves of groceries.
        pen.rect(-2, -53, 104, 10, .awning)
        pen.rect(-2, -45, 104, 2, .white)
        var rnd = GevelRandom(seed: 404)
        let goods: [UInt32] = [0xF2711C, 0xE8C547, 0xC8261B, 0x5E8C45, 0x2F5BD3, 0xEFEBE2]
        for x in [4.0, 62] {
            pen.rect(x, -40, 34, 34, .lit)
            for shelf in [-29.0, -18] {
                var at = x + 2
                while at < x + 32 {
                    pen.blob(at + 0.9, shelf - 1.2, at + 0.9, shelf - 3.8 - rnd.next() * 1.6, .color(rnd.pick(goods)), width: 1.8)
                    at += 2.6
                }
                pen.rect(x, shelf, 34, 1.2, .trim)
            }
            pen.line(Path(CGRect(x: x, y: -40, width: 34, height: 34)), .trim, width: 2.2)
            pen.line(KaartPen.polygonLine([(x + 17, -40), (x + 17, -6)]), .trim, width: 1.4)
        }
        pen.door(cx: 50, w: 20, h: 36)
        pen.line(KaartPen.polygonLine([(50, -35), (50, -1)]), .trim, width: 1.2)
        // Trolleys on the left, crates of oranges, apples and greens on the right.
        pen.trolley(x: 5)
        pen.trolley(x: 10)
        pen.crate(x: 62, fruit: 0xF2711C)
        pen.crate(x: 74, fruit: 0xC8261B)
        pen.crate(x: 86, fruit: 0x5E8C45)
        pen.art.signAt = CGPoint(x: front.maxX - 4, y: front.minY - 6)
        pen.art.sign = "cart.fill"
        return pen.art
    }

    /// Het café: a brown café — a cream neck gable over a dark wooden front with warm windows and lace half-curtains, and a terrace with a parasol.
    private static func cafe() -> KaartLandmark {
        var pen = KaartPen(wall: 0xD9CDB4, door: 0x2F4B3A, awning: 0x2F4B3A, accent: 0xF6D27A)
        let front = pen.canalHouse(x: 0, type: .hals, width: 74, floors: 1, flowers: true, doorLeft: true, seed: 6)
        // The dark wooden pub front over the ground floor.
        pen.rect(0, -47, 74, 47, .color(0x4A2C1C))
        pen.rect(-1.5, -50, 77, 5, .color(0x2E1C12))
        for x in [23.0, 48] {
            pen.rect(x, -41, 22, 31, .lit)
            pen.line(KaartPen.polygonLine([(x, -33), (x + 22, -33)]), .trim, width: 1)
            pen.line(KaartPen.polygonLine([(x + 7.3, -41), (x + 7.3, -33), (x + 14.7, -33), (x + 14.7, -41)]), .trim, width: 0.8)
            pen.rect(x, -22, 22, 12, .trim)
            pen.line(KaartPen.polygonLine([(x - 1, -22), (x + 23, -22)]), .color(0xC9A15B), width: 1)
            pen.line(Path(CGRect(x: x, y: -41, width: 22, height: 31)), .color(0x2E1C12), width: 2)
            pen.rect(x - 1.5, -10, 25, 2.5, .color(0x2E1C12))
        }
        pen.art.doorRect = .zero
        pen.door(cx: 11, w: 14, h: 33)
        pen.rect(5, -45, 12, 4, .lit)
        // A brass lantern by the door that glows at night.
        pen.rect(19.5, -38, 1, 3, .ink)
        pen.rect(18, -35, 4, 5, .lit)
        pen.rect(17.5, -36, 5, 1.2, .ink)
        // The terrace: two tables with chairs under a parasol.
        pen.cafeTable(x: -14)
        pen.cafeTable(x: -36)
        pen.parasol(cx: -25, top: -46, w: 40, colors: (0xEFE6D6, 0x2F4B3A))
        pen.art.signAt = CGPoint(x: front.maxX - 4, y: front.minY + 2)
        pen.art.sign = "cup.and.saucer.fill"
        return pen.art
    }

    /// Het kantoor: a tall modern office block of pale stone with a strict grid of dark windows, a glass lobby and a plant room on the roof.
    private static func kantoor() -> KaartLandmark {
        var pen = KaartPen(wall: 0xD3CBBA, roof: 0x6E6B64, door: 0x2C2C2A, accent: 0x5E6B73)
        pen.box(x: 0, w: 80, h: 150, depth: 30)
        // Plant room and mast on the flat roof.
        pen.box(x: 28, w: 28, h: 12, depth: 14, base: -158, paint: .color(0x8E8B83))
        pen.line(KaartPen.polygonLine([(70, -160), (70, -182)]), .ink, width: 1.2)
        pen.dot(70, -182, 2.2, .color(0xC8261B))
        // Four office floors: dark windows between stone piers, slate bands under each row.
        var rnd = GevelRandom(seed: 71)
        var glass = Path(), lit = Path()
        for f in 0..<4 {
            let y = -144 + Double(f) * 27
            pen.rect(0, y + 20, 80, 4, .accent)
            for c in 0..<4 {
                let pane = Path(CGRect(x: 6 + Double(c) * 17.6, y: y, width: 12.4, height: 19))
                if rnd.next() < 0.5 { lit.addPath(pane) } else { glass.addPath(pane) }
            }
        }
        pen.fill(glass, .glass)
        pen.fill(lit, .lit)
        // The glass lobby with a canopy over the door.
        pen.rect(0, -36, 80, 3, .accent)
        pen.rect(5, -31, 70, 31, .lit)
        var mullions = Path()
        for x in [22.5, 57.5] {
            mullions.move(to: CGPoint(x: x, y: -31))
            mullions.addLine(to: CGPoint(x: x, y: 0))
        }
        pen.line(mullions, .trim, width: 1.4)
        pen.door(cx: 40, w: 18, h: 26)
        pen.line(KaartPen.polygonLine([(40, -25), (40, -1)]), .trim, width: 1)
        pen.rect(24, -30, 32, 3, .ink)
        pen.pottedTree(x: 13, h: 22)
        pen.pottedTree(x: 67, h: 22)
        pen.art.signAt = CGPoint(x: -34, y: -86)
        pen.art.sign = "briefcase.fill"
        return pen.art
    }

    /// De bibliotheek: a sandstone reading hall with a copper dome, tall arched windows full of bookshelves, a round window over the door and a reading bench.
    private static func bibliotheek() -> KaartLandmark {
        var pen = KaartPen(wall: 0xC9A15B, roof: 0x5F8F7E, door: 0x1F3A6B, accent: 0xC9A15B)
        let front = pen.box(x: 0, w: 90, h: 96, depth: 30, top: .color(0x6E6B64))
        // The green copper dome on a drum with a lantern, set back behind a balustrade.
        let drum = CGRect(x: 25, y: -114, width: 40, height: 18)
        pen.rect(drum.minX, drum.minY, drum.width, drum.height, .wall)
        pen.windows(in: drum, cols: 3, rows: 1, w: 5, h: 9, arched: true, seed: 81)
        pen.dome(over: drum, w: 48, h: 24)
        pen.rect(41, -147, 8, 10, .color(0xEFE6D6))
        pen.rect(39.5, -149, 11, 2.5, .roof)
        pen.dot(45, -151, 3.4, .accent)
        pen.rect(-3, -99, 96, 5, .trim)
        var balusters = Path()
        for x in stride(from: -1.0, through: 89, by: 5) { balusters.addRect(CGRect(x: x, y: -104, width: 2.2, height: 5)) }
        balusters.addRect(CGRect(x: -3, y: -106, width: 96, height: 2.4))
        pen.fill(balusters, .trim)
        pen.rect(0, -7, 90, 7, .color(0xA8844A))
        pen.bookWindow(x: 7, y: -86, w: 20, h: 74, seed: 8)
        pen.bookWindow(x: 63, y: -86, w: 20, h: 74, seed: 18)
        // The door with a round window above it.
        pen.door(cx: 45, w: 18, h: 34, base: -4, arched: true)
        pen.rect(33, -4, 24, 4, .trim)
        pen.oval(37, -80, 16, 16, .trim)
        pen.oval(39.5, -77.5, 11, 11, .lit)
        // A reading bench with a book on it.
        pen.bench(x: -26)
        pen.rect(-20, -9.5, 6, 2.2, .color(0xC8261B))
        pen.art.signAt = CGPoint(x: front.maxX - 4, y: front.minY - 2)
        pen.art.sign = "book.fill"
        return pen.art
    }

    /// De huisarts: a calm sage-green house with two chimneys, on a stoop with a railing, a green door with a brass plate, a hedge and a lamp.
    private static func huisarts() -> KaartLandmark {
        var pen = KaartPen(wall: 0xC5CDB9, roof: 0x45505A, door: 0x24533F, accent: 0xC9A15B)
        let front = pen.box(x: 0, w: 76, h: 74, depth: 30)
        pen.ridgeRoof(over: front, rise: 28)
        for x in [18.0, 68] {
            pen.rect(x, -118, 7, 20, .color(0x8C4A3A))
            pen.rect(x - 1, -120, 9, 3, .trim)
        }
        pen.rect(-2, -76, 80, 4, .trim)
        pen.rect(0, -6, 76, 6, .color(0xA19E95))
        pen.windows(in: CGRect(x: 2, y: -72, width: 72, height: 32), cols: 3, rows: 1, w: 14, h: 20, seed: 9)
        pen.windows(in: CGRect(x: 0, y: -41, width: 28, height: 32), cols: 1, rows: 1, w: 15, h: 20, seed: 19)
        pen.windows(in: CGRect(x: 48, y: -41, width: 28, height: 32), cols: 1, rows: 1, w: 15, h: 20, seed: 29)
        // The stoop: steps up to the door, a railing, a brass name plate and a lamp.
        pen.door(cx: 38, w: 14, h: 26, base: -8)
        pen.rect(28, -4, 20, 4, .color(0xC4BFB3))
        pen.rect(30, -8, 16, 4, .color(0xC4BFB3))
        pen.line(KaartPen.polygonLine([(28, -1), (28, -12), (31, -15)]), .ink, width: 1)
        pen.line(KaartPen.polygonLine([(48, -1), (48, -12), (45, -15)]), .ink, width: 1)
        pen.rect(47.5, -26, 5, 4, .accent)
        pen.rect(37, -42, 2, 3, .ink)
        pen.rect(35.5, -40, 5, 5, .lit)
        // A low hedge on both sides.
        pen.fill(Path(roundedRect: CGRect(x: 1, y: -9, width: 24, height: 9), cornerRadius: 4), .plant)
        pen.fill(Path(roundedRect: CGRect(x: 51, y: -9, width: 24, height: 9), cornerRadius: 4), .plant)
        pen.art.signAt = CGPoint(x: front.maxX - 4, y: front.minY - 10)
        pen.art.sign = "stethoscope"
        return pen.art
    }

    /// De apotheek: a brick spout-gable house with jars and bottles in the shop window, a gaper over the door and the green cross.
    private static func apotheek() -> KaartLandmark {
        var pen = KaartPen(wall: 0x7B3F2E, door: 0x24533F, awning: 0x24533F, accent: 0x2E9E4F)
        let front = pen.canalHouse(x: 0, type: .tuit, width: 68, floors: 2, shop: true, doorLeft: true, seed: 10)
        // Bottles on the sill and jars on the shelf of the shop window (x 28...62, y -34...-6).
        let glassColors: [UInt32] = [0x8A5A1E, 0x2F5BD3, 0xEFEBE2, 0x5E8C45, 0x7A1E1E, 0x8A5A1E]
        for (i, c) in glassColors.enumerated() {
            let x = 30.6 + Double(i) * 5.6
            pen.blob(x, -8.5, x, -12.5, .color(c), width: 3.6)
            pen.blob(x, -13, x, -15.5, .color(c), width: 1.5)
        }
        for (i, c) in [0xEFEBE2, 0x2E9E4F, 0xEFEBE2, 0xC9A15B].enumerated() {
            let x = 32 + Double(i) * 8.4
            pen.blob(x - 1.2, -24.5, x + 1.2, -24.5, .color(UInt32(c)), width: 5)
            pen.rect(x - 2.6, -28.6, 5.2, 1.4, .ink)
        }
        // De gaper: a carved head with an open mouth and a turban over the door.
        pen.oval(10.7, -57, 6, 7, .color(0xE8C4A0))
        pen.blob(10.6, -56.6, 16.8, -56.6, .color(0xC8261B), width: 3)
        pen.dot(13.7, -51.6, 1.6, .ink)
        // The green pharmacy cross on a bracket off the corner.
        let gx = front.maxX + 12, gy = -80.0
        pen.line(KaartPen.polygonLine([(front.maxX, gy - 6), (gx, gy - 6)]), .ink, width: 1.4)
        pen.greenCross(cx: gx, cy: gy, size: 23)
        pen.art.signAt = CGPoint(x: -34, y: -104)
        pen.art.sign = "pills.fill"
        return pen.art
    }

    /// De school: a long brick school with big windows, an orange tiled roof with a bell turret, a clock over the door and bikes by the yard fence.
    private static func school() -> KaartLandmark {
        var pen = KaartPen(wall: 0x8C4A3A, roof: 0xB5552E, door: 0x1F3A6B, accent: 0xC9A15B)
        let front = pen.box(x: 0, w: 110, h: 76, depth: 30)
        pen.ridgeRoof(over: front, rise: 32)
        // The bell turret on the ridge.
        pen.rect(65, -129, 10, 14, .color(0xEFEBE2))
        pen.rect(67.5, -126, 5, 8, .ink)
        pen.dot(70, -121, 3.4, .accent)
        pen.spire(cx: 70, base: -129, w: 15, h: 15, paint: .roof)
        pen.line(KaartPen.polygonLine([(70, -144), (70, -152)]), .ink, width: 1)
        // White bands and big school windows.
        pen.rect(-2, -78, 114, 4, .trim)
        pen.rect(0, -40, 110, 3, .trim)
        for x in [0.0, 68] {
            pen.windows(in: CGRect(x: x, y: -74, width: 42, height: 34), cols: 2, rows: 1, w: 15, h: 22, seed: 13 + Int(x))
            pen.windows(in: CGRect(x: x, y: -37, width: 42, height: 34), cols: 2, rows: 1, w: 15, h: 22, seed: 31 + Int(x))
        }
        // The entrance bay: a front gable with a clock, a window and a double door.
        pen.poly([(38, -76), (55, -108), (72, -76)], .wall)
        pen.line(KaartPen.polygonLine([(36, -75), (55, -110), (74, -75)]), .trim, width: 2.5)
        pen.clock(cx: 55, cy: -88, r: 7.5)
        pen.windows(in: CGRect(x: 42, y: -74, width: 26, height: 34), cols: 1, rows: 1, w: 14, h: 22, seed: 7)
        pen.door(cx: 55, w: 20, h: 30)
        pen.line(KaartPen.polygonLine([(55, -29), (55, -1)]), .trim, width: 1)
        // The schoolyard fence with bikes against it.
        pen.fence(from: -40, to: -3, h: 12)
        pen.bicycle(x: -40, frame: 0xF2711C)
        pen.bicycle(x: -26, frame: 0x2F5BD3)
        pen.art.signAt = CGPoint(x: front.maxX - 4, y: front.minY - 8)
        pen.art.sign = "backpack.fill"
        return pen.art
    }

    /// Het gemeentehuis: a stately brick town hall with white stone quoins, a columned porch on steps, a clock tower with a cupola and the flag.
    private static func gemeentehuis() -> KaartLandmark {
        var pen = KaartPen(wall: 0x9A5238, roof: 0x45505A, door: 0x1F3A6B, accent: 0xC9A15B)
        let front = pen.box(x: 0, w: 112, h: 78, depth: 32)
        pen.ridgeRoof(over: front, rise: 26, depth: 32)
        // The clock tower over the centre, with a lantern, a cupola and the flag.
        let tower = pen.box(x: 42, w: 28, h: 36, depth: 14, base: -78)
        pen.quoins(x: 42, top: tower.minY, bottom: -78)
        pen.quoins(x: 70, top: tower.minY, bottom: -78, right: true)
        pen.clock(cx: 56, cy: -97, r: 9)
        pen.rect(40, tower.minY - 4, 32, 4, .trim)
        let lantern = pen.box(x: 47, w: 18, h: 16, depth: 9, base: tower.minY - 4, paint: .trim)
        pen.windows(in: lantern, cols: 1, rows: 1, w: 7, h: 11, arched: true, seed: 14)
        pen.dome(over: lantern, w: 22, h: 8)
        pen.flag(x: 56, y: lantern.minY - 8, height: 21)
        pen.dot(56, lantern.minY - 30, 2.6, .accent)
        // Wings: stone quoins, cornice and band, tall windows over two floors.
        pen.quoins(x: 0, top: -78)
        pen.quoins(x: 112, top: -78, right: true)
        pen.rect(-3, -80, 118, 5, .trim)
        pen.rect(0, -41, 112, 3, .trim)
        for x in [2.0, 70] {
            pen.windows(in: CGRect(x: x, y: -76, width: 40, height: 35), cols: 2, rows: 1, w: 12, h: 24, arched: true, seed: 140 + Int(x))
            pen.windows(in: CGRect(x: x, y: -38, width: 40, height: 32), cols: 2, rows: 1, w: 12, h: 22, seed: 141 + Int(x))
        }
        // The porch: a stone frame, steps, two columns, a pediment and a golden coat of arms.
        pen.rect(38, -62, 36, 56, .color(0xE3D6BC))
        pen.door(cx: 56, w: 16, h: 28, base: -6, arched: true)
        pen.rect(32, -3, 48, 3, .color(0xC4BFB3))
        pen.rect(36, -6, 40, 3, .color(0xC4BFB3))
        pen.columns(from: 44, to: 68, count: 2, base: -6, h: 34)
        pen.pediment(x: 34, w: 44, y: -47, rise: 12)
        pen.poly([(51, -74), (61, -74), (61, -67), (56, -62), (51, -67)], .accent)
        pen.art.signAt = CGPoint(x: -34, y: -98)
        pen.art.sign = "building.columns.fill"
        return pen.art
    }

    /// De bank: a grey stone temple front with four cream columns, a pediment with a gold coin, steps and heavy bronze doors.
    private static func bank() -> KaartLandmark {
        var pen = KaartPen(wall: 0x8E8B83, roof: 0x6E6B64, door: 0x6B4A2E, accent: 0xC9A15B)
        let front = pen.box(x: 0, w: 90, h: 84, depth: 30)
        pen.gableRoof(over: front, rise: 22, gable: .trim)
        pen.poly([(11, -86.5), (45, -102), (79, -86.5)], .wall)
        pen.oval(40, -96, 10, 8, .accent)
        pen.rect(0, -84, 90, 7, .trim)
        pen.rect(-1, -10, 92, 10, .color(0x77746C))
        // Tall windows and the heavy double doors behind the columns.
        pen.windows(in: CGRect(x: 13, y: -66, width: 20, height: 52), cols: 1, rows: 1, w: 10, h: 40, seed: 15)
        pen.windows(in: CGRect(x: 57, y: -66, width: 20, height: 52), cols: 1, rows: 1, w: 10, h: 40, seed: 51)
        pen.door(cx: 45, w: 17, h: 34, base: -10)
        pen.line(KaartPen.polygonLine([(45, -43), (45, -11)]), .ink, width: 1)
        pen.rect(39.5, -28, 3, 1.6, .accent)
        pen.rect(47.5, -28, 3, 1.6, .accent)
        pen.columns(from: 12, to: 78, count: 4, base: -10, h: 60)
        pen.rect(26, -3.4, 38, 3.4, .color(0xC4BFB3))
        pen.rect(29, -6.8, 32, 3.4, .color(0xC4BFB3))
        pen.rect(32, -10, 26, 3.2, .color(0xC4BFB3))
        pen.art.signAt = CGPoint(x: front.maxX - 4, y: front.minY - 4)
        pen.art.sign = "eurosign.circle.fill"
        return pen.art
    }

    /// Het postkantoor: a brick post office with a stepped gable carrying an envelope, white stone bands, an arched door and a red post box.
    private static func postkantoor() -> KaartLandmark {
        var pen = KaartPen(wall: 0x8C4A3A, roof: 0x45505A, door: 0x2F4B3A, accent: 0xC8261B)
        let front = pen.box(x: 0, w: 76, h: 80, depth: 30)
        pen.stepGable(over: front, rise: 46)
        pen.rect(front.midX - 12, -114, 24, 16, .white)
        pen.line(KaartPen.polygonLine([(front.midX - 12, -114), (front.midX, -104), (front.midX + 12, -114)]), .ink, width: 1.4)
        pen.line(Path(CGRect(x: front.midX - 12, y: -114, width: 24, height: 16)), .ink, width: 1)
        pen.rect(-2, -82, 80, 4, .trim)
        pen.rect(0, -45, 76, 3, .trim)
        pen.windows(in: CGRect(x: 0, y: -78, width: 76, height: 32), cols: 3, rows: 1, w: 12, h: 20, seed: 16)
        pen.windows(in: CGRect(x: 0, y: -42, width: 26, height: 40), cols: 1, rows: 1, w: 13, h: 28, arched: true, seed: 61)
        pen.windows(in: CGRect(x: 50, y: -42, width: 26, height: 40), cols: 1, rows: 1, w: 13, h: 28, arched: true, seed: 62)
        pen.door(cx: 38, w: 18, h: 34, arched: true)
        // The red post box on its post.
        pen.rect(-11.2, -14, 2.4, 14, .ink)
        pen.fill(Path(roundedRect: CGRect(x: -17, y: -32, width: 14, height: 19), cornerRadius: 3), .color(0xC8261B))
        pen.line(KaartPen.polygonLine([(-14.5, -27), (-5.5, -27)]), .ink, width: 1.2)
        pen.line(KaartPen.polygonLine([(-14.5, -22), (-5.5, -22)]), .ink, width: 1.2)
        pen.art.signAt = CGPoint(x: front.maxX - 4, y: front.minY - 2)
        pen.art.sign = "envelope.fill"
        return pen.art
    }

    /// De fietsenmaker: a green wooden workshop with a front gable, red barn doors open on a bike in the stand, a wheel on the gable and bikes outside.
    private static func fietsenmaker() -> KaartLandmark {
        var pen = KaartPen(wall: 0x3F5A4A, roof: 0x5B3328, door: 0x2A2017, accent: 0xF2711C)
        let front = pen.box(x: 0, w: 76, h: 54, depth: 34)
        pen.gableRoof(over: front, rise: 34, depth: 34, overhang: 4)
        var planks = Path()
        for x in stride(from: 6.0, to: 76, by: 6) {
            let top = -54 - 34 * (1 - abs(x - 38) / 38)
            planks.move(to: CGPoint(x: x, y: top + 2))
            planks.addLine(to: CGPoint(x: x, y: 0))
        }
        pen.line(planks, .darker(0x3F5A4A), width: 0.8)
        // The wheel on the gable.
        pen.wheel(cx: 38, cy: -70, r: 9)
        // The open workshop: a dark opening with a bike in the stand, red barn doors folded back.
        pen.door(cx: 28, w: 28, h: 40)
        pen.bicycle(x: 16, base: -3, frame: 0xF2711C, wheels: .trim)
        for x in [5.0, 42] {
            pen.rect(x, -40, 9, 40, .color(0x8E2A1E))
            pen.line(KaartPen.polygonLine([(x + 1, -39), (x + 8, -1)]), .trim, width: 1)
            pen.line(Path(CGRect(x: x + 0.6, y: -39.4, width: 7.8, height: 38.8)), .trim, width: 1)
        }
        pen.windows(in: CGRect(x: 50, y: -46, width: 26, height: 30), cols: 1, rows: 1, w: 16, h: 18, seed: 19)
        // Bikes waiting outside.
        pen.bicycle(x: -28, frame: 0xC8261B)
        pen.bicycle(x: 80, frame: 0x2F5BD3)
        pen.art.signAt = CGPoint(x: -34, y: -84)
        pen.art.sign = "bicycle"
        return pen.art
    }
}

// MARK: - Props for the shops

nonisolated private extension KaartPen {
    /// A short thick stroke with round ends, in any colour and without an outline: a loaf, a book, a bottle.
    mutating func blob(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double, _ paint: KaartPaint, width: Double) {
        line(Self.polygonLine([(x1, y1), (x2, y2)]), paint, width: width)
    }

    /// A round dot `d` across, without an outline.
    mutating func dot(_ x: Double, _ y: Double, _ d: Double, _ paint: KaartPaint) {
        blob(x - 0.01, y, x + 0.01, y, paint, width: d)
    }

    /// A Dutch bike (24 wide, 16 high) standing on `base` from x.
    mutating func bicycle(x: Double, base: Double = 0, frame: UInt32, wheels wheelPaint: KaartPaint = .ink) {
        let r = 5.2
        func p(_ dx: Double, _ dy: Double) -> (Double, Double) { (x + dx, base + dy) }
        func pt(_ dx: Double, _ dy: Double) -> CGPoint { let q = p(dx, dy); return CGPoint(x: q.0, y: q.1) }
        var wheels = Path()
        for hub in [pt(5.5, -r), pt(18.5, -r)] {
            wheels.addEllipse(in: CGRect(x: hub.x - r, y: hub.y - r, width: 2 * r, height: 2 * r))
        }
        line(wheels, wheelPaint, width: 1.3)
        var bars = Path()
        bars.addPath(Self.polygonLine([p(5.5, -r), p(10, -r - 8.5), p(11.5, -r), p(5.5, -r)]))
        bars.addPath(Self.polygonLine([p(10, -r - 8.5), p(16.8, -r - 8.5), p(18.5, -r)]))
        bars.addPath(Self.polygonLine([p(11.5, -r), p(16.8, -r - 8.5)]))
        line(bars, .color(frame), width: 1.5)
        line(Self.polygonLine([p(10, -r - 8.5), p(9.6, -r - 10.2)]), .ink, width: 1)
        line(Self.polygonLine([p(7.8, -r - 10.4), p(11.6, -r - 10.4)]), .ink, width: 1.8)
        line(Self.polygonLine([p(16.8, -r - 8.5), p(16.3, -r - 11.8), p(19.6, -r - 12.2)]), .ink, width: 1.2)
    }

    /// A shopping trolley (17 wide, 18 high) from x.
    mutating func trolley(x: Double) {
        var cage = Path()
        cage.addPath(Self.polygon([(x + 2, -16), (x + 14, -16), (x + 12.5, -7), (x + 3.5, -7)]))
        for gx in [5.0, 8, 11] {
            cage.move(to: CGPoint(x: x + gx, y: -16))
            cage.addLine(to: CGPoint(x: x + gx + 0.3, y: -7))
        }
        cage.addPath(Self.polygonLine([(x + 3.5, -7), (x + 3.5, -2), (x + 13, -2), (x + 12.5, -7)]))
        line(cage, .color(0x9AA3A8), width: 1.1)
        line(Self.polygonLine([(x + 14, -16), (x + 16.5, -18.5)]), .color(0x9AA3A8), width: 1.1)
        line(Self.polygonLine([(x + 15.5, -19.3), (x + 17.5, -17.7)]), .awning, width: 2)
        dot(x + 4, -1, 2.2, .ink)
        dot(x + 12.5, -1, 2.2, .ink)
    }

    /// A wooden crate (10 wide) on the ground, heaped with fruit.
    mutating func crate(x: Double, fruit: UInt32) {
        for (i, dx) in [1.8, 4.6, 7.4, 3.2, 6.0].enumerated() {
            dot(x + dx + 0.4, i < 3 ? -7.6 : -9.6, 3.2, .color(fruit))
        }
        rect(x, -7, 10, 7, .color(0x9A6A3A))
        line(Self.polygonLine([(x + 0.5, -3.5), (x + 9.5, -3.5)]), .color(0x6B4A2E), width: 0.8)
    }

    /// A round café table with a chair on each side, centred at x.
    mutating func cafeTable(x: Double) {
        var chairs = Path()
        for s in [-1.0, 1.0] {
            chairs.addPath(Self.polygonLine([(x + s * 10.5, -15.5), (x + s * 10, -8), (x + s * 6.5, -8), (x + s * 6.5, 0)]))
            chairs.addPath(Self.polygonLine([(x + s * 10, -8), (x + s * 10, 0)]))
        }
        line(chairs, .color(0x8A5A32), width: 1.3)
        line(Self.polygonLine([(x, -12), (x, -0.6)]), .ink, width: 1.3)
        line(Self.polygonLine([(x - 3, -0.6), (x + 3, -0.6)]), .ink, width: 1.2)
        blob(x - 5.5, -12.6, x + 5.5, -12.6, .color(0x2E2117), width: 2)
        dot(x - 1.5, -15, 2.6, .color(0xF6D27A))
    }

    /// A striped parasol over the terrace: a pole from the ground and a wide canopy with its top at `top`.
    mutating func parasol(cx: Double, top: Double, w: Double, colors: (UInt32, UInt32)) {
        line(Self.polygonLine([(cx, top), (cx, 0)]), .ink, width: 1.4)
        let n = 6
        let base = top + 10
        for i in 0..<n {
            let a = cx - w / 2 + Double(i) * w / Double(n), b = a + w / Double(n)
            poly([(cx, top), (a, base), (b, base)], .color(i % 2 == 0 ? colors.0 : colors.1))
        }
        var valance = Path()
        for i in 0..<n {
            let a = cx - w / 2 + Double(i) * w / Double(n)
            valance.addEllipse(in: CGRect(x: a, y: base - 1.5, width: w / Double(n), height: 4))
        }
        fill(valance, .awning)
        dot(cx, top - 1, 2.4, .ink)
    }

    /// A park bench (22 wide) from x.
    mutating func bench(x: Double) {
        line(Self.polygonLine([(x + 2, -7), (x + 2, 0)]), .ink, width: 1.2)
        line(Self.polygonLine([(x + 20, -7), (x + 20, 0)]), .ink, width: 1.2)
        blob(x, -7.2, x + 22, -7.2, .color(0x8A5A32), width: 2)
        blob(x + 0.5, -12, x + 21.5, -12, .color(0x8A5A32), width: 2)
        line(Self.polygonLine([(x + 2, -7), (x + 1.5, -12.5)]), .ink, width: 1)
        line(Self.polygonLine([(x + 20, -7), (x + 20.5, -12.5)]), .ink, width: 1)
    }

    /// A low iron fence with a rail on top, from x to x2.
    mutating func fence(from x: Double, to x2: Double, h: Double) {
        var bars = Path()
        for bx in stride(from: x, through: x2, by: 3.2) {
            bars.move(to: CGPoint(x: bx, y: 0))
            bars.addLine(to: CGPoint(x: bx, y: -h))
        }
        bars.addPath(Self.polygonLine([(x, -h), (x2, -h)]))
        bars.addPath(Self.polygonLine([(x, -h * 0.4), (x2, -h * 0.4)]))
        line(bars, .color(0x2B3A33), width: 1)
    }

    /// White stone corner blocks, long and short, up the edge of a wall at x (on its left side unless `right`).
    mutating func quoins(x: Double, top: Double, bottom: Double = 0, right: Bool = false) {
        var blocks = Path()
        var y = bottom - 5.5, i = 0
        while y > top + 1 {
            let w = i % 2 == 0 ? 7.0 : 4.5
            blocks.addRect(CGRect(x: right ? x - w : x, y: y, width: w, height: 4.2))
            y -= 6.4
            i += 1
        }
        fill(blocks, .trim)
    }

    /// A clock face with a dark rim and hands at ten past ten.
    mutating func clock(cx: Double, cy: Double, r: Double) {
        let face = CGRect(x: cx - r, y: cy - r, width: 2 * r, height: 2 * r)
        oval(face.minX, face.minY, face.width, face.height, .white)
        line(Path(ellipseIn: face), .ink, width: max(1, r * 0.18))
        line(Self.polygonLine([(cx - r * 0.45, cy - r * 0.35), (cx, cy), (cx + r * 0.55, cy - r * 0.45)]), .ink, width: max(0.9, r * 0.15))
    }

    /// The Dutch pharmacy sign: a green cross with a white edge, `size` across.
    mutating func greenCross(cx: Double, cy: Double, size: Double) {
        let a = size * 0.36
        func cross(_ s: Double, _ t: Double) -> [(Double, Double)] {
            [(cx - t / 2, cy - s / 2), (cx + t / 2, cy - s / 2), (cx + t / 2, cy - t / 2), (cx + s / 2, cy - t / 2),
             (cx + s / 2, cy + t / 2), (cx + t / 2, cy + t / 2), (cx + t / 2, cy + s / 2), (cx - t / 2, cy + s / 2),
             (cx - t / 2, cy + t / 2), (cx - s / 2, cy + t / 2), (cx - s / 2, cy - t / 2), (cx - t / 2, cy - t / 2)]
        }
        poly(cross(size + 3, a + 3), .white)
        poly(cross(size, a), .accent)
    }

    /// A bike wheel with spokes, as a sign.
    mutating func wheel(cx: Double, cy: Double, r: Double) {
        var spokes = Path()
        for i in 0..<8 {
            let t = Double(i) * .pi / 4
            spokes.move(to: CGPoint(x: cx, y: cy))
            spokes.addLine(to: CGPoint(x: cx + cos(t) * r, y: cy + sin(t) * r))
        }
        line(spokes, .trim, width: 0.7)
        line(Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: 2 * r, height: 2 * r)), .ink, width: 2.6)
        dot(cx, cy, 2.6, .accent)
    }

    /// A tall arched window with bookshelves inside: glass in the arch, rows of coloured spines below.
    mutating func bookWindow(x: Double, y: Double, w: Double, h: Double, seed: Int) {
        let pane = Self.window(x: x, y: y, w: w, h: h, arched: true)
        fill(pane, .lit)
        var rnd = GevelRandom(seed: seed)
        let colors: [UInt32] = [0xC8261B, 0x1F3A6B, 0x2F4B3A, 0xE8C547, 0xF2711C, 0xEFEBE2, 0x7A1E1E, 0x5E8C45]
        var row = y + w / 2 + 2
        var shelves = Path()
        while row + 9 <= y + h {
            var bx = x + 1.8
            while bx < x + w - 1.8 {
                let top = row + 8 - (5 + rnd.next() * 2.6)
                blob(bx + 0.7, row + 7.6, bx + 0.7, top, .color(rnd.pick(colors)), width: 1.5)
                bx += 2.1
            }
            shelves.addPath(Self.polygonLine([(x, row + 8.6), (x + w, row + 8.6)]))
            row += 10
        }
        line(shelves, .color(0x6B4A2E), width: 1.2)
        line(pane, .trim, width: 2)
    }

    /// A stepped gable (trapgevel) on top of `front`, with the roof running back behind it.
    mutating func stepGable(over front: CGRect, rise: Double, depth: Double = 30, steps: Int = 3) {
        let l = Double(front.minX), r = Double(front.maxX), top = Double(front.minY), w = Double(front.width)
        let dx = depth, dy = -depth * Self.slope
        let sw = w * 0.13, sh = rise / Double(steps + 1)
        poly([(front.midX, top - rise), (front.midX + dx, top - rise + dy), (r + dx, top + dy), (r, top)], .roofSide)
        var pts: [(Double, Double)] = [(l, top)]
        var x = l, y = top
        var caps = Path()
        for i in 0..<steps {
            y -= sh
            pts.append((x, y))
            caps.addRect(CGRect(x: x - (i == 0 ? 2 : 0), y: y - 1, width: sw + (i == 0 ? 2 : 0), height: 3.5))
            x += sw
            pts.append((x, y))
        }
        y -= sh
        pts.append((x, y))
        var xr = r - Double(steps) * sw
        caps.addRect(CGRect(x: x - 2, y: y - 1, width: xr - x + 4, height: 3.5))
        pts.append((xr, y))
        y += sh
        pts.append((xr, y))
        for i in 0..<steps {
            caps.addRect(CGRect(x: xr, y: y - 1, width: sw + (i == steps - 1 ? 2 : 0), height: 3.5))
            xr += sw
            pts.append((xr, y))
            y += sh
            pts.append((xr, y))
        }
        poly(pts, .wall)
        fill(caps, .trim)
    }
}
