/// A 2D array that, in contrast to `[[Element]]`, only uses a single
/// flat array as underlying store.
public struct Matrix<Element> {
    /// The flat representation of the elements.
    public private(set) var elements: [Element]
    /// The width of the table.
    public private(set) var width: Int
    /// The height of the table.
    public private(set) var height: Int

    public init(width: Int, _ elements: [Element]) {
        assert((width == 0 && elements.isEmpty) || (elements.count % width == 0))
        self.elements = elements
        self.width = width
        self.height = elements.isEmpty ? 0 : elements.count / width
    }

    public init(height: Int, width: Int, element: Element) {
        elements = Array(repeating: element, count: height * width)
        self.width = width
        self.height = height
    }

    private func index(_ i: Int, _ j: Int) -> Int {
        i * width + j
    }

    public subscript(_ i: Int, _ j: Int) -> Element {
        get { elements[index(i, j)] }
        set { elements[index(i, j)] = newValue }
    }
}
