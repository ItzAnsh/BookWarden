//
//  IssuedBooksView.swift
//  ProfileScreen
//
//  Created by Abhi  on 30/05/24.
//


import Foundation
import SwiftUI

struct IssuedBooksView: View {
    @State private var searchText = ""
    var images: [String] = [
        "https://m.media-amazon.com/images/I/81DXIOk9glL._AC_UY436_FMwebp_QL65_.jpg","https://m.media-amazon.com/images/I/61aJc8wQX4L._AC_UY436_FMwebp_QL65_.jpg"
            ]
    
    @ObservedObject var userManager = UserManager.shared
//    var books: [Book]
    
//    init(books: [Book]) {
//        self.books = books
//    }

    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(){
                    ForEach((userManager.user?.getIssues() ?? []), id: \.self) { issue in
                        IssuedBooksSSView(image: issue.getBook().imageURL)
                        
                    }
                }
            }
            .navigationTitle("Issued Books")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
        }
    }
}

