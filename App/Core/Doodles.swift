import SwiftUI

/// Hand-drawn style decorations between collage strips.
enum DoodleKind: CaseIterable {
    case zigzag, dots, rings, dashes
}

struct Doodle: View {
    let kind: DoodleKind
    let color: Color

    var body: some View {
        switch kind {
        case .zigzag:
            ZigZag().stroke(color, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                .frame(width: 52, height: 14)
        case .dots:
            Line().stroke(color, style: StrokeStyle(lineWidth: 5, lineCap: .round, dash: [0.1, 9]))
                .frame(width: 58, height: 6)
        case .rings:
            HStack(spacing: 4) {
                ForEach(0..<4, id: \.self) { _ in Circle().stroke(color, lineWidth: 2).frame(width: 9, height: 9) }
            }
        case .dashes:
            HStack(spacing: 4) {
                ForEach(0..<5, id: \.self) { _ in Capsule().fill(color).frame(width: 2.5, height: 12) }
            }
        }
    }
}

struct ZigZag: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        var p = Path()
        let steps = 8
        let w = rect.width / CGFloat(steps)
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        for i in 1...steps {
            let y = i.isMultiple(of: 2) ? rect.maxY : rect.minY
            p.addLine(to: CGPoint(x: rect.minX + CGFloat(i) * w, y: y))
        }
        return p
    }
}

struct Line: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return p
    }
}
