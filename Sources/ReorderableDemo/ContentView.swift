import SwiftUI

/// Entry point for the demo: one `ReorderableStore` instance, two container
/// types switched via a segmented control. Reordering in either tab mutates
/// the same underlying data — proof the logic isn't duplicated per-container.
public struct ContentView: View {
    private enum Container: String, CaseIterable, Identifiable {
        case list = "List"
        case grid = "Grid"
        var id: String { rawValue }
    }

    @State private var selected: Container = .list
    private let store: ReorderableStore

    public init(store: ReorderableStore = .sampleData) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Container", selection: $selected) {
                    ForEach(Container.allCases) { container in
                        Text(container.rawValue).tag(container)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                switch selected {
                case .list:
                    ReorderableListDemoView(store: store)
                case .grid:
                    ReorderableGridDemoView(store: store)
                }
            }
            .navigationTitle("Reorderable Containers")
        }
    }
}

extension ReorderableStore {
    /// Sample data so the demo runs standalone with no setup.
    public static var sampleData: ReorderableStore {
        ReorderableStore(entries: [
            ReorderableEntry(title: "Architecture Review", subtitle: "Due Monday"),
            ReorderableEntry(title: "System Design Doc", subtitle: "In review"),
            ReorderableEntry(title: "Memory Profiling Pass", subtitle: "Blocked"),
            ReorderableEntry(title: "Low-Level Design Spike", subtitle: "Not started"),
            ReorderableEntry(title: "Performance Benchmarking", subtitle: "Scheduled")
        ])
    }
}
