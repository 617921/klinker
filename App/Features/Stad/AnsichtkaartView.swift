import SwiftUI

/// One postcard, big: tap to turn it over, share it, close. When it's new, Ria rings her bell
/// and reads the greeting.
struct AnsichtkaartView: View {
    let buurt: Buurt
    var isNew = false

    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var flipped = false
    @State private var shareImage: Image?

    var body: some View {
        VStack(spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    CourierLabel(text: isNew ? "Ria brengt een ansichtkaart!" : "Ansichtkaart · \(buurt.id) van \(Buurt.all.count)")
                    Text(buurt.title)
                        .font(.system(size: 24, weight: .heavy))
                        .tracking(-0.4)
                        .foregroundStyle(Theme.ink)
                        .accessibilityAddTraits(.isHeader)
                }
                Spacer(minLength: 8)
                CircleIconButton(systemName: "xmark", label: "Sluiten") { dismiss() }
            }

            Spacer(minLength: 0)
            card
                .onTapGesture { turn() }
                .accessibilityAddTraits(.isButton)
                .accessibilityHint("Tik om de kaart om te draaien.")

            HStack(spacing: 12) {
                Button(action: turn) {
                    Label(flipped ? "Voorkant" : "Draai om", systemImage: "arrow.triangle.2.circlepath")
                }
                .buttonStyle(OutlineButtonStyle())
                if let shareImage {
                    ShareLink(item: shareImage, preview: SharePreview(buurt.title, image: shareImage)) {
                        Label("Deel", systemImage: "square.and.arrow.up")
                    }
                    .buttonStyle(OutlineButtonStyle())
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.top, 22)
        .background(Theme.paper)
        .presentationDetents([.large])
        .presentationBackground(Theme.paper)
        .onAppear(perform: appear)
    }

    private var card: some View {
        ZStack {
            AnsichtkaartFront(buurt: buurt)
                .opacity(flipped ? 0 : 1)
            AnsichtkaartBack(buurt: buurt)
                .rotation3DEffect(.degrees(reduceMotion ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                .opacity(flipped ? 1 : 0)
        }
        .rotation3DEffect(.degrees(flipped && !reduceMotion ? 180 : 0), axis: (x: 0, y: 1, z: 0), perspective: 0.4)
    }

    private func turn() {
        KlinkerAudio.shared.play(.paper)
        Haptics.tap()
        withAnimation(reduceMotion ? .easeInOut(duration: 0.2) : .spring(response: 0.55, dampingFraction: 0.8)) { flipped.toggle() }
    }

    private func appear() {
        AnsichtkaartStore.shared.markSeen(buurt.id)
        if isNew {
            KlinkerAudio.shared.play(.bikeBell)
            Speech.shared.say(buurt.title, after: 0.9)
            Haptics.success()
        }
        let renderer = ImageRenderer(content: AnsichtkaartFront(buurt: buurt).frame(width: 600, height: 400).padding(20).background(Color.white))
        renderer.scale = 2
        if let image = renderer.uiImage { shareImage = Image(uiImage: image) }
    }
}

/// The postcards row in the Vandaag panel: the ones you have, and an empty slot for each
/// neighbourhood still to finish.
struct AnsichtkaartenRow: View {
    @Environment(ProgressStore.self) private var progress
    @State private var open: Buurt?

    var body: some View {
        let statuses = (1...ContentStore.totalSheets).map { progress.status(ofSheet: $0) }
        let store = AnsichtkaartStore.shared
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Buurt.all) { buurt in
                    if buurt.isComplete(statuses) {
                        Button {
                            KlinkerAudio.shared.play(.paper)
                            open = buurt
                        } label: {
                            AnsichtkaartFront(buurt: buurt)
                                .frame(width: 168, height: 112)
                                .overlay(alignment: .topTrailing) {
                                    if !store.seen.contains(buurt.id) {
                                        Text("nieuw")
                                            .font(.system(size: 13, weight: .heavy))
                                            .foregroundStyle(Theme.ink)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 2)
                                            .background(Theme.orange, in: Capsule())
                                            .rotationEffect(.degrees(3))
                                            .offset(x: 6, y: -8)
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Ansichtkaart: \(buurt.title)")
                    } else {
                        slot(buurt, left: buurt.left(statuses))
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 2)
        }
        .sheet(item: $open) { buurt in
            AnsichtkaartView(buurt: buurt)
        }
    }

    private func slot(_ buurt: Buurt, left: Int) -> some View {
        VStack(spacing: 4) {
            Image(systemName: "envelope")
                .font(.system(size: 18, weight: .semibold))
            Text(buurt.name)
                .font(.custom("Baskerville-SemiBoldItalic", size: 15))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(left == 1 ? "Nog 1 plek" : "Nog \(left) plekken")
                .font(Fonts.body(12))
        }
        .foregroundStyle(Theme.muted)
        .padding(.horizontal, 8)
        .frame(width: 168, height: 112)
        .overlay(RoundedRectangle(cornerRadius: 3).strokeBorder(Theme.dashed, style: StrokeStyle(lineWidth: 2, dash: [6, 4])))
        .accessibilityElement(children: .combine)
    }
}
