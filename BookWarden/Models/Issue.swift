//
//  Issue.swift
//  Project
//
//  Created by Saksham Nagpal on 31/05/24.
//


import Foundation

struct Issue: Codable, Hashable {
    private let id: String
    private let bookId: String
    private let userId: String
    private let issuedDate: Date
    private let deadline: Date
    private var status: IssueStatus
    private var returnDate: Date?
    
    init(id: String, bookId: String, userId: String, issuedDate: Date, deadline: Date, status: IssueStatus, returnDate: Date? = nil) {
        self.id = id
        self.bookId = bookId
        self.userId = userId
        self.issuedDate = issuedDate
        self.deadline = deadline
        self.status = status
        self.returnDate = returnDate
    }
    
    // Getters
    func getId() -> String { return id }
    func getBookId() -> String { return bookId }
    func getUserId() -> String { return userId }
    func getIssuedDate() -> Date { return issuedDate }
    func getDeadline() -> Date { return deadline }
    func getStatus() -> IssueStatus { return status }
    func getReturnDate() -> Date? { return returnDate }
    
    // Setters
    mutating func setStatus(_ newStatus: IssueStatus) { status = newStatus }
    mutating func setReturnDate(_ newReturnDate: Date?) { returnDate = newReturnDate }
}

enum IssueStatus: String, Codable {
    case requested = "requested"
    case issued = "issued"
    case returned = "returned"
    case fined = "fined"
    case fining = "fining"
}



