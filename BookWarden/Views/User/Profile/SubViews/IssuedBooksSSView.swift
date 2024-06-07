//
//  SwiftUIView.swift
//
//
//  Created by Abhi  on 31/05/24.
//

import Foundation
import SwiftUI

struct IssuedBooksSSView: View {
    var images: [String] =
    [
        "https://m.media-amazon.com/images/I/81DXIOk9glL._AC_UY436_FMwebp_QL65_.jpg",
       "https://m.media-amazon.com/images/I/61aJc8wQX4L._AC_UY436_FMwebp_QL65_.jpg "]
    
    var image: URL
    
    init() {
        self.image = URL(string: "https://m.media-amazon.com/images/I/81DXIOk9glL._AC_UY436_FMwebp_QL65_.jpg")!
    }
    
    init(image: URL) {
        self.image = image
    }

    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                if let firstImage = images.first { // Access the first image
                    AsyncImage(url: image) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .frame(width: 167, height: 209)
                                .scaledToFill()
                        } else if phase.error != nil {
                            Color.red // Indicates an error
                                .frame(width: 167, height: 209)
                                .cornerRadius(10.0)
                        } else {
                            Color.gray // Acts as a placeholder
                                .frame(width: 167, height: 209)
                                .cornerRadius(10.0)
                        }
                    }
                }
                Button(action: {
                    
                    print("Button tapped")
                }) {
                    Text("RENEW")
                        .fontWeight(.bold)
                        .font(.system(size: 11))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 76, height: 24)
                        .background(Color.blue)
                        .cornerRadius(50)
                }
            }
            Spacer()
            VStack(alignment: .leading) {
                if let firstImage = images.first { // Access the first image
                    AsyncImage(url: URL(string: firstImage)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .frame(width: 167, height: 209)
                                .scaledToFill()
                                
                        } else if phase.error != nil {
                            Color.red // Indicates an error
                                .frame(width: 167, height: 209)
                                .cornerRadius(10.0)
                        } else {
                            Color.gray // Acts as a placeholder
                                .frame(width: 167, height: 209)
                                .cornerRadius(10.0)
                        }
                    }
                }
                Button(action: {
                    
                    print("Button tapped")
                }) {
                    Text("RENEW")
                        .fontWeight(.bold)
                        .font(.system(size: 11))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 76, height: 24)
                        .background(Color.blue)
                        .cornerRadius(50)
                }
            }
        }
        .padding()
    }
}



#Preview {
    IssuedBooksSSView()
}
