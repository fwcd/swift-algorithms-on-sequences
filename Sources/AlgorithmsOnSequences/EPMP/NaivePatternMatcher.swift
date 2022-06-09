/// The naive, quadratic time algorithm for finding
/// the pattern in the text.
public struct NaivePatternMatcher: ExactPatternMatcher {
    public static func findAllOccurrences<Element>(of pattern: [Element], in text: [Element]) -> [Int] where Element: Equatable {
        guard !pattern.isEmpty else { return Array(text.indices) }

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
