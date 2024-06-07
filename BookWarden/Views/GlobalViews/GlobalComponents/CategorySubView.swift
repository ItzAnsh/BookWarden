//
//  CategorySubView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 29/05/24.
//

import SwiftUI

struct CategorySubView: View {
    var imgUrl = "https://m.media-amazon.com/images/I/71kUYNSKKgL.AC_SX500.jpg"
    var title = "Fiction"
    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: URL(string: imgUrl)) {image in
                    image
                        .resizable()
                        .frame(width: 75, height: 115)
                        .scaledToFit()
                    
                } placeholder: {}
                
                HStack {
                    Text(title)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.accent)
                .font(.title3)
                .fontWeight(.bold)
            }
            Divider()
        }
    }
}

#Preview {
    CategorySubView()
}
