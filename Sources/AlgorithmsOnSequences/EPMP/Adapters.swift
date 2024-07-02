/// An adapter that wraps a TextSearcher in a PatternMatcher-conforming
/// type. Note that this may negate the performance benefit of
/// preprocessing the text.
public struct TextSearcherPatternMatcher<Wrapped>: PatternMatcher where Wrapped: TextSearcher {
    public typealias Element = Wrapped.Element

    private let pattern: [Wrapped.Element]

    public init(pattern: [Wrapped.Element]) {
        self.pattern = pattern
    }

    public func findAllOccurrences(in text: [Wrapped.Element]) -> [Int] {
        Wrapped(text: text).findAllOccurrences(of: pattern)
    }
}

/// An adapter that wraps a PatternMatcher in a TextSearcher-conforming
/// type. Note that this may negate the performance benefit of
/// preprocessing the text.
public struct PatternMatcherTextSearcher<Wrapped>: TextSearcher where Wrapped: PatternMatcher {
    public typealias Element = Wrapped.Element

    private let text: [Wrapped.Element]

    public init(text: [Wrapped.Element]) {
        self.text = text
    }

    public func findAllOccurrences(of pattern: [Wrapped.Element]) -> [Int] {
        Wrapped(pattern: pattern).findAllOccurrences(in: text)
    }
}

extension TextSearcher {
    public typealias PatternMatcher = TextSearcherPatternMatcher<Self>
}

extension PatternMatcher {
    public typealias TextSearcher = PatternMatcherTextSearcher<Self>
}
