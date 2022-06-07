/// A linear time pattern matcher.
public struct ZBoxPatternMatcher: ExactPatternMatcher {
    public static func findAllOccurrences<C>(of pattern: C, in text: C) -> [C.Index]
        where C: Collection,
              C.Element: Equatable {
        // TODO
        return []
    }
}
