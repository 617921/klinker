import SwiftUI

/// "Jouw spullen": every object, earned or not, in a sideways row of cards.
struct HouseTray: View {
    let state: HouseState
    let play: HousePlay

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Array(HouseCatalog.items.enumerated()), id: \.element.id) { index, item in
                    HouseTrayCard(item: item, index: index, state: state, play: play)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 4)
        }
    }
}

/// One object card: dashed silhouette when locked, lifted when selected, greyed when in the house.
struct HouseTrayCard: View {
    let item: HouseItem
    let index: Int
    let state: HouseState
    let play: HousePlay

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private static let tilts: [Double] = [-1.5, 1, -0.5, 1.5, -1, 0.5]

    var body: some View {
        let unlocked = state.isUnlocked(item)
        let slot = state.slot(of: item)
        let selected = play.selectedID == item.id
        let flying = play.hoist?.item.id == item.id
        let isNew = unlocked && slot == nil && !flying && !state.everPlaced.contains(item.id)
        let still = reduceMotion
        Button { play.pick(item, state: state) } label: {
            VStack(spacing: 3) {
                HouseItemArt(item: item, onFloor: true, locked: !unlocked)
                    .frame(width: 60, height: 45)
                    .opacity(slot != nil || flying ? 0.45 : 1)
                if unlocked {
                    StripView(text: item.word, style: item.style, size: 12, tape: item.article)
                        .frame(maxWidth: 88)
                        .padding(.top, 3)
                }
                Text(note(unlocked: unlocked, slot: slot, selected: selected, flying: flying))
                    .font(.system(size: 11, weight: selected || slot != nil ? .heavy : .medium))
                    .foregroundStyle(selected ? Theme.orangeText : Theme.muted)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 7)
            .padding(.horizontal, 4)
            .padding(.bottom, 5)
            .frame(width: 96, height: 114, alignment: .top)
            .background {
                RoundedRectangle(cornerRadius: 3)
                    .fill(!unlocked ? Color.clear : (slot != nil || flying) ? HouseInk.hex(0xE9E5DA) : Color.white)
            }
            .overlay {
                if !unlocked {
                    RoundedRectangle(cornerRadius: 3)
                        .strokeBorder(Theme.dashed, style: StrokeStyle(lineWidth: 2, dash: [5, 4]))
                } else if selected {
                    RoundedRectangle(cornerRadius: 3).strokeBorder(Theme.ink, lineWidth: 3)
                }
            }
            .overlay(alignment: .topTrailing) {
                if isNew {
                    Text("nieuw")
                        .font(.system(size: 10, weight: .heavy))
                        .foregroundStyle(Theme.ink)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 1)
                        .background(Theme.orange, in: Capsule())
                        .rotationEffect(.degrees(6))
                        .offset(x: 4, y: -6)
                }
            }
            .shadow(color: Theme.ink.opacity(selected ? 0.18 : 0), radius: 7, x: 0, y: 8)
            .rotationEffect(.degrees(selected ? 0 : Self.tilts[index % Self.tilts.count]))
            .offset(y: selected ? -6 : 0)
            .keyframeAnimator(initialValue: 0.0, trigger: play.nudges[item.id, default: 0]) { content, angle in
                content.rotationEffect(.degrees(still ? 0 : angle))
            } keyframes: { _ in
                KeyframeTrack {
                    LinearKeyframe(-4.0, duration: 0.1)
                    LinearKeyframe(4.0, duration: 0.2)
                    LinearKeyframe(0.0, duration: 0.1)
                }
            }
            .animation(.easeOut(duration: 0.2), value: selected)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityText(unlocked: unlocked, slot: slot))
        .accessibilityAddTraits(selected ? .isSelected : [])
    }

    private func note(unlocked: Bool, slot: HouseSlot?, selected: Bool, flying: Bool) -> String {
        if !unlocked { return "Leer vel \(item.unlockSheet) om dit te krijgen" }
        if selected { return "kies een plek" }
        if flying { return "onderweg" }
        if let slot { return slot.room.prep }
        return item.en
    }

    private func accessibilityText(unlocked: Bool, slot: HouseSlot?) -> String {
        if !unlocked { return "Nog op slot. Leer vel \(item.unlockSheet) om dit te krijgen." }
        if let slot { return "\(item.spoken), \(item.verb.rawValue) \(slot.room.prep). Tik voor het woord." }
        return "\(item.spoken), \(item.en). Tik en kies een plek."
    }
}
