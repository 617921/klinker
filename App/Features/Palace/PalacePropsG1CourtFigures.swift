import SwiftUI

/// People in the courtroom (`g1Person` accessories), all in a black gown with a white bib where
/// they wear one: "judge" (seen from the front behind the bench, cut at its top, 64 × 84),
/// "lawyer" (standing behind a table with a thick folder, 88 × 128), "guilty" (in the dock, head
/// bowed, hands folded, `text` in a bubble, 90 × 150).
enum G1CourtFigures {
    typealias Look = PalaceFigures.Look

    static let gown: UInt32 = 0x1E1E1C

    static func draw(_ pen: PropPen, _ p: PalacePropParams) {
        let v = Look.at(p.variant ?? 4)
        switch p.accessory {
        case "judge": judge(pen.fitted(CGSize(width: 64, height: 84)), v)
        case "lawyer": lawyer(pen.fitted(CGSize(width: 88, height: 128)), v)
        default: guilty(pen.fitted(CGSize(width: 90, height: 150)), v, p.text)
        }
    }

    /// The white bib under the chin, centred on x.
    private static func bib(_ f: PropPen, x: CGFloat, y: CGFloat, s: CGFloat = 1) {
        f.svg("M\(x - 3.5 * s) \(y)H\(x + 3.5 * s)L\(x + 4 * s) \(y + 10 * s)H\(x + 0.4 * s)V\(y + 3 * s)H\(x - 0.4 * s)V\(y + 10 * s)H\(x - 4 * s)Z", 0xFFFDF6)
    }

    // MARK: Judge

    static func judge(_ f: PropPen, _ v: Look) {
        f.svg("M4 84V60C4 46 16 40 32 40C48 40 60 46 60 60V84Z", gown)
        f.svgLine("M22 44V84M42 44V84", 0x3E4C55, 1.2)
        bib(f, x: 32, y: 40, s: 1.3)
        f.rect(28.5, 33, 7, 8, PalaceInk.shade(v.skin, 0.9))
        f.dot(32, 23, 12, v.skin)
        f.svg("M19 24C17 12 24 9 32 9C40 9 47 12 45 24C43 17 39 15 32 15C25 15 21 17 19 24Z", 0xD3D1C7)
        f.ring(27.5, 24, 3.4, 0x2E2117, 1.1)
        f.ring(36.5, 24, 3.4, 0x2E2117, 1.1)
        f.svgLine("M30.9 24H33.1", 0x2E2117, 1.1)
        f.svgLine("M28 30.5H36", 0x8C5A3C, 1.2)
        f.svgLine("M8 62C8 72 12 78 20 80M56 62C56 72 52 78 44 80", 0x2E2E2C, 7)
        f.dot(22, 80, 3.6, v.skin)
        f.dot(42, 80, 3.6, v.skin)
    }

    // MARK: Lawyer

    static func lawyer(_ f: PropPen, _ v: Look) {
        f.oval(4, 122, 80, 6, 0x1E1E1C, 0.16)
        let me = f.within(CGRect(x: 4, y: 0, width: 64, height: 114))
        me.svg("M7 100L9.5 44C10.5 36 15.5 32 22 32C28.5 32 33.5 36 34.5 44L37 100Z", gown)
        bib(me, x: 22, y: 33)
        G1People.head(me, v, mood: "open")
        me.svgLine("M13 42C10 52 12 62 18 68", 0x2E2E2C, 6)
        me.svgLine("M31 42C38 46 44 44 50 36", 0x2E2E2C, 6)
        me.dot(51, 34, 3.2, v.skin)
        me.svgLine("M53 32L57 26", v.skin, 2.2)
        // The table in front with a thick folder
        f.rect(0, 84, 88, 6, 0x8C5E38, radius: 1)
        f.rect(4, 90, 80, 32, 0x7A5230)
        f.rect(10, 94, 68, 24, 0x6B4A2E)
        f.svg("M30 84L34 72H64L60 84Z", 0x2F5BD3)
        f.svg("M32 80L36 70H62L58 80Z", 0xFFFDF6)
        f.svg("M30 84L34 74H64L60 84Z", 0x21468B, 0.5)
    }

    // MARK: Guilty

    static func guilty(_ f: PropPen, _ v: Look, _ text: String?) {
        let me = f.within(CGRect(x: 14, y: 30, width: 64, height: 114))
        G1People.body(me, v, coat: 0x8C9499, backArm: false)
        me.svgLine("M13 42C12 54 16 62 22 64M31 42C32 54 28 62 24 64", PalaceInk.shade(0x8C9499, 0.8), 6)
        me.dot(23, 65, 3.6, v.skin)
        // Head bowed: lower and turned down, a sad mouth, a sweat drop
        me.dot(22, 22, 11, v.skin)
        me.svg("M11 20C10 12 15 8 22 8C29 8 34 12 33 20C31 15 27 13.5 22 13.5C17 13.5 13 15 11 20Z", v.hair)
        me.svgLine("M25 22.5Q27 24 29 22.5", 0x2E2117, 1.2)
        me.svgLine("M25 29Q27.5 27 30 29", 0x8C5A3C, 1.2)
        me.svg("M34 14Q36.5 18 34 20Q31.5 18 34 14Z", 0x5DCAA5)
        // The dock in front
        f.rect(0, 104, 90, 6, 0x8C5E38, radius: 1)
        f.rect(4, 110, 82, 40, 0x7A5230)
        f.svgLine("M18 110V150M36 110V150M54 110V150M72 110V150", 0x6B4A2E, 3)
        if let text {
            G1Props.bubble(f, CGRect(x: 6, y: 0, width: 84, height: 22), text, tail: CGPoint(x: 40, y: 34), font: PropFont.heavy(9))
        }
    }
}
