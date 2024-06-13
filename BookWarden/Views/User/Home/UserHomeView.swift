//
//  UserHomeView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 27/05/24.
//
var grayGradient = LinearGradient(colors: [.secondaryColors, .tertiaryColors], startPoint: .top, endPoint: .bottom)
import SwiftUI

struct UserHomeView: View {
    @ObservedObject var bookManager = BookManager.shared
    @State private var recentBooks: [Book] = [] // State to hold recent books
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 10) {
                        ScrollView(.horizontal) {
                            HStack(spacing: 15) {
                                ForEach((1...4), id: \.self) { _ in
                                    HomeDeadlineCard()
                                }
                            }
                            .safeAreaPadding()
                        }
                    }
                    
                    VStack(spacing: 34) {
                        UserRecommendationView()
                        UserHomeGenresSubView()
                        
                        VStack {
                            TitleComponent(title: "Recent Books", page: ArrivalBooks())
                            
                            ScrollView(.horizontal) {
                                HStack(alignment:.top,spacing: 26) {
                                    ForEach(chunkBooks(recentBooks, chunkSize: 3), id: \.self) { chunk in
                                        VStack(spacing: 19) {
                                            ForEach(chunk, id: \.id) { book in
                                                RecentBooksCard(
                                                    image: book.imageURL,
                                                    name: book.title,
                                                    authorName: book.author
                                                )
                                            }
                                        }
                                    }
                                }
                                .safeAreaPadding(.horizontal)
                            }
                        }
                        .background(grayGradient)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Home")
            .background(Color(.backgroundColors))
        }
        .onAppear {
            let accessToken = UserManager.shared.accessToken
            bookManager.fetchBooks(accessToken: accessToken) { result in
                switch result {
                case .success(let books):
                    print("Fetched \(books.count) books")
                case .failure(let error):
                    print("Failed to fetch books: \(error.localizedDescription)")
                }
            }
            bookManager.fetchPreferredBooks(accessToken: accessToken) { result in
                switch result {
                case .success(let books):
                    print("Fetched preferred books:")
                    books.forEach { print($0.title) }
                case .failure(let error):
                    print("Error fetching preferred books: \(error.localizedDescription)")
                }
            }
            bookManager.fetchRecentBooks(accessToken: accessToken) { result in
                switch result {
                case .success(let books):
                    self.recentBooks = books // Store fetched recent books
                    print("Fetched recent books:")
                    books.forEach { print($0.title) }
                case .failure(let error):
                    print("Error fetching recent books: \(error.localizedDescription)")
                }
            }
            BookManager.shared.fetchCategories(accessToken: accessToken) { result in
                switch result {
                case .success(let categories):
                    print("Categories fetched: \(categories)")
                case .failure(let error):
                    print("Failed to fetch categories: \(error)")
                }
            }
        }
    }
}
func chunkBooks(_ books: [Book], chunkSize: Int) -> [[Book]] {
    var chunks: [[Book]] = []
    for i in stride(from: 0, to: books.count, by: chunkSize) {
        let endIndex = min(i + chunkSize, books.count)
        let chunk = Array(books[i..<endIndex])
        chunks.append(chunk)
    }
    return chunks
}
