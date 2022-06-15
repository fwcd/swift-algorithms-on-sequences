import ArgumentParser
import AlgorithmsOnSequences
import Foundation

@main
struct AlgorithmsOnSequencesBenchmarks: ParsableCommand {
    @Option(name: .shortAndLong, help: "The directory to place outputs in")
    var outputBaseDir: String = "./Output"

    func run() throws {
        try FileManager.default.createDirectory(atPath: outputBaseDir, withIntermediateDirectories: true)

        try benchmarkEPMP(type: NaivePatternMatcher.self)
        try benchmarkEPMP(type: ZBoxPatternMatcher.self)
        try benchmarkEPMP(type: BoyerMoorePatternMatcher.self)
    }

    private func benchmarkEPMP<M>(type: M.Type) throws
        where M: ExactPatternMatcher,
              M.Element == Character {
        let matcherName = String(describing: type).split(separator: "<")[0]

        print("[EPMP] Benchmarking \(matcherName)...")

        var results: [(patternLength: Int, textLength: Int, time: TimeInterval)] = []

        for m in stride(from: 1_000, through: 10_000, by: 1_000) {
            let pattern = Array(repeating: "ab", count: m).flatMap { $0 }
            let matcher = M.init(pattern: pattern)
            for n in stride(from: 1_000, through: 10_000, by: 1_000) {
                let text = Array(repeating: "ab", count: n).flatMap { $0 }
                let start = Date()
                _ = matcher.findAllOccurrences(in: text)
                results.append((
                    patternLength: pattern.count,
                    textLength: text.count,
                    time: -start.timeIntervalSinceNow
                ))
            }
        }

        let outputDir = "\(outputBaseDir)/EPMP"
        let outputPath = "\(outputDir)/\(matcherName).txt"
        let outputData = results.map { "\($0.patternLength);\($0.textLength);\($0.time)" }.joined(separator: "\n")

        try FileManager.default.createDirectory(atPath: outputDir, withIntermediateDirectories: true)
        try outputData.write(toFile: outputPath, atomically: false, encoding: .utf8)
    }
}
