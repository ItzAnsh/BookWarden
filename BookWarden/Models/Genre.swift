import Foundation
struct Genre: Codable {
    var id: String
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

