import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskManager: TaskManager
    @Binding var selectedTab: Int
    
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @State private var priority = Priority.medium
    @State private var selectedProject: Project?
    @State private var showingSaveAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Task Details") {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Due Date") {
                    DatePicker("Select Date", selection: $dueDate)
                }
                
                Section("Priority") {
                    Picker("Select Priority", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            HStack {
                                Circle()
                                    .fill(Color(priority.color))
                                    .frame(width: 12, height: 12)
                                Text(priority.rawValue)
                            }
                            .tag(priority)
                        }
                    }
                }
                
                Section("Project") {
                    Picker("Select Project", selection: $selectedProject) {
                        Text("None")
                            .tag(Optional<Project>.none)
                        ForEach(taskManager.projects) { project in
                            Text(project.name)
                                .tag(Optional(project))
                        }
                    }
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        saveTask()
                        showingSaveAlert = true
                    }
                    .disabled(title.isEmpty)
                }
            }
            .alert("Task Added", isPresented: $showingSaveAlert) {
                Button("OK") {
                    resetForm()
                    dismiss()
                    selectedTab = 0
                }
            } message: {
                Text("Your task has been successfully added.")
            }
        }
    }
    
    private func saveTask() {
        let newTask = TaskTask(
            title: title,
            description: description,
            dueDate: dueDate,
            priority: priority,
            projectId: selectedProject?.id
        )
        taskManager.addTask(newTask)
    }
    
    private func resetForm() {
        title = ""
        description = ""
        dueDate = Date()
        priority = .medium
        selectedProject = nil
    }
}