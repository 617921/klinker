import SwiftUI

/// The town hall itself (everything that is not a word object): the tall window onto the canal,
/// cornice, the door, LOKET 3 and 4 behind glass with the clerk, the ticket machine, the chairs,
/// the standing desk's leg and the plant. Path data copied from the prototype's SVG.
struct GemeentehuisBackdrop: View, Equatable {
    let window: [PalaceWindowHouse]

    static func == (a: Self, b: Self) -> Bool { a.window.map(\.spec) == b.window.map(\.spec) }

    var body: some View {
        ZStack(alignment: .topLeading) {
            PalaceInk.hex(0xE8DDC6)
            PalaceCanalWindow(houses: window).palaceAt(12, 40)
            PalaceArtwork(marks: Self.marks, width: 370, height: 408)
            PalaceLettering(lines: ["LOKET 3"], font: .custom("AvenirNext-Heavy", fixedSize: 11), color: Theme.onInk,
                            width: 62, height: 24)
                .palaceAt(186, 37)
            PalaceLettering(lines: ["TREK EEN", "NUMMER"], font: .custom("AvenirNextCondensed-Heavy", fixedSize: 11),
                            color: Theme.ink, width: 52, height: 26, spacing: -2, tracking: 0.3)
                .palaceAt(10, 232)
            PalaceLettering(lines: ["A23"], font: .custom("CourierNewPS-BoldMT", fixedSize: 11), color: PalaceInk.hex(0xF6D27A), width: 24, height: 16)
                .palaceAt(24, 270)
            PalaceClock().frame(width: 32, height: 32).palaceAt(116, 36)
        }
        .frame(width: 370, height: 408, alignment: .topLeading)
        .accessibilityHidden(true)
    }

    nonisolated static let marks: [PalaceMark] = {
        var dentils = ""
        for x in stride(from: 4, to: 370, by: 10) { dentils += "M\(x) 17h5v4h-5Z" }
        var tiles = ""
        for r in 0..<5 {
            for c in 0..<17 where (r + c) % 2 == 0 {
                tiles += "M\(c * 23 - 6) \(303 + r * 23)h23v23h-23Z"
            }
        }
        return [
            // Window wall with two arched openings, frames and mullions, sill
            .eo("M12 40H96V220H12Z M12 220V59A19 19 0 0 1 50 59V220Z M58 220V59A19 19 0 0 1 96 59V220Z", 0xE8DDC6),
            .s("M12 220V59A19 19 0 0 1 50 59V220Z M58 220V59A19 19 0 0 1 96 59V220Z", 0xEFEBE2, 3),
            .s("M31 42V220M77 42V220M12 100H50M12 160H50M58 100H96M58 160H96", 0xEFEBE2, 2),
            .f("M6 219H102V226H6Z", 0xEFEBE2),
            .f("M8 226H100V229H8Z", 0xD9CDB4),
            // Cornice
            .f("M0 0H370V14H0Z", 0xD9CDB4),
            .f("M0 14H370V17H0Z", 0xEFEBE2),
            .f(dentils, 0xD9CDB4),
            // Wainscot
            .f("M0 252H370V300H0Z", 0x8C5E38),
            .f("M0 249H370V254H0Z", 0x4A3524),
            .f("M6 260H40V292H6Z M48 260H82V292H48Z", 0x7A5230),
            // Door
            .f("M100 90H164V300H100Z", 0xEFEBE2),
            .f("M104 96H131V300H104Z M133 96H160V300H133Z", 0x2F4B3A),
            .f("M108 102H127V160H108Z M137 102H156V160H137Z", 0x3E4C55),
            .f("M110 150L122 104H126L114 150Z M139 150L151 104H155L143 150Z", 0xFFFFFF, 0.18),
            .f("M108 230H127V292H108Z M137 230H156V292H137Z", 0x264034),
            .f("M127 212H130V228H127Z M134 212H137V228H134Z", 0xC9A15B),
            .f("M98 298H166V302H98Z", 0x4A3524),
            // Counter header with LOKET 3
            .f("M162 26H370V72H162Z", 0x7A5230),
            .f("M160 23H370V28H160Z M162 69H370V73H162Z", 0x4A3524),
            .f("M186 37H248V61H186Z", 0x1E1E1C),
            .s("M189 40H245V58H189Z", 0xC9A15B, 1),
            // Behind the glass: office, binders and the clerk
            .f("M170 73H264V222H170Z M270 73H364V222H270Z", 0xDCE3DF),
            .f("M276 106H360V109H276Z", 0xB9C4BF),
            .f("M280 84H287V106H280Z", 0x2F5BD3),
            .f("M288 88H294V106H288Z", 0xC8261B),
            .f("M295 84H301V106H295Z", 0xFAC775),
            .f("M344 86H351V106H344Z", 0x0F6E56),
            .f("M352 82H358V106H352Z", 0x3C3489),
            .f("M294 222C294 200 304 191 318 191C332 191 342 200 342 222Z", 0x3F5A4A),
            .f("M312 192L318 200L324 192Z", 0xFFFFFF),
            .s("M334 204C342 196 346 186 346 174", 0x3F5A4A, 7, round: true),
            .dot(318, 177, 12, 0xE8C4A0),
            .f("M306 175C305 166 311 162 318 162C326 162 331 166 330 175C327 170 323 168 318 168C313 168 309 170 306 175Z", 0xB4B2A9),
            .s("M310.5 178a3.5 3.5 0 1 0 7 0a3.5 3.5 0 1 0 -7 0Z M318.5 178a3.5 3.5 0 1 0 7 0a3.5 3.5 0 1 0 -7 0Z M317.5 178H318.5", 0x1E1E1C, 1.4),
            .s("M313 185Q318 188 323 185", 0x8C5A3C, 1.3, round: true),
            .f("M170 73H264V222H170Z M270 73H364V222H270Z", 0xA9CBE0, 0.16),
            .f("M178 73H192L170 104V90Z M198 73H204L170 122V114Z M278 73H292L270 104V90Z M298 73H304L270 122V114Z", 0xFFFFFF, 0.4),
            .f("M164 73H170V222H164Z M264 73H270V222H264Z M364 73H370V222H364Z", 0x7A5230),
            .f("M196 212H238V222H196Z M296 212H338V222H296Z", 0x2E2117, 0.35),
            // Counter
            .f("M158 222H370V236H158Z", 0xC9965F),
            .f("M158 236H370V242H158Z", 0x6B4A2E),
            .f("M162 242H370V300H162Z", 0x9A6A42),
            .f("M170 250H226V290H170Z M234 250H290V290H234Z M298 250H354V290H298Z M362 250H370V290H362Z", 0x8A5C38),
            .f("M162 294H370V300H162Z", 0x4A3524),
            // Tiled floor
            .f("M0 300H370V408H0Z", 0xEDE6D6),
            .f(tiles, 0xD6CBB4),
            .f("M0 297H100V302H0Z", 0x4A3524),
            // Ticket machine
            .f("M10 232H62V258H10Z", 0xFFFDF6),
            .s("M10 232H62V258H10Z", 0x2E2117, 1.5),
            .f("M22 262H50Q54 262 54 266V334H18V266Q18 262 22 262Z", 0x3F5A4A),
            .f("M24 270H48V286H24Z", 0x232B3B),
            .dot(36, 297, 5, 0xC8261B),
            .f("M27 308H45V311H27Z", 0x1E1E1C),
            .f("M30 311H42V322H30Z", 0xFFFFFF),
            .s("M32 315H40M32 318H38", 0xB4B2A9, 1),
            .f("M14 334H58V340H14Z", 0x2E2117),
            // Waiting chairs
            .f("M58 356H152V359H58Z", 0x1E1E1C, 0.12),
            .f("M62 312H88V332H62Z M92 312H118V332H92Z M122 312H148V332H122Z", 0x1F3A6B),
            .f("M60 332H150V338H60Z", 0x2B4C86),
            .s("M89.5 332V338M120 332V338", 0x1F3A6B, 1.5),
            .s("M64 338V356M86 338V356M94 338V356M116 338V356M124 338V356M146 338V356M60 346H150", 0x2E2117, 2.5),
            // Standing desk
            .f("M184 300H190V354H184Z", 0x4A3524),
            .f("M170 353H204V358H170Z", 0x2E2117),
            .f("M162 286H212L216 300H158Z", 0xC9965F),
            .f("M158 300H216V304H158Z", 0x7A5230),
            // Plant
            .f("M350 360C344 344 330 330 322 300C340 312 352 334 350 360Z", 0x5E8C45),
            .f("M356 360C340 342 336 318 346 296C354 318 360 340 356 360Z", 0x4E7A3A),
            .f("M360 360C360 334 366 314 376 300V360Z", 0x5E8C45),
            .f("M352 362C334 356 322 342 318 326C336 330 348 342 352 362Z", 0x6E9C52),
            .f("M362 362C366 346 374 338 380 334V362Z", 0x4E7A3A),
            .f("M338 364H372V406H342Z", 0xA3410A),
            .f("M335 358H372V366H335Z", 0x8A3B12),
        ]
    }()
}

/// The wall clock: cream face, twelve ticks and hands that show the real time.
struct PalaceClock: View {
    nonisolated static let face: [PalaceMark] = {
        var ticks = ""
        for i in 0..<12 {
            let a = Double(i) * .pi / 6
            let r1 = i % 3 == 0 ? 9.5 : 11
            ticks += String(format: "M%.2f %.2fL%.2f %.2f", 16 + sin(a) * r1, 16 - cos(a) * r1, 16 + sin(a) * 12.5, 16 - cos(a) * 12.5)
        }
        return [
            .dot(16, 16, 14.5, 0xFFFDF6),
            .ring(16, 16, 14.5, 0x2E2117, 3),
            .s(ticks, 0x2E2117, 1.4, round: true),
        ]
    }()

    var body: some View {
        TimelineView(.periodic(from: .now, by: 30)) { context in
            let parts = Calendar.current.dateComponents([.hour, .minute, .second], from: context.date)
            let minutes = Double(parts.minute ?? 0) + Double(parts.second ?? 0) / 60
            let hours = Double((parts.hour ?? 0) % 12) + minutes / 60
            ZStack {
                PalaceArtwork(marks: Self.face, width: 32, height: 32)
                hand(width: 2.5, length: 8, angle: hours * 30)
                hand(width: 2, length: 12, angle: minutes * 6)
                Circle().fill(PalaceInk.hex(0xC8261B)).frame(width: 4, height: 4)
            }
            .frame(width: 32, height: 32)
        }
        .accessibilityHidden(true)
    }

    private func hand(width: CGFloat, length: CGFloat, angle: Double) -> some View {
        RoundedRectangle(cornerRadius: width / 2)
            .fill(PalaceInk.hex(0x2E2117))
            .frame(width: width, height: length)
            .offset(y: -length / 2)
            .rotationEffect(.degrees(angle))
    }
}
