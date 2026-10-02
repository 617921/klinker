import SwiftUI

// TEMPORARY stubs (removed as each g6 room is written).
enum G6Art {
    static func painting(_ pen: PropPen, _ p: PalacePropParams) {}; static func styles(_ pen: PropPen, _ p: PalacePropParams) {}
    static func standout(_ pen: PropPen, _ p: PalacePropParams) {}; static func choose(_ pen: PropPen, _ p: PalacePropParams) {}
}
enum G6ArtFloor {
    static func ribbon(_ pen: PropPen, _ p: PalacePropParams) {}; static func expoPoster(_ pen: PropPen, _ p: PalacePropParams) {}
    static func guestbook(_ pen: PropPen, _ p: PalacePropParams) {}
}
enum G6GalleryRoom { static let noor: CGPoint? = nil; nonisolated static let slots: [String: PalaceSlot] = [:] }
struct G6GalleryBackdrop: View, Equatable { var body: some View { Color.clear } }
