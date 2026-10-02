import SwiftUI

/// Things at the vet: a picture of pets at home, a card about a germ that jumps from one animal
/// to the next, a single pet that shows something (a tear, a flea, a sore paw, a long coat), a pet
/// on the table with a syringe or a chip reader at its neck, and a bag of food with a full bowl.
enum G4Vet {
    typealias Kind = G4Animals.Kind

    // MARK: Pets at home

    /// A framed picture (118 × 66): a house outline with a dog, a cat and a goldfish bowl inside,
    /// a red heart under the roof.
    static func petHouse(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 118, height: 66))
        f.rect(2, 3, 116, 63, 0x1E1E1C, radius: 3, 0.14)
        f.rect(0, 0, 116, 63, 0x9A6A42, radius: 3)
        f.rect(4, 4, 108, 55, 0xFFFDF6, radius: 1)
        f.svg("M22 29L58 11L94 29V57H22Z", 0xF6E7C8)
        f.svgLine("M23 29V57M93 29V57", 0x1F3A6B, 2.6)
        f.svgLine("M14 33L58 10L102 33", 0x1F3A6B, 3.4)
        f.svgLine("M8 57H108", 0x1F3A6B, 2)
        G4Draw.heart(f, 58, 22, 5.5, 0xC8261B)
        G4Animals.sit(.dog, f, in: CGRect(x: 25, y: 30, width: 32, height: 27), shadow: false)
        G4Animals.sit(.cat, f, in: CGRect(x: 55, y: 32, width: 21, height: 25), coat: 0x4A3524, shadow: false)
        f.dot(83, 48, 8.5, 0xBCDCEB)
        f.rect(75, 39, 16, 3, 0xBCDCEB)
        f.svgLine("M76.5 40H89.5", 0x8FB6CF, 1.4)
        f.oval(80, 46, 7, 4.4, 0xF2711C)
        f.svg("M80.5 48.2L77 45.6V50.8Z", 0xF2711C)
        f.dot(85, 47.6, 0.7, 0x1E1E1C)
    }

    // MARK: Contagious

    /// A warning card (106 × 80): a sick cat sneezes, germs fly along an arrow to a dog that turns ill.
    static func contagion(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 106, height: 80))
        f.rect(2, 3, 104, 77, 0x1E1E1C, radius: 4, 0.14)
        f.rect(0, 0, 104, 77, 0xFAC775, radius: 4)
        f.rect(4, 4, 96, 69, 0xFFFDF6, radius: 2)
        PalaceIcon.warning.draw(f, in: CGRect(x: 8, y: 7, width: 17, height: 17), color: 0xC8261B, detail: 0xFFFDF6)
        let cat = G4Animals.sit(.cat, f, in: CGRect(x: 6, y: 30, width: 36, height: 41), coat: G4Animals.sickTint, mood: .sick)
        cat.svgLine("M38 17L44 15M38 20L45 21M37 23L42 26", 0x5E6B73, 1.2)
        G4Animals.sit(.dog, f, in: CGRect(x: 56, y: 32, width: 44, height: 39), coat: 0xC9B07B, mood: .sick, left: true)
        f.svgLine("M38 30Q54 8 70 24", 0x5E6B73, 1.4)
        f.svg("M66.5 22.5L72.5 26.5L71 19.5Z", 0x5E6B73)
        for (x, y, r) in [(42.0, 26.0, 2.4), (48.0, 18.0, 2.8), (57.0, 14.0, 2.4), (64.0, 17.5, 2.0), (73.0, 36.0, 2.6), (86.0, 50.0, 2.2)] as [(CGFloat, CGFloat, CGFloat)] {
            G4Draw.germ(f, x, y, r)
        }
    }

    // MARK: One animal

    /// One pet sitting (see `PalacePropKind.g4Animal`).
    static func animal(_ pen: PropPen, _ p: PalacePropParams) {
        let kind = G4Animals.kind(p.variant)
        let coat = PropColor.named(p.tone, G4Animals.defaultCoat(kind))
        let left = p.flip == true
        switch p.accessory {
        case "sad":
            let f = pen.fitted(CGSize(width: 60, height: 104))
            G4Draw.rainCloud(f, 10, 2, 40)
            f.svgLine("M18 40L16 46M30 38L28 44M42 40L40 46M24 50L22 56M36 50L34 56", 0x8FB6CF, 1.2)
            f.oval(2, 96, 56, 7, 0x8FB6CF, 0.5)
            if p.mount == "box" { box(f, back: true) }
            let a = G4Animals.sit(kind, f, in: CGRect(x: 6, y: 56, width: 48, height: 44), coat: coat, mood: .sad, left: left, shadow: false)
            let eye = kind == .dog ? CGPoint(x: 41, y: 13) : CGPoint(x: 29.5, y: 15)
            G4Animals.tear(a, eye.x, eye.y + 1.5)
            if p.mount == "box" { box(f, back: false) }
        case "flea":
            let f = pen.fitted(CGSize(width: 80, height: 64))
            let a = G4Animals.sit(kind, f, in: CGRect(x: 2, y: 14, width: 46, height: 48), coat: coat, mood: .pain, left: left)
            a.svgLine("M14 16L10 11M17 13L15 7M21 12L21 6", 0xC8261B, 1.2)
            for (x, y) in [(14.0, 32.0), (20.0, 27.0), (10.0, 40.0)] as [(CGFloat, CGFloat)] { a.dot(x, y, 0.9, 0x2E2117) }
            let g = G4Draw.lens(f, 58, 22, 18, back: coat)
            g.svgLine("M44 14L50 30M52 8L58 34M62 6L66 30M70 12L72 34", PalaceInk.shade(coat, 0.8), 1.2)
            G4Draw.flea(g, 58, 23, 1.15)
            g.svgLine("M47 34Q52 26 56 32", 0x6B3A1E, 0.8)
            G4Draw.lensRim(f, 58, 22, 18)
        case "paw":
            let f = pen.fitted(CGSize(width: 62, height: 60))
            let a = G4Animals.sit(kind, f, in: CGRect(x: 2, y: 8, width: 54, height: 50), coat: coat, mood: .pain, left: left)
            let paw = G4Animals.anchors(kind).paw
            // The near leg comes up: cover the standing paw, lift it forward in a bandage.
            a.oval(paw.x - 4.5, paw.y - 3, 9, 5, coat)
            a.rect(paw.x - 3, paw.y - 13, 6, 12, coat)
            a.svgLine("M\(paw.x - 2) \(paw.y - 14)L\(paw.x + 8) \(paw.y - 16)", coat, 4.8)
            a.rect(paw.x + 6, paw.y - 21, 10, 10, 0xFFFDF6, radius: 3.5)
            a.svgLine("M\(paw.x + 9) \(paw.y - 20.5)V\(paw.y - 11.5)M\(paw.x + 12.5) \(paw.y - 20.5)V\(paw.y - 11.5)", 0xD3D1C7, 0.9)
            a.svgLine("M\(paw.x + 18) \(paw.y - 24)L\(paw.x + 21) \(paw.y - 27)M\(paw.x + 19) \(paw.y - 16)L\(paw.x + 23) \(paw.y - 16)M\(paw.x + 18) \(paw.y - 9)L\(paw.x + 21) \(paw.y - 6)", 0xC8261B, 1.3)
        case "brush":
            let f = pen.fitted(CGSize(width: 74, height: 60))
            let a = G4Animals.sit(kind, f, in: CGRect(x: 20, y: 6, width: 52, height: 53), coat: coat, fluffy: true, left: left)
            a.svgLine("M12 34Q16 30 20 34M14 40Q18 36 22 40M24 30Q27 27 30 30", PalaceInk.shade(coat, 0.75), 0.9)
            // A brush combs the back, hair caught in its bristles; loose hairs float off.
            f.svgLine("M2 6L14 16", 0x8C5E38, 4.4)
            f.svg("M10 14L22 18L19 30L7 26Z", 0x9A6A42)
            f.svgLine("M21 20L25 21M20.5 23L24.5 24M20 26L24 27M19.5 29L23 30", 0x2E2117, 1)
            f.svgLine("M22 19Q27 24 23 31", coat, 2.2)
        default:
            let f = pen.fitted(CGSize(width: 54, height: 50))
            G4Animals.sit(kind, f, in: CGRect(x: 0, y: 0, width: 54, height: 50), coat: coat, left: left)
        }
    }

    /// A cardboard box the animal sits in: the back flaps, or the front panel.
    private static func box(_ f: PropPen, back: Bool) {
        if back {
            f.svg("M8 76L2 64L20 70Z M52 76L58 64L40 70Z", 0xB98A5A)
            f.rect(8, 72, 44, 6, 0x8C5E38)
        } else {
            f.rect(8, 78, 44, 22, 0xC99A62)
            f.svgLine("M8 78H52", 0x8C5E38, 1.4)
            f.svgLine("M26 84H34", 0x8C5E38, 1.2)
        }
    }

    // MARK: Care on the table

    /// An animal on a towel and a gloved hand from the right (110 × 80): a syringe with a vial,
    /// or a chip reader whose screen shows `text`, with a lens showing the chip under the skin.
    static func animalCare(_ pen: PropPen, _ p: PalacePropParams) {
        let kind = G4Animals.kind(p.variant ?? 1)
        let coat = PropColor.named(p.tone, G4Animals.defaultCoat(kind))
        if p.accessory == "scanner" { return scanner(pen.fitted(CGSize(width: 88, height: 92)), kind, coat, p.text) }
        let f = pen.fitted(CGSize(width: 110, height: 80))
        f.rect(4, 70, 66, 8, 0x5DCAA5, radius: 2)
        f.svgLine("M8 72H66M8 75H66", 0xFFFDF6, 0.8)
        let neck = sitOnTowel(kind, f, in: CGRect(x: 6, y: 14, width: 58, height: 58), coat: coat, mood: .pain)
        f.svg("M110 30L92 34L94 50L110 48Z", 0x2F8F7A)
        f.rect(84, 34, 12, 14, 0x8FB6CF, radius: 4)
        let tip = CGPoint(x: neck.x + 3, y: neck.y - 2)
        var g = f
        g.ctx.translateBy(x: tip.x, y: tip.y)
        g.ctx.rotate(by: .degrees(-18))
        g.line(0, 0, 10, 0, 0x9A9890, 1)
        g.rect(10, -3.5, 22, 7, 0xFFFDF6, radius: 1.5)
        g.rect(12, -2.5, 13, 5, 0x8FB6CF)
        g.svgLine("M14 -3.5V-1.5M18 -3.5V-1.5M22 -3.5V-1.5", 0x5E6B73, 0.6)
        g.rect(32, -1, 8, 2, 0x5E6B73)
        g.rect(40, -4, 2.4, 8, 0x5E6B73, radius: 1)
        f.svgLine("M\(tip.x + 30) \(tip.y - 9)L86 38", 0x8FB6CF, 5)
        // The vial on the table
        f.rect(80, 58, 9, 16, 0xE4ECEE, radius: 2)
        f.rect(80, 64, 9, 7, 0x8FB6CF)
        f.rect(80.5, 55, 8, 4, 0x1F3A6B, radius: 1)
    }

    /// The animal sitting in `rect` without a shadow; returns its neck point in the pen's units.
    private static func sitOnTowel(_ kind: Kind, _ f: PropPen, in rect: CGRect, coat: UInt32, mood: G4Animals.Mood) -> CGPoint {
        G4Animals.sit(kind, f, in: rect, coat: coat, mood: mood, shadow: false)
        let d = G4Animals.design(kind)
        let s = min(rect.width / d.width, rect.height / d.height)
        let n = G4Animals.anchors(kind).neck
        return CGPoint(x: rect.midX - d.width * s / 2 + n.x * s, y: rect.maxY - d.height * s + n.y * s)
    }

    /// A chip reader (88 × 92): a gloved hand holds a yellow reader to the animal's neck, its screen
    /// shows `text` with a beep; a lens shows the little chip under the skin.
    private static func scanner(_ f: PropPen, _ kind: Kind, _ coat: UInt32, _ text: String?) {
        f.rect(2, 84, 62, 8, 0x5DCAA5, radius: 2)
        f.svgLine("M6 86H60M6 89H60", 0xFFFDF6, 0.8)
        let neck = sitOnTowel(kind, f, in: CGRect(x: 0, y: 32, width: 60, height: 54), coat: coat, mood: .calm)
        f.svg("M88 2L72 8L74 24L88 20Z", 0x2F8F7A)
        f.rect(42, 4, 26, 40, 0xFAC775, radius: 5)
        f.stroke(Path(roundedRect: CGRect(x: 42, y: 4, width: 26, height: 40), cornerRadius: 5), 0xE0A030, 1)
        f.rect(45, 8, 20, 14, 0x232B3B, radius: 1.5)
        f.text(text ?? "", PropFont.mono(6.5), 0x5DCAA5, at: CGPoint(x: 55, y: 15), maxWidth: 18)
        f.dot(55, 30, 3, 0x1E7A4C)
        f.ring(neck.x + 4, neck.y - 2, 6, 0x3E4C55, 2.4)
        f.svgLine("M48 44L\(neck.x + 7) \(neck.y - 6)", 0x3E4C55, 3)
        f.rect(64, 10, 12, 14, 0x8FB6CF, radius: 4)
        f.svgLine("M38 10Q34 14 38 18M34 6Q28 14 34 22", 0x1E7A4C, 1.3)
        let g = G4Draw.lens(f, 70, 70, 14, back: PalaceInk.shade(coat, 1.15))
        g.svgLine("M58 62L64 78M68 58L74 82M78 60L82 76", PalaceInk.shade(coat, 0.85), 1)
        g.rect(62, 67, 16, 6.5, 0xD3E0E6, radius: 3.2)
        g.svgLine("M65.5 68.2V72M68 68.2V72M70.5 68.2V72", 0xC9A15B, 1)
        g.rect(73, 68.2, 3.4, 4, 0x5E6B73, radius: 0.8)
        G4Draw.lensRim(f, 70, 70, 14)
        f.svgLine("M\(neck.x + 4) \(neck.y + 4)L58 64", 0x3E4C55, 0.8)
    }

    // MARK: Food

    /// A bag of animal food (an animal's head on its label, an open top heaped with kibble) beside a
    /// full bowl (72 × 56). `variant` 0 dog, 1 cat; `mount` "shelf" puts them on a wall shelf.
    static func foodBag(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 72, height: 56))
        let shelf = p.mount == "shelf"
        let floor: CGFloat = shelf ? 48 : 54
        if shelf {
            f.rect(0, 48, 72, 5, 0x9A6A42, radius: 1)
            f.svg("M8 53H12L10 56Z M60 53H64L62 56Z", 0x6B4A2E)
        } else {
            f.oval(2, 50, 68, 6, 0x1E1E1C, 0.14)
        }
        let bag = CGRect(x: 4, y: floor - 44, width: 32, height: 44)
        f.svg("M\(bag.minX + 2) \(bag.minY + 6)L\(bag.minX + 6) \(bag.minY)H\(bag.maxX - 6)L\(bag.maxX - 2) \(bag.minY + 6)Z", 0x8C5E38)
        for (x, y) in [(10.0, 4.0), (15.0, 2.5), (20.0, 4.5), (25.0, 3.0), (29.0, 5.0)] as [(CGFloat, CGFloat)] {
            f.dot(bag.minX + x, bag.minY + y, 2, 0x8C5E38)
        }
        f.rect(bag.minX, bag.minY + 6, bag.width, bag.height - 6, 0x0F6E56, radius: 2)
        f.rect(bag.minX + 4, bag.minY + 12, bag.width - 8, 22, 0xFFFDF6, radius: 2)
        let kind: Kind = (p.variant ?? 0) == 1 ? .cat : .dog
        G4Animals.sit(kind, f, in: CGRect(x: bag.minX + 6, y: bag.minY + 13, width: bag.width - 12, height: 20), shadow: false)
        PalaceIcon.g4Paw.draw(f, in: CGRect(x: bag.midX - 4, y: bag.maxY - 9, width: 8, height: 8), color: 0xFAC775, detail: 0x0F6E56)
        // Bowl heaped with kibble
        f.svg("M42 \(floor - 12)H70L66 \(floor)H46Z", 0xC8261B)
        f.rect(42, floor - 13, 28, 3, 0xA81E15, radius: 1.5)
        for (x, y) in [(46.0, -15.0), (51.0, -17.0), (56.0, -18.5), (61.0, -17.0), (66.0, -15.0), (49.0, -14.0), (58.0, -14.5), (63.0, -13.5), (54.0, -14.0)] as [(CGFloat, CGFloat)] {
            f.dot(x, floor + y, 2.4, 0x8C5E38)
        }
        f.dot(40, floor - 1.5, 1.6, 0x8C5E38)
    }
}
