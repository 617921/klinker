import SwiftUI

/// Wraps strips onto lines, like words on a page.
struct RansomFlow: Layout {
    var spacing: CGFloat = 8
    var lineSpacing: CGFloat = 10
    var centered = false

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        let lines = arrange(subviews, maxWidth: maxWidth)
        let width = lines.map(\.width).max() ?? 0
        let height = lines.reduce(0) { $0 + $1.height } + lineSpacing * CGFloat(max(0, lines.count - 1))
        return CGSize(width: proposal.width ?? width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let lines = arrange(subviews, maxWidth: bounds.width)
        var y = bounds.minY
        for line in lines {
            var x = bounds.minX + (centered ? (bounds.width - line.width) / 2 : 0)
            for item in line.items {
                let size = item.size
                subviews[item.index].place(
                    at: CGPoint(x: x, y: y + (line.height - size.height) / 2),
                    proposal: ProposedViewSize(width: size.width, height: size.height)
                )
                x += size.width + spacing
            }
            y += line.height + lineSpacing
        }
    }

    private struct Item {
        let index: Int
        let size: CGSize
    }

    private struct FlowLine {
        var items: [Item] = []
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    private func arrange(_ subviews: Subviews, maxWidth: CGFloat) -> [FlowLine] {
        var lines: [FlowLine] = []
        var line = FlowLine()
        for index in subviews.indices {
            var size = subviews[index].sizeThatFits(.unspecified)
            size.width = min(size.width, maxWidth)
            let needed = line.items.isEmpty ? size.width : line.width + spacing + size.width
            if needed > maxWidth, !line.items.isEmpty {
                lines.append(line)
                line = FlowLine()
            }
            line.width = line.items.isEmpty ? size.width : line.width + spacing + size.width
            line.height = max(line.height, size.height)
            line.items.append(Item(index: index, size: size))
        }
        if !line.items.isEmpty { lines.append(line) }
        return lines
    }
}

/// One cut-out word strip.
struct RansomTileView: View {
    let tile: RansomGame.Tile

    var body: some View {
        PaperStrip(text: tile.text, size: 25)
            .rotationEffect(.degrees(tile.tilt))
            .shadow(color: Theme.ink.opacity(0.12), radius: 1.5, x: 0.5, y: 1.5)
    }
}

/// Press feedback for strips: a little lift.
struct RansomPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.08 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

/// The green cutting mat the loose strips lie on ("knip" = cut).
struct RansomCuttingMat: View {
    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size)
            context.fill(Path(roundedRect: rect, cornerRadius: 6), with: .color(Color(hex: 0x2F6B4F)))
            var grid = Path()
            let step: CGFloat = 18
            var x = step
            while x < size.width {
                grid.move(to: CGPoint(x: x, y: 0))
                grid.addLine(to: CGPoint(x: x, y: size.height))
                x += step
            }
            var y = step
            while y < size.height {
                grid.move(to: CGPoint(x: 0, y: y))
                grid.addLine(to: CGPoint(x: size.width, y: y))
                y += step
            }
            context.stroke(grid, with: .color(.white.opacity(0.12)), lineWidth: 0.6)
            var ruler = Path()
            var tick: CGFloat = 9
            var i = 0
            while tick < size.width {
                let long = i.isMultiple(of: 4)
                ruler.move(to: CGPoint(x: tick, y: 0))
                ruler.addLine(to: CGPoint(x: tick, y: long ? 9 : 5))
                tick += 9
                i += 1
            }
            context.stroke(ruler, with: .color(.white.opacity(0.35)), lineWidth: 1)
        }
        .accessibilityHidden(true)
    }
}
