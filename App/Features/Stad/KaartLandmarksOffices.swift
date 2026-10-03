import SwiftUI

/// Offices, practices and services: housing, police, barber, restaurant, language school,
/// temp agency, dentist, vet, tax office, notary, insurer, newspaper kiosk, community centre.
nonisolated extension KaartLandmarks {
    static func offices(_ n: Int) -> KaartLandmark? {
        switch n {
        case 20: woningcorporatie()
        case 21: politiebureau()
        case 27: kapper()
        case 28: restaurant()
        case 30: taalschool()
        case 31: uitzendbureau()
        case 33: tandarts()
        case 34: dierenarts()
        case 39: belastingdienst()
        case 40: notaris()
        case 41: verzekeraar()
        case 50: krantenkiosk()
        case 51: buurthuis()
        default: nil
        }
    }

    /// De woningcorporatie: a modern block of flats with bright balconies and solar panels, over the
    /// brick housing office with little house models in its window.
    private static func woningcorporatie() -> KaartLandmark {
        var pen = KaartPen(wall: 0xDCD2BF, roof: 0x6E6B64, door: 0x2F4B3A, accent: 0xC8261B)
        let w = 108.0, h = 152.0, plinth = 36.0
        pen.box(x: 0, w: w, h: h)
        // The office: a brick plinth with a big window of house models.
        pen.sidePatch(w: w, d0: 0, d1: 30, top: -plinth, bottom: 0, .darker(0x8C4A3A))
        pen.rect(0, -plinth, w, plinth, .color(0x8C4A3A))
        pen.rect(6, -31, 60, 25, .lit)
        pen.line(Path(CGRect(x: 6, y: -31, width: 60, height: 25)), .trim, width: 2.4)
        pen.rect(9, -10, 54, 2, .trim)
        for (i, c) in [UInt32(0xF4F1EA), 0xE0A93B, 0x9FC4D8].enumerated() {
            let x = 13 + Double(i) * 17
            pen.rect(x, -18, 11, 8, .color(c))
            pen.poly([(x - 1.5, -18), (x + 5.5, -25), (x + 12.5, -18)], .color(0xC8261B))
            pen.rect(x + 4, -15, 3, 5, .ink)
        }
        pen.rect(73, -33.5, 28, 3, .ink)
        pen.door(cx: 87, w: 16, h: 28)
        // Three storeys of flats, two balconies each, in cheerful colours.
        let balconies: [[UInt32]] = [[0xF2711C, 0x7FA36B], [0x3D6E9E, 0xE0A93B], [0x7FA36B, 0xF2711C]]
        for i in 0..<3 {
            let base = -plinth - 38 * Double(i)
            pen.windows(in: CGRect(x: 2, y: base - 38, width: w - 4, height: 36), cols: 4, rows: 1, w: 14, h: 24, seed: 20 + i)
            pen.sidePatch(w: w, d0: 9, d1: 21, top: base - 30, bottom: base - 12, .glass)
            for (j, x) in [7.0, 55].enumerated() {
                pen.rect(x, base - 13, 46, 10, .color(balconies[i][j]))
                pen.rect(x - 2, base - 3.5, 50, 3.5, .trim)
                if (i + j) % 2 == 0 {
                    pen.oval(x + 3, base - 19, 7, 7, .plant)
                    pen.oval(x + 5, base - 19, 3, 3, .bloom)
                }
            }
        }
        pen.rect(-1, -h - 1, w + 2, 4, .trim)
        // Solar panels and a stair hut on the flat roof.
        for x in [6.0, 30, 54] {
            pen.topPatch(x: x, w: 20, d0: 6, d1: 24, top: -h, .color(0x2B3A5A))
        }
        pen.box(x: 88, w: 16, h: 12, depth: 10, base: -h - 9, paint: .color(0xCFC5B1), top: .roof)
        pen.art.signAt = CGPoint(x: w + 2, y: -78)
        pen.art.sign = "key.fill"
        return pen.art
    }

    /// Het politiebureau: a brick station with a blue-and-white chequered band, a blue lamp over the
    /// doors, a flag on the roof, and a police car and a police bike out front.
    private static func politiebureau() -> KaartLandmark {
        var pen = KaartPen(wall: 0x8C4A3A, roof: 0x45505A, door: 0x1F3A6B, accent: 0x3B7DD8)
        let w = 124.0, h = 86.0, depth = 32.0
        pen.box(x: 0, w: w, h: h, depth: depth)
        // The chequered band under the roof, wrapping round the corner.
        let band = -h + 4
        pen.rect(0, band, w, 10, .color(0x1F3A6B))
        pen.sidePatch(w: w, d0: 0, d1: depth, top: band, bottom: band + 10, .darker(0x1F3A6B))
        var checks = Path()
        for (i, x) in stride(from: 0.0, to: w - 1, by: 6.2).enumerated() {
            checks.addRect(CGRect(x: x, y: band + (i % 2 == 0 ? 0 : 5), width: 6.2, height: 5))
        }
        pen.fill(checks, .white)
        pen.rect(-1.5, -h - 1, w + 3, 5, .trim)
        pen.windows(in: CGRect(x: 0, y: -72, width: w, height: 30), cols: 5, rows: 1, w: 14, h: 19, seed: 21)
        pen.windows(in: CGRect(x: 0, y: -36, width: 46, height: 34), cols: 2, rows: 1, w: 13, h: 19, seed: 5)
        pen.windows(in: CGRect(x: 78, y: -36, width: 46, height: 34), cols: 2, rows: 1, w: 13, h: 19, seed: 6)
        // Double doors under a canopy, the blue lamp above.
        pen.rect(46, -34.5, 32, 3, .ink)
        pen.door(cx: 62, w: 22, h: 30)
        pen.rect(61.2, -29, 1.6, 29, .trim)
        pen.rect(60.5, -40, 3, 4, .ink)
        pen.rect(52.5, -55, 19, 3, .white)
        pen.rect(54.5, -52, 15, 11, .accent)
        pen.rect(52.5, -41.5, 19, 2.6, .white)
        pen.flag(x: 36, y: -h - 9, height: 30)
        pen.rect(102, -h - 26, 1.4, 22, .ink)
        // A police car in front of the left windows, a police bike with a white pannier on the right.
        pen.policeCar(x: 1)
        pen.bike(x: 92, color: 0x1F3A6B, k: 1.15)
        pen.rect(93, -13.5, 9, 6.5, .white)
        pen.rect(93, -11, 9, 1.6, .color(0x1F3A6B))
        pen.art.signAt = CGPoint(x: w + 2, y: -76)
        pen.art.sign = "shield.fill"
        return pen.art
    }

    /// De kapper: a cream neck-gable house with a big shop window and a barber's pole by the door.
    private static func kapper() -> KaartLandmark {
        var pen = KaartPen(wall: 0xE3D6BC, door: 0x1F3A6B, awning: 0x1F3A6B)
        let front = pen.canalHouse(x: 0, type: .hals, width: 66, floors: 2, shop: true, flowers: true, seed: 27)
        // Barber's pole: a white tube with red and blue bands, on a bracket left of the shop.
        let x = front.minX - 10, top = -62.0
        pen.rect(x + 7, top + 8, 4, 2, .ink)
        pen.oval(x + 1, top - 5, 6, 6, .trim)
        pen.rect(x - 0.6, top - 1, 9.2, 3, .ink)
        pen.fill(Path(roundedRect: CGRect(x: x, y: top + 2, width: 8, height: 24), cornerRadius: 3), .white)
        var red = Path(), blue = Path()
        for i in 0..<4 {
            let y = top + 2 + Double(i) * 6
            let band = KaartPen.polygon([(x, y + 3), (x + 8, y), (x + 8, y + 2), (x, y + 5)])
            if i % 2 == 0 { red.addPath(band) } else { blue.addPath(band) }
        }
        pen.fill(red, .color(0xC8261B))
        pen.fill(blue, .color(0x1F3A6B))
        pen.rect(x - 0.6, top + 26, 9.2, 3, .ink)
        pen.art.signAt = CGPoint(x: front.maxX - 4, y: front.minY + 30)
        pen.art.sign = "scissors"
        return pen.art
    }

    /// Het restaurant: a dark-green bell-gable house with a wine-red awning, and a terrace of tables
    /// with checked cloths under string lights and a parasol, with a chalkboard menu by the door.
    private static func restaurant() -> KaartLandmark {
        var pen = KaartPen(wall: 0x2F4B3A, door: 0x7A1E1E, awning: 0x7A1E1E, accent: 0xEFE6D6)
        let front = pen.canalHouse(x: 0, type: .klok, width: 76, floors: 2, shop: true, flowers: true, seed: 28)
        // String lights from a pole at the end of the terrace to the front.
        pen.rect(-69, -64, 2.2, 64, .ink)
        pen.stringLights(from: CGPoint(x: -68, y: -63), to: CGPoint(x: front.minX + 2, y: -76), sag: 10, bulbs: 8)
        // Two tables with checked cloths and chairs; a parasol over the far one.
        for (cx, parasol) in [(-49.0, true), (-20.0, false)] {
            pen.chair(cx: cx - 13, facingRight: true)
            pen.chair(cx: cx + 13, facingRight: false)
            pen.rect(cx - 1, -10, 2, 10, .ink)
            pen.rect(cx - 4.5, -1.8, 9, 1.8, .ink)
            pen.rect(cx - 10, -18, 20, 8, .color(0xC8261B))
            var checks = Path()
            for i in 0..<5 {
                checks.addRect(CGRect(x: cx - 10 + Double(i) * 4, y: i % 2 == 0 ? -18 : -14, width: 4, height: 4))
            }
            pen.fill(checks, .white)
            pen.oval(cx - 10.5, -20, 21, 4.5, .white)
            if parasol {
                pen.rect(cx - 0.8, -50, 1.6, 31, .ink)
                pen.poly([(cx - 20, -42), (cx, -53), (cx + 20, -42)], .awning)
                pen.rect(cx - 20, -42, 40, 3.5, .accent)
                pen.rect(cx + 4, -26, 2.4, 7, .color(0x2F5E46))
            } else {
                pen.oval(cx - 2, -26, 4, 5, .bloom)
                pen.rect(cx - 0.5, -22, 1, 3, .plant)
            }
        }
        // The chalkboard menu on the pavement right of the door.
        let d = pen.art.doorRect
        let bx = d.maxX + 4
        pen.poly([(bx, 0), (bx + 4, -18), (bx + 6, -18), (bx + 2.5, 0)], .color(0x6B4A2E))
        pen.poly([(bx + 12, 0), (bx + 8, -18), (bx + 10, -18), (bx + 13.5, 0)], .color(0x6B4A2E))
        pen.rect(bx + 1.5, -17, 11, 13, .color(0x2C2C2A))
        var chalk = Path()
        for (i, y) in [-14.0, -11, -8].enumerated() {
            chalk.addRect(CGRect(x: bx + 3.5, y: y, width: i == 0 ? 7 : 5.5, height: 0.9))
        }
        pen.fill(chalk, .white)
        pen.art.signAt = CGPoint(x: front.maxX - 4, y: front.minY + 30)
        pen.art.sign = "fork.knife"
        return pen.art
    }

    /// De taalschool: a sunny yellow schoolhouse whose big gable holds two chatting speech bubbles,
    /// with an arched door and bikes against the wall.
    private static func taalschool() -> KaartLandmark {
        var pen = KaartPen(wall: 0xE2B957, roof: 0xA4452E, door: 0x1F3A6B, accent: 0xF2711C)
        let w = 96.0
        let front = pen.box(x: 0, w: w, h: 72)
        pen.gableRoof(over: front, rise: 54)
        pen.rect(0, -38, w, 3, .trim)
        pen.windows(in: CGRect(x: 0, y: -72, width: w, height: 34), cols: 3, rows: 1, w: 15, h: 21, seed: 30)
        pen.windows(in: CGRect(x: 0, y: -35, width: 36, height: 33), cols: 1, rows: 1, w: 20, h: 21, seed: 3)
        pen.windows(in: CGRect(x: 60, y: -35, width: 36, height: 33), cols: 1, rows: 1, w: 20, h: 21, seed: 4)
        pen.door(cx: 48, w: 18, h: 30, arched: true)
        // Two speech bubbles in the gable: a white one with dots, an orange one answering.
        let white = speechBubble(CGRect(x: 25, y: -105, width: 31, height: 19), tailLeft: true)
        pen.fill(white, .white)
        pen.line(white, .ink, width: 1)
        for i in 0..<3 { pen.oval(30.5 + Double(i) * 8, -97.5, 4, 4, .color(0x1F3A6B)) }
        let orange = speechBubble(CGRect(x: 47, y: -93, width: 25, height: 15), tailLeft: false)
        pen.fill(orange, .accent)
        pen.line(orange, .ink, width: 1)
        pen.rect(52, -88.5, 15, 1.8, .white)
        pen.rect(52, -84.5, 10, 1.8, .white)
        // Bikes leaning against the front.
        pen.bike(x: 2, color: 0xC8261B)
        pen.bike(x: 66, color: 0x2F6FA8)
        pen.art.signAt = CGPoint(x: w + 2, y: -86)
        pen.art.sign = "character.bubble.fill"
        return pen.art
    }

    /// Het uitzendbureau: a white modern office with an orange band over a big glass shop front full
    /// of job posters, ribbon windows above and a flag banner by the door.
    private static func uitzendbureau() -> KaartLandmark {
        var pen = KaartPen(wall: 0xEDE8DF, roof: 0x5E6B73, door: 0x2C2C2A, awning: 0x2F6FA8, accent: 0xF2711C)
        let w = 92.0, h = 108.0
        pen.box(x: 0, w: w, h: h)
        // Glass shop front in a dark frame, posters stuck on the glass.
        pen.rect(0, -42, w, 42, .color(0x2C2C2A))
        pen.rect(4, -38, 52, 35, .lit)
        pen.line(KaartPen.polygonLine([(30, -38), (30, -3)]), .ink, width: 1.6)
        for row in 0..<2 {
            for col in 0..<3 {
                let px = 8 + Double(col) * 16 - (col > 1 ? 2 : 0), py = -35 + Double(row) * 16
                pen.rect(px, py, 11, 13.5, .white)
                pen.rect(px, py, 11, 4, (row + col) % 2 == 0 ? .accent : .awning)
                pen.rect(px + 2, py + 6.5, 7, 1, .ink)
                pen.rect(px + 2, py + 9, 4.5, 1, .ink)
            }
        }
        pen.door(cx: 73, w: 18, h: 34, paint: .lit)
        pen.rect(72.2, -34, 1.6, 34, .ink)
        // The orange band, wrapping round the corner.
        pen.rect(0, -50, w, 8, .accent)
        pen.sidePatch(w: w, d0: 0, d1: 30, top: -50, bottom: -42, .darker(0xF2711C))
        // Ribbon windows on the two office floors.
        for y in [-74.0, -101] {
            for i in 0..<4 {
                pen.rect(6 + Double(i) * 20, y, 20, 16, (i + Int(-y)) % 3 == 0 ? .glass : .lit)
            }
            var mullions = Path(CGRect(x: 6, y: y, width: 80, height: 16))
            for i in 1..<4 {
                mullions.move(to: CGPoint(x: 6 + Double(i) * 20, y: y))
                mullions.addLine(to: CGPoint(x: 6 + Double(i) * 20, y: y + 16))
            }
            pen.line(mullions, .trim, width: 1.6)
            pen.rect(4, y + 16, 84, 2.2, .trim)
        }
        // A tall orange flag banner on the pavement.
        pen.rect(-17, -64, 1.6, 64, .ink)
        var banner = Path()
        banner.move(to: CGPoint(x: -15.5, y: -63))
        banner.addQuadCurve(to: CGPoint(x: -4, y: -46), control: CGPoint(x: -4, y: -64))
        banner.addLine(to: CGPoint(x: -5, y: -20))
        banner.addLine(to: CGPoint(x: -15.5, y: -17))
        banner.closeSubpath()
        pen.fill(banner, .accent)
        pen.rect(-13, -50, 6, 1.6, .white)
        pen.rect(-13, -46, 6, 1.6, .white)
        pen.art.signAt = CGPoint(x: w + 2, y: -86)
        pen.art.sign = "briefcase.fill"
        return pen.art
    }

    /// De tandarts: a clean white bell-gable house with mint trim and a big white tooth on a round
    /// mint plaque in its gable, half-lowered blinds, a mint door and a potted bay tree.
    private static func tandarts() -> KaartLandmark {
        var pen = KaartPen(wall: 0xF4F1EA, roof: 0x7E8C93, door: 0x3E9C8F, accent: 0x5DB8A8)
        let w = 78.0, h = 70.0, cx = w / 2
        pen.box(x: 0, w: w, h: h)
        // A bell gable on top, its roof running back.
        pen.poly([(cx, -124), (cx + 30, -141), (w + 30, -h - 17), (w, -h)], .roof)
        var edge = Path()
        edge.move(to: CGPoint(x: 0, y: -h))
        edge.addQuadCurve(to: CGPoint(x: 15, y: -95), control: CGPoint(x: 15, y: -h - 3))
        edge.addCurve(to: CGPoint(x: cx, y: -124), control1: CGPoint(x: 12, y: -112), control2: CGPoint(x: cx - 13, y: -124))
        edge.addCurve(to: CGPoint(x: w - 15, y: -95), control1: CGPoint(x: cx + 13, y: -124), control2: CGPoint(x: w - 12, y: -112))
        edge.addQuadCurve(to: CGPoint(x: w, y: -h), control: CGPoint(x: w - 15, y: -h - 3))
        var bell = edge
        bell.closeSubpath()
        pen.fill(bell, .wall)
        pen.line(edge, .accent, width: 3)
        pen.rect(-1.5, -h - 1.5, w + 3, 3.5, .accent)
        pen.rect(0, -5, w, 5, .accent)
        // Ground floor: a wide window with half-lowered white blinds, the door on the right.
        pen.rect(5, -31, 36, 22, .lit)
        pen.rect(5, -31, 36, 9, .white)
        var slats = Path()
        for y in [-28.0, -25] {
            slats.move(to: CGPoint(x: 5, y: y))
            slats.addLine(to: CGPoint(x: 41, y: y))
        }
        pen.line(slats, .color(0xBFC8C6), width: 0.8)
        pen.line(Path(CGRect(x: 5, y: -31, width: 36, height: 22)), .trim, width: 2.4)
        pen.rect(3.5, -9, 39, 2.4, .trim)
        pen.poly([(47, -34), (65, -34), (67, -30), (45, -30)], .accent)
        pen.door(cx: 56, w: 16, h: 28)
        pen.pottedTree(x: 73, h: 22)
        // Upper floor windows; the tooth plaque in the gable.
        pen.windows(in: CGRect(x: 0, y: -h + 2, width: w, height: 32), cols: 3, rows: 1, w: 13, h: 20, seed: 33)
        let plaque = CGRect(x: cx - 15, y: -112, width: 30, height: 30)
        pen.oval(plaque.minX, plaque.minY, plaque.width, plaque.height, .accent)
        pen.line(Path(ellipseIn: plaque.insetBy(dx: 2.5, dy: 2.5)), .white, width: 1.4)
        pen.fill(tooth(cx: plaque.midX, cy: plaque.midY + 0.5, s: 9.5), .white)
        pen.fill(sparkle(cx: plaque.midX + 9, cy: plaque.midY - 8.5, r: 3.6), .white)
        // The board hangs off the left corner: the right side is close to the place in front.
        pen.art.signAt = CGPoint(x: -46, y: -84)
        pen.art.sign = "face.smiling.inverse"
        return pen.art
    }

    /// De dierenarts: a green practice with a big white paw-print plaque, a ginger cat in the window
    /// and a dog waiting by the door with its water bowl.
    private static func dierenarts() -> KaartLandmark {
        var pen = KaartPen(wall: 0x4E8A5A, roof: 0x5B3328, door: 0xEFE6D6, accent: 0xF4F1EA)
        let w = 92.0, h = 70.0
        let front = pen.box(x: 0, w: w, h: h)
        pen.ridgeRoof(over: front, rise: 25)
        pen.rect(0, -38, w, 3, .trim)
        pen.rect(0, -5, w, 5, .color(0x3A6B45))
        // Upper floor: windows either side of the paw plaque.
        pen.windows(in: CGRect(x: 0, y: -70, width: 30, height: 32), cols: 1, rows: 1, w: 14, h: 20, seed: 34)
        pen.windows(in: CGRect(x: 62, y: -70, width: 30, height: 32), cols: 1, rows: 1, w: 14, h: 20, seed: 35)
        pen.oval(31, -69, 30, 30, .accent)
        pen.line(Path(ellipseIn: CGRect(x: 33, y: -67, width: 26, height: 26)), .color(0x3A6B45), width: 1.2)
        pen.fill(paw(cx: 46, cy: -54, s: 10), .color(0x3A6B45))
        // Ground floor: a big window with a ginger cat on the sill, the door on the right.
        pen.rect(6, -31, 44, 24, .lit)
        pen.line(Path(CGRect(x: 6, y: -31, width: 44, height: 24)), .trim, width: 2.4)
        pen.line(KaartPen.polygonLine([(28, -31), (28, -7)]), .trim, width: 1.6)
        pen.rect(4.5, -7, 47, 2.4, .trim)
        pen.cat(x: 36, y: -7, color: 0xE08A3C)
        pen.door(cx: 66, w: 16, h: 28)
        // The dog by the door, with its bowl.
        pen.dog(x: 76, color: 0xC08A4E)
        pen.poly([(93, -3.5), (100, -3.5), (99, 0), (94, 0)], .color(0x3D6E9E))
        pen.art.signAt = CGPoint(x: w + 2, y: -96)
        pen.art.sign = "pawprint.fill"
        return pen.art
    }

    /// De belastingdienst: a tall grey-blue government block with rows and rows of windows between
    /// concrete fins, a glass entrance hall under a canopy and a flag on the roof.
    private static func belastingdienst() -> KaartLandmark {
        var pen = KaartPen(wall: 0x7D8E9C, roof: 0x4A535C, door: 0x1E1E1C, accent: 0x1F3A6B)
        let w = 116.0, h = 184.0, depth = 36.0
        pen.box(x: 0, w: w, h: h, depth: depth)
        // Six storeys of windows between pale concrete fins.
        let grid = CGRect(x: 2, y: -h + 8, width: w - 4, height: h - 60)
        var fins = Path()
        for i in 0...6 {
            let x = 2 + 112.0 / 7 * Double(i) - 1 + (i == 0 ? 2 : 0) - (i == 6 ? 2 : 0)
            fins.addRect(CGRect(x: x, y: grid.minY - 2, width: 2.4, height: grid.height + 4))
        }
        pen.fill(fins, .color(0xA9B6C0))
        pen.windows(in: grid, cols: 6, rows: 6, w: 10, h: 13, seed: 39)
        for i in 0..<5 {
            pen.sidePatch(w: w, d0: 8, d1: 16, top: grid.minY + 6 + Double(i) * 24, bottom: grid.minY + 18 + Double(i) * 24, .glass)
            pen.sidePatch(w: w, d0: 22, d1: 30, top: grid.minY + 6 + Double(i) * 24, bottom: grid.minY + 18 + Double(i) * 24, .glass)
        }
        pen.rect(-1.5, -h - 1, w + 3, 5, .color(0x5B6973))
        // The entrance hall: one big glass wall under a canopy.
        pen.rect(0, -52, w, 6, .color(0x5B6973))
        pen.rect(12, -40, 92, 37, .lit)
        var mullions = Path(CGRect(x: 12, y: -40, width: 92, height: 37))
        for x in [35.0, 81] {
            mullions.move(to: CGPoint(x: x, y: -40))
            mullions.addLine(to: CGPoint(x: x, y: -3))
        }
        pen.line(mullions, .ink, width: 1.6)
        pen.door(cx: 58, w: 22, h: 30)
        pen.rect(57.2, -30, 1.6, 30, .trim)
        pen.poly([(4, -44), (112, -44), (116, -40), (0, -40)], .color(0x4A535C))
        pen.flag(x: 30, y: -h - 10, height: 32)
        pen.box(x: 74, w: 24, h: 10, depth: 12, base: -h - 10, paint: .color(0x9AA8B3), top: .roof)
        pen.art.signAt = CGPoint(x: w + 2, y: -104)
        pen.art.sign = "doc.text.fill"
        return pen.art
    }

    /// De notaris: a stately brick town house with a cream cornice and corner stones, a slate roof
    /// with dormers, a stoop up to a dark door between columns and a brass name plate.
    private static func notaris() -> KaartLandmark {
        var pen = KaartPen(wall: 0x6E3A2C, roof: 0x45505A, door: 0x1E3A2C, accent: 0xC9A15B)
        let w = 96.0, h = 116.0
        let front = pen.box(x: 0, w: w, h: h)
        pen.ridgeRoof(over: front, rise: 34)
        for x in [30.0, 66] {
            pen.rect(x - 7, -137, 14, 14, .trim)
            pen.rect(x - 4, -134, 8, 11, .glass)
            pen.poly([(x - 9.5, -136), (x, -145), (x + 9.5, -136)], .roof)
        }
        pen.rect(-3, -h - 2, w + 6, 7, .trim)
        // Cream corner stones and a stone basement.
        var quoins = Path()
        for i in 0..<8 {
            let y = -h + 6 + Double(i) * 13.5, wide = i % 2 == 0
            quoins.addRect(CGRect(x: 0, y: y, width: wide ? 9 : 6, height: 6.5))
            quoins.addRect(CGRect(x: w - (wide ? 9 : 6), y: y, width: wide ? 9 : 6, height: 6.5))
        }
        pen.fill(quoins, .trim)
        pen.rect(0, -12, w, 12, .color(0x8A8270))
        pen.windows(in: CGRect(x: 0, y: -h + 2, width: w, height: 58), cols: 3, rows: 2, w: 14, h: 22, seed: 40)
        pen.windows(in: CGRect(x: 2, y: -48, width: 22, height: 36), cols: 1, rows: 1, w: 13, h: 24, seed: 41)
        pen.windows(in: CGRect(x: 72, y: -48, width: 22, height: 36), cols: 1, rows: 1, w: 13, h: 24, seed: 42)
        // The stoop, the columned door and the brass plate.
        pen.rect(30, -4, 36, 4, .trim)
        pen.rect(32.5, -7.5, 31, 3.5, .trim)
        pen.rect(35, -11, 26, 3.5, .trim)
        pen.line(KaartPen.polygonLine([(29, 0), (29, -9), (34, -14)]), .ink, width: 1.2)
        pen.line(KaartPen.polygonLine([(67, 0), (67, -9), (62, -14)]), .ink, width: 1.2)
        pen.door(cx: 48, w: 18, h: 30, base: -11, arched: true)
        pen.columns(from: 33, to: 63, count: 2, base: -11, h: 31)
        pen.pediment(x: 22, w: 52, y: -49, rise: 9)
        pen.rect(66.5, -32, 6, 5, .accent)
        pen.line(Path(CGRect(x: 66.5, y: -32, width: 6, height: 5)), .ink, width: 0.6)
        pen.art.signAt = CGPoint(x: w + 2, y: -88)
        pen.art.sign = "signature"
        return pen.art
    }

    /// De verzekeraar: a slate-blue office with white window bands, a stone entrance and a big
    /// red-and-white umbrella standing on its roof.
    private static func verzekeraar() -> KaartLandmark {
        var pen = KaartPen(wall: 0x5E6B73, roof: 0x3A4148, door: 0x2C2C2A, awning: 0xC8261B, accent: 0xEFE6D6)
        let w = 84.0, h = 108.0
        pen.box(x: 0, w: w, h: h)
        pen.rect(-1.5, -h - 1, w + 3, 5, .trim)
        for y in [-42.0, -75] {
            pen.rect(0, y, w, 3, .trim)
            pen.sidePatch(w: w, d0: 0, d1: 30, top: y, bottom: y + 3, .darker(0xEFEBE2))
        }
        pen.windows(in: CGRect(x: 0, y: -h + 4, width: w, height: 66), cols: 3, rows: 2, w: 14, h: 21, seed: 41)
        pen.windows(in: CGRect(x: 0, y: -40, width: 28, height: 34), cols: 1, rows: 1, w: 15, h: 21, seed: 43)
        pen.windows(in: CGRect(x: 56, y: -40, width: 28, height: 34), cols: 1, rows: 1, w: 15, h: 21, seed: 44)
        // Stone door surround with a red canopy.
        pen.rect(31, -36, 22, 36, .trim)
        pen.door(cx: 42, w: 14, h: 28)
        pen.awning(x: 29, y: -40, w: 26, drop: 7)
        // The umbrella on the roof.
        let cx = 42.0 + 15, rim = -h - 8.5 - 26
        pen.line(KaartPen.polygonLine([(cx - 14, -h - 8), (cx - 14, rim + 4)]), .ink, width: 1.4)
        pen.line(KaartPen.polygonLine([(cx + 14, -h - 8), (cx + 14, rim + 4)]), .ink, width: 1.4)
        var shaft = Path()
        shaft.move(to: CGPoint(x: cx, y: rim - 22))
        shaft.addLine(to: CGPoint(x: cx, y: rim + 14))
        shaft.addQuadCurve(to: CGPoint(x: cx + 7, y: rim + 14), control: CGPoint(x: cx + 3.5, y: rim + 19))
        pen.line(shaft, .ink, width: 2.2)
        umbrella(&pen, cx: cx, rim: rim, r: 28)
        pen.art.signAt = CGPoint(x: w + 2, y: -86)
        pen.art.sign = "umbrella.fill"
        return pen.art
    }

    /// De krantenkiosk: a little green eight-sided Amsterdam kiosk with a curved roof and gold
    /// finial, a serving hatch, papers and magazines on display and a rack of newspapers outside.
    private static func krantenkiosk() -> KaartLandmark {
        var pen = KaartPen(wall: 0x2F5E46, roof: 0x24453A, door: 0x24453A, accent: 0xC8261B)
        let body = 58.0
        // Three faces of the octagon: left (lit), front, right (shaded).
        pen.poly([(0, -3.5), (13, 0), (13, -body), (0, -body - 3.5)], .wall)
        pen.rect(13, -body, 36, body, .wall)
        pen.poly([(49, 0), (63, -4.5), (63, -body - 4.5), (49, -body)], .side)
        pen.art.front = CGRect(x: 0, y: -body - 4.5, width: 63, height: body + 4.5)
        // Cream corner posts, plinth and crown.
        var posts = Path()
        for (x, dy) in [(11.5, 0.0), (47.5, 0)] { posts.addRect(CGRect(x: x, y: -body + dy, width: 3, height: body)) }
        pen.fill(posts, .trim)
        pen.poly([(0, -3.5), (13, 0), (49, 0), (63, -4.5), (63, -10.5), (49, -6), (13, -6), (0, -9.5)], .color(0x1E3A2C))
        pen.poly([(-2, -body - 3), (13, -body + 0.5), (49, -body + 0.5), (65, -body - 4), (65, -body - 11), (49, -body - 6.5), (13, -body - 6.5), (-2, -body - 10)], .trim)
        // Roof: a curved dome in two halves, with a gold finial.
        let top = -body - 7.0, peak = -body - 42.0
        var left = Path()
        left.move(to: CGPoint(x: -5, y: top - 3))
        left.addQuadCurve(to: CGPoint(x: 31, y: peak), control: CGPoint(x: 16, y: top - 8))
        left.addLine(to: CGPoint(x: 31, y: top))
        left.addLine(to: CGPoint(x: 13, y: top))
        left.closeSubpath()
        pen.fill(left, .roof)
        var right = Path()
        right.move(to: CGPoint(x: 31, y: peak))
        right.addQuadCurve(to: CGPoint(x: 67, y: top - 4), control: CGPoint(x: 46, y: top - 8))
        right.addLine(to: CGPoint(x: 49, y: top))
        right.addLine(to: CGPoint(x: 31, y: top))
        right.closeSubpath()
        pen.fill(right, .roofSide)
        pen.rect(30.3, peak - 9, 1.4, 10, .ink)
        pen.oval(27.5, peak - 6, 7, 7, .color(0xC9A15B))
        // Serving hatch and counter, papers below.
        pen.rect(17, -48, 28, 20, .lit)
        pen.line(Path(CGRect(x: 17, y: -48, width: 28, height: 20)), .trim, width: 2)
        pen.rect(15, -28, 32, 3, .trim)
        for i in 0..<3 {
            let x = 16.5 + Double(i) * 10.5
            pen.rect(x, -23, 8.5, 12, .white)
            pen.rect(x + 1, -21.5, 6.5, 2.2, .accent)
            pen.rect(x + 1, -18, 6.5, 0.9, .color(0x8A8F9E))
            pen.rect(x + 1, -16, 4.5, 0.9, .color(0x8A8F9E))
        }
        // Magazines on the left face, a door on the right face.
        let mags: [UInt32] = [0xF2B544, 0x2F6FA8, 0xC8261B, 0xF4F1EA, 0x7FA36B, 0xF2711C]
        for (i, c) in mags.enumerated() {
            let x = 2 + Double(i % 2) * 5, y = -46 + Double(i / 2) * 11
            pen.rect(x, y + Double(i % 2) * 1.2, 4, 9, .color(c))
        }
        pen.door(cx: 56, w: 9, h: 34, base: -2)
        // The newspaper rack outside, right of the door.
        pen.rect(67, -20, 1.2, 20, .ink)
        pen.rect(80, -20, 1.2, 20, .ink)
        for (i, y) in [-20.0, -12].enumerated() {
            pen.rect(66, y + 6, 16, 1.4, .ink)
            for j in 0..<2 {
                let x = 67.5 + Double(j) * 6.5
                pen.rect(x, y, 5.5, 7, .white)
                pen.rect(x + 0.8, y + 1, 3.9, 1.6, (i + j) % 2 == 0 ? .accent : .color(0x2F6FA8))
            }
        }
        // A kiosk is small, but it is a place: drawn a size up. The board hangs off the left face.
        var art = scaled(pen.art, 1.25)
        art.signAt = CGPoint(x: -46, y: -98)
        art.sign = "newspaper.fill"
        return art
    }

    /// Het buurthuis: a long, low, friendly hall with a rainbow mural, bunting along the eaves, big
    /// windows, a bench in front of the mural and flower pots by the door.
    private static func buurthuis() -> KaartLandmark {
        var pen = KaartPen(wall: 0xEADFC8, roof: 0xB5532F, door: 0x2F6FA8, accent: 0xF2B544)
        let w = 136.0, h = 54.0
        let front = pen.box(x: 0, w: w, h: h)
        pen.ridgeRoof(over: front, rise: 26)
        // The mural: sky, sun, rainbow and a green hill with flowers.
        let mural = CGRect(x: 5, y: -47, width: 54, height: 40)
        pen.rect(mural.minX, mural.minY, mural.width, mural.height, .color(0x9FCFE0))
        pen.oval(41, -44, 12, 12, .color(0xF6C445))
        for (i, c) in [UInt32(0xC8261B), 0xF2711C, 0xF2B544, 0x5E8C45, 0x2F6FA8].enumerated() {
            var arc = Path()
            arc.addArc(center: CGPoint(x: 26, y: -9), radius: 22 - Double(i) * 3.4, startAngle: .degrees(180), endAngle: .degrees(360), clockwise: false)
            pen.line(arc, .color(c), width: 3.2)
        }
        var hill = Path()
        hill.move(to: CGPoint(x: mural.minX, y: mural.maxY))
        hill.addLine(to: CGPoint(x: mural.minX, y: -17))
        hill.addQuadCurve(to: CGPoint(x: mural.maxX, y: -13), control: CGPoint(x: 34, y: -30))
        hill.addLine(to: CGPoint(x: mural.maxX, y: mural.maxY))
        hill.closeSubpath()
        pen.fill(hill, .color(0x7FB069))
        for (x, y) in [(12.0, -14.0), (22, -18), (46, -17), (53, -13)] { pen.oval(x, y, 3, 3, .bloom) }
        pen.line(Path(mural), .trim, width: 2)
        // Windows and the double door.
        pen.windows(in: CGRect(x: 62, y: -48, width: 24, height: 40), cols: 1, rows: 1, w: 18, h: 26, seed: 51)
        pen.windows(in: CGRect(x: 112, y: -48, width: 24, height: 40), cols: 1, rows: 1, w: 18, h: 26, seed: 52)
        pen.door(cx: 99, w: 20, h: 30)
        pen.rect(98.2, -30, 1.6, 30, .trim)
        // Bunting along the eaves.
        pen.bunting(from: CGPoint(x: -3, y: -h), to: CGPoint(x: w / 2, y: -h), sag: 6)
        pen.bunting(from: CGPoint(x: w / 2, y: -h), to: CGPoint(x: w + 3, y: -h), sag: 6)
        // A bench in front of the mural and pots by the door.
        pen.bench(x: 16, w: 28)
        pen.flowerPot(x: 82)
        pen.flowerPot(x: 109)
        pen.art.signAt = CGPoint(x: w + 2, y: -70)
        pen.art.sign = "person.3.fill"
        return pen.art
    }

    // MARK: Shapes

    /// The same drawing `k` times bigger, still standing on the ground line at y = 0.
    private static func scaled(_ art: KaartLandmark, _ k: Double) -> KaartLandmark {
        let t = CGAffineTransform(scaleX: k, y: k)
        var out = art
        out.layers = art.layers.map { KaartLayer(path: $0.path.applying(t), paint: $0.paint, line: $0.line.map { $0 * k }) }
        out.front = art.front.applying(t)
        out.doorRect = art.doorRect.applying(t)
        out.signAt = art.signAt?.applying(t)
        return out
    }

    /// A rounded speech bubble with a little tail at the bottom left or right.
    private static func speechBubble(_ r: CGRect, tailLeft: Bool) -> Path {
        var p = Path(roundedRect: r, cornerRadius: r.height * 0.45)
        let x = tailLeft ? r.minX + r.width * 0.22 : r.maxX - r.width * 0.22
        let tip = tailLeft ? x - 6 : x + 6
        p.addPath(KaartPen.polygon([(x - 3.5, r.maxY - 1), (tip, r.maxY + 6), (x + 3.5, r.maxY - 1)]))
        return p
    }

    /// A molar: two bumps on top, two roots below; `s` is half its width.
    private static func tooth(cx: Double, cy: Double, s: Double) -> Path {
        func p(_ x: Double, _ y: Double) -> CGPoint { CGPoint(x: cx + x * s, y: cy + y * s) }
        var t = Path()
        t.move(to: p(-1, -0.45))
        t.addQuadCurve(to: p(0, -0.72), control: p(-0.85, -1.2))
        t.addQuadCurve(to: p(1, -0.45), control: p(0.85, -1.2))
        t.addQuadCurve(to: p(0.6, 1.05), control: p(1.08, 0.35))
        t.addQuadCurve(to: p(0.16, 0.3), control: p(0.3, 1.0))
        t.addQuadCurve(to: p(-0.16, 0.3), control: p(0, 0.12))
        t.addQuadCurve(to: p(-0.6, 1.05), control: p(-0.3, 1.0))
        t.addQuadCurve(to: p(-1, -0.45), control: p(-1.08, 0.35))
        t.closeSubpath()
        return t
    }

    /// A four-pointed sparkle.
    private static func sparkle(cx: Double, cy: Double, r: Double) -> Path {
        let k = r * 0.28
        return KaartPen.polygon([(cx, cy - r), (cx + k, cy - k), (cx + r, cy), (cx + k, cy + k), (cx, cy + r), (cx - k, cy + k), (cx - r, cy), (cx - k, cy - k)])
    }

    /// A paw print: one big pad and four toes; `s` is about half its width.
    private static func paw(cx: Double, cy: Double, s: Double) -> Path {
        var p = Path()
        p.addEllipse(in: CGRect(x: cx - 0.6 * s, y: cy - 0.05 * s, width: 1.2 * s, height: 0.95 * s))
        for (x, y) in [(-0.95, -0.35), (-0.4, -0.85), (0.4, -0.85), (0.95, -0.35)] {
            p.addEllipse(in: CGRect(x: cx + (x - 0.21) * s, y: cy + (y - 0.27) * s, width: 0.42 * s, height: 0.54 * s))
        }
        return p
    }

    /// A red-and-white umbrella canopy with a scalloped rim at `rim`, `r` wide each side of `cx`.
    private static func umbrella(_ pen: inout KaartPen, cx: Double, rim: Double, r: Double) {
        let parts = 4, step = 2 * r / Double(parts)
        var canopy = Path()
        canopy.move(to: CGPoint(x: cx - r, y: rim))
        canopy.addQuadCurve(to: CGPoint(x: cx + r, y: rim), control: CGPoint(x: cx, y: rim - r * 1.45))
        for i in 0..<parts {
            let x0 = cx + r - Double(i) * step
            canopy.addQuadCurve(to: CGPoint(x: x0 - step, y: rim), control: CGPoint(x: x0 - step / 2, y: rim - 5))
        }
        canopy.closeSubpath()
        pen.fill(canopy, .awning)
        // White panels between the ribs: the second one, and the outer one on the right.
        let apex = rim - r * 0.72
        let panels = [
            KaartPen.polygon([(cx, apex), (cx - step - 1, rim + 3), (cx, rim + 3)]),
            KaartPen.polygon([(cx, apex), (cx + step + 1, rim + 3), (cx + 2 * r, rim + 3), (cx + 2 * r, apex - 10), (cx, apex - 10)]),
        ]
        for panel in panels { pen.fill(panel.intersection(canopy), .white) }
        pen.line(canopy, .ink, width: 0.8)
        pen.oval(cx - 2, apex - 5, 4, 4, .ink)
    }
}

// MARK: - Props

nonisolated private extension KaartPen {
    /// A patch on the right side wall of a box `w` wide, from depth d0 to d1; `top` and `bottom`
    /// are the heights where the patch meets the front corner.
    mutating func sidePatch(w: Double, d0: Double, d1: Double, top: Double, bottom: Double, _ paint: KaartPaint) {
        let s = Self.slope
        poly([(w + d0, bottom - d0 * s), (w + d1, bottom - d1 * s), (w + d1, top - d1 * s), (w + d0, top - d0 * s)], paint)
    }

    /// A patch on the flat top of a box whose front top edge is at y `top`, from depth d0 to d1.
    mutating func topPatch(x: Double, w: Double, d0: Double, d1: Double, top: Double, _ paint: KaartPaint) {
        let s = Self.slope
        poly([(x + d0, top - d0 * s), (x + w + d0, top - d0 * s), (x + w + d1, top - d1 * s), (x + d1, top - d1 * s)], paint)
    }

    /// A parked bike, rear wheel at x, about 26 × 16.
    mutating func bike(x: Double, color: UInt32, k: Double = 1.1) {
        let t = CGAffineTransform(a: k, b: 0, c: 0, d: k, tx: x, ty: -14.2 * k)
        line(KaartArt.bikeWheels.applying(t), .ink, width: 1.7)
        line(KaartArt.bikeFrame.applying(t), .color(color), width: 2.2)
    }

    /// A terrace chair seen from the side.
    mutating func chair(cx: Double, facingRight: Bool) {
        let wood: KaartPaint = .color(0x6B4A2E)
        rect(cx - 4, -10, 1.4, 10, .ink)
        rect(cx + 2.6, -10, 1.4, 10, .ink)
        rect(cx - 4.5, -11.5, 9, 2.4, wood)
        rect(facingRight ? cx - 4.5 : cx + 2.7, -22, 1.8, 11, wood)
    }

    /// A white police car with a blue stripe and a blue light on the roof, about 48 long.
    mutating func policeCar(x: Double) {
        let white: KaartPaint = .color(0xF4F1EA)
        rect(x + 21, -27, 8, 3.5, .accent)
        poly([(x + 9, -14), (x + 15, -24), (x + 34, -24), (x + 40, -14)], white)
        fill(Path(roundedRect: CGRect(x: x, y: -16, width: 48, height: 11), cornerRadius: 3.5), white)
        poly([(x + 12, -15), (x + 16.5, -22), (x + 23.5, -22), (x + 23.5, -15)], .color(0x3E4C55))
        poly([(x + 25.5, -15), (x + 25.5, -22), (x + 33, -22), (x + 37.5, -15)], .color(0x3E4C55))
        rect(x, -12.5, 48, 4, .color(0x1F3A6B))
        rect(x, -8.5, 48, 1.4, .color(0xF2711C))
        for wx in [x + 6, x + 33] {
            oval(wx, -9.5, 9.5, 9.5, .ink)
            oval(wx + 3, -6.5, 3.5, 3.5, .trim)
        }
    }

    /// A wooden park bench, `w` wide.
    mutating func bench(x: Double, w: Double = 26) {
        let wood: KaartPaint = .color(0x8A5A32)
        for lx in [x + 2, x + w - 3.8] {
            rect(lx, -18, 1.8, 18, .ink)
        }
        rect(x, -18, w, 2.4, wood)
        rect(x, -14.2, w, 2.2, wood)
        rect(x - 1, -9.5, w + 2, 2.8, wood)
    }

    /// A terracotta pot with a flowering bush.
    mutating func flowerPot(x: Double, w: Double = 9) {
        poly([(x, -8), (x + w, -8), (x + w - 1.5, 0), (x + 1.5, 0)], .color(0xB5532F))
        oval(x - 1.5, -15, w + 3, 9, .plant)
        for (dx, dy) in [(0.5, -14.0), (w - 3.5, -15), (w / 2 - 1.5, -12)] { oval(x + dx, dy, 3, 3, .bloom) }
    }

    /// A string of warm bulbs hanging between two points.
    mutating func stringLights(from a: CGPoint, to b: CGPoint, sag: Double, bulbs: Int) {
        let c = CGPoint(x: (a.x + b.x) / 2, y: max(a.y, b.y) + sag)
        var wire = Path()
        wire.move(to: a)
        wire.addQuadCurve(to: b, control: c)
        line(wire, .ink, width: 0.8)
        var dots = Path()
        for q in Self.along(a, c, b, count: bulbs) {
            dots.addEllipse(in: CGRect(x: q.x - 1.8, y: q.y - 0.4, width: 3.6, height: 3.6))
        }
        fill(dots, .color(0xF6D27A))
    }

    /// A line of little triangle flags hanging between two points.
    mutating func bunting(from a: CGPoint, to b: CGPoint, sag: Double) {
        let c = CGPoint(x: (a.x + b.x) / 2, y: max(a.y, b.y) + sag)
        var wire = Path()
        wire.move(to: a)
        wire.addQuadCurve(to: b, control: c)
        line(wire, .ink, width: 0.7)
        let colors: [UInt32] = [0xC8261B, 0xF2B544, 0x2F6FA8, 0x5E8C45, 0xF2711C]
        let count = Int((b.x - a.x) / 8)
        for (i, q) in Self.along(a, c, b, count: count).enumerated() {
            poly([(q.x - 3, q.y), (q.x + 3, q.y), (q.x, q.y + 7)], .color(colors[i % colors.count]))
        }
    }

    /// `count` points spread along a quadratic curve, ends excluded.
    static func along(_ a: CGPoint, _ c: CGPoint, _ b: CGPoint, count: Int) -> [CGPoint] {
        (1...max(1, count)).map { i in
            let t = Double(i) / Double(count + 1), u = 1 - t
            return CGPoint(x: u * u * a.x + 2 * u * t * c.x + t * t * b.x, y: u * u * a.y + 2 * u * t * c.y + t * t * b.y)
        }
    }

    /// A ginger cat sitting on a sill at (x, y), facing left.
    mutating func cat(x: Double, y: Double, color: UInt32) {
        oval(x + 1, y - 9, 8, 9, .color(color))
        oval(x - 1, y - 14, 7, 6.5, .color(color))
        poly([(x - 0.6, y - 12), (x, y - 16.5), (x + 2.2, y - 13.4)], .color(color))
        poly([(x + 3, y - 13.6), (x + 5, y - 16.5), (x + 5.8, y - 12)], .color(color))
        var tail = Path()
        tail.move(to: CGPoint(x: x + 8.5, y: y - 1.5))
        tail.addQuadCurve(to: CGPoint(x: x + 11, y: y - 9), control: CGPoint(x: x + 13, y: y - 2))
        line(tail, .color(color), width: 1.8)
    }

    /// A dog sitting on the ground at x, facing left, with a red collar.
    mutating func dog(x: Double, color: UInt32) {
        var tail = Path()
        tail.move(to: CGPoint(x: x + 14, y: -3))
        tail.addQuadCurve(to: CGPoint(x: x + 18, y: -11), control: CGPoint(x: x + 19.5, y: -4))
        line(tail, .color(color), width: 2.4)
        oval(x + 5, -13, 11, 13, .color(color))
        poly([(x + 3, -6), (x + 3.5, -17), (x + 9.5, -18), (x + 10, -6)], .color(color))
        rect(x + 3.2, -8, 2.4, 8, .color(color))
        rect(x + 6.6, -8, 2.4, 8, .color(color))
        oval(x + 1.5, -24, 9.5, 8.5, .color(color))
        oval(x - 2.5, -20.5, 6, 4.4, .color(color))
        oval(x + 6, -23.5, 4, 8, .darker(color))
        rect(x + 3.2, -17.6, 6.6, 1.8, .color(0xC8261B))
        oval(x - 2.8, -20.6, 2.2, 2, .ink)
        oval(x + 3.6, -21.6, 1.6, 1.6, .ink)
    }
}
