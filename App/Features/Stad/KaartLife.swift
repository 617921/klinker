import SwiftUI

/// The city's ambient life, above the places: cloud shadows drifting over, gulls, the mill's
/// sails, sailboats on the lake, skaters on frozen canals and ripples when it drizzles.
/// Moving sprites over a world-sized frame (no world-sized canvas), still under Reduce Motion.
struct KaartLifeMotion: View {
    let zoom: CGFloat
    let mood: KaartMood
    let active: Bool
    let reduceMotion: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30, paused: !active || reduceMotion)) { timeline in
            frame(at: reduceMotion ? 30 : timeline.date.timeIntervalSinceReferenceDate)
        }
        .frame(width: KaartData.worldWidth * zoom, height: KaartData.contentHeight * zoom, alignment: .topLeading)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private static let clouds: [(y: Double, offset: Double, scale: Double)] = [
        (150, 0.05, 1.1), (470, 0.55, 0.9), (800, 0.3, 1.25), (1110, 0.8, 1),
    ]
    private static let gulls: [(center: CGPoint, reach: CGSize, period: Double, phase: Double)] = [
        (CGPoint(x: 520, y: 18), CGSize(width: 330, height: 16), 46, 0),
        (CGPoint(x: 300, y: 300), CGSize(width: 130, height: 60), 34, 1.7),
        (CGPoint(x: 690, y: 1140), CGSize(width: 220, height: 22), 52, 3.1),
    ]
    private static let skaters: [(radius: Double, period: Double, phase: Double, scarf: UInt32)] = [
        (290, 58, 0, 0xC8261B), (290, 58, 0.35, 0x2F5BD3), (430, 74, 1.2, 0xF2711C), (430, 74, 2.9, 0x0F6E56), (150, 44, 2.1, 0xF2C53D),
    ]
    /// Points on the canals where drizzle rings spread.
    private static let ripples: [CGPoint] = [
        (150.0, 40.0), (150, 120), (290, 30), (290, 75), (290, 150), (430, 45), (430, 100), (430, 140), (570, 70), (570, 112),
    ].map { KaartMapPaths.p($0.0, $0.1) } + [CGPoint(x: 140, y: 26), CGPoint(x: 420, y: 30), CGPoint(x: 820, y: 34), CGPoint(x: 600, y: 1150)]

    /// Two boats tacking slowly back and forth across the lake.
    private static func sailboat(_ i: Int, t: Double, zoom k: CGFloat) -> CGPoint {
        let n = Double(i)
        let period = 110 + n * 30
        let x = 640 + 170 * sin(2 * .pi * t / period + n * 2.4)
        return kaartPoint(x, 1146 + n * 26, k)
    }

    private func frame(at t: Double) -> some View {
        let k = zoom
        let night = mood.night
        let winter = mood.season == .winter
        return ZStack(alignment: .topLeading) {
            KaartLifeSails(zoom: k, night: night)
                .rotationEffect(.degrees(360 * stadPhase(t, period: 14)))
                .position(kaartPoint(KaartSouth.millHub.x, KaartSouth.millHub.y, k))

            if winter {
                ForEach(Self.skaters.indices, id: \.self) { i in
                    let s = Self.skaters[i]
                    let angle = 90 + 70 * sin(2 * .pi * t / s.period + s.phase)
                    let heading = cos(2 * .pi * t / s.period + s.phase)
                    let p = KaartMapPaths.p(s.radius, angle)
                    KaartSkaterSprite(zoom: k, scarf: s.scarf, night: night, stride: sin(t * 5 + Double(i)) > 0)
                        .scaleEffect(x: heading > 0 ? -1 : 1, y: 1)
                        .position(kaartPoint(p.x, p.y - 6, k))
                }
            } else {
                ForEach(0..<2, id: \.self) { i in
                    KaartSailboatSprite(zoom: k, night: night, sail: i == 0 ? 0xFFFDF6 : 0xF2711C)
                        .position(Self.sailboat(i, t: t, zoom: k))
                }
            }

            if mood.rain {
                ForEach(Self.ripples.indices, id: \.self) { i in
                    let phase = stadPhase(t, period: 1.7, delay: Double(i) * 0.37)
                    Ellipse()
                        .stroke(Color.white.opacity(0.75 * (1 - phase)), lineWidth: 1)
                        .frame(width: 10 * k, height: 4.5 * k)
                        .scaleEffect(0.4 + 1.2 * phase)
                        .position(kaartPoint(Self.ripples[i].x, Self.ripples[i].y, k))
                }
            }

            if !night {
                ForEach(Self.gulls.indices, id: \.self) { i in
                    let g = Self.gulls[i]
                    let a = 2 * .pi * t / g.period + g.phase
                    let x = g.center.x + g.reach.width * sin(a)
                    let y = g.center.y + g.reach.height * sin(2 * a)
                    let flap = sin(t * 7 + Double(i) * 1.3)
                    Ellipse()
                        .fill(StadInk.hex(0x1E1E1C, 0.12))
                        .frame(width: 9 * k, height: 3 * k)
                        .position(kaartPoint(x + 6, y + 30, k))
                    KaartGullSprite(zoom: k, flap: flap)
                        .scaleEffect(x: cos(a) > 0 ? 1 : -1, y: 1)
                        .position(kaartPoint(x, y, k))
                }
            }

            if !night && !mood.rain {
                ForEach(Self.clouds.indices, id: \.self) { i in
                    let c = Self.clouds[i]
                    let x = -320 + 1640 * stadPhase(t, period: 170, delay: -c.offset * 170)
                    KaartCloudShadow(zoom: k)
                        .scaleEffect(c.scale)
                        .position(kaartPoint(x, c.y + 18 * sin(t / 23 + Double(i)), k))
                }
            }
        }
        .frame(width: KaartData.worldWidth * k, height: KaartData.contentHeight * k, alignment: .topLeading)
    }
}

/// Light and weather over the whole screen: pink dawn, golden hour, a grey drizzle with
/// falling streaks. Nothing at plain day; the night look lives in the map colours.
struct KaartWeatherOverlay: View {
    let mood: KaartMood
    let active: Bool
    let reduceMotion: Bool

    var body: some View {
        ZStack {
            wash
            if mood.rain {
                TimelineView(.animation(minimumInterval: 1.0 / 30, paused: !active || reduceMotion)) { timeline in
                    let t = reduceMotion ? 3 : timeline.date.timeIntervalSinceReferenceDate
                    Canvas { ctx, size in
                        Self.drawRain(&ctx, size: size, t: t, night: mood.night)
                    }
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    @ViewBuilder
    private var wash: some View {
        if mood.rain {
            StadInk.hex(mood.night ? 0x10131C : 0x7D8A96, mood.night ? 0.25 : 0.16)
                .blendMode(.multiply)
        } else {
            switch mood.phase {
            case .dawn:
                LinearGradient(colors: [StadInk.hex(0xF3A3A0, 0.26), StadInk.hex(0xF9D9B5, 0.12)], startPoint: .top, endPoint: .bottom)
                    .blendMode(.multiply)
            case .golden:
                LinearGradient(colors: [StadInk.hex(0xF2A54A, 0.26), StadInk.hex(0xE9824A, 0.14)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .blendMode(.multiply)
            case .day, .night:
                EmptyView()
            }
        }
    }

    /// Short slanted streaks falling at different speeds, spread by a fixed hash.
    private static func drawRain(_ ctx: inout GraphicsContext, size: CGSize, t: Double, night: Bool) {
        var streaks = Path()
        let span = size.height + 60
        for i in 0..<110 {
            var rnd = GevelRandom(seed: i * 7919 + 13)
            let x0 = rnd.next() * (size.width + 80) - 40
            let speed = 520 + rnd.next() * 260
            let y = (rnd.next() * span + t * speed).truncatingRemainder(dividingBy: span) - 30
            let x = x0 - 0.22 * y
            streaks.move(to: CGPoint(x: x, y: y))
            streaks.addLine(to: CGPoint(x: x - 3, y: y + 13))
        }
        ctx.stroke(streaks, with: .color(night ? Color.white.opacity(0.22) : StadInk.hex(0x4E5E6E, 0.32)), style: StrokeStyle(lineWidth: 1, lineCap: .round))
    }
}

// MARK: - Sprites

/// A soft cloud shadow passing over the city (world 300 × 170).
private struct KaartCloudShadow: View, Equatable {
    let zoom: CGFloat

    var body: some View {
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom, y: zoom)
            for (x, y, w, h) in [(30.0, 50.0, 150.0, 90.0), (110, 25, 160, 110), (170, 60, 120, 80)] {
                let rect = CGRect(x: x, y: y, width: w, height: h)
                let shade = Gradient(colors: [StadInk.hex(0x1E2A3A, 0.085), StadInk.hex(0x1E2A3A, 0)])
                ctx.fill(Path(ellipseIn: rect), with: .radialGradient(shade, center: CGPoint(x: rect.midX, y: rect.midY), startRadius: 0, endRadius: max(w, h) / 2))
            }
        }
        .frame(width: 300 * zoom, height: 170 * zoom)
    }
}

/// A gull, wings up or down with `flap` (-1...1). World 16 × 10.
private struct KaartGullSprite: View, Equatable {
    let zoom: CGFloat
    let flap: Double

    var body: some View {
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom, y: zoom)
            let tip = 5 - 3.5 * flap
            var wings = Path()
            wings.move(to: CGPoint(x: 1, y: tip))
            wings.addQuadCurve(to: CGPoint(x: 8, y: 6), control: CGPoint(x: 4.5, y: tip - 2.5))
            wings.addQuadCurve(to: CGPoint(x: 15, y: tip), control: CGPoint(x: 11.5, y: tip - 2.5))
            ctx.stroke(wings, with: .color(StadInk.hex(0x5F5E5A)), style: StrokeStyle(lineWidth: 2.6, lineCap: .round, lineJoin: .round))
            ctx.stroke(wings, with: .color(.white), style: StrokeStyle(lineWidth: 1.4, lineCap: .round, lineJoin: .round))
            ctx.fill(Path(ellipseIn: CGRect(x: 6.6, y: 4.8, width: 3, height: 2.6)), with: .color(.white))
            ctx.fill(Path(ellipseIn: CGRect(x: 9.2, y: 5.2, width: 1.6, height: 1.2)), with: .color(StadInk.hex(0xF2C53D)))
        }
        .frame(width: 16 * zoom, height: 10 * zoom)
    }
}

/// The decorative mill's four sails around the hub (world 48 × 48).
private struct KaartLifeSails: View, Equatable {
    let zoom: CGFloat
    let night: Bool

    var body: some View {
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom, y: zoom)
            ctx.translateBy(x: 24, y: 24)
            let frame = StadInk.hex(night ? 0x8A8F9E : 0x2E2117)
            let cloth = StadInk.hex(night ? 0x5D6880 : 0xF4F1EA)
            for i in 0..<4 {
                var arm = ctx
                arm.rotate(by: .degrees(Double(i) * 90))
                arm.fill(Path(CGRect(x: 2, y: -21, width: 6, height: 17)), with: .color(cloth))
                arm.stroke(Path(CGRect(x: 2, y: -21, width: 6, height: 17)), with: .color(frame), lineWidth: 0.8)
                arm.stroke(Path { $0.move(to: CGPoint(x: 0, y: 0)); $0.addLine(to: CGPoint(x: 0, y: -22)) }, with: .color(frame), lineWidth: 1.6)
            }
            ctx.fill(Path(ellipseIn: CGRect(x: -2.2, y: -2.2, width: 4.4, height: 4.4)), with: .color(frame))
        }
        .frame(width: 48 * zoom, height: 48 * zoom)
    }
}

/// A skater in a winter coat and a bright scarf (world 10 × 14).
private struct KaartSkaterSprite: View, Equatable {
    let zoom: CGFloat
    let scarf: UInt32
    let night: Bool
    let stride: Bool

    var body: some View {
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom, y: zoom)
            let f = night ? 0.6 : 1
            var legs = Path()
            legs.move(to: CGPoint(x: 5, y: 9)); legs.addLine(to: CGPoint(x: stride ? 2 : 4, y: 13.5))
            legs.move(to: CGPoint(x: 5, y: 9)); legs.addLine(to: CGPoint(x: stride ? 8 : 6.5, y: 13))
            ctx.stroke(legs, with: .color(StadInk.hex(Gevelkit.shade(0x1E1E1C, f))), style: StrokeStyle(lineWidth: 1.4, lineCap: .round))
            ctx.fill(Path(roundedRect: CGRect(x: 2.5, y: 3.5, width: 5, height: 6.5), cornerRadius: 2), with: .color(StadInk.hex(Gevelkit.shade(0x1F3A6B, f))))
            ctx.fill(Path(CGRect(x: 2.5, y: 3.5, width: 6.5, height: 1.8)), with: .color(StadInk.hex(Gevelkit.shade(scarf, f))))
            ctx.fill(Path(ellipseIn: CGRect(x: 3, y: 0, width: 4, height: 4)), with: .color(StadInk.hex(Gevelkit.shade(0xE8C4A0, f))))
        }
        .frame(width: 10 * zoom, height: 14 * zoom)
    }
}

/// A small sailboat on the lake (world 22 × 22).
private struct KaartSailboatSprite: View, Equatable {
    let zoom: CGFloat
    let night: Bool
    let sail: UInt32

    var body: some View {
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom, y: zoom)
            let f = night ? 0.55 : 1
            var hull = Path()
            hull.move(to: CGPoint(x: 2, y: 16)); hull.addLine(to: CGPoint(x: 20, y: 16)); hull.addLine(to: CGPoint(x: 17, y: 20)); hull.addLine(to: CGPoint(x: 5, y: 20)); hull.closeSubpath()
            ctx.fill(hull, with: .color(StadInk.hex(Gevelkit.shade(0x6B4A2E, f))))
            var main = Path()
            main.move(to: CGPoint(x: 11, y: 1)); main.addLine(to: CGPoint(x: 11, y: 15)); main.addLine(to: CGPoint(x: 3, y: 15)); main.closeSubpath()
            ctx.fill(main, with: .color(StadInk.hex(Gevelkit.shade(sail, f))))
            var jib = Path()
            jib.move(to: CGPoint(x: 12, y: 4)); jib.addLine(to: CGPoint(x: 18, y: 15)); jib.addLine(to: CGPoint(x: 12, y: 15)); jib.closeSubpath()
            ctx.fill(jib, with: .color(StadInk.hex(Gevelkit.shade(0xFFFDF6, f))))
            ctx.stroke(Path { $0.move(to: CGPoint(x: 0, y: 21)); $0.addLine(to: CGPoint(x: 8, y: 21)) }, with: .color(.white.opacity(0.6)), lineWidth: 1)
        }
        .frame(width: 22 * zoom, height: 22 * zoom)
    }
}
