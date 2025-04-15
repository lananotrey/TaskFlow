import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var showingAddTask = false
    @State private var selectedSortOption = SortOption.dueDate
    @State private var showingSuccessAlert = false
    @Binding var selectedTab: Int
    
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
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    statsCards
                    tasksList
                }
                .padding()
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.indigo)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("Due Date") { selectedSortOption = .dueDate }
                        Button("Priority") { selectedSortOption = .priority }
                        Button("Title") { selectedSortOption = .title }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                            .foregroundColor(.indigo)
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                NavigationView {
                    AddTaskView(selectedTab: $selectedTab, showingSuccessAlert: $showingSuccessAlert)
                }
            }
            .alert("Task Added", isPresented: $showingSuccessAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your new task has been successfully added.")
            }
        }
    }
    
    private var statsCards: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCardView(
                    title: "Completion Rate",
                    value: String(format: "%.0f%%", taskManager.completionRate() * 100),
                    icon: "chart.pie.fill",
                    color: .indigo
                )
                
                StatCardView(
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
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
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
                            .foregroundColor(.gray)
                    }
                    
                    ProgressView(value: Double(completed), total: Double(tasks.count))
                        .tint(Color(project.color))
                }
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
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
                    NavigationLink(destination: TaskDetailView(task: task)) {
                        TaskRowView(task: task)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(12)
                    }
                }
            }
        }
    }
}