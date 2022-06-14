/// A linear time pattern matcher.
public struct ZBoxPatternMatcher<Element>: ExactPatternMatcher where Element: Equatable {
    private let pattern: [Element]

    public init(pattern: [Element]) {
        self.pattern = pattern
    }

    public func findAllOccurrences(in text: [Element]) -> [Int] {
        // Concatenate pattern, boundary and text
        let tokens = pattern.map(Token.element) + [.boundary] + text.map(Token.element)

        // Compute lcps (Z-Boxes) by finding the longest common prefixes at each index with itself
        let lcps = ZBoxUtils.findLongestCommonPrefixes(in: tokens)

        // Use the lcps (Z-Boxes) to compute the actual occurrences
        return (0..<text.count)
            .filter { lcps[$0 + pattern.count + 1] == pattern.count }
    }
}

public enum ZBoxUtils {
    /// Finds the longest common prefixes of every suffix with the text itself
    /// (i.e. computes the Z-Boxes).
    /// 
    /// - Parameter text: The text to use
    /// - Returns: The longest common prefixes of every suffix with the text itself
    public static func findLongestCommonPrefixes<Element>(in text: [Element]) -> [Int] where Element: Equatable {
        // The lcp of the text with the first suffix (itself) is its own length
        var lcps: [Int] = [text.count]
        var window: Range<Int> = 0..<0
        
        // Compute the lcps using a dynamic programming-esque approach -
        // every iteration uses the lcps up to (but not including) i.
        for i in 1..<text.count {
            if i > window.endIndex {
                // We are past our window, search explicitly
                var k = 0
                while i + k < text.count && text[k] == text[i + k] {
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
                    while window.endIndex + q < text.count && text[remaining + q] == text[window.endIndex + q] {
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

    /// Finds the longest common suffix of every prefix with the text itself.
    public static func findLongestCommonSuffixes<Element>(in text: [Element]) -> [Int] where Element: Equatable {
        findLongestCommonPrefixes(in: text.reversed()).reversed()
    }
}

/// A token for use in the Z-Box algorithm.
private enum Token<Element> {
    case element(Element)
    case boundary
}

extension Token: Equatable where Element: Equatable {}
