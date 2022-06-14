import XCTest
@testable import AlgorithmsOnSequences

final class MatrixTests: XCTestCase {
    func testEmptyMatrix() {
        let matrix = Matrix(width: 0, [])

        XCTAssertEqual(matrix.height, 0)
        XCTAssertEqual(matrix.width, 0)
    }

    func testFlatMatrix() {
        let row = [9, 8, 5]
        let matrix = Matrix(width: row.count, row)

        XCTAssertEqual(matrix.elements, row)
        XCTAssertEqual(matrix.height, 1)
        XCTAssertEqual(matrix.width, row.count)

        XCTAssertEqual(matrix[0, 0], 9)
        XCTAssertEqual(matrix[0, 1], 8)
        XCTAssertEqual(matrix[0, 2], 5)
    }

    func testTabularMatrix() {
        let matrix = Matrix(width: 2, [
            1, 2,
            4, 5,
            7, 8
        ])

        XCTAssertEqual(matrix.height, 3)
        XCTAssertEqual(matrix[0, 0], 1)
        XCTAssertEqual(matrix[0, 1], 2)
        XCTAssertEqual(matrix[1, 0], 4)
        XCTAssertEqual(matrix[1, 1], 5)
        XCTAssertEqual(matrix[2, 0], 7)
        XCTAssertEqual(matrix[2, 1], 8)
    }
}

