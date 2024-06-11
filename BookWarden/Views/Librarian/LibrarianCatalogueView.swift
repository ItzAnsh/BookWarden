//
//  LibrarianCatalogueView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 31/05/24.
//

import SwiftUI

struct LibrarianCatalogueView: View {
    @State var addModalPresent = false
    @State var searchText: String = ""
    @State var alertState: Bool = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 35) {
                    ForEach((0..<5), id: \.self) { _ in
                        HStack(spacing: 24) {
                            CatalogueSingleBookSubView(alertState: $alertState, image: URL(string: "https://m.media-amazon.com/images/I/81w7a13pbnL.AC_SX500.jpg")!, categoryType: .librarian, title: "How to be happy", author: "Jane austen")
                            CatalogueSingleBookSubView(alertState: $alertState, image:
                                                        URL(string: "https://m.media-amazon.com/images/I/81w7a13pbnL.AC_SX500.jpg")!, categoryType: .librarian, title: "How to be happy", author: "Jane austen")
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Catalogue")
            .searchable(text: $searchText)
            .safeAreaPadding(.all)
            .toolbar() {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        addModalPresent = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }
                }
            }
            
        }
//        .sheet(isPresented: $addModalPresent) {
//          
//            AddBookModalView()
//        }
        
    }
}

#Preview {
    LibrarianCatalogueView()
}
