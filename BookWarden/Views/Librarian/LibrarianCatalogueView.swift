import SwiftUI

import SwiftUI

struct LibrarianCatalogueView: View {
    @State private var addModalPresent = false
    @State private var searchText: String = ""
    @State private var deleteBookAlert: Bool = false
    @State private var bookToDelete: String? = nil // Track the book to be deleted
    
    @ObservedObject var bookManager = BookManager.shared

    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return bookManager.books
        } else {
            return bookManager.books.filter { book in
                book.title.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var newArr: [[Book]] {
        var newArray: [[Book]] = []
        for i in stride(from: 0, to: filteredBooks.count, by: 2) {
            let end = min(i + 2, filteredBooks.count)
            let subArray = Array(filteredBooks[i..<end])
            newArray.append(subArray)
        }
        return newArray
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 35) {
                    ForEach(0..<self.newArr.count, id: \.self) { index in
                        HStack(spacing: 24) {
                            ForEach(newArr[index], id: \.id) { book in
                                CatalogueSingleBookSubView(
                                    alertState: $deleteBookAlert,
                                    id: book.id,
                                    image: book.imageURL,
                                    categoryType: .librarian,
                                    title: book.title,
                                    author: book.author,
                                    bookToDelete: $bookToDelete
                                )
                            }
                        }
                        .safeAreaPadding(.horizontal)
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Catalogue")
            .searchable(text: $searchText)
            .safeAreaPadding(.all)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        addModalPresent = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }
                }
            }
            .alert(isPresented: $deleteBookAlert) {
                Alert(
                    title: Text("Confirm Delete"),
                    message: Text("Are you sure you want to delete this book?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let bookId = bookToDelete?.trimmingCharacters(in: .whitespaces), !bookId.isEmpty {
                            let accessToken = UserManager.shared.accessToken
                            bookManager.deleteBook(bookID: bookId, accessToken: accessToken) { result in
                                switch result {
                                case .success:
                                    print("Deleted book with ID: \(bookId)")
                                case .failure(let error):
                                    print("Failed to delete book: \(error)")
                                }
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
//        .sheet(isPresented: $addModalPresent) {
//            AddBookModalView()
//        }
        .onAppear {
            let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
            bookManager.fetchBooksLibrarian(accessToken: accessToken) { result in
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
