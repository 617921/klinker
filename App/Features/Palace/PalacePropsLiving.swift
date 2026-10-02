import SwiftUI

/// Props for the home, café and office (and any place that needs papers, phones or people
/// holding things). This file routes each kind and draws the paper things.
enum PalaceLivingProps {
    static func draw(_ kind: PalacePropKind, _ pen: PropPen, _ p: PalacePropParams) {
        switch kind {
        case .paperSheet: paperSheet(pen, p)
        case .envelope: envelope(pen, p)
        case .smartphone: PalacePhone.draw(pen, p)
        case .wallCalendar: wallCalendar(pen, p)
        case .personHolding: PalacePeople.holding(pen, p)
        case .ceilingLeak: PalaceHomeProps.ceilingLeak(pen, p)
        case .movingBoxes: PalaceHomeProps.movingBoxes(pen, p)
        case .vacuum: PalaceHomeProps.vacuum(pen, p)
        case .furnitureSet: PalaceHomeProps.furnitureSet(pen, p)
        case .floorPlan: PalaceHomeProps.floorPlan(pen, p)
        case .loudSpeaker: PalaceHomeSound.loudSpeaker(pen, p)
        case .thinWall: PalaceHomeSound.thinWall(pen, p)
        case .terraceView: PalaceCafeProps.terraceView(pen, p)
        case .tipJar: PalaceCafeProps.tipJar(pen, p)
        case .bottleAndGlass: PalaceCafeProps.bottleAndGlass(pen, p)
        case .drinkGlass: PalaceCafeProps.drinkGlass(pen, p)
        case .snackTable: PalaceCafeTables.snackTable(pen, p)
        case .gramophone: PalaceCafeProps.gramophone(pen, p)
        case .candleTable: PalaceCafeTables.candleTable(pen, p)
        case .payTerminal: PalaceCafeProps.payTerminal(pen, p)
        case .meetingTable: PalaceOfficeProps.meetingTable(pen, p)
        case .orgChart: PalaceOfficeProps.orgChart(pen, p)
        case .taskBoard: PalaceOfficeProps.taskBoard(pen, p)
        case .handIn: PalaceOfficeProps.handIn(pen, p)
        case .hourglass: PalaceOfficeProps.hourglass(pen, p)
        default: break
        }
    }

    /// Header colours for papers and tags.
    static func tone(_ name: String?) -> UInt32 {
        switch name {
        case "green": 0x0F6E56
        case "red": 0xC8261B
        case "orange": 0xF2711C
        case "purple": 0x3C3489
        case "brown": 0x7A5230
        default: 0x1F3A6B
        }
    }

    // MARK: Paper sheet

    /// A sheet: a coloured header with pictograms, a big amount, a caption, filled-in fields.
    static func paperSheet(_ pen: PropPen, _ p: PalacePropParams) {
        let (w, h) = (pen.size.width, pen.size.height)
        let pinned = p.mount == "wall"
        let clipboard = p.mount == "clipboard"
        var sheet = CGRect(x: 2, y: pinned ? 5 : 2, width: w - 5, height: h - (pinned ? 8 : 5))
        if clipboard {
            let board = CGRect(x: 1, y: 3, width: w - 3, height: h - 4)
            pen.rect(board.offsetBy(dx: 1.5, dy: 2), 0x1E1E1C, radius: 3, 0.16)
            pen.rect(board, 0x8C5E38, radius: 3)
            sheet = board.insetBy(dx: 3.5, dy: 3.5)
            sheet.origin.y += 5
            sheet.size.height -= 5
        } else {
            pen.rect(sheet.offsetBy(dx: 1.5, dy: 2), 0x1E1E1C, radius: 1.5, 0.15)
        }
        pen.rect(sheet, 0xFFFDF6, radius: 1.5)
        if clipboard {
            pen.rect(sheet.midX - 10, 0, 20, 9, 0x8A8A82, radius: 2)
            pen.rect(sheet.midX - 7, 1.5, 14, 4, 0xB4B2A9, radius: 1.5)
        }
        pen.svg("M\(sheet.maxX - 7) \(sheet.minY)H\(sheet.maxX)V\(sheet.minY + 7)Z", 0xE2DED3)
        let inner = sheet.insetBy(dx: 4, dy: 4)
        var y = inner.minY
        let icons = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:))
        // variant 1: the pictogram is the big picture of the sheet, not a header mark.
        let bigPicture = p.variant == 1 && !icons.isEmpty && p.text == nil
        if !bigPicture, !icons.isEmpty || p.tone != nil {
            let colour = tone(p.tone)
            let band = CGRect(x: inner.minX, y: y, width: inner.width - 4, height: min(18, max(12, inner.height * 0.3)))
            pen.rect(band, colour, radius: 1.5)
            let side = band.height - 3
            var x = band.minX + 2
            for icon in icons {
                icon.draw(pen, in: CGRect(x: x, y: band.minY + 1.5, width: side, height: side), color: 0xFFFDF6, detail: colour)
                x += side + 2
            }
            if x < band.maxX - 10 {
                pen.line(x + 2, band.midY - 2, band.maxX - 4, band.midY - 2, 0xFFFDF6, 1.5)
                pen.line(x + 2, band.midY + 2.5, band.maxX - 12, band.midY + 2.5, 0xFFFDF6, 1.5)
            }
            y = band.maxY + 3
        }
        let fields = p.lines ?? []
        let signature = p.accessory == "signature"
        let below = CGFloat(fields.count) * 17 + (signature ? 13 : 0) + (p.caption != nil ? 11 : 0)
        if bigPicture, let icon = icons.first {
            let side = min(inner.width * 0.8, max(14, inner.maxY - y - below - 2))
            icon.draw(pen, in: CGRect(x: inner.midX - side / 2, y: y + 1, width: side, height: side), color: tone(p.tone), detail: 0xFFFDF6)
            y += side + 3
        }
        let room = max(0, inner.maxY - y - below)
        if let text = p.text {
            pen.text(text, PropFont.heavy(max(9, min(room * 0.9, 22))), 0x1E1E1C,
                     at: CGPoint(x: inner.midX, y: y + room / 2 + 1), maxWidth: inner.width)
        } else if room > 6 {
            var ly = y + 3
            while ly < y + room - 1 {
                pen.line(inner.minX + 1, ly, inner.maxX - (ly == y + 3 ? 6 : 1), ly, 0xD3D1C7, 1.3)
                ly += 4.5
            }
        }
        y += room
        if let caption = p.caption {
            pen.text(caption, PropFont.demi(9), 0x5F5E5A, at: CGPoint(x: inner.midX, y: y + 5), maxWidth: inner.width)
            y += 11
        }
        var penTip: CGPoint?
        for field in fields {
            // A small printed label, then the handwritten value on its line.
            let cells = field.split(separator: "|", omittingEmptySubsequences: false).map(String.init)
            pen.text(cells.first ?? "", PropFont.mono(6.5), 0x5F5E5A, at: CGPoint(x: inner.minX, y: y + 3), anchor: .leading)
            pen.line(inner.minX, y + 15, inner.maxX, y + 15, 0xB4B2A9, 1)
            if cells.count > 1 {
                let font = PropFont.demi(9.5)
                let x = inner.minX + 1
                let natural = pen.width(of: cells[1], font)
                pen.text(cells[1], font, 0x2F5BD3, at: CGPoint(x: x, y: y + 10.5), anchor: .leading, maxWidth: inner.maxX - x)
                penTip = CGPoint(x: min(inner.maxX, x + natural + 1), y: y + 13.5)
            }
            y += 17
        }
        if signature {
            let mid = inner.midX
            pen.line(inner.minX, y + 10, mid - 3, y + 10, 0x1E1E1C, 1)
            pen.line(mid + 3, y + 10, inner.maxX, y + 10, 0x1E1E1C, 1)
            pen.svgLine("M\(inner.minX + 2) \(y + 8)C\(inner.minX + 6) \(y + 1) \(inner.minX + 8) \(y + 11) \(inner.minX + 12) \(y + 5)C\(inner.minX + 15) \(y + 1) \(inner.minX + 16) \(y + 9) \(mid - 6) \(y + 6)",
                        0x2F5BD3, 1.3)
            pen.svgLine("M\(mid + 5) \(y + 9)C\(mid + 9) \(y + 2) \(mid + 11) \(y + 11) \(mid + 15) \(y + 5)C\(mid + 18) \(y + 2) \(mid + 20) \(y + 9) \(inner.maxX - 3) \(y + 6)",
                        0xC8261B, 1.3)
        }
        if p.accessory == "pen", let tip = penTip { writingPen(pen, tip: tip) }
        if pinned {
            pen.dot(sheet.midX, sheet.minY + 1.5, 3, 0xC8261B)
            pen.dot(sheet.midX - 0.8, sheet.minY + 0.7, 1, 0xFFFFFF, 0.7)
        }
    }

    /// A pen whose tip rests at `tip`, slanting up to the right.
    static func writingPen(_ pen: PropPen, tip: CGPoint) {
        let (x, y) = (tip.x, tip.y)
        pen.line(x + 1.5, y - 1.5, x + 15, y - 15, 0x1E1E1C, 3.4)
        pen.line(x + 12, y - 12, x + 16, y - 16, 0x2F5BD3, 4)
        pen.line(x, y, x + 2, y - 2, 0xC9A15B, 1.6)
        pen.svgLine("M\(x - 9) \(y + 1)Q\(x - 6) \(y - 2) \(x - 4) \(y + 1)T\(x) \(y)", 0x2F5BD3, 1.1)
    }

    // MARK: Envelope

    /// The front of an envelope: the sender's mark large on the left, the address, a stamp.
    static func envelope(_ pen: PropPen, _ p: PalacePropParams) {
        let (w, h) = (pen.size.width, pen.size.height)
        let body = CGRect(x: 2, y: 3, width: w - 5, height: h - 6)
        pen.rect(body.offsetBy(dx: 1.5, dy: 2), 0x1E1E1C, radius: 2, 0.16)
        pen.rect(body, 0xF6F3EA, radius: 2)
        pen.svgLine("M\(body.minX + 1) \(body.maxY - 1)L\(body.midX) \(body.midY + 2)L\(body.maxX - 1) \(body.maxY - 1)", 0xE2DED3, 1.2)
        let side = min(body.height - 7, body.width * 0.46)
        if let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first {
            let box = CGRect(x: body.minX + 4, y: body.minY + 3.5, width: side, height: side)
            pen.rect(box, tone(p.tone), radius: 2)
            icon.draw(pen, in: box.insetBy(dx: 2, dy: 2), color: 0xFFFDF6, detail: tone(p.tone))
        }
        let stamp = CGRect(x: body.maxX - 13, y: body.minY + 4, width: 9, height: 11)
        pen.rect(stamp, 0xFFFDF6)
        pen.rect(stamp.insetBy(dx: 1.2, dy: 1.2), 0xF2711C)
        let left = body.minX + side + 9
        var y = body.maxY - 4 - CGFloat(max(1, (p.lines ?? []).count)) * 9
        for line in p.lines ?? ["", ""] {
            if line.isEmpty {
                pen.line(left, y + 4, body.maxX - 6, y + 4, 0xB4B2A9, 2)
            } else {
                pen.text(line, PropFont.mono(8), 0x1E1E1C, at: CGPoint(x: left, y: y + 4), anchor: .leading, maxWidth: body.maxX - 4 - left)
            }
            y += 9
        }
    }

    // MARK: Wall calendar

    /// A month on the wall; one week row (`highlight`) is filled in orange with a picture.
    static func wallCalendar(_ pen: PropPen, _ p: PalacePropParams) {
        let f = pen.fitted(CGSize(width: 64, height: 70))
        f.dot(32, 2.5, 1.8, 0x2E2117)
        f.svgLine("M32 3L20 9M32 3L44 9", 0x5F5E5A, 0.8)
        f.rect(5.5, 9.5, 54, 60, 0x1E1E1C, radius: 2, 0.15)
        f.rect(4, 8, 54, 60, 0xFFFDF6, radius: 2)
        f.rect(4, 8, 54, 14, 0xC8261B, radius: 2)
        f.rect(4, 18, 54, 4, 0xC8261B)
        f.text(p.caption ?? "", PropFont.heavy(9), 0xFFFDF6, at: CGPoint(x: 31, y: 15.5), maxWidth: 46)
        f.rect(15, 6, 2.4, 6, 0x2E2117, radius: 1.2)
        f.rect(44.6, 6, 2.4, 6, 0x2E2117, radius: 1.2)
        let rows = 5, top: CGFloat = 25, rowH: CGFloat = 8.4
        for r in 0..<rows {
            let y = top + CGFloat(r) * rowH
            if r == p.highlight {
                f.rect(6, y - 1, 50, rowH + 0.4, 0xFAC775, radius: 1.5)
                if let icon = (p.icons ?? []).compactMap(PalaceIcon.init(rawValue:)).first {
                    icon.draw(f, in: CGRect(x: 21, y: y - 4.5, width: 14, height: 14), color: 0xF2711C, detail: 0xFAC775)
                }
                f.svgLine("M38 \(y + 4)q2.5 -2.4 5 0t5 0t5 0", 0x2F5BD3, 1.2)
                f.svgLine("M8 \(y + 3)l3 3M11 \(y + 3)l-3 3M13 \(y + 3)l3 3M16 \(y + 3)l-3 3", 0xA3410A, 0.9)
            } else {
                for c in 0..<7 { f.rect(7.5 + CGFloat(c) * 7, y, 4.6, 4.6, 0xD3D1C7, radius: 0.6) }
            }
        }
    }
}
