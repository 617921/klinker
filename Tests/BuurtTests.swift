import XCTest
@testable import Klinker

@MainActor
final class BuurtTests: XCTestCase {
    func testEveryPlaceIsInExactlyOneNeighbourhood() {
        let all = Buurt.all.flatMap(\.places)
        XCTAssertEqual(all.sorted(), Array(1...62))
        XCTAssertEqual(Buurt.all.count, 8)
        for buurt in Buurt.all {
            XCTAssertTrue((5...11).contains(buurt.places.count), "\(buurt.name) has \(buurt.places.count) places")
        }
    }

    func testPostcardsComeOneByOne() {
        // Numbered in the order they arrive, each at a different moment.
        let lasts = Buurt.all.map(\.last)
        XCTAssertEqual(lasts, lasts.sorted())
        XCTAssertEqual(Set(lasts).count, lasts.count)
        XCTAssertEqual(Buurt.all.map(\.id), Array(1...8))
        XCTAssertLessThanOrEqual(lasts.first ?? 99, 12, "the first postcard comes early")
    }

    func testPostcardBuildingsBelongToTheirNeighbourhood() {
        for buurt in Buurt.all {
            XCTAssertFalse(buurt.picks.isEmpty)
            for pick in buurt.picks {
                XCTAssertTrue(buurt.places.contains(pick), "\(pick) is not in \(buurt.name)")
                XCTAssertNotNil(KaartData.house(pick).landmark, "\(pick) has no building of its own to draw")
            }
            XCTAssertTrue(buurt.picks.contains(buurt.warm))
            XCTAssertNotNil(KaartData.house(buurt.warm).landmark?.marks[.raam], "\(buurt.warm) has no window to light")
        }
    }

    func testCompletion() {
        let buurt = Buurt.all[0]
        var statuses = [SheetStatus](repeating: .locked, count: 62)
        XCTAssertFalse(buurt.isComplete(statuses))
        XCTAssertEqual(buurt.left(statuses), buurt.places.count)
        for n in buurt.places { statuses[n - 1] = .growing }
        XCTAssertTrue(buurt.isComplete(statuses))
        XCTAssertEqual(buurt.left(statuses), 0)
    }
}
