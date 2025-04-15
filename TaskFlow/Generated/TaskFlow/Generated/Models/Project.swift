import Foundation

struct Project: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var color: String
    
    init(id: UUID = UUID(), name: String, color: String = "indigo") {
        self.id = id
        self.name = name
        self.color = color
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.id == rhs.id
    }
}