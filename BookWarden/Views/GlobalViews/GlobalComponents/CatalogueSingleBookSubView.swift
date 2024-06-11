//
//  CatalogueSingleBookSubView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 31/05/24.
//

import SwiftUI

enum CatalogueTypes {
    case member
    case librarian
}

struct CatalogueSingleBookSubView: View {
    @Binding var alertState: Bool
    var image: URL
    var categoryType: CatalogueTypes = .member
    var available: Bool = true
    var title: String
    var author: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            NavigationLink(destination: BookDescriptionView(title: title, image: image, author: author)) {
                AsyncImage(url: image) {image in
                    image
                        .resizable()
                        .frame(width: 161, height: 201)
                        .scaledToFill()
                    if available {
                        
                    }
                    
                } placeholder: {
                    ProgressView()
                }
            }
            
            VStack {
                HStack {
                    
                    Button(action: {
                        alertState = true
                    }) {
                        Text(categoryType == .librarian ? "Request" : "ISSUE")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(categoryType == .librarian ? .blue : .accent)
                    .cornerRadius(.infinity)
                    
                    Spacer()
                    
                    Image(systemName: categoryType == .librarian ? "trash.fill" : "ellipsis")
                        .font(.system(size: 17))
                        .foregroundColor(categoryType == .librarian ? /*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/ : .textPrimaryColors)
                }
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/ / 2)
        .frame(width: 161)
        
    }
}


//#Preview {
//    CatalogueSingleBookSubView(image: URL(string: "https://m.media-amazon.com/images/I/81w7a13pbnL.AC_SX500.jpg") ?? "")
//}
