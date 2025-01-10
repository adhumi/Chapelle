import SwiftUI

@main
struct Chapelle: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
#if os(macOS)
        .windowToolbarStyle(.unified(showsTitle: true))
        .windowStyle(.hiddenTitleBar)
#endif
    }
}
