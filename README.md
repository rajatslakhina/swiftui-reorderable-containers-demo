# SwiftUI Reorderable Containers — One Store, Two Containers

## The problem

WWDC26 shipped a genuinely new SwiftUI capability: drag-to-rearrange now works across `List`, `LazyVGrid`, and more — not just `List`, and it even reaches watchOS for the first time. Most write-ups stop at "here's the new modifier." What they don't show is the part that actually matters for a real app: how do you write the reorder *logic* once and drive multiple container types from it, instead of copy-pasting an `onMove`-style closure into every view that needs reordering?

That's the problem this repo solves.

## The design decision

The reorder logic lives in `ReorderableStore`, a plain `@Observable` class with zero SwiftUI view code in it. It owns the array, validates the move (bounds-checked, no-op guard for a same-index drop), and exposes a single `move(from:to:)` entry point plus an `IndexSet`-based adapter. Two views — `ReorderableListDemoView` and `ReorderableGridDemoView` — both bind to the *same* store instance and both route their reorder gesture through the *same* `move` function.

**Trade-off considered:** the store adds one layer of indirection compared to just inlining `@State private var items` and a `move` closure directly in each view. For a single-container demo that inline approach is fewer lines. It falls apart the moment you have a second container (or a second screen) that needs the same reordering behavior — you either duplicate the closure or refactor under pressure. Paying the indirection cost up front keeps the logic testable in isolation and reusable across containers without touching a single view.

**Alternative rejected:** putting `move(from:to:)` logic directly inside each view's reorder closure. Rejected because it can't be unit tested without a view host, and any bug fix has to be applied in every container that reorders the same kind of data.

## What's in here

- `Sources/ReorderableDemo/ReorderableStore.swift` — the observable store; no import of SwiftUI beyond `Observation`.
- `Sources/ReorderableDemo/ReorderableListDemoView.swift` — `List`-based reorder UI.
- `Sources/ReorderableDemo/ReorderableGridDemoView.swift` — `LazyVGrid`-based reorder UI using the same store.
- `Sources/ReorderableDemo/ContentView.swift` — a segmented control switching between the two, so you can see one store powering both.
- `Tests/ReorderableDemoTests/ReorderableStoreTests.swift` — move-to-start, move-to-end, move-through-middle, out-of-bounds guard, and no-op cases, all exercised without instantiating a single view.
- `DemoApp/DemoApp.xcodeproj` — a real, minimal Xcode project that hosts the library as a runnable app on Simulator (see "How to run it" and "Runtime crash found & fixed" below for why this exists as a separate `.xcodeproj` rather than a Swift Package executable target).

## How to run it

1. Open `DemoApp/DemoApp.xcodeproj` in Xcode (not `Package.swift` — see below for why).
2. Xcode resolves `ReorderableDemo` as a local Swift Package dependency automatically.
3. Select the `DemoApp` scheme, pick any iOS Simulator destination, and Build & Run.

## Runtime crash found & fixed

An earlier version of this repo shipped `ReorderableDemoApp` as a Swift Package `.executableTarget`, relying on Xcode's "run a package directly on Simulator" convenience to make it launchable. That crashed on every single launch, 100% reproducibly, verified three times in a real Xcode debug session:

```
failure in __BKSHIDEvent__BUNDLE_IDENTIFIER_FOR_CURRENT_PROCESS_IS_NIL__
(BKSHIDEvent.m:92) : missing bundleID for main bundle
EXC_BREAKPOINT on com.apple.uikit.eventfetch-thread
```

Root cause: that convenience stores the synthesized Bundle Identifier in a per-checkout Xcode setting that never gets committed to git — so it's inherently non-reproducible, and came back empty here. The fix was to replace it with `DemoApp/DemoApp.xcodeproj`, a real Xcode project with the Bundle Identifier written directly into `project.pbxproj` (committed, version-controlled, reproducible for anyone who clones this repo).

Honest verification status: the `.xcodeproj` was authored by hand (valid PBX object graph, balanced braces/parens checked programmatically) rather than through Xcode's project wizard, because driving Xcode's GUI reliably wasn't possible in this environment without risking interference with unrelated windows open on the same machine. It has **not** been confirmed to open and Build & Run cleanly in Xcode yet — that final check is worth doing before treating this as fully verified.

## Portfolio category

iOS Lead / Architect · Latest Concept (WWDC26 SwiftUI reorder API)

## Note

The reorder-gesture API surface should be checked against Apple's finalized WWDC26 documentation before shipping — the code here uses the established `onMove(perform:)` closure pattern applied to both `List` and `LazyVGrid` as the mechanism, since that's the pattern the WWDC26 coverage describes extending to more containers; Apple's final method name/signature may differ slightly. The store logic itself has no SwiftUI dependency and is written to be trivially testable regardless of which exact reorder API wires into it. A screen recording of the drag interaction on both container types would be a strong addition before treating this as fully "shipped" portfolio material.
