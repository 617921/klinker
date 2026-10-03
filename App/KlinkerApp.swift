import SwiftData
import SwiftUI

/// Klinker: learn 682 Dutch B1 words by building a canal city, brick by brick.
/// ("klinker" is both a vowel and the brick that paves Dutch streets.)
@main
struct KlinkerApp: App {
    private let container: ModelContainer
    @State private var progress: ProgressStore

    init() {
        let container: ModelContainer
        do {
            container = try ModelContainer(for: Card.self)
        } catch {
            // Fall back to memory so the app still opens; progress won't persist this session.
            container = try! ModelContainer(for: Card.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        }
        self.container = container
        _progress = State(initialValue: ProgressStore(context: container.mainContext))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(progress)
                .modelContainer(container)
        }
    }
}

/// De Stad is the home screen. Rounds and place interiors open full screen over it.
struct RootView: View {
    @State private var round: RoundKind?
    @State private var visit: PlaceVisit?

    var body: some View {
        StadView(covered: round != nil || visit != nil)
            .tint(Theme.ink)
            .environment(\.startRound) { round = $0 }
            .environment(\.enterPlace) { visit = PlaceVisit(sheetNumber: $0) }
            .fullScreenCover(item: $round) { kind in
                RoundView(kind: kind)
            }
            .fullScreenCover(item: $visit) { visit in
                PlaceInteriorView(sheetNumber: visit.sheetNumber)
            }
    }
}
