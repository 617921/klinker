import SwiftUI

/// Today's list in the Vandaag panel: the current place, fading places, post and the house.
struct VandaagToday: View {
    let onOpenPlace: (Int) -> Void

    @Environment(ProgressStore.self) private var progress

    var body: some View {
        let fading = (1...ContentStore.totalSheets).filter { progress.status(ofSheet: $0) == .fading }
        VStack(spacing: 10) {
            NowRow(onOpen: { onOpenPlace(progress.currentSheetNumber) })
            if let first = fading.first {
                FadingRow(places: fading, onOpen: { onOpenPlace(first) })
            }
            LettersCard()
            HouseCard()
        }
    }
}

/// A white row card: art on the left, text, chevron.
struct VandaagRow<Art: View, Info: View>: View {
    @ViewBuilder let art: Art
    @ViewBuilder let text: Info

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            art
            VStack(alignment: .leading, spacing: 3) { text }
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "chevron.right")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Theme.muted)
                .accessibilityHidden(true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 76, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
        .contentShape(Rectangle())
    }
}

/// "Nu bezig · vel n": the current place and how many words are still to get right once.
private struct NowRow: View {
    let onOpen: () -> Void

    @Environment(ProgressStore.self) private var progress

    var body: some View {
        let n = progress.currentSheetNumber
        let sheet = progress.content.sheet(n)
        let total = sheet?.words.count ?? 11
        let met = min(total, progress.metCount(inSheet: n))
        let left = total - met
        let next = n < ContentStore.totalSheets ? PlaceCatalog.name(n + 1) : nil
        let line = next.map { "Nog \(left) \(left == 1 ? "woord" : "woorden") goed, dan gaat \($0) open" }
            ?? "Nog \(left) \(left == 1 ? "woord" : "woorden") te gaan"
        Button(action: onOpen) {
            VandaagRow {
                ZStack {
                    RoundedRectangle(cornerRadius: 3).fill(Theme.orange)
                    Image(systemName: KaartPlaceView.symbol(n))
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Theme.ink)
                }
                .frame(width: 48, height: 48)
                .rotationEffect(.degrees(-3))
            } text: {
                CourierLabel(text: "Nu bezig · vel \(n)", size: 12)
                Text(sheet?.title ?? PlaceCatalog.name(n))
                    .font(.system(size: 19, weight: .heavy))
                    .tracking(-0.3)
                    .foregroundStyle(Theme.ink)
                    .multilineTextAlignment(.leading)
                HStack(spacing: 3) {
                    ForEach(0..<total, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 1.5)
                            .fill(i < met ? Theme.orange : Theme.hairline)
                    }
                }
                .frame(height: 6)
                .padding(.vertical, 3)
                Text(line)
                    .font(Fonts.body(13))
                    .foregroundStyle(Theme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Nu bezig, vel \(n): \(sheet?.title ?? PlaceCatalog.name(n)). \(met) van \(total) goed. \(line).")
        .accessibilityHint("Toon deze plek op de kaart.")
        .accessibilityAddTraits(.isButton)
    }
}

/// "2 plekken verbleken": built places whose words are slipping. Opens the first one.
private struct FadingRow: View {
    let places: [Int]
    let onOpen: () -> Void

    var body: some View {
        let names = places.map(PlaceCatalog.name)
        let title = names.count <= 2
            ? names.joined(separator: " en ")
            : "\(names[0]), \(names[1]) en \(names.count - 2) meer"
        Button(action: onOpen) {
            VandaagRow {
                KaartLegendIcon(status: .fading)
                    .frame(width: 14, height: 14)
                    .scaleEffect(2.4)
                    .frame(width: 48, height: 48)
                    .background(Theme.note, in: RoundedRectangle(cornerRadius: 3))
            } text: {
                CourierLabel(text: places.count == 1 ? "1 plek verbleekt" : "\(places.count) plekken verbleken", size: 12)
                Text(title)
                    .font(.system(size: 19, weight: .heavy))
                    .tracking(-0.3)
                    .foregroundStyle(Theme.ink)
                    .multilineTextAlignment(.leading)
                Text("Herhaal hun woorden, dan staan ze weer fris.")
                    .font(Fonts.body(13))
                    .foregroundStyle(Theme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(places.count == 1 ? "1 plek verbleekt" : "\(places.count) plekken verbleken"): \(title).")
        .accessibilityHint("Toon de eerste op de kaart.")
        .accessibilityAddTraits(.isButton)
    }
}

/// The rest, when the panel is pulled all the way up: single games, the city in numbers, the street.
struct VandaagMore: View {
    let night: Bool
    let active: Bool

    @Environment(ProgressStore.self) private var progress

    var body: some View {
        let statuses = (1...ContentStore.totalSheets).map { progress.status(ofSheet: $0) }
        let built = statuses.filter { $0 == .built || $0 == .fading }.count
        VStack(alignment: .leading, spacing: 26) {
            section("Losse spellen") {
                GameStrips()
            }
            section("Jouw stad") {
                Text("\(built) van \(ContentStore.totalSheets) plekken gebouwd · \(progress.wordsOnWall) / \(ContentStore.totalWords) woorden")
                    .font(Fonts.body(14))
                    .foregroundStyle(Theme.muted)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 1) {
                    ForEach(statuses.indices, id: \.self) { i in
                        Rectangle()
                            .fill(color(statuses[i]))
                            .clipShape(RoundedRectangle(cornerRadius: 1))
                    }
                }
                .frame(height: 8)
                .accessibilityHidden(true)
                KaartLegend()
                    .padding(.top, 6)
            }
            section("Ontdekt in de stad") {
                let discoveries = KaartDiscoveries.shared
                Text("\(discoveries.count) van \(discoveries.total) gevonden")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundStyle(Theme.ink)
                Text("Zoom helemaal in en tik op katten, eenden, kraampjes en bootjes: zo leer je extra woorden. Sommige zie je alleen in een bepaald seizoen.")
                    .font(Fonts.body(14))
                    .foregroundStyle(Theme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            section("Jouw straat") {
                StraatView(night: night, active: active)
            }
        }
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 22, weight: .heavy))
                .tracking(-0.5)
                .foregroundStyle(Theme.ink)
                .accessibilityAddTraits(.isHeader)
            content()
        }
    }

    private func color(_ status: SheetStatus) -> Color {
        switch status {
        case .built: Theme.ink
        case .growing: Theme.orange.opacity(0.45)
        case .current: Theme.orange
        case .fading: Theme.tapeOther
        case .locked: Theme.hairline
        }
    }
}
