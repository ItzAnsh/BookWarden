import Foundation

struct Library: Identifiable, Hashable {
    let id: String
    private let name: String
    private let location: String
    private let contactNo: String
    private let contactEmail: String
    private let librarian: User
    private var books: [Book]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case location
        case contactNo
        case contactEmail
        case librarian
        case books
    }
    
    init(id: String, name: String, location: String, contactNo: String, contactEmail: String, librarian: User, books: [Book]? = nil) {
        self.id = id
        self.name = name
        self.location = location
        self.contactNo = contactNo
        self.contactEmail = contactEmail
        self.librarian = librarian
        self.books = books
    }
    
    // Getters
    func getId() -> String { return id }
    func getName() -> String { return name }
    func getLocation() -> String { return location }
    func getContactNo() -> String { return contactNo }
    func getContactEmail() -> String { return contactEmail }
    func getLibrarian() -> User { return librarian }
    func getBooks() -> [Book]? { return books }
    
    // Setters
    mutating func setBooks(_ newBooks: [Book]?) { books = newBooks }
    mutating func addBook(_ book: Book) {
        if books == nil {
            books = []
        }
        books?.append(book)
    }
    
    mutating func removeBook(byId bookId: String) {
//        books?.removeAll { $0.getId() == bookId }
    }
}


