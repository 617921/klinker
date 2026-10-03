import SwiftUI

/// Where the map should scroll next, as a content offset.
struct KaartScrollRequest: Equatable {
    var offset: CGPoint
    var animated: Bool
    var token: Int
}

/// Applies scroll requests with `ScrollPosition` where it exists (iOS 18+).
struct KaartScrollDriver: ViewModifier {
    let request: KaartScrollRequest?

    func body(content: Content) -> some View {
        if #available(iOS 18, *) {
            content.modifier(KaartScrollPositionDriver(request: request))
        } else {
            content
        }
    }
}

@available(iOS 18, *)
private struct KaartScrollPositionDriver: ViewModifier {
    let request: KaartScrollRequest?
    @State private var position = ScrollPosition()

    func body(content: Content) -> some View {
        content
            .scrollPosition($position)
            .onChange(of: request) { _, request in
                guard let request else { return }
                // After this update, so a new zoom's content size is laid out first.
                Task {
                    if request.animated {
                        withAnimation(.easeInOut(duration: 0.45)) { position.scrollTo(point: request.offset) }
                    } else {
                        position.scrollTo(point: request.offset)
                    }
                }
            }
    }
}

struct KaartPlaceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// The note that says what the looks of a place mean (shapes, not just colour).
struct KaartLegend: View {
    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 5) {
            GridRow {
                item(.built, "Gebouwd")
                item(.growing, "In aanbouw")
            }
            GridRow {
                item(.current, "Nu bezig")
                item(.fading, "Verbleekt")
            }
            GridRow {
                item(.locked, "Op slot")
            }
        }
        .padding(.horizontal, 11)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(Theme.note, in: RoundedRectangle(cornerRadius: 3))
        .overlay(alignment: .topLeading) {
            Rectangle().fill(Theme.tapeDe.opacity(0.9)).frame(width: 36, height: 12).rotationEffect(.degrees(-6)).offset(x: 16, y: -6)
        }
        .rotationEffect(.degrees(-1))
        .shadow(color: Theme.ink.opacity(0.18), radius: 4, y: 2)
        .allowsHitTesting(false)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Legenda: gebouwd, in aanbouw, nu bezig, verbleekt, op slot")
    }

    private func item(_ status: SheetStatus, _ text: String) -> some View {
        HStack(spacing: 6) {
            KaartLegendIcon(status: status)
                .frame(width: 14, height: 14)
            Text(text.uppercased())
                .font(Fonts.label(11))
                .foregroundStyle(Theme.ink)
        }
    }
}

struct KaartLegendIcon: View {
    let status: SheetStatus

    private static let house = StadSVG.path("M2 13V6l5-4 5 4v7z")
    private static let window = StadSVG.path("M5.5 8h3v3h-3z")
    private static let scaffold = StadSVG.path("M1 5v9M13 5v9M1 8h12M1 11h12")

    var body: some View {
        switch status {
        case .built:
            ZStack {
                Self.house.fill(StadInk.hex(0x9A5238))
                Self.window.fill(StadInk.hex(0xF6D27A))
            }
        case .current:
            Ellipse()
                .strokeBorder(Theme.orange, lineWidth: 2.5)
                .frame(width: 14, height: 9)
        case .growing:
            ZStack {
                Self.house.fill(StadInk.hex(0x9A5238))
                Self.scaffold.stroke(Theme.orange, lineWidth: 1.2)
            }
        case .fading:
            ZStack(alignment: .topTrailing) {
                Self.house.fill(Theme.tapeOther)
                Circle().fill(Theme.orange).frame(width: 6, height: 6).offset(x: 2, y: -2)
            }
        case .locked:
            RoundedRectangle(cornerRadius: 2)
                .strokeBorder(StadInk.hex(0x8E8A80), style: StrokeStyle(lineWidth: 1.5, dash: [3, 2]))
                .frame(width: 14, height: 12)
        }
    }
}

struct KaartCompass: View {
    var body: some View {
        VStack(spacing: 2) {
            Text("N")
                .font(Fonts.label(12))
                .foregroundStyle(Theme.ink)
                .padding(.horizontal, 5)
                .background(Theme.note, in: RoundedRectangle(cornerRadius: 2))
            ZStack {
                Circle().fill(Theme.note)
                Circle().stroke(Theme.ink, lineWidth: 1.5)
                StadSVG.path("M17 5l4.25 11.9h-8.5z").fill(Theme.ink)
                StadSVG.path("M17 29l-4.25-11.9h8.5z").fill(Theme.dashed)
            }
            .frame(width: 34, height: 34)
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
