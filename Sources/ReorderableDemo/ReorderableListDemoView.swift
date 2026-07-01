import SwiftUI

/// Reorders `store.entries` inside a `List`, using WWDC26's expanded reorder
/// support. All of the actual move logic lives in `ReorderableStore` — this
/// view only wires the gesture to `store.move`.
public struct ReorderableListDemoView: View {
    @Bindable private var store: ReorderableStore

    public init(store: ReorderableStore) {
        self.store = store
    }

    public var body: some View {
        List {
            ForEach(store.entries) { entry in
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.title)
                        .font(.headline)
                    Text(entry.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .onMove { offsets, destination in
                store.move(fromOffsets: offsets, toOffset: destination)
            }
        }
        .listStyle(.plain)
        .navigationTitle("List")
    }
}
