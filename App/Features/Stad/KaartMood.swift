import Foundation

/// The light over the city through the day.
nonisolated enum KaartLightPhase: Sendable {
    /// Half an hour before sunrise to an hour after: pink morning.
    case dawn
    case day
    /// The last ninety minutes before sunset to half an hour after: golden hour.
    case golden
    case night
}

/// Sunrise and sunset in Amsterdam, close enough for a picture: the day is about 7¾ hours
/// in late December and 16¾ in late June, centred on solar noon (12:40 in winter time).
nonisolated enum KaartSun {
    /// Hours after local midnight, e.g. 21.9 for 21:54.
    static func times(on date: Date, calendar: Calendar = .current) -> (rise: Double, set: Double) {
        let day = Double(calendar.ordinality(of: .day, in: .year, for: date) ?? 172)
        let length = 12.25 + 4.5 * cos(2 * .pi * (day - 172) / 365.25)
        let noon = 12.67 + (calendar.timeZone.isDaylightSavingTime(for: date) ? 1 : 0)
        return (noon - length / 2, noon + length / 2)
    }

    static func phase(at date: Date, calendar: Calendar = .current) -> KaartLightPhase {
        let sun = times(on: date, calendar: calendar)
        let parts = calendar.dateComponents([.hour, .minute], from: date)
        let hour = Double(parts.hour ?? 12) + Double(parts.minute ?? 0) / 60
        if hour < sun.rise - 0.5 || hour >= sun.set + 0.5 { return .night }
        if hour < sun.rise + 1 { return .dawn }
        if hour >= sun.set - 1.5 { return .golden }
        return .day
    }
}

/// How the city looks right now: day or night, the light, the season, and whether it drizzles.
nonisolated struct KaartMood: Equatable, Sendable {
    var phase: KaartLightPhase
    var season: GevelSeason
    var rain: Bool

    var night: Bool { phase == .night }

    static let plainDay = KaartMood(phase: .day, season: .zomer, rain: false)

    /// The mood for a moment. "Altijd dag" / "Altijd nacht" fix the light; the season and the
    /// weather still follow the calendar.
    static func at(_ date: Date, light: StadLight, calendar: Calendar = .current) -> KaartMood {
        let phase: KaartLightPhase = switch light {
        case .auto: KaartSun.phase(at: date, calendar: calendar)
        case .day: .day
        case .night: .night
        }
        let season = GevelSeason.of(date)
        let mood = KaartMood(phase: phase, season: season, rain: drizzles(at: date, season: season, calendar: calendar))
        #if DEBUG
        if let forced = ProcessInfo.processInfo.environment["KLINKER_MOOD"] { return mood.forced(forced) }
        #endif
        return mood
    }

    #if DEBUG
    /// For screenshots: "lente,golden,rain" picks a season, a light and the weather.
    private func forced(_ spec: String) -> KaartMood {
        var mood = self
        for token in spec.split(separator: ",").map(String.init) {
            if let season = GevelSeason(rawValue: token) { mood.season = season }
            switch token {
            case "dawn": mood.phase = .dawn
            case "day": mood.phase = .day
            case "golden": mood.phase = .golden
            case "night": mood.phase = .night
            case "rain": mood.rain = true
            case "dry": mood.rain = false
            default: break
            }
        }
        return mood
    }
    #endif

    /// A Dutch drizzle now and then: each three-hour block of the day rains or not, more often in autumn.
    static func drizzles(at date: Date, season: GevelSeason, calendar: Calendar = .current) -> Bool {
        let parts = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let block = (parts.year ?? 0) * 100_000 + (parts.month ?? 0) * 3_000 + (parts.day ?? 0) * 10 + (parts.hour ?? 0) / 3
        var rnd = GevelRandom(seed: block)
        _ = rnd.next()
        let chance: Double = switch season {
        case .herfst: 0.3
        case .winter, .lente: 0.2
        case .zomer: 0.12
        }
        return rnd.next() < chance
    }
}
