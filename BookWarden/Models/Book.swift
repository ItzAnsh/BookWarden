import Foundation

struct Book: Identifiable, Codable, Hashable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.title > rhs.title
    }
    
    let id: String
    var title: String
    var author: String
    var description: String
    var genre: Genre
    var price: Double
    var publisher: String
    var language: String
    var length: Int
    var imageURL: URL
    let isbn10: String
    let isbn13: String
    let v: Int
    
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case title
            case author
            case description
            case genre
            case price
            case publisher
            case language
            case length
            case imageURL
            case isbn10
            case isbn13
            case v = "__v"
        }
}
