import SwiftUI

/// The 682 palette: paper, ink and collage accents. Shared by every screen.
enum Theme {
    static let paper = Color(hex: 0xF3F0E8)
    static let ink = Color(hex: 0x1E1E1C)
    static let onInk = Color(hex: 0xF4F1EA)
    static let muted = Color(hex: 0x5F5E5A)
    static let hairline = Color(hex: 0xE2DED3)
    static let card = Color.white
    static let note = Color(hex: 0xFFFDF6)
    static let dashed = Color(hex: 0xC9C4B8)

    static let okBg = Color(hex: 0xE2F4EA)
    static let okText = Color(hex: 0x14532D)
    static let okLine = Color(hex: 0x1E7A4C)
    static let badBg = Color(hex: 0xFDECEA)
    static let badText = Color(hex: 0x7A1A12)
    static let badLine = Color(hex: 0xB42318)

    static let orange = Color(hex: 0xF2711C)
    static let orangeText = Color(hex: 0xA3410A)
    static let label = Color(hex: 0x8A3B12)

    static let tapeDe = Color(hex: 0x2F5BD3)
    static let tapeHet = Color(hex: 0xF2711C)
    static let tapeOther = Color(hex: 0xB4B2A9)

    static let doodles: [Color] = [Color(hex: 0xEF9F27), Color(hex: 0x5DCAA5), Color(hex: 0xED93B1), Color(hex: 0x7F77DD)]

    static func tape(_ article: Article) -> Color {
        switch article {
        case .de: tapeDe
        case .het: tapeHet
        case .none: tapeOther
        }
    }
}

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

/// Fonts. Uses fonts that ship with iOS so the app needs no font files.
enum Fonts {
    /// Small uppercase labels like "VEL 14 / 62".
    static func label(_ size: CGFloat = 13) -> Font { .custom("CourierNewPS-BoldMT", size: size) }
    /// Screen headings.
    static func heading(_ size: CGFloat = 28) -> Font { .system(size: size, weight: .heavy) }
    /// Body copy.
    static func body(_ size: CGFloat = 16) -> Font { .system(size: size) }
    /// Black strip call-to-action buttons.
    static func cta(_ size: CGFloat = 19) -> Font { .custom("AvenirNext-Heavy", size: size) }
    /// Example sentences and story text.
    static func reading(_ size: CGFloat = 18) -> Font { .custom("Baskerville", size: size) }
    static func readingItalic(_ size: CGFloat = 18) -> Font { .custom("Baskerville-Italic", size: size) }
}

/// The black strip CTA: "SPEEL JE RONDE".
struct InkButtonStyle: ButtonStyle {
    var tilt: Double = -0.8
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Fonts.cta())
            .textCase(.uppercase)
            .foregroundStyle(Theme.onInk)
            .frame(maxWidth: .infinity, minHeight: 58)
            .background(Theme.ink, in: RoundedRectangle(cornerRadius: 3))
            .rotationEffect(.degrees(tilt))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// Secondary: outlined ink button.
struct OutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .heavy))
            .foregroundStyle(Theme.ink)
            .frame(maxWidth: .infinity, minHeight: 56)
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(Theme.ink, lineWidth: 2))
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
    }
}

/// 44pt round icon button (close, back, listen).
struct CircleIconButton: View {
    let systemName: String
    let label: String
    var dark = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(dark ? Theme.onInk : Theme.ink)
                .frame(width: 44, height: 44)
                .background(dark ? Theme.ink : Color.white, in: Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}

/// A Courier caption label, e.g. "VEL 14 / 62".
struct CourierLabel: View {
    let text: String
    var color: Color = Theme.label
    var size: CGFloat = 13

    var body: some View {
        Text(text.uppercased())
            .font(Fonts.label(size))
            .foregroundStyle(color)
    }
}

/// A small rounded chip with a count, e.g. "12 dagen".
struct Chip: View {
    let text: String
    var systemImage: String? = nil
    var fill: Color = .white
    var foreground: Color = Theme.ink

    var body: some View {
        HStack(spacing: 6) {
            if let systemImage { Image(systemName: systemImage) }
            Text(text)
        }
        .font(.system(size: 14, weight: .bold))
        .foregroundStyle(foreground)
        .padding(.horizontal, 14)
        .frame(minHeight: 36)
        .background(fill, in: Capsule())
    }
}
