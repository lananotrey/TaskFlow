import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var showingAddTask = false
    @State private var selectedSortOption = SortOption.dueDate
    @Environment(\.colorScheme) private var colorScheme
    
    enum SortOption {
        case dueDate, priority, title
    }
    
    var sortedTasks: [TaskTask] {
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
            ScrollView {
                VStack(spacing: 20) {
                    statsCards
                    tasksList
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground))
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
    
    private var statsCards: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(
                    title: "Completion Rate",
                    value: String(format: "%.0f%%", taskManager.completionRate() * 100),
                    icon: "chart.pie.fill",
                    color: .indigo
                )
                
                StatCard(
                    title: "Total Tasks",
                    value: "\(taskManager.tasks.count)",
                    icon: "checklist",
                    color: .orange
                )
            }
            
            priorityStats
            projectStats
        }
    }
    
    private var priorityStats: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tasks by Priority")
                .font(.headline)
            
            ForEach(Priority.allCases, id: \.self) { priority in
                let count = taskManager.tasks.filter { $0.priority == priority }.count
                HStack {
                    Circle()
                        .fill(Color(priority.color))
                        .frame(width: 12, height: 12)
                    Text(priority.rawValue)
                    Spacer()
                    Text("\(count)")
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
    
    private var projectStats: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Project Status")
                .font(.headline)
            
            ForEach(taskManager.projects) { project in
                let tasks = taskManager.tasksForProject(project)
                let completed = tasks.filter { $0.isCompleted }.count
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(project.name)
                        Spacer()
                        Text("\(completed)/\(tasks.count)")
                            .foregroundStyle(.gray)
                    }
                    
                    ProgressView(value: Double(completed), total: Double(tasks.count))
                        .tint(Color(project.color))
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
    
    private var tasksList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tasks")
                .font(.headline)
            
            if taskManager.tasks.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "checklist")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("No tasks yet")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                ForEach(sortedTasks) { task in
                    TaskRow(task: task)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                        .swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                taskManager.deleteTask(task)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            Text(value)
                .font(.title2)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

struct TaskRow: View {
    @EnvironmentObject var taskManager: TaskManager
    let task: TaskTask
    
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
        .padding()
    }
}