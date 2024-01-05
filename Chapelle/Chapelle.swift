import SwiftUI

@main
struct Chapelle: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        #if os(xrOS)
        ImmersiveSpace(id: "ImmersiveWebcam") {
            ImmersiveWebcamView()
        }
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
        #endif
    }
}
