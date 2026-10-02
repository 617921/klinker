import SwiftUI

/// People with animals: a girl caring for her pet, and the vet examining a dog on the table.
enum G4VetPeople {
    typealias Look = PalaceFigures.Look

    // MARK: Caring for a pet

    /// A girl kneeling with an animal on her lap (72 × 100), giving it a carrot; two hearts.
    /// `variant` the animal (0 dog, 1 cat, 2 rabbit; default rabbit).
    static func petCare(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 72, height: 100))
        let v = Look.at(3)
        f.oval(4, 94, 64, 5, 0x1E1E1C, 0.15)
        f.svgLine("M16 93H40", v.trousers, 7)
        f.svg("M6 89H16V97H6Z", 0x2E2117)
        f.svgLine("M22 74L40 90", v.trousers, 9)
        f.svg("M12 78L13 52C14 45 18 42 24 42C30 42 34 45 35 52L36 78Z", 0x5DCAA5)
        f.svg("M19 42L24 48L29 42Z", 0xEFEBE2)
        f.dot(12, 26, 4.5, v.hair)
        G4Draw.head(f, 24, 30, v)
        G4Draw.smile(f, 24, 30)
        f.svgLine("M16 52C13 64 22 72 36 72", PalaceInk.shade(0x5DCAA5, 0.78), 6)
        let kind = G4Animals.kind(p.variant ?? 2)
        f.svgLine("M31 52C31 72 46 86 60 82", 0x5DCAA5, 6)
        G4Animals.sit(kind, f, in: CGRect(x: 30, y: 38, width: 40, height: 46), mood: .happy, shadow: false)
        f.dot(62, 81, 3.4, v.skin)
        f.svgLine("M63.5 78L62.5 69", 0xF2711C, 3)
        f.svgLine("M62 83L59 87M63.5 83.5L65 88", 0x5E8C45, 1.4)
        G4Draw.heart(f, 44, 22, 4.2, 0xC8261B)
        G4Draw.heart(f, 54, 13, 3.2, 0xED93B1)
    }

    // MARK: The vet

    /// The vet (150 × 110): green scrubs with a paw badge, listening with a stethoscope to a dog
    /// sitting on a steel table under a lamp.
    static func vetExam(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 150, height: 110))
        f.oval(10, 103, 130, 7, 0x1E1E1C, 0.14)
        f.svgLine("M34 0V8", 0x3E4C55, 1.4)
        f.svg("M24 16H44L40 8H28Z", 0x3E4C55)
        f.svg("M26 16H42L50 30H18Z", 0xFAC775, 0.2)
        f.svgLine("M40 68V104M98 68V104", 0x9A9890, 3)
        f.svgLine("M40 92H98", 0x9A9890, 2)
        f.rect(24, 62, 88, 7, 0xD3D1C7, radius: 2)
        f.rect(24, 67, 88, 3, 0x9A9890, radius: 1)
        let coat = PropColor.named(p.tone, G4Animals.defaultCoat(.dog))
        G4Animals.sit(.dog, f, in: CGRect(x: 28, y: 10, width: 66, height: 53), coat: coat, mood: .calm, shadow: false)
        let v = f.within(CGRect(x: 92, y: 2, width: 64 * 0.94, height: 114 * 0.94), unit: 0.94).mirrored()
        let look = Look.at(p.variant ?? 1)
        let scrubs: UInt32 = 0x2F8F7A
        G4Draw.adult(v, look, coat: scrubs, shadow: false)
        v.svg("M17 32L22 40L27 32Z", PalaceInk.shade(scrubs, 0.8))
        PalaceIcon.g4Paw.draw(v, in: CGRect(x: 12, y: 50, width: 9, height: 9), color: 0xFFFDF6, detail: scrubs)
        G4Draw.smile(v, 22, 19)
        // Stethoscope round the neck, down to the dog's chest
        v.svgLine("M17 33C13 44 18 50 23 50M27 33C30 42 28 48 25 50", 0x3E4C55, 1.3)
        v.svgLine("M24 50C26 62 46 58 60 46C68 40 74 38 82 37", 0x3E4C55, 1.3)
        v.svgLine("M31 42C40 50 62 44 80 36", scrubs, 6)
        v.rect(78, 31, 9, 9, 0x8FB6CF, radius: 3.5)
        v.dot(88, 36, 3, 0x9A9890)
        v.dot(88, 36, 1.6, 0xD3D1C7)
    }
}
