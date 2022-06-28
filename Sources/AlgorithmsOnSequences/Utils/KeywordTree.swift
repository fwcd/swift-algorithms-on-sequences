/// A labelled prefix tree/trie.
public struct KeywordTree<Edge> where Edge: Hashable {
    public var isFinal: Bool
    public var children: [Edge: Self]

    /// Creates a new keyword tree.
    /// 
    /// - Parameters:
    ///   - isFinal: Whether the node represents the end of a string in the tree
    ///   - children: This node's children
    public init(
        isFinal: Bool = false,
        children: [Edge: Self] = [:]
    ) {
        self.isFinal = isFinal
        self.children = children
    }

    /// Fetches the immediate child connected by the given edge.
    public subscript(edge: Edge) -> Self? {
        get { children[edge] }
        set { children[edge] = newValue }
    }

    /// Fetches the child connected by the given path.
    public subscript<Path>(path: Path) -> Self?
        where Path: Collection,
              Path.Element == Edge {
        guard let edge = path.first else { return self }
        return children[edge]?[path.dropFirst()]
    }

    /// Inserts the given path into the tree.
    /// 
    /// - Parameter path: The path to insert
    public mutating func insert<Path>(path: Path)
        where Path: Collection,
              Path.Element == Edge {
        guard let edge = path.first else {
            isFinal = true
            return
        }
        children[edge] = children[edge] ?? KeywordTree(isFinal: false)
        children[edge]?.insert(path: path.dropFirst())
    }

    /// Whether this tree contains a node at the given path.
    ///
    /// - Parameter path: The path to search
    /// - Returns: Whether a (final) node exists there
    public func contains<Path>(path: Path) -> Bool
        where Path: Collection,
              Path.Element == Edge {
        self[path]?.isFinal ?? false
    }
}

extension KeywordTree where Edge: Comparable {
    /// Create a keyword tree from the given paths.
    /// 
    /// - Parameter paths: The paths to construct the tree from
    public init<Paths>(paths: Paths)
        where Paths: Sequence,
              Paths.Element == [Edge] {
        self.init()
        for path in paths {
            insert(path: path)
        }
    }
}
