////
////  AddBookModalView.swift
////  BookWarden
////
////  Created by Ansh Bhasin on 07/06/24.
////
//
//import SwiftUI
//
//struct AddBookModalView: View {
//    @State var ISBN: String = ""
//    @State var bookName: String = ""
//    @State var bookAuthor: String = ""
//    @State var genre: String = ""
//    @State var language: String = ""
//    @State var publisher: String = ""
//    @State var length = ""
//    @State var ISBN10: String = ""
//    @State var ISBN13: String = ""
//    //    @Binding var modalState: Bool
////    @State var isShowingScanner = false
//    
//    @State var isbnMode = false
//    
//    var body: some View {
//        NavigationView {
//            
//            
//            List {
//                
//                Section {
//                    QRScannerView(ISBNCode: $ISBN, ISBN10: $ISBN10, ISBN13: $ISBN13, bookName: $bookName, bookAuthor: $bookAuthor, genre: $genre, publisher: $publisher, length: $length)
//                }
//                
//                
//                Section("CREATE FROM ISBN") {
//                    //                    Text("ISBN")
//                    HStack {
//                        Text("ISBN")
//                        Spacer()
//                        TextField("Optional", text: $ISBN)
//                    }
//                }
//                
//                Section("CREATE MANUALLY") {
//                    HStack {
//                        Text("Book Name")
//                        Spacer()
//                        TextField("Required", text: $bookName)
//                        //                        Spacer()
//                    }
//                    
//                    HStack {
//                        Text("Author")
//                        Spacer()
//                        TextField("Required", text: $bookAuthor)
//                    }
//                    
//                    HStack {
//                        Text("Genre")
//                        Spacer()
//                        TextField("Required", text: $genre)
//                    }
//                    
//                    HStack {
//                        Text("Language")
//                        Spacer()
//                        TextField("Required", text: $language)
//                    }
//                    
//                    HStack {
//                        Text("Publisher")
//                        Spacer()
//                        TextField("Required", text: $publisher)
//                    }
//                    
//                    HStack {
//                        Text("Page length")
//                        Spacer()
//                        TextField("Required", text: $length)
//                            .keyboardType(.numberPad)
//                    }
//                    
//                    HStack {
//                        Text("ISBN10")
//                        Spacer()
//                        TextField("Required", text: $ISBN10)
//                    }
//                    
//                    HStack {
//                        Text("ISBN13")
//                        Spacer()
//                        TextField("Required", text: $ISBN13)
//                    }
//                }
//            }
//            .navigationTitle("Create Book")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button (action: {
//                        //                        modalState = false
//                    }) {
//                        Text("Cancel")
//                            .foregroundStyle(.blue)
//                    }
//                }
//                
//                
//                ToolbarItem(placement: .topBarTrailing) {
//                    NavigationLink(destination: BookQuantitySelect(
//                    bookName: $bookName, bookAuthor: $bookAuthor, genre: $genre, language: $language, publisher: $publisher, length: $length, ISBN10: $ISBN10, ISBN13: $ISBN13
//                    )) {
//                        
//                        Text("Next")
//                            .foregroundStyle(.blue)
//                        
//                    }
//                }
//            }
//        }
//        .accentColor(.blue)
//    }
//    
//}
//
//#Preview {
//    AddBookModalView()
//}
//
//struct BookQuantitySelect: View {
//    @Binding var bookName: String
//    @Binding var bookAuthor: String
//    @Binding var genre: String
//    @Binding var language: String
//    @Binding var publisher: String
//    @Binding var length: String
//    @Binding var ISBN10: String
//    @Binding var ISBN13: String
//    @State var totalQuantity = ""
//    @State var availableQuantity = ""
//    var body: some View {
//        
//        List {
//            Section("BOOK QUANTITY") {
//                HStack {
//                    Text("Total Quantity")
//                    TextField("", text: $totalQuantity)
//                }
//                
//                HStack {
//                    Text("Available Quantity")
//                    TextField("", text: $availableQuantity)
//                }
//            }
//        }
//        .navigationTitle("Create Book")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            //            ToolbarItem(placement: .topBarLeading) {
//            //                Button(action: {}) {
//            //                    Text("Cancel")
//            //                }
//            //                .foregroundColor(.blue)
//            //            }
//            
//            ToolbarItem(placement: .topBarTrailing) {
//                Button(action: {
//                    BookManager.shared.createBook(book: Book(id: "", title: bookName, author: bookAuthor, description: "", genre: genre, price: 0, publisher: "New publisher", language: language, length: Int(length) ?? 0, imageURL: URL(string: "https://m.media-amazon.com/images/I/81KeOD++BBL._AC_UL640_FMwebp_QL65_.jpg")!, isbn10: "100223445", isbn13: "1292123789012"), token: UserDefaults.standard.string(forKey: "authToken") ?? "") { result in
//                        switch result {
//                        case .success():
//                            print("Added the book")
//                        case .failure(let error):
//                            print("Failed to create book: \(error)")
//                        }
//                        
//                    }
//                }) {
//                    Text("Done")
//                        .foregroundStyle(.blue)
//                }
//            }
//        }
//        //        .foregroundColor(.blue)
//        
//    }
//}
