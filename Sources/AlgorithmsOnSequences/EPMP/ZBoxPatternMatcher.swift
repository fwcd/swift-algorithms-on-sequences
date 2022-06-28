/// A linear time pattern matcher.
public struct ZBoxPatternMatcher<Element>: PatternMatcher where Element: Equatable {
    private let pattern: [Element]

    public init(pattern: [Element]) {
        self.pattern = pattern
    }

    public func findAllOccurrences(in text: [Element]) -> [Int] {
        guard pattern.count <= text.count else { return [] }

        // Concatenate pattern, boundary and text
        let tokens = pattern.map(Token.element) + [.boundary] + text.map(Token.element)

        // Compute lcps (Z-Boxes) by finding the longest common prefixes at each index with itself
        let lcps = tokens.longestCommonPrefixes

        // Use the lcps (Z-Boxes) to compute the actual occurrences
        return (0..<text.count)
            .filter { lcps[$0 + pattern.count + 1] == pattern.count }
    }
}

/// A token for use in the Z-Box algorithm.
private enum Token<Element> {
    case element(Element)
    case boundary
}

extension Token: Equatable where Element: Equatable {}
