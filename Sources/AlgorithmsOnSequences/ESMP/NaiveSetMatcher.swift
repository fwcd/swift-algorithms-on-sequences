/// The naive, quadratic time algorithm for finding
/// the patterns in the text.
public struct NaiveSetMatcher<Element>: SetMatcher where Element: Hashable & Comparable {
    private let tree: KeywordTree<Bool, Element>

    public init(patterns: Set<[Element]>) {
        tree = KeywordTree(paths: patterns)
    }

    public func findAllOccurrences(in text: [Element]) -> [Int] {
        var occurrences: [Int] = []

        for i in 0..<text.count {
            var node: KeywordTree<Bool, Element> = tree
            var j = i
            while j < text.count, !node.label, let child = node[text[j]] {
                node = child
                j += 1
            }
            if node.label {
                occurrences.append(i)
            }
        }

        return occurrences
    }
}
