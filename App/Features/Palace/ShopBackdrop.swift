import SwiftUI

/// The shop interior that the bakery, the supermarket and the pharmacy share: a window onto the
/// canal on the left, a wall of shelves (two shelves of three bays), a counter in front of it and
/// a tiled floor. The slots are shared, so a new shop only needs a look and lines in anchors.json.
/// Things on the glass hang in `window`; goods without a word fill free bays as `decor`.
enum PalaceShop {
    static let noor = CGPoint(x: 214, y: 290)

    nonisolated static let slots: [String: PalaceSlot] = [
        "window": PalaceSlot(frame: CGRect(x: 18, y: 42, width: 84, height: 92), pin: CGPoint(x: 60, y: 137), align: .center, tilt: -1.5),
        "shelfTopLeft": PalaceSlot(frame: CGRect(x: 121, y: 22, width: 76, height: 50), pin: CGPoint(x: 120, y: 68), tilt: -1.5),
        "shelfTopMid": PalaceSlot(frame: CGRect(x: 203, y: 22, width: 76, height: 50), pin: CGPoint(x: 241, y: 68), align: .center, tilt: 1.5),
        "shelfTopRight": PalaceSlot(frame: CGRect(x: 285, y: 22, width: 76, height: 50), pin: CGPoint(x: 364, y: 68), align: .trailing, tilt: 1),
        "shelfLeft": PalaceSlot(frame: CGRect(x: 121, y: 100, width: 76, height: 50), pin: CGPoint(x: 120, y: 146), tilt: 1.5),
        "shelfMid": PalaceSlot(frame: CGRect(x: 203, y: 100, width: 76, height: 50), pin: CGPoint(x: 241, y: 146), align: .center, tilt: -1.5),
        "shelfRight": PalaceSlot(frame: CGRect(x: 285, y: 100, width: 76, height: 50), pin: CGPoint(x: 364, y: 146), align: .trailing, tilt: -1),
        "counterLeft": PalaceSlot(frame: CGRect(x: 118, y: 178, width: 78, height: 54), pin: CGPoint(x: 116, y: 228), tilt: -1),
        "counterMid": PalaceSlot(frame: CGRect(x: 200, y: 174, width: 84, height: 58), pin: CGPoint(x: 242, y: 228), align: .center, tilt: 1.5),
        "counterRight": PalaceSlot(frame: CGRect(x: 288, y: 178, width: 76, height: 54), pin: CGPoint(x: 366, y: 228), align: .trailing, tilt: -1.5),
        "floorLeft": PalaceSlot(frame: CGRect(x: 8, y: 232, width: 92, height: 166), pin: CGPoint(x: 4, y: 368), tilt: -1.5),
        "floorMid": PalaceSlot(frame: CGRect(x: 112, y: 300, width: 82, height: 98), pin: CGPoint(x: 153, y: 370), align: .center, tilt: 1.5),
        "floorRight": PalaceSlot(frame: CGRect(x: 290, y: 282, width: 74, height: 118), pin: CGPoint(x: 366, y: 336), align: .trailing, tilt: -2),
    ]
}

/// Colours of one shop and the houses across the canal.
nonisolated struct ShopLook: Sendable {
    let wall: UInt32
    let trim: UInt32
    let shelf: UInt32
    let shelfBack: UInt32
    let counterTop: UInt32
    let counterFront: UInt32
    let panel: UInt32
    let floor: UInt32
    let tile: UInt32
    /// "wood" panels, "belt" (supermarket checkout) or "cross" (pharmacy).
    let counter: String
    let houses: [PalaceHouse]

    static func of(_ type: PalaceRoomType) -> ShopLook {
        switch type {
        case .supermarket: supermarket
        case .pharmacy: pharmacy
        default: bakery
        }
    }

    static let bakery = ShopLook(
        wall: 0xF1E2C4, trim: 0x7A5230, shelf: 0x9A6A42, shelfBack: 0xE2C9A0, counterTop: 0xEFEBE2,
        counterFront: 0x8C5E38, panel: 0x7A5230, floor: 0xE6CDB0, tile: 0xC98B5E, counter: "wood",
        houses: [
            PalaceHouse(type: .klok, width: 62, floors: 3, cols: 2, doorLeft: false, shop: true, flowers: false,
                        color: 0x9A5238, door: 0x1F3A6B, awning: 0x0F6E56),
            PalaceHouse(type: .trap, width: 62, floors: 3, cols: 2, doorLeft: true, shop: false, flowers: true,
                        color: 0xD9CDB4, door: 0x2F4B3A, awning: 0xC8261B),
        ])

    static let supermarket = ShopLook(
        wall: 0xE9ECE8, trim: 0x0F6E56, shelf: 0x8E9AA0, shelfBack: 0xD6DDD9, counterTop: 0x3E4C55,
        counterFront: 0xDCE3DF, panel: 0x0F6E56, floor: 0xE2DED3, tile: 0xCFCBC0, counter: "belt",
        houses: [
            PalaceHouse(type: .hals, width: 62, floors: 3, cols: 2, doorLeft: true, shop: false, flowers: true,
                        color: 0x5E6B73, door: 0x7A1E1E, awning: 0x2F4B3A),
            PalaceHouse(type: .lijst, width: 62, floors: 3, cols: 2, doorLeft: false, shop: true, flowers: false,
                        color: 0x7B3F2E, door: 0x24533F, awning: 0xFAC775),
        ])

    static let pharmacy = ShopLook(
        wall: 0xE4EEE8, trim: 0x0F6E56, shelf: 0xF4F1EA, shelfBack: 0xC9DDD3, counterTop: 0xFFFDF6,
        counterFront: 0x0F6E56, panel: 0x0C5A46, floor: 0xE8E2D2, tile: 0xD3CCBA, counter: "cross",
        houses: [
            PalaceHouse(type: .tuit, width: 62, floors: 3, cols: 2, doorLeft: false, shop: false, flowers: true,
                        color: 0xD9CDB4, door: 0x1F3A6B, awning: 0xC8261B),
            PalaceHouse(type: .klok, width: 62, floors: 3, cols: 2, doorLeft: true, shop: true, flowers: false,
                        color: 0x7B3F2E, door: 0x2F4B3A, awning: 0x1F3A6B),
        ])
}

/// A shop: wall, shelves, counter and floor, with the canal outside the window.
struct ShopBackdrop: View, Equatable {
    let type: PalaceRoomType

    var body: some View {
        let look = ShopLook.of(type)
        ZStack(alignment: .topLeading) {
            PalaceArtwork(marks: Self.room(type), width: 370, height: 408)
            PalaceCanalWindow(houses: PalaceCanal.row(look.houses)).palaceAt(18, 36)
            PalaceArtwork(marks: Self.windowFrame(look), width: 370, height: 408)
        }
        .frame(width: 370, height: 408, alignment: .topLeading)
        .accessibilityHidden(true)
    }

    private static let bakeryRoom = marks(.bakery)
    private static let supermarketRoom = marks(.supermarket)
    private static let pharmacyRoom = marks(.pharmacy)

    private static func room(_ type: PalaceRoomType) -> [PalaceMark] {
        switch type {
        case .supermarket: supermarketRoom
        case .pharmacy: pharmacyRoom
        default: bakeryRoom
        }
    }

    nonisolated static func marks(_ l: ShopLook) -> [PalaceMark] {
        wall(l) + shelves(l) + floor(l) + counter(l)
    }

    private nonisolated static func wall(_ l: ShopLook) -> [PalaceMark] {
        var dentils = ""
        for x in stride(from: 4, to: 370, by: 10) { dentils += "M\(x) 14h5v4h-5Z" }
        return [
            .f("M0 0H370V256H0Z", l.wall),
            .f("M0 0H370V14H0Z", l.trim),
            .f("M0 14H370V18H0Z", PalaceInk.shade(l.wall, 0.93)),
            .f(dentils, l.trim),
            .f("M0 18H370V21H0Z", 0x1E1E1C, 0.07),
            .f("M10 28H110V224H10Z", l.trim),
        ]
    }

    /// Two shelves of three bays (x 121–197, 203–279, 285–361), boards at y 72 and 150.
    private nonisolated static func shelves(_ l: ShopLook) -> [PalaceMark] {
        let dark = PalaceInk.shade(l.shelf, 0.8)
        var boards = "", shadows = "", posts = ""
        for y in [72.0, 150, 208] {
            boards += "M116 \(y)H366V\(y + 6)H116Z"
            shadows += "M120 \(y + 6)H362V\(y + 9)H120Z"
        }
        for x in [116.0, 198, 280, 362] { posts += "M\(x) 20H\(x + 5)V232H\(x)Z" }
        return [
            .f("M116 20H367V232H116Z", l.shelfBack),
            .f("M116 20H367V26H116Z", 0x1E1E1C, 0.06),
            .f(shadows, 0x1E1E1C, 0.12),
            .f(posts, l.shelf),
            .f(boards, l.shelf),
            .s("M116 78.5H366M116 156.5H366M116 214.5H366", dark, 1),
        ]
    }

    private nonisolated static func floor(_ l: ShopLook) -> [PalaceMark] {
        var tiles = ""
        for r in 0..<7 {
            for c in 0..<17 where (r + c) % 2 == 0 {
                tiles += "M\(c * 23 - 6) \(254 + r * 23)h23v23h-23Z"
            }
        }
        return [
            .f("M0 252H370V408H0Z", l.floor),
            .f(tiles, l.tile, 0.55),
            .f("M0 248H116V254H0Z", l.trim),
            .f("M0 254H116V256H0Z", 0x1E1E1C, 0.1),
        ]
    }

    private nonisolated static func counter(_ l: ShopLook) -> [PalaceMark] {
        var out: [PalaceMark] = [
            .f("M112 302H370V308H112Z", 0x1E1E1C, 0.1),
            .f("M112 238H370V302H112Z", l.counterFront),
            .f("M110 230H370V239H110Z", l.counterTop),
            .f("M110 239H370V242H110Z", 0x1E1E1C, 0.16),
            .f("M112 296H370V302H112Z", PalaceInk.shade(l.counterFront, 0.7)),
        ]
        switch l.counter {
        case "belt":
            var ribs = ""
            for x in stride(from: 116, to: 366, by: 9) { ribs += "M\(x) 231.5V237.5" }
            out += [
                .s(ribs, 0x2E3A42, 1.2),
                .f("M112 250H370V262H112Z", l.panel),
                .f("M112 262H370V264H112Z", 0x1E1E1C, 0.12),
                .f("M124 272H190V290H124Z M202 272H268V290H202Z M280 272H346V290H280Z", PalaceInk.shade(l.counterFront, 0.94)),
                .s("M358 238V296", PalaceInk.shade(l.counterFront, 0.85), 2),
            ]
        case "cross":
            out += [
                .f("M122 248H228V290H122Z M234 248H360V290H234Z", l.panel),
                .f("M134 254H164V284H134Z", 0xFFFDF6),
                .f("M145 257H153V265H161V273H153V281H145V273H137V265H145Z", 0x1E7A4C),
            ]
        default:
            out += [
                .f("M120 248H178V290H120Z M186 248H244V290H186Z M252 248H310V290H252Z M318 248H370V290H318Z", l.panel),
                .s("M124 252H174V286H124Z M190 252H240V286H190Z M256 252H306V286H256Z M322 252H370V286H322Z",
                   PalaceInk.shade(l.panel, 1.25), 1),
            ]
        }
        return out
    }

    /// Glazing bars and sill drawn over the canal view.
    nonisolated static func windowFrame(_ l: ShopLook) -> [PalaceMark] {
        [
            .s("M18 36H102V216H18Z", PalaceInk.shade(l.trim, 0.8), 1.5),
            .f("M18 138H102V142H18Z", l.trim),
            .f("M24 214L58 140H66L32 214Z", 0xFFFFFF, 0.12),
            .f("M6 218H114V226H6Z", PalaceInk.shade(l.wall, 0.9)),
            .f("M8 226H112V229H8Z", 0x1E1E1C, 0.12),
        ]
    }
}
