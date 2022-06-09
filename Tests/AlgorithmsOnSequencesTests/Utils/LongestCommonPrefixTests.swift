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
}
