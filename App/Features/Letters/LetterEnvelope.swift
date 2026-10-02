import SwiftUI

/// The big envelope: kraft paper, flap, wax seal, "Aan: Noor · Utrecht" and a NIEUW / GELEZEN tag.
struct LetterEnvelopeFace: View {
    var width: CGFloat = 290
    var height: CGFloat = 184
    var sealed = true
    var tag: String?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3).fill(LetterInk.envelope)
            LetterPolygon.bottomFold.fill(LetterInk.envelopeShade)
            LetterPolygon.flap.fill(LetterInk.flap)
        }
        .frame(width: width, height: height)
        .overlay(alignment: .bottomLeading) {
            Text("Aan: Noor · Utrecht")
                .font(Fonts.label(13))
                .foregroundStyle(LetterInk.envelopeInk)
                .padding(.leading, 14)
                .padding(.bottom, 12)
        }
        .overlay(alignment: .topTrailing) {
            if let tag {
                Text(tag)
                    .font(.custom("AvenirNext-Heavy", size: 13))
                    .foregroundStyle(Theme.onInk)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Theme.ink)
                    .rotationEffect(.degrees(4))
                    .padding(.top, 10)
                    .padding(.trailing, 12)
            }
        }
        .overlay(alignment: .top) {
            LetterWaxSeal(size: 56, broken: !sealed)
                .offset(y: height * 0.62 - 28)
        }
        .compositingGroup()
        .shadow(color: LetterInk.hex(0x3C280A, 0.22), radius: 8, y: 6)
    }
}

/// A small opened envelope (the icon on the postbus tiles).
struct LetterMiniEnvelope: View {
    var body: some View {
        Canvas { ctx, size in
            let k = min(size.width / 34, size.height / 24)
            ctx.scaleBy(x: k, y: k)
            ctx.fill(Path(CGRect(x: 2, y: 10, width: 30, height: 13)), with: .color(LetterInk.envelope))
            var flap = Path()
            flap.move(to: CGPoint(x: 2, y: 10)); flap.addLine(to: CGPoint(x: 17, y: 1)); flap.addLine(to: CGPoint(x: 32, y: 10))
            flap.closeSubpath()
            ctx.fill(flap, with: .color(LetterInk.flap))
            var v = Path()
            v.move(to: CGPoint(x: 2, y: 10)); v.addLine(to: CGPoint(x: 17, y: 18)); v.addLine(to: CGPoint(x: 32, y: 10))
            ctx.stroke(v, with: .color(LetterInk.hex(0x9C7F4C)), lineWidth: 1.4)
        }
        .frame(width: 34, height: 24)
        .accessibilityHidden(true)
    }
}

/// The red Dutch brievenbus on the home card, with an envelope in the slot when there's mail.
struct LetterMailbox: View {
    var hasMail: Bool

    var body: some View {
        Canvas { ctx, size in
            let k = min(size.width / 76, size.height / 104)
            ctx.translateBy(x: (size.width - 76 * k) / 2, y: size.height - 104 * k)
            ctx.scaleBy(x: k, y: k)
            Self.draw(hasMail: hasMail, in: &ctx)
        }
        .accessibilityHidden(true)
    }

    private static func draw(hasMail: Bool, in ctx: inout GraphicsContext) {
        let red = LetterInk.mailboxRed
        let dark = LetterInk.hex(0x8E1A12)
        // Ground shadow and post.
        ctx.fill(Path(ellipseIn: CGRect(x: 18, y: 99, width: 40, height: 5)), with: .color(LetterInk.hex(0x1E1E1C, 0.15)))
        ctx.fill(Path(CGRect(x: 33, y: 76, width: 10, height: 26)), with: .color(LetterInk.hex(0x3D3D3A)))
        // Body with a rounded top.
        var body = Path()
        body.move(to: CGPoint(x: 10, y: 76))
        body.addLine(to: CGPoint(x: 10, y: 34))
        body.addCurve(to: CGPoint(x: 38, y: 12), control1: CGPoint(x: 10, y: 20), control2: CGPoint(x: 22, y: 12))
        body.addCurve(to: CGPoint(x: 66, y: 34), control1: CGPoint(x: 54, y: 12), control2: CGPoint(x: 66, y: 20))
        body.addLine(to: CGPoint(x: 66, y: 76))
        body.closeSubpath()
        ctx.fill(body, with: .color(red))
        var side = ctx
        side.clip(to: body)
        side.fill(Path(CGRect(x: 57, y: 0, width: 10, height: 80)), with: .color(LetterInk.hex(0xA31E15)))
        side.fill(Path(ellipseIn: CGRect(x: 16, y: 16, width: 16, height: 10)), with: .color(Color.white.opacity(0.22)))
        // Lid seam, base and slot.
        var seam = Path()
        seam.move(to: CGPoint(x: 10, y: 33)); seam.addLine(to: CGPoint(x: 66, y: 33))
        ctx.stroke(seam, with: .color(dark), lineWidth: 1.5)
        ctx.fill(Path(roundedRect: CGRect(x: 7, y: 74, width: 62, height: 6), cornerRadius: 1.5), with: .color(dark))
        ctx.fill(Path(roundedRect: CGRect(x: 21, y: 40, width: 34, height: 6), cornerRadius: 3), with: .color(LetterInk.hex(0x3A0E0A)))
        // Emblem: a cream plate with a little envelope.
        ctx.fill(Path(roundedRect: CGRect(x: 26, y: 53, width: 24, height: 16), cornerRadius: 2.5), with: .color(LetterInk.hex(0xF6EBD9)))
        let icon = CGRect(x: 31, y: 57, width: 14, height: 9)
        var mark = Path(icon)
        mark.move(to: CGPoint(x: icon.minX, y: icon.minY))
        mark.addLine(to: CGPoint(x: icon.midX, y: icon.midY + 1))
        mark.addLine(to: CGPoint(x: icon.maxX, y: icon.minY))
        ctx.stroke(mark, with: .color(red), style: StrokeStyle(lineWidth: 1.5, lineJoin: .round))
        guard hasMail else { return }
        // An envelope sticking out of the slot (only the part above the slot shows).
        var mail = ctx
        mail.clip(to: Path(CGRect(x: 0, y: 0, width: 76, height: 43.5)))
        mail.translateBy(x: 40, y: 34)
        mail.rotate(by: .degrees(-13))
        let env = CGRect(x: -15, y: -12, width: 30, height: 22)
        mail.fill(Path(env), with: .color(LetterInk.cream))
        mail.stroke(Path(env), with: .color(LetterInk.hex(0x9C7F4C)), lineWidth: 0.8)
        var flap = Path()
        flap.move(to: CGPoint(x: -15, y: -12)); flap.addLine(to: CGPoint(x: 0, y: -2)); flap.addLine(to: CGPoint(x: 15, y: -12))
        mail.stroke(flap, with: .color(LetterInk.hex(0x9C7F4C)), lineWidth: 1)
        mail.fill(Path(ellipseIn: CGRect(x: -3.5, y: -5.5, width: 7, height: 7)), with: .color(LetterInk.hex(0xA3201A)))
    }
}
