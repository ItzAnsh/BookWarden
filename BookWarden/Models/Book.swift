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
//    var realeaseDate: Sti 
    var length: Int
    var imageURL: URL
    var isbn10: String
    var isbn13: String
    
    init(book: Book) {
        self.id = book.id
        self.title = book.title
        self.author = book.author
        self.description = book.description
        self.genre = book.genre
        self.price = book.price
        self.publisher = book.publisher
        self.language = book.language
        self.length = book.length
        self.imageURL = book.imageURL
        self.isbn10 = book.isbn10
        self.isbn13 = book.isbn13
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.author = try container.decode(String.self, forKey: .author)
        self.description = try container.decode(String.self, forKey: .description)
        self.genre = try container.decode(String.self, forKey: .genre)
        self.price = try container.decode(Double.self, forKey: .price)
        self.publisher = try container.decode(String.self, forKey: .publisher)
        self.language = try container.decode(String.self, forKey: .language)
        self.length = try container.decode(Int.self, forKey: .length)
        self.imageURL = try container.decode(URL.self, forKey: .imageURL)
        self.isbn10 = try container.decode(String.self, forKey: .isbn10)
        self.isbn13 = try container.decode(String.self, forKey: .isbn13)
    }
    
    init(id: String, title: String, author: String, description: String, genre: String, price: Double, publisher: String, language: String, length: Int, imageURL: URL, isbn10: String, isbn13: String) {
        self.id = id
        self.title = title
        self.author = author
        self.description = description
        self.genre = genre
        self.price = price
        self.publisher = publisher
        self.language = language
        self.length = length
        self.imageURL = imageURL
        self.isbn10 = isbn10
        self.isbn13 = isbn13
    }
}
