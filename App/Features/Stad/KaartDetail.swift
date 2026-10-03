import Observation
import SwiftUI

/// Small Amsterdam things hidden in the city (cats, ducks, a stroopwafel cart, boats...). They
/// show when you zoom in; tap one to hear and see its Dutch word. The list and the drawings
/// live in `KaartDetails` (KaartDetailsList.swift, KaartDetailArt.swift).
nonisolated struct KaartDetail: Identifiable, Sendable {
    let id: String
    let kind: KaartDetailKind
    let nl: String
    let article: Article
    let en: String
    /// World point of the sprite's centre at rest (for moving details: where the motion starts).
    let point: CGPoint
    /// Sprite size in world units.
    var size = CGSize(width: 14, height: 12)
    /// Shown from this zoom up (1 = the normal zoom, 1.8 = the closest).
    var minZoom: CGFloat = 1.8
    var motion: KaartDetailMotion = .still
    /// Drawn mirrored (facing left).
    var flipped = false
    /// Only in these seasons (nil: all year), e.g. no pedal boats in winter.
    var seasons: [GevelSeason]? = nil
    /// Also out at night.
    var nightToo = true

    func shows(in mood: KaartMood) -> Bool {
        (seasons?.contains(mood.season) ?? true) && (nightToo || !mood.night)
    }

    var spoken: String { article == .none ? nl : "\(article.rawValue) \(nl)" }

    /// Where it is at time t, and whether it faces left.
    func pose(at t: Double) -> (point: CGPoint, facingLeft: Bool) {
        switch motion {
        case .still:
            return (point, flipped)
        case .path(let points, let period):
            guard points.count > 1 else { return (point, flipped) }
            // There and back along the points, at an even pace.
            let phase = stadPhase(t, period: period)
            let along = phase < 0.5 ? phase * 2 : (1 - phase) * 2
            let legs = Double(points.count - 1)
            let i = min(points.count - 2, Int(along * legs))
            let f = along * legs - Double(i)
            let a = points[i], b = points[i + 1]
            let p = CGPoint(x: a.x + (b.x - a.x) * f, y: a.y + (b.y - a.y) * f)
            let goingRight = (b.x - a.x) * (phase < 0.5 ? 1 : -1) >= 0
            return (p, flipped ? goingRight : !goingRight)
        case .canal(let radius, let from, let to, let period):
            let phase = stadPhase(t, period: period)
            let along = phase < 0.5 ? phase * 2 : (1 - phase) * 2
            let eased = (1 - cos(.pi * along)) / 2
            let angle = from + (to - from) * eased
            let p = KaartMapPaths.p(radius, angle)
            // Moving towards a larger angle goes right-to-left on the lower half of the ring.
            let increasing = (to > from) == (phase < 0.5)
            return (p, flipped ? !increasing : increasing)
        }
    }

    /// Everywhere it can be, for culling.
    var reach: CGRect {
        let pad = max(size.width, size.height)
        switch motion {
        case .still:
            return CGRect(x: point.x - pad, y: point.y - pad, width: pad * 2, height: pad * 2)
        case .path(let points, _):
            return points.reduce(CGRect.null) { $0.union(CGRect(origin: $1, size: .zero)) }.insetBy(dx: -pad, dy: -pad)
        case .canal(let radius, let from, let to, _):
            return stride(from: min(from, to), through: max(from, to), by: 4).reduce(CGRect.null) {
                $0.union(CGRect(origin: KaartMapPaths.p(radius, $1), size: .zero))
            }.insetBy(dx: -pad, dy: -pad)
        }
    }
}

nonisolated enum KaartDetailMotion: Sendable {
    case still
    /// Back and forth along world points (ducks paddling, a cyclist), `period` seconds there and back.
    case path([CGPoint], period: Double)
    /// Back and forth along a canal ring of `radius` between two angles (degrees), easing at the ends.
    case canal(radius: Double, from: Double, to: Double, period: Double)
}

/// The details you have found (tapped), remembered across launches.
@Observable
final class KaartDiscoveries {
    static let shared = KaartDiscoveries()

    private(set) var found: Set<String>
    @ObservationIgnored private let defaults: UserDefaults
    private static let key = "klinker.discoveries"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        found = Set(defaults.stringArray(forKey: Self.key) ?? [])
    }

    /// Marks a detail found; true the first time.
    @discardableResult
    func mark(_ id: String) -> Bool {
        guard !found.contains(id) else { return false }
        found.insert(id)
        defaults.set(Array(found), forKey: Self.key)
        return true
    }

    var count: Int { found.intersection(KaartDetails.all.map(\.id)).count }
    var total: Int { KaartDetails.all.count }
}

/// The details on the map: only those near the screen and allowed at this zoom, animated.
struct KaartDetailsLayer: View {
    let zoom: CGFloat
    let mood: KaartMood
    /// The part of the world on screen (world units).
    let visible: CGRect
    let active: Bool
    let reduceMotion: Bool
    let onTap: (KaartDetail, CGPoint) -> Void

    var body: some View {
        let k = zoom
        let shown = KaartDetails.all.filter {
            k >= $0.minZoom - 0.01 && $0.shows(in: mood) && visible.insetBy(dx: -60, dy: -60).intersects($0.reach)
        }
        TimelineView(.animation(minimumInterval: 1.0 / 30, paused: !active || reduceMotion || shown.isEmpty)) { timeline in
            let t = reduceMotion ? 12 : timeline.date.timeIntervalSinceReferenceDate
            ZStack(alignment: .topLeading) {
                ForEach(shown) { detail in
                    sprite(detail, t: t)
                }
            }
            .frame(width: KaartData.worldWidth * k, height: KaartData.contentHeight * k, alignment: .topLeading)
        }
        .frame(width: KaartData.worldWidth * k, height: KaartData.contentHeight * k, alignment: .topLeading)
    }

    private func sprite(_ detail: KaartDetail, t: Double) -> some View {
        let k = zoom
        let pose = detail.pose(at: t)
        let night = mood.night, season = mood.season
        return Button {
            onTap(detail, pose.point)
        } label: {
            Canvas { ctx, _ in
                ctx.scaleBy(x: k, y: k)
                KaartDetailArt.draw(detail.kind, size: detail.size, t: t, night: night, season: season, in: &ctx)
            }
            .frame(width: detail.size.width * k, height: detail.size.height * k)
            .scaleEffect(x: pose.facingLeft ? -1 : 1, y: 1)
            .frame(width: max(40, detail.size.width * k), height: max(40, detail.size.height * k))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .position(kaartPoint(pose.point.x, pose.point.y, k))
        .accessibilityLabel(detail.spoken)
        .accessibilityHint("Tik: hoor het woord.")
    }
}

/// The note that pops up over a tapped detail: its word on a paper strip, the English, and
/// how many you have found.
struct KaartWordBubble: View {
    let detail: KaartDetail
    let isNew: Bool
    let found: Int
    let total: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                CourierLabel(text: isNew ? "Ontdekt! · \(found) / \(total)" : "\(found) / \(total) ontdekt", size: 11)
                Spacer(minLength: 0)
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Theme.muted)
            }
            PaperStrip(text: detail.nl, size: 20, tape: detail.article == .none ? nil : detail.article)
                .padding(.top, 4)
            Text(detail.en)
                .font(Fonts.body(13))
                .foregroundStyle(Theme.muted)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(width: 190, alignment: .leading)
        .background(Theme.note, in: RoundedRectangle(cornerRadius: 3))
        .rotationEffect(.degrees(-1))
        .shadow(color: Theme.ink.opacity(0.25), radius: 10, y: 6)
        .accessibilityElement(children: .combine)
    }
}

extension KaartDetailKind {
    /// What a tap makes you hear before the word: the thing's own sound where it has one
    /// (a bell, a horn, the organ, a splash, a till), else the music box of a find.
    var sound: (effect: KlinkerSound, wordAfter: Double) {
        switch self {
        case .draaiorgel: (.organ, 0.2)
        case .bloemenfiets, .bakfiets, .poes: (.bikeBell, 0.8)
        case .rondvaartboot, .sloep: (.boatHorn, 0.7)
        case .eend, .zwaan, .meerkoet, .waterfiets, .roeiboot, .hengel: (.splash, 0.35)
        case .stroopwafel, .friet, .haring, .kaas, .oliebol, .ijsje: (.register, 0.5)
        default: (.found, 0.35)
        }
    }
}
