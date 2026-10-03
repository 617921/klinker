import SwiftUI

/// The city's streets and water at street level: klinker (brick) streets, arched bridges,
/// houseboats, and the light on the ground: sun shadows of the places and, at night, the glow
/// of their windows. World units, drawn into the static map.
nonisolated enum KaartCity {
    /// Streets as on a hand-drawn map: inked on both sides, pale paving inside with a faint brick
    /// texture (a dashed stroke, so the bricks follow every curve). One path, so junctions are clean.
    static func drawStreets(_ path: Path, in ctx: inout GraphicsContext, colors c: KaartColors, night: Bool) {
        ctx.stroke(path, with: .color(KaartInk.line(night: night)), style: StrokeStyle(lineWidth: 13.2, lineCap: .round, lineJoin: .round))
        ctx.stroke(path, with: .color(c.street), style: StrokeStyle(lineWidth: 11.2, lineCap: .round, lineJoin: .round))
        ctx.stroke(path, with: .color(c.brickJoint.opacity(0.18)), style: StrokeStyle(lineWidth: 10, lineCap: .butt, dash: [0.7, 2.3]))
    }

    /// A brick deck with stone parapets over the water, and the dark arch underneath on the near side.
    static func drawBridges(_ bridges: [(center: CGPoint, angle: Double)], in ctx: inout GraphicsContext, colors c: KaartColors, night: Bool) {
        let arch = StadInk.hex(night ? 0x10151F : 0x2E4A5C, night ? 0.7 : 0.45)
        for bridge in bridges {
            var b = ctx
            b.translateBy(x: bridge.center.x, y: bridge.center.y)
            b.rotate(by: .radians(bridge.angle))
            // Along x: the street. Along y: the canal.
            let deck = CGRect(x: -17, y: -8, width: 34, height: 16)
            // The arch shows on whichever side faces down the screen.
            let nearSide: CGFloat = cos(bridge.angle) >= 0 ? 1 : -1
            var opening = Path()
            opening.addEllipse(in: CGRect(x: -8, y: nearSide > 0 ? 5 : -11, width: 16, height: 6))
            b.fill(opening, with: .color(arch))
            b.fill(Path(roundedRect: deck, cornerRadius: 2), with: .color(c.street))
            b.stroke(Path(deck), with: .color(c.brickJoint), style: StrokeStyle(lineWidth: 0.6, dash: [0.9, 3]))
            for y in [-7.0, 7.0] {
                var rail = Path()
                rail.move(to: CGPoint(x: -17, y: y))
                rail.addLine(to: CGPoint(x: 17, y: y))
                b.stroke(rail, with: .color(KaartInk.line(night: night)), style: StrokeStyle(lineWidth: 3.4, lineCap: .round))
                b.stroke(rail, with: .color(c.parapet), style: StrokeStyle(lineWidth: 1.8, lineCap: .round))
            }
        }
    }

    /// Houseboats along the canal edges: a hull, a cabin with windows and a few pot plants.
    static func drawHouseboats(_ boats: [(center: CGPoint, heading: Double, color: UInt32)], in ctx: inout GraphicsContext, night: Bool) {
        let f = night ? 0.5 : 1
        for boat in boats {
            var b = ctx
            b.translateBy(x: boat.center.x, y: boat.center.y)
            b.rotate(by: .degrees(boat.heading))
            b.fill(Path(roundedRect: CGRect(x: -12, y: -4, width: 24, height: 8), cornerRadius: 3), with: .color(StadInk.hex(Gevelkit.shade(boat.color, f))))
            b.fill(Path(CGRect(x: -8, y: -3, width: 14, height: 6)), with: .color(StadInk.hex(night ? 0x8A7F6E : 0xEFE6D6)))
            b.fill(Path(CGRect(x: -8.5, y: -3.3, width: 15, height: 1.6)), with: .color(StadInk.hex(Gevelkit.shade(0x3A3632, f))))
            for x in [-5.5, -1.5, 2.5] {
                b.fill(Path(CGRect(x: x, y: -0.6, width: 2.2, height: 2.2)), with: .color(StadInk.hex(night ? 0xF6D27A : 0x5E6B73)))
            }
            for (x, y) in [(8.5, -1.5), (9.5, 1.5)] {
                b.fill(Path(ellipseIn: CGRect(x: x - 1.6, y: y - 1.6, width: 3.2, height: 3.2)), with: .color(StadInk.hex(Gevelkit.shade(0x5E8C45, f))))
            }
        }
    }

    /// Each standing place's silhouette cast onto the ground, leaning with the sun.
    static func drawPlaceShadows(_ standing: [Int], lean: Double, in ctx: inout GraphicsContext) {
        var shadows = Path()
        for n in standing {
            guard let place = KaartData.byNumber[n] else { continue }
            let geo = KaartData.house(n)
            var silhouette = geo.gevel.body
            for part in [geo.side, geo.roof, geo.spA, geo.spB] { silhouette.addPath(part) }
            let world = CGAffineTransform(
                translationX: place.point.x - geo.buttonWidth / 2 + geo.spriteOrigin.x,
                y: place.point.y - 58 + geo.spriteOrigin.y
            )
            .scaledBy(x: geo.spriteSize.width / geo.viewBox.width, y: geo.spriteSize.height / geo.viewBox.height)
            .translatedBy(x: -geo.viewBox.minX, y: -geo.viewBox.minY)
            shadows.addPath(silhouette.applying(world).applying(KaartFiller.sunShear(lean: lean, baseY: place.point.y)))
        }
        ctx.fill(shadows, with: .color(StadInk.hex(0x1E1E1C, 0.13)))
    }

    /// At night, lit windows throw warm light on the street in front of each built place.
    static func drawPlaceGlows(_ built: [Int], in ctx: inout GraphicsContext) {
        let glow = Gradient(colors: [StadInk.hex(0xF6D27A, 0.38), StadInk.hex(0xF6D27A, 0)])
        for n in built {
            guard let place = KaartData.byNumber[n] else { continue }
            let center = CGPoint(x: place.point.x, y: place.point.y + 4)
            var c = ctx
            c.translateBy(x: center.x, y: center.y)
            c.scaleBy(x: 1, y: 0.32)
            c.fill(Path(ellipseIn: CGRect(x: -34, y: -34, width: 68, height: 68)), with: .radialGradient(glow, center: .zero, startRadius: 0, endRadius: 34))
        }
    }
}
