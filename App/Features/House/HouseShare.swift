import CoreTransferable
import ImageIO
import SwiftUI
import UniformTypeIdentifiers

/// "Deel je huis": the cutaway as a postcard, rendered to an image and shared with the system share sheet.
struct HouseShareSheet: View {
    let state: HouseState
    let night: Bool

    @Environment(\.dismiss) private var dismiss
    @Environment(\.displayScale) private var displayScale
    @State private var rendered: HouseRenderedPostcard?

    var body: some View {
        VStack(spacing: 14) {
            Spacer(minLength: 8)
            HousePostcard(state: state, night: night)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Ansichtkaart: mijn huis in Klinker. \(state.placedCount) spullen in huis, \(state.score) procent gezellig.")
            Spacer(minLength: 8)
            Group {
                if let rendered {
                    ShareLink(item: rendered.file, preview: SharePreview("Mijn huis in Klinker", image: rendered.preview)) {
                        Label("Deel je huis", systemImage: "square.and.arrow.up")
                    }
                } else {
                    Button {} label: { Label("Kaart maken…", systemImage: "hourglass") }
                        .disabled(true)
                }
            }
            .buttonStyle(HouseLightButtonStyle(filled: true))

            Button("Sluiten") { dismiss() }
                .buttonStyle(HouseLightButtonStyle(filled: false))
            Text("Je deelt een plaatje van je huis.")
                .font(Fonts.label(11))
                .foregroundStyle(Theme.onInk.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(HouseInk.hex(0x2B2A27).ignoresSafeArea())
        .task {
            rendered = HouseRenderedPostcard.make(state: state, night: night, scale: displayScale)
        }
    }
}

/// The postcard: the furnished cutaway, a stamp, two tapes, "Mijn huis in Klinker".
struct HousePostcard: View {
    let state: HouseState
    let night: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HouseCutawayStill(state: state, night: night)
                .scaleEffect(0.7487, anchor: .topLeading)
                .offset(y: -22.5)
                .frame(width: 292, height: 307, alignment: .topLeading)
                .clipShape(RoundedRectangle(cornerRadius: 2))
                .overlay(alignment: .bottomLeading) {
                    Text("Noor woont hier")
                        .font(Fonts.label(15))
                        .foregroundStyle(Theme.ink)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.white)
                        .rotationEffect(.degrees(-3))
                        .offset(x: 6, y: -4)
                }
                .overlay(alignment: .topTrailing) {
                    HouseStamp()
                        .rotationEffect(.degrees(6))
                        .offset(x: -8, y: 10)
                }
            HStack(alignment: .bottom, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Mijn huis in Klinker")
                        .font(Fonts.readingItalic(25))
                        .foregroundStyle(Theme.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    Text("NOOR · \(state.placedCount) WOORDEN IN HUIS")
                        .font(Fonts.label(11))
                        .foregroundStyle(Theme.muted)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                Spacer(minLength: 0)
                Text("\(state.score)% gezellig")
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundStyle(Theme.ink)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Theme.orange)
                    .rotationEffect(.degrees(-2))
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 12)
        .padding(.bottom, 14)
        .frame(width: 316)
        .background(Theme.note, in: RoundedRectangle(cornerRadius: 3))
        .overlay(alignment: .topLeading) {
            Rectangle().fill(Theme.tapeHet.opacity(0.9)).frame(width: 54, height: 16)
                .rotationEffect(.degrees(-8)).offset(x: 24, y: -8)
        }
        .overlay(alignment: .topTrailing) {
            Rectangle().fill(Theme.tapeDe.opacity(0.9)).frame(width: 54, height: 16)
                .rotationEffect(.degrees(7)).offset(x: -26, y: -8)
        }
        .shadow(color: .black.opacity(0.3), radius: 14, x: 0, y: 12)
        .rotationEffect(.degrees(-1.5))
    }
}

/// A postage stamp: "682 · NL".
struct HouseStamp: View {
    var body: some View {
        VStack(spacing: 2) {
            Text("682")
                .font(Fonts.cta(17))
                .foregroundStyle(HouseInk.hex(0xC8261B))
            Text("NL")
                .font(Fonts.label(11))
                .foregroundStyle(Theme.ink)
        }
        .frame(width: 52, height: 62)
        .background(Color.white)
        .overlay {
            Rectangle().strokeBorder(HouseInk.hex(0xC8261B), style: StrokeStyle(lineWidth: 2, dash: [4, 3]))
        }
    }
}

/// The furnished cutaway without buttons, for the postcard image.
struct HouseCutawayStill: View {
    let state: HouseState
    let night: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            HouseSky(night: night, twinkle: false)
            HouseInteriorDrawing(night: night, lights: HouseLights(state: state))
            HouseRoomTags()
            HouseLampGlows(state: state, night: night)
            ForEach(HouseCatalog.slots) { slot in
                if let item = state.item(in: slot) {
                    HousePlacedArt(item: item, slot: slot)
                        .houseAt(slot.rect.minX, slot.rect.minY)
                }
            }
        }
        .frame(width: 390, height: 440, alignment: .topLeading)
        .clipped()
    }
}

/// The postcard as a PNG file plus a preview image.
struct HouseRenderedPostcard {
    let file: HousePostcardFile
    let preview: Image

    static func make(state: HouseState, night: Bool, scale: CGFloat) -> HouseRenderedPostcard? {
        let card = HousePostcard(state: state, night: night)
            .padding(28)
            .background(Theme.paper)
        let renderer = ImageRenderer(content: card)
        renderer.scale = max(2, scale)
        guard let image = renderer.cgImage, let png = png(image) else { return nil }
        return HouseRenderedPostcard(file: HousePostcardFile(png: png), preview: Image(decorative: image, scale: renderer.scale))
    }

    private static func png(_ image: CGImage) -> Data? {
        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(data, UTType.png.identifier as CFString, 1, nil) else { return nil }
        CGImageDestinationAddImage(destination, image, nil)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return data as Data
    }
}

/// Shares as a real PNG image ("Mijn huis in Klinker.png").
nonisolated struct HousePostcardFile: Transferable, Sendable {
    let png: Data

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { file in file.png }
            .suggestedFileName("Mijn huis in Klinker.png")
    }
}

/// Light buttons for the dark share screen.
struct HouseLightButtonStyle: ButtonStyle {
    let filled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(filled ? Fonts.cta(17) : .system(size: 16, weight: .heavy))
            .textCase(filled ? .uppercase : nil)
            .foregroundStyle(filled ? Theme.ink : Theme.onInk)
            .frame(maxWidth: 360, minHeight: filled ? 54 : 48)
            .background {
                if filled {
                    RoundedRectangle(cornerRadius: 3).fill(Theme.onInk)
                } else {
                    RoundedRectangle(cornerRadius: 3).strokeBorder(Theme.onInk, lineWidth: 2)
                }
            }
            .rotationEffect(.degrees(filled ? -0.8 : 0))
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
