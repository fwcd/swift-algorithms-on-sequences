/// An algorithm that finds all occurrences of a
/// string (the pattern) in another (the text).
public protocol ExactPatternMatcher {
    /// Finds all occurrences of the given pattern in the given text.
    /// 
    /// - Parameters:
    ///   - pattern: The pattern to search for
    ///   - text: The sequence to search in
    /// - Returns: The indices at which the pattern occurs in the text
    static func findAllOccurrences<C>(of pattern: C, in text: C) -> [C.Index]
        where C: Collection,
              C.Element: Equatable,
              C.Index: Strideable,
              C.Index.Stride: SignedInteger
}
