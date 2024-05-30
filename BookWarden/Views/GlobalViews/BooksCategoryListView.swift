//
//  BooksCategoryListView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 29/05/24.
//

import SwiftUI

enum DisplayType {
    case listOfBooks
    case listOfGenres
}

struct BooksCategoryListView: View {
    var pageTitle: String
    var genres1: [String] = ["Fiction", "Science", "Mathematics", "Physics", "DSA", "Development", "Swift", "C++", "OS", "Spring"]
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach((genres1), id: \.self) {genre in
                        CategorySubView(title: genre)
                        
                    }
                }
            }
            .safeAreaPadding()
            .scrollIndicators(.hidden)
            .navigationBarTitle(pageTitle, displayMode: .inline)
        }
        
        
    }
}

#Preview {
    BooksCategoryListView(pageTitle: "Title")
}
