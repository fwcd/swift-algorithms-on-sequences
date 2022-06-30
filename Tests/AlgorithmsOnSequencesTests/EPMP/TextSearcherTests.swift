import XCTest
@testable import AlgorithmsOnSequences
import MirrorDiffKit

final class TextSearcherTests: XCTestCase {
    func testNaiveTextSearcher() {
        testTextSearcher(NaiveTextSearcher.self)
    }

    func testUkkonenTextSearcher() {
        let el = UkkonenTextSearcher<Character>.Token.element
        let end = UkkonenTextSearcher<Character>.Token.end

        assertThat(UkkonenTextSearcher(text: Array("xabxac")).suffixTree, equals: .init(children: [
            end: .init(),
            el("b"): .init(remainingEdges: ["x", "a", "c"].map(el) + [end]),
            el("c"): .init(remainingEdges: [end]),
            el("a"): .init(node: .init(children: [
                el("c"): .init(remainingEdges: [end]),
                el("b"): .init(remainingEdges: ["x", "a", "c"].map(el) + [end]),
            ])),
            el("x"): .init(remainingEdges: ["a"].map(el), node: .init(children: [
                el("c"): .init(remainingEdges: [end]),
                el("b"): .init(remainingEdges: ["x", "a", "c"].map(el) + [end]),
            ])),
        ]))

        // TODO: Fix
        // testTextSearcher(UkkonenTextSearcher.self)
    }

    private func testTextSearcher<Searcher>(_ type: Searcher.Type)
        where Searcher: TextSearcher,
              Searcher.Element == Character {
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

    private func assertThat<Searcher>(_ type: Searcher.Type, finds pattern: String, in text: String, at indices: [Int], line: UInt = #line)
        where Searcher: TextSearcher,
              Searcher.Element == Character {
        XCTAssertEqual(Searcher(text: Array(text)).findAllOccurrences(of: Array(pattern)), indices, line: line)
    }

    private func assertThat<T>(_ value1: T, equals value2: T) where T: Equatable {
        XCTAssertEqual(value1, value2, diff(between: value1, and: value2))
    }
}
