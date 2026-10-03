import SwiftUI

/// Places of work and making: DIY store, thrift shop, energy company, garage, fire station,
/// concert hall, gallery, studio, start-up.
nonisolated extension KaartLandmarks {
    static func work(_ n: Int) -> KaartLandmark? {
        switch n {
        case 37: bouwmarkt()
        case 38: kringloopwinkel()
        case 42: energiebedrijf()
        case 43: garage()
        case 53: brandweer()
        case 55: concertzaal()
        case 56: galerie()
        case 57: studio()
        case 58: startup()
        default: nil
        }
    }

    /// De bouwmarkt: a long steel shed with an orange band and entrance, planks leaning outside and a stack of paint tins.
    private static func bouwmarkt() -> KaartLandmark {
        var pen = KaartPen(wall: 0x7E8C94, roof: 0x4C565D, door: 0x2C2C2A, awning: 0xF2711C, accent: 0xF2711C)
        let shed = pen.box(x: 0, w: 130, h: 62, depth: 34)
        gableRoof(&pen, over: shed, rise: 24, depth: 34, overhang: 4)
        // Corrugated steel: thin ribs up to the gable line.
        var ribs = Path()
        for x in stride(from: 6.0, to: 130, by: 6) {
            let top = -62 - 24 * (1 - abs(x - 65) / 65)
            ribs.move(to: CGPoint(x: x, y: -2))
            ribs.addLine(to: CGPoint(x: x, y: top + 2))
        }
        pen.line(ribs, .darker(0x7E8C94), width: 0.8)
        // The orange band round the top, and a round vent in the gable.
        let rise = 34 * KaartPen.slope
        pen.rect(0, -62, 130, 9, .accent)
        pen.poly([(130, -62), (164, -62 - rise), (164, -53 - rise), (130, -53)], .darker(0xF2711C))
        pen.oval(56, -82, 18, 18, .trim)
        pen.oval(59, -79, 12, 12, .glass)
        // Ribbon windows either side, and the wide orange entrance with sliding doors.
        pen.windows(in: CGRect(x: 2, y: -48, width: 42, height: 22), cols: 2, rows: 1, w: 15, h: 11, seed: 37)
        pen.windows(in: CGRect(x: 86, y: -48, width: 42, height: 22), cols: 2, rows: 1, w: 15, h: 11, seed: 38)
        pen.rect(45, -44, 40, 44, .accent)
        pen.door(cx: 65, w: 32, h: 36, paint: .lit)
        pen.line(KaartPen.polygonLine([(65, -36), (65, 0)]), .trim, width: 1.5)
        // Planks leaning against the wall and a pile on a pallet.
        for (i, x) in [-6.0, 0, 6].enumerated() {
            pen.poly([(x, 0), (x + 5, 0), (x + 15, -54 + Double(i) * 4), (x + 10, -54 + Double(i) * 4)], .color(i == 1 ? 0xC9A15B : 0xDDBB82))
        }
        pen.rect(14, -3, 29, 3, .color(0x8A6A43))
        for i in 0..<4 {
            pen.rect(14 + Double(i % 2) * 2, -6.5 - Double(i) * 3.5, 27, 3.5, .color(i % 2 == 0 ? 0xDDBB82 : 0xC9A15B))
        }
        // Paint tins stacked by the door.
        tin(&pen, x: 90, base: 0, color: 0xC8261B)
        tin(&pen, x: 106, base: 0, color: 0x1F3A6B)
        tin(&pen, x: 98, base: -16, color: 0xE8B83A)
        pen.art.signAt = CGPoint(x: 126, y: -76)
        pen.art.sign = "hammer.fill"
        return pen.art
    }

    /// De kringloopwinkel: a cosy green shop with a striped awning, an old armchair and a standard lamp out front, boxes of stuff by the door.
    private static func kringloopwinkel() -> KaartLandmark {
        var pen = KaartPen(wall: 0x5F8270, roof: 0x5B3328, door: 0x7A1E1E, awning: 0xD9A23A, accent: 0xE8C27A)
        let shop = pen.box(x: 0, w: 88, h: 84, depth: 30)
        gableRoof(&pen, over: shop, rise: 34, overhang: 4)
        pen.oval(36, -106, 16, 16, .trim)
        pen.oval(39, -103, 10, 10, .lit)
        pen.windows(in: CGRect(x: 0, y: -84, width: 88, height: 36), cols: 3, rows: 1, w: 12, h: 18, seed: 38)
        pen.flowerBox(x: 36, y: -53, w: 16)
        // Shop window with a cream frame, a striped awning over it, and the door.
        pen.rect(5, -41, 52, 37, .trim)
        pen.rect(8, -38, 46, 31, .lit)
        pen.line(KaartPen.polygonLine([(31, -38), (31, -7)]), .trim, width: 1.6)
        pen.awning(x: 4, y: -50, w: 54, drop: 10)
        pen.door(cx: 72, w: 16, h: 30)
        // Armchair and standard lamp on the pavement.
        let cx = -22.0
        pen.fill(Path(roundedRect: CGRect(x: cx - 11, y: -28, width: 22, height: 16), cornerRadius: 5), .color(0xC0612F))
        pen.rect(cx - 10, -15, 20, 7, .color(0xD27A45))
        pen.fill(Path(roundedRect: CGRect(x: cx - 14, y: -19, width: 6, height: 13), cornerRadius: 3), .darker(0xC0612F))
        pen.fill(Path(roundedRect: CGRect(x: cx + 8, y: -19, width: 6, height: 13), cornerRadius: 3), .darker(0xC0612F))
        pen.rect(cx - 11, -6, 2.4, 6, .ink)
        pen.rect(cx + 8.6, -6, 2.4, 6, .ink)
        let lx = -42.0
        pen.oval(lx - 5, -2.5, 10, 3, .ink)
        pen.rect(lx - 0.8, -44, 1.6, 42, .ink)
        pen.poly([(lx - 9, -42), (lx + 9, -42), (lx + 6, -54), (lx - 6, -54)], .color(0xE8C27A))
        pen.line(KaartPen.polygonLine([(lx - 9, -41), (lx + 9, -41)]), .color(0xC0612F), width: 1.4)
        // Boxes of stuff, one open with a framed picture sticking out.
        pen.rect(86, -16, 20, 16, .color(0xC49A63))
        pen.rect(107, -12, 11, 12, .color(0xB8895A))
        pen.rect(90, -30, 16, 14, .color(0xB8895A))
        pen.rect(93, -40, 11, 11, .color(0xC9A15B))
        pen.rect(95, -38, 7, 7, .color(0x1F3A6B))
        pen.poly([(90, -30), (84, -36), (88, -37), (94, -30)], .color(0xD6AE78))
        pen.poly([(106, -30), (112, -36), (108, -37), (102, -30)], .color(0xD6AE78))
        var tape = Path()
        tape.addRect(CGRect(x: 95, y: -16, width: 2, height: 16))
        tape.addRect(CGRect(x: 111.5, y: -12, width: 2, height: 12))
        pen.fill(tape, .color(0xE8DCC0))
        pen.art.signAt = CGPoint(x: 88, y: -112)
        pen.art.sign = "arrow.3.trianglepath"
        return pen.art
    }

    /// Het energiebedrijf: a pale modern office with rows of solar panels on the roof, a bolt on the front and a small wind turbine.
    private static func energiebedrijf() -> KaartLandmark {
        var pen = KaartPen(wall: 0xE6E2D6, roof: 0x7A858B, door: 0x24533F, awning: 0x2E7D4F, accent: 0xF2C230)
        pen.box(x: 0, w: 104, h: 80, depth: 34)
        // Solar panels in two rows on the flat roof, tilted to the sun.
        let dx = 34.0, dy = -34 * KaartPen.slope
        for t in [0.12, 0.56] {
            let ox = dx * t, oy = -80 + dy * t
            for (a, b) in [(4.0, 50.0), (54.0, 100.0)] {
                pen.line(KaartPen.polygonLine([(a + ox + 10, oy - 12), (a + ox + 10, oy)]), .ink, width: 1.2)
                pen.line(KaartPen.polygonLine([(b + ox + 8, oy - 12), (b + ox + 8, oy)]), .ink, width: 1.2)
                let panel = [(a + ox, oy), (b + ox, oy), (b + ox + 9, oy - 13), (a + ox + 9, oy - 13)]
                pen.poly(panel, .color(0x23406E))
                var grid = Path()
                for f in [0.25, 0.5, 0.75] {
                    grid.move(to: CGPoint(x: a + ox + (b - a) * f, y: oy))
                    grid.addLine(to: CGPoint(x: a + ox + (b - a) * f + 9, y: oy - 13))
                }
                grid.move(to: CGPoint(x: a + ox + 4.5, y: oy - 6.5))
                grid.addLine(to: CGPoint(x: b + ox + 4.5, y: oy - 6.5))
                pen.line(grid, .color(0x7FA3C9), width: 0.7)
            }
        }
        // Green bands, ribbon windows, the bolt sign and a glass entrance.
        pen.rect(0, -80, 104, 5, .awning)
        pen.rect(0, -44, 104, 4, .awning)
        pen.windows(in: CGRect(x: 24, y: -76, width: 80, height: 32), cols: 4, rows: 1, w: 13, h: 17, seed: 42)
        pen.oval(5, -72, 20, 20, .accent)
        pen.poly([(17, -70), (9, -61), (14.5, -61), (12, -54), (21, -64), (15.5, -64)], .ink)
        pen.windows(in: CGRect(x: 0, y: -40, width: 62, height: 36), cols: 3, rows: 1, w: 13, h: 20, seed: 43)
        pen.rect(66, -40, 30, 4, .awning)
        pen.door(cx: 81, w: 20, h: 32, paint: .lit)
        pen.line(KaartPen.polygonLine([(81, -32), (81, 0)]), .trim, width: 1.4)
        // A small wind turbine beside the building.
        let mx = 152.0, hub = CGPoint(x: 152, y: -118)
        pen.poly([(mx - 3, 0), (mx + 3, 0), (mx + 1.2, -116), (mx - 1.2, -116)], .color(0xF4F2EC))
        pen.fill(Path(roundedRect: CGRect(x: mx - 4, y: -122, width: 12, height: 7), cornerRadius: 3), .color(0xF4F2EC))
        for angle in [-90.0, 30, 150] {
            let a = angle * .pi / 180
            let along = CGPoint(x: cos(a), y: sin(a)), across = CGPoint(x: -sin(a), y: cos(a))
            func p(_ l: Double, _ w: Double) -> (Double, Double) {
                (hub.x + along.x * l + across.x * w, hub.y + along.y * l + across.y * w)
            }
            pen.poly([p(2, -2.6), p(34, -0.8), p(36, 0), p(34, 0.9), p(2, 2)], .color(0xF4F2EC))
        }
        pen.oval(hub.x - 2.5, hub.y - 2.5, 5, 5, .color(0xC9CED1))
        pen.art.signAt = CGPoint(x: 106, y: -82)
        pen.art.sign = "bolt.fill"
        return pen.art
    }

    /// De garage: a white workshop with a blue band and a roll-up door, a little red car in front, tyres and an old petrol pump.
    private static func garage() -> KaartLandmark {
        var pen = KaartPen(wall: 0xEDE8DC, roof: 0x5E6B73, door: 0x1F3A6B, awning: 0x1F3A6B, accent: 0xC8261B)
        pen.box(x: 0, w: 124, h: 64, depth: 30)
        pen.rect(0, -64, 124, 11, .awning)
        pen.rect(0, -53, 124, 2, .trim)
        // The roll-up door: grey slats in a dark frame.
        let bay = CGRect(x: 8, y: -46, width: 62, height: 46)
        pen.rect(bay.minX - 3, bay.minY - 3, bay.width + 6, bay.height + 3, .color(0x4A555C))
        pen.rect(bay.minX, bay.minY, bay.width, bay.height, .color(0xB9C0C4))
        var slats = Path()
        for y in stride(from: bay.minY + 3.5, to: bay.maxY, by: 3.5) {
            slats.move(to: CGPoint(x: bay.minX, y: y))
            slats.addLine(to: CGPoint(x: bay.maxX, y: y))
        }
        pen.line(slats, .color(0x8A9499), width: 0.9)
        // Office: a window and the door under a blue canopy.
        pen.windows(in: CGRect(x: 76, y: -50, width: 48, height: 20), cols: 2, rows: 1, w: 15, h: 12, seed: 43)
        pen.door(cx: 100, w: 16, h: 27)
        pen.rect(88, -33, 24, 4, .awning)
        // A little round red car parked in front of the bay.
        let c = 14.0
        pen.fill(KaartPen.polygon([(c + 8, -16), (c + 14, -28), (c + 33, -28), (c + 42, -16)]), .color(0xC8261B))
        pen.poly([(c + 12, -17), (c + 16, -26), (c + 23, -26), (c + 23, -17)], .color(0xA9CCD8))
        pen.poly([(c + 25, -17), (c + 25, -26), (c + 32, -26), (c + 38, -17)], .color(0xA9CCD8))
        pen.fill(Path(roundedRect: CGRect(x: c, y: -19, width: 50, height: 12), cornerRadius: 5), .color(0xC8261B))
        pen.rect(c + 1, -9, 48, 2.5, .trim)
        pen.oval(c + 45, -16, 4.5, 3.5, .color(0xF6D27A))
        for wx in [c + 7, c + 34] {
            pen.oval(wx, -11, 11, 11, .ink)
            pen.oval(wx + 3.2, -7.8, 4.6, 4.6, .trim)
        }
        // Tyres: a stack and one standing up.
        for i in 0..<3 {
            pen.fill(Path(roundedRect: CGRect(x: 128, y: -7 - Double(i) * 7, width: 22, height: 7), cornerRadius: 3), .color(0x2C2C2A))
        }
        pen.oval(133, -22.5, 12, 3.5, .color(0x55524E))
        pen.oval(148, -20, 20, 20, .color(0x2C2C2A))
        pen.oval(153.5, -14.5, 9, 9, .color(0x8A8F94))
        // An old petrol pump with a round lamp on top.
        let px = -24.0
        pen.rect(px - 2, -3, 18, 3, .color(0x5E6B73))
        pen.fill(Path(roundedRect: CGRect(x: px, y: -32, width: 14, height: 30), cornerRadius: 2), .accent)
        pen.rect(px + 3, -27, 8, 7, .trim)
        pen.oval(px + 1, -45, 12, 12, .color(0xF6EBD0))
        pen.rect(px + 1, -40, 12, 2.5, .color(0xF2711C))
        pen.line(Path { p in
            p.move(to: CGPoint(x: px + 14, y: -22))
            p.addQuadCurve(to: CGPoint(x: px + 16, y: -6), control: CGPoint(x: px + 22, y: -14))
        }, .ink, width: 1.4)
        pen.art.signAt = CGPoint(x: 124, y: -98)
        pen.art.sign = "car.fill"
        return pen.art
    }

    /// De brandweer: a red-brick fire station with white stone bands, two big red doors (a fire engine peeking out of one) and a hose-drying tower.
    private static func brandweer() -> KaartLandmark {
        var pen = KaartPen(wall: 0x8C3A2C, roof: 0x45505A, door: 0xD12A1E, awning: 0xD12A1E, accent: 0xEFE6D6)
        // The tower first, so the hall stands in front of its side wall.
        let tower = pen.box(x: 0, w: 30, h: 156, depth: 22)
        let hallFront = CGRect(x: 30, y: -78, width: 100, height: 78)
        var cover = boxShape(x: 30, w: 100, h: 78, depth: 32)
        cover.addPath(ridgeRoofShape(over: hallFront, rise: 26, depth: 32, overhang: 2))
        hide(&pen, behind: cover)
        let hall = pen.box(x: 30, w: 100, h: 78, depth: 32)
        pen.art.front = hall
        ridgeRoof(&pen, over: hall, rise: 26, depth: 32, overhang: 2)
        // Tower: the open top where the hoses hang to dry, a pyramid roof, slit windows.
        pen.rect(0, -126, 30, 4, .accent)
        pen.rect(5, -150, 20, 22, .color(0x2A2420))
        var hoses = Path()
        for x in [8.5, 13, 17.5, 22] {
            hoses.move(to: CGPoint(x: x, y: -149))
            hoses.addLine(to: CGPoint(x: x, y: -131 + (x == 13 ? 3 : 0)))
        }
        pen.line(hoses, .color(0xE8DCC0), width: 1.8)
        pen.rect(0, -156, 30, 4, .accent)
        pen.spire(cx: 26, base: tower.minY - 5, w: 42, h: 30)
        pen.windows(in: CGRect(x: 0, y: -120, width: 30, height: 74), cols: 1, rows: 2, w: 8, h: 16, arched: true, seed: 53)
        // Hall: white cornice and string course, arched windows upstairs.
        pen.rect(30, -78, 100, 5, .accent)
        pen.rect(30, -50, 100, 4, .accent)
        pen.windows(in: CGRect(x: 30, y: -74, width: 100, height: 24), cols: 4, rows: 1, w: 10, h: 16, arched: true, seed: 54)
        // Two big doors in white stone arches.
        for cx in [59.0, 105.0] {
            pen.fill(KaartPen.window(x: cx - 23, y: -48, w: 46, h: 48, arched: true), .accent)
        }
        pen.door(cx: 105, w: 38, h: 44, arched: true)
        var panels = Path()
        panels.addRect(CGRect(x: 89, y: -22, width: 13, height: 16))
        panels.addRect(CGRect(x: 108, y: -22, width: 13, height: 16))
        pen.line(panels, .color(0x9E1E15), width: 1.2)
        pen.line(KaartPen.polygonLine([(105, -44), (105, 0)]), .color(0x9E1E15), width: 1.4)
        pen.fill(KaartPen.window(x: 40, y: -44, w: 38, h: 44, arched: true), .color(0x2A2420))
        // The fire engine nosing out of the left door.
        pen.fill(Path(roundedRect: CGRect(x: 42, y: -34, width: 34, height: 32), cornerRadius: 3), .color(0xD12A1E))
        pen.rect(45, -32, 28, 11, .color(0xA9CCD8))
        pen.line(KaartPen.polygonLine([(59, -32), (59, -21)]), .color(0xD12A1E), width: 1.4)
        pen.rect(42, -16, 34, 3, .white)
        pen.rect(52, -12, 14, 6, .color(0x3A3A38))
        pen.oval(44, -12, 6, 6, .color(0xF6D27A))
        pen.oval(68, -12, 6, 6, .color(0xF6D27A))
        pen.rect(41, -4, 36, 4, .color(0x9AA3A8))
        pen.fill(Path(roundedRect: CGRect(x: 50, y: -38, width: 18, height: 4), cornerRadius: 2), .color(0x2F6FD8))
        pen.art.signAt = CGPoint(x: -46, y: -114)
        pen.art.sign = "flame.fill"
        return pen.art
    }

    /// De concertzaal: a brick concert hall like the Concertgebouw: white stone trim, tall arched windows, columns and a golden lyre on the gable.
    private static func concertzaal() -> KaartLandmark {
        var pen = KaartPen(wall: 0xA0563C, roof: 0x5F8A7E, door: 0x3E2A1E, awning: 0x7A1E1E, accent: 0xD6A846)
        // Left wing, the tall centre, then the right wing in front of the centre's side wall.
        let left = pen.box(x: 0, w: 28, h: 62, depth: 32)
        hide(&pen, behind: boxShape(x: 28, w: 84, h: 100, depth: 32))
        let centre = pen.box(x: 28, w: 84, h: 100, depth: 32)
        pen.art.front = centre
        gableRoof(&pen, over: centre, rise: 32, depth: 32, overhang: 4)
        hide(&pen, behind: boxShape(x: 112, w: 28, h: 62, depth: 32))
        let right = pen.box(x: 112, w: 28, h: 62, depth: 32)
        for wing in [left, right] {
            pen.rect(wing.minX, -62, 28, 4, .trim)
            pen.windows(in: CGRect(x: wing.minX, y: -58, width: 28, height: 56), cols: 1, rows: 2, w: 10, h: 18, arched: true, seed: Int(wing.minX))
        }
        // The gable: a lunette window and the golden lyre on top.
        var lunette = Path()
        lunette.addArc(center: CGPoint(x: 70, y: -101), radius: 15, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
        lunette.closeSubpath()
        pen.line(lunette, .trim, width: 3)
        pen.fill(lunette, .lit)
        var spokes = Path()
        for a in [225.0, 270, 315] {
            spokes.move(to: CGPoint(x: 70, y: -101))
            spokes.addLine(to: CGPoint(x: 70 + 15 * cos(a * .pi / 180), y: -101 + 15 * sin(a * .pi / 180)))
        }
        pen.line(spokes, .trim, width: 1.4)
        lyre(&pen, cx: 70, base: -133)
        // Tall arched windows upstairs, white stone band, then the columned entrance.
        pen.windows(in: CGRect(x: 28, y: -98, width: 84, height: 50), cols: 3, rows: 1, w: 15, h: 34, arched: true, seed: 55)
        pen.rect(28, -52, 84, 5, .trim)
        pen.door(cx: 70, w: 16, h: 28, arched: true)
        for cx in [47.3, 92.7] {
            pen.fill(KaartPen.window(x: cx - 7, y: -26, w: 14, h: 26, arched: true), .door)
        }
        pen.columns(from: 36, to: 104, count: 4, h: 36)
        pen.rect(26, -2, 88, 2, .trim)
        pen.art.signAt = CGPoint(x: -46, y: -66)
        pen.art.sign = "music.note"
        return pen.art
    }

    /// De galerie: a white minimal box with big windows full of colourful paintings and a red sculpture by the door.
    private static func galerie() -> KaartLandmark {
        var pen = KaartPen(wall: 0xF1EEE7, roof: 0x3A3F44, door: 0x2C2C2A, awning: 0x2C2C2A, accent: 0xC8261B)
        pen.box(x: 0, w: 90, h: 100, depth: 28)
        pen.rect(-3, -101, 96, 4, .ink)
        // Upstairs: one wide window with a portrait and a big abstract.
        pen.rect(8, -92, 74, 34, .lit)
        painting(&pen, CGRect(x: 14, y: -87, width: 20, height: 24), back: 0x2F4B3A)
        pen.oval(19.5, -83, 9, 11, .color(0xE8C4A0))
        pen.poly([(17, -63), (19.5, -72), (28.5, -72), (31, -63)], .color(0x7A1E1E))
        painting(&pen, CGRect(x: 42, y: -86, width: 34, height: 22), back: 0x1F3A6B)
        pen.oval(46, -83, 15, 15, .color(0xF2C230))
        pen.rect(63, -80, 10, 12, .color(0xE0362C))
        // Downstairs: a big window with two more paintings, and the door.
        pen.rect(6, -48, 52, 44, .lit)
        painting(&pen, CGRect(x: 11, y: -42, width: 18, height: 24), back: 0xFFFFFF)
        pen.rect(11, -42, 8, 10, .color(0xE0362C))
        pen.rect(22, -24, 7, 6, .color(0x1F5FAF))
        pen.rect(11, -22, 5, 4, .color(0xF2C230))
        var grid = Path()
        grid.move(to: CGPoint(x: 19, y: -42)); grid.addLine(to: CGPoint(x: 19, y: -18))
        grid.move(to: CGPoint(x: 11, y: -32)); grid.addLine(to: CGPoint(x: 29, y: -32))
        grid.move(to: CGPoint(x: 22, y: -32)); grid.addLine(to: CGPoint(x: 22, y: -18))
        pen.line(grid, .ink, width: 1)
        painting(&pen, CGRect(x: 34, y: -40, width: 19, height: 19), back: 0x3FA39B)
        pen.oval(38, -36, 10, 10, .color(0xF2711C))
        pen.rect(0, -3, 90, 3, .color(0xD9D4C8))
        pen.door(cx: 73, w: 15, h: 34, paint: .lit)
        // A red loop sculpture on a white plinth.
        pen.rect(-24, -16, 14, 16, .color(0xE9E5DC))
        pen.line(Path(ellipseIn: CGRect(x: -27, y: -38, width: 20, height: 20)), .accent, width: 4)
        pen.oval(-15, -24, 7, 7, .color(0x1F5FAF))
        pen.art.signAt = CGPoint(x: 86, y: -88)
        pen.art.sign = "paintpalette.fill"
        return pen.art
    }

    /// De studio: an old brick warehouse turned TV studio: big skylights in the roof, a hoisting beam, a dish, a red on-air lamp and a camera.
    private static func studio() -> KaartLandmark {
        var pen = KaartPen(wall: 0x7B3F2E, roof: 0x3A3F44, door: 0x2F4B3A, awning: 0x2F4B3A, accent: 0xE0362C)
        let hall = pen.box(x: 0, w: 128, h: 80, depth: 34)
        let rise = 46.0
        ridgeRoof(&pen, over: hall, rise: rise, depth: 34, overhang: 3)
        let dx = 34.0, ridgeY = -80 - rise - 34 * KaartPen.slope / 2
        // Skylights on the front slope of the roof.
        func onRoof(_ x: Double, _ u: Double) -> (Double, Double) { (x + u * dx / 2, -80 + u * (ridgeY + 80)) }
        for (a, b) in [(6.0, 36.0), (88.0, 120.0)] {
            pen.poly([onRoof(a - 2, 0.12), onRoof(b + 2, 0.12), onRoof(b + 2, 0.84), onRoof(a - 2, 0.84)], .trim)
            pen.poly([onRoof(a, 0.17), onRoof(b, 0.17), onRoof(b, 0.79), onRoof(a, 0.79)], .lit)
            var bars = Path()
            for x in stride(from: a + (b - a) / 3, to: b - 1, by: (b - a) / 3) {
                let p0 = onRoof(x, 0.17), p1 = onRoof(x, 0.79)
                bars.move(to: CGPoint(x: p0.0, y: p0.1))
                bars.addLine(to: CGPoint(x: p1.0, y: p1.1))
            }
            pen.line(bars, .trim, width: 1.4)
        }
        // A satellite dish on the roof.
        let dish = Path(ellipseIn: CGRect(x: -10, y: -6.5, width: 20, height: 13))
            .applying(CGAffineTransform(rotationAngle: -0.6).concatenating(CGAffineTransform(translationX: 112, y: -128)))
        pen.line(KaartPen.polygonLine([(112, -128), (116, -112)]), .ink, width: 1.6)
        pen.fill(dish, .color(0xEFEBE2))
        pen.line(KaartPen.polygonLine([(112, -128), (104, -138)]), .ink, width: 1.2)
        // The loading dormer with its hoisting beam, rope and hook.
        pen.poly([(48, -78), (48, -118), (64, -136), (80, -118), (80, -78)], .wall)
        pen.line(KaartPen.polygonLine([(45, -116), (64, -139), (83, -116)]), .roof, width: 3.5)
        pen.rect(56, -114, 16, 24, .door)
        pen.line(KaartPen.polygonLine([(64, -114), (64, -90)]), .trim, width: 1.2)
        pen.line(KaartPen.polygonLine([(66, -128), (54, -121)]), .ink, width: 3.5)
        pen.line(KaartPen.polygonLine([(54, -121), (54, -96)]), .ink, width: 0.9)
        pen.line(Path { p in
            p.move(to: CGPoint(x: 54, y: -96))
            p.addQuadCurve(to: CGPoint(x: 57, y: -94), control: CGPoint(x: 54, y: -92))
        }, .ink, width: 1.2)
        // Front: arched warehouse windows, green loading doors, the studio door with the on-air lamp.
        pen.windows(in: CGRect(x: 0, y: -78, width: 50, height: 34), cols: 2, rows: 1, w: 12, h: 18, arched: true, seed: 57)
        pen.windows(in: CGRect(x: 78, y: -78, width: 50, height: 34), cols: 2, rows: 1, w: 12, h: 18, arched: true, seed: 58)
        pen.windows(in: CGRect(x: 0, y: -42, width: 50, height: 40), cols: 2, rows: 1, w: 13, h: 22, arched: true, seed: 59)
        pen.windows(in: CGRect(x: 78, y: -42, width: 50, height: 40), cols: 2, rows: 1, w: 13, h: 22, arched: true, seed: 60)
        pen.rect(55, -76, 18, 26, .door)
        pen.line(KaartPen.polygonLine([(64, -76), (64, -50)]), .trim, width: 1.2)
        pen.rect(52, -50, 24, 2.5, .ink)
        pen.door(cx: 64, w: 24, h: 34, arched: true)
        pen.fill(Path(roundedRect: CGRect(x: 56, y: -43.5, width: 16, height: 6), cornerRadius: 2), .accent)
        // A TV camera on its tripod, pointing at the door.
        let tx = 146.0
        pen.line(KaartPen.polygonLine([(tx - 9, 0), (tx, -18), (tx + 9, 0)]), .ink, width: 1.6)
        pen.line(KaartPen.polygonLine([(tx, -18), (tx, 0)]), .ink, width: 1.4)
        pen.fill(Path(roundedRect: CGRect(x: tx - 9, y: -30, width: 20, height: 11), cornerRadius: 2), .color(0x2C2C2A))
        pen.rect(tx - 15, -28, 6, 7, .color(0x55524E))
        pen.rect(tx - 4, -34, 9, 4, .color(0x55524E))
        pen.oval(tx + 6, -28, 3, 3, .accent)
        pen.art.signAt = CGPoint(x: -46, y: -78)
        pen.art.sign = "video.fill"
        return pen.art
    }

    /// De startup: a silver-framed glass box with a floating upper floor, pink neon strips, plants on the roof and bikes parked underneath.
    private static func startup() -> KaartLandmark {
        var pen = KaartPen(wall: 0xCDD3D5, roof: 0x6E9A4E, door: 0x2C2C2A, awning: 0xFF4FA3, accent: 0x3FD0C9)
        pen.box(x: 0, w: 96, h: 44, depth: 30)
        sidePanes(&pen, x: 96, base: 0, h: 44, depth: 30, count: 2)
        hide(&pen, behind: boxShape(x: -28, w: 124, h: 46, depth: 30, base: -44))
        let upper = pen.box(x: -28, w: 124, h: 46, depth: 30, base: -44)
        sidePanes(&pen, x: 96, base: -44, h: 46, depth: 30, count: 2)
        // Big glass panes in thin silver frames, neon strips top and bottom.
        glassPanes(&pen, x: -24, y: -86, w: 116, h: 36, count: 5)
        glassPanes(&pen, x: 4, y: -40, w: 58, h: 36, count: 2)
        pen.rect(upper.minX, upper.minY, upper.width, 3.5, .awning)
        pen.rect(upper.minX, -47.5, upper.width, 3.5, .accent)
        // Plants: a planter under the upstairs glass and a little garden on the roof.
        pen.rect(-24, -50, 116, 4, .color(0x6B4A2E))
        var leaves = Path()
        for x in stride(from: -22.0, to: 92, by: 7) {
            leaves.addEllipse(in: CGRect(x: x, y: -55, width: 8, height: 7))
        }
        pen.fill(leaves, .plant)
        for (x, d) in [(-12.0, 0.3), (14, 0.65), (44, 0.35), (78, 0.7), (100, 0.4)] {
            let ox = 30 * d, oy = -90 - 30 * KaartPen.slope * d
            pen.oval(x + ox - 7, oy - 11, 14, 12, .plant)
        }
        // The door with a neon frame, a potted plant beside it.
        pen.rect(66, -42, 28, 42, .awning)
        pen.door(cx: 80, w: 20, h: 36, paint: .lit)
        pen.rect(98, -10, 10, 10, .color(0xE9E5DC))
        pen.oval(94, -30, 18, 22, .plant)
        pen.line(KaartPen.polygonLine([(103, -10), (103, -22)]), .ink, width: 1.2)
        // Bikes: one under the floating floor, one against the glass.
        bike(&pen, x: -20, frame: 0x3FD0C9)
        bike(&pen, x: 6, frame: 0xF2C230)
        pen.art.signAt = CGPoint(x: 98, y: -96)
        pen.art.sign = "lightbulb.fill"
        return pen.art
    }

    // MARK: Helpers

    /// Cuts `cover` out of the solid shapes drawn so far. They sit behind it anyway; this keeps
    /// their hidden edges out of the outline the painter draws round everything solid.
    private static func hide(_ pen: inout KaartPen, behind cover: Path) {
        for i in pen.art.layers.indices where pen.art.layers[i].line == nil && pen.art.layers[i].paint.isSurface {
            pen.art.layers[i].path = pen.art.layers[i].path.subtracting(cover)
        }
    }

    /// `KaartPen.ridgeRoof`, cutting away the box top under it first.
    private static func ridgeRoof(_ pen: inout KaartPen, over f: CGRect, rise: Double, depth: Double, overhang: Double) {
        hide(&pen, behind: ridgeRoofShape(over: f, rise: rise, depth: depth, overhang: overhang))
        pen.ridgeRoof(over: f, rise: rise, depth: depth, overhang: overhang)
    }

    /// `KaartPen.gableRoof`, cutting away the box top under it first.
    private static func gableRoof(_ pen: inout KaartPen, over f: CGRect, rise: Double, depth: Double = 30, overhang: Double) {
        let dx = depth, dy = -depth * KaartPen.slope, px = Double(f.midX), py = f.minY - rise
        hide(&pen, behind: KaartPen.polygon([(f.minX, f.minY), (px, py), (px + dx, py + dy), (f.maxX + overhang + dx, f.minY + dy), (f.maxX + overhang, f.minY)]))
        pen.gableRoof(over: f, rise: rise, depth: depth, overhang: overhang)
    }

    /// The shape of `KaartPen.ridgeRoof` over `f`, for `hide`.
    private static func ridgeRoofShape(over f: CGRect, rise: Double, depth: Double, overhang: Double) -> Path {
        let dx = depth, dy = -depth * KaartPen.slope, ridgeY = f.minY - rise + dy / 2
        return KaartPen.polygon([
            (f.minX - overhang, f.minY), (f.maxX + overhang, f.minY), (f.maxX + dx + overhang, f.minY + dy),
            (f.maxX + dx / 2 + overhang, ridgeY), (f.minX + dx / 2 - overhang, ridgeY),
        ])
    }

    /// The whole shape of a `box` (front, side wall and top), for `hide`.
    private static func boxShape(x: Double, w: Double, h: Double, depth: Double = 30, base: Double = 0) -> Path {
        let dx = depth, dy = -depth * KaartPen.slope, y0 = base - h
        return KaartPen.polygon([(x, base), (x + w, base), (x + w + dx, base + dy), (x + w + dx, y0 + dy), (x + dx, y0 + dy), (x, y0)])
    }

    /// A paint tin standing on `base`: coloured body, a cream lid and a white label.
    private static func tin(_ pen: inout KaartPen, x: Double, base: Double, color: UInt32) {
        pen.rect(x, base - 15, 14, 15, .color(color))
        pen.rect(x - 0.8, base - 16, 15.6, 3, .trim)
        pen.rect(x, base - 10, 14, 4.5, .white)
    }

    /// A framed picture: dark frame and its background colour (draw the picture on top).
    private static func painting(_ pen: inout KaartPen, _ r: CGRect, back: UInt32) {
        pen.rect(r.minX - 1.5, r.minY - 1.5, r.width + 3, r.height + 3, .ink)
        pen.rect(r.minX, r.minY, r.width, r.height, .color(back))
    }

    /// The golden lyre on top of the concert hall, foot at (cx, base).
    private static func lyre(_ pen: inout KaartPen, cx: Double, base: Double) {
        pen.rect(cx - 6, base - 3, 12, 3, .accent)
        var arms = Path()
        for s in [-1.0, 1] {
            arms.move(to: CGPoint(x: cx + s * 2, y: base - 3))
            arms.addQuadCurve(to: CGPoint(x: cx + s * 10, y: base - 22), control: CGPoint(x: cx + s * 15, y: base - 8))
            arms.addQuadCurve(to: CGPoint(x: cx + s * 6, y: base - 28), control: CGPoint(x: cx + s * 7, y: base - 27))
        }
        arms.move(to: CGPoint(x: cx - 9, y: base - 20))
        arms.addLine(to: CGPoint(x: cx + 9, y: base - 20))
        pen.line(arms, .accent, width: 3.2)
        var strings = Path()
        for x in [-3.0, 0, 3] {
            strings.move(to: CGPoint(x: cx + x, y: base - 20))
            strings.addLine(to: CGPoint(x: cx + x, y: base - 4))
        }
        pen.line(strings, .accent, width: 0.9)
    }

    /// A row of tall glass panes with thin dark frames between them.
    private static func glassPanes(_ pen: inout KaartPen, x: Double, y: Double, w: Double, h: Double, count: Int) {
        let gap = 3.0
        let pw = (w - gap * Double(count - 1)) / Double(count)
        var glass = Path(), lit = Path()
        for i in 0..<count {
            let pane = Path(CGRect(x: x + Double(i) * (pw + gap), y: y, width: pw, height: h))
            if i % 2 == 0 { lit.addPath(pane) } else { glass.addPath(pane) }
        }
        pen.fill(glass, .glass)
        pen.fill(lit, .lit)
    }

    /// Glass panes on the side wall of a box whose front ends at x.
    private static func sidePanes(_ pen: inout KaartPen, x: Double, base: Double, h: Double, depth: Double, count: Int) {
        let s = KaartPen.slope, m = 4.0, gap = 3.0
        let pw = (depth - gap * Double(count + 1)) / Double(count)
        var glass = Path()
        for i in 0..<count {
            let d0 = gap + Double(i) * (pw + gap), d1 = d0 + pw
            glass.addPath(KaartPen.polygon([(x + d0, base - m - d0 * s), (x + d1, base - m - d1 * s), (x + d1, base - h + m - d1 * s), (x + d0, base - h + m - d0 * s)]))
        }
        pen.fill(glass, .glass)
    }

    /// A parked bike seen from the side, rear wheel centred at x, wheels on the ground.
    private static func bike(_ pen: inout KaartPen, x: Double, frame: UInt32) {
        let r = 6.5
        var wheels = Path()
        wheels.addEllipse(in: CGRect(x: x - r, y: -2 * r, width: 2 * r, height: 2 * r))
        wheels.addEllipse(in: CGRect(x: x + 20 - r, y: -2 * r, width: 2 * r, height: 2 * r))
        pen.line(wheels, .ink, width: 1.8)
        let rear = (x, -r), crank = (x + 9, -r), seat = (x + 6, -r - 10), head = (x + 17, -r - 11), front = (x + 20, -r)
        pen.line(KaartPen.polygonLine([rear, seat, crank, rear]), .color(frame), width: 2)
        pen.line(KaartPen.polygonLine([seat, head, crank]), .color(frame), width: 2)
        pen.line(KaartPen.polygonLine([head, front]), .color(frame), width: 2)
        pen.line(KaartPen.polygonLine([(x + 3, -r - 12), (x + 9, -r - 12)]), .ink, width: 2.2)
        pen.line(KaartPen.polygonLine([head, (head.0 - 1, head.1 - 3), (head.0 + 3, head.1 - 3)]), .ink, width: 1.6)
    }
}
