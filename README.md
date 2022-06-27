# Algorithms on Sequences for Swift

[![Build](https://github.com/fwcd/swift-algorithms-on-sequences/actions/workflows/build.yml/badge.svg)](https://github.com/fwcd/swift-algorithms-on-sequences/actions/workflows/build.yml)

An implementation of various string search algorithms for Swift.

## Overview

- Exact Pattern Matching Problem (EPMP)
  - [x] Naive algorithm (quadratic time)
  - [x] Z-Box algorithm (linear time)
  - [x] Boyer-Moore algorithm
  - [ ] Knuth-Morris-Pratt algorithm
  - [ ] Ukkonen's algorithm
- Exact Set Matching Problem (ESMP)
  - [x] Naive algorithm
  - [ ] Aho-Corasick algorithm

## Getting Started

- To build the package, make sure to have Swift 5.6 or newer installed and run `swift build`.
- To run the test suite, invoke `swift test`.
- To run the benchmarks, invoke `Scripts/run-benchmarks` and then `Scripts/plot-benchmarks` to plot them (make sure to have Python 3.9 or newer, `matplotlib`, `numpy` and `scipy` installed)
