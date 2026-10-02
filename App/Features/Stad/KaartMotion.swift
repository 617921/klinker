import SwiftUI

/// Ria's round: along the inner street ring (R 220), out along a radial, back along the outer
/// ring (R 360) and in again — constant speed, 38 s per lap (StadKaart `kt-ria`).
nonisolated enum KaartRia {
    static let period = 38.0
    private static let arc = 144.0 * .pi / 180
    private static let lengths = [220 * arc, 140, 360 * arc, 140]
    private static let total = lengths.reduce(0, +)

    /// World position and whether she rides facing left.
    static func position(_ phase: Double) -> (point: CGPoint, facingLeft: Bool) {
        var d = phase * total
        func ring(_ r: Double, _ t: Double) -> CGPoint {
            let a = t * .pi / 180
            return CGPoint(x: 500 + r * cos(a), y: 96 + r * sin(a))
        }
        if d < lengths[0] { return (ring(220, 18 + 144 * d / lengths[0]), true) }
        d -= lengths[0]
        if d < lengths[1] { return (ring(220 + 140 * d / lengths[1], 162), true) }
        d -= lengths[1]
        if d < lengths[2] { return (ring(360, 162 - 144 * d / lengths[2]), false) }
        d -= lengths[2]
        return (ring(360 - 140 * min(1, d / lengths[3]), 18), true)
    }
}

/// World point → scroll content point.
nonisolated func kaartPoint(_ x: CGFloat, _ y: CGFloat, _ zoom: CGFloat) -> CGPoint {
    CGPoint(x: x * zoom, y: (y + KaartData.north) * zoom)
}

/// Things that move under the places: river barge, canal boat, the pulsing ring and crane at
/// the place under construction.
struct KaartBelowMotion: View {
    let zoom: CGFloat
    let current: KaartPlace?
    let night: Bool
    let active: Bool
    let reduceMotion: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30, paused: !active || reduceMotion)) { timeline in
            frame(at: reduceMotion ? 20 : timeline.date.timeIntervalSinceReferenceDate)
        }
        .frame(width: KaartData.worldWidth * zoom, height: KaartData.contentHeight * zoom, alignment: .topLeading)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func frame(at t: Double) -> some View {
        let k = zoom
        let boatPhase = stadPhase(t, period: 46)
        let theta = 176 - 172 * boatPhase
        let boatAt = KaartMapPaths.p(290, theta)
        let boatOpacity = boatPhase < 0.0465 ? boatPhase / 0.0465 : boatPhase > 0.9767 ? (1 - boatPhase) / 0.0233 : 1
        let bargeX = -90 + 1180 * stadPhase(t, period: 80)
        return ZStack(alignment: .topLeading) {
            KaartBargeSprite(zoom: k, night: night)
                .position(kaartPoint(bargeX + 36, 22, k))
            KaartBoatSprite(zoom: k)
                .rotationEffect(.degrees(theta - 90))
                .opacity(boatOpacity)
                .position(kaartPoint(boatAt.x, boatAt.y, k))
            if let current {
                ring(at: current.point, t: t)
                KaartCraneSprite(zoom: k)
                    .position(kaartPoint(current.point.x - 52 + 80, current.point.y - 143 + 73, k))
                KaartHookSprite(zoom: k)
                    .position(kaartPoint(current.point.x - 52 + 20, current.point.y - 143 + 35 + 12 * stadWave(t, period: 4.2), k))
            }
        }
        .frame(width: KaartData.worldWidth * k, height: KaartData.contentHeight * k, alignment: .topLeading)
    }

    private func ring(at p: CGPoint, t: Double) -> some View {
        let k = zoom
        let center = kaartPoint(p.x, p.y, k)
        let size = CGSize(width: 110 * k, height: 46 * k)
        return ZStack {
            Ellipse().fill(Theme.orange.opacity(0.16))
            ForEach([0.0, 0.9], id: \.self) { delay in
                let raw = stadPhase(t, period: 1.8, delay: delay)
                let eased = reduceMotion ? 0.35 : 1 - (1 - raw) * (1 - raw)
                Ellipse()
                    .strokeBorder(Theme.orange, lineWidth: 3 * k)
                    .scaleEffect(0.7 + 0.75 * eased)
                    .opacity(0.95 * (1 - eased))
            }
        }
        .frame(width: size.width, height: size.height)
        .position(center)
    }
}

/// Things that move above the places: Ria de postbode (tappable), the "!" on fading places, the mill.
struct KaartAboveMotion: View {
    let zoom: CGFloat
    /// World top-left of each 20-unit "!" badge.
    let bangs: [CGPoint]
    /// World top-left of the 44-unit mill sails, when the mill plot is still empty.
    let mill: CGPoint?
    let night: Bool
    let active: Bool
    let reduceMotion: Bool
    /// Ria stands still at this phase while she talks.
    let riaFrozen: Double?
    let riaShift: Double
    let riaMessage: String
    let onRia: (Double) -> Void

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30, paused: !active || reduceMotion || riaFrozen != nil)) { timeline in
            frame(at: reduceMotion ? 7 : timeline.date.timeIntervalSinceReferenceDate)
        }
        .frame(width: KaartData.worldWidth * zoom, height: KaartData.contentHeight * zoom, alignment: .topLeading)
    }

    private func frame(at t: Double) -> some View {
        let k = zoom
        let phase = riaFrozen ?? stadPhase(t - riaShift, period: KaartRia.period)
        let ria = KaartRia.position(phase)
        let riaCenter = kaartPoint(ria.point.x, ria.point.y - 20, k)
        let bob = reduceMotion ? 0 : -3 * stadWave(t, period: 1.6)
        return ZStack(alignment: .topLeading) {
            if let mill {
                KaartMillSails(zoom: k, night: night)
                    .rotationEffect(.degrees(reduceMotion ? 20 : 360 * stadPhase(t, period: 18)))
                    .position(kaartPoint(mill.x + 22, mill.y + 22, k))
                    .allowsHitTesting(false)
            }
            ForEach(bangs.indices, id: \.self) { i in
                Text("!")
                    .font(Fonts.cta(12))
                    .foregroundStyle(Theme.ink)
                    .frame(width: max(16, 20 * k), height: max(16, 20 * k))
                    .background(Theme.orange, in: Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .position(kaartPoint(bangs[i].x + 10, bangs[i].y + 10 + bob, k))
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }
            Button {
                onRia(phase)
            } label: {
                KaartRiaSprite(zoom: k)
                    .scaleEffect(x: ria.facingLeft ? -1 : 1, y: 1)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Ria de postbode. Tik voor haar bericht.")
            .position(riaCenter)
            if riaFrozen != nil {
                KaartRiaBubble(message: riaMessage)
                    .position(x: riaCenter.x, y: max(60, riaCenter.y - 70))
                    .allowsHitTesting(false)
                    .transition(.opacity)
            }
        }
        .frame(width: KaartData.worldWidth * k, height: KaartData.contentHeight * k, alignment: .topLeading)
    }
}

private struct KaartRiaBubble: View {
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            CourierLabel(text: "Ria de postbode", size: 12)
            Text(message)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Theme.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(width: 220, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 3))
        .overlay(alignment: .topLeading) {
            Rectangle().fill(Ink.hex(0xC8261B, 0.9)).frame(width: 40, height: 12).rotationEffect(.degrees(-6)).offset(x: 16, y: -7)
        }
        .rotationEffect(.degrees(-1.2))
        .shadow(color: Theme.ink.opacity(0.25), radius: 10, y: 8)
    }
}

// MARK: - Sprites

private struct KaartBargeSprite: View, Equatable {
    let zoom: CGFloat
    let night: Bool

    var body: some View {
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom, y: zoom)
            ctx.fill(KaartArt.bargeHull, with: .color(Ink.hex(night ? 0x151515 : 0x2C2C2A)))
            ctx.fill(Path(CGRect(x: 16, y: 5, width: 14, height: 10)), with: .color(Ink.hex(0xC9A15B)))
            ctx.fill(Path(CGRect(x: 33, y: 5, width: 14, height: 10)), with: .color(Ink.hex(0x7B3F2E)))
            ctx.fill(Path(CGRect(x: 50, y: 5, width: 12, height: 10)), with: .color(Ink.hex(0xEFEBE2)))
        }
        .frame(width: 72 * zoom, height: 20 * zoom)
    }
}

private struct KaartBoatSprite: View, Equatable {
    let zoom: CGFloat

    var body: some View {
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom, y: zoom)
            ctx.translateBy(x: 6, y: 0)
            ctx.stroke(KaartArt.boatWake, with: .color(.white.opacity(0.7)), lineWidth: 1.5)
            ctx.fill(KaartArt.boatHull, with: .color(Ink.hex(0x6B4A2E)))
            ctx.stroke(KaartArt.boatStripe, with: .color(Ink.hex(0xF4F1EA)), lineWidth: 1.5)
            ctx.fill(KaartArt.boatCabin, with: .color(Ink.hex(0x2F4B3A)))
            ctx.fill(Path(ellipseIn: CGRect(x: 22.6, y: 3.6, width: 4.8, height: 4.8)), with: .color(Ink.hex(0xE8C4A0)))
            ctx.fill(Path(ellipseIn: CGRect(x: 22.6, y: 8.1, width: 4.8, height: 4.8)), with: .color(Ink.hex(0x8C5A3C)))
            ctx.fill(KaartArt.boatFlag, with: .color(Ink.hex(0xAE1C28)))
        }
        .frame(width: 48 * zoom, height: 16 * zoom)
    }
}

private struct KaartCraneSprite: View, Equatable {
    let zoom: CGFloat

    var body: some View {
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom, y: zoom)
            let orange = Color(.sRGB, red: 242 / 255, green: 113 / 255, blue: 28 / 255)
            let grey = Ink.hex(0x5F5E5A)
            ctx.stroke(KaartArt.craneLattice, with: .color(orange), style: StrokeStyle(lineWidth: 2, lineJoin: .round))
            ctx.stroke(KaartArt.craneJib, with: .color(orange), style: StrokeStyle(lineWidth: 2, lineJoin: .round))
            ctx.stroke(KaartArt.craneCables, with: .color(grey), lineWidth: 1.2)
            ctx.fill(KaartArt.craneWeights, with: .color(grey))
            ctx.fill(KaartArt.craneCabin, with: .color(Ink.hex(0x1E1E1C)))
            ctx.fill(KaartArt.craneWindow, with: .color(Ink.hex(0xA9CBE0)))
        }
        .frame(width: 160 * zoom, height: 146 * zoom)
    }
}

/// The hook and its load (crane svg units 0...40 × 0...70).
private struct KaartHookSprite: View, Equatable {
    let zoom: CGFloat

    var body: some View {
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom, y: zoom)
            ctx.stroke(KaartArt.hookLine, with: .color(Ink.hex(0x1E1E1C)), lineWidth: 1.2)
            ctx.fill(KaartArt.hook, with: .color(Ink.hex(0x1E1E1C)))
            ctx.fill(KaartArt.hookLoad, with: .color(Ink.hex(0x8A6A3E)))
        }
        .frame(width: 40 * zoom, height: 70 * zoom)
    }
}

private struct KaartMillSails: View, Equatable {
    let zoom: CGFloat
    let night: Bool

    var body: some View {
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom, y: zoom)
            ctx.fill(KaartArt.millSails, with: .color(night ? Color.white.opacity(0.05) : Ink.hex(0xFFFDF6, 0.6)))
            ctx.stroke(KaartArt.millSails, with: .color(Ink.hex(night ? 0x8A90A2 : 0x8E8A80)), style: StrokeStyle(lineWidth: 1.6, lineJoin: .round, dash: [4, 3]))
        }
        .frame(width: 44 * zoom, height: 44 * zoom)
    }
}

/// Ria on her red post bike with the orange bag (svg 70 × 62 drawn at 38 × 34 world units).
private struct KaartRiaSprite: View, Equatable {
    let zoom: CGFloat

    var body: some View {
        Canvas { ctx, _ in
            ctx.scaleBy(x: zoom * 38 / 70, y: zoom * 34 / 62)
            ctx.stroke(KaartArt.riaWheels, with: .color(Ink.hex(0x1E1E1C)), lineWidth: 3)
            ctx.stroke(KaartArt.riaFrame, with: .color(Ink.hex(0xC8261B)), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            ctx.fill(KaartArt.riaBag, with: .color(Ink.hex(0xF2711C)))
            ctx.fill(KaartArt.riaLetter, with: .color(Ink.hex(0xFFFDF6)))
            ctx.stroke(KaartArt.riaBody, with: .color(Ink.hex(0x1F3A6B)), style: StrokeStyle(lineWidth: 6, lineCap: .round))
            ctx.fill(KaartArt.riaHead, with: .color(Ink.hex(0xC99A74)))
            ctx.fill(KaartArt.riaCap, with: .color(Ink.hex(0xF2711C)))
        }
        .frame(width: 38 * zoom, height: 34 * zoom)
    }
}
