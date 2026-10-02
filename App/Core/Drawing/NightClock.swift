import Foundation

/// Night follows the real clock: 20:00–7:00. The street, the map and Noor's house all use it.
nonisolated enum NightClock {
    static func isNight(_ date: Date = .now) -> Bool {
        let hour = Calendar.current.component(.hour, from: date)
        return hour >= 20 || hour < 7
    }
}
