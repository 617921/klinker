import SwiftUI

/// The eleven word objects of the town hall, drawn in their own boxes (prototype SVGs).
struct GemeentehuisObjectArt: View {
    let art: PalaceArt

    var body: some View {
        switch art {
        case .calendar: PalaceArtwork(marks: Self.calendar, width: 44, height: 50)
        case .wallPhone: PalaceArtwork(marks: Self.phone, width: 44, height: 54)
        case .loketSign: loketSign
        case .permitCard: PalaceArtwork(marks: Self.card, width: 44, height: 44)
        case .inTray: inTray
        case .form: PalaceArtwork(marks: Self.form, width: 44, height: 44)
        case .signature: PalaceArtwork(marks: Self.signature, width: 44, height: 44)
        case .stamp: stamp
        case .idSign: idSign
        case .passport: PalaceArtwork(marks: Self.passport, width: 44, height: 44)
        case .standingDesk: standingDesk
        default: EmptyView()
        }
    }

    // MARK: Objects with lettering

    private var loketSign: some View {
        ZStack(alignment: .topLeading) {
            PalaceArtwork(marks: Self.loket, width: 72, height: 44)
            Text("LOKET").font(.custom("CourierNewPS-BoldMT", fixedSize: 11)).foregroundStyle(Theme.onInk)
                .frame(height: 16).palaceAt(10, 14)
            Text("4").font(.custom("AvenirNext-Heavy", fixedSize: 16)).foregroundStyle(Theme.ink)
                .frame(width: 20, height: 22).palaceAt(44, 11)
        }
        .frame(width: 72, height: 44, alignment: .topLeading)
    }

    private var inTray: some View {
        ZStack(alignment: .topLeading) {
            PalaceArtwork(marks: Self.tray, width: 44, height: 44)
            Text("IN").font(.custom("AvenirNext-Heavy", fixedSize: 10)).foregroundStyle(Theme.onInk)
                .frame(width: 16, height: 11).palaceAt(14, 27)
        }
        .frame(width: 44, height: 44, alignment: .topLeading)
    }

    private var stamp: some View {
        ZStack(alignment: .topLeading) {
            PalaceArtwork(marks: Self.stampMarks, width: 52, height: 44)
            PalaceStampLabel(text: "GELDIG", size: 10)
                .rotationEffect(.degrees(-7))
                .palaceAt(3, 23)
        }
        .frame(width: 52, height: 44, alignment: .topLeading)
    }

    private var idSign: some View {
        ZStack(alignment: .topLeading) {
            PalaceArtwork(marks: Self.idSignMarks, width: 56, height: 44)
            PalaceLettering(lines: ["ID", "VERPLICHT"], font: .custom("AvenirNextCondensed-Heavy", fixedSize: 11),
                            color: PalaceInk.hex(0x7A1A12), width: 46, height: 28, spacing: -2, tracking: 0.3)
                .palaceAt(5, 8)
        }
        .frame(width: 56, height: 44, alignment: .topLeading)
    }

    private var standingDesk: some View {
        ZStack(alignment: .topLeading) {
            PalaceArtwork(marks: Self.deskPaper, width: 58, height: 44)
            PalaceWritingPen().palaceAt(28, 8)
        }
        .frame(width: 58, height: 44, alignment: .topLeading)
    }

    // MARK: Path data (prototype)

    nonisolated static let calendar: [PalaceMark] = {
        var grid = ""
        for r in 0..<4 {
            for c in 0..<5 { grid += String(format: "M%.1f %dh3.5v3h-3.5Z", 8 + Double(c) * 6.2, 22 + r * 6) }
        }
        return [
            .dot(22, 4, 1.6, 0x2E2117),
            .f("M5 9H39V46H5Z", 0xFFFFFF),
            .f("M5 46H39V48H5Z", 0xD3D1C7),
            .f("M5 9H39V18H5Z", 0xC8261B),
            .s("M13 6V12M31 6V12", 0x2E2117, 2, round: true),
            .f(grid, 0xB4B2A9),
            .s("M23 29.5a5.4 4.8 0 1 0 10.8 0a5.4 4.8 0 1 0 -10.8 0", 0xC8261B, 1.8),
        ]
    }()

    nonisolated static let phone: [PalaceMark] = [
        .f("M12 8H32V42H12Z", 0x5E6B73),
        .f("M15 12H29V18H15Z", 0xDCE3DF),
        .f("M16 22h3v2.5h-3Z M20.5 22h3v2.5h-3Z M25 22h3v2.5h-3Z M16 26.5h3v2.5h-3Z M20.5 26.5h3v2.5h-3Z M25 26.5h3v2.5h-3Z M16 31h3v2.5h-3Z M20.5 31h3v2.5h-3Z M25 31h3v2.5h-3Z", 0xEFEBE2),
        .f("M5 9H11V41H5Z M3 7H12V14H3Z M3 36H12V43H3Z", 0x1E1E1C),
        .s("M7 43C6 50 13 51 14 46C15 42 19 44 20 42", 0x1E1E1C, 1.4, round: true),
        .f("M27 33L42 35L40 51L25 49Z", 0xFAC775),
        .s("M29.5 38L37.5 47M37.5 38L29.5 47", 0xB42318, 2.4, round: true),
    ]

    nonisolated static let loket: [PalaceMark] = [
        .f("M4 8H68V36H4Z", 0x1E1E1C),
        .s("M7 11H65V33H7Z", 0xC9A15B, 1),
        .dot(54, 22, 9, 0xFAC775),
    ]

    nonisolated static let card: [PalaceMark] = [
        .f("M11 16H37V34H11Z", 0xF6EBD9),
        .f("M11 16H37V19H11Z", 0x21468B),
        .f("M14 22H21V31H14Z", 0x5E6B73),
        .dot(17.5, 25, 2, 0xE8C4A0),
        .s("M24 23H34M24 26.5H33M24 30H30", 0xB4B2A9, 1.4, round: true),
        .dot(23, 36, 4.5, 0xE8C4A0),
    ]

    nonisolated static let tray: [PalaceMark] = [
        .f("M10 9H36V24H10Z", 0xF6F3EA),
        .f("M8 12L34 10L36 25H9Z", 0xFFFFFF),
        .f("M7 15H35V27H7Z", 0xFFFDF6),
        .s("M11 18H29M11 21H25", 0xB4B2A9, 1.1),
        .f("M3 24H41V27H3Z", 0x3E4C55),
        .f("M5 27H39V38H5Z", 0x5E6B73),
    ]

    nonisolated static let form: [PalaceMark] = [
        .f("M10 16H34L38 34H6Z", 0xFFFFFF),
        .f("M10.5 18H33.5L34.2 21H9.8Z", 0x0F6E56),
        .s("M10 24.5H31M9.3 28H33M8.6 31.5H26", 0xB4B2A9, 1.2),
        .s("M28 30H31V33H28Z", 0x1E1E1C, 0.9),
        .f("M6 34H38V35.5H6Z", 0xE2DED3),
    ]

    nonisolated static let signature: [PalaceMark] = [
        .f("M8 16H34L38 34H4Z", 0xFFFFFF),
        .s("M9 20H30M8.4 23.5H31", 0xD3D1C7, 1.2),
        .s("M8 27.5L11 30.5M11 27.5L8 30.5", 0x1E1E1C, 1.1, round: true),
        .s("M13 31H34", 0x1E1E1C, 1.1),
        .s("M14 30C16 25 18 31 20 27C22 24 23 30 26 28", 0x2F5BD3, 1.4, round: true),
        .s("M25 39L39 25", 0x1E1E1C, 3, round: true),
        .s("M36.5 27.5L39.5 24.5", 0xC8261B, 3.6, round: true),
        .s("M25 39L23.5 40.5", 0xC9A15B, 1.6, round: true),
    ]

    nonisolated static let stampMarks: [PalaceMark] = [
        .f("M3 22H33L36 38H0Z", 0xFFFFFF),
        .s("M2 36H33", 0xD3D1C7, 1.1),
        .dot(46, 10, 5, 0xC8261B),
        .f("M44.5 14H47.5V21H44.5Z", 0x4A3524),
        .f("M40 21H52V29H40Z", 0x2E2117),
        .f("M40 29H52V31H40Z", 0x1E7A4C),
    ]

    nonisolated static let idSignMarks: [PalaceMark] = [
        .f("M3 6H53V38H3Z", 0xFFFFFF),
        .s("M5 8H51V36H5Z", 0xB42318, 2),
    ]

    nonisolated static let passport: [PalaceMark] = [
        .f("M14 16H30V36H14Z", 0x7A1E1E),
        .ring(22, 24, 3.4, 0xC9A15B, 1.2),
        .s("M18 31H26", 0xC9A15B, 1.2),
        .f("M27 3H41V17H27Z", 0xFFFFFF),
        .f("M27 3H41V6.5H27Z", 0xC8261B),
        .s("M31 12a3.2 3.2 0 1 0 1.2 -2.6", 0x1E7A4C, 1.5, round: true),
        .s("M31.2 8.2L32.4 10L30.3 10.7", 0x1E7A4C, 1.3, round: true),
    ]

    nonisolated static let deskPaper: [PalaceMark] = [
        .f("M14 21H44L47 34H11Z", 0xFFFFFF),
        .s("M30 24.5H42M35 28H44M15 31.5H44", 0xD3D1C7, 1.1),
        .s("M17 24.5q1.5 -2 3 0t3 0t3 0t3 0", 0x2F5BD3, 1.2),
        .s("M16 28q1.5 -2 3 0t3 0t3 0t3 0t3 0t3 0", 0x2F5BD3, 1.2),
    ]
}

/// The green "GELDIG" stamp mark.
struct PalaceStampLabel: View {
    let text: String
    var size: CGFloat = 10

    var body: some View {
        Text(text)
            .font(.custom("AvenirNextCondensed-Heavy", fixedSize: size))
            .tracking(0.3)
            .foregroundStyle(Theme.okLine)
            .padding(.horizontal, 3)
            .background(Theme.okBg.opacity(0.6))
            .overlay(Rectangle().stroke(Theme.okLine, lineWidth: 1.5))
            .fixedSize()
            .accessibilityHidden(true)
    }
}

/// The pen at the standing desk that keeps writing.
struct PalaceWritingPen: View {
    @State private var writing = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    static let marks: [PalaceMark] = [
        .s("M2 16L13 5", 0x1E1E1C, 2.6, round: true),
        .s("M11.5 6.5L15 3", 0x2F5BD3, 3, round: true),
    ]

    var body: some View {
        PalaceArtwork(marks: Self.marks, width: 18, height: 18)
            .offset(x: writing ? 8 : 0, y: writing ? 1 : 0)
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) { writing = true }
            }
    }
}
