//
//  SingleLibraryView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 03/06/24.
//

import SwiftUI

struct SingleLibraryView: View {
    var title: String = "Chitkara University"
    var location: String = "Ground Floor, Law Block"
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .lineLimit(1)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(location)
                .lineLimit(1)
                .font(.caption)
            
            HStack {
                Button(action: {
                    
                }) {
                    Text("EDIT")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
//                        .padding(.horizontal)
                        .frame(width: 100)
                        .padding(.vertical, 8)
                        .background(.blue)
                        .cornerRadius(.infinity)
                        
                }
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    Text("DELETE")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
//                        .padding(.horizontal)
                        .frame(width: 100)
                        .padding(.vertical, 8)
                        .background(.blue)
                        .cornerRadius(.infinity)
                }
            }
            
            
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
    }
}

#Preview {
    SingleLibraryView()
}
