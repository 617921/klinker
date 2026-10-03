import Foundation

/// The city's soundscape under the map: canal water, a far-off murmur, rain and wind as soft
/// loops, and now and then a gull by the water, a bike bell, the tram, a boat, birds in spring,
/// crickets on summer nights, skates in winter, and the church bells on the hour.
/// What you hear follows where you look and how close you zoom.
@MainActor
final class CityAmbience {
    static let shared = CityAmbience()

    private var active = false
    private var mood = KaartMood.plainDay
    private var visible = CGRect(x: 0, y: 0, width: 400, height: 800)
    private var zoom: CGFloat = 1
    private var loop: Task<Void, Never>?
    private var due: [KlinkerSound: Date] = [:]
    private var levels: [KlinkerSound: Float] = [:]
    private var lastStrike: Int?
    private var rng = SynthRandom(seed: UInt64(Date.now.timeIntervalSince1970))

    private let audio = KlinkerAudio.shared

    /// Called by the map whenever what's on screen, the zoom, the mood or visibility changes.
    func update(active: Bool, mood: KaartMood, visible: CGRect, zoom: CGFloat) {
        self.mood = mood
        self.visible = visible
        self.zoom = zoom
        guard active != self.active else { return }
        self.active = active
        if active {
            loop = Task { [weak self] in
                while !Task.isCancelled {
                    self?.tick()
                    try? await Task.sleep(for: .milliseconds(250))
                }
            }
        } else {
            loop?.cancel()
            loop = nil
            levels = [:]
            audio.setBeds([:])
        }
    }

    // MARK: Beds

    private var targets: [KlinkerSound: Float] {
        let night = mood.night
        let close = Float(0.8 + 0.2 * min(1, zoom / 1.8))
        let nearWater: Float = visible.minY < 70 || visible.maxY > 1090 ? 0.08 : 0
        var t: [KlinkerSound: Float] = [
            .water: (0.14 + nearWater) * close * (mood.season == .winter ? 0.4 : 1),
            .murmur: night ? 0.04 : 0.1,
        ]
        if mood.rain { t[.rain] = 0.22 }
        if mood.season == .winter { t[.wind] = night ? 0.16 : 0.12 }
        return t
    }

    private func tick() {
        // Glide each bed a quarter of the way to its target, so changes swell in gently.
        let goal = targets
        for bed in KlinkerSound.allCases where bed.isBed {
            let now = levels[bed] ?? 0, target = goal[bed] ?? 0
            levels[bed] = abs(target - now) < 0.004 ? target : now + (target - now) * 0.25
        }
        audio.setBeds(levels)
        oneShots()
        bells()
    }

    // MARK: One-shots

    private func oneShots() {
        let now = Date.now
        let night = mood.night
        let warm = mood.season == .lente || mood.season == .zomer
        let center = CGPoint(x: visible.midX, y: visible.midY)
        let tram = KaartData.byNumber[12]?.point ?? CGPoint(x: 580, y: 160)
        let candidates: [(KlinkerSound, CGPoint?, ClosedRange<Double>, Float, Bool)] = [
            // sound, where (nil: around you), seconds between, volume, allowed now
            (.gull, CGPoint(x: center.x, y: visible.minY < 70 ? 20 : 1150), 7...16, 0.35, !night && (visible.minY < 90 || visible.maxY > 1070)),
            (.bikeBell, nil, 14...30, 0.18, !night && !mood.rain),
            (.tramBell, tram, 18...34, 0.3, !night),
            (.boatHorn, nil, 40...80, 0.15, !night && mood.season != .winter),
            (.songbird, CGPoint(x: 222, y: 338), 6...14, 0.3, !night && warm && mood.phase != .golden),
            (.cricket, nil, 1.5...4, 0.12, night && warm),
            (.skate, nil, 5...11, 0.25, !night && mood.season == .winter),
        ]
        for (sound, place, gap, volume, allowed) in candidates {
            guard allowed else { due[sound] = nil; continue }
            guard let when = due[sound] else {
                due[sound] = now.addingTimeInterval(gap.lowerBound * (0.3 + rng.unit()))
                continue
            }
            guard now >= when else { continue }
            due[sound] = now.addingTimeInterval(gap.lowerBound + rng.unit() * (gap.upperBound - gap.lowerBound))
            let (gain, pan) = placement(place)
            guard gain > 0.05 else { continue }
            audio.playCity(sound, volume: volume * gain, pan: pan)
        }
    }

    /// How loud and how far left/right a sound at `place` is, from what's on screen.
    private func placement(_ place: CGPoint?) -> (gain: Float, pan: Float) {
        guard let place else { return (1, Float(rng.next()) * 0.6) }
        let halfW = max(100, visible.width / 2), halfH = max(150, visible.height / 2)
        let dx = (place.x - visible.midX) / (halfW + 80), dy = (place.y - visible.midY) / (halfH + 80)
        let d = max(abs(dx), abs(dy))
        let gain = d <= 1 ? 1 - 0.4 * d : max(0, 0.6 - (d - 1) * 0.8)
        return (Float(gain), Float(max(-1, min(1, dx))) * 0.8)
    }

    /// On the hour, between eight in the morning and nine at night, the church bells strike.
    private func bells() {
        let parts = Calendar.current.dateComponents([.hour, .minute], from: .now)
        guard let hour = parts.hour, parts.minute == 0, (8...21).contains(hour), lastStrike != hour else { return }
        lastStrike = hour
        let church = KaartData.byNumber[25]?.point ?? CGPoint(x: 500, y: 400)
        let (gain, pan) = placement(church)
        audio.strike(hours: hour % 12 == 0 ? 12 : hour % 12, volume: 0.35 * max(0.4, gain), pan: pan)
    }
}
