/// An efficient string search algorithm developed by Robert S. Boyer
/// and J Strother Moore in 1977 that preprocesses the pattern.
public struct BoyerMoorePatternMatcher<Element>: PatternMatcher where Element: Hashable {
    private let pattern: [Element]
    private let patternIndexing: Indexing<Element>
    private let badCharacterTable: Matrix<Int>
    private let longestCommonSuffixes: [Int]
    private let longestCommonBorders: [Int]
    private let rightmostCopyTable: [Int]

    public init(pattern: [Element]) {
        // Generate indexings
        let patternIndexing = Indexing(pattern)

        // Generate bad character table
        // First index (row): character in alphabet (see indexing scheme above)
        // Second index (col): index in the pattern
        var badCharacterTable = Matrix(height: patternIndexing.count, width: pattern.count, element: 0)
        for (element, i) in patternIndexing {
            for j in 0..<pattern.count {
                // Find first occurrence of element to the left of j
                var shift = 1
                while j - shift >= 0 && pattern[j - shift] != element {
                    shift += 1
                }
                badCharacterTable[i, j] = shift
            }
        }

        // Common longest common suffixes and borders of the pattern with itself in O(n)
        let longestCommonSuffixes = pattern.longestCommonSuffixes
        let longestCommonBorders = pattern.longestCommonBorders

        // Compute rightmost copy table for good suffix rule
        var rightmostCopyTable = Array(repeating: 0, count: pattern.count)
        for j in 0..<pattern.count {
            let lcs = longestCommonSuffixes[j]
            if lcs > 0 {
                rightmostCopyTable[pattern.count - lcs] = j
            }
        }

        self.pattern = pattern
        self.patternIndexing = patternIndexing
        self.badCharacterTable = badCharacterTable
        self.longestCommonSuffixes = longestCommonSuffixes
        self.longestCommonBorders = longestCommonBorders
        self.rightmostCopyTable = rightmostCopyTable
    }

    public func findAllOccurrences(in text: [Element]) -> [Int] {
        guard !pattern.isEmpty else { return Array(text.indices) }
        guard pattern.count <= text.count else { return [] }

        var k = pattern.count - 1
        var occurrences: [Int] = []

        // Search the text
        // Note: In Boyer-Moore we scan the pattern backwards
        search:
        while k < text.count {
            var i = pattern.count - 1
            var h = k

            while i >= 0 && pattern[i] == text[h] {
                i -= 1
                h -= 1
            }

            if i < 0 {
                // We found an occurrence
                occurrences.append(k - pattern.count + 1)
                if longestCommonBorders.count > 1 {
                    k += pattern.count - longestCommonBorders[1]
                } else {
                    k += 1
                }
            } else {
                // Shift k according to max of bad character and good suffix shift
                let badCharacterShift = patternIndexing.index(for: text[h]).map { badCharacterTable[$0, i] } ?? i - 1
                let goodSuffixShift: Int
                if i == pattern.count - 1 {
                    // Did not match at all
                    goodSuffixShift = 1
                } else {
                    let rmc = rightmostCopyTable[i + 1]
                    if rmc > 0 {
                        goodSuffixShift = pattern.count - rmc - 1
                    } else {
                        goodSuffixShift = pattern.count - longestCommonBorders[i + 1]
                    }
                }
                k += max(badCharacterShift, goodSuffixShift)
            }
        }

        return occurrences
    }
}
