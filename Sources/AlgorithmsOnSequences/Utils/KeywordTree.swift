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

extension KeywordTree where Label == Void {
    public init(children: [Edge: KeywordTree<Label, Edge>] = [:]) {
        self.init(label: (), children: children)
    }
}
