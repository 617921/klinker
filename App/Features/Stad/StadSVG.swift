import SwiftUI

/// Colours for the city drawings. Usable from any isolation (Theme's `Color(hex:)` is main-actor bound).
nonisolated enum StadInk {
    static func hex(_ value: UInt32, _ opacity: Double = 1) -> Color {
        Color(
            .sRGB,
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255,
            opacity: opacity
        )
    }
}

/// Parses SVG path data into a SwiftUI `Path`, so the prototype's path strings can be used verbatim.
/// Supports M L H V C S Q T A Z (absolute and relative). Same fill semantics as the browser.
nonisolated enum StadSVG {
    static func path(_ data: String) -> Path {
        var parser = StadSVGParser(bytes: Array(data.utf8))
        parser.parse()
        return parser.path
    }
}

nonisolated private struct StadSVGParser {
    let bytes: [UInt8]
    var index = 0
    var path = Path()
    var current = CGPoint.zero
    var subpathStart = CGPoint.zero
    var lastCubic: CGPoint?
    var lastQuad: CGPoint?

    init(bytes: [UInt8]) { self.bytes = bytes }

    private static let commands = Set("MmLlHhVvCcSsQqTtAaZz".utf8)

    mutating func parse() {
        var command: UInt8 = 0
        while true {
            skipSeparators()
            guard index < bytes.count else { return }
            let c = bytes[index]
            if Self.commands.contains(c) {
                command = c
                index += 1
            } else if command == 0 || command == UInt8(ascii: "Z") || command == UInt8(ascii: "z") {
                return
            }
            guard apply(command) else { return }
            // Extra coordinate pairs after a moveto are linetos.
            if command == UInt8(ascii: "M") { command = UInt8(ascii: "L") }
            if command == UInt8(ascii: "m") { command = UInt8(ascii: "l") }
        }
    }

    private mutating func skipSeparators() {
        while index < bytes.count {
            let c = bytes[index]
            if c == 32 || c == 44 || c == 9 || c == 10 || c == 13 { index += 1 } else { break }
        }
    }

    private mutating func number() -> Double? {
        skipSeparators()
        guard index < bytes.count else { return nil }
        let start = index
        if bytes[index] == UInt8(ascii: "-") || bytes[index] == UInt8(ascii: "+") { index += 1 }
        var digits = false
        var dot = false
        while index < bytes.count {
            let c = bytes[index]
            if c >= 48 && c <= 57 {
                digits = true
                index += 1
            } else if c == UInt8(ascii: ".") && !dot {
                dot = true
                index += 1
            } else {
                break
            }
        }
        if digits, index < bytes.count, bytes[index] == UInt8(ascii: "e") || bytes[index] == UInt8(ascii: "E") {
            var probe = index + 1
            if probe < bytes.count, bytes[probe] == UInt8(ascii: "-") || bytes[probe] == UInt8(ascii: "+") { probe += 1 }
            if probe < bytes.count, bytes[probe] >= 48, bytes[probe] <= 57 {
                index = probe
                while index < bytes.count, bytes[index] >= 48, bytes[index] <= 57 { index += 1 }
            }
        }
        guard digits else {
            index = start
            return nil
        }
        return Double(String(decoding: bytes[start..<index], as: UTF8.self))
    }

    private mutating func point(_ relative: Bool) -> CGPoint? {
        guard let x = number(), let y = number() else { return nil }
        return relative ? CGPoint(x: current.x + x, y: current.y + y) : CGPoint(x: x, y: y)
    }

    private mutating func apply(_ command: UInt8) -> Bool {
        let relative = command >= 97
        let kind = command | 0x20
        var keepCubic = false
        var keepQuad = false
        switch kind {
        case UInt8(ascii: "m"):
            guard let p = point(relative) else { return false }
            path.move(to: p)
            current = p
            subpathStart = p
        case UInt8(ascii: "l"):
            guard let p = point(relative) else { return false }
            path.addLine(to: p)
            current = p
        case UInt8(ascii: "h"):
            guard let x = number() else { return false }
            let p = CGPoint(x: relative ? current.x + x : x, y: current.y)
            path.addLine(to: p)
            current = p
        case UInt8(ascii: "v"):
            guard let y = number() else { return false }
            let p = CGPoint(x: current.x, y: relative ? current.y + y : y)
            path.addLine(to: p)
            current = p
        case UInt8(ascii: "c"):
            guard let c1 = point(relative), let c2 = point(relative), let p = point(relative) else { return false }
            path.addCurve(to: p, control1: c1, control2: c2)
            lastCubic = c2
            keepCubic = true
            current = p
        case UInt8(ascii: "s"):
            let c1 = lastCubic.map { CGPoint(x: 2 * current.x - $0.x, y: 2 * current.y - $0.y) } ?? current
            guard let c2 = point(relative), let p = point(relative) else { return false }
            path.addCurve(to: p, control1: c1, control2: c2)
            lastCubic = c2
            keepCubic = true
            current = p
        case UInt8(ascii: "q"):
            guard let c = point(relative), let p = point(relative) else { return false }
            path.addQuadCurve(to: p, control: c)
            lastQuad = c
            keepQuad = true
            current = p
        case UInt8(ascii: "t"):
            let c = lastQuad.map { CGPoint(x: 2 * current.x - $0.x, y: 2 * current.y - $0.y) } ?? current
            guard let p = point(relative) else { return false }
            path.addQuadCurve(to: p, control: c)
            lastQuad = c
            keepQuad = true
            current = p
        case UInt8(ascii: "a"):
            guard let rx = number(), let ry = number(), let rotation = number(),
                  let large = number(), let sweep = number(), let p = point(relative) else { return false }
            arc(to: p, rx: rx, ry: ry, rotation: rotation, large: large != 0, sweep: sweep != 0)
            current = p
        case UInt8(ascii: "z"):
            path.closeSubpath()
            current = subpathStart
        default:
            return false
        }
        if !keepCubic { lastCubic = nil }
        if !keepQuad { lastQuad = nil }
        return true
    }

    /// SVG endpoint arc to centre parameterisation (SVG spec F.6.5).
    private mutating func arc(to end: CGPoint, rx rx0: Double, ry ry0: Double, rotation: Double, large: Bool, sweep: Bool) {
        let start = current
        guard start != end else { return }
        var rx = abs(rx0), ry = abs(ry0)
        guard rx > 0, ry > 0 else {
            path.addLine(to: end)
            return
        }
        let phi = rotation * .pi / 180
        let cosP = cos(phi), sinP = sin(phi)
        let dx = (start.x - end.x) / 2, dy = (start.y - end.y) / 2
        let x1 = cosP * dx + sinP * dy
        let y1 = -sinP * dx + cosP * dy
        let lambda = (x1 * x1) / (rx * rx) + (y1 * y1) / (ry * ry)
        if lambda > 1 {
            rx *= lambda.squareRoot()
            ry *= lambda.squareRoot()
        }
        let num = rx * rx * ry * ry - rx * rx * y1 * y1 - ry * ry * x1 * x1
        let den = rx * rx * y1 * y1 + ry * ry * x1 * x1
        var coef = den == 0 ? 0 : max(0, num / den).squareRoot()
        if large == sweep { coef = -coef }
        let cxp = coef * rx * y1 / ry
        let cyp = -coef * ry * x1 / rx
        let cx = cosP * cxp - sinP * cyp + (start.x + end.x) / 2
        let cy = sinP * cxp + cosP * cyp + (start.y + end.y) / 2
        func angle(_ ux: Double, _ uy: Double, _ vx: Double, _ vy: Double) -> Double {
            atan2(ux * vy - uy * vx, ux * vx + uy * vy)
        }
        let ux = (x1 - cxp) / rx, uy = (y1 - cyp) / ry
        let vx = (-x1 - cxp) / rx, vy = (-y1 - cyp) / ry
        let theta = angle(1, 0, ux, uy)
        var delta = angle(ux, uy, vx, vy)
        if !sweep && delta > 0 { delta -= 2 * .pi }
        if sweep && delta < 0 { delta += 2 * .pi }
        let transform = CGAffineTransform(translationX: cx, y: cy).rotated(by: phi).scaledBy(x: rx, y: ry)
        path.addRelativeArc(center: .zero, radius: 1, startAngle: .radians(theta), delta: .radians(delta), transform: transform)
    }
}
