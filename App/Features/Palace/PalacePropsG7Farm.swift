import SwiftUI

enum G7FarmProps {
    static func barn(_ pen: PropPen, _ p: PalacePropParams) {}
    static func meadow(_ pen: PropPen, _ p: PalacePropParams) {}
    static func fields(_ pen: PropPen, _ p: PalacePropParams) {}
    static func dairy(_ pen: PropPen, _ p: PalacePropParams) {}
    static func farmStall(_ pen: PropPen, _ p: PalacePropParams) {}
    static func tractor(_ pen: PropPen, _ p: PalacePropParams) {}
}

enum G7FarmAnimals {
    static func livestock(_ pen: PropPen, _ p: PalacePropParams) {}
    static func milking(_ pen: PropPen, _ p: PalacePropParams) {}
    static func feeding(_ pen: PropPen, _ p: PalacePropParams) {}
}

