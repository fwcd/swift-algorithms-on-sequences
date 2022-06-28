import XCTest
@testable import AlgorithmsOnSequences

final class SetMatcherTests: XCTestCase {
    func testNaiveSetMatcher() {
        testSetMatcher(NaiveSetMatcher.self)
    }

    private func testSetMatcher<M>(_ type: M.Type)
        where M: SetMatcher,
              M.Element == Character {
        assertThat(type, finds: [], in: "abcabc", at: [])

        assertThat(type, finds: ["abc"], in: "abcabc", at: [0, 3])
        assertThat(type, finds: ["aa"], in: "aaaaa", at: [0, 1, 2, 3])
        assertThat(type, finds: ["def"], in: "feddEf", at: [])
        assertThat(type, finds: [""], in: "test", at: [0, 1, 2, 3])
        assertThat(type, finds: ["ba"], in: "abba", at: [2])
        assertThat(type, finds: ["ba"], in: "abbaabba", at: [2, 6])
        assertThat(type, finds: ["aaa"], in: "abaaa", at: [2])

        assertThat(type, finds: ["ba", "bba"], in: "abbaabba", at: [1, 2, 5, 6])
        assertThat(type, finds: ["abb", "a", "aab"], in: "abbaabba", at: [0, 3, 4, 7])
        assertThat(type, finds: ["abb", "aab"], in: "abbaabba", at: [0, 3, 4])

        // TODO: Automatically generate test cases
    }

    private func assertThat<M>(_ type: M.Type, finds patterns: Set<String>, in text: String, at indices: [Int], line: UInt = #line)
        where M: SetMatcher,
              M.Element == Character {
        XCTAssertEqual(M.init(patterns: Set(patterns.map { Array($0) })).findAllOccurrences(in: Array(text)), indices, line: line)
    }
}
