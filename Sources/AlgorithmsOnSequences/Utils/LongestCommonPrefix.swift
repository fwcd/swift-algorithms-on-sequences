extension Collection where Element: Equatable {
    /// Computes the length of the longest common prefix
    /// with the given sequence.
    ///
    /// - Parameter rhs: The sequence to compare against.
    /// - Returns: The longest common prefix.
    public func longestCommonPrefix(_ rhs: Self) -> SubSequence {
        var end = startIndex
        for (i, j) in zip(indices, rhs.indices) {
            if self[i] != rhs[j] {
                return self[..<i]
            }
            end = index(after: end)
        }
        return self[..<end]
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

// MARK: Efficient Z-algorithm implementation of longest common prefixes

extension Collection where Element: Equatable, Index == Int {
    /// The longest common prefixes of every suffix with the text itself
    /// (i.e. the Z-Boxes).
    /// 
    /// - Returns: The longest common prefixes of every suffix with the text itself
    public var longestCommonPrefixes: [Int] {
        guard !isEmpty else { return [] }

        // The lcp of the text with the first suffix (itself) is its own length
        var lcps: [Int] = [count]
        var window: Range<Int> = 0..<0
        
        // Compute the lcps using a dynamic programming-esque approach -
        // every iteration uses the lcps up to (but not including) i.
        for i in 1..<count {
            if i > window.endIndex {
                // We are past our window, search explicitly
                var k = 0
                while i + k < count && self[k] == self[i + k] {
                    k += 1
                }
                lcps.append(k)
                window = i..<(i + k)
            } else {
                // Reuse previous information (this is the crucial trick of this algorithm,
                // if we were to search explicitly in every iteration like in the if-branch
                // we would have quadratic run time, thereby not really improving over the
                // naive algorithm).
                let remaining = window.endIndex - i
                if i - window.startIndex < lcps.count && lcps[i - window.startIndex] < remaining {
                    // The corresponding lcp at the beginning is smaller than the remaining
                    // part of the window, reuse it (we don't need to update the window in
                    // this case either)
                    lcps.append(lcps[i - window.startIndex])
                } else {
                    // Search explicitly past the window
                    var q = 0
                    while window.endIndex + q < count && self[remaining + q] == self[window.endIndex + q] {
                        q += 1
                    }
                    let k = remaining + q
                    lcps.append(k)
                    window = i..<(i + k)
                }
            }
        }

        return lcps
    }

    /// The longest common suffixes of every prefix with the text itself.
    /// 
    /// - Returns: The longest common suffixes of every prefix with the text itself
    public var longestCommonSuffixes: [Int] {
        reversed().longestCommonPrefixes.reversed()
    }

    /// The longest common borders of the text with every suffix of itself.
    /// 
    /// - Returns: The longest common borders of the text with every suffix of itself
    public var longestCommonBorders: [Int] {
        let lcss = longestCommonSuffixes
        var lcbs: [Int] = Array(repeating: 0, count: count)
        var maxK = 0

        for k in 0..<lcbs.count {
            let lcs = lcss[k]
            if k == lcs - 1 {
                maxK = Swift.max(maxK, lcs)
            }
            lcbs[lcbs.count - 1 - k] = maxK
        }

        return lcbs
    }
}
