/// A bidirectional mapping between a finite set of elements and integers.
public struct Indexing<Element> where Element: Hashable {
    private let elementToIndex: [Element: Int]
    private let elements: [Element]

    /// Creates an indexing from the given elements. Duplicate elements
    /// are allowed, but will be skipped.
    /// 
    /// - Parameter elements: The elements to create an indexing from
    public init(_ elements: [Element]) {
        var elementToIndex: [Element: Int] = [:]
        for element in elements where !elementToIndex.keys.contains(element) {
            elementToIndex[element] = elementToIndex.count
        }

        self.elements = elements
    }

    /// Maps an element to an integer.
    public subscript(_ element: Element) -> Int {
        elementToIndex[element]!
    }

    /// Maps an integer to an element.
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
}
