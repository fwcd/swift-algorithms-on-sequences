/// The Knuth-Morris-Pratt linear-time string search algorithm.
/// See https://en.wikipedia.org/wiki/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm
public struct KnuthMorrisPrattPatternMatcher<Element>: ExactPatternMatcher where Element: Hashable {
    private let pattern: [Element]
    /* internal for testing */ let partialMatchTable: [Int]

    public init(pattern: [Element]) {
        self.pattern = pattern

        // Build KMP partial-match table by "pre-searching" the pattern for itself.

        var partialMatchTable: [Int] = []

        if !pattern.isEmpty {
            partialMatchTable.reserveCapacity(pattern.count + 1)
            partialMatchTable.append(-1)

            // Index of next character of current candidate substring in pattern.
            var candidate = 0

            for element in pattern.dropFirst() {
                if element == pattern[candidate] {
                    partialMatchTable.append(partialMatchTable[candidate])
                } else {
                    partialMatchTable.append(candidate)
                    while candidate >= 0 && element != pattern[candidate] {
                        candidate = partialMatchTable[candidate]
                    }
                }
                candidate += 1
            }

            // Only needed when all word occurrences are searched
            partialMatchTable.append(candidate)

            assert(
                partialMatchTable.count == pattern.count + 1,
                "Expected partial match table of size \(pattern.count + 1), but was \(partialMatchTable.count)"
            )
        }

        self.partialMatchTable = partialMatchTable
    }

    public func findAllOccurrences(in text: [Element]) -> [Int] {
        guard !pattern.isEmpty else { return Array(text.indices) }

        var occurrences: [Int] = []
        var i = 0 // Position within the text
        var j = 0 // Position within the pattern

        while i < text.count {
            if text[i] == pattern[j] {
                i += 1
                j += 1
                if j == pattern.count {
                    // Occurrence found, jump to next partial match position (as computed in table)
                    occurrences.append(i - pattern.count)
                    j = partialMatchTable[j]
                }
            } else {
                j = partialMatchTable[j]
                if j < 0 {
                    i += 1
                    j += 1
                }
            }
        }

        return occurrences
    }
}
