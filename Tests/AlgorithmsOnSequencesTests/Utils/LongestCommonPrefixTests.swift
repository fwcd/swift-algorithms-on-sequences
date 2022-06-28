import XCTest
@testable import AlgorithmsOnSequences

final class LongestCommonPrefixTests: XCTestCase {
    func testLongestCommonPrefixes() {
        XCTAssertEqual("abba".longestCommonPrefix("ab"), "ab")
        XCTAssertEqual("abba".longestCommonPrefix("ba"), "")
        XCTAssertEqual("banana".longestCommonPrefix("anana"), "")
        XCTAssertEqual("banana".longestCommonPrefix("banane"), "banan")

        let word = Array("ananas")
        let expectedLcps = [6, 0, 3, 0, 1, 0]
        let actualLcps = word.indices.map { word.longestCommonPrefix($0).count }

        XCTAssertEqual(actualLcps, expectedLcps)
    }

    func testZAlgorithmLongestCommonPrefixes() {
        XCTAssertEqual(Array("ananas").longestCommonPrefixes, [6, 0, 3, 0, 1, 0])
        XCTAssertEqual(Array("bananaban").longestCommonSuffixes, [0, 0, 3, 0, 2, 0, 0, 0, 9])
        XCTAssertEqual(Array("nabananab").longestCommonPrefixes, [9, 0, 0, 0, 2, 0, 3, 0, 0])
        XCTAssertEqual(Array("bananba").longestCommonBorders, [7, 2, 2, 2, 2, 2, 0])
    }
}
