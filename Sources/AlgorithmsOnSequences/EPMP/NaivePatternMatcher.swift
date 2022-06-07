/// The naive, quadratic time algorithm for finding
/// the pattern in the text.
public struct NaivePatternMatcher: ExactPatternMatcher {
    public static func findAllOccurrences<C>(of pattern: C, in text: C) -> [C.Index] where C: Collection, C.SubSequence: Equatable {
        var positions: [C.Index] = []
        for i in text.indices {
            if text[i..<text.index(i, offsetBy: pattern.count)] == pattern[...] {
                positions.append(i)
            }
        }
        return positions
    }
}
