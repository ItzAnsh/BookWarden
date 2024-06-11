//
//  Issue.swift
//  Project
//
//  Created by Saksham Nagpal on 31/05/24.
//


import Foundation

struct Issue: Codable, Hashable {
    private let id: String
    private let book: Book
    private let user: User
    private let issuedDate: Date
    private let deadline: Date
    private var status: IssueStatus
    private var returnDate: Date?
    
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case book = "bookId"
            case user = "userId"
            case issuedDate = "date"
            case deadline
            case status
            case returnDate
        }
    
    init(id: String, book: Book, user: User, issuedDate: Date, deadline: Date, status: IssueStatus, returnDate: Date? = nil) {
        self.id = id
        self.book = book
        self.user = user
        self.issuedDate = issuedDate
        self.deadline = deadline
        self.status = status
        self.returnDate = returnDate
    }
    
    init(issueDetails: Issue) {
        self.id = issueDetails.getId()
        self.book = issueDetails.getBook()
        self.user = issueDetails.getUser()
        self.issuedDate = issueDetails.getIssuedDate()
        self.deadline = issueDetails.getDeadline()
        self.status = issueDetails.getStatus()
        self.returnDate = issueDetails.getReturnDate()
    }
    
    // Getters
    func getId() -> String { return id }
    func getBook() -> Book { return book }
    func getUser() -> User { return user }
    func getIssuedDate() -> Date { return issuedDate }
    func getDeadline() -> Date { return deadline }
    func getStatus() -> IssueStatus { return status }
    func getReturnDate() -> Date? { return returnDate }
    
    // Setters
    mutating func setStatus(_ newStatus: IssueStatus) { status = newStatus }
    mutating func setReturnDate(_ newReturnDate: Date?) { returnDate = newReturnDate }
}

enum IssueStatus: String, Codable {
    case rejected = "rejected"
    case requested = "requested"
    case issued = "issued"
    case returned = "returned"
    case fined = "fined"
    case fining = "fining"
    case finingreturned = "fining-returned"
    case renewrequested = "renew=requested"
    case renewrejected = "renew-rejected"
    case renewapproved = "renew-approved"
}
