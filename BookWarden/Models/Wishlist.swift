//
//  File.swift
//  frontend_data_models
//
//  Created by Saksham Nagpal on 27/05/24.
//
import Foundation

struct Wishlist: Codable, Hashable {
    private let id: String
    private var books: [Book]
    
    init(id: String, books: [Book] = []) {
        self.id = id
        self.books = books
    }
    
    // Getters
    func getId() -> String { return id }
    func getBooks() -> [Book] { return books }
    
    // Add a book to the wishlist
    mutating func addBook(_ book: Book) {
        books.append(book)
    }
    
    // Remove a book from the wishlist by id
    mutating func removeBook(byId bookId: String) {
//        books.removeAll { $0.getId() == bookId }
    }
}


