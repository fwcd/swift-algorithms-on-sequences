/// An algorithm that finds all occurrences of a string (the pattern)
/// in another (the text). The matcher is initialized with a text
/// to allow the algorithm to preprocess the text.
public protocol TextSearcher {
    associatedtype Element

    /// Creates a new text searcher, possibly preprocessing the
    /// given text.
    /// 
    /// - Parameter text: The text to search
    init(text: [Element])

    /// Finds all occurrences of the given pattern in the text.
    /// 
    /// - Parameters:
    ///   - pattern: The pattern to search for
    /// - Returns: The indices at which the pattern occurs in the text
    func findAllOccurrences(of pattern: [Element]) -> [Int]
}
