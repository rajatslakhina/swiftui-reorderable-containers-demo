import Foundation
import Observation

/// A single item shown in either a `List` or a `LazyVGrid` reorder demo.
public struct ReorderableEntry: Identifiable, Equatable, Sendable {
    public let id: UUID
    public var title: String
    public var subtitle: String

    public init(id: UUID = UUID(), title: String, subtitle: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
    }
}

/// Owns the reorder logic for a collection of `ReorderableEntry` values.
///
/// Deliberately has no import of SwiftUI: this type can be unit tested without
/// standing up a view hierarchy, and the same instance can back any number of
/// container views (List, LazyVGrid, ...) without duplicating the move logic.
@Observable
public final class ReorderableStore {

    public private(set) var entries: [ReorderableEntry]

    public init(entries: [ReorderableEntry]) {
        self.entries = entries
    }

    /// Moves the entry at `source` to `destination`.
    ///
    /// Mirrors the semantics SwiftUI's reorder APIs expect: `destination` is
    /// the index the item should land at *after* removal, matching
    /// `Array.move(fromOffsets:toOffset:)` for a single-element move.
    /// Out-of-bounds or no-op moves are ignored rather than trapping, since
    /// this is driven by live drag gestures where a stale index is possible.
    public func move(from source: Int, to destination: Int) {
        guard entries.indices.contains(source) else { return }
        guard destination >= 0, destination <= entries.count else { return }
        guard source != destination else { return }

        let entry = entries.remove(at: source)
        let adjustedDestination = destination > source ? destination - 1 : destination
        entries.insert(entry, at: adjustedDestination)
    }

    /// Adapter for the `IndexSet`-based `onMove` signature some containers
    /// still expose, so both the newer per-index reorder API and the older
    /// `onMove(perform:)` closure can drive the same store.
    public func move(fromOffsets offsets: IndexSet, toOffset destination: Int) {
        guard let source = offsets.first, offsets.count == 1 else { return }
        move(from: source, to: destination)
    }
}
