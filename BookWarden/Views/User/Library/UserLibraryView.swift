import SwiftUI

struct UserLibraryView: View {
    @ObservedObject var bookManager = BookManager.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 35) {
                    ForEach(bookManager.books) { book in
                        HStack(spacing: 24) {
                            CatalogueSingleBookSubView(image: book.imageURL)
                            CatalogueSingleBookSubView(image: book.imageURL)
                        }
                    }
                }
                .safeAreaPadding()
            }
            .navigationTitle("Library")
        }
        .onAppear() {
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
