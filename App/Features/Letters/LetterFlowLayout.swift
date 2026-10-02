import SwiftUI

nonisolated private struct LetterBreakKey: LayoutValueKey {
    static let defaultValue = false
}

extension View {
    /// Starts a new line in a `LetterFlowLayout`.
    func letterLineBreak(_ on: Bool) -> some View {
        layoutValue(key: LetterBreakKey.self, value: on)
    }
}

/// Wraps cut-outs like words on a page; rows are vertically centred, `alignment` sets each row's x.
struct LetterFlowLayout: Layout {
    var spacing: CGFloat = 6
    var lineSpacing: CGFloat = 2
    var alignment: HorizontalAlignment = .leading

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        let rows = rows(subviews, maxWidth: maxWidth)
        let width = rows.map(\.width).max() ?? 0
        let height = rows.reduce(0) { $0 + $1.height } + lineSpacing * CGFloat(max(0, rows.count - 1))
        return CGSize(width: proposal.width ?? width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var y = bounds.minY
        for row in rows(subviews, maxWidth: bounds.width) {
            var x: CGFloat
            switch alignment {
            case .center: x = bounds.minX + (bounds.width - row.width) / 2
            case .trailing: x = bounds.maxX - row.width
            default: x = bounds.minX
            }
            for item in row.items {
                let dy = (row.height - item.size.height) / 2
                subviews[item.index].place(at: CGPoint(x: x, y: y + dy), proposal: ProposedViewSize(item.size))
                x += item.size.width + spacing
            }
            y += row.height + lineSpacing
        }
    }

    private struct Item {
        let index: Int
        let size: CGSize
    }

    private struct Row {
        var items: [Item] = []
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    private func rows(_ subviews: Subviews, maxWidth: CGFloat) -> [Row] {
        var rows: [Row] = []
        var row = Row()
        for (index, sub) in subviews.enumerated() {
            var size = sub.sizeThatFits(.unspecified)
            if size.width > maxWidth { size = sub.sizeThatFits(ProposedViewSize(width: maxWidth, height: nil)) }
            let needed = row.items.isEmpty ? size.width : row.width + spacing + size.width
            if !row.items.isEmpty && (needed > maxWidth || sub[LetterBreakKey.self]) {
                rows.append(row)
                row = Row()
            }
            row.width = row.items.isEmpty ? size.width : row.width + spacing + size.width
            row.height = max(row.height, size.height)
            row.items.append(Item(index: index, size: size))
        }
        if !row.items.isEmpty { rows.append(row) }
        return rows
    }
}
