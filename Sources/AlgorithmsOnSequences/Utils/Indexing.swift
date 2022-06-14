/// A bidirectional mapping between a finite set of elements and integers.
public struct Indexing<Element>: Sequence where Element: Hashable {
    private let elementToIndex: [Element: Int]
    private let elements: [Element]

    /// Whether there are no elements. O(1).
    public var isEmpty: Bool { elements.isEmpty }
    /// The number of elements. O(1).
    public var count: Int { elements.count }

    /// Creates an indexing from the given elements. Duplicate elements
    /// are allowed, but will be skipped.
    /// 
    /// - Parameter elements: The elements to create an indexing from
    public init(_ elementsIncludingDuplicates: [Element]) {
        var elements: [Element] = []

        var elementToIndex: [Element: Int] = [:]
        for element in elementsIncludingDuplicates where !elementToIndex.keys.contains(element) {
            elementToIndex[element] = elementToIndex.count
            elements.append(element)
        }

        self.elements = elements
        self.elementToIndex = elementToIndex
    }

    /// Maps an element to an integer. O(1).
    public subscript(_ element: Element) -> Int {
        elementToIndex[element]!
    }

    /// Maps an integer to an element. O(1).
    public subscript(_ i: Int) -> Element {
        elements[i]
    }

    /// Checks whether this indexing contains the given element. O(1).
    /// 
    /// - Parameter element: The element to check for
    /// - Returns: Whether this indexing contains the element
    public func contains(_ element: Element) -> Bool {
        elementToIndex.keys.contains(element)
    }

    public func makeIterator() -> Dictionary<Element, Int>.Iterator {
        elementToIndex.makeIterator()
    }
}
