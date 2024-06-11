import SwiftUI

struct UserLibraryView: View {
    @ObservedObject var bookManager = BookManager.shared
    
    var newArr: [[Book]] {
        var newArray: [[Book]] = []
        
        for i in stride(from: 0, to: bookManager.books.count, by: 2) {
            let end = min(i + 2, bookManager.books.count)
            let subArray = Array(bookManager.books[i..<end])
            newArray.append(subArray)
        }
        
        return newArray
    }
    
    @State var issuedBookAlert: Bool = false
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 35) {
                    ForEach(0..<self.newArr.count, id: \.self) { index in
                        HStack(spacing: 24) {
                            ForEach(newArr[index], id: \.id) { book in
//                                Spacer()
                                CatalogueSingleBookSubView(alertState: $issuedBookAlert, image: book.imageURL, title: book.title, author: book.author)
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
            .alert("Are you sure?", isPresented: $issuedBookAlert) {
//                Alert("Are you sure?") {
                Button("Issue", role: .cancel) {}
                    Button("Cancel", role: .destructive) {}
                    
//                }
            } message: {
                Text("Are you sure you want to issue this book")
            }
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

#Preview {
    UserLibraryView()
}
