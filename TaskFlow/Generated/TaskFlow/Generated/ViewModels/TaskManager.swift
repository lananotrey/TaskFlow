import SwiftUI

class TaskManager: ObservableObject {
    @Published var tasks: [TaskTask] = []
    @Published var projects: [Project] = []
    
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        projects = [
            Project(name: "Personal", color: "indigo"),
            Project(name: "Work", color: "pink"),
            Project(name: "Shopping", color: "mint")
        ]
        
        tasks = []
    }
    
    func addTask(_ task: TaskTask) {
        tasks.append(task)
    }
    
    func deleteTask(_ task: TaskTask) {
        tasks.removeAll { $0.id == task.id }
    }
    
    func toggleTaskCompletion(_ task: TaskTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func addProject(_ project: Project) {
        projects.append(project)
    }
    
    func deleteProject(_ project: Project) {
        projects.removeAll { $0.id == project.id }
        tasks.removeAll { $0.projectId == project.id }
    }
    
    func tasksForProject(_ project: Project) -> [TaskTask] {
        tasks.filter { $0.projectId == project.id }
    }
    
    func completionRate() -> Double {
        guard !tasks.isEmpty else { return 0 }
        return Double(tasks.filter { $0.isCompleted }.count) / Double(tasks.count)
    }
}