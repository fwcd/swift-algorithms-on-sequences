/// An efficient string search algorithm developed by Robert S. Boyer
/// and J Strother Moore in 1977 that preprocesses the pattern.
public struct BoyerMoorePatternMatcher<Element>: ExactPatternMatcher where Element: Hashable {
    private let pattern: [Element]
    private let patternIndexing: Indexing<Element>
    private let badCharacterTable: Table<Int>

    public init(pattern: [Element]) {
        // Generate indexings
        let patternIndexing = Indexing(pattern)

        // Generate bad character table
        // First index (row): character in alphabet (see indexing scheme above)
        // Second index (col): index in the pattern
        var badCharacterTable = Table(height: patternIndexing.count, width: pattern.count, element: 0)
        for (element, i) in patternIndexing {
            for j in 0..<pattern.count {
                // Find first occurrence of element to the left of j
                var shift = 1
                while j >= shift && pattern[j - shift] != element {
                    shift += 1
                }
                badCharacterTable[i, j] = shift
            }
        }

        self.pattern = pattern
        self.patternIndexing = patternIndexing
        self.badCharacterTable = badCharacterTable
    }

    public func findAllOccurrences(in text: [Element]) -> [Int] {
        guard !pattern.isEmpty else { return Array(text.indices) }
        guard pattern.count <= text.count else { return [] }

        var i = pattern.count - 1
        var occurrences: [Int] = []

        // Search the text
        // Note: In Boyer-Moore we scan the pattern backwards
        search:
        while i < text.count {
            for j in 0..<pattern.count {
                let textIndex = i - j
                let patternIndex = pattern.count - 1 - j
                let textElement = text[textIndex]
                let patternElement = pattern[patternIndex]

                if textElement != patternElement {
                    // Bad character rule
                    i += badCharacterTable[patternIndexing[patternElement], patternIndex]
                    continue search
                }
            }
            occurrences.append(i - pattern.count + 1)
            i += 1
        }

        return occurrences
    }
}
