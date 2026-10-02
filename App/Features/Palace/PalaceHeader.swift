import SwiftUI

/// "GEMEENTEHUIS | van binnen", the close button, and the method line in Courier.
struct PalaceHeader: View {
    let sheetNumber: Int
    let placeName: String
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                ViewThatFits(in: .horizontal) {
                    strips(withSubtitle: true, doodle: true)
                    strips(withSubtitle: true, doodle: false)
                    strips(withSubtitle: false, doodle: false)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(placeName) van binnen")
                .accessibilityAddTraits(.isHeader)
                Spacer(minLength: 0)
                CircleIconButton(systemName: "xmark", label: "Sluiten", action: onClose)
            }
            Text("Vel \(sheetNumber) · Methode van loci: je onthoudt woorden op hun plek.")
                .font(Fonts.label(12))
                .foregroundStyle(Theme.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func strips(withSubtitle: Bool, doodle: Bool) -> some View {
        HStack(spacing: 6) {
            Text(placeName.uppercased())
                .font(.custom("AvenirNext-Heavy", size: 20))
                .foregroundStyle(Theme.onInk)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
                .background(Theme.ink)
                .rotationEffect(.degrees(-1.5))
            if withSubtitle {
                Text("van binnen")
                    .font(Fonts.readingItalic(19))
                    .foregroundStyle(Theme.ink)
                    .lineLimit(1)
                    .fixedSize()
                    .padding(.horizontal, 10)
                    .padding(.vertical, 2)
                    .background(Color.white)
                    .overlay(Rectangle().stroke(Ink.hex(0xD3D1C7), lineWidth: 1))
                    .rotationEffect(.degrees(1.5))
            }
            if doodle {
                Doodle(kind: .zigzag, color: Theme.doodles[0])
                    .frame(width: 40)
                    .accessibilityHidden(true)
            }
        }
        .fixedSize(horizontal: !withSubtitle ? false : true, vertical: false)
    }
}

/// Segmented control: Verken | Waar is…? | Wat is weg?
struct PalaceModePicker: View {
    let mode: PalaceMode
    let onSelect: (PalaceMode) -> Void

    var body: some View {
        HStack(spacing: 2) {
            ForEach(PalaceMode.allCases) { item in
                let on = item == mode
                Button {
                    guard !on else { return }
                    Haptics.tap()
                    onSelect(item)
                } label: {
                    Text(item.label)
                        .font(.system(size: 15, weight: .heavy))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .padding(.horizontal, 4)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .foregroundStyle(on ? Theme.onInk : Theme.ink)
                        .background(on ? Theme.ink : Color.clear, in: RoundedRectangle(cornerRadius: 2))
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(on ? .isSelected : [])
                .animation(.easeInOut(duration: 0.2), value: on)
            }
        }
        .padding(2)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
        .rotationEffect(.degrees(-0.4))
    }
}

/// Wraps its children onto new lines when they don't fit (strips in a sentence).
struct PalaceFlow: Layout {
    var spacing: CGFloat = 6
    var lineSpacing: CGFloat = 10
    var centered = false

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = arrange(width: proposal.width ?? .infinity, subviews: subviews)
        let width = rows.map(\.width).max() ?? 0
        let height = rows.map(\.height).reduce(0, +) + lineSpacing * CGFloat(max(0, rows.count - 1))
        return CGSize(width: proposal.width ?? width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var y = bounds.minY
        for row in arrange(width: bounds.width, subviews: subviews) {
            var x = bounds.minX + (centered ? max(0, (bounds.width - row.width) / 2) : 0)
            for index in row.items {
                let size = subviews[index].sizeThatFits(.unspecified)
                subviews[index].place(at: CGPoint(x: x, y: y + (row.height - size.height) / 2), proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
            y += row.height + lineSpacing
        }
    }

    private struct Row {
        var items: [Int] = []
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    private func arrange(width: CGFloat, subviews: Subviews) -> [Row] {
        var rows: [Row] = []
        var row = Row()
        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            let needed = row.items.isEmpty ? size.width : row.width + spacing + size.width
            if needed > width, !row.items.isEmpty {
                rows.append(row)
                row = Row()
            }
            row.width = row.items.isEmpty ? size.width : row.width + spacing + size.width
            row.height = max(row.height, size.height)
            row.items.append(index)
        }
        if !row.items.isEmpty { rows.append(row) }
        return rows
    }
}
