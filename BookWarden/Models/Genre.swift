import Foundation
struct Genre: Codable, Hashable, Identifiable {
    var id: String
    var name: String
    var v: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case v = "__v"
    }
}

