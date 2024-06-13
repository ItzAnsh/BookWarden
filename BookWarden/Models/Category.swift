//
//  Category.swift
//  BookWarden
//
//  Created by Manan Gupta on 13/06/24.
//

import Foundation

struct Category: Identifiable, Codable {
    let id: String
    let name: String
    let books: [Book]
}
