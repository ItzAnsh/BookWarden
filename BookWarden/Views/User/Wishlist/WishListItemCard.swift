//
//  WishListItemCard.swift
//  BookWarden
//
//  Created by Manan Gupta on 30/05/24.
//

import SwiftUI

enum UserType {
    case admin
    case librarian
    case member
}

struct WishListItemCard: View {
    var image: String
    var name: String
    var authorName: String
    var numberofStar: Int
    var numberofReviews: Int
    var userType: UserType
    
    init(userType: UserType) {
        self.image = "https://m.media-amazon.com/images/I/81w7a13pbnL.AC_SX500.jpg"
        self.name = "The Black Orphan"
        self.authorName = "S. Hussain Zaidi"
        self.numberofStar = 4
        self.numberofReviews = 8363
        self.userType = userType
    }
    
    init(image: String, name: String, authorName: String, numberofStar: Int, numberofReviews: Int, userType: UserType) {
        self.image = image
        self.name = name
        self.authorName = authorName
        self.numberofStar = numberofStar
        self.numberofReviews  = numberofReviews
        self.userType = userType
        
    }
    var body: some View {
        HStack(spacing: 12 ){
            VStack {
                AsyncImage(url: URL(string: image)) {image in
                    image
                        .resizable()
                        .frame(width: 132, height: 165)
                        .scaledToFill()
                    
                } placeholder: {}
            }
            
            
            HStack() {
                VStack(alignment: .leading, spacing: 9.5) {
                    Text(name)
                        .lineLimit(2)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    Text("Sun Tuz")
                        .font(.body)
                    HStack(spacing: 4){
                        ForEach(0..<5) { index in Image(systemName: index < numberofStar ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 13, height: 13)
                                .foregroundColor(.black)
                        }
                        Text("(\(numberofReviews))")
                            .font(.caption2)
                    }
                    if userType == .admin || userType == .librarian { Text("Issued On - 29/04/2024")
                            .font(.caption2)
                    }
                    else {
                        HStack(spacing: 15){
                            Button(action: {
                                
                                print("Button tapped")
                            }) {
                                Text("ISSUE")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 100, height: 30)
                                    .background(Color.blue)
                                    .cornerRadius(50)
                            }
                            Image(systemName: "ellipsis")
                                .resizable()
                                .frame(width: 20, height: 5)
                        }
                    }
                }
                
                //            .padding(30)
                Spacer()
            }
        }
        
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    }
}
#Preview {
    WishListItemCard(userType: .member)
}
