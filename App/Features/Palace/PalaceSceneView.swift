import SwiftUI

/// The illustrated room (370 × 408 scene points) with its word objects and pinned strips.
/// Scales to the width it gets.
struct PalaceSceneView: View {
    let room: PalaceRoom
    /// `nil` draws the room without interaction (empty state).
    let game: PalaceGame?
    var onTap: (String) -> Void = { _ in }

    static let size = CGSize(width: 370, height: 408)

    var body: some View {
        ZStack(alignment: .topLeading) {
            backdrop
            ForEach(room.decor) { item in
                PalaceObjectArt(art: item.art)
                    .frame(width: item.frame.width, height: item.frame.height)
                    .palaceAt(item.frame.minX, item.frame.minY)
                    .accessibilityHidden(true)
            }
            if let game {
                ForEach(Array(room.spots.enumerated()), id: \.element.id) { index, spot in
                    objectButton(spot, index: index, game: game)
                        .palaceAt(spot.frame.minX, spot.frame.minY)
                }
            }
            if let noor = room.noor {
                PalaceNoor(facingLeft: room.noorFacesLeft).palaceAt(noor.x, noor.y).allowsHitTesting(false)
            }
            if let game {
                PalacePinLayout(spread: room.spreadPins, obstacles: pinObstacles) {
                    ForEach(room.spots) { spot in
                        PalacePin(word: spot.word, pinned: game.isPinned(spot.id), tilt: spot.tilt)
                            .palacePin(spot.pin, align: spot.align)
                    }
                }
                .allowsHitTesting(false)
            }
        }
        .frame(width: Self.size.width, height: Self.size.height, alignment: .topLeading)
        .clipShape(RoundedRectangle(cornerRadius: 3))
        .dynamicTypeSize(.xSmall ... .xLarge)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(room.sceneLabel.isEmpty ? "De ruimte: \(room.placeName)" : room.sceneLabel)
    }

    /// Areas strips should keep clear of: Noor's face and body.
    private var pinObstacles: [CGRect] {
        guard room.spreadPins, let noor = room.noor else { return [] }
        return [CGRect(x: noor.x + 6, y: noor.y + 4, width: 32, height: 100)]
    }

    @ViewBuilder private var backdrop: some View {
        switch room.kind {
        case .gemeentehuis:
            GemeentehuisBackdrop(window: room.window).equatable()
        case let .anchored(type):
            PalaceRoomTypeBackdrop(type: type).equatable()
        case .noticeBoard:
            PalaceNoticeBackdrop(sheetNumber: room.sheetNumber, placeName: room.placeName, marks: room.backdrop)
                .equatable()
        }
    }

    private func objectButton(_ spot: PalaceSpot, index: Int, game: PalaceGame) -> some View {
        let look = game.look(spot.id)
        var text = spot.label
        if game.mode == .verken && game.found.contains(spot.id) { text += ". \(spot.word.spoken)" }
        let hint = switch game.mode {
        case .verken: "Tik om het woord te horen."
        case .waar: "Kies dit ding als antwoord."
        case .weg: "Tik om het woord te horen."
        }
        return PalaceObjectButton(
            spot: spot,
            look: look,
            showsDot: game.hasDot(spot.id),
            dotDelay: Double(index) * 0.37,
            shakes: game.shakes[spot.id, default: 0],
            accessibilityText: text,
            hint: hint
        ) {
            onTap(spot.id)
        }
    }
}

/// The scene scaled to fit a width, with two strips of yellow tape holding it like a photo.
struct PalaceScaledScene: View {
    let room: PalaceRoom
    let game: PalaceGame?
    let scale: CGFloat
    var onTap: (String) -> Void = { _ in }

    var body: some View {
        PalaceSceneView(room: room, game: game, onTap: onTap)
            .scaleEffect(scale, anchor: .topLeading)
            .frame(width: PalaceSceneView.size.width * scale, height: PalaceSceneView.size.height * scale, alignment: .topLeading)
            .background(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Theme.ink.opacity(0.12))
                    .offset(y: 2)
            }
            .overlay(alignment: .topLeading) {
                tape(-9).offset(x: 10 * scale, y: -7)
            }
            .overlay(alignment: .topTrailing) {
                tape(8).offset(x: -6 * scale, y: -7)
            }
    }

    private func tape(_ angle: Double) -> some View {
        Rectangle()
            .fill(PalaceInk.hex(0xFAC775, 0.8))
            .frame(width: 42, height: 13)
            .rotationEffect(.degrees(angle))
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}
