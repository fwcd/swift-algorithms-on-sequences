extension Collection where Element: Equatable {
    /// Computes the length of the longest common prefix
    /// with the given sequence.
    ///
    /// - Parameter rhs: The sequence to compare against.
    /// - Returns: The longest common prefix.
    public func longestCommonPrefix(_ rhs: Self) -> SubSequence {
        for (i, j) in zip(indices, rhs.indices) {
            if self[i] != rhs[j] {
                return self[..<i]
            }
        }
        return self[...]
    }

    /// Computes the length of the longest common prefix
    /// with the prefix starting at the given index.
    ///
    /// - Parameter index: The starting index in this sequence.
    /// - Returns: The longest common prefix.
    public func longestCommonPrefix(_ index: Index) -> SubSequence {
        self[...].longestCommonPrefix(self[index...])
    }
}
