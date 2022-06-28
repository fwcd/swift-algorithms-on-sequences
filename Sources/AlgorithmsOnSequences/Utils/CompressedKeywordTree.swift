/// A trie with compressed edges, e.g. suitable for representing suffix trees.
public struct CompressedKeywordTree<Edge> where Edge: Hashable {
    private var children: [Edge: Child]

    private struct Child {
        let remainingEdges: [Edge]
        let node: CompressedKeywordTree<Edge>
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
        guard let child = children[edge],
              path.dropFirst().starts(with: child.remainingEdges) else { return nil }
        return child.node[path.dropFirst(child.remainingEdges.count + 1)]
    }
}
