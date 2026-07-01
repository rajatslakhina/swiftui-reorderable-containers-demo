import XCTest
@testable import ReorderableDemo

final class ReorderableStoreTests: XCTestCase {

    private func makeStore(count: Int = 5) -> ReorderableStore {
        let entries = (0..<count).map { i in
            ReorderableEntry(title: "Item \(i)", subtitle: "")
        }
        return ReorderableStore(entries: entries)
    }

    func testMoveToStart() {
        let store = makeStore()
        store.move(from: 3, to: 0)
        XCTAssertEqual(store.entries.map(\.title), ["Item 3", "Item 0", "Item 1", "Item 2", "Item 4"])
    }

    func testMoveToEnd() {
        let store = makeStore()
        store.move(from: 0, to: 5) // destination == count, meaning "after last"
        XCTAssertEqual(store.entries.map(\.title), ["Item 1", "Item 2", "Item 3", "Item 4", "Item 0"])
    }

    func testMoveThroughMiddle() {
        let store = makeStore()
        store.move(from: 1, to: 3)
        XCTAssertEqual(store.entries.map(\.title), ["Item 0", "Item 2", "Item 1", "Item 3", "Item 4"])
    }

    func testOutOfBoundsSourceIsIgnored() {
        let store = makeStore()
        store.move(from: 99, to: 0)
        XCTAssertEqual(store.entries.map(\.title), ["Item 0", "Item 1", "Item 2", "Item 3", "Item 4"])
    }

    func testOutOfBoundsDestinationIsIgnored() {
        let store = makeStore()
        store.move(from: 0, to: 99)
        XCTAssertEqual(store.entries.map(\.title), ["Item 0", "Item 1", "Item 2", "Item 3", "Item 4"])
    }

    func testNoOpMoveIsIgnored() {
        let store = makeStore()
        store.move(from: 2, to: 2)
        XCTAssertEqual(store.entries.map(\.title), ["Item 0", "Item 1", "Item 2", "Item 3", "Item 4"])
    }

    func testIndexSetAdapterOnlyAcceptsSingleElementMoves() {
        let store = makeStore()
        store.move(fromOffsets: [0, 1], toOffset: 4) // multi-select move: unsupported here, must no-op
        XCTAssertEqual(store.entries.map(\.title), ["Item 0", "Item 1", "Item 2", "Item 3", "Item 4"])
    }
}
