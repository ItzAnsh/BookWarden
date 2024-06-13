//
//  UserHomeGenresSubView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 29/05/24.
//

import SwiftUI

struct UserHomeGenresSubView: View {

    var genres1: [String] = ["Fiction", "Science", "Mathematics", "Physics", "DSA", "Development", "Swift", "C++", "OS", "Spring"]
    var colors: [Color] = [.blue, .red, .green, .yellow, .purple, .pink, .gray, .indigo]
    var body: some View {
        VStack() {
            TitleComponent(title: "Categories", page: BooksCategoryListView(pageTitle: "Categories"))
            
            ScrollView(.horizontal) {
                VStack(spacing: 19) {
                    HStack(spacing: 19) {
                        ForEach((0..<genres1.count / 2), id: \.self) { genre in
                            CategoryComponent(genre: genres1[genre], color: colors.randomElement()!)
                            
                        }
                    }
                    HStack(spacing: 19) {
                        ForEach((genres1.count / 2..<genres1.count)) { genre in
                            CategoryComponent(genre: genres1[genre], color: colors.randomElement()!)
                        }
                    }
                    .safeAreaPadding(.horizontal)
                }
            }
        }
        .background(grayGradient)
    }
}

#Preview {
    UserHomeGenresSubView()
}
