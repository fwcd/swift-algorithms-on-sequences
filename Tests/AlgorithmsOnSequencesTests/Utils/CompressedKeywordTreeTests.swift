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

        // 4. Phase (suffixes of 'xabx')
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

        // 5. Phase (suffixes of 'xabxa')
        tree.extend(path: [], by: "a")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a", "b", "x"]),
            "a": .init(remainingEdges: ["b", "x"]),
            "b": .init(remainingEdges: ["x"]),
        ]))
        tree.extend(path: ["x"], by: "a")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a", "b", "x"]),
            "a": .init(remainingEdges: ["b", "x"]),
            "b": .init(remainingEdges: ["x"]),
        ]))
        tree.extend(path: ["b", "x"], by: "a")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a", "b", "x"]),
            "a": .init(remainingEdges: ["b", "x"]),
            "b": .init(remainingEdges: ["x", "a"]),
        ]))
        tree.extend(path: ["a", "b", "x"], by: "a")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a", "b", "x"]),
            "a": .init(remainingEdges: ["b", "x", "a"]),
            "b": .init(remainingEdges: ["x", "a"]),
        ]))
        tree.extend(path: ["x", "a", "b", "x"], by: "a")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a", "b", "x", "a"]),
            "a": .init(remainingEdges: ["b", "x", "a"]),
            "b": .init(remainingEdges: ["x", "a"]),
        ]))

        // 6. Phase (suffixes of 'xabxac')
        tree.extend(path: [], by: "c")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a", "b", "x", "a"]),
            "a": .init(remainingEdges: ["b", "x", "a"]),
            "b": .init(remainingEdges: ["x", "a"]),
            "c": .init(),
        ]))
        tree.extend(path: ["a"], by: "c")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a", "b", "x", "a"]),
            "a": .init(node: .init(children: [
                "c": .init(),
                "b": .init(remainingEdges: ["x", "a"])
            ])),
            "b": .init(remainingEdges: ["x", "a"]),
            "c": .init(),
        ]))
        tree.extend(path: ["x", "a"], by: "c")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a"], node: .init(children: [
                "c": .init(),
                "b": .init(remainingEdges: ["x", "a"]),
            ])),
            "a": .init(node: .init(children: [
                "c": .init(),
                "b": .init(remainingEdges: ["x", "a"])
            ])),
            "b": .init(remainingEdges: ["x", "a"]),
            "c": .init(),
        ]))
        tree.extend(path: ["b", "x", "a"], by: "c")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a"], node: .init(children: [
                "c": .init(),
                "b": .init(remainingEdges: ["x", "a"]),
            ])),
            "a": .init(node: .init(children: [
                "c": .init(),
                "b": .init(remainingEdges: ["x", "a"])
            ])),
            "b": .init(remainingEdges: ["x", "a", "c"]),
            "c": .init(),
        ]))
        tree.extend(path: ["a", "b", "x", "a"], by: "c")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a"], node: .init(children: [
                "c": .init(),
                "b": .init(remainingEdges: ["x", "a"]),
            ])),
            "a": .init(node: .init(children: [
                "c": .init(),
                "b": .init(remainingEdges: ["x", "a", "c"])
            ])),
            "b": .init(remainingEdges: ["x", "a", "c"]),
            "c": .init(),
        ]))
        tree.extend(path: ["x", "a", "b", "x", "a"], by: "c")
        XCTAssertEqual(tree, .init(children: [
            "x": .init(remainingEdges: ["a"], node: .init(children: [
                "c": .init(),
                "b": .init(remainingEdges: ["x", "a", "c"]),
            ])),
            "a": .init(node: .init(children: [
                "c": .init(),
                "b": .init(remainingEdges: ["x", "a", "c"])
            ])),
            "b": .init(remainingEdges: ["x", "a", "c"]),
            "c": .init(),
        ]))
    }

    func testSearch() {
        // Suffix tree of 'xabxac'
        let tree: CompressedKeywordTree<Character> = .init(children: [
            "x": .init(remainingEdges: ["a"], node: .init(children: [
                "c": .init(),
                "b": .init(remainingEdges: ["x", "a", "c"]),
            ])),
            "a": .init(node: .init(children: [
                "c": .init(),
                "b": .init(remainingEdges: ["x", "a", "c"])
            ])),
            "b": .init(remainingEdges: ["x", "a", "c"]),
            "c": .init(),
        ])

        XCTAssert(tree.contains(path: Array("c")))
        XCTAssert(tree.contains(path: Array("ac")))
        XCTAssert(tree.contains(path: Array("xac")))
        XCTAssert(tree.contains(path: Array("bxac")))
        XCTAssert(tree.contains(path: Array("abxac")))
        XCTAssert(tree.contains(path: Array("xabxac")))
        XCTAssertFalse(tree.contains(path: Array("axac")))

        let traversed = tree.depthFirstSearchedPaths.sorted { $0.lexicographicallyPrecedes($1) }
        let suffixes = Array("xabxac").suffixes.dropLast().map(Array.init).sorted { $0.lexicographicallyPrecedes($1) }
        XCTAssertEqual(traversed, suffixes)
        XCTAssertEqual(Set(traversed.map(\.count)), Set(tree.depthFirstSearchedDepths))

        let xSubtree: CompressedKeywordTree<Character> = .init(children: [
            "a": .init(node: .init(children: [
                "c": .init(),
                "b": .init(remainingEdges: ["x", "a", "c"]),
            ]))
        ])
        XCTAssertEqual(tree["x"], xSubtree)
        XCTAssertEqual(Set(xSubtree.depthFirstSearchedPaths), [
            Array("ac"),
            Array("abxac"),
        ])

        let xaSubtree: CompressedKeywordTree<Character> = .init(children: [
            "c": .init(),
            "b": .init(remainingEdges: ["x", "a", "c"]),
        ])
        XCTAssertEqual(tree["xa"], xaSubtree)

        let xacSubtree: CompressedKeywordTree<Character> = .init()
        XCTAssertEqual(tree["xac"], xacSubtree)

        let xabSubtree: CompressedKeywordTree<Character> = .init(children: [
            "x": .init(remainingEdges: ["a", "c"]),
        ])
        XCTAssertEqual(tree["xab"], xabSubtree)
    }
}
