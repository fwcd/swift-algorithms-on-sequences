import XCTest
@testable import AlgorithmsOnSequences

final class IndexingTests: XCTestCase {
    func testEmptyIndexing() {
        let indexing = Indexing<String>([])

        XCTAssert(indexing.isEmpty)
        XCTAssertEqual(indexing.count, 0)
        XCTAssert(Array(indexing).isEmpty)
    }

    func testSimpleIndexing() {
        let indexing = Indexing(["pen", "pineapple", "apple", "pen"])
        
        XCTAssertEqual(indexing.count, 3)
        XCTAssertEqual(indexing["pen"], 0)
        XCTAssertEqual(indexing["pineapple"], 1)
        XCTAssertEqual(indexing["apple"], 2)
        XCTAssertEqual(indexing[2], "apple")
        XCTAssertEqual(indexing[1], "pineapple")
        XCTAssertEqual(indexing[0], "pen")
    }
}

