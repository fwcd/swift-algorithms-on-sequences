/// An algorithm that finds all occurrences of a string (the pattern)
/// in another (the text). The matcher is initialized with a text
/// to allow the algorithm to preprocess the text.
public protocol TextSearcher: _EPMPBenchmarkable {
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

/// Conformance to `_EPMPBenchmarkable`.
extension TextSearcher {
    public init(text1: [Element]) {
        self.init(text: text1)
    }

    public func findAllOccurrences(with text2: [Element]) -> [Int] {
        findAllOccurrences(of: text2)
    }

    public static func resolve(text1: [Element], text2: [Element]) -> (pattern: [Element], text: [Element]) {
        (pattern: text2, text: text1)
    }
}
