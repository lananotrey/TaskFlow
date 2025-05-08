import SwiftUI

struct LocalStorage {
    static let shared = LocalStorage()
    
    @AppStorage("APP_LINK") var savedLink = ""
    @AppStorage("FIRST_LAUNCH") var isFirstLaunch = true
    
    // MARK: - Tasks and Projects Storage
    
    func saveTasks(_ tasks: [TaskTask]) {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "SAVED_TASKS")
        }
    }
    
    func loadTasks() -> [TaskTask] {
        if let data = UserDefaults.standard.data(forKey: "SAVED_TASKS"),
           let tasks = try? JSONDecoder().decode([TaskTask].self, from: data) {
            return tasks
        }
        return []
    }
    
    func saveProjects(_ projects: [Project]) {
        if let encoded = try? JSONEncoder().encode(projects) {
            UserDefaults.standard.set(encoded, forKey: "SAVED_PROJECTS")
        }
    }
    
    func loadProjects() -> [Project] {
        if let data = UserDefaults.standard.data(forKey: "SAVED_PROJECTS"),
           let projects = try? JSONDecoder().decode([Project].self, from: data) {
            return projects
        }
        return []
    }
}

enum ViewState: Equatable {
    case main, service
}

