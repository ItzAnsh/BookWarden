//
//  AdminAddLibrarySubView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 03/06/24.
//

import SwiftUI

struct AdminAddLibrarySubView: View {
    @State private var libraryName = ""
    @State private var libraryLocation = ""
    @State private var librarianEmail = ""
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Library Details")) {
                    TextField("Enter library name", text: $libraryName)
                    TextField("Library location", text: $libraryLocation)
                }
                
                Section(header: Text("Add Librarian")) {
                    TextField("Librarian email", text: $librarianEmail)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination:  Text("Back")) {
                        Text("Back")
                    }
                    .foregroundStyle(.blue)
                }
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(destination:  Text("Done")) {
                    Button(action: {}) {
                        Text("Done")
                    }
//                    }
                    .foregroundStyle(.blue)
                }
                
            }
            .toolbarBackground(Color(.systemGray6))
            .toolbarBackground(.visible)
//            .preferredColorScheme(.dark)
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    AdminAddLibrarySubView()
}
