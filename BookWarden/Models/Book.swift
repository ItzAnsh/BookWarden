import Foundation

struct Book: Identifiable, Codable, Hashable {
    let id: String
    var title: String
    var author: String
    var description: String
    var genre: String
    var price: Double
    var publisher: String
    var language: String
    var length: Int
    var imageURL: URL
}
