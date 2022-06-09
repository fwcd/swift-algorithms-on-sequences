import XCTest
@testable import AlgorithmsOnSequences

final class PrefixesAndSuffixesTests: XCTestCase {
    func testPrefixes() {
        XCTAssertEqual("".prefixes, [""])
        XCTAssertEqual("x".prefixes, ["", "x"])
        XCTAssertEqual("banana".prefixes, ["", "b", "ba", "ban", "bana", "banan", "banana"])
    }

    func testSuffixes() {
        XCTAssertEqual("".suffixes, [""])
        XCTAssertEqual("x".suffixes, ["x", ""])
        XCTAssertEqual("abc".suffixes, ["abc", "bc", "c", ""])
    }
}
