/// A trie with compressed edges, e.g. suitable for representing suffix trees.
public struct CompressedKeywordTree<Edge> where Edge: Hashable {
    private var children: [Edge: Child]

    public var isLeaf: Bool { children.isEmpty }

    /// The paths to the tree's leafs collected by
    /// depth-first search traversal.
    public var depthFirstSearchedPaths: [[Edge]] {
        isLeaf ? [[]] : children.flatMap { (edge, child) in
            child.node.depthFirstSearchedPaths.map { [edge] + child.remainingEdges + $0 }
        }
    }

    /// The depths collected by depth-first search traversal.
    /// Semantically equivalent to `depthFirstSearchedPaths.map(\.count)`
    /// (but more efficient).
    public var depthFirstSearchedDepths: [Int] {
        isLeaf ? [0] : children.flatMap { (edge, child) in
            child.node.depthFirstSearchedDepths.map { 1 + child.remainingEdges.count + $0 }
        }
    }

    private struct Child {
        let remainingEdges: [Edge]
        let node: CompressedKeywordTree<Edge>

        func isPrefix<Path>(of path: Path) -> Bool
            where Path: Collection,
                  Path.Element == Edge {
            path.starts(with: remainingEdges)
        }
    }

    /// Creates a new compressed keyword tree.
    public init() {
        children = [:]
    }

    /// Fetches the child connected by the given path.
    public subscript<Path>(path: Path) -> Self?
        where Path: Collection,
              Path.Element == Edge {
        guard let edge = path.first else { return self }
        guard let child = children[edge], child.isPrefix(of: path.dropFirst()) else { return nil }
        return child.node[path.dropFirst(child.remainingEdges.count + 1)]
    }

    /// Extends the tree with the given element, i.e. performs a step
    /// in Ukkonen's algorithm by turning a suffix tree of S[1...j]
    /// into a suffix tree of S[1...i + 1] (given S[i + 1]).
    /// 
    /// - Parameter edge: The element to extend the tree by
    public mutating func extend(by edge: Edge) {
        // TODO
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
