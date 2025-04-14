import SwiftUI

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
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
        
        tasks = [
            Task(title: "Buy groceries", description: "Get milk, eggs, and bread", priority: .medium, projectId: projects[2].id),
            Task(title: "Finish presentation", description: "Complete slides for meeting", priority: .high, projectId: projects[1].id),
            Task(title: "Exercise", description: "30 minutes cardio", priority: .low, projectId: projects[0].id)
        ]
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }
    
    func toggleTaskCompletion(_ task: Task) {
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
    
    func tasksForProject(_ project: Project) -> [Task] {
        tasks.filter { $0.projectId == project.id }
    }
    
    func completionRate() -> Double {
        guard !tasks.isEmpty else { return 0 }
        return Double(tasks.filter { $0.isCompleted }.count) / Double(tasks.count)
    }
}