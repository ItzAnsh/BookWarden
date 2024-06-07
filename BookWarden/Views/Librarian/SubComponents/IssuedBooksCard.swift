//
//  IssuedBooksCard.swift
//  StatesLearning
//
//  Created by Vibho Sharma on 05/06/24.
//


import SwiftUI

struct IssuedBooksCard : View {
    var image: String
    var name: String
    var authorName: String
    
    init() {
        self.image = "https://m.media-amazon.com/images/I/81w7a13pbnL.AC_SX500.jpg"
        self.name = "The Black Orphan"
        self.authorName = "Some Author"
    }
    
    init(image: String, name: String, authorName: String) {
        self.image = image
        self.name = name
        self.authorName = authorName
        
    }
    var body: some View {
            HStack() {
                AsyncImage(url: URL(string: image)) {image in
                    image
                        .resizable()
                        .frame(width: 100, height: 105)
                        .scaledToFill()
//                        .cornerRadius(8.0)
                    
                } placeholder: {}
                
                VStack(alignment: .leading, spacing: 9) {
                    Text(name)
                        .fontWeight(.bold)
                        .font(.title3)
                    Text(authorName)
                        .fontWeight(.bold)
                        .font(.caption)
                }
                Spacer()
                
                Text("RETURNED")

            }
        
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        
    }
}

#Preview {
    IssuedBooksCard()
}
