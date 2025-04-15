import SwiftUI

struct ProjectsView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var showingAddProject = false
    @State private var editingProject: Project?
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                if taskManager.projects.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "folder")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No projects yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(taskManager.projects) { project in
                                ProjectCard(project: project)
                                    .contextMenu {
                                        Button {
                                            editingProject = project
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        
                                        Button(role: .destructive) {
                                            taskManager.deleteProject(project)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Projects")
            .toolbar {
                Button {
                    showingAddProject = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.indigo)
                }
            }
            .sheet(isPresented: $showingAddProject) {
                AddProjectView()
            }
            .sheet(item: $editingProject) { project in
                EditProjectView(project: project)
            }
        }
    }
}

struct ProjectCard: View {
    @EnvironmentObject var taskManager: TaskManager
    let project: Project
    
    var body: some View {
        NavigationLink(destination: ProjectDetailView(project: project)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(project.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: "folder.fill")
                        .foregroundStyle(Color(project.color))
                }
                
                let tasks = taskManager.tasksForProject(project)
                Text("\(tasks.count) tasks")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                let completed = tasks.filter { $0.isCompleted }.count
                ProgressView(value: Double(completed), total: Double(tasks.count))
                    .tint(Color(project.color))
            }
            .padding()
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
    }
}