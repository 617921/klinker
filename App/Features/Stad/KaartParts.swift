import SwiftUI

/// A tapped detail's word, shown over the map for a few seconds.
struct KaartBubble: Equatable {
    let detail: KaartDetail
    let point: CGPoint
    let isNew: Bool
    let id = UUID()

    static func == (a: KaartBubble, b: KaartBubble) -> Bool { a.id == b.id }
}

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

/// The red brievenbus on the quay left of the station, with a count when post is waiting.
struct KaartMailboxButton: View {
    let mail: Int
    let zoom: CGFloat
    let onMail: () -> Void

    private static let point = CGPoint(x: 392, y: 74)

    var body: some View {
        let k = zoom
        Button {
            Haptics.tap()
            onMail()
        } label: {
            LetterMailbox(hasMail: mail > 0)
                .frame(width: 19 * k, height: 26 * k)
                .overlay(alignment: .topTrailing) {
                    if mail > 0 {
                        Text("\(min(mail, 99))")
                            .font(.system(size: 12, weight: .heavy))
                            .foregroundStyle(Theme.ink)
                            .padding(.horizontal, 5)
                            .frame(minWidth: 20, minHeight: 20)
                            .background(Theme.orange, in: Capsule())
                            .overlay(Capsule().stroke(Color.white, lineWidth: 1.5))
                            .offset(x: 14, y: -10)
                    }
                }
                .frame(width: 44, height: 48)
                .contentShape(Rectangle())
        }
        .buttonStyle(KaartPlaceButtonStyle())
        .position(kaartPoint(Self.point.x, Self.point.y, k))
        .accessibilityLabel(mail > 0
            ? "Brievenbus: \(mail) \(mail == 1 ? "nieuwe brief" : "nieuwe brieven")"
            : "Brievenbus: geen nieuwe post")
        .accessibilityHint("Open de anonieme brieven.")
    }
}

/// An uithangbord: a painted board on an iron bracket, with the place's sign on it
/// (world 26 × 22). Grey while the place is fading.
struct KaartShopSign: View, Equatable {
    let n: Int
    let faded: Bool
    let night: Bool
    let zoom: CGFloat

    private static let boards: [UInt32] = [0x2F4B3A, 0x7A1E1E, 0x1F3A6B, 0x2C2C2A, 0x8A5A1E]

    var body: some View {
        let k = zoom
        let f = night ? 0.6 : 1
        let board = StadInk.hex(faded ? 0xB4B2A9 : Gevelkit.shade(Self.boards[n % Self.boards.count], f))
        let paint = faded ? Theme.muted : StadInk.hex(night ? 0xD9CFAE : 0xF4E9CF)
        let iron = StadInk.hex(night ? 0x8A8F9E : 0x1E1E1C)
        ZStack(alignment: .topLeading) {
            Canvas { ctx, _ in
                ctx.scaleBy(x: k, y: k)
                var bracket = Path()
                bracket.move(to: CGPoint(x: 25, y: 2)); bracket.addLine(to: CGPoint(x: 5, y: 2))
                bracket.move(to: CGPoint(x: 25, y: 7)); bracket.addLine(to: CGPoint(x: 17, y: 2))
                bracket.move(to: CGPoint(x: 8, y: 2)); bracket.addLine(to: CGPoint(x: 8, y: 5))
                bracket.move(to: CGPoint(x: 19, y: 2)); bracket.addLine(to: CGPoint(x: 19, y: 5))
                ctx.stroke(bracket, with: .color(iron), style: StrokeStyle(lineWidth: 1.2, lineCap: .round))
                let rect = CGRect(x: 4.5, y: 5, width: 18, height: 15)
                ctx.fill(Path(roundedRect: rect.offsetBy(dx: 0.8, dy: 1), cornerRadius: 2.5), with: .color(StadInk.hex(0x1E1E1C, 0.2)))
                ctx.fill(Path(roundedRect: rect, cornerRadius: 2.5), with: .color(board))
                ctx.stroke(Path(roundedRect: rect.insetBy(dx: 1.4, dy: 1.4), cornerRadius: 1.5), with: .color(paint.opacity(0.7)), lineWidth: 0.6)
            }
            Image(systemName: KaartPlaceView.symbol(n))
                .font(.system(size: max(5, 8 * k), weight: .semibold))
                .foregroundStyle(paint)
                .frame(width: 18 * k, height: 15 * k)
                .offset(x: 4.5 * k, y: 5 * k)
        }
        .frame(width: 26 * k, height: 22 * k, alignment: .topLeading)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
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
            ZStack(alignment: .bottom) {
                Self.house.fill(StadInk.hex(0x9A5238))
                Image(systemName: "lock.fill")
                    .font(.system(size: 7, weight: .bold))
                    .foregroundStyle(StadInk.hex(0xD9A441))
                    .offset(y: -1)
            }
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
            KaartWindRose()
                .frame(width: 40, height: 40)
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// An eight-point wind rose, each point split into a dark and a light half, like old sea charts.
struct KaartWindRose: View {
    var body: some View {
        Canvas { ctx, size in
            let c = CGPoint(x: size.width / 2, y: size.height / 2)
            let r = min(size.width, size.height) / 2
            ctx.fill(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: 2 * r, height: 2 * r)), with: .color(Theme.note))
            ctx.stroke(Path(ellipseIn: CGRect(x: c.x - r + 1, y: c.y - r + 1, width: 2 * r - 2, height: 2 * r - 2)), with: .color(Theme.ink), lineWidth: 1.4)
            ctx.stroke(Path(ellipseIn: CGRect(x: c.x - r + 4, y: c.y - r + 4, width: 2 * r - 8, height: 2 * r - 8)), with: .color(Theme.ink.opacity(0.5)), lineWidth: 0.6)
            for i in 0..<8 {
                let long = i % 2 == 0
                let length = long ? r - 3 : r * 0.55
                let half = long ? r * 0.2 : r * 0.13
                var point = ctx
                point.translateBy(x: c.x, y: c.y)
                point.rotate(by: .degrees(Double(i) * 45))
                var dark = Path()
                dark.move(to: .zero); dark.addLine(to: CGPoint(x: 0, y: -length)); dark.addLine(to: CGPoint(x: half, y: -half)); dark.closeSubpath()
                var light = Path()
                light.move(to: .zero); light.addLine(to: CGPoint(x: 0, y: -length)); light.addLine(to: CGPoint(x: -half, y: -half)); light.closeSubpath()
                let north = i == 0
                point.fill(dark, with: .color(north ? Theme.orange : Theme.ink))
                point.fill(light, with: .color(Theme.note))
                point.stroke(light, with: .color(north ? Theme.orange : Theme.ink), lineWidth: 0.8)
            }
            ctx.fill(Path(ellipseIn: CGRect(x: c.x - 2.2, y: c.y - 2.2, width: 4.4, height: 4.4)), with: .color(Theme.ink))
        }
    }
}
