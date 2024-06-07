//
//  IssuedBooks.swift
//  StatesLearning
//
//  Created by Vibho Sharma on 05/06/24.
//

import SwiftUI

struct IssuedBooks: View {
    var body: some View {
        NavigationStack {
            
            List {
                ForEach((0..<5), id: \.self) { _ in
                    IssuedBooksCard()
                }
            }
            .listStyle(.grouped)
            .navigationBarTitle("Issued Books", displayMode: .inline)
            
        }
        
        
    }
}

#Preview {
    IssuedBooks()
}
