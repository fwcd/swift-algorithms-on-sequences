/// A trie with compressed edges, e.g. suitable for representing (implicit) suffix trees.
public struct CompressedKeywordTree<Edge>: Hashable where Edge: Hashable {
    /* internal for testing */ var children: [Edge: Child]

    public var isLeaf: Bool { children.isEmpty }

    /// The paths to the tree's leafs collected by
    /// depth-first search traversal.
    public var depthFirstSearchedPaths: [[Edge]] {
        [[]] + children.flatMap { (edge, child) in
            child.node.depthFirstSearchedPaths.map { [edge] + child.remainingEdges + $0 }
        }
    }

    /// The depths collected by depth-first search traversal.
    /// Semantically equivalent to `depthFirstSearchedPaths.map(\.count)`
    /// (but more efficient).
    public var depthFirstSearchedDepths: [Int] {
        [0] + children.flatMap { (edge, child) in
            child.node.depthFirstSearchedDepths.map { 1 + child.remainingEdges.count + $0 }
        }
    }

    /* internal for testing */ struct Child: Hashable {
        var remainingEdges: [Edge] = []
        var node: CompressedKeywordTree<Edge> = .init()

        func isPrefix<Path>(of path: Path) -> Bool
            where Path: Collection,
                  Path.Element == Edge {
            path.starts(with: remainingEdges)
        }

        mutating func popFirst() -> Edge? {
            guard !remainingEdges.isEmpty else { return nil }
            return remainingEdges.removeFirst()
        }

        mutating func split() {
            guard let edge = popFirst() else {
                fatalError("Cannot split empty child of compressed keyword tree")
            }
            let tail = self
            remainingEdges = []
            node.children[edge] = tail
        }

        mutating func extend<Path>(path: Path, by newEdge: Edge)
            where Path: Collection,
                  Path.Element == Edge {
            let pathEdges = Array(path)
            if pathEdges == remainingEdges {
                // Ukkonen's algorithm rule 1
                remainingEdges.append(newEdge)
            } else {
                let lcp = pathEdges.longestCommonPrefix(remainingEdges)
                if lcp.count == remainingEdges.count {
                    // Recurse
                    node.extend(path: path.dropFirst(remainingEdges.count), by: newEdge)
                } else {
                    assert(lcp.count < remainingEdges.count)
                    guard remainingEdges[lcp.count] != newEdge else {
                        // Ukkonen's algorithm rule 3, do nothing
                        return
                    }
                    // Ukkonen's algorithm rule 2, split
                    let tail = remainingEdges[lcp.count...]
                    assert(!tail.isEmpty)
                    assert(tail[0] != newEdge)
                    remainingEdges = Array(lcp)
                    node = .init(children: [
                        tail[0]: .init(remainingEdges: Array(tail.dropFirst()), node: node),
                        newEdge: .init(),
                    ])
                }
            }
        }
    }

    /// Creates a new compressed keyword tree with the given children.
    /// 
    /// - Parameter children: The node's children
    /* internal for testing */ init(children: [Edge: Child]) {
        self.children = children
    }

    /// Creates a new compressed keyword tree.
    public init() {
        self.init(children: [:])
    }

    /// Fetches the child connected by the given path.
    public subscript<Path>(path: Path) -> Self?
        where Path: Collection,
              Path.Element == Edge {
        guard let edge = path.first else { return self }
        guard let child = children[edge], child.isPrefix(of: path.dropFirst()) else { return nil }
        return child.node[path.dropFirst(child.remainingEdges.count + 1)]
    }

    /// Extends a path in the tree, i.e. a step in Ukkonen's algorithm.
    /// 
    /// - Parameters:
    ///   - path: The path to extend
    ///   - by: The edge to extend with
    public mutating func extend<Path>(path: Path, by newEdge: Edge)
        where Path: Collection,
              Path.Element == Edge {
        if let first = path.first {
            let tail = path.dropFirst()
            if var child = children[first] {
                child.extend(path: tail, by: newEdge)
                children[first] = child
            } else {
                children[first] = Child(remainingEdges: tail + [newEdge])
            }
        } else {
            children[newEdge] = children[newEdge] ?? Child()
        }
    }

    /// Whether this tree contains a node at the given path.
    ///
    /// - Parameter path: The path to search
    /// - Returns: Whether a node exists there
    public func contains<Path>(path: Path) -> Bool
        where Path: Collection,
              Path.Element == Edge {
        self[path] != nil
    }
}
