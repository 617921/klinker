import SwiftUI

/// People in motion for the park: a runner, someone walking a dog on a lead, and two people out
/// for a stroll arm in arm. Same build as `PalaceFigures.person`, facing right.
enum PalaceParkPeople {
    typealias Look = PalaceFigures.Look

    // MARK: Runner

    /// A runner mid-stride (70 × 114): leaning forward, headband, speed lines, a drop of sweat.
    /// `variant` picks the shirt and skin.
    static func runner(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 70, height: 114))
        let v = Look.at(p.variant ?? 6)
        f.oval(8, 107, 52, 6, 0x1E1E1C, 0.15)
        f.svgLine("M2 44H14M0 56H10M4 68H15", 0xB4B2A9, 2)
        f.svgLine("M30 40L21 50L28 58", v.skin, 4.5)
        f.svgLine("M30 70L21 86L9 90", v.skin, 5.5)
        f.svg("M1 87Q1 94 8 94H15Q16 90 12 88Z", 0x2F5BD3)
        f.svgLine("M34 70L46 83L42 101", v.skin, 5.5)
        f.svg("M36 99H49Q53 103 49 107H36Z", 0x2F5BD3)
        f.svgLine("M37 105H49", 0xFFFDF6, 1.4)
        f.svg("M24 62H41L43 76L34 77L32 71L29 77L22 75Z", 0x1E1E1C)
        f.svg("M23 64L27 38C28 33 32 30 37 31C42 32 44 36 43 41L40 64Z", v.coat)
        f.rect(29, 46, 10, 8, 0xFFFDF6, radius: 1)
        f.svgLine("M31 49H37M31 51.5H35", 0xB4B2A9, 1)
        f.svgLine("M39 40L43 44", v.coat, 6.5)
        f.svgLine("M42 43L48 48L55 40", v.skin, 4.5)
        f.dot(40, 20, 10, v.skin)
        f.svg("M30 19C29 11 34 8 40 8C47 8 51 12 50 18C47 14 44 13 40 13C35 13 32 15 30 19Z", v.hair)
        f.svgLine("M30.5 16.5Q40 11.5 49.8 15.5", 0xC8261B, 3)
        f.dot(45.5, 20.5, 1.3, 0x2E2117)
        f.svg("M55 10Q57.5 14.5 55 16Q52.5 14.5 55 10Z", 0x8FB6CF)
        f.svg("M58 20Q60 23.5 58 24.8Q56 23.5 58 20Z", 0x8FB6CF)
    }

    // MARK: Dog walker

    /// Someone walking a dog on a red lead (112 × 114). `variant` picks the person's look.
    static func dogWalker(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 112, height: 114))
        let v = Look.at(p.variant ?? 3)
        f.oval(4, 107, 104, 6, 0x1E1E1C, 0.15)
        walker(f, x: 0, v, hair: v.hair, hat: false)
        f.svgLine("M33 42C38 50 42 56 48 60", v.coat, 6)
        f.dot(49, 61, 3.2, v.skin)
        f.svgLine("M50 61Q70 78 92 80", 0xC8261B, 1.8)
        dog(f, 0xC9A15B)
    }

    /// A dog walking right, its collar at about (95, 81).
    static func dog(_ f: PropPen, _ coat: UInt32) {
        let dark = PalaceInk.shade(coat, 0.72)
        f.svgLine("M74 90L71 104M80 91L83 104M93 90L91 104M98 89L101 104", coat, 3.8)
        f.svgLine("M72 84Q64 77 66 69", coat, 3.2)
        f.rect(69, 79, 32, 14, coat, radius: 7)
        f.dot(102, 76, 7.5, coat)
        f.rect(103, 76, 8, 6, PalaceInk.shade(coat, 1.15), radius: 3)
        f.dot(110.5, 78, 1.7, 0x1E1E1C)
        f.svg("M97 70Q94 79 98.5 83Q101.5 76 100.5 70Z", dark)
        f.dot(104.5, 73.5, 1.2, 0x1E1E1C)
        f.svgLine("M95.5 79L98.5 86", 0xC8261B, 2.6)
    }

    // MARK: Strollers

    /// Two people out for a walk, arm in arm, one with a walking stick and one with a hat (84 × 114).
    static func strollers(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 84, height: 114))
        let back = Look.at(p.variant ?? 2), front = Look.at((p.variant ?? 2) + 3)
        f.oval(2, 107, 82, 6, 0x1E1E1C, 0.15)
        walker(f.within(CGRect(x: 30, y: -2, width: 64, height: 114)), x: 0, back, hair: 0xD3D1C7, hat: false)
        f.svgLine("M63 42C68 52 69 62 68 70", back.coat, 6)
        f.dot(68, 72, 3.1, back.skin)
        f.svgLine("M69 72L74 108", 0x4A3524, 2.2)
        walker(f, x: 2, front, hair: 0xB4B2A9, hat: true)
        f.svgLine("M35 42C39 50 41 54 46 56", front.coat, 6)
        f.svgLine("M46 56L52 50", PalaceInk.shade(back.coat, 0.78), 5)
    }

    /// The walking body shared by the park people: legs in stride, coat, far arm, head and hair.
    /// Its coat sits between x + 11 and x + 37; the near arm is left to the caller.
    static func walker(_ f: PropPen, x: CGFloat, _ v: Look, hair: UInt32, hat: Bool) {
        let dark = PalaceInk.shade(v.coat, 0.78)
        f.svgLine("M\(x + 20) 84L\(x + 14) 104M\(x + 28) 84L\(x + 35) 104", v.trousers, 5)
        f.svg("M\(x + 9) 102H\(x + 18)V107H\(x + 9)Z M\(x + 31) 102H\(x + 40)V107H\(x + 31)Z", 0x2E2117)
        f.svg("M\(x + 11) 88L\(x + 12.5) 44C\(x + 13.5) 36 \(x + 17.5) 32 \(x + 24) 32C\(x + 30.5) 32 \(x + 34.5) 36 \(x + 35.5) 44L\(x + 37) 88Z", v.coat)
        f.svgLine("M\(x + 24) 40V86", dark, 1.2)
        f.svg("M\(x + 19) 32L\(x + 24) 39L\(x + 29) 32Z", 0xEFEBE2)
        f.svgLine("M\(x + 15) 42C\(x + 12) 52 \(x + 12) 62 \(x + 14) 70", dark, 6)
        f.dot(x + 14.5, 72, 3.1, v.skin)
        f.dot(x + 24, 19, 11, v.skin)
        f.svg("M\(x + 13) 18C\(x + 12) 10 \(x + 17) 6 \(x + 24) 6C\(x + 31) 6 \(x + 36) 10 \(x + 35) 18C\(x + 33) 13 \(x + 29) 11.5 \(x + 24) 11.5C\(x + 19) 11.5 \(x + 15) 13 \(x + 13) 18Z", hair)
        if hat {
            f.svg("M\(x + 12) 11H\(x + 36)V13H\(x + 12)Z M\(x + 16) 11V5Q\(x + 16) 2 \(x + 20) 2H\(x + 28)Q\(x + 32) 2 \(x + 32) 5V11Z", 0x4A3524)
            f.rect(x + 16, 8, 16, 2, 0xC8261B)
        }
        f.dot(x + 30, 19.5, 1.3, 0x2E2117)
    }
}
