import Foundation

/// Every sound in Klinker. Effects play once; the city sounds come from `CityAmbience`.
nonisolated enum KlinkerSound: String, CaseIterable, Sendable {
    // Feedback
    case correct, wrong, tap, paper
    // Moments
    case roundDone, built, snip, applause, pops, found
    // Things in the city
    case bikeBell, tramBell, boatHorn, organ, register, splash, gull, songbird, cricket, skate
    // Beds that loop softly under the city
    case water, murmur, rain, wind

    var isBed: Bool {
        switch self {
        case .water, .murmur, .rain, .wind: true
        default: false
        }
    }
}

/// Renders each sound from scratch (see `Synth`). Pure functions, safe off the main thread.
nonisolated enum SoundBank {
    static func render(_ sound: KlinkerSound) -> [Float] {
        switch sound {
        case .correct: correct()
        case .wrong: wrong()
        case .tap: tap()
        case .paper: paper()
        case .roundDone: carillon(["C5", "E5", "G5", "C6"], step: 0.17, ring: 2.2, peak: 0.7)
        case .built: built()
        case .snip: snip()
        case .applause: applause()
        case .pops: pops()
        case .found: found()
        case .bikeBell: bikeBell(rings: 2)
        case .tramBell: tramBell()
        case .boatHorn: boatHorn()
        case .organ: organ()
        case .register: register()
        case .splash: splash()
        case .gull: gull()
        case .songbird: songbird()
        case .cricket: cricket()
        case .skate: skate()
        case .water: water()
        case .murmur: murmur()
        case .rain: rain()
        case .wind: wind()
        }
    }

    /// The church bells striking `hours` times (1...12).
    static func strike(_ hours: Int) -> [Float] {
        let n = max(1, min(12, hours))
        var out = Synth.buffer(Double(n) * 1.5 + 3)
        for i in 0..<n {
            Synth.bell(&out, at: 0.05 + Double(i) * 1.5, freq: Synth.note("G3"), amp: 0.5, decay: 1.6, partials: Synth.churchBell)
        }
        var wet = Synth.reverb(out, wet: 0.9, size: 1.6, tail: 1.5)
        Synth.normalize(&wet, peak: 0.6)
        Synth.edges(&wet, fadeOut: 0.8)
        return wet
    }

    // MARK: Feedback

    /// A bicycle bell: the hammer rattles against the dome ("trring").
    static func bikeBell(rings: Int) -> [Float] {
        var out = Synth.buffer(0.55 * Double(rings) + 0.5)
        var rng = SynthRandom(seed: 41)
        for r in 0..<rings {
            let start = Double(r) * 0.42
            var t = 0.0
            while t < 0.16 {
                let a = Float(0.35 + 0.35 * rng.unit()) * Float(1 - t / 0.3)
                Synth.bell(&out, at: start + t, freq: 2650, amp: a, decay: 0.22, partials: [(1, 0.6, 1), (1.47, 0.4, 0.8), (2.09, 0.25, 0.5), (2.74, 0.12, 0.35)])
                t += 1 / 24 + rng.unit() * 0.006
            }
        }
        Synth.normalize(&out, peak: 0.55)
        Synth.edges(&out, fadeOut: 0.15)
        return out
    }

    static func correct() -> [Float] {
        var out = bikeBell(rings: 1)
        Synth.normalize(&out, peak: 0.45)
        return out
    }

    /// A soft wooden bump: low, short, not unkind.
    static func wrong() -> [Float] {
        var out = Synth.buffer(0.35)
        Synth.sine(&out, at: 0, freq: 150, amp: 0.6, decay: 0.09, glide: { t in 1 - min(0.35, t * 3) })
        Synth.sine(&out, at: 0.11, freq: 120, amp: 0.45, decay: 0.08, glide: { t in 1 - min(0.35, t * 3) })
        var click = Synth.noise(0.02, seed: 7)
        Synth.lowpass(&click, cutoff: 900)
        Synth.mix(&out, click, gain: 0.3)
        Synth.mix(&out, click, at: 0.11, gain: 0.25)
        Synth.normalize(&out, peak: 0.4)
        Synth.edges(&out)
        return out
    }

    /// A woodblock click for taps on the map.
    static func tap() -> [Float] {
        var out = Synth.buffer(0.09)
        Synth.bell(&out, at: 0, freq: 1450, amp: 0.5, decay: 0.018, partials: [(1, 0.7, 1), (2.07, 0.3, 0.6), (3.9, 0.1, 0.4)])
        var click = Synth.noise(0.006, seed: 3)
        Synth.highpass(&click, cutoff: 2000)
        Synth.mix(&out, click, gain: 0.25)
        Synth.normalize(&out, peak: 0.22)
        Synth.edges(&out, fadeOut: 0.02)
        return out
    }

    /// Paper sliding: a few soft crinkles.
    static func paper() -> [Float] {
        var out = Synth.noise(0.28, seed: 11)
        Synth.bandpass(&out, center: 3200, q: 0.6)
        var rng = SynthRandom(seed: 12)
        var points: [(Double, Float)] = [(0, 0)]
        var t = 0.0
        while t < 0.24 {
            t += 0.02 + rng.unit() * 0.03
            points.append((t, Float(0.3 + 0.7 * rng.unit()) * Float(1 - t / 0.3)))
        }
        points.append((0.28, 0))
        Synth.shape(&out, points)
        Synth.normalize(&out, peak: 0.12)
        return out
    }

    // MARK: Moments

    /// Carillon notes struck one after another, then left ringing in the square.
    static func carillon(_ notes: [String], step: Double, ring: Double, peak: Float) -> [Float] {
        var out = Synth.buffer(Double(notes.count) * step + ring)
        for (i, name) in notes.enumerated() {
            Synth.bell(&out, at: 0.02 + Double(i) * step, freq: Synth.note(name), amp: 0.5, decay: 0.9, partials: Synth.churchBell)
        }
        var wet = Synth.reverb(out, wet: 0.8, size: 1.3, tail: 1.2)
        Synth.normalize(&wet, peak: peak)
        Synth.edges(&wet, fadeOut: 0.5)
        return wet
    }

    /// A place is built: a descending peal and a full chord.
    static func built() -> [Float] {
        var out = carillon(["C6", "B5", "A5", "G5", "F5", "E5", "D5", "C5"], step: 0.15, ring: 0.2, peak: 0.6)
        var chord = Synth.buffer(3.2)
        for name in ["C4", "C5", "E5", "G5"] {
            Synth.bell(&chord, at: 0, freq: Synth.note(name), amp: 0.4, decay: 1.4, partials: Synth.churchBell)
        }
        chord = Synth.reverb(chord, wet: 0.8, size: 1.3, tail: 1.2)
        Synth.normalize(&chord, peak: 0.6)
        out += [Float](repeating: 0, count: max(0, Synth.count(1.25) + chord.count - out.count))
        Synth.mix(&out, chord, at: 1.25)
        Synth.normalize(&out, peak: 0.7)
        Synth.edges(&out, fadeOut: 0.6)
        return out
    }

    /// Scissors cutting the ribbon: two quick metallic snaps.
    static func snip() -> [Float] {
        var out = Synth.buffer(0.3)
        for (i, start) in [0.0, 0.085].enumerated() {
            var shh = Synth.noise(0.05, seed: UInt64(20 + i))
            Synth.highpass(&shh, cutoff: 3500)
            Synth.shape(&shh, [(0, 0), (0.004, 1), (0.05, 0)])
            Synth.mix(&out, shh, at: start, gain: 0.5)
            Synth.sine(&out, at: start + 0.035, freq: 3400 - Double(i) * 300, amp: 0.3, decay: 0.012)
        }
        Synth.normalize(&out, peak: 0.45)
        Synth.edges(&out)
        return out
    }

    /// A small crowd clapping.
    static func applause() -> [Float] {
        let length = 1.9
        var out = Synth.buffer(length)
        var rng = SynthRandom(seed: 77)
        var t = 0.0
        while t < length - 0.1 {
            var clap = Synth.noise(0.03, seed: UInt64(t * 10_000) + 5)
            Synth.bandpass(&clap, center: 900 + rng.unit() * 1600, q: 1.2)
            Synth.shape(&clap, [(0, 0), (0.001, 1), (0.03, 0)])
            let swell = Float(min(1, t / 0.25) * max(0, min(1, (length - t) / 0.9)))
            Synth.mix(&out, clap, at: t, gain: swell * Float(0.5 + 0.5 * rng.unit()))
            t += 0.012 + rng.unit() * 0.03
        }
        let room = Synth.reverb(out, wet: 0.5, size: 0.8, tail: 0.5)
        out = room
        Synth.normalize(&out, peak: 0.4)
        Synth.edges(&out, fadeOut: 0.3)
        return out
    }

    /// Confetti poppers.
    static func pops() -> [Float] {
        var out = Synth.buffer(0.7)
        for (i, start) in [0.0, 0.09, 0.16, 0.3, 0.38].enumerated() {
            var burst = Synth.noise(0.04, seed: UInt64(90 + i))
            Synth.lowpass(&burst, cutoff: 2500)
            Synth.shape(&burst, [(0, 0), (0.001, 1), (0.04, 0)])
            Synth.mix(&out, burst, at: start, gain: 0.5)
            Synth.sine(&out, at: start, freq: 900 - Double(i) * 60, amp: 0.4, decay: 0.03, glide: { t in max(0.35, 1 - t * 20) })
        }
        Synth.normalize(&out, peak: 0.4)
        Synth.edges(&out)
        return out
    }

    /// A music-box arpeggio: you found something.
    static func found() -> [Float] {
        var out = Synth.buffer(1.3)
        for (i, name) in ["G5", "B5", "D6", "G6"].enumerated() {
            Synth.bell(&out, at: Double(i) * 0.075, freq: Synth.note(name), amp: 0.5, decay: 0.45, partials: Synth.tine)
        }
        var wet = Synth.reverb(out, wet: 0.4, size: 0.6, tail: 0.4)
        Synth.normalize(&wet, peak: 0.4)
        Synth.edges(&wet, fadeOut: 0.3)
        return wet
    }

    // MARK: Things in the city

    static func tramBell() -> [Float] {
        var out = Synth.buffer(1.4)
        for start in [0.0, 0.26] {
            Synth.bell(&out, at: start, freq: 1180, amp: 0.5, decay: 0.35, partials: Synth.smallBell)
        }
        Synth.normalize(&out, peak: 0.45)
        Synth.edges(&out, fadeOut: 0.3)
        return out
    }

    /// A canal boat's horn: a warm reedy toot.
    static func boatHorn() -> [Float] {
        var out = Synth.buffer(0.9)
        for n in 1...10 {
            Synth.sine(&out, at: 0, freq: 196 * Double(n), amp: 0.5 / Float(n), decay: 10, attack: 0.04, length: 0.7, vibrato: (5, 0.004))
        }
        Synth.lowpass(&out, cutoff: 1400)
        Synth.shape(&out, [(0, 1), (0.6, 1), (0.72, 0)])
        var wet = Synth.reverb(out, wet: 0.5, size: 1.2, tail: 0.6)
        Synth.normalize(&wet, peak: 0.42)
        Synth.edges(&wet, fadeOut: 0.3)
        return wet
    }

    /// The street organ plays "In Holland staat een huis" (traditional) with oom-pah and tremolo.
    static func organ() -> [Float] {
        let beat = 0.2 // one eighth note in 6/8
        let tune: [(String, Double)] = [
            ("G4", 1), ("C5", 2), ("C5", 1), ("C5", 2), ("C5", 1), ("C5", 3),
            ("D5", 1), ("E5", 2), ("E5", 1), ("E5", 2), ("E5", 1), ("E5", 3),
            ("G5", 2), ("G5", 1), ("A5", 2), ("G5", 1), ("E5", 2), ("C5", 1),
            ("D5", 2), ("E5", 1), ("E5", 2), ("D5", 1), ("D5", 2), ("C5", 4),
        ]
        let total = tune.reduce(0) { $0 + $1.1 } * beat
        var out = Synth.buffer(total + 0.8)
        var t = 0.0
        for (name, beats) in tune {
            let f = Synth.note(name), len = beats * beat * 0.92
            for (h, a) in [(1.0, 0.5), (2.0, 0.28), (3.0, 0.16), (4.0, 0.08)] as [(Double, Float)] {
                Synth.sine(&out, at: t, freq: f * h, amp: a, decay: 6, attack: 0.012, length: len, vibrato: (6.5, 0.006))
            }
            t += beats * beat
        }
        // Oom-pah: a bass note on 1 and a soft chord on 4 of each bar.
        let bars = Int((total / (6 * beat)).rounded(.up))
        let basses = ["C3", "C3", "G2", "C3"]
        for b in 0..<bars {
            let start = Double(b) * 6 * beat + beat
            Synth.sine(&out, at: start, freq: Synth.note(basses[b % 4]), amp: 0.35, decay: 0.25, attack: 0.01)
            for name in b % 4 == 2 ? ["B3", "D4", "G4"] : ["E4", "G4", "C5"] {
                Synth.sine(&out, at: start + 3 * beat, freq: Synth.note(name), amp: 0.1, decay: 0.15, attack: 0.01)
            }
        }
        Synth.lowpass(&out, cutoff: 3200)
        var wet = Synth.reverb(out, wet: 0.35, size: 0.9, tail: 0.6)
        Synth.normalize(&wet, peak: 0.4)
        Synth.edges(&wet, fadeOut: 0.5)
        return wet
    }

    /// A shop till: a bright ring and the drawer.
    static func register() -> [Float] {
        var out = Synth.buffer(0.9)
        var drawer = Synth.noise(0.12, seed: 31)
        Synth.lowpass(&drawer, cutoff: 1500)
        Synth.shape(&drawer, [(0, 0), (0.01, 1), (0.12, 0)])
        Synth.mix(&out, drawer, gain: 0.4)
        Synth.bell(&out, at: 0.08, freq: 2350, amp: 0.5, decay: 0.3, partials: Synth.smallBell)
        Synth.normalize(&out, peak: 0.4)
        Synth.edges(&out, fadeOut: 0.2)
        return out
    }

    /// Something small dipping into the water.
    static func splash() -> [Float] {
        var out = Synth.buffer(0.5)
        Synth.sine(&out, at: 0, freq: 420, amp: 0.5, decay: 0.05, glide: { t in 1 + t * 22 })
        var spray = Synth.noise(0.3, seed: 51)
        Synth.bandpass(&spray, center: 1800, q: 0.7)
        Synth.shape(&spray, [(0, 0), (0.01, 1), (0.3, 0)])
        Synth.mix(&out, spray, gain: 0.3)
        Synth.normalize(&out, peak: 0.35)
        Synth.edges(&out)
        return out
    }

    /// A herring gull far off: two "kee-ow" calls.
    static func gull() -> [Float] {
        var out = Synth.buffer(1.4)
        for (i, start) in [0.0, 0.55].enumerated() {
            let len = 0.42 - Double(i) * 0.05
            for (h, a) in [(1.0, 0.5), (2.0, 0.25), (3.0, 0.12)] as [(Double, Float)] {
                Synth.sine(&out, at: start, freq: 1350 * h, amp: a, decay: 4, attack: 0.03, length: len, glide: { t in
                    let p = t / len
                    return p < 0.3 ? 1 + p * 1.3 : 1.39 - (p - 0.3) * 0.75
                })
            }
            let first = Synth.count(start), n = Synth.count(len)
            for j in 0..<min(n, out.count - first) {
                let p = Double(j) / Double(n)
                out[first + j] *= Float(sin(.pi * p)) * Float(0.75 + 0.25 * sin(2 * .pi * 38 * Double(j) / Synth.rate))
            }
        }
        Synth.lowpass(&out, cutoff: 3500)
        var wet = Synth.reverb(out, wet: 0.45, size: 1.2, tail: 0.5)
        Synth.normalize(&wet, peak: 0.3)
        Synth.edges(&wet, fadeOut: 0.3)
        return wet
    }

    /// A blackbird-ish phrase of quick whistles.
    static func songbird() -> [Float] {
        var out = Synth.buffer(1.3)
        var rng = SynthRandom(seed: 61)
        var t = 0.0
        for _ in 0..<6 {
            let f = 2600 + rng.unit() * 1600, len = 0.06 + rng.unit() * 0.08
            let up = rng.unit() > 0.5
            Synth.sine(&out, at: t, freq: f, amp: 0.4, decay: 4, attack: 0.01, length: len, glide: { s in up ? 1 + s * 3 : 1 - s * 2.5 })
            t += len + 0.03 + rng.unit() * 0.08
        }
        var wet = Synth.reverb(out, wet: 0.2, size: 0.6, tail: 0.3)
        Synth.normalize(&wet, peak: 0.25)
        Synth.edges(&wet, fadeOut: 0.2)
        return wet
    }

    /// A cricket's three-pulse chirp, twice.
    static func cricket() -> [Float] {
        var out = Synth.buffer(0.6)
        for group in [0.0, 0.3] {
            for p in 0..<3 {
                Synth.sine(&out, at: group + Double(p) * 0.035, freq: 4600, amp: 0.4, decay: 0.008, attack: 0.003, length: 0.02)
            }
        }
        Synth.normalize(&out, peak: 0.18)
        Synth.edges(&out)
        return out
    }

    /// Skates on canal ice: a long scrape.
    static func skate() -> [Float] {
        var out = Synth.noise(0.9, seed: 71)
        Synth.bandpass(&out, center: 2400, q: 0.9)
        Synth.shape(&out, [(0, 0), (0.15, 0.8), (0.55, 1), (0.9, 0)])
        Synth.normalize(&out, peak: 0.2)
        return out
    }

    // MARK: Beds (seamless loops)

    /// Canal water lapping against the quay.
    static func water() -> [Float] {
        let length = 12.0
        var out = Synth.noise(length + 1, seed: 101)
        Synth.lowpass(&out, cutoff: 450)
        Synth.lowpass(&out, cutoff: 450)
        var rng = SynthRandom(seed: 102)
        var swell: [(Double, Float)] = []
        var t = 0.0
        while t < length + 1 {
            swell.append((t, Float(0.35 + 0.65 * rng.unit())))
            t += 0.5 + rng.unit() * 1.2
        }
        Synth.shape(&out, swell)
        var laps = Synth.buffer(length + 1)
        t = 0.3
        while t < length + 0.5 {
            var lap = Synth.noise(0.25, seed: UInt64(t * 100) + 9)
            Synth.bandpass(&lap, center: 600 + rng.unit() * 500, q: 1.5)
            Synth.shape(&lap, [(0, 0), (0.04, 1), (0.25, 0)])
            Synth.mix(&laps, lap, at: t, gain: Float(0.3 + 0.4 * rng.unit()))
            t += 0.6 + rng.unit() * 1.4
        }
        Synth.mix(&out, laps)
        var loop = Synth.loopable(out, crossfade: 1)
        Synth.normalize(&loop, peak: 0.5)
        return loop
    }

    /// The city far away: a low, soft hum of traffic and voices.
    static func murmur() -> [Float] {
        var out = Synth.noise(13, seed: 111)
        Synth.lowpass(&out, cutoff: 220)
        Synth.lowpass(&out, cutoff: 260)
        var loop = Synth.loopable(out, crossfade: 1)
        Synth.normalize(&loop, peak: 0.5)
        return loop
    }

    /// Dutch drizzle: a soft hiss and drops on roofs and water.
    static func rain() -> [Float] {
        let length = 10.0
        var out = Synth.noise(length + 1, seed: 121)
        Synth.highpass(&out, cutoff: 1500)
        Synth.lowpass(&out, cutoff: 6000)
        for i in out.indices { out[i] *= 0.35 }
        var rng = SynthRandom(seed: 122)
        var t = 0.0
        while t < length + 0.9 {
            var drop = Synth.noise(0.012, seed: UInt64(t * 1000) + 3)
            Synth.bandpass(&drop, center: 2500 + rng.unit() * 2500, q: 2)
            Synth.mix(&out, drop, at: t, gain: Float(0.4 + 0.6 * rng.unit()))
            t += 0.01 + rng.unit() * 0.04
        }
        var loop = Synth.loopable(out, crossfade: 1)
        Synth.normalize(&loop, peak: 0.5)
        return loop
    }

    /// Winter wind round the houses.
    static func wind() -> [Float] {
        let length = 12.0
        var out = Synth.noise(length + 1, seed: 131)
        Synth.bandpass(&out, center: 420, q: 0.8)
        var rng = SynthRandom(seed: 132)
        var gusts: [(Double, Float)] = []
        var t = 0.0
        while t < length + 1 {
            gusts.append((t, Float(0.2 + 0.8 * rng.unit())))
            t += 1.5 + rng.unit() * 2.5
        }
        Synth.shape(&out, gusts)
        var loop = Synth.loopable(out, crossfade: 1.5)
        Synth.normalize(&loop, peak: 0.5)
        return loop
    }
}
