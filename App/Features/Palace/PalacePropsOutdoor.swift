import SwiftUI

/// Draws the outdoor props (market, park, tram stop), so `PalacePropView` needs one line for them.
enum PalaceOutdoorProps {
    static func draw(_ kind: PalacePropKind, _ pen: PropPen, _ p: PalacePropParams) {
        switch kind {
        case .stall: PalaceMarketProps.stall(pen, p)
        case .scale: PalaceMarketProps.scale(pen, p)
        case .seasonWheel: PalaceMarketProps.seasonWheel(pen, p)
        case .rosette: PalaceMarketProps.rosette(pen, p)
        case .punnet: PalaceTradeProps.punnet(pen, p)
        case .ripeness: PalaceTradeProps.ripeness(pen, p)
        case .pickCrate: PalaceTradeProps.pickCrate(pen, p)
        case .cashBox: PalaceTradeProps.cashBox(pen, p)
        case .handover: PalaceTradeProps.handover(pen, p)
        case .haggle: PalaceTradeProps.haggle(pen, p)
        case .duckPond: PalaceParkProps.duckPond(pen, p)
        case .bench: PalaceParkProps.bench(pen, p)
        case .lawn: PalaceParkProps.lawn(pen, p)
        case .playground: PalaceParkProps.playground(pen, p)
        case .stage: PalaceParkProps.stage(pen, p)
        case .litter: PalaceParkProps.litter(pen, p)
        case .roadSign: PalaceParkProps.roadSign(pen, p)
        case .runner: PalaceParkPeople.runner(pen, p)
        case .dogWalker: PalaceParkPeople.dogWalker(pen, p)
        case .strollers: PalaceParkPeople.strollers(pen, p)
        case .lineDisplay: PalaceTramProps.lineDisplay(pen, p)
        case .tramDoor: PalaceTramProps.tramDoor(pen, p)
        case .bufferStop: PalaceTramProps.bufferStop(pen, p)
        case .punctual: PalaceTramProps.punctual(pen, p)
        case .roadworks: PalaceStreetProps.roadworks(pen, p)
        case .timetable: PalaceStreetProps.timetable(pen, p)
        case .ticketMachine: PalaceStreetProps.ticketMachine(pen, p)
        case .cardReader: PalaceStreetProps.cardReader(pen, p)
        case .uniform: PalaceStreetProps.uniform(pen, p)
        default: break
        }
    }
}

/// Pictograms of the outdoor places (market, park, tram stop), in the same 24 × 24 box as
/// `PalaceIcon`. A few keep fixed colours because the colour is the meaning: the green banknote,
/// the red slash of "no card" and the green disc of "allowed".
enum PalaceOutdoorIcons {
    static func draw(_ icon: PalaceIcon, _ p: PropPen, _ c: UInt32, _ d: UInt32) {
        switch icon {
        case .banknote:
            p.rect(4, 3, 19.5, 12, 0x4E7A3A, radius: 1.5)
            p.rect(0.5, 7.5, 20.5, 13, 0x5E8C45, radius: 1.5)
            p.stroke(Path(roundedRect: CGRect(x: 2.2, y: 9.2, width: 17.1, height: 9.6), cornerRadius: 1), 0xD5E3C3, 0.9)
            p.dot(10.75, 14, 4.4, 0xD5E3C3)
            p.text("€", PropFont.heavy(8), 0x3F5A4A, at: CGPoint(x: 10.6, y: 14.2))
        case .noCard:
            p.rect(2, 6, 20, 13, c, radius: 2)
            p.rect(2, 9, 20, 2.6, d)
            p.rect(4.5, 14, 6, 2, d, radius: 0.5)
            p.line(3.5, 21.5, 20.5, 2.5, d, 5)
            p.line(3.5, 21.5, 20.5, 2.5, 0xC8261B, 2.8)
        case .tram:
            p.svgLine("M8.5 3.5L12 0.8L15.5 3.5", c, 1.3)
            p.svg("M6.5 3.5H17.5Q21 3.5 21 7V19.5H3V7Q3 3.5 6.5 3.5Z", c)
            p.rect(5.2, 6.2, 13.6, 6.4, d, radius: 1.2)
            p.dot(7, 16, 1.4, d)
            p.dot(17, 16, 1.4, d)
            p.svgLine("M6 20.5L4.5 23M18 20.5L19.5 23", c, 1.6)
        case .detour:
            p.rect(2.5, 1.5, 9, 4, 0xC8261B, radius: 0.6)
            p.svg("M5 1.5H7.5L5.5 5.5H3Z M9.5 1.5H11.5L9.5 5.5H7.5Z", 0xFFFDF6)
            p.svgLine("M7 22.5V14Q7 9 12 9H17", c, 3.2)
            p.svg("M16 4.2L22.5 9L16 13.8Z", c)
        case .wheelchair:
            p.dot(11.5, 3.4, 2.3, c)
            p.svgLine("M11 6.8L10.4 13.2H16.2L18.6 19.4", c, 2.4)
            p.svgLine("M10.8 9.6H15.4", c, 2)
            var wheel = Path()
            wheel.addArc(center: CGPoint(x: 10, y: 16.4), radius: 5.6, startAngle: .degrees(-100), endAngle: .degrees(-10), clockwise: true)
            p.stroke(wheel, c, 2)
        case .dogLeash:
            p.svgLine("M7.5 12Q12 3.5 19.2 3.6", c, 1.3)
            p.dot(20.4, 3.4, 2, c)
            p.rect(6, 12.5, 12.5, 5.6, c, radius: 2.6)
            p.dot(5.6, 11.4, 3.1, c)
            p.rect(1.2, 11.2, 4, 2.8, c, radius: 1.2)
            p.svg("M4.6 8.2L8 9L7 12.4Z", c)
            p.svgLine("M7.8 17L7.4 22.5M10.4 17.5V22.5M14.6 17.5L15 22.5M17 17L17.6 22.5", c, 1.7)
            p.svgLine("M18.2 13.6L21.6 9.6", c, 1.6)
            p.dot(6.4, 10.8, 0.7, d)
        case .bike:
            p.ring(5.6, 16, 4.6, c, 1.8)
            p.ring(18.4, 16, 4.6, c, 1.8)
            p.svgLine("M5.6 16L10 8.8H16.8L18.4 16M10 8.8L12.2 16H5.6M16.8 8.8L12.2 16M8.4 7H11.6M16.8 8.8L16 6.2H18.6", c, 1.6)
        case .allowed:
            p.dot(12, 12, 10.5, 0x1E7A4C)
            p.svgLine("M6.8 12.4L10.4 16L17.4 8.4", 0xFFFFFF, 2.8)
        default:
            break
        }
    }
}
