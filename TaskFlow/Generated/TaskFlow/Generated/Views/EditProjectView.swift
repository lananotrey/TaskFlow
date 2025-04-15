import SwiftUI

struct EditProjectView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskManager: TaskManager
    
    let project: Project
    @State private var projectName: String
    @State private var selectedColor: String
    
    let colors = ["indigo", "pink", "mint", "orange", "teal", "purple"]
    
    init(project: Project) {
        self.project = project
        _projectName = State(initialValue: project.name)
        _selectedColor = State(initialValue: project.color)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Project Details") {
                    TextField("Project Name", text: $projectName)
                    
                    HStack {
                        Text("Color")
                        Spacer()
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(Color(color))
                                .frame(width: 24, height: 24)
                                .overlay {
                                    if color == selectedColor {
                                        Circle()
                                            .strokeBorder(.white, lineWidth: 2)
                                            .shadow(radius: 1)
                                    }
                                }
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                }
            }
            .navigationTitle("Edit Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProject()
                        dismiss()
                    }
                    .disabled(projectName.isEmpty)
                }
            }
        }
    }
    
    private func saveProject() {
        if let index = taskManager.projects.firstIndex(where: { $0.id == project.id }) {
            let updatedProject = Project(id: project.id, name: projectName, color: selectedColor)
            taskManager.projects[index] = updatedProject
        }
    }
}