import XCTest
@testable import Klinker

/// Every designed room must anchor all its words on real objects, with no sign that spells a word.
@MainActor
final class AnchorTests: XCTestCase {
    func testDesignedRoomsHaveNoProblems() throws {
        let content = ContentStore.shared
        let book = PalaceAnchorBook.bundled
        XCTAssertFalse(book.rooms.isEmpty, "anchors.json should be bundled")
        for number in book.rooms.keys.sorted() {
            let sheet = try XCTUnwrap(content.sheet(number), "anchors for sheet \(number) without content")
            XCTAssertEqual(book.problems(for: sheet), [], "sheet \(number)")
        }
    }
}
