import SwiftUI

/// How far the Vandaag panel is pulled up.
enum VandaagDetent: Int, CaseIterable {
    /// Today's summary and the play button.
    case peek
    /// Plus today's list: current place, fading places, post, house.
    case half
    /// Plus single games, city progress and the street.
    case full

    var spoken: String {
        switch self {
        case .peek: "klein"
        case .half: "half open"
        case .full: "helemaal open"
        }
    }
}

/// The panel over the bottom of the city map, like a drawer: drag the top part (or tap the
/// grabber) between three heights. Only the full height scrolls.
struct VandaagPanel: View {
    @Binding var detent: VandaagDetent
    /// Height of the full panel, from its top to the bottom of the screen.
    let maxHeight: CGFloat
    let bottomInset: CGFloat
    let night: Bool
    let onOpenPlace: (Int) -> Void
    /// Reports the peek height so the map can keep places above it.
    let onPeekHeight: (CGFloat) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var headerHeight: CGFloat = 170
    @State private var todayHeight: CGFloat = 320
    @State private var dragOffset: CGFloat = 0
    @GestureState private var dragging = false

    private static let topID = "vandaag-top"

    private var peek: CGFloat { min(maxHeight, headerHeight + bottomInset) }
    private var half: CGFloat { min(maxHeight, max(peek, headerHeight + todayHeight + bottomInset + 16)) }

    private func height(_ d: VandaagDetent) -> CGFloat {
        switch d {
        case .peek: peek
        case .half: half
        case .full: maxHeight
        }
    }

    private var springy: Animation? {
        reduceMotion ? nil : .spring(response: 0.36, dampingFraction: 0.86)
    }

    var body: some View {
        let rest = height(detent)
        let h = min(maxHeight, max(peek, rest - dragOffset))
        let reveal = half > peek ? min(1, max(0, (h - peek) / (half - peek))) : 1
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                VandaagHeader(detent: detent, onGrabber: cycle, onAdjust: step)
                    .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { headerHeight = $0 }
                    .contentShape(Rectangle())
                    .gesture(drag)

                ScrollView {
                    VStack(alignment: .leading, spacing: 26) {
                        VandaagToday(onOpenPlace: onOpenPlace)
                            .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { todayHeight = $0 }
                            .id(Self.topID)
                        VandaagMore(night: night, active: detent == .full)
                            .opacity(detent == .full ? 1 : min(1, max(0, (h - half) / 80)))
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                    .padding(.bottom, bottomInset + 28)
                }
                .scrollDisabled(detent != .full)
                .scrollBounceBehavior(.basedOnSize)
                .opacity(reveal)
                .accessibilityHidden(detent == .peek)
                .gesture(drag, including: detent == .full ? .subviews : .all)
            }
            .frame(maxWidth: .infinity)
            .frame(height: h, alignment: .top)
            .background(Theme.paper)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20, style: .continuous))
            .shadow(color: Theme.ink.opacity(0.22), radius: 14, y: -2)
            .onChange(of: detent) { _, new in
                if new != .full { proxy.scrollTo(Self.topID, anchor: .top) }
            }
            .onChange(of: dragging) { _, isDragging in
                // A cancelled drag (no onEnded) springs back.
                if !isDragging, dragOffset != 0 { withAnimation(springy) { dragOffset = 0 } }
            }
            .onChange(of: peek, initial: true) { _, value in onPeekHeight(value) }
        }
    }

    private var drag: some Gesture {
        DragGesture(minimumDistance: 8, coordinateSpace: .global)
            .updating($dragging) { _, state, _ in state = true }
            .onChanged { dragOffset = $0.translation.height }
            .onEnded { value in
                let projected = height(detent) - value.predictedEndTranslation.height
                let target = VandaagDetent.allCases.min {
                    abs(height($0) - projected) < abs(height($1) - projected)
                } ?? detent
                if target != detent { Haptics.tap() }
                withAnimation(springy) {
                    detent = target
                    dragOffset = 0
                }
            }
    }

    /// Grabber tap: open to half, or close back to the summary.
    private func cycle() {
        withAnimation(springy) { detent = detent == .peek ? .half : .peek }
        Haptics.tap()
    }

    /// VoiceOver swipe up or down on the grabber.
    private func step(_ up: Bool) {
        let next = VandaagDetent(rawValue: detent.rawValue + (up ? 1 : -1)) ?? detent
        withAnimation(springy) { detent = next }
    }
}

/// Grabber, "Vandaag" summary and the big play button. Always visible.
private struct VandaagHeader: View {
    let detent: VandaagDetent
    let onGrabber: () -> Void
    let onAdjust: (Bool) -> Void

    @Environment(ProgressStore.self) private var progress

    var body: some View {
        let sheet = progress.currentSheet
        let total = sheet?.words.count ?? 0
        let left = max(0, total - progress.metCount(inSheet: progress.currentSheetNumber))
        let reviews = progress.reviewCount()
        let played = progress.wasActive()
        VStack(alignment: .leading, spacing: 14) {
            Button(action: onGrabber) {
                Capsule()
                    .fill(Theme.dashed)
                    .frame(width: 40, height: 5)
                    .frame(maxWidth: .infinity, minHeight: 22)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Vandaag")
            .accessibilityValue(detent.spoken)
            .accessibilityHint("Veeg omhoog of omlaag om meer of minder te zien.")
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment: onAdjust(true)
                case .decrement: onAdjust(false)
                @unknown default: break
                }
            }

            HStack(alignment: .center, spacing: 10) {
                VStack(alignment: .leading, spacing: 3) {
                    CourierLabel(text: "Vandaag")
                    Text(summary(left: left, reviews: reviews))
                        .font(.system(size: 20, weight: .heavy))
                        .tracking(-0.3)
                        .foregroundStyle(Theme.ink)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .accessibilityElement(children: .combine)
                Spacer(minLength: 0)
                if played {
                    Chip(text: "Gespeeld", systemImage: "checkmark", fill: Theme.okBg, foreground: Theme.okText)
                        .accessibilityLabel("Vandaag al gespeeld")
                }
            }

            PlayRoundButton()
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
    }

    private func summary(left: Int, reviews: Int) -> String {
        let new = left == 1 ? "1 nieuw woord" : "\(left) nieuwe woorden"
        switch (left > 0, reviews > 0) {
        case (true, true): return "\(new) · \(reviews) herhalen"
        case (true, false): return new
        case (false, true): return "\(reviews) \(reviews == 1 ? "woord" : "woorden") herhalen"
        case (false, false): return "Alles staat er fris bij"
        }
    }
}
