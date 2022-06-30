public struct UkkonenTextSearcher<Element>: TextSearcher where Element: Hashable {
    private let textLength: Int
    /* internal for testing */ let suffixTree: CompressedKeywordTree<Element>

    public init(text: [Element]) {
        var suffixTree = CompressedKeywordTree<Element>()

        // Iterate phases, in every step i we build the suffix tree of text[...i]
        for prefix in text.prefixes.dropFirst() {
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
        let depths = suffixTree[pattern]?.depthFirstSearchedDepths ?? []
        // Subtract suffix lengths from text to obtain the positions
        return depths.map { textLength - $0 - pattern.count }.sorted()
    }
}
