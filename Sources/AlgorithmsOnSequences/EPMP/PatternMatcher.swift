/// An algorithm that finds all occurrences of a string (the pattern)
/// in another (the text). The matcher is initialized with a pattern
/// to allow the algorithm to preprocess the pattern.
public protocol PatternMatcher: _EPMPBenchmarkable {
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

/// Conformance to `_EPMPBenchmarkable`.
extension PatternMatcher {
    public init(text1: [Element]) {
        self.init(pattern: text1)
    }

    public func findAllOccurrences(with text2: [Element]) -> [Int] {
        findAllOccurrences(in: text2)
    }

    public static func resolve(text1: [Element], text2: [Element]) -> (pattern: [Element], text: [Element]) {
        (pattern: text1, text: text2)
    }
}
