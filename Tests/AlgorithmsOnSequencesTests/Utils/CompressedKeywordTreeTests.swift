import XCTest
@testable import AlgorithmsOnSequences

final class CompressedKeywordTreeTests: XCTestCase {
    func testEmpty() {
        let tree = CompressedKeywordTree<Int>()

        XCTAssert(tree.isLeaf)
        XCTAssertEqual(tree.children, [:])
        XCTAssertEqual(tree.depthFirstSearchedDepths, [0])
        XCTAssertEqual(tree.depthFirstSearchedPaths, [[]])
    }

    func testUkkonenSteps() {
        var tree = CompressedKeywordTree<Character>()

        // Simulate Ukkonen's algorithm on the string 'aab' phase-by-phase

        // 1. Phase (suffixes of 'a')
        tree.extend(path: [], by: "a")
        XCTAssertFalse(tree.isLeaf)
        XCTAssertEqual(tree, .init(children: ["a": .init()]))

        // 2. Phase (suffixes of 'aa')
        tree.extend(path: [], by: "a")
        XCTAssertEqual(tree, .init(children: ["a": .init()]))
        tree.extend(path: ["a"], by: "a")
        XCTAssertEqual(tree, .init(children: ["a": .init(remainingEdges: ["a"])]))

        // 3. Phase (suffixes of 'aab')
        tree.extend(path: [], by: "b")
        XCTAssertEqual(tree, .init(children: [
            "a": .init(remainingEdges: ["a"]),
            "b": .init(),
        ]))
        tree.extend(path: ["a"], by: "b")
        XCTAssertEqual(tree, .init(children: [
            "a": .init(node: .init(children: [
                "a": .init(),
                "b": .init(),
            ])),
            "b": .init(),
        ]))
        tree.extend(path: ["a", "a"], by: "b")
        XCTAssertEqual(tree, .init(children: [
            "a": .init(node: .init(children: [
                "a": .init(remainingEdges: ["b"]),
                "b": .init(),
            ])),
            "b": .init(),
        ]))
    }
}
