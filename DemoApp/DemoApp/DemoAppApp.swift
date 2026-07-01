import SwiftUI
import ReorderableDemo

/// The runnable consumer of the `ReorderableDemo` library.
///
/// This lives in a real, git-committed `.xcodeproj` (not a bare Swift Package
/// executable target) on purpose: running an SPM `.executableTarget` directly
/// as an iOS app via Xcode's "run a package on Simulator" convenience stores
/// the synthesized Bundle Identifier in a per-checkout, non-version-controlled
/// Xcode setting. That's exactly what caused a 100%-reproducible launch crash
/// in an earlier version of this repo:
///
///   `__BKSHIDEvent__BUNDLE_IDENTIFIER_FOR_CURRENT_PROCESS_IS_NIL__`
///   EXC_BREAKPOINT on com.apple.uikit.eventfetch-thread
///
/// A real `.xcodeproj` target has its Bundle Identifier written into
/// `project.pbxproj`, which is committed to git — so it's reproducible for
/// anyone who clones this repo, not just on the machine that first ran it.
@main
struct DemoAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
