public struct UkkonenTextSearcher<Element>: TextSearcher where Element: Hashable {
    private let suffixTree: CompressedKeywordTree<Element, [Int]>

    public init(text: [Element]) {
        suffixTree = CompressedKeywordTree()
        // TODO: Construct the tree
    }

    public func findAllOccurrences(of pattern: [Element]) -> [Int] {
        suffixTree[pattern]?.label ?? []
    }
}
