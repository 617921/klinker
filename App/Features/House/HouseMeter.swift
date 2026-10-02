import SwiftUI

/// The gezelligheidsmeter: total percentage and three objects per room.
struct HouseMeter: View {
    let state: HouseState

    var body: some View {
        let pct = state.score
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                CourierLabel(text: "Gezelligheidsmeter", size: 12)
                Spacer(minLength: 4)
                Text(state.meterText)
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundStyle(Theme.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            HouseMeterBar(fraction: Double(pct) / 100, height: 12)
            HStack(spacing: 4) {
                ForEach(HouseRoom.allCases) { room in
                    let n = min(3, state.count(in: room))
                    Text("\(room.rawValue) \(n)/3")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(n >= 3 ? Theme.okLine : Theme.muted)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    if room != .zolder { Spacer(minLength: 2) }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
        .rotationEffect(.degrees(-0.4))
        .overlay(alignment: .topTrailing) {
            if pct >= 100 {
                StripView(text: "gezellig", style: 9, size: 15, tape: Article.none)
                    .rotationEffect(.degrees(4))
                    .offset(x: -14, y: -24)
                    .transition(.scale(scale: 0.6).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.55), value: pct >= 100)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
    }

    private var accessibilityText: String {
        let rooms = HouseRoom.allCases.map { "\($0.rawValue) \(min(3, state.count(in: $0))) van 3" }.joined(separator: ", ")
        return "Gezelligheidsmeter: \(state.score) procent. \(rooms)."
    }
}

/// A rounded progress bar: orange, green when full.
struct HouseMeterBar: View {
    let fraction: Double
    var height: CGFloat = 12

    var body: some View {
        let f = max(0, min(1, fraction))
        Capsule()
            .fill(Theme.hairline)
            .overlay(alignment: .leading) {
                GeometryReader { geo in
                    Capsule()
                        .fill(f >= 1 ? Theme.okLine : Theme.orange)
                        .frame(width: geo.size.width * f)
                }
            }
            .clipShape(Capsule())
            .frame(height: height)
            .animation(.easeOut(duration: 0.6), value: f)
            .accessibilityHidden(true)
    }
}
