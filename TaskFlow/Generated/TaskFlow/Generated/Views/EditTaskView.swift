import SwiftUI

struct EditTaskView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskManager: TaskManager
    
    let task: TaskTask
    @State private var title: String
    @State private var description: String
    @State private var dueDate: Date
    @State private var priority: Priority
    @State private var selectedProject: Project?
    @State private var showingSaveAlert = false
    
    init(task: TaskTask) {
        self.task = task
        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description)
        _dueDate = State(initialValue: task.dueDate)
        _priority = State(initialValue: task.priority)
        if let projectId = task.projectId {
            _selectedProject = State(initialValue: TaskManager().projects.first(where: { $0.id == projectId }))
        }
    }
    
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
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTask()
                        showingSaveAlert = true
                    }
                    .disabled(title.isEmpty)
                }
            }
            .alert("Task Updated", isPresented: $showingSaveAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your task has been successfully updated.")
            }
        }
    }
    
    private func saveTask() {
        let updatedTask = TaskTask(
            id: task.id,
            title: title,
            description: description,
            dueDate: dueDate,
            priority: priority,
            isCompleted: task.isCompleted,
            projectId: selectedProject?.id
        )
        