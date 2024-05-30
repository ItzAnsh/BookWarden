//
//  HomeDeadlineCard.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 28/05/24.
//

import SwiftUI

enum ReturnType {
    case days
    case months
    case years
}

struct HomeDeadlineCard: View, CustomStringConvertible {
    var image: String
    var bookName: String
    var daysLeft: Int
    var description: String {
        // daysLeft is lower than 30
        if daysLeft < 30 {
            return "\(daysLeft) days remaining"
        }
        
        // days is greater than a month but not more than a year
        if daysLeft > 30 && daysLeft < 365 {
                return "\(Int(daysLeft / 30)) months remaining"
        }
        
        if daysLeft > 365 {
            let years = daysLeft / 365
            return "\(years) \(years > 1 ? "years" : "year") remaining"
        }
        
        return ""
    }
    
    init(image: String, bookName: String, daysLeft: Int) {
        self.image = image
        self.bookName = bookName
        self.daysLeft = daysLeft
    }
    
    init() {
        self.image = "https://m.media-amazon.com/images/I/81zeKRGCPpL._AC_UY436_FMwebp_QL65_.jpg"
        self.bookName =  "Harry Potter"
        self.daysLeft = 10
    }
    
    
    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: URL(string: image)) {image in
                    image.resizable().scaledToFill()
                } placeholder: {}
                    .frame(width: 34, height: 43)
                    .aspectRatio(contentMode: .fit)
                
                VStack(alignment: .leading) {
                    Text("Harry Potter and Goblet of Fire")
                        .lineLimit(1)
                        .foregroundStyle(.textPrimaryColors)
                        .font(.headline)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.textSecondaryColors)
                }
            }
        }
        .frame(width: 208)
        .padding(.horizontal, 12)
        .padding(.vertical, 17)
        .background(.secondaryColors)
        .cornerRadius(7)
        .shadow(radius: 2)
    }
}

#Preview {
    HomeDeadlineCard()
}
