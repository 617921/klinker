import SwiftUI

/// Builds each house's paths once and keeps them.
enum GevelCache {
    private static var store: [HouseSpec: GevelGeometry] = [:]

    static func geometry(for spec: HouseSpec) -> GevelGeometry {
        if let cached = store[spec] { return cached }
        let built = Gevelkit.gevel(spec)
        if store.count > 300 { store.removeAll(keepingCapacity: true) }
        store[spec] = built
        return built
    }
}

/// One canal house from the gevelkit. Scales to the frame it's given, keeping its aspect ratio.
struct CanalHouseView: View, Equatable {
    let spec: HouseSpec
    var night = false
    var season: GevelSeason = .zomer

    init(spec: HouseSpec, night: Bool = false, season: GevelSeason = .zomer) {
        self.spec = spec
        self.night = night
        self.season = season
    }

    var body: some View {
        let geometry = GevelCache.geometry(for: spec)
        let palette = GevelPalette.street(spec, night: night, season: season)
        Canvas { ctx, size in
            ctx.scaleBy(x: size.width / geometry.size.width, y: size.height / geometry.size.height)
            GevelPainter.draw(geometry, palette: palette, in: &ctx)
        }
        .aspectRatio(geometry.size, contentMode: .fit)
        .accessibilityHidden(true)
    }
}
