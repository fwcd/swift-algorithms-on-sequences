/// An algorithm that finds all occurrences of a string (the pattern)
/// in another (the text). The matcher is initialized with a pattern
/// to allow the algorithm to preprocess the pattern.
public protocol PatternMatcher {
    associatedtype Element

    /// Creates a new pattern matcher, possibly preprocessing the
    /// given pattern.
    /// 
    /// - Parameter pattern: The pattern to search for
    init(pattern: [Element])

    /// Finds all occurrences of the pattern in the given text.
    /// 
    /// - Parameters:
    ///   - text: The sequence to search in
    /// - Returns: The indices at which the pattern occurs in the text
    func findAllOccurrences(in text: [Element]) -> [Int]
}
