import XCTest
@testable import AlgorithmsOnSequences

final class TableTests: XCTestCase {
    func testEmptyTable() {
        let table = Table(width: 0, [])

        XCTAssertEqual(table.height, 0)
        XCTAssertEqual(table.width, 0)
    }

    func testFlatTable() {
        let row = [9, 8, 5]
        let table = Table(width: row.count, row)

        XCTAssertEqual(table.elements, row)
        XCTAssertEqual(table.height, 1)
        XCTAssertEqual(table.width, row.count)

        XCTAssertEqual(table[0, 0], 9)
        XCTAssertEqual(table[0, 1], 8)
        XCTAssertEqual(table[0, 2], 5)
    }

    func testTabularTable() {
        let table = Table(width: 2, [
            1, 2,
            4, 5,
            7, 8
        ])

        XCTAssertEqual(table.height, 3)
        XCTAssertEqual(table[0, 0], 1)
        XCTAssertEqual(table[0, 1], 2)
        XCTAssertEqual(table[1, 0], 4)
        XCTAssertEqual(table[1, 1], 5)
        XCTAssertEqual(table[2, 0], 7)
        XCTAssertEqual(table[2, 1], 8)
    }
}

