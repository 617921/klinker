import SwiftUI

/// One flat layer of an object drawing (viewBox 0 0 64 48), like one SVG `<path>`.
nonisolated struct HouseLayer: Sendable {
    let path: Path
    let color: UInt32
    /// `nil` fills the path; a width strokes it with round caps.
    let stroke: CGFloat?
}

/// The flat illustrations of the household objects. The first fifteen are the StadHuis prototype's
/// paths verbatim; the rest are drawn in the same style.
nonisolated enum HouseArt {
    static func layers(_ id: String) -> [HouseLayer] { table[id] ?? [] }

    private static func f(_ d: String, _ color: UInt32) -> HouseLayer {
        HouseLayer(path: SVGPath.parse(d), color: color, stroke: nil)
    }

    private static func s(_ d: String, _ color: UInt32, _ width: CGFloat = 2.5) -> HouseLayer {
        HouseLayer(path: SVGPath.parse(d), color: color, stroke: width)
    }

    /// Draws `layers` fitted into `size` (SVG `meet`): bottom-aligned for floor objects, centred for wall
    /// objects, top-aligned for things hanging from the ceiling. Locked objects are a dashed grey silhouette.
    static func draw(_ layers: [HouseLayer], in ctx: inout GraphicsContext, size: CGSize, align: HouseArtAlign, locked: Bool = false) {
        let k = min(size.width / 64, size.height / 48)
        let spare = size.height - 48 * k
        var c = ctx
        c.translateBy(x: (size.width - 64 * k) / 2, y: align == .bottom ? spare : align == .center ? spare / 2 : 0)
        c.scaleBy(x: k, y: k)
        for layer in layers {
            if locked {
                c.stroke(layer.path, with: .color(Ink.hex(0x8E8B83)),
                         style: StrokeStyle(lineWidth: 1.4, lineJoin: .round, dash: [3, 2.5]))
            } else if let width = layer.stroke {
                c.stroke(layer.path, with: .color(Ink.hex(layer.color)),
                         style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
            } else {
                c.fill(layer.path, with: .color(Ink.hex(layer.color)))
            }
        }
    }

    private static let table: [String: [HouseLayer]] = [
        // MARK: From the prototype

        "bank": [
            f("M10 12h44a4 4 0 0 1 4 4v14H6V16a4 4 0 0 1 4-4z", 0x2F6E62),
            f("M9 28h46v9H9z", 0x3C8577),
            f("M2 22a4 4 0 0 1 8 0v19H2z M54 22a4 4 0 0 1 8 0v19h-8z M2 37h60v5H2z", 0x24574D),
            f("M6 42h3v4H6z M55 42h3v4h-3z", 0x2E2117),
            f("M31.5 29h1v8h-1z M31.5 14h1v13h-1z", 0x24574D),
        ],
        "lamp": [
            f("M22 4h20l6 15H16z", 0xFAC775),
            f("M16 17h32v2.5H16z", 0xEF9F27),
            f("M31 19.5h2V43h-2z", 0x2E2117),
            f("M23 43h18v3.5H23z", 0x2E2117),
        ],
        "plant": [
            f("M32 31C21 28 14 17 17 7c7 4 13 12 15 24z M32 31c-2-10-1-21 2-27 4 8 3 19-2 27z", 0x4E7A3A),
            f("M32 31c2-12 8-20 17-23 1 9-5 19-17 23z", 0x6E9C52),
            f("M19 30h26v4H19z", 0xA3410A),
            f("M21 34h22l-3 12H24z", 0xC7772E),
        ],
        "klok": [
            f("M16 22a16 16 0 1 0 32 0a16 16 0 1 0 -32 0z", 0x1E1E1C),
            f("M19 22a13 13 0 1 0 26 0a13 13 0 1 0 -26 0z", 0xFFFDF6),
            f("M31 11h2v3h-2z M31 30h2v3h-2z M21 21h3v2h-3z M40 21h3v2h-3z M31 14h2v9h-2z M32 21h7v2h-7z", 0x1E1E1C),
            f("M30.2 22a1.8 1.8 0 1 0 3.6 0a1.8 1.8 0 1 0 -3.6 0z", 0xC8261B),
        ],
        "bed": [
            f("M4 10h8v36H4z M54 24h6v22h-6z M12 38h42v3H12z", 0x4A3524),
            f("M12 28h42v10H12z", 0xFFFDF6),
            f("M26 24h28v14H26z", 0x7F77DD),
            f("M13 21h11a3 3 0 0 1 3 3v4H13z", 0xF4C0D1),
            f("M26 30h28v2.5H26z", 0x3C3489),
        ],
        "tafel": [
            f("M4 20h56v5H4z", 0xB5824E),
            f("M8 25h4v21H8z M52 25h4v21h-4z M12 28h40v2H12z", 0x8A5A32),
            f("M29 11h6l-1 9h-4z", 0x2F5BD3),
            f("M31.4 6h1.2v5h-1.2z", 0x4E7A3A),
            f("M29 3c0 3 1.2 4.5 3 4.5S35 6 35 3l-1.5 1.5L32 2l-1.5 2.5z", 0xC8261B),
        ],
        "stoel": [
            f("M18 4h4v42h-4z M42 4h4v42h-4z M22 8h20v3H22z M22 14h20v3H22z", 0x24533F),
            f("M15 26h34v5H15z", 0xC9A15B),
            f("M15 31h34v1.5H15z", 0xA88442),
        ],
        "kast": [
            f("M9 2h46v4H9z M13 44h4v3h-4z M47 44h4v3h-4z", 0x4A3524),
            f("M12 6h40v38H12z", 0x6E3A2C),
            f("M16 10h14v30H16z M34 10h14v30H34z", 0x8C4A3A),
            f("M28 26a1.6 1.6 0 1 0 3.2 0a1.6 1.6 0 1 0 -3.2 0z M32.8 26a1.6 1.6 0 1 0 3.2 0a1.6 1.6 0 1 0 -3.2 0z", 0xC9A15B),
        ],
        "kussen": [
            f("M8 28c0-7 5-9 24-9s24 2 24 9v8c0 7-5 9-24 9S8 43 8 36z", 0xED93B1),
            f("M18 32a2 2 0 1 0 4 0a2 2 0 1 0 -4 0z M30 32a2 2 0 1 0 4 0a2 2 0 1 0 -4 0z M42 32a2 2 0 1 0 4 0a2 2 0 1 0 -4 0z", 0x993556),
            s("M8 28l-4-3M56 28l4-3M8 36l-4 3M56 36l4 3", 0x993556),
        ],
        "kat": [
            f("M18 46c-1-12 3-21 12-23 9 2 13 11 12 23z M24 12l1-9 6 5z M40 12l-1-9-6 5z M23 15a9 8 0 1 0 18 0a9 8 0 1 0 -18 0z M42 44c8 1 12-5 10-12-2 4-5 7-10 8z", 0xD9893A),
            f("M27 30h10v2H27z M26 35h12v2H26z M29 8h6v1.6h-6z", 0xA3410A),
            f("M27 46c0-6 2-10 5-10s5 4 5 10z", 0xF6EBD9),
            f("M27.5 15a1.5 1.5 0 1 0 3 0a1.5 1.5 0 1 0 -3 0z M33.5 15a1.5 1.5 0 1 0 3 0a1.5 1.5 0 1 0 -3 0z", 0x1E1E1C),
            f("M30.8 18h2.4l-1.2 1.4z", 0x993556),
        ],
        "fiets": [
            s("M5 34a10 10 0 1 0 20 0a10 10 0 1 0 -20 0z M39 34a10 10 0 1 0 20 0a10 10 0 1 0 -20 0z", 0x1E1E1C),
            s("M15 34L25 20h16l8 14M25 20l8 14H15M41 20l-2-7h-5M33 34l-6-17", 0xC8261B),
            f("M22 15h9v3h-9z", 0x2E2117),
            f("M32 12h6v2.5h-6z", 0x2E2117),
        ],
        "boek": [
            f("M12 37h40v9H12z", 0x2F5BD3),
            f("M16 29h34v8H16z", 0xC8261B),
            f("M20 22h26v7H20z", 0xFAC775),
            f("M48 38.5h3v6h-3z M46 30.5h3v5h-3z M43 23.5h2.5v4H43z M18 40.5h20v2H18z", 0xFFFDF6),
        ],
        "koffiepot": [
            f("M21 17h20l3 27H18z", 0x2F5BD3),
            f("M23 11h16l2 6H21z M29 7h4v4h-4z", 0x1F3A6B),
            f("M42 23l11-8 1 3-9 13z", 0x2F5BD3),
            s("M21 21c-9 0-9 15 0 15", 0x1F3A6B),
            f("M27 27a2 2 0 1 0 4 0a2 2 0 1 0 -4 0z M33 33a2 2 0 1 0 4 0a2 2 0 1 0 -4 0z M27 38a2 2 0 1 0 4 0a2 2 0 1 0 -4 0z", 0xFFFFFF),
        ],
        "spiegel": [
            f("M32 3c10 0 16 9 16 21s-6 21-16 21-16-9-16-21S22 3 32 3z", 0xC9A15B),
            f("M32 7c7.5 0 12 7.5 12 17s-4.5 17-12 17-12-7.5-12-17S24.5 7 32 7z", 0xC9E6E2),
            f("M24 20l7-8h3l-9 10z M26 27l10-12h2L27 29z", 0xFFFFFF),
        ],
        "tapijt": [
            f("M8 30h48l6 14H2z", 0x993556),
            f("M12 33h40l3 8H9z", 0xFAC775),
            f("M18 35h28l1.5 4h-31z", 0x993556),
            s("M4 44v3M10 44v3M16 44v3M22 44v3M28 44v3M34 44v3M40 44v3M46 44v3M52 44v3M58 44v3", 0xC9A15B),
        ],

        // MARK: New, same style

        "prikbord": [
            s("M22 6L32 1L42 6", 0x4A3524, 1.5),
            f("M6 6h52v38H6z", 0x7A5230),
            f("M9 9h46v32H9z", 0xC9965F),
            f("M13 13h15v13H13z", 0xFFFFFF),
            f("M32 12h19v11H32z", 0xFAC775),
            f("M34 27h17v11H34z", 0xC9E6E2),
            f("M14 29h14v9H14z", 0xF4C0D1),
            s("M16 18h9M16 21.5h6M35 17h13M35 20h9M37 32h11M37 35h7", 0x8A3B12, 1),
            f("M18.9 13a1.6 1.6 0 1 0 3.2 0a1.6 1.6 0 1 0 -3.2 0z M39.9 12a1.6 1.6 0 1 0 3.2 0a1.6 1.6 0 1 0 -3.2 0z M40.9 27a1.6 1.6 0 1 0 3.2 0a1.6 1.6 0 1 0 -3.2 0z M19.4 29a1.6 1.6 0 1 0 3.2 0a1.6 1.6 0 1 0 -3.2 0z", 0xC8261B),
        ],
        "bureau": [
            f("M17 8h20v13H17z", 0x2C2C2A),
            f("M19 10h16v9H19z", 0x8FB6CF),
            f("M14 20.5h26v1.5H14z", 0x5E6B73),
            s("M50 21l-4-9l6-5", 0x1E1E1C, 1.6),
            f("M49 4l9 3l-3 6l-8-3z", 0x0F6E56),
            f("M7 15h6v6H7z", 0xC8261B),
            f("M3 22h58v5H3z", 0x7A5230),
            f("M6 27h4v19H6z M38 27h20v19H38z", 0x4A3524),
            f("M40.5 29h15v7h-15z M40.5 37.5h15v7h-15z", 0x6B4A2E),
            f("M46.5 31.5h3v2h-3z M46.5 40h3v2h-3z", 0xC9A15B),
        ],
        "gordijn": [
            f("M11 8h42v36H11z", 0xBCCDD6),
            f("M31 8h2v36h-2z M11 24h42v2H11z", 0xEFEBE2),
            f("M3 7h19C20 16 16 24 12 29c4 5 6 11 6 17H3z", 0xC8261B),
            f("M61 7H42c2 9 6 17 10 22-4 5-6 11-6 17h15z", 0xC8261B),
            s("M8 8c1 7 1 14 0 20M8 31c1 5 1 10 0 14M56 8c-1 7-1 14 0 20M56 31c-1 5-1 10 0 14", 0x8F1B13, 1),
            f("M5 27.5h11v3.5H5z M48 27.5h11v3.5H48z", 0xFAC775),
            f("M1 3h62v4H1z", 0x4A3524),
        ],
        "waterkoker": [
            f("M17 41h30v5H17z", 0x2C2C2A),
            s("M44 16c9 0 9 19 0 19", 0x2C2C2A, 3.5),
            f("M21 13h22l3 28H18z", 0xD9D6CC),
            f("M21 18l-9-5-1.5 3 10.5 7z", 0xB4B2A9),
            f("M24 9h16l1 4H23z M30 6h4v3h-4z", 0x5E6B73),
            f("M24 19h4v17h-4z", 0x8FB6CF),
            f("M37 43a1.6 1.6 0 1 0 3.2 0a1.6 1.6 0 1 0 -3.2 0z", 0xC8261B),
        ],
        "fotolijstje": [
            f("M38 14l10 32h-3.5L35 16z", 0x4A3524),
            f("M16 4h30v42H16z", 0x2E2117),
            f("M19 7h24v36H19z", 0xFFFDF6),
            f("M21 9h20v25H21z", 0xBCCDD6),
            f("M22 34c0-7 2.5-10 5-10s5 3 5 10z", 0x2F5BD3),
            f("M30 34c0-7 2.5-10 5-10s5 3 5 10z", 0xC8261B),
            f("M24 18a3 3 0 1 0 6 0a3 3 0 1 0 -6 0z", 0xC99A74),
            f("M32 19a3 3 0 1 0 6 0a3 3 0 1 0 -6 0z", 0x8A5A32),
        ],
        "boekenkast": [
            f("M10 1h44v4H10z M14 45h4v3h-4z M46 45h4v3h-4z", 0x4A3524),
            f("M12 5h40v40H12z", 0x6E3A2C),
            f("M15 8h34v10H15z M15 21h34v10H15z M15 34h34v9H15z", 0x3A1F17),
            f("M16 9h3v9h-3z M33 22h4v9h-4z M18 35h3v8h-3z M43 35h4v8h-4z", 0x2F5BD3),
            f("M20 10h4v8h-4z M24 23h3v8h-3z M37 36h3v7h-3z", 0xC8261B),
            f("M25 11h3v7h-3z M16 22h4v9h-4z M28 35h4v8h-4z", 0xFAC775),
            f("M29 9h3v9h-3z M38 23h3v8h-3z M22 36h5v7h-5z", 0x0F6E56),
            f("M35 18l4-9 2.5 1-4 8z M44 12h4v6h-4z M42.5 31c-1.5-4 0-6.5 2.5-6.5s4 2.5 2.5 6.5z", 0xF4C0D1),
        ],
        "piano": [
            f("M4 4h56v4H4z", 0x1E1E1C),
            f("M6 8h52v22H6z", 0x2C2C2A),
            f("M10 11h44v16H10z", 0x3A3A37),
            f("M25 12h14v11H25z", 0xFFFDF6),
            s("M27.5 15h9M27.5 18h9M27.5 21h6", 0x8A5A32, 0.8),
            f("M3 30h58v6H3z", 0x1E1E1C),
            f("M5 30.5h54v3.5H5z", 0xFFFDF6),
            f("M8 30.5h2v2.2H8z M13 30.5h2v2.2h-2z M20 30.5h2v2.2h-2z M25 30.5h2v2.2h-2z M30 30.5h2v2.2h-2z M37 30.5h2v2.2h-2z M42 30.5h2v2.2h-2z M49 30.5h2v2.2h-2z M54 30.5h2v2.2h-2z", 0x1E1E1C),
            f("M7 36h50v8H7z M7 44h4v4H7z M53 44h4v4h-4z", 0x2C2C2A),
            f("M28.5 45h2.5v2h-2.5z M33 45h2.5v2H33z M14 13h3v3h-3z M47 13h3v3h-3z", 0xC9A15B),
        ],
        "schommelstoel": [
            s("M4 40c14 7 40 7 56-3", 0x6B4A2E, 3),
            f("M40 2l5 1.2-6.5 29-5-1.2z", 0x8A5A32),
            s("M38.5 9l4.5 1M37 15l4.5 1M35.5 21l4.5 1", 0xC9A15B, 1.6),
            f("M13 27h24v4H13z", 0x8A5A32),
            f("M14 24h21v3H14z", 0xC8261B),
            f("M12 17h21v3H12z M13 20h3v7h-3z", 0x8A5A32),
            f("M15 31h3.5v12H15z M32 31h3.5v12H32z", 0x6B4A2E),
        ],
        "kroonluchter": [
            s("M32 0v9", 0xA88442, 2),
            f("M30 8h4v16h-4z", 0xC9A15B),
            s("M32 22C24 22 14 21 12 15M32 22C40 22 50 21 52 15M32 27C27 29 22 29 20 25M32 27C37 29 42 29 44 25", 0xC9A15B, 2),
            f("M32 31a4 4 0 1 0 0-8a4 4 0 1 0 0 8z", 0xC9A15B),
            f("M9 14h6v2.5H9z M49 14h6v2.5h-6z M17 24h6v2.5h-6z M41 24h6v2.5h-6z", 0xA88442),
            f("M10.5 8h3v6h-3z M50.5 8h3v6h-3z M18.5 18h3v6h-3z M42.5 18h3v6h-3z", 0xFFFDF6),
            s("M10.5 8h3v6h-3z M50.5 8h3v6h-3z M18.5 18h3v6h-3z M42.5 18h3v6h-3z", 0xA88442, 0.8),
            f("M12 2.5c1.6 2 1.6 4 0 5c-1.6-1-1.6-3 0-5z M52 2.5c1.6 2 1.6 4 0 5c-1.6-1-1.6-3 0-5z M20 12.5c1.6 2 1.6 4 0 5c-1.6-1-1.6-3 0-5z M44 12.5c1.6 2 1.6 4 0 5c-1.6-1-1.6-3 0-5z", 0xFAC775),
            f("M12 17l1.5 3-1.5 2-1.5-2z M52 17l1.5 3-1.5 2-1.5-2z M20 27l1.5 3-1.5 2-1.5-2z M44 27l1.5 3-1.5 2-1.5-2z M32 31l2 4-2 3-2-3z", 0xC9E6E2),
        ],
    ]
}

nonisolated enum HouseArtAlign: Sendable {
    case bottom, center, top
}

/// One object drawn into the frame it is given.
struct HouseItemArt: View {
    let item: HouseItem
    var align: HouseArtAlign = .bottom
    var locked = false

    init(item: HouseItem, onFloor: Bool = true, locked: Bool = false) {
        self.item = item
        self.align = onFloor ? .bottom : .center
        self.locked = locked
    }

    init(item: HouseItem, align: HouseArtAlign) {
        self.item = item
        self.align = align
    }

    var body: some View {
        let layers = item.layers
        let align = align
        let locked = locked
        Canvas { ctx, size in
            HouseArt.draw(layers, in: &ctx, size: size, align: align, locked: locked)
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// An object in its spot. De kroonluchter hangs from the ceiling on a chain.
struct HousePlacedArt: View {
    let item: HouseItem
    let slot: HouseSlot

    var body: some View {
        let hanging = item.id == "kroonluchter"
        HouseItemArt(item: item, align: slot.onFloor ? .bottom : hanging ? .top : .center)
            .frame(width: slot.rect.width, height: slot.rect.height)
            .overlay(alignment: .top) {
                if hanging {
                    let gap = max(0, slot.rect.minY - slot.room.ceiling(atX: slot.rect.midX))
                    Rectangle()
                        .fill(Ink.hex(0xA88442))
                        .frame(width: 1.4, height: gap + 1)
                        .offset(y: -gap)
                }
            }
    }
}

extension HouseRoom {
    /// The ceiling height above a point (the attic follows the bell gable).
    func ceiling(atX x: CGFloat) -> CGFloat {
        switch self {
        case .keuken: 330
        case .woonkamer: 236
        case .slaapkamer: 144
        case .zolder: 52 + abs(x - 159) * 0.12
        }
    }
}
