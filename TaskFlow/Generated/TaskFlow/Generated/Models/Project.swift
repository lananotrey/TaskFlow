import Foundation

struct Project: Identifiable, Codable {
    let id: UUID
    var name: String
    var color: String
    
    init(id: UUID = UUID(), name: String, color: String = "indigo") {
        self.id = id
        self.name = name
        self.color = color
    }
}