import SwiftUI

/// One of the ten magazine cut-out looks. Every word keeps one style forever.
struct StripStyle {
    let background: Color
    let foreground: Color
    let fontName: String
    let uppercase: Bool
    let tracking: CGFloat
    let edge: Bool

    static let all: [StripStyle] = [
        StripStyle(background: Color(hex: 0x1E1E1C), foreground: Color(hex: 0xF4F1EA), fontName: "AvenirNext-Heavy", uppercase: true, tracking: 0.5, edge: false),
        StripStyle(background: Color(hex: 0xF6EBD9), foreground: Color(hex: 0xC8261B), fontName: "Didot-Bold", uppercase: false, tracking: 0, edge: false),
        StripStyle(background: Color(hex: 0xF4C0D1), foreground: Color(hex: 0x4B1528), fontName: "Futura-CondensedExtraBold", uppercase: true, tracking: 0.5, edge: false),
        StripStyle(background: Color(hex: 0x0F6E56), foreground: Color(hex: 0xE1F5EE), fontName: "Baskerville-SemiBold", uppercase: false, tracking: 0, edge: false),
        StripStyle(background: Color(hex: 0xD9D6CC), foreground: Color(hex: 0x1E1E1C), fontName: "AvenirNextCondensed-DemiBold", uppercase: true, tracking: 1.2, edge: false),
        StripStyle(background: Color(hex: 0x3C3489), foreground: Color(hex: 0xEEEDFE), fontName: "Rockwell-Bold", uppercase: false, tracking: 0, edge: false),
        StripStyle(background: Color(hex: 0xFAC775), foreground: Color(hex: 0x412402), fontName: "AmericanTypewriter-Bold", uppercase: false, tracking: 0, edge: false),
        StripStyle(background: Color.white, foreground: Color(hex: 0x1E1E1C), fontName: "Baskerville-SemiBoldItalic", uppercase: false, tracking: 0, edge: true),
        StripStyle(background: Color(hex: 0xC9E6E2), foreground: Color(hex: 0x04342C), fontName: "AvenirNextCondensed-Heavy", uppercase: true, tracking: 0.5, edge: false),
        StripStyle(background: Color(hex: 0x993556), foreground: Color(hex: 0xFBEAF0), fontName: "BodoniSvtyTwoITCTT-Bold", uppercase: false, tracking: 0, edge: false),
    ]

    static func at(_ index: Int) -> StripStyle {
        all[((index % all.count) + all.count) % all.count]
    }
}

/// Wall sizes by level 0...4 (Nieuw ... Beheerst).
enum WallScale {
    static let sizes: [CGFloat] = [32, 26, 20, 15, 12]
    static let opacities: [Double] = [1, 1, 0.92, 0.7, 0.45]
    static let stageNames = ["Nieuw", "Gezien", "Herkennen", "Onthouden", "Beheerst"]

    static func size(level: Int, word: String) -> CGFloat {
        let base = sizes[max(0, min(4, level))]
        return word.count > 12 ? (base * 0.8).rounded() : base
    }

    static func opacity(level: Int) -> Double { opacities[max(0, min(4, level))] }
}

/// The coloured tape that holds a strip: blue = de, orange = het, grey = other.
struct Tape: View {
    let article: Article
    var width: CGFloat = 30

    var body: some View {
        Rectangle()
            .fill(Theme.tape(article).opacity(0.9))
            .frame(width: width, height: 12)
            .rotationEffect(.degrees(-9))
            .accessibilityHidden(true)
    }
}

/// A collage strip with arbitrary text.
struct StripView: View {
    let text: String
    let style: Int
    var size: CGFloat = 20
    var tape: Article? = nil

    var body: some View {
        let s = StripStyle.at(style)
        Text(s.uppercase ? text.uppercased() : text)
            .font(.custom(s.fontName, size: size))
            .tracking(s.tracking)
            .foregroundStyle(s.foreground)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .padding(.horizontal, (size * 0.32 + 5).rounded())
            .padding(.vertical, (size * 0.14 + 2).rounded())
            .background(s.background)
            .overlay {
                if s.edge { Rectangle().stroke(Color(hex: 0xD3D1C7), lineWidth: 1) }
            }
            .overlay(alignment: .topLeading) {
                if let tape {
                    Tape(article: tape, width: max(18, (size * 0.9 + 6).rounded()))
                        .offset(x: 8, y: -7)
                }
            }
    }
}

/// The calm look for every vocabulary word: one readable font, the word spelled exactly as
/// written (no capitals), on a cream paper strip. Only the tape colour varies (de / het / other).
/// The mixed magazine styles (`StripView`) are kept for the anonymous letters only.
struct PaperStrip: View {
    let text: String
    var size: CGFloat = 20
    var tape: Article? = nil

    static let paper = Color(hex: 0xFBF6EA)
    static let fontName = "AvenirNext-DemiBold"

    var body: some View {
        Text(text)
            .font(.custom(Self.fontName, size: size))
            .foregroundStyle(Theme.ink)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .padding(.horizontal, (size * 0.45 + 4).rounded())
            .padding(.vertical, (size * 0.16 + 2).rounded())
            .background(Self.paper)
            .overlay(Rectangle().stroke(Color(hex: 0xE2DACA), lineWidth: 1))
            .shadow(color: Theme.ink.opacity(0.10), radius: 1.5, x: 0.5, y: 1.5)
            .overlay(alignment: .topLeading) {
                if let tape {
                    Tape(article: tape, width: max(18, (size * 0.9 + 6).rounded()))
                        .offset(x: 8, y: -7)
                }
            }
    }
}

/// A vocabulary word as a paper strip with its article tape.
struct WordStrip: View {
    let word: Word
    var size: CGFloat = 20
    var showTape = true

    var body: some View {
        PaperStrip(text: word.nl, size: size, tape: showTape ? word.article : nil)
            .accessibilityLabel(word.spoken)
    }
}

/// How well a word is known: four dots, empty for a new word, full when mastered
/// (Gezien, Herkennen, Onthouden, Beheerst).
struct LevelDots: View {
    let level: Int
    var dot: CGFloat = 6

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<4, id: \.self) { i in
                Circle()
                    .fill(i < max(0, min(4, level)) ? Theme.ink : Color(hex: 0xD9D4C7))
                    .frame(width: dot, height: dot)
            }
        }
        .accessibilityElement()
        .accessibilityLabel(WallScale.stageNames[max(0, min(4, level))])
    }
}

/// Deterministic small tilt for collage items.
enum Tilt {
    static let pattern: [Double] = [-2, 1.5, -1, 2, -1.5, 1, -2.5, 1.5, -1, 2, -1.5]
    static func at(_ index: Int) -> Double { pattern[((index % pattern.count) + pattern.count) % pattern.count] }
}
