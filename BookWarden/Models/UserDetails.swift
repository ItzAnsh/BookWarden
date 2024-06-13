//struct UserDetails: Codable {
//    let id: String
//    let name: String
//    let email: String
//    let role: String?
//    let date: Date
//}

//struct Book: Codable {
//    let id: String
//    let title: String
//    let author: String
//    let description: String
//    let price: Int
//    let genre: String
//    let publisher: String
//    let language: String
//    let length: Int
//    let imageURL: String
//    let isbn10: String
//    let isbn13: String
//}

//struct Library: Codable {
//    let id: String
//    let name: String
//    let location: String
//    let contactNo: String
//    let contactEmail: String
//    let librarian: String
//    let totalBooks: Int
//    let adminId: String
//    let issuePeriod: Int
//    let maxBooks: Int
//    let fineInterest: Int
//}
//
//struct IssuedBook: Codable {
//    let id: String
//    let book: Book
//    let userId: String
//    let library: Library
//    let date: Date
//    let deadline: Date
//    let status: String
//}
//
//struct Fine: Codable {
//    let id: String
//    let userId: String
//    let issuedBooks: [IssuedBook]
//    let amount: Int
//    let status: String
//    let category: String
//    let interest: Int
//    let transactionId: String
//}
//
//struct ApiResponse: Codable {
//    let userDetails: [UserDetails]
//    let issuedBooks: [[IssuedBook]]
//    let fines: [[Fine]]
//}
