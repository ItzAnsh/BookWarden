import Foundation

struct User: Codable, Hashable {
    private let id: String
    private var name: String
    private var email: String
    private var contactNo: String
    private var genrePreferences: [String]
    private let roles: Role
    private var fines: [Fine]?
    private var issues: [Issue]?
    private var wishlist: Wishlist?
    
    init(id: String, name: String, email: String, contactNo: String, genrePreferences: [String], roles: Role, fines: [Fine]? = [], issues: [Issue]? = [], wishlist: Wishlist? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.contactNo = contactNo
        self.genrePreferences = genrePreferences
        self.roles = roles
        self.fines = fines
        self.issues = issues
        self.wishlist = wishlist
    }
    
    // Getters
    func getId() -> String { return id }
    func getName() -> String { return name }
    func getEmail() -> String { return email }
    func getContactNo() -> String { return contactNo }
    func getGenrePreferences() -> [String] { return genrePreferences }
    func getRoles() -> Role { return roles }
    func getFines() -> [Fine]? { return fines }
    func getIssues() -> [Issue]? { return issues }
    func getWishlist() -> Wishlist? { return wishlist }
    
    // Setters
    mutating func setName(_ newName: String) { name = newName }
    mutating func setEmail(_ newEmail: String) { email = newEmail }
    mutating func setContactNo(_ newContactNo: String) { contactNo = newContactNo }
    mutating func setGenrePreferences(_ newPreferences: [String]) { genrePreferences = newPreferences }
    mutating func setFines(_ newFines: [Fine]?) { fines = newFines }
    mutating func setIssues(_ newIssues: [Issue]?) { issues = newIssues }
    mutating func setWishlist(_ newWishlist: Wishlist?) { wishlist = newWishlist }
}

enum Role: String, Codable, Hashable {
    case librarian = "Librarian"
    case admin = "Admin"
    case superAdmin = "Super-admin"
    case normalUser = "Normal user"
}


