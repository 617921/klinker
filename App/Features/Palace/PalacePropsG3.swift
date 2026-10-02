import SwiftUI

/// Dispatch for the g3 props (hospital, gym, hairdresser, university, language school, dentist).
/// Each prop is described where it is drawn.
enum G3Props {
    static func draw(_ kind: PalacePropKind, _ pen: PropPen, _ p: PalacePropParams) {
        switch kind {
        case .g3Door: G3Hospital.door(pen, p)
        case .g3Drip: G3Hospital.drip(pen, p)
        case .g3Bed: G3Hospital.bed(pen, p)
        case .g3PillWeek: G3Hospital.pillWeek(pen, p)
        case .g3Worker: G3Workers.worker(pen, p)
        case .g3Tooth: G3Dentist.tooth(pen, p)
        case .g3Face: G3Dentist.face(pen, p)
        case .g3DentalChair: G3Dentist.chair(pen, p)
        case .g3Patient: G3DentalPatients.patient(pen, p)
        case .g3Lockers: G3Gym.lockers(pen, p)
        case .g3Treadmill: G3Gym.treadmill(pen, p)
        case .g3Bike: G3Gym.bike(pen, p)
        case .g3Streak: G3Gym.streak(pen, p)
        case .g3CutCard: G3Gym.cutCard(pen, p)
        case .g3Athlete: G3Athletes.athlete(pen, p)
        case .g3Head: G3Salon.head(pen, p)
        case .g3SalonChair: G3Salon.chair(pen, p)
        case .g3StylePoster: G3Salon.stylePoster(pen, p)
        case .g3HairLock: G3Salon.hairLock(pen, p)
        case .g3DyeBowl: G3Salon.dyeBowl(pen, p)
        case .g3Lecture: G3Study.lecture(pen, p)
        case .g3Thesis: G3Study.thesis(pen, p)
        case .g3Retry: G3Study.retry(pen, p)
        case .g3Levels: G3Study.levels(pen, p)
        case .g3Chest: G3Language.chest(pen, p)
        case .g3MouthChart: G3Language.mouthChart(pen, p)
        case .g3Tangle: G3Language.tangle(pen, p)
        case .g3Countdown: G3Language.countdown(pen, p)
        case .g3Speaker: G3Language.speaker(pen, p)
        default: break
        }
    }
}

/// Parts shared by the g3 figures, in the 64 × 114 standing design of `PalaceFigures.person`:
/// head centre (22, 19), shoulders at y 42, feet at y 108, facing right.
enum G3Body {
    typealias Look = PalaceFigures.Look

    static func shadow(_ f: PropPen, width: CGFloat = 52) {
        f.oval(6, 106, width, 6, 0x1E1E1C, 0.16)
    }

    static func legs(_ f: PropPen, _ trousers: UInt32, shoes: UInt32 = 0x2E2117) {
        f.svgLine("M17 84V104M27 84V104", trousers, 5)
        f.svg("M12 103H21V108H12Z M23 103H32V108H23Z", shoes)
    }

    /// The upper body down to `hem` (88: a coat to the knees, 74: a tunic).
    static func torso(_ f: PropPen, _ colour: UInt32, hem: CGFloat = 88) {
        f.svg("M9 \(hem)L10.5 44C11.5 36 15.5 32 22 32C28.5 32 32.5 36 33.5 44L35 \(hem)Z", colour)
    }

    /// Head, short hair (or none) and an eye.
    static func head(_ f: PropPen, skin: UInt32, hair: UInt32?, eye: Bool = true) {
        f.dot(22, 19, 11, skin)
        if let hair {
            f.svg("M11 18C10 10 15 6 22 6C29 6 34 10 33 18C31 13 27 11.5 22 11.5C17 11.5 13 13 11 18Z", hair)
        }
        if eye { f.dot(28, 19.5, 1.3, 0x2E2117) }
    }

    static func smile(_ f: PropPen) {
        f.svgLine("M25.5 25Q27.5 26.8 29.5 25", 0x8C5A3C, 1.1)
    }

    /// An arm along SVG path `d` in `sleeve`, with a hand at `hand`.
    static func arm(_ f: PropPen, _ d: String, _ sleeve: UInt32, hand: CGPoint, skin: UInt32, width: CGFloat = 6) {
        f.svgLine(d, sleeve, width)
        f.dot(hand.x, hand.y, 3.1, skin)
    }

    /// A drop of sweat (point up) at `x`, `y`, `s` high.
    static func sweat(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ s: CGFloat = 6) {
        f.svg("M\(x) \(y)Q\(x + s * 0.42) \(y + s * 0.62) \(x) \(y + s)Q\(x - s * 0.42) \(y + s * 0.62) \(x) \(y)Z", 0x8FB6CF)
    }

    /// A speech bubble with one line of lettering and a tail towards `tail`.
    static func bubble(_ f: PropPen, _ r: CGRect, _ text: String, tail: CGPoint, size: CGFloat = 9) {
        f.rect(r.offsetBy(dx: 1, dy: 1.5), 0x1E1E1C, radius: 7, 0.12)
        let base = min(max(tail.x, r.minX + 8), r.maxX - 8)
        f.svg("M\(base - 4) \(r.maxY - 1)L\(tail.x) \(tail.y)L\(base + 4) \(r.maxY - 1)Z", 0xFFFDF6)
        f.rect(r, 0xFFFDF6, radius: 7)
        f.stroke(Path(roundedRect: r, cornerRadius: 7), 0x5E6B73, 1)
        f.svg("M\(base - 3.2) \(r.maxY - 1.2)L\(tail.x) \(tail.y)L\(base + 3.2) \(r.maxY - 1.2)Z", 0xFFFDF6)
        f.svgLine("M\(base - 4) \(r.maxY)L\(tail.x) \(tail.y)L\(base + 4) \(r.maxY)", 0x5E6B73, 1)
        f.text(text, PropFont.demi(size), 0x1E1E1C, at: CGPoint(x: r.midX, y: r.midY + 0.5), maxWidth: r.width - 8)
    }

    /// A short-sleeved arm: sleeve to the elbow, bare forearm.
    static func shortSleeve(_ f: PropPen, upper: String, fore: String, _ sleeve: UInt32, hand: CGPoint, skin: UInt32) {
        f.svgLine(fore, skin, 4.6)
        f.svgLine(upper, sleeve, 6.4)
        f.dot(hand.x, hand.y, 3, skin)
    }
}
