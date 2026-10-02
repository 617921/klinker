import SwiftUI

/// The picture at the top of the house screen: outside (the facade on its street) or inside (the
/// cutaway), crossfading. Drawn in the prototype's 390 × 440 scene and scaled to fit.
struct HouseStage: View {
    let state: HouseState
    let play: HousePlay
    let store: HouseStore
    let night: Bool
    let scale: CGFloat

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let lights = HouseLights(state: state)
        let inside = play.inside
        ZStack(alignment: .topLeading) {
            HouseSky(night: night, twinkle: !reduceMotion)

            HouseOutside(night: night, lights: lights, onSteen: { play.tapSteen() }, onHenk: { play.tapHenk() })
                .opacity(inside ? 0 : 1)
                .scaleEffect(inside && !reduceMotion ? 1.06 : 1)
                .allowsHitTesting(!inside)
                .accessibilityHidden(inside)

            ZStack(alignment: .topLeading) {
                HouseInteriorDrawing(night: night, lights: lights, ropeVisible: play.hoist == nil || reduceMotion)
                HouseRoomTags()
                HouseRoomsLayer(state: state, play: play, store: store, night: night)
            }
            .opacity(inside ? 1 : 0)
            .scaleEffect(!inside && !reduceMotion ? 0.94 : 1)
            .allowsHitTesting(inside)
            .accessibilityHidden(!inside)
        }
        .frame(width: 390, height: 440, alignment: .topLeading)
        .clipped()
        .animation(.easeInOut(duration: reduceMotion ? 0.25 : 0.45), value: inside)
        .scaleEffect(scale, anchor: .topLeading)
        .frame(width: 390 * scale, height: 440 * scale, alignment: .topLeading)
        .clipShape(RoundedRectangle(cornerRadius: scale < 0.99 ? 3 : 0))
        .overlay(alignment: .topLeading) {
            Group {
                if let caption = play.caption {
                    HouseCaption(text: caption)
                        .transition(.scale(scale: 0.96).combined(with: .opacity))
                } else if play.hoist == nil {
                    HouseViewToggle(inside: inside) { play.toggleView() }
                        .transition(.opacity)
                }
            }
            .padding(.leading, 12)
            .padding(.top, 10)
        }
        .overlay(alignment: .topTrailing) {
            if let toast = play.toast {
                HouseToastCard(toast: toast)
                    .frame(width: min(214, 390 * scale - 150))
                    .padding(.trailing, 10)
                    .padding(.top, 10)
                    .id(toast.id)
                    .transition(.scale(scale: 0.96, anchor: .top).combined(with: .opacity))
                    .allowsHitTesting(false)
            }
        }
        .animation(.easeOut(duration: 0.25), value: play.caption)
    }
}

/// "Naar binnen" / "Naar buiten".
struct HouseViewToggle: View {
    let inside: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: inside ? "house" : "door.left.hand.open")
                    .font(.system(size: 17, weight: .semibold))
                Text(inside ? "Naar buiten" : "Naar binnen")
                    .font(.system(size: 14, weight: .heavy))
            }
            .foregroundStyle(Theme.ink)
            .padding(.leading, 10)
            .padding(.trailing, 14)
            .frame(minHeight: 44)
            .background(Color.white, in: Capsule())
            .shadow(color: Theme.ink.opacity(0.15), radius: 0, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

/// The black note during a hoist: "VIA DE HIJSBALK".
struct HouseCaption: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("VIA DE HIJSBALK")
                .font(Fonts.cta(15))
                .foregroundStyle(HouseInk.hex(0xFAC775))
            Text(text)
                .font(.system(size: 13))
                .foregroundStyle(Theme.onInk)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 10)
        .padding(.top, 8)
        .padding(.bottom, 9)
        .frame(width: 186, alignment: .leading)
        .background(Theme.ink, in: RoundedRectangle(cornerRadius: 3))
        .rotationEffect(.degrees(-1.5))
        .accessibilityElement(children: .combine)
    }
}

/// A note card with a word strip: "De bank staat nu in de woonkamer."
struct HouseToastCard: View {
    let toast: HouseToast

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            PaperStrip(text: toast.label, size: 18, tape: toast.article)
                .rotationEffect(.degrees(-2))
            Text(toast.line)
                .font(.system(size: 14, weight: .heavy))
                .foregroundStyle(Theme.ink)
                .fixedSize(horizontal: false, vertical: true)
            if let sub = toast.sub {
                Text(sub)
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 14)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.note, in: RoundedRectangle(cornerRadius: 3))
        .shadow(color: Theme.ink.opacity(0.2), radius: 8, x: 0, y: 6)
        .rotationEffect(.degrees(1))
        .accessibilityElement(children: .combine)
    }
}
