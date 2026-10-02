import SwiftUI

/// The seeded look of a generic room: colours, arrangement and whether it is mirrored.
struct PalaceRoomStyle {
    let wall: UInt32
    let panel: UInt32
    let floor: UInt32
    let door: UInt32
    let rug: UInt32
    let coat: UInt32
    let painting: Int
    /// Window on the right, door on the left.
    let mirrored: Bool
    /// The second arrangement: wall objects swap places.
    let swapped: Bool

    static let walls: [UInt32] = [0xE8DDC6, 0xDCE3DF, 0xEADBD0, 0xD8E0E6, 0xE6DEC0, 0xD9E2CF, 0xEDE3D3, 0xE4DAE4]
    static let panels: [UInt32] = [0x8C5E38, 0x3F5A4A, 0x5E6B73, 0x7A5230, 0x1F3A6B, 0x993556]
    static let floors: [UInt32] = [0xB98A5A, 0xA87B4F, 0xC49A6C, 0x9A6A42]
    static let rugs: [UInt32] = [0x993556, 0x1F3A6B, 0x0F6E56, 0xC8261B, 0x3C3489]
    static let coats: [UInt32] = [0x8C4A3A, 0x2F5BD3, 0x3F5A4A, 0xC9A15B, 0x993556]

    static func seeded(_ sheetNumber: Int) -> PalaceRoomStyle {
        var rnd = GevelRandom(seed: PalaceGenericRoom.mix(sheetNumber))
        return PalaceRoomStyle(
            wall: rnd.pick(walls), panel: rnd.pick(panels), floor: rnd.pick(floors),
            door: rnd.pick(PalaceCanal.doors), rug: rnd.pick(rugs), coat: rnd.pick(coats),
            painting: Int(rnd.next() * 3), mirrored: rnd.next() < 0.5, swapped: rnd.next() < 0.5
        )
    }
}

/// The generic room: a Dutch room with a tall canal window, a door with the place's sign,
/// and thirteen object places of which (up to) eleven carry the sheet's words.
enum PalaceGenericRoom {
    private struct Slot {
        let art: PalaceArt
        let box: CGRect
        let label: String
        var pin: CGPoint = .zero
        var align: PalacePinAlign = .center
        var tilt: Double = 0
    }

    /// Door centre in unmirrored coordinates (the sign hangs above it).
    static let doorX: CGFloat = 302
    static let noorSpot = CGPoint(x: 236, y: 290)

    /// Spreads nearby seeds apart (consecutive sheets look unrelated).
    static func mix(_ n: Int) -> Int {
        var z = UInt32(truncatingIfNeeded: n) &+ 0x9E37_79B9
        z = (z ^ (z >> 16)) &* 0x85EB_CA6B
        z = (z ^ (z >> 13)) &* 0xC2B2_AE35
        return Int(z ^ (z >> 16))
    }

    private static func slots(_ style: PalaceRoomStyle, symbol: String) -> [Slot] {
        let s = style.swapped
        let wall = [
            Slot(art: .painting(style.painting), box: CGRect(x: s ? 112 : 164, y: 22, width: 76, height: 66), label: "Het schilderij aan de muur"),
            Slot(art: .clock, box: CGRect(x: s ? 208 : 116, y: s ? 26 : 30, width: 36, height: 36), label: "De klok aan de muur"),
            Slot(art: .books, box: CGRect(x: s ? 184 : 112, y: 102, width: 60, height: 48), label: "De boeken op de plank"),
            Slot(art: .vase, box: CGRect(x: s ? 122 : 206, y: 98, width: 40, height: 52), label: "De vaas met tulpen"),
            Slot(art: .noticeBoard(symbol), box: CGRect(x: s ? 176 : 112, y: 170, width: 72, height: 58), label: "Het prikbord"),
            Slot(art: .mirror, box: CGRect(x: s ? 120 : 206, y: 166, width: 42, height: 62), label: "De spiegel"),
            Slot(art: .sillPlant, box: CGRect(x: 34, y: 176, width: 40, height: 44), label: "De plant op de vensterbank"),
        ]
        let floor = [
            Slot(art: .floorLamp, box: CGRect(x: 14, y: 236, width: 36, height: 112), label: "De staande lamp"),
            Slot(art: .desk, box: CGRect(x: 114, y: 258, width: 96, height: 64), label: "Het bureau met de lamp"),
            Slot(art: .chair, box: CGRect(x: 64, y: 268, width: 40, height: 64), label: "De stoel"),
            Slot(art: .rug(style.rug), box: CGRect(x: 60, y: 354, width: 150, height: 30), label: "Het kleed op de vloer"),
            Slot(art: .coatRack(style.coat), box: CGRect(x: 336, y: 186, width: 34, height: 114), label: "De kapstok met een jas"),
            Slot(art: .umbrellaStand, box: CGRect(x: 300, y: 330, width: 30, height: 46), label: "De paraplubak"),
        ]
        return (wall + floor).enumerated().map { i, slot in
            var out = slot
            (out.pin, out.align) = pin(for: slot.art, slot.box)
            out.tilt = Tilt.at(i + (s ? 3 : 0))
            return out
        }
    }

    /// Where a strip hangs on each kind of object: mostly across its lower edge.
    private static func pin(for art: PalaceArt, _ b: CGRect) -> (CGPoint, PalacePinAlign) {
        switch art {
        case .painting: (CGPoint(x: b.midX, y: b.maxY - 4), .center)
        case .clock: (CGPoint(x: b.midX, y: b.maxY - 2), .center)
        case .books, .vase, .noticeBoard: (CGPoint(x: b.midX, y: b.maxY - 14), .center)
        case .mirror: (CGPoint(x: b.midX, y: b.maxY - 14), .center)
        case .sillPlant: (CGPoint(x: b.midX - 2, y: b.maxY - 6), .center)
        case .floorLamp: (CGPoint(x: b.minX - 8, y: b.minY + 92), .leading)
        case .desk: (CGPoint(x: b.midX, y: b.minY + 44), .center)
        case .chair: (CGPoint(x: b.midX, y: b.maxY - 10), .center)
        case .rug: (CGPoint(x: b.midX, y: b.minY + 16), .center)
        case .coatRack: (CGPoint(x: b.maxX - 2, y: b.minY + 96), .trailing)
        default: (CGPoint(x: b.midX, y: b.maxY - 8), .center)
        }
    }

    static func make(sheetNumber: Int, words: [Word]) -> PalaceRoom {
        let style = PalaceRoomStyle.seeded(sheetNumber)
        var rnd = GevelRandom(seed: mix(sheetNumber &* 31 &+ 7))
        let all = slots(style, symbol: PlaceCatalog.symbol(sheetNumber)).map { mirror($0, style.mirrored) }
        // Which object places carry a word (seeded), and which word goes where.
        let chosen = shuffled(Array(all.indices), &rnd).prefix(min(words.count, all.count)).sorted()
        let wordOrder = shuffled(Array(words.prefix(chosen.count)), &rnd)
        let spots: [PalaceSpot] = zip(chosen, wordOrder).map { index, word in
            let s = all[index]
            return PalaceSpot(word: word, art: s.art, frame: s.box, pin: s.pin, align: s.align, tilt: s.tilt, label: s.label)
        }
        let used = Set(chosen)
        let decor = all.indices.filter { !used.contains($0) }.map { PalaceDecor(id: $0, art: all[$0].art, frame: all[$0].box) }
        let noor = style.mirrored ? CGPoint(x: 370 - noorSpot.x - 44, y: noorSpot.y) : noorSpot
        return PalaceRoom(
            sheetNumber: sheetNumber,
            placeName: PlaceCatalog.name(sheetNumber),
            kind: .generic(style),
            spots: spots,
            decor: decor,
            window: PalaceCanal.row(PalaceCanal.seeded(sheetNumber)),
            backdrop: PalaceGenericBackdrop.marks(style),
            noor: noor,
            hall: "ruimte",
            waarOrder: shuffled(spots.map(\.id), &rnd),
            spreadPins: true
        )
    }

    /// Mirrors a slot left ↔ right (positions only; drawings keep their orientation).
    private static func mirror(_ s: Slot, _ on: Bool) -> Slot {
        guard on else { return s }
        let align: PalacePinAlign = switch s.align {
        case .leading: .trailing
        case .center: .center
        case .trailing: .leading
        }
        return Slot(art: s.art, box: CGRect(x: 370 - s.box.maxX, y: s.box.minY, width: s.box.width, height: s.box.height),
                    label: s.label, pin: CGPoint(x: 370 - s.pin.x, y: s.pin.y), align: align, tilt: -s.tilt)
    }

    private static func shuffled<T>(_ items: [T], _ rnd: inout GevelRandom) -> [T] {
        var a = items
        guard a.count > 1 else { return a }
        for i in stride(from: a.count - 1, to: 0, by: -1) {
            let j = min(i, Int(rnd.next() * Double(i + 1)))
            a.swapAt(i, j)
        }
        return a
    }
}
