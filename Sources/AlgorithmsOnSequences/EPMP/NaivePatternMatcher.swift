/// The naive, quadratic time algorithm for finding
/// the pattern in the text.
public struct NaivePatternMatcher: ExactPatternMatcher {
    public static func findAllOccurrences<C>(of pattern: C, in text: C) -> [C.Index]
        where C: Collection,
              C.Element: Equatable,
              C.Index: Strideable,
              C.Index.Stride: SignedInteger {
        var positions: [C.Index] = []
        search:
        for startIndex in text.startIndex..<text.index(text.endIndex, offsetBy: -pattern.count + 1) {
            var j = startIndex
            for i in pattern.indices {
                if pattern[i] != text[j] {
                    continue search
                }
                j = text.index(after: j)
            }
            positions.append(startIndex)
        }
        return positions
    }
}
