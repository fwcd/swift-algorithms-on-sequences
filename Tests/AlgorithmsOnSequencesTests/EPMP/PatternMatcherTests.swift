import XCTest
@testable import AlgorithmsOnSequences

final class PatternMatcherTests: XCTestCase {
    func testNaivePatternMatcher() {
        testPatternMatcher(NaivePatternMatcher.self)
    }

    func testZBoxPatternMatcher() {
        testPatternMatcher(ZBoxPatternMatcher.self)
    }

    func testBoyerMoorePatternMatcher() {
        testPatternMatcher(BoyerMoorePatternMatcher.self)
    }

    func testKnuthMorrisPrattPatternMatcher() {
        // Using the examples from Wikipedia: https://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm#Working_example_of_the_table-building_algorithm
        XCTAssertEqual(KnuthMorrisPrattPatternMatcher(pattern: Array("abcdabd")).partialMatchTable, [-1, 0, 0, 0, -1, 0, 2, 0])
        XCTAssertEqual(KnuthMorrisPrattPatternMatcher(pattern: Array("abacababc")).partialMatchTable, [-1, 0, -1, 1, -1, 0, -1, 3, 2, 0])
        XCTAssertEqual(KnuthMorrisPrattPatternMatcher(pattern: Array("abacababa")).partialMatchTable, [-1, 0, -1, 1, -1, 0, -1, 3, -1, 3])
        XCTAssertEqual(KnuthMorrisPrattPatternMatcher(pattern: Array("participate in parachute")).partialMatchTable, [-1, 0, 0, 0, 0, 0, 0, -1, 0, 2, 0, 0, 0, 0, 0, -1, 0, 0, 3, 0, 0, 0, 0, 0, 0])

        testPatternMatcher(KnuthMorrisPrattPatternMatcher.self)
    }

    private func testPatternMatcher<Matcher>(_ type: Matcher.Type)
        where Matcher: PatternMatcher,
              Matcher.Element == Character {
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

    private func assertThat<Matcher>(_ type: Matcher.Type, finds pattern: String, in text: String, at indices: [Int], line: UInt = #line)
        where Matcher: PatternMatcher,
              Matcher.Element == Character {
        XCTAssertEqual(Matcher(pattern: Array(pattern)).findAllOccurrences(in: Array(text)), indices, line: line)
    }
}
