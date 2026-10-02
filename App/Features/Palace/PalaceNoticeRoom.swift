import SwiftUI

/// The seeded look of a prikbord room: wall, wainscot and floor colours, and Noor's side.
struct PalaceRoomStyle {
    let wall: UInt32
    let panel: UInt32
    let floor: UInt32
    /// Noor stands on the left (and the plant on the right).
    let noorLeft: Bool

    static let walls: [UInt32] = [0xE8DDC6, 0xDCE3DF, 0xEADBD0, 0xD8E0E6, 0xE6DEC0, 0xD9E2CF, 0xEDE3D3, 0xE4DAE4]
    static let panels: [UInt32] = [0x8C5E38, 0x3F5A4A, 0x5E6B73, 0x7A5230, 0x1F3A6B, 0x993556]
    static let floors: [UInt32] = [0xB98A5A, 0xA87B4F, 0xC49A6C, 0x9A6A42]

    static func seeded(_ sheetNumber: Int) -> PalaceRoomStyle {
        var rnd = PalaceRandom(seed: PalaceNoticeRoom.mix(sheetNumber))
        return PalaceRoomStyle(wall: rnd.pick(walls), panel: rnd.pick(panels), floor: rnd.pick(floors), noorLeft: rnd.next() < 0.5)
    }
}

/// The neutral fallback for a place without anchors: its words hang as notes on a big prikbord.
/// The notes mean nothing by themselves, so the room never teaches a false link; it offers
/// Verken and Wat is weg? (where is which note), not Waar is…?.
enum PalaceNoticeRoom {
    /// The cork area notes are spread over: 3 columns × 4 rows under the name sign.
    static let grid = CGRect(x: 24, y: 50, width: 322, height: 188)

    /// Spreads nearby seeds apart (consecutive sheets look unrelated).
    static func mix(_ n: Int) -> Int {
        var z = UInt32(truncatingIfNeeded: n) &+ 0x9E37_79B9
        z = (z ^ (z >> 16)) &* 0x85EB_CA6B
        z = (z ^ (z >> 13)) &* 0xC2B2_AE35
        return Int(z ^ (z >> 16))
    }

    static func make(sheetNumber: Int, words: [Word]) -> PalaceRoom {
        let style = PalaceRoomStyle.seeded(sheetNumber)
        var rnd = PalaceRandom(seed: mix(sheetNumber &* 31 &+ 7))
        let cells = shuffled(Array(0..<12), &rnd)
        let colW = grid.width / 3, rowH = grid.height / 4
        let spots: [PalaceSpot] = words.prefix(12).enumerated().map { i, word in
            let cell = cells[i]
            let cx = grid.minX + (CGFloat(cell % 3) + 0.5) * colW + CGFloat(rnd.next() * 16 - 8)
            let top = grid.minY + CGFloat(cell / 3) * rowH + CGFloat(rnd.next() * 3)
            return PalaceSpot(
                word: word, art: .note(cell), frame: CGRect(x: cx - 30, y: top, width: 60, height: 44),
                pin: CGPoint(x: cx, y: top + 19), align: .center, tilt: Tilt.at(i),
                label: "Briefje \(i + 1) op het prikbord"
            )
        }
        let placeName = PlaceCatalog.name(sheetNumber)
        return PalaceRoom(
            sheetNumber: sheetNumber,
            placeName: placeName,
            kind: .noticeBoard(style),
            spots: spots,
            backdrop: PalaceNoticeBackdrop.marks(style),
            noor: CGPoint(x: style.noorLeft ? 30 : 296, y: 290),
            noorFacesLeft: !style.noorLeft,
            hall: "ruimte",
            thing: "briefje",
            sceneLabel: "Het prikbord van \(placeName)",
            waarOrder: spots.map(\.id),
            spreadPins: true
        )
    }

    private static func shuffled<T>(_ items: [T], _ rnd: inout PalaceRandom) -> [T] {
        var a = items
        guard a.count > 1 else { return a }
        for i in stride(from: a.count - 1, to: 0, by: -1) {
            a.swapAt(i, min(i, Int(rnd.next() * Double(i + 1))))
        }
        return a
    }
}

/// A note pinned to the prikbord: coloured paper, a few pencil lines, a pushpin. Says nothing.
struct PalaceNoteArt: View {
    let variant: Int

    private static let papers: [UInt32] = [0xFFFDF6, 0xFAC775, 0xC9E6E2, 0xF4C0D1, 0xDCE3DF, 0xF6EBD9]
    private static let pins: [UInt32] = [0xC8261B, 0x2F5BD3, 0x1E7A4C, 0xF2711C, 0x3C3489]
    private static let tilts: [Double] = [-3, 2, -1.5, 3, -2.5, 1.5, -2, 2.5]

    var body: some View {
        Canvas { ctx, size in
            let pen = PropPen(ctx: ctx, size: size)
            let paper = CGRect(x: 2, y: 4, width: size.width - 4, height: size.height - 8)
            pen.rect(paper.offsetBy(dx: 1, dy: 2), 0x1E1E1C, 0.16)
            pen.rect(paper, Self.papers[variant % Self.papers.count])
            let widths: [CGFloat] = [0.7, 0.55, 0.62]
            for (k, w) in widths.enumerated() {
                let y = paper.minY + 13 + CGFloat(k) * 7
                pen.line(paper.minX + 7, y, paper.minX + 7 + (paper.width - 14) * w, y, 0xB4B2A9, 1.3)
            }
            pen.dot(paper.midX, paper.minY + 4, 3.6, Self.pins[variant % Self.pins.count])
            pen.dot(paper.midX - 1, paper.minY + 3, 1.2, 0xFFFFFF, 0.6)
        }
        .rotationEffect(.degrees(Self.tilts[variant % Self.tilts.count]))
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
