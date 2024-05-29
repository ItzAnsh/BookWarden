//
//  CategoryComponent.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 29/05/24.
//

import SwiftUI

struct CategoryComponent: View {
    var genre: String
    var color: Color = .blue
    var body: some View {
        VStack {
            Text(genre)
                .frame(width: 150, height: 80)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
        }
        .background(color.gradient)
        .cornerRadius(18)
    }
}

#Preview {
    CategoryComponent(genre: "Fiction")
}
