import SwiftUI

/// While a place is locked: a red-and-white ribbon across its door, tied in a bow, with a
/// brass padlock hanging from it. `cut` (0...1) plays the opening: the ribbon parts and falls,
/// the padlock drops.
struct KaartRibbon: View, Equatable {
    /// The door inside the place's frame (world units).
    let door: CGRect
    let zoom: CGFloat
    var cut: Double = 0

    private static let pad: CGFloat = 14

    var body: some View {
        let k = zoom
        let pad = Self.pad
        let box = door.insetBy(dx: -pad, dy: -pad)
        let door = door
        let cut = cut
        Canvas { ctx, _ in
            ctx.scaleBy(x: k, y: k)
            ctx.translateBy(x: pad - door.minX, y: pad - door.minY)
            Self.draw(door: door, cut: cut, in: &ctx)
        }
        .frame(width: box.width * k, height: (box.height + 30) * k)
        .offset(x: box.minX * k, y: box.minY * k)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    static func draw(door: CGRect, cut: Double, in ctx: inout GraphicsContext) {
        let y = door.minY + door.height * 0.38
        let reach = max(4, door.width * 0.55)
        let left = door.minX - reach, right = door.maxX + reach, mid = door.midX
        let fade = 1 - min(1, cut * 1.4)
        let red = StadInk.hex(0xC8261B, fade), white = Color.white.opacity(0.9 * fade)
        let drop = cut * cut

        for (from, to, pivot, sign) in [(left, mid, left, 1.0), (mid, right, right, -1.0)] {
            var half = ctx
            half.translateBy(x: pivot, y: y)
            half.rotate(by: .degrees(sign * 75 * drop))
            half.translateBy(x: -pivot, y: -y)
            let band = CGRect(x: from, y: y - 1.2, width: to - from, height: 2.4)
            half.fill(Path(band), with: .color(red))
            var stripes = Path()
            var x = from + 0.6
            while x < to - 0.6 {
                stripes.addPath(KaartPen.polygon([(x, y + 1.2), (x + 0.8, y + 1.2), (x + 1.6, y - 1.2), (x + 0.8, y - 1.2)]))
                x += 2.4
            }
            half.fill(stripes, with: .color(white))
        }

        // The bow and the padlock hang from the middle until the ribbon is cut.
        if cut < 0.05 {
            for side in [-1.0, 1.0] {
                var loop = Path()
                loop.addEllipse(in: CGRect(x: mid + side * 2.6 - 2.2, y: y - 2.4, width: 4.4, height: 3.4))
                ctx.fill(loop, with: .color(red))
                ctx.fill(KaartPen.polygon([(mid, y), (mid + side * 1.6, y + 4.2), (mid + side * 0.4, y + 4.4)]), with: .color(red))
            }
            ctx.fill(Path(ellipseIn: CGRect(x: mid - 1.2, y: y - 1.2, width: 2.4, height: 2.4)), with: .color(StadInk.hex(0x8E1A12)))
        }
        let lockY = y + 2 + drop * 26
        var lock = ctx
        lock.opacity = 1 - min(1, cut * 1.2)
        var shackle = Path()
        shackle.addArc(center: CGPoint(x: mid, y: lockY + 3.2), radius: 2.4, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
        lock.stroke(shackle, with: .color(StadInk.hex(0x5F5E5A)), lineWidth: 1.2)
        let body = CGRect(x: mid - 3.6, y: lockY + 3, width: 7.2, height: 6)
        lock.fill(Path(roundedRect: body.offsetBy(dx: 0.5, dy: 0.6), cornerRadius: 1.4), with: .color(StadInk.hex(0x1E1E1C, 0.25)))
        lock.fill(Path(roundedRect: body, cornerRadius: 1.4), with: .color(StadInk.hex(0xD9A441)))
        lock.fill(Path(roundedRect: CGRect(x: body.minX, y: body.minY, width: body.width, height: 1.6), cornerRadius: 0.8), with: .color(StadInk.hex(0xF2C96B)))
        lock.fill(Path(ellipseIn: CGRect(x: mid - 0.8, y: body.minY + 2, width: 1.6, height: 1.6)), with: .color(StadInk.hex(0x2E2117)))
        lock.fill(Path(CGRect(x: mid - 0.4, y: body.minY + 3.2, width: 0.8, height: 1.6)), with: .color(StadInk.hex(0x2E2117)))
    }
}

/// Under the place that opens next: "VEL 15 · VOLGENDE".
struct KaartSketchLabel: View {
    let n: Int
    let next: Bool
    let night: Bool

    var body: some View {
        Text("VEL \(n) · VOLGENDE")
            .font(Fonts.label(11))
            .foregroundStyle(night ? StadInk.hex(0xF6D27A) : Theme.orangeText)
            .padding(.horizontal, 5)
            .padding(.vertical, 1)
            .background(night ? StadInk.hex(0x2E3446) : Theme.note)
            .overlay(Rectangle().stroke(Theme.orange, style: StrokeStyle(lineWidth: 1.5, dash: [3, 2])))
            .fixedSize()
            .rotationEffect(.degrees(-1.5))
    }
}
