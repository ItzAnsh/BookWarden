//
//  LibrarianCatalogueView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 31/05/24.
//

import SwiftUI

struct LibrarianCatalogueView: View {
    @State var searchText: String = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 35) {
                    ForEach((0..<5), id: \.self) { _ in
                        HStack(spacing: 24) {
//                            CatalogueSingleBookSubView(image: "https://m.media-amazon.com/images/I/81w7a13pbnL.AC_SX500.jpg")
//                            CatalogueSingleBookSubView(image: "https://m.media-amazon.com/images/I/81w7a13pbnL.AC_SX500.jpg")
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Catalogue")
            .searchable(text: $searchText)
            .safeAreaPadding(.all)
        }
    }
}

#Preview {
    LibrarianCatalogueView()
}
