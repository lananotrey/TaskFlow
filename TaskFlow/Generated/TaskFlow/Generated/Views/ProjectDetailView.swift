import SwiftUI

struct ProjectDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskManager: TaskManager
    @State private var showingDeleteAlert = false
    @State private var showingDeleteConfirmation = false
    @Binding var selectedTab: Int
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
                showingDeleteAlert = true
            } label: {
                Label("Delete Project", systemImage: "trash")
            }
        }
        .alert("Delete Project", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                taskManager.deleteProject(project)
                showingDeleteConfirmation = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showingDeleteConfirmation = false
                    dismiss()
                    selectedTab = 1
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this project? All associated tasks will also be deleted.")
        }
        .alert("Project Deleted", isPresented: $showingDeleteConfirmation) {
        } message: {
            Text("The project has been successfully deleted.")
        }
    }
}