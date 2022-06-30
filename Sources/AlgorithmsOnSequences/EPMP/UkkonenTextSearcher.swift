public struct UkkonenTextSearcher<Element>: TextSearcher where Element: Hashable {
    private let textLength: Int
    /* internal for testing */ let suffixTree: CompressedKeywordTree<Token>

    /// A token for use in the Ukkonen text searcher.
    /// Since Ukkonen's algorithm only builds an implicit
    /// search tree we need to represent the end of string explicitly.
    enum Token: Hashable, CustomStringConvertible {
        case element(Element)
        case end // Usually denoted by '$' in literature

        var description: String {
            switch self {
            case .element(let element): return "\(element)"
            case .end: return "$"
            }
        }
    }

    public init(text: [Element]) {
        var suffixTree = CompressedKeywordTree<Token>()
        let tokens = text.map(Token.element) + [Token.end]

        // Iterate phases, in every step i we build the suffix tree of text[...i]
        for prefix in tokens.prefixes.dropFirst() {
            assert(!prefix.isEmpty)
            for suffix in prefix.suffixes.dropLast() {
                assert(!suffix.isEmpty)
                suffixTree.extend(path: suffix.dropLast(), by: prefix.last!)
            }
        }

        textLength = text.count
        self.suffixTree = suffixTree
    }

    public func findAllOccurrences(of pattern: [Element]) -> [Int] {
        guard !pattern.isEmpty else { return Array(0..<textLength) }
        let tokens = pattern.map(Token.element)
        let depths = suffixTree[tokens]?.depthFirstSearchedDepths ?? []
        // Subtract suffix lengths from text to obtain the positions
        return depths.map { depth -> Int in
            let pathHeight = pattern.count + depth - 1 // subtract the $
            return textLength - pathHeight
        }.sorted()
    }
}
