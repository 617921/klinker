import SwiftUI

/// Each place's own building. Places without one (station, market, park, tram stop) keep
/// their gevelkit spec in `KaartData`. Groups live in their own files.
nonisolated enum KaartLandmarks {
    static func make(_ n: Int) -> KaartLandmark? {
        shops(n) ?? big(n) ?? outskirts(n)
    }
}
