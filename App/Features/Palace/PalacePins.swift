import SwiftUI

/// Where a strip hangs: its anchor point and how it lines up with it.
nonisolated struct PalacePinPlacement: Sendable {
    var point: CGPoint
    var align: PalacePinAlign
}

nonisolated private struct PalacePinKey: LayoutValueKey {
    static let defaultValue = PalacePinPlacement(point: .zero, align: .leading)
}

extension View {
    func palacePin(_ point: CGPoint, align: PalacePinAlign) -> some View {
        layoutValue(key: PalacePinKey.self, value: PalacePinPlacement(point: point, align: align))
    }
}

/// Lays out word strips over the 370 × 408 scene at their anchors, keeping each strip inside the scene.
/// With `spread`, a strip that would cover an earlier one (or an obstacle such as Noor) is nudged
/// to the nearest free spot close to its anchor.
struct PalacePinLayout: Layout {
    var spread = false
    var obstacles: [CGRect] = []

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        CGSize(width: 370, height: 408)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var taken = obstacles
        for sub in subviews {
            let pin = sub[PalacePinKey.self]
            let size = sub.sizeThatFits(.unspecified)
            var x: CGFloat
            switch pin.align {
            case .leading: x = pin.point.x
            case .center: x = pin.point.x - size.width / 2
            case .trailing: x = pin.point.x - size.width
            }
            var rect = clamp(CGRect(x: x, y: pin.point.y, width: size.width, height: size.height), in: bounds.size)
            if spread {
                rect = freeSpot(near: rect, avoiding: taken, in: bounds.size)
                taken.append(rect)
            }
            sub.place(at: CGPoint(x: bounds.minX + rect.minX, y: bounds.minY + rect.minY), proposal: ProposedViewSize(size))
        }
    }

    private func clamp(_ r: CGRect, in size: CGSize) -> CGRect {
        let x = min(max(r.minX, 3), max(3, size.width - 3 - r.width))
        let y = min(max(r.minY, 2), size.height - r.height - 2)
        return CGRect(x: x, y: y, width: r.width, height: r.height)
    }

    private static let nudges: [CGPoint] = {
        var list: [CGPoint] = []
        for dy in stride(from: -36.0, through: 36, by: 6) {
            for dx in stride(from: -48.0, through: 48, by: 12) { list.append(CGPoint(x: dx, y: dy)) }
        }
        return list.sorted { abs($0.x) * 0.6 + abs($0.y) < abs($1.x) * 0.6 + abs($1.y) }
    }()

    private func freeSpot(near rect: CGRect, avoiding taken: [CGRect], in size: CGSize) -> CGRect {
        var best = rect
        var bestOverlap = CGFloat.infinity
        for nudge in Self.nudges {
            let candidate = clamp(rect.offsetBy(dx: nudge.x, dy: nudge.y), in: size)
            let grown = candidate.insetBy(dx: -2, dy: -3)
            let overlap = taken.reduce(CGFloat(0)) { sum, other in
                let i = grown.intersection(other)
                return i.isNull ? sum : sum + i.width * i.height
            }
            if overlap == 0 { return candidate }
            if overlap < bestOverlap {
                bestOverlap = overlap
                best = candidate
            }
        }
        return best
    }
}

/// A word strip taped onto its object. It pins on with a springy drop and tape, and fades out when hidden.
struct PalacePin: View {
    let word: Word
    let pinned: Bool
    let tilt: Double

    @State private var drops = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct Pose {
        var scale: CGFloat = 1
        var lift: CGFloat = 0
    }

    var body: some View {
        StripView(text: word.nl, style: word.style, size: word.nl.count > 14 ? 11.5 : 13)
            .fixedSize()
            .shadow(color: Theme.ink.opacity(0.18), radius: 0, x: 0, y: 2)
            .overlay(alignment: .topLeading) {
                PalacePinTape(article: word.article, drops: drops).offset(x: 6, y: -9)
            }
            .keyframeAnimator(initialValue: Pose(), trigger: drops) { content, pose in
                content.scaleEffect(pose.scale).offset(y: pose.lift)
            } keyframes: { _ in
                KeyframeTrack(\.scale) {
                    MoveKeyframe(1.25)
                    SpringKeyframe(0.97, duration: 0.3, spring: .snappy)
                    SpringKeyframe(1, duration: 0.2, spring: .bouncy)
                }
                KeyframeTrack(\.lift) {
                    MoveKeyframe(-18)
                    SpringKeyframe(2, duration: 0.3, spring: .snappy)
                    SpringKeyframe(0, duration: 0.2, spring: .bouncy)
                }
            }
            .rotationEffect(.degrees(tilt))
            .opacity(pinned ? 1 : 0)
            .animation(.easeOut(duration: pinned ? 0.2 : 0.6), value: pinned)
            .onChange(of: pinned) { _, now in
                if now && !reduceMotion { drops += 1 }
            }
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

/// The article tape on a pinned strip; it slaps on just after the strip lands.
private struct PalacePinTape: View {
    let article: Article
    let drops: Int

    private struct Pose {
        var opacity: Double = 1
        var scale: CGFloat = 1
        var shift: CGFloat = 0
    }

    var body: some View {
        Tape(article: article, width: 22)
            .keyframeAnimator(initialValue: Pose(), trigger: drops) { content, pose in
                content
                    .opacity(pose.opacity)
                    .scaleEffect(pose.scale)
                    .offset(x: pose.shift, y: pose.shift)
            } keyframes: { _ in
                KeyframeTrack(\.opacity) {
                    MoveKeyframe(0)
                    LinearKeyframe(0, duration: 0.28)
                    LinearKeyframe(1, duration: 0.35)
                }
                KeyframeTrack(\.scale) {
                    MoveKeyframe(1.5)
                    LinearKeyframe(1.5, duration: 0.28)
                    CubicKeyframe(1, duration: 0.35)
                }
                KeyframeTrack(\.shift) {
                    MoveKeyframe(-8)
                    LinearKeyframe(-8, duration: 0.28)
                    CubicKeyframe(0, duration: 0.35)
                }
            }
    }
}
