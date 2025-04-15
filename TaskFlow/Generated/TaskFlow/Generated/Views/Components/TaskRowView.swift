import SwiftUI

struct TaskRowView: View {
    @EnvironmentObject var taskManager: TaskManager
    let task: TaskTask
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color(task.priority.color))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted)
                
                Text(task.dueDate.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                if let projectId = task.projectId,
                   let project = taskManager.projects.first(where: { $0.id == projectId }) {
                    Text(project.name)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    taskManager.toggleTaskCompletion(task)
                }
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(task.isCompleted ? Color(task.priority.color) : .gray)
            }
        }
        .padding()
    }
}