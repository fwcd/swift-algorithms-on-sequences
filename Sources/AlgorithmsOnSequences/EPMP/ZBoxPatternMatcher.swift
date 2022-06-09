/// A linear time pattern matcher.
public struct ZBoxPatternMatcher: ExactPatternMatcher {
    public static func findAllOccurrences<Element>(of pattern: [Element], in text: [Element]) -> [Int] where Element: Equatable {
        // Concatenate pattern, boundary and text
        let tokens = pattern.map(Token.element) + [.boundary] + text.map(Token.element)

        // Compute Z-boxes by finding the longest common prefixes at each index with itself
        let lcps = findLongestCommonPrefixes(in: tokens)

        // Use Z-boxes to compute the actual occurrences
        return (0..<text.count)
            .filter { lcps[$0 + pattern.count + 1] == pattern.count }
    }

    private static func findLongestCommonPrefixes<C>(in text: C) -> [Int]
        where C: Collection,
              C.Element: Equatable {
        // TODO
        return []
    }
}

/// A token for use in the Z-Box algorithm.
private enum Token<Element> {
    case element(Element)
    case boundary
}

extension Token: Equatable where Element: Equatable {}
