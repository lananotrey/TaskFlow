import SwiftUI

struct ProjectDetailView: View {
    @EnvironmentObject var taskManager: TaskManager
    let project: Project
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Circle()
                            .fill(Color(project.color))
                            .frame(width: 20, height: 20)
                        Text(project.name)
                            .font(.headline)
                    }
                    
                    let tasks = taskManager.tasksForProject(project)
                    let completed = tasks.filter { $0.isCompleted }.count
                    
                    if !tasks.isEmpty {
                        ProgressView(value: Double(completed), total: Double(tasks.count))
                            .tint(Color(project.color))
                        Text("\(completed) of \(tasks.count) tasks completed")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.vertical, 8)
            }
            
            Section("Tasks") {
                let projectTasks = taskManager.tasksForProject(project)
                if projectTasks.isEmpty {
                    Text("No tasks in this project")
                        .foregroundStyle(.gray)
                } else {
                    ForEach(projectTasks) { task in
                        TaskRowView(task: task)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            taskManager.deleteTask(projectTasks[index])
                        }
                    }
                }
            }
        }
        .navigationTitle("Project Details")
        .toolbar {
            Button(role: .destructive) {
                taskManager.deleteProject(project)
            } label: {
                Label("Delete Project", systemImage: "trash")
            }
        }
    }
}