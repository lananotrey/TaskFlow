import SwiftUI

struct ContentView: View {
    @StateObject private var taskManager = TaskManager()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                OnboardingView()
                    .transition(.opacity)
            } else {
                TabView(selection: $selectedTab) {
                    TaskListView(selectedTab: $selectedTab)
                        .tabItem {
                            Label("Tasks", systemImage: "checklist")
                        }
                        .tag(0)
                        .environmentObject(taskManager)
                    
                    ProjectsView()
                        .tabItem {
                            Label("Projects", systemImage: "folder")
                        }
                        .tag(1)
                        .environmentObject(taskManager)
                    
                    StatsView()
                        .tabItem {
                            Label("Stats", systemImage: "chart.bar")
                        }
                        .tag(2)
                        .environmentObject(taskManager)
                    
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                        .tag(3)
                }
                .tint(.indigo)
                .preferredColorScheme(isDarkMode ? .dark : .light)
            }
        }
        .animation(.easeInOut, value: hasCompletedOnboarding)
    }
}