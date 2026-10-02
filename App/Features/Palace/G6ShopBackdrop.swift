import SwiftUI

/// Two more looks for the shared shop interior (ShopBackdrop.swift, same slots and Noor spot):
/// a second-hand shop with old wood and a rag rug, and a news kiosk in navy with a striped awning.
extension ShopLook {
    nonisolated static let g6Thrift = ShopLook(
        wall: 0xEFE4CF, trim: 0x7B3F2E, shelf: 0x8C6A4A, shelfBack: 0xDCC9A6, counterTop: 0xE9DCC0,
        counterFront: 0x6B4A2E, panel: 0x7B3F2E, floor: 0xDCC6A2, tile: 0xB98B5E, counter: "wood",
        houses: [
            PalaceHouse(type: .hals, width: 62, floors: 3, cols: 2, doorLeft: true, shop: true, flowers: false,
                        color: 0x3F5A4A, door: 0x7A1E1E, awning: 0xFAC775),
            PalaceHouse(type: .trap, width: 62, floors: 3, cols: 2, doorLeft: false, shop: false, flowers: true,
                        color: 0xE3D6BC, door: 0x1F3A6B, awning: 0xC8261B),
        ])

    nonisolated static let g6Kiosk = ShopLook(
        wall: 0xE6ECEE, trim: 0x1F3A6B, shelf: 0x5E6B73, shelfBack: 0xD3DCE0, counterTop: 0xF4F1EA,
        counterFront: 0x1F3A6B, panel: 0x2B4C86, floor: 0xE2DED3, tile: 0xC9C4B8, counter: "wood",
        houses: [
            PalaceHouse(type: .klok, width: 62, floors: 3, cols: 2, doorLeft: false, shop: false, flowers: true,
                        color: 0x9A5238, door: 0x2F4B3A, awning: 0xC8261B),
            PalaceHouse(type: .lijst, width: 62, floors: 3, cols: 2, doorLeft: true, shop: true, flowers: false,
                        color: 0xD9CDB4, door: 0x7A1E1E, awning: 0x1F3A6B),
        ])
}

/// The shop interior in a g6 look, with a few touches of its own (a rag rug, an awning edge).
struct G6ShopBackdrop: View, Equatable {
    let type: PalaceRoomType

    var body: some View {
        let kiosk = type == .g6Kiosk
        let look: ShopLook = kiosk ? .g6Kiosk : .g6Thrift
        ZStack(alignment: .topLeading) {
            PalaceArtwork(marks: kiosk ? Self.kioskRoom : Self.thriftRoom, width: 370, height: 408)
            PalaceCanalWindow(houses: PalaceCanal.row(look.houses)).palaceAt(18, 36)
            PalaceArtwork(marks: ShopBackdrop.windowFrame(look), width: 370, height: 408)
        }
        .frame(width: 370, height: 408, alignment: .topLeading)
        .accessibilityHidden(true)
    }

    private nonisolated static let thriftRoom: [PalaceMark] = ShopBackdrop.marks(.g6Thrift) + rug
    private nonisolated static let kioskRoom: [PalaceMark] = ShopBackdrop.marks(.g6Kiosk) + awning

    /// A striped rag rug on the wooden floor.
    private nonisolated static let rug: [PalaceMark] = {
        var stripes = ""
        for (i, y) in stride(from: 318.0, to: 392, by: 9).enumerated() where i % 2 == 0 {
            stripes += "M104 \(y)H288V\(y + 4.5)H104Z"
        }
        return [
            .f("M100 314H292V396H100Z", 0xC8261B, 0.55),
            .f(stripes, 0xFAC775, 0.6),
            .s("M100 314H292V396H100Z", 0x7A1E1E, 1.2, 0.5),
        ]
    }()

    /// Red and white scallops along the top, like a kiosk awning.
    private nonisolated static let awning: [PalaceMark] = {
        var red = "", white = ""
        for (i, x) in stride(from: 0.0, to: 370, by: 18.5).enumerated() {
            let d = "M\(x) 0H\(x + 18.5)V12Q\(x + 9.25) 20 \(x) 12Z"
            if i % 2 == 0 { red += d } else { white += d }
        }
        return [.f(red, 0xC8261B), .f(white, 0xFFFDF6), .f("M0 0H370V3H0Z", 0x1E1E1C, 0.15)]
    }()
}
