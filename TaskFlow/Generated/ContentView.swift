import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var dueDate: Date
    var priority: Priority
    var isCompleted: Bool
    var projectId: UUID?
    
    init(id: UUID = UUID(), 
         title: String, 
         description: String = "", 
         dueDate: Date = Date(), 
         priority: Priority = .medium,
         isCompleted: Bool = false,
         projectId: UUID? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.priority = priority
        self.isCompleted = isCompleted
        self.projectId = projectId
    }
}

enum Priority: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var color: String {
        switch self {
        case .low: return "mint"
        case .medium: return "orange"
        case .high: return "pink"
        }
    }
}