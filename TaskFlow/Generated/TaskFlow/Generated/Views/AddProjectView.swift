import SwiftUI

struct AddProjectView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskManager: TaskManager
    
    @State private var projectName = ""
    @State private var selectedColor = "indigo"
    
    let colors = ["indigo", "pink", "mint", "orange", "teal", "purple"]
    
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
            .navigationTitle("New Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let newProject = Project(name: projectName, color: selectedColor)
                        taskManager.addProject(newProject)
                        dismiss()
                    }
                    .disabled(projectName.isEmpty)
                }
            }
        }
    }
}