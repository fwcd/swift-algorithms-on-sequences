/// An algorithm that finds all occurrences of multiple strings
/// (patterns) in a text. The matcher is initialized with the
/// set to allow preprocessing.
public protocol SetMatcher {
    associatedtype Element: Hashable

    /// Creates a new set matcher, possibly preprocessing
    /// the given patterns.
    /// 
    /// - Parameter patterns: The patterns to search for
    init(patterns: Set<[Element]>)

    /// Finds all occurrences of any pattern in the given
    /// text.
    /// 
    /// - Parameter text: The text to search in
    /// - Returns: The indices at which any pattern from the set occurs
    func findAllOccurrences(in text: [Element]) -> [Int]
}
