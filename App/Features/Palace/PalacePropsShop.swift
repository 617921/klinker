import SwiftUI

/// Shop props, shared by the bakery, the supermarket and the pharmacy: goods on a shelf and
/// shoppers holding something. `draw` dispatches every shop prop, so the shared switch in
/// `PalacePropView` stays one line.
enum PalaceShopProps {
    static func draw(_ kind: PalacePropKind, _ pen: PropPen, _ p: PalacePropParams) {
        switch kind {
        case .shelfGoods: shelfGoods(pen, p)
        case .shopper: shopper(pen, p)
        case .cardTerminal: PalaceGrocer.cardTerminal(pen, p)
        case .tillReceipt: PalaceGrocer.tillReceipt(pen, p)
        case .weighScale: PalaceGrocer.weighScale(pen, p)
        case .produceCrate: PalaceGrocer.produceCrate(pen, p)
        case .priceTag: PalaceGrocer.priceTag(pen, p)
        case .offerPoster: PalaceGrocer.offerPoster(pen, p)
        case .bottleReturn: PalaceGrocer.bottleReturn(pen, p)
        case .shoppingCart: PalaceGrocer.shoppingCart(pen, p)
        case .datedPack: PalaceGrocer.datedPack(pen, p)
        case .overPacked: PalaceGrocer.overPacked(pen, p)
        case .pastryCase: PalaceBakery.pastryCase(pen, p)
        case .doughBoard: PalaceBakery.doughBoard(pen, p)
        case .toppings: PalaceBakery.toppings(pen, p)
        case .ingredientRow: PalaceBakery.ingredientRow(pen, p)
        case .warningSign: PalaceBakery.warningSign(pen, p)
        case .orderSlip: PalaceBakery.orderSlip(pen, p)
        case .tastingPlate: PalaceBakery.tastingPlate(pen, p)
        case .breadLoaf: PalaceBakery.breadLoaf(pen, p)
        case .pillJar: PalacePharmacy.pillJar(pen, p)
        case .medLeaflet: PalacePharmacy.medLeaflet(pen, p)
        case .effectPoster: PalacePharmacy.effectPoster(pen, p)
        case .measureCup: PalacePharmacy.measureCup(pen, p)
        case .medBox: PalacePharmacy.medBox(pen, p)
        case .syrupBottle: PalacePharmacy.syrupBottle(pen, p)
        case .insuranceCard: PalacePharmacy.insuranceCard(pen, p)
        case .refundSlip: PalacePharmacy.refundSlip(pen, p)
        case .otcRack: PalacePharmacy.otcRack(pen, p)
        case .breakfastTable: PalacePharmacy.breakfastTable(pen, p)
        default: break
        }
    }

    // MARK: Goods on a shelf

    /// A bay of goods standing on a shelf (76 × 50), no word of its own:
    /// `accessory` "bread", "boxes", "medicine" or "jars"; `variant` shifts the colours.
    static func shelfGoods(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 76, height: 50))
        let colors: [UInt32] = [0xC8261B, 0xFAC775, 0x2F5BD3, 0x0F6E56, 0xF2711C, 0x3C3489]
        let v = p.variant ?? 0
        func color(_ i: Int) -> UInt32 { colors[(i + v) % colors.count] }
        switch p.accessory ?? "boxes" {
        case "bread":
            for (i, x) in [10.0, 18, 26].enumerated() {
                let lean = CGFloat(i - 1) * 5
                f.svgLine("M\(x - lean) 42L\(x + lean) 6", 0xC98A45, 7.5)
                f.svgLine("M\(x + lean * 0.6 - 2) 14l3.5 -2.5M\(x + lean * 0.2 - 2) 22l3.5 -2.5", 0xE8B978, 1.3)
            }
            f.svg("M2 33H34L31 50H5Z", 0xB98450)
            f.svgLine("M4 38H32M5 42.5H31M6 46.5H30", 0x8C5E38, 1)
            f.svg("M36 50C36 38 43 31 52 31C61 31 68 38 68 50Z", 0xB97A3E)
            f.svgLine("M44 39Q47 36 50 39M52 37Q55 34 58 37M60 40Q63 37 65 40", 0xE2B47A, 1.4)
            f.svg("M58 50C58 44 62 41 67 41C72 41 76 44 76 50Z", 0xD09A5A)
        case "medicine":
            for row in 0..<2 {
                for i in 0..<5 {
                    let x = 2 + CGFloat(i) * 15, y = row == 0 ? 6.0 : 28
                    f.rect(x, y, 13, 21, 0xFFFDF6, radius: 1)
                    f.rect(x, y + 4, 13, 4, color(i + row * 2))
                    f.svgLine("M\(x + 3) \(y + 13)H\(x + 10)M\(x + 3) \(y + 16)H\(x + 8)", 0xB4B2A9, 1)
                }
            }
        case "jars":
            for i in 0..<4 {
                let x = 3 + CGFloat(i) * 18.5
                f.rect(x, 22, 16, 28, PalaceInk.shade(color(i), 0.75), radius: 3)
                f.rect(x + 2, 30, 12, 11, 0xFFFDF6, radius: 1)
                f.rect(x - 0.5, 16, 17, 7, color(i + 3), radius: 1.5)
            }
        default:
            let heights: [CGFloat] = [44, 36, 44, 30]
            for i in 0..<4 {
                let x = 2 + CGFloat(i) * 15, h = heights[i]
                f.rect(x, 50 - h, 14, h, color(i))
                f.rect(x + 2, 50 - h * 0.62, 10, h * 0.3, 0xFFFDF6, radius: 1)
                f.dot(x + 7, 50 - h * 0.47, 2.6, color(i + 2))
            }
            for (i, y) in [32.0, 41].enumerated() {
                f.rect(62, y, 13, 9, 0xB4B2A9, radius: 1.5)
                f.rect(62, y + 2.5, 13, 4, color(i + 4))
            }
        }
    }

    // MARK: Shopper

    /// A standing customer facing right (64 × 114) with something in their hands:
    /// `accessory` "cakeBox" (a tied cake box, `text` on its tag), "tray" (party hat, treats held
    /// out to a reaching hand), "pill" (a pill to the mouth, a glass of water) or "bag".
    static func shopper(_ pen: PropPen, _ p: PalacePropParams) {
        let item = p.accessory ?? "bag"
        let tray = item == "tray"
        let full = pen.fitted(CGSize(width: tray ? 86 : 64, height: tray ? 124 : 114))
        let f = tray ? full.within(CGRect(x: 0, y: 10, width: 86, height: 114)) : full
        let v = PalaceFigures.Look.at(p.variant ?? 0)
        let dark = PalaceInk.shade(v.coat, 0.78)
        let walking = item == "cakeBox"
        f.oval(6, 106, 56, 6, 0x1E1E1C, 0.16)
        f.svgLine(walking ? "M17 84L12 104M27 84L32 104" : "M17 84V104M27 84V104", v.trousers, 5)
        f.svg(walking ? "M7 103H16V108H7Z M28 103H37V108H28Z" : "M12 103H21V108H12Z M23 103H32V108H23Z", 0x2E2117)
        f.svg("M9 88L10.5 44C11.5 36 15.5 32 22 32C28.5 32 32.5 36 33.5 44L35 88Z", v.coat)
        f.svgLine("M22 40V86", dark, 1.2)
        f.svg("M17 32L22 39L27 32Z", 0xEFEBE2)
        if item != "pill" && item != "cakeBox" {
            f.svgLine("M13 42C10 52 10 62 12 70", dark, 6)
            f.dot(12.5, 72, 3.1, v.skin)
        }
        f.dot(22, 19, 11, v.skin)
        f.svg("M11 18C10 10 15 6 22 6C29 6 34 10 33 18C31 13 27 11.5 22 11.5C17 11.5 13 13 11 18Z", v.hair)
        f.dot(28, 19.5, 1.3, 0x2E2117)
        switch item {
        case "cakeBox":
            f.svgLine("M13 42C14 52 22 60 31 63M31 42C36 50 44 57 52 62", dark, 6)
            f.rect(28, 44, 32, 19, 0xFFFDF6, radius: 1.5)
            f.stroke(Path(roundedRect: CGRect(x: 28, y: 44, width: 32, height: 19), cornerRadius: 1.5), 0xD3D1C7, 1)
            f.svgLine("M44 44V63M28 53.5H60", 0xC8261B, 1.6)
            f.svgLine("M44 44C39 37 36 42 44 44C52 37 49 42 44 44", 0xC8261B, 1.4)
            f.dot(31.5, 63.5, 3.2, v.skin)
            f.dot(53, 63.5, 3.2, v.skin)
            let tag = Path(roundedRect: CGRect(x: 0, y: 0, width: 24, height: 11), cornerRadius: 1.5)
                .applying(CGAffineTransform(rotationAngle: 0.25).concatenating(CGAffineTransform(translationX: 45, y: 64)))
            f.svgLine("M58 58L52 66", 0x8C5E38, 0.9)
            f.fill(tag, 0xFAC775)
            if let text = p.text {
                var t = f
                t.ctx.translateBy(x: 56.5, y: 71)
                t.ctx.rotate(by: .radians(0.25))
                t.text(text, PropFont.demi(7), 0x412402, at: .zero, maxWidth: 21)
            }
        case "tray":
            f.svg("M14 10L25 -9L31 9Z", 0x2F5BD3)
            f.svgLine("M17.5 4L28 2M21 -2.5L29.5 -3.5", 0xFAC775, 1.8)
            f.dot(25, -9, 2.6, 0xC8261B)
            f.svgLine("M31 42C38 47 46 49 54 48", v.coat, 6)
            f.dot(55, 48, 3.2, v.skin)
            f.rect(40, 44, 42, 4, 0xB4B2A9, radius: 2)
            for (i, x) in [46.0, 59, 72].enumerated() {
                f.svg("M\(x - 5) 37H\(x + 5)L\(x + 3.5) 44H\(x - 3.5)Z", [0xC8261B, 0x2F5BD3, 0x0F6E56][i])
                f.svg("M\(x - 6) 37.5C\(x - 6) 31 \(x + 6) 31 \(x + 6) 37.5Z", [0xF4C0D1, 0xFFFDF6, 0xF6D27A][i])
                f.dot(x, 31.5, 1.9, 0xC8261B)
            }
            f.svgLine("M88 30L77 31", 0x2F5BD3, 7)
            f.dot(74.5, 31, 3.6, 0xC99A74)
            f.line(73, 29, 72.5, 34, 0xC99A74, 2)
            for (x, y, c) in [(40.0, 22.0, 0xFAC775), (52, 14, 0xC8261B), (66, 10, 0x2F5BD3), (44, 32, 0x0F6E56), (80, 40, 0xF2711C)] as [(CGFloat, CGFloat, UInt32)] {
                f.rect(x, y, 3, 3, c, radius: 0.6)
            }
        case "pill":
            f.svgLine("M13 42C14 52 18 59 25 60", dark, 6)
            f.rect(21, 45, 10, 15, 0xA9CBE0, radius: 1.5, 0.75)
            f.rect(21, 51, 10, 9, 0x6FA3C7, radius: 1.5, 0.7)
            f.stroke(Path(roundedRect: CGRect(x: 21, y: 45, width: 10, height: 15), cornerRadius: 1.5), 0xFFFFFF, 1)
            f.dot(25.5, 60, 3.2, v.skin)
            f.svgLine("M31 42C41 44 41 33 34 28", v.coat, 6)
            f.dot(33.5, 27, 3.2, v.skin)
            f.oval(28.4, 23, 3.6, 3, 0x7A2A20)
            PalaceShopProps.capsule(f, CGPoint(x: 33, y: 22), angle: -0.5, 0xFFFDF6, 0xC8261B, length: 8)
        default:
            f.svgLine("M31 42C34 52 34 62 33 70", v.coat, 6)
            f.svgLine("M28 78C28 70 38 70 38 78", 0x8C5E38, 1.4)
            f.svgLine("M30 79L36 60", 0xD9A05B, 4.5)
            f.svgLine("M43 79L46 64", 0x5E8C45, 4)
            f.rect(24, 76, 24, 24, v.bag, radius: 2)
            f.dot(33, 72, 3.1, v.skin)
        }
    }

    // MARK: Shared bits

    /// A two-colour capsule of `length` points, centred at `c`, turned by `angle` radians.
    static func capsule(_ f: PropPen, _ c: CGPoint, angle: CGFloat, _ a: UInt32, _ b: UInt32, length: CGFloat = 12) {
        let h = length * 0.42
        let t = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: c.x, y: c.y))
        let body = Path(roundedRect: CGRect(x: -length / 2, y: -h / 2, width: length, height: h), cornerRadius: h / 2).applying(t)
        f.fill(body, b)
        var left = f
        left.ctx.clip(to: Path(CGRect(x: -length / 2 - 1, y: -h, width: length / 2 + 1, height: 2 * h)).applying(t))
        left.fill(body, a)
        f.stroke(body, 0x1E1E1C, 0.6, 0.35)
    }

    /// An arm reaching in from outside the frame: a sleeve from `from` to `to` and a hand at `to`.
    static func reach(_ f: PropPen, from: CGPoint, to: CGPoint, sleeve: UInt32 = 0x1F3A6B, skin: UInt32 = 0xE8C4A0) {
        f.line(from.x, from.y, to.x, to.y, sleeve, 7)
        f.dot(to.x, to.y, 3.8, skin)
    }

    /// A euro coin (radius `r`).
    static func coin(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ r: CGFloat = 5) {
        f.dot(x, y, r, 0xC9A15B)
        f.ring(x, y, r * 0.7, 0xE8CF8E, 1)
        f.text("€", PropFont.heavy(r * 1.1), 0x7A5230, at: CGPoint(x: x, y: y + 0.3))
    }
}
