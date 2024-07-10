//
//  Location.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 12/06/24.
//

import Foundation

struct Location: Codable, Hashable, Identifiable {
    var id: String
    var libraryId: Library
    var bookId: String
    var totalQuantity: Int
    var availableQuantity: Int
    var v: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case libraryId
        case bookId
        case totalQuantity
        case availableQuantity
        case v = "__v"
    }
}
