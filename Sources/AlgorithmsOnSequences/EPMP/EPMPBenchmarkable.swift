/// A generic protocol for EPMP implementations that preprocess
/// either the pattern or the text. This protocol is only intended
/// for testing purposes.
/// 
/// This protocol should be considered an implementation detail,
/// clients of the library should use the (more expressive)
/// `PatternMatcher` and `TextSearcher` protocols instead.
public protocol _EPMPBenchmarkable {
    associatedtype Element

    init(text1: [Element])

    func findAllOccurrences(with text2: [Element]) -> [Int]

    static func resolve(text1: [Element], text2: [Element]) -> (pattern: [Element], text: [Element])
}
