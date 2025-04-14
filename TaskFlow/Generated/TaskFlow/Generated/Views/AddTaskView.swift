import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskManager: TaskManager
    
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @State private var priority = Priority.medium
    @State private var selectedProject: Project?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Task Details") {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Due Date") {
                    DatePicker("Select Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section("Priority") {
                