import Foundation

struct Library: Identifiable, Hashable, Codable{
    let id: String
    private var name: String
    private var location: String
    private var contactNo: String
    private var contactEmail: String
    private var totalBooks: Int
    private var issuePeriod: Int
    private var maxBooks: Int
    private var fineInterest: Int
    private var librarian: User
    private var adminId: String
    private var books: [Book]?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case location
        case contactNo
        case contactEmail
        case totalBooks
        case issuePeriod
        case maxBooks
        case fineInterest
        case librarian
        case books
        case adminId
    }
    
    init(id: String, name: String, location: String, contactNo: String, contactEmail: String,totalBooks: Int, issuePeriod: Int, maxBooks: Int,fineInterest: Int, librarian: User, books: [Book]? = nil, adminId: String) {
        self.id = id
        self.name = name
        self.location = location
        self.contactNo = contactNo
        self.contactEmail = contactEmail
        self.totalBooks = totalBooks
        self.issuePeriod = issuePeriod
        self.maxBooks = maxBooks
        self.fineInterest = fineInterest
        self.librarian = librarian
        self.books = books
        self.adminId = adminId
    }
    
    // Getters
    func getId() -> String { return id }
    func getName() -> String { return name }
    func getLocation() -> String { return location }
    func getContactNo() -> String { return contactNo }
    func getContactEmail() -> String { return contactEmail }
    func getTotalBooks() -> Int {return totalBooks}
    func getIssuePeriod() -> Int {return issuePeriod}
    func getMaxBooks() -> Int {return maxBooks}
    func getFineInterest() -> Int {return fineInterest}
    func getLibrarian() -> User { return librarian }
    func getBooks() -> [Book]? { return books }
    
    // Setters
    mutating func setName(_ newName: String) { name = newName }
    mutating func setLocation(_ newLocation: String) { location = newLocation }
    mutating func setContactNo(_ newContactNo: String) { contactNo = newContactNo }
    mutating func setContactEmail(_ newContactEmail: String) { contactEmail = newContactEmail }
    mutating func setTotalBooks(_ newTotalBooks: Int) { totalBooks = newTotalBooks }
    mutating func setIssuePeriod(_ newIssuePeriod: Int) { issuePeriod = newIssuePeriod }
    mutating func setMaxBooks(_ newMaxBooks: Int) { maxBooks = newMaxBooks }
    mutating func setFineInterest(_ newFineInterest: Int) { fineInterest = newFineInterest }
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


