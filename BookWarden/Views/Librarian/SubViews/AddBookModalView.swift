//
//  AddBookModalView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 07/06/24.
//

import SwiftUI

struct AddBookModalView: View {
    @State var ISBN: String = ""
    @State var bookName: String = ""
    @State var bookAuthor: String = ""
    @State var genre: String = ""
    @State var language: String = ""
    @State var publisher: String = ""
    @State var length = ""
    @State var ISBN10: String = ""
    @State var ISBN13: String = ""
    //    @Binding var modalState: Bool
    
    var body: some View {
        NavigationView {
            
            
            List {
                
                Section {
                    VStack {
                        Button(action: {}) {
                            Image(systemName: "barcode.viewfinder")
                                .foregroundColor(.blue)
                                .font(.system(size: 80))
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6)) // Set background to systemGray6
                    }
                    .listRowBackground(Color(.systemGray6)) // Make sure list row background matches
                }
                
                
                Section("CREATE FROM ISBN") {
                    //                    Text("ISBN")
                    HStack {
                        Text("ISBN")
                        Spacer()
                        TextField("Optional", text: $ISBN)
                    }
                }
                
                Section("CREATE MANUALLY") {
                    HStack {
                        Text("Book Name")
                        Spacer()
                        TextField("Required", text: $bookName)
                        //                        Spacer()
                    }
                    
                    HStack {
                        Text("Author")
                        Spacer()
                        TextField("Required", text: $bookAuthor)
                    }
                    
                    HStack {
                        Text("Genre")
                        Spacer()
                        TextField("Required", text: $genre)
                    }
                    
                    HStack {
                        Text("Language")
                        Spacer()
                        TextField("Required", text: $language)
                    }
                    
                    HStack {
                        Text("Publisher")
                        Spacer()
                        TextField("Required", text: $publisher)
                    }
                    
                    HStack {
                        Text("Page length")
                        Spacer()
                        TextField("Required", text: $length)
                            .keyboardType(.numberPad)
                    }
                    
                    HStack {
                        Text("ISBN10")
                        Spacer()
                        TextField("Required", text: $ISBN10)
                    }
                    
                    HStack {
                        Text("ISBN13")
                        Spacer()
                        TextField("Required", text: $ISBN13)
                    }
                }
            }
            .navigationTitle("Create Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button (action: {
                        //                        modalState = false
                    }) {
                        Text("Cancel")
                            .foregroundStyle(.blue)
                    }
                }
                
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: BookQuantitySelect()) {
                        
                        Text("Next")
                            .foregroundStyle(.blue)
                        
                    }
                }
            }
        }
        .accentColor(.blue)
    }
    
}

#Preview {
    AddBookModalView()
}

struct BookQuantitySelect: View {
    @State var totalQuantity = ""
    @State var availableQuantity = ""
    var body: some View {
        
        List {
            Section("BOOK QUANTITY") {
                HStack {
                    Text("Total Quantity")
                    TextField("", text: $totalQuantity)
                }
                
                HStack {
                    Text("Available Quantity")
                    TextField("", text: $availableQuantity)
                }
            }
        }
        .navigationTitle("Create Book")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            //            ToolbarItem(placement: .topBarLeading) {
            //                Button(action: {}) {
            //                    Text("Cancel")
            //                }
            //                .foregroundColor(.blue)
            //            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {}) {
                    Text("Done")
                        .foregroundStyle(.blue)
                }
            }
        }
        //        .foregroundColor(.blue)
        
    }
}
