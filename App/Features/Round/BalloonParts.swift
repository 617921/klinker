import SwiftUI

enum BalloonPalette {
    static let colors: [Color] = [Color(hex: 0xED93B1), Color(hex: 0x5DCAA5), Color(hex: 0xFAC775)]
    static let sky = Color(hex: 0xDCEBF7)
    static let string = Color(hex: 0x8A8A84)

    static func color(_ k: Int) -> Color { colors[((k % colors.count) + colors.count) % colors.count] }
}

/// A balloon: round top, narrowing to the knot at the bottom.
struct BalloonShape: Shape {
    nonisolated func path(in r: CGRect) -> Path {
        let w = r.width, h = r.height
        var p = Path()
        p.move(to: CGPoint(x: r.midX, y: r.maxY))
        p.addCurve(
            to: CGPoint(x: r.minX, y: r.minY + h * 0.42),
            control1: CGPoint(x: r.minX + w * 0.26, y: r.maxY - h * 0.03),
            control2: CGPoint(x: r.minX, y: r.minY + h * 0.72)
        )
        p.addCurve(
            to: CGPoint(x: r.midX, y: r.minY),
            control1: CGPoint(x: r.minX, y: r.minY + h * 0.15),
            control2: CGPoint(x: r.minX + w * 0.22, y: r.minY)
        )
        p.addCurve(
            to: CGPoint(x: r.maxX, y: r.minY + h * 0.42),
            control1: CGPoint(x: r.maxX - w * 0.22, y: r.minY),
            control2: CGPoint(x: r.maxX, y: r.minY + h * 0.15)
        )
        p.addCurve(
            to: CGPoint(x: r.midX, y: r.maxY),
            control1: CGPoint(x: r.maxX, y: r.minY + h * 0.72),
            control2: CGPoint(x: r.maxX - w * 0.26, y: r.maxY - h * 0.03)
        )
        p.closeSubpath()
        return p
    }
}

struct BalloonKnot: Shape {
    nonisolated func path(in r: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: r.midX, y: r.minY))
        p.addLine(to: CGPoint(x: r.maxX, y: r.maxY))
        p.addLine(to: CGPoint(x: r.minX, y: r.maxY))
        p.closeSubpath()
        return p
    }
}

/// A gently wavy string.
struct BalloonString: Shape {
    nonisolated func path(in r: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: r.midX, y: r.minY))
        let steps = 3
        let step = r.height / CGFloat(steps)
        for i in 0..<steps {
            let y0 = r.minY + CGFloat(i) * step
            let side: CGFloat = i.isMultiple(of: 2) ? 1 : -1
            p.addQuadCurve(
                to: CGPoint(x: r.midX, y: y0 + step),
                control: CGPoint(x: r.midX + side * r.width / 2, y: y0 + step / 2)
            )
        }
        return p
    }
}

/// How a balloon looks right now.
enum BalloonLook: Equatable {
    case flying
    case popped
    case wrong
    /// The right answer, ringed after a mistake or a miss.
    case ringed
    /// Another balloon was answered; this one just waits.
    case idle
}

/// One balloon with its meaning, knot and string.
struct BalloonView: View {
    let label: String
    let color: Color
    let width: CGFloat
    let look: BalloonLook

    static func totalHeight(width: CGFloat) -> CGFloat { width * 1.18 + 65 }

    var body: some View {
        let bodyHeight = width * 1.18
        ZStack {
            VStack(spacing: 0) {
                ZStack {
                    BalloonShape().fill(color)
                    // Shine
                    Ellipse()
                        .fill(Color.white.opacity(0.38))
                        .frame(width: width * 0.16, height: bodyHeight * 0.2)
                        .rotationEffect(.degrees(28))
                        .offset(x: -width * 0.26, y: -bodyHeight * 0.24)
                    Text(label)
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundStyle(Theme.ink)
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .minimumScaleFactor(0.6)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 8)
                }
                .frame(width: width, height: bodyHeight)
                .overlay {
                    if look == .ringed {
                        BalloonShape()
                            .stroke(Theme.ink, lineWidth: 4)
                            .padding(-6)
                            .transition(.scale(scale: 1.3).combined(with: .opacity))
                    }
                }
                BalloonKnot()
                    .fill(color)
                    .frame(width: 14, height: 10)
                    .offset(y: -3)
                BalloonString()
                    .stroke(BalloonPalette.string, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .frame(width: 10, height: 55)
            }
            .scaleEffect(scale)
            .rotationEffect(.degrees(look == .wrong ? -12 : 0))
            .opacity(opacity)

            if look == .popped {
                BalloonBurst(color: color)
                    .offset(y: -(Self.totalHeight(width: width) / 2) + bodyHeight / 2)
            }
        }
        .frame(width: width + 12, height: Self.totalHeight(width: width))
    }

    private var scale: CGFloat {
        switch look {
        case .popped: 1.6
        case .wrong: 0.75
        default: 1
        }
    }

    private var opacity: Double {
        switch look {
        case .popped: 0
        case .wrong: 0.35
        case .idle: 0.75
        default: 1
        }
    }
}

/// Confetti bits flying out of a popped balloon.
struct BalloonBurst: View {
    let color: Color
    @State private var out = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { i in
                Capsule()
                    .fill(i.isMultiple(of: 3) ? Theme.ink : color)
                    .frame(width: 4, height: i.isMultiple(of: 2) ? 14 : 9)
                    .offset(y: out ? -(reduceMotion ? 40 : 86) : -24)
                    .rotationEffect(.degrees(Double(i) * 30))
                    .opacity(out ? 0 : 1)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) { out = true }
        }
    }
}

/// Soft white clouds.
struct BalloonClouds: View {
    let size: CGSize

    var body: some View {
        let w = size.width / 390
        let h = max(size.height, 1) / 640
        ZStack(alignment: .topLeading) {
            cloud(x: 28, y: 70, width: 96, height: 30, w: w, h: h)
            cloud(x: 60, y: 56, width: 44, height: 32, w: w, h: h)
            cloud(x: 240, y: 210, width: 110, height: 32, w: w, h: h)
            cloud(x: 270, y: 194, width: 50, height: 34, w: w, h: h)
            cloud(x: 90, y: 420, width: 80, height: 26, w: w, h: h)
        }
        .frame(width: size.width, height: size.height, alignment: .topLeading)
        .accessibilityHidden(true)
    }

    private func cloud(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, w: CGFloat, h: CGFloat) -> some View {
        Capsule()
            .fill(Color.white)
            .frame(width: width * w, height: height)
            .offset(x: x * w, y: y * h)
    }
}
