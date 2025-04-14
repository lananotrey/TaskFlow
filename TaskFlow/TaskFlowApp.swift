import SwiftUI
import FirebaseCore
import FirebaseRemoteConfig

@main
struct TaskFlowApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen()
        }
    }
}
