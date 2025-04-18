import SwiftUI

struct AddProjectView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskManager: TaskManager
    
    @State private var projectName = ""
    @State private var showingSuccessAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Project Details") {
                    TextField("Project Name", text: $projectName)
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
                        let newProject = Project(name: projectName)
                        taskManager.addProject(newProject)
                        showingSuccessAlert = true
                        projectName = ""
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showingSuccessAlert = false
                            dismiss()
                        }
                    }
                    .disabled(projectName.isEmpty)
                }
            }
            .alert("Project Added", isPresented: $showingSuccessAlert) {
            } message: {
                Text("Your project has been successfully added.")
            }
        }
    }
}