import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var showingAddTask = false
    @State private var selectedSortOption = SortOption.dueDate
    
    enum SortOption {
        case dueDate, priority, title
    }
    
    var sortedTasks: [Task] {
        switch selectedSortOption {
        case .dueDate:
            return taskManager.tasks.sorted { $0.dueDate < $1.dueDate }
        case .priority:
            return taskManager.tasks.sorted { $0.priority.rawValue > $1.priority.rawValue }
        case .title:
            return taskManager.tasks.sorted { $0.title < $1.title }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                
                if taskManager.tasks.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "checklist")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No tasks yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                } else {
                    List {
                        ForEach(sortedTasks) { task in
                            TaskRow(task: task)
                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        taskManager.deleteTask(task)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.indigo)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("Due Date") { selectedSortOption = .dueDate }
                        Button("Priority") { selectedSortOption = .priority }
                        Button("Title") { selectedSortOption = .title }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                            .foregroundStyle(.indigo)
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
            }
        }
    }
}

struct TaskRow: View {
    @EnvironmentObject var taskManager: TaskManager
    let task: Task
    
    var body: some View {
        HStack {
            Button {
                withAnimation {
                    taskManager.toggleTaskCompletion(task)
                }
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(task.isCompleted ? .green : .gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .foregroundStyle(task.isCompleted ? .gray : .primary)
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.gray)
                    Text(task.dueDate.formatted(date: .abbreviated, time: .omitted))
                        .foregroundStyle(.gray)
                        .font(.caption)
                    
                    if let projectId = task.projectId,
                       let project = taskManager.projects.first(where: { $0.id == projectId }) {
                        Text(project.name)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color(project.color).opacity(0.2))
                            .cornerRadius(4)
                    }
                }
            }
            
            Spacer()
            
            Circle()
                .fill(Color(task.priority.color))
                .frame(width: 12, height: 12)
        }
    }
}