//
//  SwiftUIView.swift
//
//
//  Created by Manan Gupta on 31/05/24.
//

import Foundation
import SwiftUI

struct BookFineCard: View {
    var image: URL
    var name: String
    var finePerDay: Int
    var numberOfDays: Int
    var libraryName: String
    
    init() {
        self.image = URL(string: "https://m.media-amazon.com/images/I/81w7a13pbnL.AC_SX500.jpg")!
        self.name = "The Black Orphan"
        self.finePerDay = 5
        self.numberOfDays = 8
        self.libraryName = "Law Block Library"
    }
    
    init(image: URL, name: String, finePerDay: Int, numberOfDays: Int, libraryName: String) {
        self.image = image
        self.name = name
        self.finePerDay = finePerDay
        self.numberOfDays = numberOfDays
        self.libraryName = libraryName
        
    }
    
    var body: some View {
        VStack{
            HStack{
                VStack{
                    AsyncImage(url: image) {image in
                        image
                            .resizable()
                            .frame(width: 75, height: 94)
                            .scaledToFill()
                        
                    } placeholder: {}
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                Spacer()
                VStack(alignment: .leading){
                    VStack{
                        Text(name)
                            .font(.system(size: 18))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    VStack{
                        HStack(spacing:1){
                            Text("Rs \(finePerDay*numberOfDays)")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                            Text("(Rs. \(finePerDay)/day)")
                                .font(.system(size: 11))
                                .fontWeight(.medium)
                        }
                    }
                    VStack{
                        Text("Issued from \(libraryName)")
                            .fontWeight(.light)
                            .font(.system(size: 10))
                    }
                }
                Spacer()
                VStack{
                    Button(action: {
                        
                        print("Button tapped")
                    }) {
                        Text("Pay Now")
                            .font(.headline)
                            .font(.system(size: 33))
                            .foregroundColor(.white)
                            .frame(width: 83, height: 30)
                            .background(Color.blue)
                            .cornerRadius(50)
                    }
                }
                .padding(.horizontal)
            }
            Divider()
                .frame(width: 393)
        }
    }
}

#Preview {
    BookFineCard()
}
