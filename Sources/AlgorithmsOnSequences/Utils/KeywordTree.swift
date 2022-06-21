/// A labelled prefix tree.
public struct KeywordTree<Label, Edge> where Edge: Hashable {
    public var label: Label
    public var children: [Edge: KeywordTree<Label, Edge>]

    /// Creates a new keyword tree.
    /// 
    /// - Parameters:
    ///   - label: This node's label
    ///   - children: The children of this node
    public init(
        label: Label,
        children: [Edge: KeywordTree<Label, Edge>] = [:]
    ) {
        self.label = label
        self.children = children
    }

    /// Fetches the immediate child connected by the given edge.
    public subscript(edge: Edge) -> KeywordTree<Label, Edge>? {
        get { children[edge] }
        set { children[edge] = newValue }
    }

    /// Fetches the child connected by the given path.
    public subscript<Path>(path: Path) -> KeywordTree<Label, Edge>?
        where Path: Collection,
              Path.Element == Edge {
        guard let edge = path.first else { return self }
        return children[edge]?[path.dropFirst()]
    }
}

extension KeywordTree where Label == Bool {
    /// Inserts the given path into the tree with the leaf
    /// being labelled with true.
    /// 
    /// - Parameter path: The path to insert
    public mutating func insert<Path>(path: Path)
        where Path: Collection,
              Path.Element == Edge {
        guard let edge = path.first else {
            label = true
            return
        }
        children[edge] = children[edge] ?? KeywordTree(label: false)
        children[edge]?.insert(path: path.dropFirst())
    }

    /// Whether this tree contains a node at the given path
    /// labelled true.
    ///
    /// - Parameter path: The path to search
    /// - Returns: Whether a KeywordTree node with label true exists there
    public func contains<Path>(path: Path) -> Bool
        where Path: Collection,
              Path.Element == Edge {
        self[path]?.label ?? false
    }
}

extension KeywordTree where Label == Bool, Edge: Comparable {
    /// Create a keyword tree from the given paths.
    /// 
    /// - Parameter paths: The paths to construct the tree from
    public init<Paths>(paths: Paths)
        where Paths: Sequence,
              Paths.Element == [Edge] {
        self.init(label: false)
        for path in paths {
            insert(path: path)
        }
    }
}
