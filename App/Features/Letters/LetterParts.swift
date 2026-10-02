import SwiftUI

/// Colours for the letter drawings, usable from any isolation.
nonisolated enum LetterInk {
    static func hex(_ value: UInt32, _ opacity: Double = 1) -> Color {
        Color(.sRGB,
              red: Double((value >> 16) & 0xFF) / 255,
              green: Double((value >> 8) & 0xFF) / 255,
              blue: Double(value & 0xFF) / 255,
              opacity: opacity)
    }

    static let envelope = hex(0xE6D5B0)
    static let envelopeShade = hex(0xD8C399)
    static let flap = hex(0xCDB68A)
    static let pocket = hex(0xDCC79F)
    static let envelopeInk = hex(0x4A3510)
    static let cream = hex(0xFFFDF6)
    static let paperNote = hex(0x8A7A5C)
    static let string = hex(0xB3261E)
    static let mailboxRed = hex(0xC8261B)
    static let stampInk = hex(0x2F3E8F)
}

/// A polygon in unit coordinates (0…1), like CSS `clip-path: polygon(…)`.
struct LetterPolygon: Shape {
    let points: [CGPoint]

    nonisolated func path(in rect: CGRect) -> Path {
        var p = Path()
        guard let first = points.first else { return p }
        func map(_ u: CGPoint) -> CGPoint { CGPoint(x: rect.minX + u.x * rect.width, y: rect.minY + u.y * rect.height) }
        p.move(to: map(first))
        for point in points.dropFirst() { p.addLine(to: map(point)) }
        p.closeSubpath()
        return p
    }

    static let flap = LetterPolygon(points: [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0), CGPoint(x: 0.5, y: 0.62)])
    /// The flap on its own (its frame is just the flap).
    static let flapAlone = LetterPolygon(points: [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0), CGPoint(x: 0.5, y: 1)])
    static let bottomFold = LetterPolygon(points: [CGPoint(x: 0, y: 1), CGPoint(x: 0.5, y: 0.44), CGPoint(x: 1, y: 1)])
    static let pocket = LetterPolygon(points: [
        CGPoint(x: 0, y: 0), CGPoint(x: 0.5, y: 0.6), CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 1),
    ])
    static let sealLeft = LetterPolygon(points: [
        CGPoint(x: 0, y: 0), CGPoint(x: 0.46, y: 0), CGPoint(x: 0.56, y: 0.4), CGPoint(x: 0.44, y: 0.62),
        CGPoint(x: 0.54, y: 1), CGPoint(x: 0, y: 1),
    ])
    static let sealRight = LetterPolygon(points: [
        CGPoint(x: 0.46, y: 0), CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 1), CGPoint(x: 0.54, y: 1),
        CGPoint(x: 0.44, y: 0.62), CGPoint(x: 0.56, y: 0.4),
    ])
}

/// The red wax seal with an X. `broken` splits it in two along a crack.
struct LetterWaxSeal: View {
    var size: CGFloat = 56
    var broken = false

    var body: some View {
        if broken {
            ZStack {
                face.clipShape(LetterPolygon.sealLeft).offset(x: -3).rotationEffect(.degrees(-7))
                face.clipShape(LetterPolygon.sealRight).offset(x: 3, y: 1).rotationEffect(.degrees(6))
            }
            .opacity(0.85)
            .accessibilityHidden(true)
        } else {
            face.accessibilityHidden(true)
        }
    }

    private var face: some View {
        ZStack {
            Circle().fill(RadialGradient(
                colors: [LetterInk.hex(0xE0533F), LetterInk.hex(0xA3201A), LetterInk.hex(0x6E120D)],
                center: UnitPoint(x: 0.38, y: 0.32), startRadius: 0, endRadius: size * 0.62))
            Circle().strokeBorder(Color.black.opacity(0.12), lineWidth: size * 0.09)
            Text("X")
                .font(.custom("Baskerville-Italic", size: size * 0.48))
                .foregroundStyle(LetterInk.hex(0xF6D7CF))
                .offset(y: -size * 0.02)
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.3), radius: 2, y: 2)
    }
}

/// A round pushpin (red for suspects, yellow for clues).
struct LetterPin: View {
    var yellow = false
    var size: CGFloat = 14

    var body: some View {
        let colors = yellow
            ? [LetterInk.hex(0xFFE08A), LetterInk.hex(0xE0A100), LetterInk.hex(0x7A5300)]
            : [LetterInk.hex(0xFF8A80), LetterInk.hex(0xC62828), LetterInk.hex(0x7F1D1D)]
        Circle()
            .fill(RadialGradient(colors: colors, center: UnitPoint(x: 0.35, y: 0.35), startRadius: 0, endRadius: size * 0.6))
            .frame(width: size, height: size)
            .shadow(color: .black.opacity(0.35), radius: 1.5, y: 2)
            .accessibilityHidden(true)
    }
}

/// The orange "n nieuw" badge.
struct LetterNewBadge: View {
    let count: Int

    var body: some View {
        Text("\(count) nieuw")
            .font(.system(size: 13, weight: .heavy))
            .foregroundStyle(Theme.ink)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(Theme.orange, in: Capsule())
            .rotationEffect(.degrees(3))
    }
}

/// A round post office stamp: "UTRECHT · 14 OKT" with wavy cancel lines.
struct LetterPostmark: View {
    let text: String
    var color: Color = LetterInk.stampInk

    var body: some View {
        let lines = Self.lines(text)
        HStack(spacing: -6) {
            LetterWaves().stroke(color, style: StrokeStyle(lineWidth: 1.6, lineCap: .round))
                .frame(width: 46, height: 30)
            ZStack {
                Circle().strokeBorder(color, lineWidth: 2)
                Circle().strokeBorder(color, lineWidth: 1).padding(5)
                VStack(spacing: 1) {
                    Text(lines.0).font(Fonts.label(9))
                    Text(lines.1).font(Fonts.label(12))
                }
                .foregroundStyle(color)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .padding(9)
            }
            .frame(width: 72, height: 72)
        }
        .opacity(0.72)
        .rotationEffect(.degrees(-12))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Poststempel: \(text)")
    }

    /// "UTRECHT · 14 OKT" → ("UTRECHT", "14 OKT"); "GEEN POSTZEGEL" → ("GEEN", "POSTZEGEL").
    private static func lines(_ text: String) -> (String, String) {
        let parts = text.components(separatedBy: "·").map { $0.trimmingCharacters(in: .whitespaces) }
        if parts.count > 1 { return (parts[0], parts.dropFirst().joined(separator: " ")) }
        var words = text.split(separator: " ").map(String.init)
        guard words.count > 1, let last = words.popLast() else { return ("", text) }
        return (words.joined(separator: " "), last)
    }
}

/// Three wavy cancel lines.
struct LetterWaves: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        var p = Path()
        for row in 0..<3 {
            let y = rect.minY + rect.height * (0.2 + 0.3 * CGFloat(row))
            p.move(to: CGPoint(x: rect.minX, y: y))
            let steps = 24
            for i in 1...steps {
                let x = rect.minX + rect.width * CGFloat(i) / CGFloat(steps)
                p.addLine(to: CGPoint(x: x, y: y + 2.4 * sin(CGFloat(i) / CGFloat(steps) * .pi * 4)))
            }
        }
        return p
    }
}

/// Shakes left and right (a wrong answer). Bump `travel` by 1 to play it once.
struct LetterShake: GeometryEffect {
    var travel: CGFloat

    nonisolated var animatableData: CGFloat {
        get { travel }
        set { travel = newValue }
    }

    nonisolated func effectValue(size: CGSize) -> ProjectionTransform {
        let fraction = travel - travel.rounded(.down)
        let x = 7 * sin(fraction * .pi * 4) * (1 - fraction)
        return ProjectionTransform(CGAffineTransform(translationX: x, y: 0))
    }
}

/// Unfolds from the top, like a folded letter opening up.
struct LetterUnfold: ViewModifier {
    let folded: Bool

    func body(content: Content) -> some View {
        content
            .scaleEffect(x: folded ? 0.84 : 1, y: folded ? 0.3 : 1, anchor: .top)
            .opacity(folded ? 0 : 1)
    }
}

extension AnyTransition {
    static var letterUnfold: AnyTransition {
        .modifier(active: LetterUnfold(folded: true), identity: LetterUnfold(folded: false))
    }
}

/// A Courier caption that reads well at small sizes (the app's `CourierLabel`, with tracking).
struct LetterCaption: View {
    let text: String
    var color: Color = Theme.label
    var size: CGFloat = 12

    var body: some View {
        Text(text.uppercased())
            .font(Fonts.label(size))
            .foregroundStyle(color)
            .fixedSize(horizontal: false, vertical: true)
    }
}

extension View {
    /// Full screen on iPhone; a sheet where full-screen covers don't exist.
    @ViewBuilder
    func letterCover<Cover: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Cover) -> some View {
        #if os(iOS)
        fullScreenCover(isPresented: isPresented, content: content)
        #else
        sheet(isPresented: isPresented, content: content)
        #endif
    }
}

extension EnvironmentValues {
    /// Lays scroll content out flat (no ScrollView), for still renders of a whole screen.
    @Entry var letterFlatScroll = false
}

/// A vertical ScrollView (flat when `letterFlatScroll` is set).
struct LetterScroll<Content: View>: View {
    @Environment(\.letterFlatScroll) private var flat
    @ViewBuilder let content: () -> Content

    var body: some View {
        if flat {
            VStack(spacing: 0) { content() }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        } else {
            ScrollView { content() }
        }
    }
}
