import SwiftUI

@main
struct ControlHubApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // No main window — just menu bar
        Settings {
            EmptyView()
        }
    }
}
