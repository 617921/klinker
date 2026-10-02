import SwiftUI

/// Dispatch for the g1 props (bank, post office, housing office, police, temp agency, court) and
/// the small bits they share: coins, banknotes, parcels, hands, speech bubbles and little houses.
enum G1Props {
    static func draw(_ kind: PalacePropKind, _ pen: PropPen, _ p: PalacePropParams) {
        switch kind {
        case .g1Person: G1People.person(pen, p)
        case .g1Atm: G1Bank.atm(pen, p)
        case .g1PiggyBank: G1Bank.piggyBank(pen, p)
        case .g1BankCard: G1Bank.bankCard(pen, p)
        case .g1MoneyCounter: G1Bank.moneyCounter(pen, p)
        case .g1BankApp: G1BankScreens.app(pen, p)
        case .g1MonthStrip: G1BankScreens.monthStrip(pen, p)
        case .g1Loan: G1BankPosters.loan(pen, p)
        case .g1Finance: G1BankPosters.finance(pen, p)
        case .g1Growth: G1BankPosters.growth(pen, p)
        case .g1Bills: G1BankPosters.bills(pen, p)
        case .g1Parcel: G1Post.parcel(pen, p)
        case .g1PostScale: G1Post.scale(pen, p)
        case .g1Stamps: G1Post.stamps(pen, p)
        case .g1EnvelopeBack: G1Post.envelopeBack(pen, p)
        case .g1RateBoard: G1Post.rateBoard(pen, p)
        case .g1Registered: G1PostDesk.registered(pen, p)
        case .g1GiveAcross: G1PostDesk.giveAcross(pen, p)
        case .g1MailSlot: G1PostDesk.mailSlot(pen, p)
        case .g1OpenWindow: G1Housing.openWindow(pen, p)
        case .g1Mould: G1Housing.mould(pen, p)
        case .g1Repair: G1Housing.repair(pen, p)
        case .g1HomeAd: G1Housing.homeAd(pen, p)
        case .g1Objection: G1HousingDesk.objection(pen, p)
        case .g1Community: G1HousingDesk.community(pen, p)
        case .g1QueueScreen: G1HousingDesk.queueScreen(pen, p)
        case .g1BreakIn: G1Police.breakIn(pen, p)
        case .g1Megaphone: G1Police.megaphone(pen, p)
        case .g1Forbidden: G1Police.forbidden(pen, p)
        case .g1CutLock: G1Police.cutLock(pen, p)
        case .g1Cctv: G1Police.cctv(pen, p)
        case .g1Pickpocket: G1Police.pickpocket(pen, p)
        case .g1Interview: G1Jobs.interview(pen, p)
        case .g1Resume: G1Jobs.resume(pen, p)
        case .g1Timeline: G1Jobs.timeline(pen, p)
        case .g1JobBoard: G1Jobs.jobBoard(pen, p)
        case .g1TrialMonths: G1Jobs.trialMonths(pen, p)
        case .g1Apply: G1JobsDesk.apply(pen, p)
        case .g1Welcome: G1JobsDesk.welcome(pen, p)
        case .g1Puzzle: G1JobsDesk.puzzle(pen, p)
        case .g1Scales: G1Court.scales(pen, p)
        case .g1Gavel: G1Court.gavel(pen, p)
        case .g1LawBook: G1Court.lawBook(pen, p)
        case .g1Evidence: G1Court.evidence(pen, p)
        case .g1Bars: G1Court.bars(pen, p)
        case .g1CaseFile: G1Court.caseFile(pen, p)
        case .g1RedLight: G1Court.redLight(pen, p)
        default: break
        }
    }

    // MARK: Shared bits

    static let skin: UInt32 = 0xE8C4A0

    /// A euro coin of radius `r`.
    static func coin(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ r: CGFloat = 5) {
        f.dot(x, y, r, 0xC9A15B)
        f.dot(x - r * 0.08, y - r * 0.08, r * 0.8, 0xF6D27A)
        f.text("€", PropFont.heavy(r * 1.2), 0xA3410A, at: CGPoint(x: x - r * 0.06, y: y - r * 0.04))
    }

    /// A euro banknote (`w` wide) centred on (x, y), turned by `angle` radians. `hex` its colour.
    static func note(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, w: CGFloat, angle: CGFloat = 0, _ hex: UInt32 = 0xF2A65A) {
        var n = f
        n.ctx.translateBy(x: x, y: y)
        n.ctx.rotate(by: .radians(angle))
        let h = w * 0.52
        n.rect(-w / 2 + 0.8, -h / 2 + 1.2, w, h, 0x1E1E1C, radius: 1, 0.14)
        n.rect(-w / 2, -h / 2, w, h, hex, radius: 1)
        n.rect(-w / 2 + w * 0.08, -h / 2 + h * 0.14, w * 0.84, h * 0.72, PalaceInk.shade(hex, 1.12), radius: 0.8)
        n.ring(w * 0.18, 0, h * 0.24, PalaceInk.shade(hex, 0.72), max(0.8, w * 0.03))
        n.text("€", PropFont.heavy(h * 0.5), PalaceInk.shade(hex, 0.6), at: CGPoint(x: -w * 0.2, y: 0))
    }

    /// A brown parcel with tape, `rect` its front face, a top face above it.
    static func parcel(_ f: PropPen, _ r: CGRect, _ hex: UInt32 = 0xC9965F) {
        let top = r.height * 0.22
        f.svg("M\(r.minX) \(r.minY)L\(r.minX + top) \(r.minY - top)H\(r.maxX + top)L\(r.maxX) \(r.minY)Z", PalaceInk.shade(hex, 1.12))
        f.svg("M\(r.maxX) \(r.minY)L\(r.maxX + top) \(r.minY - top)V\(r.maxY - top)L\(r.maxX) \(r.maxY)Z", PalaceInk.shade(hex, 0.78))
        f.rect(r, hex)
        f.rect(r.midX - r.width * 0.06, r.minY, r.width * 0.12, r.height, 0xE2C9A0, 0.9)
        f.svg("M\(r.midX - r.width * 0.06 + top * 0.5) \(r.minY - top * 0.5)L\(r.midX - r.width * 0.06) \(r.minY)H\(r.midX + r.width * 0.06)L\(r.midX + r.width * 0.06 + top * 0.5) \(r.minY - top * 0.5)Z", 0xE2C9A0, 0.9)
    }

    /// An arm coming into the frame from `from`, its hand (a mitten with a thumb) at `to`.
    static func arm(_ f: PropPen, from: CGPoint, to: CGPoint, sleeve: UInt32, skin: UInt32 = skin, width: CGFloat = 7) {
        f.line(from.x, from.y, to.x, to.y, sleeve, width)
        f.dot(to.x, to.y, width * 0.58, skin)
    }

    /// A speech bubble with `text`, its tail pointing at `tail`.
    static func bubble(_ f: PropPen, _ r: CGRect, _ text: String, tail: CGPoint, font: Font = PropFont.demi(10), ink: UInt32 = 0x1E1E1C,
                       fill: UInt32 = 0xFFFDF6) {
        let baseX = min(max(tail.x, r.minX + 8), r.maxX - 8)
        let baseY = tail.y > r.midY ? r.maxY - 1 : r.minY + 1
        f.rect(r.offsetBy(dx: 1, dy: 1.5), 0x1E1E1C, radius: r.height / 2.4, 0.12)
        f.svg("M\(baseX - 5) \(baseY)L\(tail.x) \(tail.y)L\(baseX + 5) \(baseY)Z", fill)
        f.rect(r, fill, radius: r.height / 2.4)
        f.stroke(Path(roundedRect: r, cornerRadius: r.height / 2.4), 0xB4B2A9, 0.8)
        f.svgLine("M\(baseX - 5) \(baseY + (tail.y > r.midY ? 0.4 : -0.4))L\(tail.x) \(tail.y)L\(baseX + 5) \(baseY)", 0xB4B2A9, 0.8)
        f.svg("M\(baseX - 4.4) \(baseY + (tail.y > r.midY ? -0.8 : 0.8))H\(baseX + 4.4)", fill)
        f.text(text, font, ink, at: CGPoint(x: r.midX, y: r.midY + 0.5), maxWidth: r.width - 8)
    }

    /// A little house (`w` wide, its floor at `y`), front door and two windows.
    static func house(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, w: CGFloat, _ wall: UInt32, roof: UInt32 = 0x7A1E1E) {
        let h = w * 0.62
        f.rect(x, y - h, w, h, wall)
        f.svg("M\(x - w * 0.08) \(y - h)L\(x + w / 2) \(y - h - w * 0.42)L\(x + w * 1.08) \(y - h)Z", roof)
        f.rect(x + w * 0.4, y - h * 0.55, w * 0.2, h * 0.55, PalaceInk.shade(wall, 0.6))
        f.rect(x + w * 0.1, y - h * 0.75, w * 0.2, w * 0.18, 0xFFFDF6)
        f.rect(x + w * 0.7, y - h * 0.75, w * 0.2, w * 0.18, 0xFFFDF6)
    }

    /// A green tick in a white disc.
    static func tick(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ r: CGFloat, _ hex: UInt32 = 0x1E7A4C) {
        f.dot(x, y, r, hex)
        f.svgLine("M\(x - r * 0.45) \(y + r * 0.02)L\(x - r * 0.1) \(y + r * 0.38)L\(x + r * 0.5) \(y - r * 0.35)", 0xFFFDF6, max(1.2, r * 0.32))
    }

    /// A red cross.
    static func cross(_ f: PropPen, _ x: CGFloat, _ y: CGFloat, _ r: CGFloat, _ hex: UInt32 = 0xC8261B, width: CGFloat = 3) {
        f.svgLine("M\(x - r) \(y - r)L\(x + r) \(y + r)M\(x + r) \(y - r)L\(x - r) \(y + r)", hex, width)
    }
}
