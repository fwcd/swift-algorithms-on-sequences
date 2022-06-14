/// An efficient string search algorithm developed by Robert S. Boyer
/// and J Strother Moore in 1977 that preprocesses the pattern.
public struct BoyerMoorePatternMatcher<Element>: ExactPatternMatcher where Element: Equatable {
    private let pattern: [Element]

    public init(pattern: [Element]) {
        self.pattern = pattern
    }

    public func findAllOccurrences(in text: [Element]) -> [Int] {
        guard !pattern.isEmpty else { return Array(text.indices) }
        guard pattern.count <= text.count else { return [] }

        var occurrences: [Int] = []

        search:
        for i in (pattern.count - 1)..<text.count {
            for j in 0..<pattern.count {
                if text[i - j] != pattern[pattern.count - 1 - j] {
                    continue search
                }
            }
            occurrences.append(i - pattern.count + 1)
        }

        return occurrences
    }
}
