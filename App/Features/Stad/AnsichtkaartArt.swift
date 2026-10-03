import SwiftUI

/// Delft Blue: one cobalt ink on cream, as on the tiles and plates.
nonisolated enum Delft {
    static let ink: UInt32 = 0x1F3F8F
    static let paper: UInt32 = 0xF5F2E9

    static var inkColor: Color { StadInk.hex(ink) }
    static var paperColor: Color { StadInk.hex(paper) }

    /// Repaints anything in Delft Blue: dark becomes cobalt, light becomes paper, by brightness
    /// (a little contrast, so the drawing reads like ink).
    static var matrix: ColorMatrix {
        func ch(_ v: UInt32, _ shift: UInt32) -> Float { Float((v >> shift) & 0xFF) / 255 }
        let contrast: Float = 1.15, lift: Float = 0.1
        var m = ColorMatrix()
        for (shift, set) in [(UInt32(16), 0), (8, 1), (0, 2)] {
            let i = ch(ink, shift), d = ch(paper, shift) - ch(ink, shift)
            let row = (contrast * d * 0.3, contrast * d * 0.59, contrast * d * 0.11, Float(0), i + lift * d)
            switch set {
            case 0: (m.r1, m.r2, m.r3, m.r4, m.r5) = row
            case 1: (m.g1, m.g2, m.g3, m.g4, m.g5) = row
            default: (m.b1, m.b2, m.b3, m.b4, m.b5) = row
            }
        }
        (m.a1, m.a2, m.a3, m.a4, m.a5) = (0, 0, 0, 1, 0)
        return m
    }
}

/// The row of buildings on a neighbourhood's postcard, in art units (ground at y = 0).
struct AnsichtkaartScene {
    struct Item {
        var art: KaartLandmark?
        /// Left edge of the art's bounds on the row.
        var x: Double
        var pick: Int?
    }

    let items: [Item]
    /// The middle of the picked buildings (art units), to centre the card on.
    let center: Double
    /// The tallest picked building (art units).
    let height: Double
    let rural: Bool
    let warm: (item: Int, window: CGRect)?

    private static var cache: [Int: AnsichtkaartScene] = [:]

    static func of(_ buurt: Buurt) -> AnsichtkaartScene {
        if let scene = cache[buurt.id] { return scene }
        let scene = make(buurt)
        cache[buurt.id] = scene
        return scene
    }

    private static func make(_ buurt: Buurt) -> AnsichtkaartScene {
        var rnd = GevelRandom(seed: buurt.id * 7919 + 3)
        func filler() -> KaartLandmark? {
            guard !buurt.rural else { return nil }
            let type = rnd.pick([GableType.trap, .hals, .hals, .klok, .klok, .tuit, .lijst])
            let width = type == .lijst ? rnd.pick([96.0, 104]) : rnd.pick([62.0, 66, 70, 76])
            var pen = KaartPen(wall: rnd.pick(Gevelkit.facades), door: rnd.pick(Gevelkit.doors), awning: rnd.pick(Gevelkit.awnings))
            pen.canalHouse(x: 0, type: type, width: width, floors: rnd.pick([2, 2, 3]), flowers: rnd.next() < 0.5, doorLeft: rnd.next() < 0.5, seed: Int(rnd.next() * 1000))
            return pen.art
        }
        var arts: [(KaartLandmark?, Int?)] = []
        for _ in 0..<4 { arts.append((filler(), nil)) }
        for (i, n) in buurt.picks.enumerated() {
            if i > 0 { arts.append((filler(), nil)) }
            arts.append((KaartData.house(n).landmark, n))
        }
        for _ in 0..<4 { arts.append((filler(), nil)) }

        var items: [Item] = []
        var cursor = 0.0
        for (art, pick) in arts {
            if let art {
                let bounds = art.bounds
                items.append(Item(art: art, x: cursor, pick: pick))
                // The next building stands in front of this one's side wall.
                cursor += bounds.width - (pick == nil ? 28 : 18)
            } else {
                // A tree (out of town).
                items.append(Item(art: nil, x: cursor, pick: nil))
                cursor += 56
            }
        }
        let picked = items.filter { $0.pick != nil }
        let left: Double = picked.first?.x ?? 0
        var right: Double = left
        if let last = picked.last { right = last.x + Double(last.art?.bounds.width ?? 0) }
        let heights: [Double] = picked.compactMap { item in item.art.map { Double(-$0.bounds.minY) } }
        let tallest: Double = heights.max() ?? 200
        var warm: (Int, CGRect)?
        if let i = items.firstIndex(where: { $0.pick == buurt.warm }), let art = items[i].art, let window = art.marks[.raam] {
            warm = (i, window)
        }
        return AnsichtkaartScene(items: items, center: (left + right) / 2, height: tallest, rural: buurt.rural, warm: warm)
    }
}

/// The picture on a postcard: the neighbourhood along the water in Delft Blue, with one window
/// lit warm.
struct AnsichtkaartPicture: View {
    let buurt: Buurt

    var body: some View {
        let scene = AnsichtkaartScene.of(buurt)
        Canvas { ctx, size in
            Self.draw(scene, size: size, in: &ctx)
        }
        .accessibilityHidden(true)
    }

    static func draw(_ scene: AnsichtkaartScene, size: CGSize, in ctx: inout GraphicsContext) {
        let w = Double(size.width), h = Double(size.height)
        let ground = h * 0.7
        let k = ground * 0.82 / max(120, scene.height)
        let shift = w / 2 / k - scene.center
        let look = KaartLook(night: false, season: .zomer, locked: false, lightsOn: false)

        var blue = ctx
        blue.addFilter(.colorMatrix(Delft.matrix))
        blue.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Delft.paperColor))

        // Sky: fine hatching at the top, a few clouds and gulls.
        var sky = blue
        sky.clip(to: Path(CGRect(x: 0, y: 0, width: w, height: ground)))
        var hatch = Path()
        var x = -h
        while x < w { hatch.move(to: CGPoint(x: x, y: 0)); hatch.addLine(to: CGPoint(x: x + h * 0.35, y: h * 0.35)); x += 4.5 }
        sky.stroke(hatch, with: .color(StadInk.hex(0xA9B4C8)), lineWidth: 0.5)
        for (cx, cy, s) in [(0.2, 0.17, 1.0), (0.72, 0.1, 0.8), (0.9, 0.24, 0.6)] {
            var cloud = Path()
            for (dx, dy, r) in [(-0.9, 0.2, 0.55), (-0.3, -0.1, 0.75), (0.4, 0.0, 0.65), (0.95, 0.25, 0.45)] {
                let rr = r * 16 * s
                cloud.addEllipse(in: CGRect(x: cx * w + dx * 18 * s - rr, y: cy * h + dy * 14 * s - rr, width: 2 * rr, height: 2 * rr))
            }
            sky.fill(cloud, with: .color(Delft.paperColor))
            sky.stroke(cloud, with: .color(StadInk.hex(0x6A7891)), lineWidth: 0.8)
        }
        var birds = Path()
        for (bx, by) in [(0.42, 0.12), (0.47, 0.16), (0.55, 0.09)] {
            birds.move(to: CGPoint(x: bx * w - 4, y: by * h)); birds.addQuadCurve(to: CGPoint(x: bx * w, y: by * h + 1), control: CGPoint(x: bx * w - 2, y: by * h - 3))
            birds.addQuadCurve(to: CGPoint(x: bx * w + 4, y: by * h), control: CGPoint(x: bx * w + 2, y: by * h - 3))
        }
        sky.stroke(birds, with: .color(StadInk.hex(0x2E2E2E)), lineWidth: 0.9)

        // The buildings, then their reflections in the water.
        func drawRow(_ c: inout GraphicsContext) {
            for item in scene.items {
                var b = c
                b.translateBy(x: (shift + item.x) * k, y: 0)
                b.scaleBy(x: k, y: k)
                if let art = item.art {
                    b.translateBy(x: -art.bounds.minX, y: 0)
                    KaartLandmarkPainter.draw(art, look: look, in: &b)
                } else {
                    tree(&b)
                }
            }
        }
        var row = blue
        row.translateBy(x: 0, y: ground)
        drawRow(&row)

        let quay = scene.rural ? 5.0 : 7.0
        let waterTop = ground + quay
        if scene.rural {
            blue.fill(Path(CGRect(x: 0, y: ground, width: w, height: quay)), with: .color(StadInk.hex(0x7E9A62)))
        } else {
            blue.fill(Path(CGRect(x: 0, y: ground, width: w, height: quay)), with: .color(StadInk.hex(0x8C4A3A)))
            var bricks = Path()
            var bx = 0.0
            while bx < w { bricks.move(to: CGPoint(x: bx, y: ground + 3.5)); bricks.addLine(to: CGPoint(x: bx + 6, y: ground + 3.5)); bx += 9 }
            blue.stroke(bricks, with: .color(StadInk.hex(0xE8DCC8)), lineWidth: 0.5)
        }
        let water = CGRect(x: 0, y: waterTop, width: w, height: h - waterTop)
        blue.fill(Path(water), with: .color(StadInk.hex(0xB4C2CE)))
        var mirror = blue
        mirror.clip(to: Path(water))
        mirror.opacity = 0.22
        mirror.translateBy(x: 0, y: waterTop)
        mirror.scaleBy(x: 1, y: -0.8)
        drawRow(&mirror)
        var ripples = Path()
        var rnd = GevelRandom(seed: 41)
        for _ in 0..<26 {
            let rx = rnd.next() * w, ry = waterTop + 3 + rnd.next() * (h - waterTop - 5), len = 8 + rnd.next() * 18
            ripples.move(to: CGPoint(x: rx, y: ry)); ripples.addLine(to: CGPoint(x: rx + len, y: ry))
        }
        blue.stroke(ripples, with: .color(Delft.paperColor), lineWidth: 0.8)
        let edge = Path { $0.move(to: CGPoint(x: 0, y: waterTop)); $0.addLine(to: CGPoint(x: w, y: waterTop)) }
        blue.stroke(edge, with: .color(StadInk.hex(0x2E2E2E)), lineWidth: 1)

        // A rowing boat on the water.
        var boat = blue
        boat.translateBy(x: w * 0.68, y: waterTop + (h - waterTop) * 0.55)
        var hull = Path()
        hull.move(to: CGPoint(x: -22, y: -3)); hull.addLine(to: CGPoint(x: 22, y: -3))
        hull.addQuadCurve(to: CGPoint(x: 16, y: 4), control: CGPoint(x: 20, y: 3)); hull.addLine(to: CGPoint(x: -16, y: 4))
        hull.addQuadCurve(to: CGPoint(x: -22, y: -3), control: CGPoint(x: -20, y: 3)); hull.closeSubpath()
        boat.fill(hull, with: .color(StadInk.hex(0x6B4A2E)))
        boat.stroke(hull, with: .color(StadInk.hex(0x2E2E2E)), lineWidth: 0.8)
        boat.stroke(Path { $0.move(to: CGPoint(x: -14, y: -1)); $0.addLine(to: CGPoint(x: 14, y: -1)) }, with: .color(Delft.paperColor), lineWidth: 0.8)

        // One window lit warm, and its glow on the water.
        if let warm = scene.warm, let art = scene.items[warm.item].art {
            let item = scene.items[warm.item]
            let r = warm.window
            let rect = CGRect(
                x: (shift + item.x + (r.minX - art.bounds.minX)) * k, y: ground + r.minY * k,
                width: r.width * k, height: r.height * k
            )
            let glow = Gradient(colors: [StadInk.hex(0xF6C85A, 0.55), StadInk.hex(0xF6C85A, 0)])
            let center = CGPoint(x: rect.midX, y: rect.midY)
            ctx.fill(Path(ellipseIn: rect.insetBy(dx: -rect.width * 1.4, dy: -rect.height * 1.1)), with: .radialGradient(glow, center: center, startRadius: 0, endRadius: max(rect.width, rect.height) * 1.6))
            ctx.fill(Path(rect), with: .color(StadInk.hex(0xF6C85A)))
            var bars = Path()
            bars.move(to: CGPoint(x: rect.midX, y: rect.minY)); bars.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            bars.move(to: CGPoint(x: rect.minX, y: rect.midY)); bars.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            ctx.stroke(bars, with: .color(Delft.inkColor), lineWidth: 0.7)
            ctx.stroke(Path(rect), with: .color(Delft.inkColor), lineWidth: 0.9)
            let streak = CGRect(x: rect.minX - 2, y: waterTop + (ground - rect.maxY) * 0.8, width: rect.width + 4, height: 10)
            ctx.fill(Path(ellipseIn: streak), with: .color(StadInk.hex(0xF6C85A, 0.3)))
        }
    }

    /// A round tree for the country card (art units, ground at y = 0).
    private static func tree(_ ctx: inout GraphicsContext) {
        ctx.fill(Path(CGRect(x: 25, y: -40, width: 5, height: 40)), with: .color(StadInk.hex(0x4A3524)))
        var crown = Path()
        for (x, y, r) in [(27.5, -66.0, 24.0), (14, -52, 16), (41, -54, 16)] {
            crown.addEllipse(in: CGRect(x: x - r, y: y - r, width: 2 * r, height: 2 * r))
        }
        ctx.fill(crown, with: .color(StadInk.hex(0x6E9C52)))
        ctx.stroke(crown, with: .color(StadInk.hex(0x2E2E2E)), lineWidth: 2)
    }
}

/// The front of a postcard: the picture in a Delft frame, "Groeten uit …", a stamp and a postmark.
struct AnsichtkaartFront: View {
    let buurt: Buurt

    var body: some View {
        GeometryReader { geo in
            let f = geo.size.width / 360
            ZStack(alignment: .topLeading) {
                Delft.paperColor
                AnsichtkaartPicture(buurt: buurt)
                    .clipShape(Rectangle())
                    .overlay(Rectangle().strokeBorder(Delft.inkColor, lineWidth: 1.4 * f))
                    .padding(9 * f)
                Rectangle().strokeBorder(Delft.inkColor.opacity(0.5), lineWidth: 0.6 * f)
                    .padding(5 * f)
                VStack(alignment: .leading, spacing: 0) {
                    Text("GROETEN UIT")
                        .font(Fonts.label(8 * f))
                        .tracking(2 * f)
                    Text(buurt.name)
                        .font(.custom("Baskerville-SemiBoldItalic", size: 22 * f))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                .foregroundStyle(Delft.inkColor)
                .padding(.horizontal, 9 * f)
                .padding(.vertical, 5 * f)
                .background(Delft.paperColor)
                .overlay(Rectangle().strokeBorder(Delft.inkColor, lineWidth: 1.2 * f))
                .rotationEffect(.degrees(-2))
                .padding(.leading, 18 * f)
                .padding(.top, 18 * f)
                AnsichtkaartStamp(scale: f)
                    .frame(maxWidth: .infinity, alignment: .topTrailing)
                    .padding(.trailing, 18 * f)
                    .padding(.top, 16 * f)
            }
        }
        .aspectRatio(1.5, contentMode: .fit)
        .compositingGroup()
        .shadow(color: Theme.ink.opacity(0.18), radius: 6, y: 3)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Ansichtkaart: \(buurt.title)")
    }
}

/// A Klinker postage stamp with a postmark struck over its corner.
struct AnsichtkaartStamp: View {
    let scale: CGFloat

    var body: some View {
        let f = scale
        ZStack(alignment: .bottomLeading) {
            VStack(spacing: 0) {
                Text("K")
                    .font(.custom("Baskerville-SemiBold", size: 20 * f))
                Text("682")
                    .font(Fonts.label(7 * f))
            }
            .foregroundStyle(Delft.paperColor)
            .frame(width: 38 * f, height: 46 * f)
            .background(Delft.inkColor)
            .overlay(Rectangle().strokeBorder(Delft.paperColor, lineWidth: 1 * f).padding(3 * f))
            .padding(2.5 * f)
            .background(Delft.paperColor)
            .overlay(Rectangle().strokeBorder(Delft.paperColor, style: StrokeStyle(lineWidth: 3 * f, dash: [2.5 * f, 2.5 * f])))
            .rotationEffect(.degrees(3))
            Canvas { ctx, size in
                let c = CGPoint(x: size.width * 0.35, y: size.height * 0.5)
                let ink = Delft.inkColor.opacity(0.6)
                for r in [14 * f, 10 * f] {
                    ctx.stroke(Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: 2 * r, height: 2 * r)), with: .color(ink), lineWidth: 0.9 * f)
                }
                var waves = Path()
                for i in 0..<3 {
                    let y = c.y - 5 * f + CGFloat(i) * 5 * f
                    waves.move(to: CGPoint(x: c.x + 15 * f, y: y))
                    for s in 0..<4 {
                        let x0 = c.x + 15 * f + CGFloat(s) * 7 * f
                        waves.addQuadCurve(to: CGPoint(x: x0 + 7 * f, y: y), control: CGPoint(x: x0 + 3.5 * f, y: y + (s % 2 == 0 ? -2.5 : 2.5) * f))
                    }
                }
                ctx.stroke(waves, with: .color(ink), lineWidth: 0.9 * f)
                ctx.draw(Text("KLINKER").font(Fonts.label(4.5 * f)).foregroundStyle(ink), at: c)
            }
            .frame(width: 70 * f, height: 32 * f)
            .offset(x: -24 * f, y: 10 * f)
            .allowsHitTesting(false)
        }
        .accessibilityHidden(true)
    }
}

/// The back: a note from Ria in handwriting, and the address.
struct AnsichtkaartBack: View {
    let buurt: Buurt

    var body: some View {
        GeometryReader { geo in
            let f = geo.size.width / 360
            HStack(alignment: .top, spacing: 0) {
                Text(message)
                    .font(.custom("Noteworthy-Light", size: 11.5 * f))
                    .foregroundStyle(Delft.inkColor)
                    .minimumScaleFactor(0.75)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(14 * f)
                Rectangle()
                    .fill(Delft.inkColor.opacity(0.4))
                    .frame(width: 0.8 * f)
                    .padding(.vertical, 18 * f)
                VStack(alignment: .trailing, spacing: 10 * f) {
                    AnsichtkaartStamp(scale: f * 0.85)
                    Spacer(minLength: 0)
                    VStack(alignment: .leading, spacing: 7 * f) {
                        ForEach(["Noor", "Jouw huis", "Klinkerstad"], id: \.self) { line in
                            Text(line)
                                .font(.custom("Noteworthy-Bold", size: 13 * f))
                                .foregroundStyle(Delft.inkColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .overlay(alignment: .bottom) {
                                    Rectangle().fill(Delft.inkColor.opacity(0.45)).frame(height: 0.7 * f).offset(y: 2 * f)
                                }
                        }
                    }
                    Spacer(minLength: 0)
                }
                .frame(width: geo.size.width * 0.4)
                .padding(14 * f)
            }
            .background(Delft.paperColor)
        }
        .aspectRatio(1.5, contentMode: .fit)
        .compositingGroup()
        .shadow(color: Theme.ink.opacity(0.18), radius: 6, y: 3)
        .accessibilityElement(children: .combine)
    }

    private var message: String {
        let names = Array(Set(buurt.picks + buurt.places).sorted { a, b in
            let ia = buurt.picks.firstIndex(of: a) ?? 99 + a, ib = buurt.picks.firstIndex(of: b) ?? 99 + b
            return ia < ib
        }.prefix(3)).map(StadPlaces.spoken)
        let list = names.count == 3 ? "\(names[0]), \(names[1]) en \(names[2])" : names.joined(separator: " en ")
        return "Lieve Noor,\n\nGroeten uit \(buurt.name)! Vandaag fietste ik langs \(list). Alle \(buurt.places.count) plekken zijn nu open.\n\nTot gauw!\nRia"
    }
}
