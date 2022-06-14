/// An efficient string search algorithm developed by Robert S. Boyer
/// and J Strother Moore in 1977 that preprocesses the pattern.
public struct BoyerMoorePatternMatcher<Element>: ExactPatternMatcher where Element: Equatable {
    private let pattern: [Element]

    public init(pattern: [Element]) {
        self.pattern = pattern
    }

    public func findAllOccurrences(in text: [Element]) -> [Int] {
        fatalError("TODO")
    }
}
