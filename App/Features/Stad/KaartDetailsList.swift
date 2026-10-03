import SwiftUI

/// Every detail hidden in the city, with its word.
nonisolated enum KaartDetails {
    static let all: [KaartDetail] = [
        KaartDetail(
            id: "kat-singel", kind: .kat, nl: "kat", article: .de, en: "cat",
            point: CGPoint(x: 352, y: 212), size: CGSize(width: 10, height: 9), minZoom: 1
        ),
    ]
}
