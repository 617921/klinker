import SwiftUI

/// Het dossier on a corkboard: four pinned suspects in the corners, the latest clue about each one
/// pinned next to them with a red string, a neutral clue in the middle. Tap a suspect to raise
/// your suspicion (0–3 magnifiers).
struct LetterBoard: View {
    let content: LetterContent
    let store: LetterStore
    /// Letter whose clue was just earned (labelled NIEUW).
    var highlight: Int?
    /// Unsolved letter shown as a dashed placeholder when the middle is empty.
    var pending: Int?
    var animateStrings = true
    let onSuspect: (LetterSuspect) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var drawn: CGFloat = 0

    static let size = CGSize(width: 350, height: 690)
    static let cardSize = CGSize(width: 140, height: 160)
    static let noteSize = CGSize(width: 150, height: 84)

    private struct Spot {
        let card: CGPoint
        let cardTilt: Double
        let note: CGPoint
        let noteTilt: Double
        let top: Bool
    }

    private static let spots: [String: Spot] = [
        "henk": Spot(card: CGPoint(x: 10, y: 14), cardTilt: -2, note: CGPoint(x: 22, y: 228), noteTilt: -2, top: true),
        "ria": Spot(card: CGPoint(x: 200, y: 22), cardTilt: 1.5, note: CGPoint(x: 178, y: 236), noteTilt: 2, top: true),
        "sanne": Spot(card: CGPoint(x: 12, y: 516), cardTilt: 1.2, note: CGPoint(x: 24, y: 410), noteTilt: 1.5, top: false),
        "loket4": Spot(card: CGPoint(x: 198, y: 512), cardTilt: -1.5, note: CGPoint(x: 178, y: 402), noteTilt: -1.5, top: false),
    ]
    private static let middle = CGPoint(x: 100, y: 322)

    var body: some View {
        LetterFitWidth(size: CGSize(width: Self.size.width + 16, height: Self.size.height + 16)) { board }
    }

    private var board: some View {
        let earned = earnedClues()
        return ZStack(alignment: .topLeading) {
            LetterCork()
            ForEach(content.suspects) { suspect in
                if let spot = Self.spots[suspect.id], !(earned[suspect.id] ?? []).isEmpty {
                    let ends = stringEnds(spot)
                    LetterString(from: ends.0, to: ends.1)
                        .trim(from: 0, to: animateStrings ? drawn : 1)
                        .stroke(LetterInk.string, style: StrokeStyle(lineWidth: 2.2, lineCap: .round))
                }
            }
            ForEach(content.suspects) { suspect in
                if let spot = Self.spots[suspect.id], let clues = earned[suspect.id], let latest = clues.first {
                    note(latest, more: clues.count - 1, at: spot.note, tilt: spot.noteTilt)
                }
            }
            middleNote(earned[""] ?? [])
            ForEach(content.suspects) { suspect in
                if let spot = Self.spots[suspect.id] {
                    LetterSuspectCard(suspect: suspect, level: store.level(of: suspect.id),
                                      clueCount: earned[suspect.id]?.count ?? 0) { onSuspect(suspect) }
                        .rotationEffect(.degrees(spot.cardTilt))
                        .offset(x: spot.card.x, y: spot.card.y)
                }
            }
            ForEach(content.suspects) { suspect in
                if let spot = Self.spots[suspect.id], !(earned[suspect.id] ?? []).isEmpty {
                    let ends = stringEnds(spot)
                    // Top row: the string runs from the note's pin to a tack on the card;
                    // bottom row: from a tack on the note to the card's pin.
                    tack(at: spot.top ? ends.1 : ends.0).opacity(animateStrings ? Double(drawn) : 1)
                }
            }
        }
        .frame(width: Self.size.width, height: Self.size.height, alignment: .topLeading)
        .padding(8)
        .background(LetterInk.hex(0x7A5230), in: RoundedRectangle(cornerRadius: 4))
        .onAppear {
            guard animateStrings else { return }
            if reduceMotion { drawn = 1 } else { withAnimation(.easeOut(duration: 1.1).delay(0.2)) { drawn = 1 } }
        }
    }

    /// Solved letters' clues by suspect id (newest first); "" holds the neutral ones.
    private func earnedClues() -> [String: [Letter]] {
        var out: [String: [Letter]] = [:]
        let known = Set(content.suspects.map(\.id))
        for letter in content.letters.reversed() where store.clues.contains(letter.number) {
            let id = letter.clue.suspect.flatMap { known.contains($0) ? $0 : nil } ?? ""
            out[id, default: []].append(letter)
        }
        return out
    }

    /// Note end and card end of the red string.
    private func stringEnds(_ spot: Spot) -> (CGPoint, CGPoint) {
        let note = Self.noteSize, card = Self.cardSize
        if spot.top {
            return (CGPoint(x: spot.note.x + note.width / 2, y: spot.note.y + 1),
                    CGPoint(x: spot.card.x + card.width / 2, y: spot.card.y + card.height - 4))
        }
        return (CGPoint(x: spot.note.x + note.width / 2, y: spot.note.y + note.height - 4),
                CGPoint(x: spot.card.x + card.width / 2, y: spot.card.y + 11))
    }

    private func tack(at point: CGPoint) -> some View {
        Circle()
            .fill(LetterInk.string)
            .frame(width: 7, height: 7)
            .shadow(color: .black.opacity(0.3), radius: 1, y: 1)
            .offset(x: point.x - 3.5, y: point.y - 3.5)
            .accessibilityHidden(true)
    }

    private func note(_ letter: Letter, more: Int, at point: CGPoint, tilt: Double) -> some View {
        ZStack {
            ForEach(Array((0..<min(more, 2)).reversed()), id: \.self) { k in
                RoundedRectangle(cornerRadius: 2)
                    .fill(LetterInk.hex(0xF6F0DF))
                    .frame(width: Self.noteSize.width, height: Self.noteSize.height)
                    .shadow(color: LetterInk.hex(0x281400, 0.25), radius: 3, y: 2)
                    .rotationEffect(.degrees(Double(k + 1) * 3.5))
                    .offset(x: CGFloat(k + 1) * 5, y: -CGFloat(k + 1) * 4)
            }
            LetterBoardNote(letter: letter, isNew: letter.number == highlight, more: more)
        }
        .rotationEffect(.degrees(tilt))
        .offset(x: point.x, y: point.y)
    }

    @ViewBuilder
    private func middleNote(_ neutral: [Letter]) -> some View {
        if let latest = neutral.first {
            note(latest, more: neutral.count - 1, at: Self.middle, tilt: -1)
        } else if let pending {
            VStack(alignment: .leading, spacing: 2) {
                LetterCaption(text: "Brief \(pending)", size: 11)
                Text("Nog niet ontcijferd.")
                    .font(.system(size: 13))
                    .foregroundStyle(LetterInk.hex(0x3D2A14))
            }
            .padding(.horizontal, 10)
            .padding(.top, 12)
            .frame(width: Self.noteSize.width, height: Self.noteSize.height, alignment: .topLeading)
            .background(LetterInk.cream.opacity(0.7))
            .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(LetterInk.hex(0x7A5230), style: StrokeStyle(lineWidth: 2, dash: [5, 4])))
            .rotationEffect(.degrees(-1))
            .offset(x: Self.middle.x, y: Self.middle.y)
        }
    }
}

/// One clue note: BRIEF n, kind icon, the clue (short), a yellow pin.
private struct LetterBoardNote: View {
    let letter: Letter
    let isNew: Bool
    let more: Int

    var body: some View {
        let kind = LetterClueKind(letter.clue.kind)
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                LetterCaption(text: isNew ? "Brief \(letter.number) · nieuw" : "Brief \(letter.number)", size: 10.5)
                Spacer(minLength: 0)
                Image(systemName: kind.symbol)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Theme.label)
            }
            Text(letter.clue.text)
                .font(.custom("Didot-Bold", size: 13.5))
                .foregroundStyle(Theme.ink)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, 10)
        .padding(.top, 12)
        .padding(.bottom, 6)
        .frame(width: LetterBoard.noteSize.width, height: LetterBoard.noteSize.height, alignment: .topLeading)
        .background(LetterInk.cream, in: RoundedRectangle(cornerRadius: 2))
        .shadow(color: LetterInk.hex(0x281400, 0.3), radius: 4, y: 3)
        .overlay(alignment: .top) { LetterPin(yellow: true).offset(y: -6) }
        .overlay(alignment: .topTrailing) {
            if more > 0 {
                Text("+\(more)")
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundStyle(Theme.onInk)
                    .padding(.horizontal, 5)
                    .background(Theme.ink, in: Capsule())
                    .offset(x: 6, y: -6)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Aanwijzing uit brief \(letter.number): \(letter.clue.text)")
    }
}

/// A suspect's card: photo, name strip, bio and 0–3 magnifiers.
struct LetterSuspectCard: View {
    let suspect: LetterSuspect
    let level: Int
    let clueCount: Int
    let action: () -> Void

    private static let levels = ["geen verdenking", "een beetje verdacht", "verdacht", "heel verdacht"]

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                LetterPortrait(suspectID: suspect.id)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .clipShape(Rectangle())
                StripView(text: suspect.name, style: suspect.style, size: 12)
                    .rotationEffect(.degrees(-1.5))
                Text(suspect.bio)
                    .font(.system(size: 11.5))
                    .foregroundStyle(Theme.muted)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                Spacer(minLength: 0)
                HStack(spacing: 5) {
                    ForEach(0..<3, id: \.self) { i in
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 13, weight: i < level ? .black : .regular))
                            .foregroundStyle(i < level ? Theme.ink : Theme.dashed)
                    }
                }
            }
            .padding(.top, 18)
            .padding(.horizontal, 7)
            .padding(.bottom, 7)
            .frame(width: LetterBoard.cardSize.width, height: LetterBoard.cardSize.height)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 2))
            .overlay {
                if level == 3 { RoundedRectangle(cornerRadius: 2).strokeBorder(Theme.badLine, lineWidth: 3) }
            }
            .shadow(color: LetterInk.hex(0x281400, 0.3), radius: 4, y: 3)
            .overlay(alignment: .top) { LetterPin().offset(y: 4) }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(suspect.name), \(suspect.role). \(suspect.bio)")
        .accessibilityValue("\(Self.levels[max(0, min(3, level))]). \(clueCount) aanwijzingen.")
        .accessibilityHint("Tik om je verdenking te veranderen.")
        .accessibilityAddTraits(.isButton)
    }
}

/// Shows fixed-size content scaled down to the width on offer (never up).
struct LetterFitWidth<Content: View>: View {
    let size: CGSize
    @ViewBuilder let content: () -> Content

    var body: some View {
        GeometryReader { geo in
            content()
                .frame(width: size.width, height: size.height)
                .scaleEffect(min(1, geo.size.width / size.width), anchor: .topLeading)
        }
        .aspectRatio(size.width / size.height, contentMode: .fit)
        .frame(maxWidth: size.width)
    }
}

/// A sagging red string between two pins.
struct LetterString: Shape {
    let from: CGPoint
    let to: CGPoint

    nonisolated func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: from)
        let mid = CGPoint(x: (from.x + to.x) / 2 + 6, y: (from.y + to.y) / 2 + 10)
        p.addQuadCurve(to: to, control: mid)
        return p
    }
}

/// Cork: warm gradient with fine light and dark specks.
struct LetterCork: View {
    var body: some View {
        Canvas { ctx, size in
            let rect = CGRect(origin: .zero, size: size)
            ctx.fill(Path(rect), with: .radialGradient(
                Gradient(colors: [LetterInk.hex(0xD4A56E), LetterInk.hex(0xB98048)]),
                center: CGPoint(x: size.width * 0.3, y: size.height * 0.2),
                startRadius: 0, endRadius: max(size.width, size.height) * 0.8))
            var seed: UInt64 = 0x9E37_79B9_7F4A_7C15
            func next() -> CGFloat {
                seed = seed &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
                return CGFloat(seed >> 33) / CGFloat(UInt64(1) << 31)
            }
            let count = Int(size.width * size.height / 60)
            for i in 0..<count {
                let x = next() * size.width, y = next() * size.height, r = 0.5 + next() * 0.9
                let color = i % 3 == 0 ? LetterInk.hex(0xFFF0D2, 0.25) : LetterInk.hex(0x46280A, 0.18)
                ctx.fill(Path(ellipseIn: CGRect(x: x, y: y, width: r * 2, height: r * 2)), with: .color(color))
            }
        }
        .overlay {
            Rectangle()
                .strokeBorder(LetterInk.hex(0x3C1E05, 0.35), lineWidth: 10)
                .blur(radius: 8)
        }
        .clipShape(Rectangle())
        .accessibilityHidden(true)
    }
}
