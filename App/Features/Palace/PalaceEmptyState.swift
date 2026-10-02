import SwiftUI

/// A place whose words aren't written yet: the room stands ready, empty, with a friendly note.
struct PalaceEmptyState: View {
    let sheetNumber: Int
    let scale: CGFloat
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            PalaceScaledScene(room: PalaceRoom.empty(sheetNumber: sheetNumber), game: nil, scale: scale)
                .frame(maxWidth: .infinity)
                .opacity(0.9)
            VStack(alignment: .leading, spacing: 6) {
                CourierLabel(text: "Nog leeg", size: 12)
                Text("Hier hangen nog geen woorden.")
                    .font(.system(size: 19, weight: .heavy))
                    .foregroundStyle(Theme.ink)
                Text("De woorden voor vel \(sheetNumber) komen later. Leer eerst je huidige vel: dan groeit de stad vanzelf.")
                    .font(Fonts.body(15))
                    .foregroundStyle(Theme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(Theme.note, in: RoundedRectangle(cornerRadius: 3))
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(Theme.dashed, style: StrokeStyle(lineWidth: 2, dash: [6, 4])))
            .rotationEffect(.degrees(0.6))
            Button("Terug naar de stad", action: onClose)
                .buttonStyle(InkButtonStyle())
        }
    }
}
