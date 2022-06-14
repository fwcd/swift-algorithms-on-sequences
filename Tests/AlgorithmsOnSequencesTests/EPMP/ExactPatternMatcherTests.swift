import XCTest
@testable import AlgorithmsOnSequences

final class ExactPatternMatcherTests: XCTestCase {
    func testNaivePatternMatcher() {
        testExactPatternMatcher(NaivePatternMatcher.self)
    }

    func testZBoxPatternMatcher() {
        XCTAssertEqual(ZBoxUtils.findLongestCommonPrefixes(in: Array("ananas")), [6, 0, 3, 0, 1, 0])
        XCTAssertEqual(ZBoxUtils.findLongestCommonSuffixes(in: Array("bananaban")), [0, 0, 3, 0, 2, 0, 0, 0, 9])
        XCTAssertEqual(ZBoxUtils.findLongestCommonPrefixes(in: Array("nabananab")), [9, 0, 0, 0, 2, 0, 3, 0, 0])
        XCTAssertEqual(ZBoxUtils.findLongestCommonBorders(in: Array("bananba")), [7, 2, 2, 2, 2, 2, 0])
        testExactPatternMatcher(ZBoxPatternMatcher.self)
    }

    func testBoyerMoorePatternMatcher() {
        testExactPatternMatcher(BoyerMoorePatternMatcher.self)
    }

    private func testExactPatternMatcher<M>(_ type: M.Type)
        where M: ExactPatternMatcher,
              M.Element == Character {
        assertThat(type, finds: "abc", in: "abcabc", at: [0, 3])
        assertThat(type, finds: "aa", in: "aaaaa", at: [0, 1, 2, 3])
        assertThat(type, finds: "def", in: "feddEf", at: [])
        assertThat(type, finds: "", in: "test", at: [0, 1, 2, 3])
        assertThat(type, finds: "ba", in: "abba", at: [2])
        assertThat(type, finds: "ba", in: "abbaabba", at: [2, 6])
        assertThat(type, finds: "aaa", in: "abaaa", at: [2])

        // Automatically generated test cases (using Scripts/generate-epmp-testcases)

        let path = Bundle.module.path(forResource: "epmp-testcases", ofType: "txt")!
        let raw = try! String(contentsOfFile: path, encoding: .utf8)

        for line in raw.components(separatedBy: .whitespacesAndNewlines) {
            if !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let split = line.split(separator: ";", omittingEmptySubsequences: false)
                let pattern = String(split[0])
                let text = String(split[1])
                let expectedIndices = split[2].split(separator: ",").map { Int($0)! }
                assertThat(type, finds: pattern, in: text, at: expectedIndices)
            }
        }
    }

    private func assertThat<M>(_ type: M.Type, finds pattern: String, in text: String, at indices: [Int], line: UInt = #line)
        where M: ExactPatternMatcher,
              M.Element == Character {
        XCTAssertEqual(M.init(pattern: Array(pattern)).findAllOccurrences(in: Array(text)), indices, line: line)
    }
}
