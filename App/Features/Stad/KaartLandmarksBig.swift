import SwiftUI

/// The big buildings: church, museum, theatre, school, hospital, hotel and friends.
nonisolated extension KaartLandmarks {
    static func big(_ n: Int) -> KaartLandmark? {
        switch n {
        case 25: kerk()
        default: nil
        }
    }

    /// De kerk: a brick church with a slate roof, arched windows and a tall tower with a clock and spire.
    private static func kerk() -> KaartLandmark {
        var pen = KaartPen(wall: 0x8C4A3A, roof: 0x45505A, door: 0x3E2A1E, accent: 0xC9A15B)
        // The tower comes first: it is the front with the door.
        let tower = pen.box(x: 0, w: 34, h: 128, depth: 26)
        let nave = pen.box(x: 34, w: 104, h: 74, depth: 44)
        pen.ridgeRoof(over: nave, rise: 46, depth: 44, overhang: 4)
        pen.windows(in: CGRect(x: 40, y: -66, width: 94, height: 54), cols: 4, rows: 1, w: 12, h: 30, arched: true, seed: 25)
        pen.oval(82, -70 - 14, 16, 16, .trim)
        pen.oval(85, -70 - 11, 10, 10, .lit)
        // Tower: belfry openings, clock, spire with a golden weathercock.
        pen.windows(in: CGRect(x: 4, y: -124, width: 26, height: 30), cols: 2, rows: 1, w: 7, h: 16, arched: true, seed: 3)
        pen.oval(7, -88, 20, 20, .white)
        pen.line(Path { $0.addEllipse(in: CGRect(x: 7, y: -88, width: 20, height: 20)) }, .ink, width: 1.4)
        pen.line(KaartPen.polygonLine([(17, -84), (17, -78), (21, -76)]), .ink, width: 1.4)
        pen.spire(cx: 17 + 6, base: tower.minY - 7, w: 40, h: 74)
        pen.rect(22.2, tower.minY - 7 - 74 - 10, 1.6, 12, .ink)
        pen.poly([(19, -219), (27, -219), (25, -223)], .accent)
        pen.door(cx: 17, w: 16, h: 30, arched: true)
        pen.art.signAt = CGPoint(x: 36, y: -40)
        pen.art.sign = "bell.fill"
        return pen.art
    }
}
