import SwiftUI

/// Bottom sheet for one place: name, vel, status, and what to do next
/// ("Speel je ronde" for the current place, "Herstel" for a fading one).
struct StadPlaceSheet: View {
    let n: Int
    let night: Bool
    let onRepair: () -> Void
    let onPlay: () -> Void
    let onEnter: () -> Void

    @State private var openWord: Word?

    @Environment(ProgressStore.self) private var progress
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let status = progress.status(ofSheet: n)
        let total = max(1, progress.content.sheet(n)?.words.count ?? 11)
        let learned = min(total, progress.learnedCount(inSheet: n))
        let met = min(total, progress.metCount(inSheet: n))
        let fading = status == .fading ? progress.fadingWords(inSheet: n) : []
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header(status)
                HStack(spacing: 10) {
                    statusChip(status, learned: status == .current ? met : learned, total: total, fading: fading.count)
                    Spacer(minLength: 0)
                    CircleIconButton(systemName: "speaker.wave.2.fill", label: "Luister: \(StadPlaces.spoken(n))", dark: true) {
                        Speech.shared.say(StadPlaces.spoken(n))
                    }
                }
                switch status {
                case .built: cells(filled: total, total: total, color: Theme.ink)
                case .growing: cells(filled: learned, total: total, color: Theme.ink)
                case .current: cells(filled: met, total: total, color: Theme.orange)
                default: EmptyView()
                }
                if status != .locked, let words = progress.content.sheet(n)?.words, !words.isEmpty {
                    PlaceWords(words: words) { word in
                        Speech.shared.say(word.spoken)
                        openWord = word
                    }
                    .padding(.top, 4)
                }
                Text(message(status, learned: status == .current ? met : learned, total: total))
                    .font(Fonts.body(15))
                    .foregroundStyle(Theme.ink)
                    .fixedSize(horizontal: false, vertical: true)
                action(status, fadingCount: fading.count)
                if status != .locked, progress.content.sheet(n) != nil {
                    Button(action: onEnter) {
                        Label("Ga naar binnen", systemImage: "door.left.hand.open")
                    }
                    .buttonStyle(OutlineButtonStyle())
                    .accessibilityHint("Je woorden hangen hier op hun eigen plek.")
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 22)
            .padding(.bottom, 24)
        }
        .scrollBounceBehavior(.basedOnSize)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationBackground(StadInk.hex(0xFBFAF7))
        .sheet(item: $openWord) { word in
            WordDetailView(word: word)
        }
    }

    // MARK: Parts

    private func header(_ status: SheetStatus) -> some View {
        HStack(spacing: 12) {
            tile(status)
            VStack(alignment: .leading, spacing: 2) {
                CourierLabel(text: "Vel \(n) / \(ContentStore.totalSheets)")
                Text(PlaceCatalog.name(n))
                    .font(.system(size: 22, weight: .heavy))
                    .tracking(-0.4)
                    .foregroundStyle(Theme.ink)
                    .accessibilityAddTraits(.isHeader)
            }
            Spacer(minLength: 0)
            CircleIconButton(systemName: "xmark", label: "Terug naar de kaart") { dismiss() }
        }
    }

    private func tile(_ status: SheetStatus) -> some View {
        let (fill, fg): (Color, Color) = switch status {
        case .built: (Theme.ink, Theme.onInk)
        case .current: (Theme.orange, Theme.ink)
        case .growing: (StadInk.hex(0xFCE3CF), Theme.ink)
        case .fading: (StadInk.hex(0xD9D6CC), Theme.ink)
        case .locked: (Color.white, Theme.muted)
        }
        return ZStack {
            RoundedRectangle(cornerRadius: 3).fill(fill)
            if status == .locked {
                RoundedRectangle(cornerRadius: 3)
                    .strokeBorder(Theme.tapeOther, style: StrokeStyle(lineWidth: 2, dash: [4, 3]))
                Text("\(n)")
                    .font(Fonts.label(18))
                    .foregroundStyle(fg)
            } else {
                Image(systemName: PlaceCatalog.symbol(n))
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(fg)
            }
        }
        .frame(width: 48, height: 48)
        .rotationEffect(.degrees(-3))
        .accessibilityHidden(true)
    }

    private func statusChip(_ status: SheetStatus, learned: Int, total: Int, fading: Int) -> some View {
        let text: String
        let fill: Color, fg: Color, line: Color, dot: Color
        var dashed = false
        switch status {
        case .built:
            text = "Gebouwd · \(learned) \(learned == 1 ? "woord" : "woorden") beheerst"
            (fill, fg, line, dot) = (Theme.okBg, Theme.okText, Theme.okLine, Theme.okLine)
        case .current:
            text = "Nu bezig · \(learned) van \(total) goed"
            (fill, fg, line, dot) = (StadInk.hex(0xFCE3CF), Theme.orangeText, Theme.orange, Theme.orange)
        case .growing:
            text = "In aanbouw · \(learned) van \(total) vast"
            (fill, fg, line, dot) = (Color.white, Theme.ink, Theme.orange, Theme.orange)
        case .fading:
            text = "Verbleekt · \(fading) \(fading == 1 ? "woord" : "woorden") bijna vergeten"
            (fill, fg, line, dot) = (StadInk.hex(0xECEAE4), Theme.muted, Theme.tapeOther, Theme.tapeOther)
        case .locked:
            text = n > 1 ? "Op slot · na \(PlaceCatalog.name(n - 1))" : "Op slot"
            (fill, fg, line, dot) = (Color.clear, Theme.muted, Theme.dashed, Theme.dashed)
            dashed = true
        }
        return HStack(spacing: 8) {
            Circle().fill(dot).frame(width: 9, height: 9)
            Text(text)
                .font(.system(size: 14, weight: .heavy))
                .foregroundStyle(fg)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .frame(minHeight: 34)
        .background(fill, in: Capsule())
        .overlay(Capsule().strokeBorder(line, style: StrokeStyle(lineWidth: 2, dash: dashed ? [5, 4] : [])))
    }

    private func cells(filled: Int, total: Int, color: Color) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<total, id: \.self) { i in
                if i < filled {
                    RoundedRectangle(cornerRadius: 2).fill(color)
                } else {
                    RoundedRectangle(cornerRadius: 2)
                        .strokeBorder(Theme.tapeOther, style: StrokeStyle(lineWidth: 1.5, dash: [3, 2]))
                }
            }
        }
        .frame(height: 12)
        .accessibilityElement()
        .accessibilityLabel("\(filled) van \(total) woorden geleerd")
    }

    private func message(_ status: SheetStatus, learned: Int, total: Int) -> String {
        switch status {
        case .built:
            let base: String = switch n {
            case 1: "Hier begon het: Noor stapt uit de trein. Alle \(total) woorden van vel 1 zitten stevig in je geheugen."
            case 11: "Alle \(total) woorden van vel 11 zitten stevig in je geheugen. Op zondag speelt hier muziek."
            case 12: "Alle \(total) woorden van vel 12 zitten stevig in je geheugen. Tram 2 rijdt elke tien minuten."
            default: "Alle \(total) woorden van vel \(n) zitten stevig in je geheugen."
            }
            return night ? base + " De lichten zijn aan." : base
        case .current:
            let left = max(1, total - learned)
            let next = n < ContentStore.totalSheets ? PlaceCatalog.name(n + 1) : nil
            let words = "Beantwoord nog \(left) \(left == 1 ? "woord" : "woorden") goed"
            return next.map { "\(words), dan gaat \($0) open." } ?? "\(words), dan is je stad compleet."
        case .growing:
            let left = max(1, total - learned)
            return "Je kent alle woorden van deze plek. Nog \(left) moeten echt vast gaan zitten: herhaal ze de komende dagen, dan gaat de steiger eraf."
        case .fading:
            return "Deze woorden zakken weg. Herhaal ze, dan komt de kleur terug."
        case .locked:
            return progress.content.sheet(n) == nil && n <= progress.currentSheetNumber
                ? "Deze plek is nog in de maak. De woorden komen binnenkort."
                : "Deze plek gaat open als je de woorden van \(PlaceCatalog.name(max(1, n - 1))) kent."
        }
    }

    @ViewBuilder
    private func action(_ status: SheetStatus, fadingCount: Int) -> some View {
        switch status {
        case .current:
            Button(action: onPlay) {
                Label("Speel je ronde", systemImage: "play.fill")
            }
            .buttonStyle(InkButtonStyle())
            .padding(.top, 4)
        case .fading:
            Button(action: onRepair) {
                Label("Herstel · \(fadingCount) \(fadingCount == 1 ? "woord" : "woorden")", systemImage: "hammer.fill")
            }
            .buttonStyle(InkButtonStyle())
            .padding(.top, 4)
        case .locked:
            HStack(spacing: 10) {
                Image(systemName: "lock.fill")
                    .accessibilityHidden(true)
                Text(n > 1 ? "Op slot. Leer eerst \(PlaceCatalog.name(n - 1)) (vel \(n - 1))." : "Speel je eerste ronde om te beginnen.")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .font(Fonts.body(14))
            .foregroundStyle(Theme.muted)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Theme.dashed, style: StrokeStyle(lineWidth: 2, dash: [6, 4])))
        case .built, .growing:
            EmptyView()
        }
    }
}

/// Leading-aligned wrapping row for word strips.
private struct StadWrap: Layout {
    var spacing: CGFloat = 10
    var lineSpacing: CGFloat = 12

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        let rows = arrange(subviews, maxWidth: maxWidth)
        let height = rows.reduce(0) { $0 + $1.height } + lineSpacing * CGFloat(max(0, rows.count - 1))
        let width = rows.map(\.width).max() ?? 0
        return CGSize(width: maxWidth.isFinite ? maxWidth : width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var y = bounds.minY
        for row in arrange(subviews, maxWidth: bounds.width) {
            var x = bounds.minX
            for (index, size) in row.items {
                subviews[index].place(at: CGPoint(x: x, y: y + row.height / 2), anchor: .leading, proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
            y += row.height + lineSpacing
        }
    }

    private struct Row {
        var items: [(Int, CGSize)] = []
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    private func arrange(_ subviews: Subviews, maxWidth: CGFloat) -> [Row] {
        var rows: [Row] = []
        var row = Row()
        for index in subviews.indices {
            var size = subviews[index].sizeThatFits(.unspecified)
            size.width = min(size.width, maxWidth)
            if !row.items.isEmpty, row.width + spacing + size.width > maxWidth {
                rows.append(row)
                row = Row()
            }
            row.width += row.items.isEmpty ? size.width : spacing + size.width
            row.height = max(row.height, size.height)
            row.items.append((index, size))
        }
        if !row.items.isEmpty { rows.append(row) }
        return rows
    }
}

/// The place's words as collage strips, sized by how well you know them.
private struct PlaceWords: View {
    let words: [Word]
    let onTap: (Word) -> Void

    @Environment(ProgressStore.self) private var progress

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            CourierLabel(text: "Woorden van deze plek")
            FlowLayout(spacing: 8, lineSpacing: 12) {
                ForEach(Array(words.enumerated()), id: \.element.id) { i, word in
                    LevelStrip(word: word, index: i, look: WordLook(word: word, progress: progress)) {
                        onTap(word)
                    }
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
            .rotationEffect(.degrees(-0.4))
            TapeLegend()
        }
    }
}
