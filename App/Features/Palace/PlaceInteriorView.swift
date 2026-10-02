import SwiftUI

/// The memory palace of one place (method of loci): the sheet's eleven words hang on objects
/// that mean them. Vel 14 is the town hall from the prototype, places in anchors.json get their
/// own room of props, and the rest a neutral prikbord. Presented full screen; closes with `dismiss`.
struct PlaceInteriorView: View {
    let sheetNumber: Int
    @State private var game: PalaceGame?

    @Environment(\.dismiss) private var dismiss
    @Environment(ProgressStore.self) private var progress

    init(sheetNumber: Int) {
        self.init(sheetNumber: sheetNumber, content: .shared)
    }

    /// For previews and tests: build the palace from a given content store.
    init(sheetNumber: Int, content: ContentStore) {
        self.sheetNumber = sheetNumber
        _game = State(initialValue: PalaceRoomCache.game(sheetNumber: sheetNumber, content: content))
    }

    var body: some View {
        GeometryReader { geo in
            let scale = Self.sceneScale(for: geo.size)
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    PalaceHeader(sheetNumber: sheetNumber, placeName: PlaceCatalog.name(sheetNumber)) { close() }
                    if let game {
                        content(game, scale: scale)
                    } else {
                        PalaceEmptyState(sheetNumber: sheetNumber, scale: scale) { close() }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .background(Theme.paper.ignoresSafeArea())
        .onDisappear { game?.stop() }
    }

    @ViewBuilder private func content(_ game: PalaceGame, scale: CGFloat) -> some View {
        PalaceModePicker(mode: game.mode, modes: game.room.modes) { mode in
            withAnimation(.easeOut(duration: 0.25)) { game.setMode(mode) }
        }
        PalaceScaledScene(room: game.room, game: game, scale: scale) { id in
            game.tap(id, progress: progress)
        }
        .frame(maxWidth: .infinity)
        Group {
            switch game.mode {
            case .verken: PalaceVerkenPanel(game: game) { switchMode(game, game.room.playsWaar ? .waar : .weg) }
            case .waar: PalaceWaarPanel(game: game) { switchMode(game, .weg) }
            case .weg: PalaceWegPanel(game: game) { close() }
            }
        }
        .padding(.top, 2)
    }

    private func switchMode(_ game: PalaceGame, _ mode: PalaceMode) {
        withAnimation(.easeOut(duration: 0.25)) { game.setMode(mode) }
    }

    private func close() {
        game?.stop()
        dismiss()
    }

    /// Fits the 370 × 408 scene to the width, and shrinks it a little on short screens so the
    /// question stays close by (never below 0.78, so objects stay easy to tap).
    static func sceneScale(for size: CGSize) -> CGFloat {
        let byWidth = (size.width - 32) / PalaceSceneView.size.width
        let byHeight = (size.height - 400) / PalaceSceneView.size.height
        return max(0.6, min(byWidth, max(0.78, byHeight)))
    }
}

/// Builds each palace once per content store, so re-creating the view is cheap.
enum PalaceRoomCache {
    private static var rooms: [String: PalaceRoom] = [:]

    static func game(sheetNumber: Int, content: ContentStore) -> PalaceGame? {
        let key = "\(ObjectIdentifier(content).hashValue)-\(sheetNumber)"
        if let room = rooms[key] { return PalaceGame(room: room) }
        guard let room = PalaceRoom.make(sheetNumber: sheetNumber, content: content) else { return nil }
        rooms[key] = room
        return PalaceGame(room: room)
    }
}
