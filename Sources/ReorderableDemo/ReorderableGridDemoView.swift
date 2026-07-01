import SwiftUI

/// Reorders the *same* `store.entries` inside a `LazyVGrid`, using the newly
/// expanded WWDC26 reorder API. Nothing here re-implements move semantics —
/// it drives the identical `ReorderableStore` used by the List demo.
public struct ReorderableGridDemoView: View {
    @Bindable private var store: ReorderableStore

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    public init(store: ReorderableStore) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(store.entries) { entry in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.title)
                            .font(.headline)
                        Text(entry.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
                .onMove { offsets, destination in
                    store.move(fromOffsets: offsets, toOffset: destination)
                }
            }
            .padding()
        }
        .navigationTitle("Grid")
    }
}
