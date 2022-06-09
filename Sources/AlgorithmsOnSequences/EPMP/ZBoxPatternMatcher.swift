/*

/// A linear time pattern matcher.
public struct ZBoxPatternMatcher: ExactPatternMatcher {
    public static func findAllOccurrences<Element>(of pattern: [Element], in text: [Element]) -> [Int] where Element: Equatable {
        let prefixTokens = pattern.map(Token.element) + [.boundary]
        let tokens = prefixTokens + text.map(Token.element)
        let lcps = findLongestCommonPrefixes(in: tokens)

        var occurrences: [Int] = []
        var i: C.Index = prefixTokens.endIndex

        return occurrences
    }

    public static func findLongestCommonPrefixes<C>(in text: C) -> [C.SubSequence]
        where C: Collection,
              C.Element: Equatable {
        // TODO
    }
}

/// A token for use in the Z-Box algorithm.
private enum Token<Element> {
    case element(Element)
    case boundary
}

extension Token: Equatable where Element: Equatable {}

*/
