extension Collection {
    /// The prefixes of this collection, including the empty subsequence.
    public var prefixes: [SubSequence] {
        (indices + [endIndex]).map { self[startIndex..<$0] }
    }

    /// The suffixes of this collection, including the empty subsequence.
    public var suffixes: [SubSequence] {
        (indices + [endIndex]).map { self[$0..<endIndex] }
    }
}
