import SwiftUI

struct TaskDetailView: View {
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.dismiss) var dismiss
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    let task: TaskTask
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                detailsSection
                actionsSection
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { showingEditSheet = true }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: { showingDeleteAlert = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(.indigo)
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditTaskView(task: task)
        }
        .alert("Delete Task", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                taskManager.deleteTask(task)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this task?")
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(Color(task.priority.color))
                .frame(width: 60, height: 60)
                .overlay {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 30))
                        .foregroundStyle(.white)
                }
                .onTapGesture {
                    withAnimation {
                        taskManager.toggleTaskCompletion(task)
                    }
                }
            
            Text(task.title)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !task.description.isEmpty {
                DetailRow(title: "Description", value: task.description)
            }
            
            DetailRow(title: "Due Date", value: task.dueDate.formatted(date: .long, time: .shortened))
            
            DetailRow(title: "Priority", value: task.priority.rawValue)
            
            if let projectId = task.projectId,
               let project = taskManager.projects.first(where: { $0.id == projectId }) {
                DetailRow(title: "Project", value: project.name)
            }
            
            DetailRow(title: "Status", value: task.isCompleted ? "Completed" : "In Progress")
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
    
    private var actionsSection: some View {
        HStack(spacing: 12) {
            ActionButton(
                title: "Share",
                icon: "square.and.arrow.up",
                color: .indigo,
                action: shareTask
            )
            
            ActionButton(
                title: "Edit",
                icon: "pencil",
                color: .orange,
                action: { showingEditSheet = true }
            )
            
            ActionButton(
                title: "Delete",
                icon: "trash",
                color: .red,
                action: { showingDeleteAlert = true }
            )
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
    
    private func shareTask() {
        let shareText = """
        Task: \(task.title)
        Due: \(task.dueDate.formatted(date: .long, time: .shortened))
        Priority: \(task.priority.rawValue)
        Status: \(task.isCompleted ? "Completed" : "In Progress")
        """
        
        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            activityVC.popoverPresentationController?.sourceView = rootVC.view
            rootVC.present(activityVC, animated: true)
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.gray)
            Text(value)
                .font(.body)
        }
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .buttonStyle(.bordered)
        .tint(color)
    }
}