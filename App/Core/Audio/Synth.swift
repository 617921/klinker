import Foundation

/// Tiny offline synthesizer: every Klinker sound is computed from sines, noise, filters and a
/// little reverb into a mono Float buffer. No sound files, nothing downloaded.
nonisolated enum Synth {
    static let rate = 44_100.0

    static func count(_ seconds: Double) -> Int { max(1, Int(seconds * rate)) }

    static func buffer(_ seconds: Double) -> [Float] { [Float](repeating: 0, count: count(seconds)) }

    // MARK: Tones

    /// A sine starting at `start` (s) with a short attack and an exponential decay (`decay` = time to
    /// fall to 37%). `glide` maps time since start to a frequency multiplier.
    static func sine(
        _ out: inout [Float], at start: Double, freq: Double, amp: Float, decay: Double,
        attack: Double = 0.002, length: Double? = nil, vibrato: (rate: Double, depth: Double)? = nil,
        glide: ((Double) -> Double)? = nil
    ) {
        let first = Int(start * rate)
        guard first < out.count else { return }
        // Free-ringing notes stop once they've decayed below 1% (5 time constants).
        let total = length ?? decay * 5
        let len = min(out.count - first, count(total))
        // Notes with a set length fade out over their last 15 ms instead of stopping dead (a click).
        let release = length == nil ? 0 : min(0.015, total / 3)
        let fall = exp(-1 / (decay * rate))
        let step = 2 * .pi * freq / rate
        var phase = 0.0, decayed = 1.0
        out.withUnsafeMutableBufferPointer { o in
            for i in 0..<len {
                let t = Double(i) / rate
                var inc = step
                if let glide { inc *= glide(t) }
                if let v = vibrato { inc *= 1 + v.depth * sin(2 * .pi * v.rate * t) }
                phase += inc
                var env = (t < attack ? t / attack : 1) * decayed
                decayed *= fall
                if release > 0, total - t < release { env *= max(0, (total - t) / release) }
                o[first + i] += amp * Float(env * sin(phase))
            }
        }
    }

    /// A struck bell: a set of partials (ratio to `freq`, loudness, decay factor) all struck at once.
    static func bell(_ out: inout [Float], at start: Double, freq: Double, amp: Float, decay: Double, partials: [(Double, Float, Double)]) {
        for (ratio, a, d) in partials where freq * ratio < rate / 2.2 {
            sine(&out, at: start, freq: freq * ratio, amp: amp * a, decay: decay * d, attack: 0.0015)
        }
    }

    /// Church-bell partials: hum, prime, minor third, fifth, nominal and the bright upper ones.
    static let churchBell: [(Double, Float, Double)] = [
        (0.5, 0.45, 1.6), (1, 0.6, 1.0), (1.19, 0.35, 0.8), (1.5, 0.25, 0.6), (2, 0.5, 0.5), (2.51, 0.18, 0.35), (3.0, 0.12, 0.28), (4.07, 0.06, 0.2),
    ]

    /// A small handbell or tram bell: fewer, more metallic partials.
    static let smallBell: [(Double, Float, Double)] = [
        (1, 0.7, 1.0), (2.32, 0.35, 0.6), (4.25, 0.2, 0.35), (6.1, 0.08, 0.2),
    ]

    /// Music-box tine: nearly pure with one inharmonic overtone.
    static let tine: [(Double, Float, Double)] = [(1, 0.8, 1.0), (3.0, 0.12, 0.4), (5.4, 0.05, 0.25)]

    // MARK: Noise and filters

    /// White noise in −1...1 from a fixed seed (the same sound every time).
    static func noise(_ seconds: Double, seed: UInt64) -> [Float] {
        var rng = SynthRandom(seed: seed)
        var out = [Float](repeating: 0, count: count(seconds))
        out.withUnsafeMutableBufferPointer { o in
            for i in 0..<o.count { o[i] = rng.next() }
        }
        return out
    }

    static func lowpass(_ x: inout [Float], cutoff: Double) {
        let a = Float(1 - exp(-2 * .pi * cutoff / rate))
        var y: Float = 0
        x.withUnsafeMutableBufferPointer { b in
            for i in b.indices {
                y += a * (b[i] - y)
                b[i] = y
            }
        }
    }

    static func highpass(_ x: inout [Float], cutoff: Double) {
        var low = x
        lowpass(&low, cutoff: cutoff)
        for i in x.indices { x[i] -= low[i] }
    }

    /// RBJ band-pass (constant peak gain).
    static func bandpass(_ x: inout [Float], center: Double, q: Double) {
        let w = 2 * .pi * center / rate
        let alpha = sin(w) / (2 * q)
        let a0 = 1 + alpha
        let b0 = Float(alpha / a0), b2 = Float(-alpha / a0)
        let a1 = Float(-2 * cos(w) / a0), a2 = Float((1 - alpha) / a0)
        var x1: Float = 0, x2: Float = 0, y1: Float = 0, y2: Float = 0
        x.withUnsafeMutableBufferPointer { b in
            for i in b.indices {
                let x0 = b[i]
                let y0 = b0 * x0 + b2 * x2 - a1 * y1 - a2 * y2
                x2 = x1; x1 = x0; y2 = y1; y1 = y0
                b[i] = y0
            }
        }
    }

    /// Adds `src` into `out` from `start` seconds, scaled.
    static func mix(_ out: inout [Float], _ src: [Float], at start: Double = 0, gain: Float = 1) {
        let first = Int(start * rate)
        guard first < out.count else { return }
        let n = min(src.count, out.count - first)
        out.withUnsafeMutableBufferPointer { o in
            src.withUnsafeBufferPointer { s in
                for i in 0..<n { o[first + i] += s[i] * gain }
            }
        }
    }

    /// Multiplies by an envelope given as (time, level) points, linear in between.
    static func shape(_ x: inout [Float], _ points: [(Double, Float)]) {
        guard let last = points.last else { return }
        var p = 0
        x.withUnsafeMutableBufferPointer { x in
        for i in 0..<x.count {
            let t = Double(i) / rate
            while p + 1 < points.count && points[p + 1].0 <= t { p += 1 }
            let level: Float
            if t >= last.0 {
                level = last.1
            } else {
                let (t0, l0) = points[p], (t1, l1) = points[min(p + 1, points.count - 1)]
                let f = t1 > t0 ? Float((t - t0) / (t1 - t0)) : 0
                level = l0 + (l1 - l0) * f
            }
            x[i] *= level
        }
        }
    }

    /// A small room: four combs and two all-passes (Schroeder), mixed `wet` with the dry sound.
    static func reverb(_ x: [Float], wet: Float, size: Double = 1, tail: Double = 1.2) -> [Float] {
        let dry = x + [Float](repeating: 0, count: count(tail))
        var acc = [Float](repeating: 0, count: dry.count)
        dry.withUnsafeBufferPointer { d in
            acc.withUnsafeMutableBufferPointer { a in
                for (delay, feedback) in [(0.0297, Float(0.77)), (0.0371, 0.75), (0.0411, 0.73), (0.0437, 0.71)] {
                    let n = max(1, Int(delay * size * rate))
                    var line = [Float](repeating: 0, count: n)
                    line.withUnsafeMutableBufferPointer { l in
                        var idx = 0
                        for i in 0..<d.count {
                            let y = l[idx]
                            l[idx] = d[i] + y * feedback
                            a[i] += y
                            idx += 1
                            if idx == n { idx = 0 }
                        }
                    }
                }
                for delay in [0.005, 0.0017] {
                    let n = max(1, Int(delay * rate))
                    var line = [Float](repeating: 0, count: n)
                    line.withUnsafeMutableBufferPointer { l in
                        var idx = 0
                        for i in 0..<a.count {
                            let input = a[i]
                            let y = -0.7 * input + l[idx]
                            l[idx] = input + 0.7 * y
                            a[i] = y
                            idx += 1
                            if idx == n { idx = 0 }
                        }
                    }
                }
            }
        }
        let k = wet * 0.25
        var out = dry
        out.withUnsafeMutableBufferPointer { o in
            acc.withUnsafeBufferPointer { a in
                for i in 0..<o.count { o[i] += a[i] * k }
            }
        }
        return out
    }

    /// Scales so the loudest sample is `peak`.
    static func normalize(_ x: inout [Float], peak: Float) {
        let m = x.reduce(0) { max($0, abs($1)) }
        guard m > 0 else { return }
        let k = peak / m
        for i in x.indices { x[i] *= k }
    }

    /// Fades the start and end so a sound never clicks.
    static func edges(_ x: inout [Float], fadeIn: Double = 0.002, fadeOut: Double = 0.03) {
        let a = min(x.count, count(fadeIn)), b = min(x.count, count(fadeOut))
        for i in 0..<a { x[i] *= Float(i) / Float(a) }
        for i in 0..<b { x[x.count - 1 - i] *= Float(i) / Float(b) }
    }

    /// Makes a buffer loop without a seam by crossfading its tail into its head.
    static func loopable(_ x: [Float], crossfade: Double) -> [Float] {
        let f = count(crossfade)
        guard x.count > 2 * f else { return x }
        var out = Array(x[0..<(x.count - f)])
        for i in 0..<f {
            let g = Float(i) / Float(f)
            out[i] = out[i] * g + x[x.count - f + i] * (1 - g)
        }
        return out
    }

    /// Equal-tempered frequency of a note name like "C5", "F#4", "Bb3".
    static func note(_ name: String) -> Double {
        let letters: [Character: Int] = ["C": 0, "D": 2, "E": 4, "F": 5, "G": 7, "A": 9, "B": 11]
        var chars = Array(name)
        guard let base = letters[chars.removeFirst()] else { return 440 }
        var semis = base
        if chars.first == "#" { semis += 1; chars.removeFirst() }
        if chars.first == "b" { semis -= 1; chars.removeFirst() }
        let octave = Int(String(chars)) ?? 4
        let midi = 12 * (octave + 1) + semis
        return 440 * pow(2, Double(midi - 69) / 12)
    }
}

/// xorshift64*, a small fast seeded generator.
nonisolated struct SynthRandom {
    private var state: UInt64

    init(seed: UInt64) { state = seed &* 0x9E37_79B9_7F4A_7C15 | 1 }

    /// −1...1
    mutating func next() -> Float {
        state ^= state >> 12; state ^= state << 25; state ^= state >> 27
        let v = state &* 0x2545_F491_4F6C_DD1D
        return Float(Double(v >> 11) / Double(1 << 53)) * 2 - 1
    }

    /// 0...1
    mutating func unit() -> Double { Double(next() + 1) / 2 }
}
