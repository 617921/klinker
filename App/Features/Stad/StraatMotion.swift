import SwiftUI

/// Loop position 0..<1 of a repeating animation (`animation-delay: -delay`).
nonisolated func stadPhase(_ t: Double, period: Double, delay: Double = 0) -> Double {
    let v = (t + delay).truncatingRemainder(dividingBy: period) / period
    return v < 0 ? v + 1 : v
}

/// Smooth 0 → 1 → 0 over one period (CSS ease-in-out keyframes at 0/50/100%).
nonisolated func stadWave(_ t: Double, period: Double, delay: Double = 0) -> Double {
    (1 - cos(2 * .pi * stadPhase(t, period: period, delay: delay))) / 2
}

/// Moving things on the street: the cyclist, water shimmer, the boat (or skaters in winter) and snow.
/// Ticks only while `active`; with Reduce Motion everything stands still.
struct StraatMotionLayer: View {
    let scale: CGFloat
    let season: GevelSeason
    let active: Bool
    let reduceMotion: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30, paused: !active || reduceMotion)) { timeline in
            frame(at: reduceMotion ? 12 : timeline.date.timeIntervalSinceReferenceDate)
        }
        .frame(width: StraatMetrics.width * scale, height: StraatMetrics.viewHeight * scale, alignment: .topLeading)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func frame(at t: Double) -> some View {
        let s = scale
        let top = StraatMetrics.viewTop
        let water = StraatMetrics.waterTop
        let winter = season == .winter
        return ZStack(alignment: .topLeading) {
            StraatCyclistSprite(scale: s)
                .offset(x: (1320 - 1440 * stadPhase(t, period: 22)) * s, y: (436 - top) * s)
            StraatBollards(scale: s)
            ForEach(StraatMetrics.shimmer.indices, id: \.self) { i in
                let line = StraatMetrics.shimmer[i]
                Rectangle()
                    .fill(.white)
                    .frame(width: line.w * s, height: max(1, 2 * s))
                    .opacity(0.35 + 0.35 * stadWave(t, period: line.period))
                    .offset(x: line.x * s, y: (water + line.y - top) * s)
            }
            if winter {
                StraatSkaterSprite(scale: s, skin: 0xE8C4A0, hat: 0xC8261B, coat: 0x1E3A6B)
                    .offset(x: (-80 + 1420 * stadPhase(t, period: 18)) * s, y: (water + 4 - top) * s)
                StraatSkaterSprite(scale: s, skin: 0x8C5A3C, hat: 0xF2711C, coat: 0x993556)
                    .offset(x: (-80 + 1420 * stadPhase(t, period: 26, delay: 9)) * s, y: (water + 20 - top) * s)
                StraatSnow(t: t, scale: s)
            } else {
                StraatBoatSprite(scale: s)
                    .offset(
                        x: (-220 + 1560 * stadPhase(t, period: 38)) * s,
                        y: (water + 14 + 2 * stadWave(t, period: 2.4) - top) * s
                    )
            }
        }
        .frame(width: StraatMetrics.width * s, height: StraatMetrics.viewHeight * s, alignment: .topLeading)
    }
}

/// 46 falling flakes in one canvas.
private struct StraatSnow: View {
    let t: Double
    let scale: CGFloat

    var body: some View {
        Canvas { ctx, _ in
            ctx.scaleBy(x: scale, y: scale)
            ctx.translateBy(x: 0, y: -StraatMetrics.viewTop)
            let flake = Color.white.opacity(0.85)
            for f in StraatMetrics.sky.flakes {
                let y = -20 + 760 * stadPhase(t, period: f.period, delay: f.delay)
                ctx.fill(Path(ellipseIn: CGRect(x: f.x, y: y, width: 5, height: 5)), with: .color(flake))
            }
        }
        .frame(width: StraatMetrics.width * scale, height: StraatMetrics.viewHeight * scale)
    }
}

/// Twinkling stars behind the houses (night only).
struct StraatStarsLayer: View {
    let scale: CGFloat
    let active: Bool
    let reduceMotion: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 15, paused: !active || reduceMotion)) { timeline in
            let t = reduceMotion ? 0 : timeline.date.timeIntervalSinceReferenceDate
            Canvas { ctx, _ in
                ctx.scaleBy(x: scale, y: scale)
                ctx.translateBy(x: 0, y: -StraatMetrics.viewTop)
                for star in StraatMetrics.sky.stars {
                    let opacity = 0.3 + 0.6 * (1 - stadWave(t, period: star.period))
                    ctx.fill(Path(CGRect(x: star.x, y: star.y, width: 2, height: 2)), with: .color(.white.opacity(opacity)))
                }
            }
        }
        .frame(width: StraatMetrics.width * scale, height: 130 * scale)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
