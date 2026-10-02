import SwiftUI

/// Props of the offices and paperwork places (tax office, notary, insurer, energy company, studio,
/// startup). This file routes each kind and draws the two most reusable ones: money going from
/// one party to another, and a letter or bill.
enum G2Props {
    static func draw(_ kind: PalacePropKind, _ pen: PropPen, _ p: PalacePropParams) {
        switch kind {
        case .g2MoneyFlow: moneyFlow(pen, p)
        case .g2Bill: bill(pen, p)
        case .g2TaxReturn: G2TaxProps.taxReturn(pen, p)
        case .g2TopUp: G2TaxProps.topUp(pen, p)
        case .g2Refund: G2TaxProps.refund(pen, p)
        case .g2Gross: G2TaxProps.gross(pen, p)
        case .g2Laptop: G2Screens.laptop(pen, p)
        case .g2Person: G2People.person(pen, p)
        case .g2Shelter: G2InsuranceProps.shelter(pen, p)
        case .g2Tagged: G2InsuranceProps.tagged(pen, p)
        case .g2Damage: G2InsuranceProps.damage(pen, p)
        case .g2HouseContents: G2InsuranceProps.houseContents(pen, p)
        case .g2SmallPrint: G2PolicyProps.smallPrint(pen, p)
        case .g2Handshake: G2PolicyProps.handshake(pen, p)
        case .g2AddOn: G2PolicyProps.addOn(pen, p)
        case .g2Liable: G2PolicyProps.liable(pen, p)
        case .g2Meter: G2EnergyProps.meter(pen, p)
        case .g2Instalments: G2EnergyProps.instalments(pen, p)
        case .g2Chart: G2EnergyProps.chart(pen, p)
        case .g2Supply: G2EnergyProps.supply(pen, p)
        case .g2Thermostat: G2EnergyHomeProps.thermostat(pen, p)
        case .g2EnergyLabel: G2EnergyHomeProps.energyLabel(pen, p)
        case .g2SolarPanel: G2EnergyHomeProps.solarPanel(pen, p)
        case .g2Scroll: G2NotaryProps.scroll(pen, p)
        case .g2Deed: G2NotaryProps.deed(pen, p)
        case .g2Signing: G2NotaryProps.signing(pen, p)
        case .g2LawBook: G2NotaryProps.lawBook(pen, p)
        case .g2Record: G2NotaryProps.record(pen, p)
        case .g2Heirlooms: G2FamilyProps.heirlooms(pen, p)
        case .g2FamilyTree: G2FamilyProps.familyTree(pen, p)
        case .g2Inherit: G2FamilyProps.inherit(pen, p)
        case .g2Together: G2Pairs.together(pen, p)
        case .g2Proxy: G2Pairs.proxy(pen, p)
        case .g2Talk: G2Pairs.talk(pen, p)
        case .g2NewsDesk: G2StudioProps.newsDesk(pen, p)
        case .g2Broadcast: G2StudioProps.broadcast(pen, p)
        case .g2Viewer: G2StudioProps.viewer(pen, p)
        case .g2FilmStrip: G2StudioProps.filmStrip(pen, p)
        case .g2IdeaBoard: G2StudioProps.ideaBoard(pen, p)
        default: break
        }
    }

    static let coin: UInt32 = 0xE8B32C

    // MARK: Money flow

    /// A card on the wall (100 × 80): money (a banknote on an arrow) goes from the first of `icons`
    /// to the second, each in a disc. `tone` colours the arrow and the amount tag (`text`):
    /// "green" money coming to you, "red" money going out. `caption` under the tag.
    static func moneyFlow(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 100, height: 80))
        let tone = PropColor.named(p.tone, 0x1E7A4C)
        f.rect(1.5, 3, 98, 77, 0x1E1E1C, radius: 4, 0.14)
        f.rect(0, 0, 98, 76, 0xFFFDF6, radius: 4)
        let icons = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:))
        for (i, cx) in ([19, 79] as [CGFloat]).enumerated() {
            f.dot(cx, 25, 17, 0xE2DED3)
            f.dot(cx, 25, 15, 0xF4F1EA)
            if i < icons.count {
                icons[i].draw(f, in: CGRect(x: cx - 11, y: 14, width: 22, height: 22), color: 0x1F3A6B, detail: 0xF4F1EA)
            }
        }
        f.svgLine("M38 30H58", tone, 3.6)
        f.svgLine("M53 23.5L60.5 30L53 36.5", tone, 3.6)
        PalaceIcon.banknote.draw(f, in: CGRect(x: 38, y: 5, width: 20, height: 20), color: tone, detail: 0xFFFDF6)
        if let text = p.text {
            let font = PropFont.heavy(12)
            let w = min(90, f.width(of: text, font) + 12)
            f.rect(49 - w / 2, 43, w, 18, tone, radius: 4)
            f.text(text, font, 0xFFFFFF, at: CGPoint(x: 49, y: 52.5), maxWidth: w - 6)
        }
        if let caption = p.caption {
            f.text(caption, PropFont.demi(9.5), 0x5F5E5A, at: CGPoint(x: 49, y: 69), maxWidth: 90)
        }
    }

    // MARK: Bill

    /// A letter (72 × 86) with a `tone` header (a small `icons` mark in it), the amount `text` big,
    /// a `caption`. `accessory`: "envelope" (half out of an envelope in the `tone` colour),
    /// "objection" (the amount struck out in red, the `caption` written in red, a signature),
    /// "draft" (a dashed sheet with the amount in pencil, a question mark, a pencil and an eraser),
    /// otherwise pinned to the wall.
    static func bill(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 72, height: 86))
        let tone = PropColor.named(p.tone, 0x1F3A6B)
        let kind = p.accessory ?? "pinned"
        let paper = switch kind {
        case "envelope": CGRect(x: 12, y: 2, width: 48, height: 60)
        case "draft": CGRect(x: 6, y: 6, width: 58, height: 70)
        default: CGRect(x: 8, y: 5, width: 56, height: 76)
        }
        if kind == "envelope" {
            f.rect(4, 38, 64, 44, PalaceInk.shade(tone, 0.7), radius: 2)
        }
        if kind == "draft" {
            f.rect(paper, 0xFFFDF6, radius: 1)
            var border = Path(roundedRect: paper, cornerRadius: 1)
            border = border.strokedPath(StrokeStyle(lineWidth: 1.6, dash: [4, 3]))
            f.fill(border, 0x8A8A82)
        } else {
            f.rect(paper.offsetBy(dx: 1.5, dy: 2), 0x1E1E1C, radius: 1, 0.15)
            f.rect(paper, 0xFFFDF6, radius: 1)
        }
        var y = paper.minY + 4
        if kind == "objection" {
            // Handwritten greeting lines in blue ink.
            for k in 0..<2 {
                let ly = y + 3 + CGFloat(k) * 6
                f.svgLine("M\(paper.minX + 5) \(ly)q2 -2.4 4 0t4 0t4 0t4 0t4 0\(k == 0 ? "t4 0t4 0" : "")", 0x2F5BD3, 1.1)
            }
            y += 14
        } else if kind != "draft" {
            f.rect(paper.minX, paper.minY, paper.width, 13, tone, radius: 1)
            if let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first {
                icon.draw(f, in: CGRect(x: paper.minX + 3, y: paper.minY + 2, width: 9, height: 9), color: 0xFFFDF6, detail: tone)
            }
            f.line(paper.minX + 16, paper.minY + 5, paper.maxX - 5, paper.minY + 5, 0xFFFDF6, 1.4)
            f.line(paper.minX + 16, paper.minY + 8.5, paper.maxX - 12, paper.minY + 8.5, 0xFFFDF6, 1.4)
            y = paper.minY + 17
        }
        if kind == "draft", let caption = p.caption {
            f.text(caption, PropFont.demi(8), 0x8A8A82, at: CGPoint(x: paper.midX, y: y + 4), maxWidth: paper.width - 6)
            y += 10
        }
        if kind != "objection", kind != "draft", let caption = p.caption {
            f.text(caption, PropFont.demi(8.5), 0x5F5E5A, at: CGPoint(x: paper.midX, y: y + 4), maxWidth: paper.width - 6)
            y += 10
        }
        if let text = p.text {
            let ink: UInt32 = kind == "draft" ? 0x8A8A82 : 0x1E1E1C
            let font = kind == "draft" ? PropFont.demi(14) : PropFont.heavy(13)
            let shift: CGFloat = kind == "draft" ? 7 : 0
            f.text(text, font, ink, at: CGPoint(x: paper.midX - shift, y: y + 8), maxWidth: paper.width - 6 - 2 * shift)
            if kind == "objection" {
                let w = min(paper.width - 6, f.width(of: text, font))
                f.line(paper.midX - w / 2 - 2, y + 9, paper.midX + w / 2 + 2, y + 6, 0xC8261B, 2.4)
            }
            y += 18
        }
        switch kind {
        case "objection":
            if let caption = p.caption {
                f.text(caption, PropFont.heavy(11), 0xC8261B, at: CGPoint(x: paper.midX, y: y + 6), maxWidth: paper.width - 4)
            }
            f.svgLine("M\(paper.minX + 8) \(paper.maxY - 9)C\(paper.minX + 12) \(paper.maxY - 16) \(paper.minX + 14) \(paper.maxY - 5) \(paper.minX + 18) \(paper.maxY - 11)C\(paper.minX + 21) \(paper.maxY - 15) \(paper.minX + 23) \(paper.maxY - 7) \(paper.minX + 30) \(paper.maxY - 10)", 0x2F5BD3, 1.3)
            f.line(paper.minX + 6, paper.maxY - 5, paper.minX + 34, paper.maxY - 5, 0xB4B2A9, 1)
            f.dot(paper.maxX - 9, paper.maxY - 11, 7, 0xC8261B)
            f.text("!", PropFont.heavy(12), 0xFFFFFF, at: CGPoint(x: paper.maxX - 9, y: paper.maxY - 10.5))
        case "draft":
            f.text("?", PropFont.heavy(18), 0xF2711C, at: CGPoint(x: paper.maxX - 7, y: y - 10))
            for k in 0..<2 {
                let ly = y + 4 + CGFloat(k) * 6
                f.line(paper.minX + 6, ly, paper.maxX - (k == 1 ? 22 : 8), ly, 0xD3D1C7, 1.3)
            }
            // A pencil lying across the corner, an eraser beside it.
            f.svg("M32 78L60 60L64 66L36 84Z", 0xF2B33D)
            f.svg("M60 60L68 55L64 66Z", 0xE9D3AE)
            f.svg("M66.5 56L68 55L67 58Z", 0x3E4C55)
            f.svg("M28 80.5L32 78L36 84L32 86.5Z", 0xF4C0D1)
            f.rect(6, 74, 20, 9, 0xF4C0D1, radius: 2)
            f.rect(6, 74, 8, 9, 0x2F5BD3, radius: 2)
        case "envelope":
            for k in 0..<2 {
                let ly = y + CGFloat(k) * 5
                if ly < 40 { f.line(paper.minX + 5, ly, paper.maxX - (k == 1 ? 14 : 5), ly, 0xD3D1C7, 1.3) }
            }
            f.rect(4, 44, 64, 38, tone, radius: 2)
            f.svgLine("M5 45L36 64L67 45", PalaceInk.shade(tone, 0.72), 1.4)
            f.rect(12, 66, 26, 10, 0xFFFDF6, radius: 1.2, 0.9)
            f.svgLine("M15 70H33M15 73H28", 0xB4B2A9, 1)
        default:
            for k in 0..<3 {
                let ly = y + 2 + CGFloat(k) * 5
                if ly < paper.maxY - 4 { f.line(paper.minX + 5, ly, paper.maxX - (k == 2 ? 16 : 5), ly, 0xD3D1C7, 1.3) }
            }
            f.dot(paper.midX, paper.minY + 1.5, 3, 0xC8261B)
        }
    }
}
