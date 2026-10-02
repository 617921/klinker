import SwiftUI
enum G5Art { static func banner(_ pen: PropPen, _ p: PalacePropParams) {}; static func frame(_ pen: PropPen, _ p: PalacePropParams) {}; static func statue(_ pen: PropPen, _ p: PalacePropParams) {} }
enum G5Museum { static let noor = CGPoint(x: 200, y: 290); nonisolated static let slots: [String: PalaceSlot] = [:] }
enum G5Church { static let noor = CGPoint(x: 200, y: 290); nonisolated static let slots: [String: PalaceSlot] = [:] }
struct G5MuseumBackdrop: View { var body: some View { Color.gray } }
struct G5ChurchBackdrop: View { var body: some View { Color.gray } }
