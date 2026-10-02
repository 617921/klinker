import SwiftUI
enum G5Tools { static func tool(_ pen: PropPen, _ p: PalacePropParams) {}; static func sturdy(_ pen: PropPen, _ p: PalacePropParams) {} }
enum G5People { static func fan(_ pen: PropPen, _ p: PalacePropParams) {}; static func seats(_ pen: PropPen, _ p: PalacePropParams) {} }
enum G5Makers { static func maker(_ pen: PropPen, _ p: PalacePropParams) {} }
enum G5Groups { static func group(_ pen: PropPen, _ p: PalacePropParams) {}; static func couple(_ pen: PropPen, _ p: PalacePropParams) {} }
enum G5Stage { static func poster(_ pen: PropPen, _ p: PalacePropParams) {}; static func print(_ pen: PropPen, _ p: PalacePropParams) {}; static func cloakroom(_ pen: PropPen, _ p: PalacePropParams) {}; static func screen(_ pen: PropPen, _ p: PalacePropParams) {}; static func emblem(_ pen: PropPen, _ p: PalacePropParams) {} }
enum G5Art { static func banner(_ pen: PropPen, _ p: PalacePropParams) {}; static func frame(_ pen: PropPen, _ p: PalacePropParams) {}; static func statue(_ pen: PropPen, _ p: PalacePropParams) {} }
enum G5ChurchProps { static func datePage(_ pen: PropPen, _ p: PalacePropParams) {}; static func memorial(_ pen: PropPen, _ p: PalacePropParams) {}; static func candles(_ pen: PropPen, _ p: PalacePropParams) {}; static func coffin(_ pen: PropPen, _ p: PalacePropParams) {}; static func cake(_ pen: PropPen, _ p: PalacePropParams) {} }
enum G5Hall { static let noor = CGPoint(x: 200, y: 290); nonisolated static let slots: [String: PalaceSlot] = [:] }
enum G5Museum { static let noor = CGPoint(x: 200, y: 290); nonisolated static let slots: [String: PalaceSlot] = [:] }
enum G5Church { static let noor = CGPoint(x: 200, y: 290); nonisolated static let slots: [String: PalaceSlot] = [:] }
struct G5HallBackdrop: View { let theater: Bool; var body: some View { Color.gray } }
struct G5MuseumBackdrop: View { var body: some View { Color.gray } }
struct G5ChurchBackdrop: View { var body: some View { Color.gray } }
