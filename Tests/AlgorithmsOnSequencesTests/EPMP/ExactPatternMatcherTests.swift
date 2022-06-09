import XCTest
@testable import AlgorithmsOnSequences

final class ExactPatternMatcherTests: XCTestCase {
    func testNaivePatternMatcher() {
        testExactPatternMatcher(NaivePatternMatcher.self)
    }

    func testZBoxPatternMatcher() {
        testExactPatternMatcher(ZBoxPatternMatcher.self)
    }

    private func testExactPatternMatcher<M>(_ type: M.Type) where M: ExactPatternMatcher {
        assertThat(type, finds: "abc", in: "abcabc", at: [0, 3])
        assertThat(type, finds: "aa", in: "aaaaa", at: [0, 1, 2, 3])
        assertThat(type, finds: "def", in: "feddEf", at: [])
        assertThat(type, finds: "", in: "test", at: [0, 1, 2, 3])
        assertThat(type, finds: "ba", in: "abba", at: [2])
        assertThat(type, finds: "ba", in: "abbaabba", at: [2, 6])
    }

    private func assertThat<M>(_ type: M.Type, finds pattern: String, in text: String, at indices: [Int], line: UInt = #line) where M: ExactPatternMatcher {
        XCTAssertEqual(M.findAllOccurrences(of: Array(pattern), in: Array(text)), indices, line: line)
    }
}
