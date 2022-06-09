/// A linear time pattern matcher.
public struct ZBoxPatternMatcher: ExactPatternMatcher {
    public static func findAllOccurrences<Element>(of pattern: [Element], in text: [Element]) -> [Int] where Element: Equatable {
        // Concatenate pattern, boundary and text
        let tokens = pattern.map(Token.element) + [.boundary] + text.map(Token.element)

        // Compute lcps (Z-boxes) by finding the longest common prefixes at each index with itself
        let lcps = findLongestCommonPrefixes(in: tokens)

        // Use the lcps (Z-boxes) to compute the actual occurrences
        return (0..<text.count)
            .filter { lcps[$0 + pattern.count + 1] == pattern.count }
    }

    /// Finds the longest common prefixes of every suffix with the text itself
    /// (i.e. computes the Z-boxes).
    /// 
    /// - Parameter text: The text to use
    /// - Returns: The longest common prefixes of every suffix with the text itself
    private static func findLongestCommonPrefixes<Element>(in text: [Element]) -> [Int] where Element: Equatable {
        // The lcp of the text with the first suffix (itself) is its own length
        var lcps: [Int] = [text.count]
        var l = 0
        var r = text.count - 1
        
        // Compute the lcps using a dynamic programming-esque approach -
        // every iteration uses the lcps up to (but not including) i.
        for i in 1..<text.count {
            // TODO: This is currently quadratic, refactor to include to central trick
            var k = 0
            while i + k < text.count && text[k] == text[i + k] {
                k += 1
            }
            lcps.append(k)
            l = i + 1
            r = i + k
        }

        return lcps
    }
}

/// A token for use in the Z-Box algorithm.
private enum Token<Element> {
    case element(Element)
    case boundary
}

extension Token: Equatable where Element: Equatable {}
