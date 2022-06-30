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

    func testUkkonenSteps2() {
        var tree = CompressedKeywordTree<Character>()

        // Simulate Ukkonen's algorithm on the example from Wikipedia ('xabxac')

        // 1. Phase (suffixes of 'x')
        tree.extend(path: [], by: "x")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(),
        ]))

        // 2. Phase (suffixes of 'xa')
        tree.extend(path: [], by: "a")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(),
            "a": .init(),
        ]))
        tree.extend(path: ["x"], by: "a")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a"]),
            "a": .init(),
        ]))

        // 3. Phase (suffixes of 'xab')
        tree.extend(path: [], by: "b")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a"]),
            "a": .init(),
            "b": .init(),
        ]))
        tree.extend(path: ["a"], by: "b")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a"]),
            "a": .init(remainingEdges: ["b"]),
            "b": .init(),
        ]))
        tree.extend(path: ["x", "a"], by: "b")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a", "b"]),
            "a": .init(remainingEdges: ["b"]),
            "b": .init(),
        ]))

        // 4. Phase (suffixes 'xabx')
        tree.extend(path: [], by: "x")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a", "b"]),
            "a": .init(remainingEdges: ["b"]),
            "b": .init(),
        ]))
        tree.extend(path: ["b"], by: "x")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a", "b"]),
            "a": .init(remainingEdges: ["b"]),
            "b": .init(remainingEdges: ["x"]),
        ]))
        tree.extend(path: ["a", "b"], by: "x")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a", "b"]),
            "a": .init(remainingEdges: ["b", "x"]),
            "b": .init(remainingEdges: ["x"]),
        ]))
        tree.extend(path: ["x", "a", "b"], by: "x")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a", "b", "x"]),
            "a": .init(remainingEdges: ["b", "x"]),
            "b": .init(remainingEdges: ["x"]),
        ]))
    }
}
