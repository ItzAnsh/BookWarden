//
//  UserHomeGenresSubView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 29/05/24.
//

import SwiftUI

struct UserHomeGenresSubView: View {
    var genres: [[String]] = [["Fiction", "Science"], ["Mathematics", "Physics"], ["DSA", "Development"], ["Swift", "C++"], ["OS", "Spring"]]
    var genres1: [String] = ["Fiction", "Science", "Mathematics", "Physics", "DSA", "Development", "Swift", "C++", "OS", "Spring"]
    var colors: [Color] = [.blue, .red, .green, .yellow, .purple, .pink, .gray, .indigo]
    var body: some View {
        VStack() {
            HStack() {
                HStack() {
                    Text("Categories")
                    
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.accent)
                .fontWeight(.semibold)
                .font(.title2)
                
                Spacer()
            }
            .safeAreaPadding()
            
            ScrollView(.horizontal) {
                VStack(spacing: 19) {
                    HStack(spacing: 19) {
                        //                                ForEach ((0..<genres.count), id: \.self) { genre in
                        //                                    VStack() {
                        //                                        CategoryComponent(genre: genres[genre][0], color: genre > colors.count ? colors[genre - colors.count] : colors[genre ])
                        //                                        CategoryComponent(genre: genres[genre][1], color: genre > colors.count ? colors[genre - colors.count] : colors[genre ])
                        //                                    }
                        ////                                    self.a += 2
                        //                                }
                        
                        ForEach((0..<genres1.count / 2), id: \.self) { genre in
//                                        var colorCount = genre > (colors.count / 2) - 1 ? 0 : genre;
                            
                            CategoryComponent(genre: genres1[genre], color: colors.randomElement()!)
                            
                            //                                    colorCount += 1
                        }
                    }
                    
                    HStack(spacing: 19) {
                        ForEach((genres1.count / 2..<genres1.count)) { genre in
//                                        var colorCount = genre > (colors.count / 2) - 1 ? 0 : genre;
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
