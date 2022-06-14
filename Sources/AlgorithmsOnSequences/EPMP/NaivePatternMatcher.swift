/// The naive, quadratic time algorithm for finding
/// the pattern in the text.
public struct NaivePatternMatcher<Element>: ExactPatternMatcher where Element: Equatable {
    private let pattern: [Element]

    public init(pattern: [Element]) {
        self.pattern = pattern
    }

    public func findAllOccurrences(in text: [Element]) -> [Int] {
        guard !pattern.isEmpty else { return Array(text.indices) }
        guard pattern.count <= text.count else { return [] }

        var occurrences: [Int] = []

        search:
        for i in 0...(text.count - pattern.count) {
            for j in 0..<pattern.count {
                if text[i + j] != pattern[j] {
                    continue search
                }
            }
            occurrences.append(i)
        }

        return occurrences
    }
}
