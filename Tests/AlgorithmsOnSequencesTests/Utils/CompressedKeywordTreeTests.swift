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

    // func testUkkonenSteps() {
    //     var tree = CompressedKeywordTree<Character>()

    //     tree.ukkonenStep(by: "a")
    //     XCTAssertFalse(tree.isLeaf)
    //     XCTAssertEqual(tree, .init(children: ["a": .init()]))

    //     tree.ukkonenStep(by: "a")
    //     XCTAssertEqual(tree, .init(children: ["a": .init(node: .init(children: ["a": .init()]))]))

    //     tree.ukkonenStep(by: "b")
    //     XCTAssertEqual(tree, .init(children: [
    //         "a": .init(remainingEdges: ["b"], node: .init(children: ["a": .init(remainingEdges: ["b"])])),
    //         "b": .init()
    //     ]))
    // }
}
