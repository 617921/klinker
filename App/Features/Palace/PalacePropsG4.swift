import SwiftUI

/// Dispatch for the g4 props (vet, pool, day care, community centre, hotel, restaurant); each
/// one's params are documented on its `PalacePropKind` case.
enum G4Props {
    static func draw(_ kind: PalacePropKind, _ pen: PropPen, _ p: PalacePropParams) {
        switch kind {
        case .g4PetHouse: G4Vet.petHouse(pen, p)
        case .g4Contagion: G4Vet.contagion(pen, p)
        case .g4Animal: G4Vet.animal(pen, p)
        case .g4AnimalCare: G4Vet.animalCare(pen, p)
        case .g4FoodBag: G4Vet.foodBag(pen, p)
        case .g4PetCare: G4VetPeople.petCare(pen, p)
        case .g4VetExam: G4VetPeople.vetExam(pen, p)
        case .g4Slide: G4PoolProps.slide(pen, p)
        case .g4DivingBoard: G4PoolProps.divingBoard(pen, p)
        case .g4LifeguardChair: G4PoolProps.lifeguardChair(pen, p)
        case .g4Cubicle: G4PoolProps.cubicle(pen, p)
        case .g4Swimsuit: G4PoolProps.swimsuit(pen, p)
        case .g4TowelDry: G4Swim.towelDry(pen, p)
        case .g4Swimmers: G4Swim.swimmers(pen, p)
        case .g4PoolThermometer: G4Swim.poolThermometer(pen, p)
        default: break
        }
    }
}

/// Small drawing helpers shared by the g4 props.
enum G4Draw {
    typealias Look = PalaceFigures.Look

    /// A heart centred on (cx, cy).
    static func heart(_ f: PropPen, _ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat, _ hex: UInt32) {
        PalaceIcon.heart.draw(f, in: CGRect(x: cx - r, y: cy - r, width: 2 * r, height: 2 * r), color: hex, detail: hex)
    }

    /// A grey cloud with rain under it, its top-left at (x, y), `w` wide.
    static func rainCloud(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ w: CGFloat) {
        let s = w / 26
        let c = f.within(CGRect(x: x, y: y, width: w, height: 24 * s), unit: s)
        c.dot(6, 8, 5, 0x9A9890)
        c.dot(13, 5.5, 6.5, 0x9A9890)
        c.dot(20, 8, 5, 0x9A9890)
        c.rect(1, 8, 24, 5, 0x9A9890, radius: 2.5)
        c.svgLine("M6 16L4.5 20M13 16L11.5 20M20 16L18.5 20", 0x2F5BD3, 1.4)
    }

    /// A magnifying glass: the lens centred on (cx, cy) with radius r, the handle down to the right.
    /// Returns a pen clipped to the lens (draw the enlarged thing into it), then call `lensRim`.
    static func lens(_ f: PropPen, _ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat, back: UInt32) -> PropPen {
        f.svgLine("M\(cx + r * 0.72) \(cy + r * 0.72)L\(cx + r * 1.5) \(cy + r * 1.5)", 0x2E2117, r * 0.34)
        f.dot(cx, cy, r, back)
        var g = f
        g.ctx.clip(to: Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: 2 * r, height: 2 * r)))
        return g
    }

    static func lensRim(_ f: PropPen, _ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat) {
        f.ring(cx, cy, r, 0x3E4C55, max(1.4, r * 0.16))
        f.svgLine("M\(cx - r * 0.55) \(cy - r * 0.2)Q\(cx - r * 0.5) \(cy - r * 0.55) \(cx - r * 0.15) \(cy - r * 0.6)", 0xFFFFFF, max(0.8, r * 0.08))
    }

    /// A flea: a dark oval body with bent jumping legs, centred on (cx, cy), `s` its scale.
    static func flea(_ f: PropPen, _ cx: CGFloat, _ cy: CGFloat, _ s: CGFloat) {
        let g = f.within(CGRect(x: cx - 10 * s, y: cy - 8 * s, width: 20 * s, height: 16 * s), unit: s)
        g.svgLine("M9 9L5 13L2 12M11 10L9 15L6 16M13 9L16 13L19 15", 0x4A2A14, 1)
        g.oval(5, 3, 12, 9, 0x6B3A1E)
        g.dot(16, 6, 2.6, 0x6B3A1E)
        g.dot(17, 5.2, 0.6, 0xFFFFFF)
        g.svgLine("M17.5 7.5L20 9", 0x4A2A14, 0.8)
    }

    /// A germ: a green blob with little spikes, centred on (cx, cy).
    static func germ(_ f: PropPen, _ cx: CGFloat, _ cy: CGFloat, _ r: CGFloat) {
        for k in 0..<8 {
            let a = Double(k) * .pi / 4
            f.line(cx + cos(a) * r * 0.8, cy + sin(a) * r * 0.8, cx + cos(a) * r * 1.45, cy + sin(a) * r * 1.45, 0x4E7A3A, max(0.7, r * 0.3))
        }
        f.dot(cx, cy, r, 0x6E9C52)
        f.dot(cx - r * 0.3, cy - r * 0.2, r * 0.25, 0x4E7A3A)
        f.dot(cx + r * 0.3, cy + r * 0.25, r * 0.2, 0x4E7A3A)
    }

    /// A standing adult in the 64 × 114 build of `PalaceFigures.person`, shifted by `x`, without
    /// the near arm. Its head is at (x + 22, 19), the near shoulder at (x + 31, 42).
    static func adult(_ f: PropPen, x: CGFloat = 0, _ v: Look, coat: UInt32? = nil, hair: UInt32? = nil, shadow: Bool = true) {
        let coat = coat ?? v.coat
        let dark = PalaceInk.shade(coat, 0.78)
        if shadow { f.oval(x + 6, 106, 52, 6, 0x1E1E1C, 0.16) }
        f.svgLine("M\(x + 17) 84V104M\(x + 27) 84V104", v.trousers, 5)
        f.svg("M\(x + 12) 103H\(x + 21)V108H\(x + 12)Z M\(x + 23) 103H\(x + 32)V108H\(x + 23)Z", 0x2E2117)
        f.svg("M\(x + 9) 88L\(x + 10.5) 44C\(x + 11.5) 36 \(x + 15.5) 32 \(x + 22) 32C\(x + 28.5) 32 \(x + 32.5) 36 \(x + 33.5) 44L\(x + 35) 88Z", coat)
        f.svg("M\(x + 17) 32L\(x + 22) 39L\(x + 27) 32Z", 0xEFEBE2)
        f.svgLine("M\(x + 13) 42C\(x + 10) 52 \(x + 10) 62 \(x + 12) 70", dark, 6)
        f.dot(x + 12.5, 72, 3.1, v.skin)
        head(f, x + 22, 19, v, hair: hair)
    }

    /// A head with hair and an eye, facing right, centred on (cx, cy) with radius 11.
    static func head(_ f: PropPen, _ cx: CGFloat, _ cy: CGFloat, _ v: Look, hair: UInt32? = nil, eye: Bool = true) {
        f.dot(cx, cy, 11, v.skin)
        f.svg("M\(cx - 11) \(cy - 1)C\(cx - 12) \(cy - 9) \(cx - 7) \(cy - 13) \(cx) \(cy - 13)C\(cx + 7) \(cy - 13) \(cx + 12) \(cy - 9) \(cx + 11) \(cy - 1)C\(cx + 9) \(cy - 6) \(cx + 5) \(cy - 7.5) \(cx) \(cy - 7.5)C\(cx - 5) \(cy - 7.5) \(cx - 9) \(cy - 6) \(cx - 11) \(cy - 1)Z", hair ?? v.hair)
        if eye { f.dot(cx + 6, cy + 0.5, 1.3, 0x2E2117) }
    }

    /// A smile under a head centred on (cx, cy).
    static func smile(_ f: PropPen, _ cx: CGFloat, _ cy: CGFloat) {
        f.svgLine("M\(cx + 3) \(cy + 6)Q\(cx + 5.5) \(cy + 8) \(cx + 8) \(cy + 6)", 0x8C5A3C, 1.1)
    }
}
