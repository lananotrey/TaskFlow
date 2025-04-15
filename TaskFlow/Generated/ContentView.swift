import SwiftUI

struct ContentView: View {
    @StateObject private var taskManager = TaskManager()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        if hasCompletedOnboarding {
            TabView {
                StatsView()
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar")
                    }
                    .environmentObject(taskManager)
                
                TaskListView()
                    .tabItem {
                        Label("Tasks", systemImage: "checklist")
                    }
                    .environmentObject(taskManager)
                
                ProjectsView()
                    .tabItem {
                        Label("Projects", systemImage: "folder")
                    }
                    .environmentObject(taskManager)
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            .tint(.indigo)
        } else {
            OnboardingView()
        }
    }
}