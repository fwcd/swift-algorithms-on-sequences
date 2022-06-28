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
}
