import SwiftUI

struct UserLibraryView: View {
    @ObservedObject var bookManager = BookManager.shared
    @State private var bookToDelete: String? = ""
        var newArr: [[Book]] {
        var newArray: [[Book]] = []
        
        for i in stride(from: 0, to: bookManager.books.count, by: 2) {
            let end = min(i + 2, bookManager.books.count)
            let subArray = Array(bookManager.books[i..<end])
            newArray.append(subArray)
        }
        
        return newArray
    }
    
//    @State var selectedLibrary: Location = Location(id: <#T##String#>, libraryId: <#T##Library#>, bookId: <#T##String#>, totalQuantity: <#T##Int#>, availableQuantity: <#T##Int#>)
    @State var selectedLocation: Location? = nil
    
    @State var issuedBookAlert: Bool = false
    @State var searchText: String = ""
    @State var currBook: Book = Book(id: "sample", title: "sample", author: "sample", description: "sample", genre: Genre(id: "sameple", name: "sample", v: 0), price: 0.0, publisher: "sample", language: "sample", length: 10, imageURL: URL(string: "https://www.google.com/")!, isbn10: "idmamsd", isbn13: "sajdjamdj", v: 0, location: [])
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 35) {
                    ForEach(0..<self.newArr.count, id: \.self) { index in
                        HStack(spacing: 24) {
                            ForEach(newArr[index], id: \.id) { book in
//                                Spacer()
                                CatalogueSingleBookSubView(alertState: $issuedBookAlert,book: book, bookToDelete: $bookToDelete, currBook: $currBook)
//                                Spacer()
                            }
                        }
//                        .frame()
                        .safeAreaPadding(.horizontal)
                    }
                }
                .padding(.horizontal)
//                .safeAreaPadding()
            }
            .searchable(text: $searchText)
            .navigationTitle("Library")
//            .alert("Are you sure?", isPresented: $issuedBookAlert) {
////                Alert("Are you sure?") {
//                Button("Issue", role: .cancel) {}
//                    Button("Cancel", role: .destructive) {}
//                    
////                }
//            } message: {
//                Text("Are you sure you want to issue this book")
//            }
        }
        .sheet(isPresented: $issuedBookAlert) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    HStack {
                        AsyncImage(url: currBook.imageURL) { image in
                            image
                                .resizable()
                                .frame(width: 94, height: 133)
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        
                        VStack(alignment: .leading) {
                            Text(currBook.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(currBook.author)
                                .font(.headline)
                                .fontWeight(.regular)
                            
                            
                        }
                    }
                    Divider()
                    HStack() {
                        Text("Select a library")
                        Spacer()
                        Picker("", selection: $selectedLocation) {
                            ForEach((currBook.location), id: \.self) { location in
                                Text(location.libraryId.getName())
                            }
                        }
                        .accentColor(.black)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
//                .padding()
                
//                .safeAreaPadding()
                
                Button(action: {}) {
                    Text("Issue")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding()
                .background(.accent)
                .cornerRadius(.infinity)
            }
            .safeAreaPadding(.horizontal)
            .presentationDetents([.medium])
        }
        .onAppear {
            // Assuming you fetch the accessToken from your UserManager
            let accessToken = UserManager.shared.accessToken
            bookManager.fetchBooks(accessToken: accessToken) { result in
                switch result {
                case .success(let books):
                    print("Fetched \(books.count) books")
                case .failure(let error):
                    print("Failed to fetch books: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct BookRowView: View {
    var book: Book
    
    var body: some View {
        HStack {
            AsyncImage(url: book.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 75)
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                Text(book.author)
                    .font(.subheadline)
                Text(String(format: "%.2f", book.price))
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding()
    }
}
//
//#Preview {
//    UserLibraryView()
//}
