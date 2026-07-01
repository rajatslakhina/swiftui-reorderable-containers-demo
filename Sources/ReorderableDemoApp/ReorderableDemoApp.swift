import SwiftUI
import ReorderableDemo

/// The runnable consumer of the `ReorderableDemo` library — this is what
/// turns the package from "code you can build" into "a demo you can launch
/// on a Simulator." It intentionally contains no logic of its own: it just
/// hosts the library's `ContentView`, which already carries its own sample
/// data via `ReorderableStore.sampleData`.
@main
struct ReorderableDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
