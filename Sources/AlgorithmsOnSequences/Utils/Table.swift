/// A 2D array that, in contrast to `[[Element]]`, only uses a single
/// flat array as underlying store.
public struct Table<Element> {
    /// The flat representation of the elements.
    public private(set) var elements: [Element]
    /// The width of the table.
    public private(set) var width: Int
    /// The height of the table.
    public private(set) var height: Int

    init(width: Int, _ elements: [Element]) {
        assert(elements.count % width == 0)
        self.elements = elements
        self.width = width
        self.height = elements.count / width
    }

    init(height: Int, width: Int, element: Element) {
        elements = Array(repeating: element, count: height * width)
        self.width = width
        self.height = height
    }

    private func index(_ i: Int, _ j: Int) -> Int {
        i * width + j
    }

    subscript(_ i: Int, _ j: Int) -> Element {
        get { elements[index(i, j)] }
        set { elements[index(i, j)] = newValue }
    }
}
