import SwiftUI

/// Shops, practices and offices: canal houses with a front that tells what they are.
nonisolated extension KaartLandmarks {
    static func shops(_ n: Int) -> KaartLandmark? {
        switch n {
        case 27: kapper()
        default: nil
        }
    }

    /// De kapper: a cream neck-gable house with a big shop window and a barber's pole by the door.
    private static func kapper() -> KaartLandmark {
        var pen = KaartPen(wall: 0xE3D6BC, door: 0x1F3A6B, awning: 0x1F3A6B)
        let front = pen.canalHouse(x: 0, type: .hals, width: 66, floors: 2, shop: true, flowers: true, seed: 27)
        // Barber's pole: a white tube with red and blue bands, on a bracket left of the shop.
        let x = front.minX - 7, top = -58.0
        pen.rect(x - 0.6, top - 4, 7.2, 3, .ink)
        pen.fill(Path(roundedRect: CGRect(x: x, y: top, width: 6, height: 20), cornerRadius: 3), .white)
        var bands = Path()
        for i in 0..<4 {
            let y = top + 1 + Double(i) * 5
            bands.addPath(KaartPen.polygon([(x, y + 2), (x + 6, y), (x + 6, y + 1.6), (x, y + 3.6)]))
        }
        pen.fill(bands, .color(0xC8261B))
        pen.rect(x + 0.6, top + 21, 4.8, 2, .ink)
        pen.art.signAt = CGPoint(x: front.maxX - 4, y: front.minY + 30)
        pen.art.sign = "scissors"
        return pen.art
    }
}
