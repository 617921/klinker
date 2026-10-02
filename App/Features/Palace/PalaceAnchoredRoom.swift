import SwiftUI

/// Builds a room from its anchors.json entry: each word on the prop that means it.
enum PalaceAnchoredRoom {
    /// The room, or `nil` when the room type is unknown or fewer than six words found a usable anchor.
    static func make(sheetNumber: Int, words: [Word], spec: PalaceRoomSpec) -> PalaceRoom? {
        guard let type = PalaceRoomType(rawValue: spec.type) else { return nil }
        var byID: [String: Word] = [:]
        for word in words where byID[word.id] == nil { byID[word.id] = word }

        var spots: [PalaceSpot] = []
        var decor: [PalaceDecor] = []
        for (i, anchor) in spec.anchors.enumerated() {
            guard let place = slot(anchor.slot, frame: anchor.frame, type: type) else { continue }
            var placed = place
            if let pin = anchor.pin, pin.count == 2 { placed.pin = CGPoint(x: pin[0], y: pin[1]) }
            if let align = anchor.align.flatMap(PalacePinAlign.init(name:)) { placed.align = align }
            if let tilt = anchor.tilt { placed.tilt = tilt }
            let art = PalaceArt.prop(PalaceProp(kind: anchor.prop, params: anchor.params ?? PalacePropParams()))
            if let word = byID[anchor.word], !spots.contains(where: { $0.id == word.id }) {
                spots.append(PalaceSpot(word: word, art: art, frame: placed.frame, pin: placed.pin,
                                        align: placed.align, tilt: placed.tilt, label: anchor.label))
            } else {
                // The word is not on this sheet (any more): the object stays, without a word.
                decor.append(PalaceDecor(id: i, art: art, frame: placed.frame))
            }
        }
        for (i, item) in spec.decor.enumerated() {
            guard let place = slot(item.slot, frame: item.frame, type: type) else { continue }
            let art = PalaceArt.prop(PalaceProp(kind: item.prop, params: item.params ?? PalacePropParams()))
            decor.append(PalaceDecor(id: 1000 + i, art: art, frame: place.frame))
        }
        guard !spots.isEmpty, spots.count >= min(6, words.count) else { return nil }

        let present = Set(spots.map(\.id))
        let firstOrder = (spec.order ?? []).filter { present.contains($0) }
        let order = firstOrder + spots.map(\.id).filter { !firstOrder.contains($0) }
        let rounds = (spec.weg ?? []).filter { r in
            r.options.count == 3 && r.options.contains(r.target) && r.options.allSatisfy { present.contains($0) }
        }
        let noor: CGPoint? = switch spec.noor?.count {
        case 2: spec.noor.map { CGPoint(x: $0[0], y: $0[1]) }
        case 0: nil
        default: type.noor
        }
        return PalaceRoom(
            sheetNumber: sheetNumber,
            placeName: PlaceCatalog.name(sheetNumber),
            kind: .anchored(type),
            spots: spots,
            decor: decor,
            noor: noor,
            hall: spec.hall ?? type.hall,
            sceneLabel: type.sceneLabel,
            waarOrder: order,
            wegRounds: rounds.map { PalaceWegRound(target: $0.target, options: $0.options) },
            promptOverrides: spec.prompts ?? [:],
            spreadPins: true
        )
    }

    /// A named slot of the room type, or an explicit frame (which wins); `nil` if neither is usable.
    /// An explicit frame without a slot hangs its strip across its lower edge.
    private static func slot(_ name: String?, frame: [Double]?, type: PalaceRoomType) -> PalaceSlot? {
        let named = name.flatMap { type.slots[$0] }
        guard let f = frame, f.count == 4 else { return named }
        let box = CGRect(x: f[0], y: f[1], width: f[2], height: f[3])
        guard var slot = named else {
            return PalaceSlot(frame: box, pin: CGPoint(x: box.midX, y: box.maxY - 12), align: .center)
        }
        slot.frame = box
        return slot
    }
}
