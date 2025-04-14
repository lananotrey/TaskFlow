import SwiftUI

struct StatsView: View {
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        progressCard
                        projectStats
                        priorityStats
                    }
                    .padding()
                }
            }
            .navigationTitle("Statistics")
        }
    }
    
    private var progressCard: some View {
        VStack(spacing: 16) {
            Text("Overall Progress")
                .font(.headline)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundStyle(.gray)
                
                Circle()
                    .trim(from: 0.0, to: taskManager.completionRate())
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundStyle(.indigo)
                    .rotationEffect(Angle(degrees: 270.0))
                
                Text(String(format: "%.0f%%", taskManager.completionRate() * 100))
                    .font(.title)
                    .bold()
            }
            .frame(width: 200, height: 200)
            
            Text("\(taskManager.tasks.filter { $0.isCompleted }.count) of \(taskManager.tasks.count) tasks completed")
                .foregroundStyle(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 2)
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
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 2)
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
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}