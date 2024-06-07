//
//  FinesViewCard.swift
//  StatesLearning
//
//  Created by Vibho Sharma on 05/06/24.
//

import SwiftUI

struct FinesViewCard : View {
    var image: String
    var name: String
    var authorName: String
    
    init() {
        self.image = "https://m.media-amazon.com/images/I/81w7a13pbnL.AC_SX500.jpg"
        self.name = "The Black Orphan"
        self.authorName = "Rs 25"
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
                        .font(.headline)
                    Text(authorName)
                        .fontWeight(.light)
                        .font(.caption)
                }
                Spacer()
                
                Text("Paid")

            }
        
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        
    }
}

#Preview {
    FinesViewCard()
}
