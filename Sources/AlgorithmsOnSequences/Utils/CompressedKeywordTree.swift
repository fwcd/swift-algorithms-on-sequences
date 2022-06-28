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

        mutating func extend(by edge: Edge) {
            remainingEdges.append(edge)
            node.extend(by: edge)
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

    /// Extends the tree with the given element
    /// 
    /// - Parameter edge: The element to extend the tree by
    public mutating func extend(by extended: Edge) {
        for edge in children.keys {
            children[edge]!.extend(by: extended)
        }
    }

    /// Performs a step in Ukkonen's algorithm, i.e. turns a suffix tree of
    /// `S[...i]` into a suffix tree of `S[...i + 1]` (given `S[i + 1]`).
    ///
    /// - Parameter edge: `S[i + 1]`
    public mutating func ukkonenStep(by edge: Edge) {
        // Perform extensions
        extend(by: edge)
        // Add new edge
        if var child = children[edge] {
            if !child.remainingEdges.isEmpty {
                child.split()
            }
            children[edge] = child
        } else {
            children[edge] = Child()
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
