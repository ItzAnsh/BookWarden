//
//  UserRecommendationView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 28/05/24.
//

import SwiftUI

struct UserRecommendationView: View {
    @State private var preferredBooks: [Book] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading) {
            TitleComponent(title: "You May Like", page: ArrivalBooks())
            
            if isLoading {
                ProgressView("Loading Recommendations...")
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 17) {
                        ForEach(preferredBooks) { book in
                            NavigationLink(destination: BookDescriptionView(book: book)) {
                                AsyncImage(url:  book.imageURL) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 150, height: 200)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .frame(width: 150, height: 200)
                                            .scaledToFit()
                                    case .failure:
                                        Image(systemName: "photo")
                                            .frame(width: 150, height: 200)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                        }
                    }
                }
                .safeAreaPadding(.horizontal)
                .scrollIndicators(.hidden)
            }
        }
        .background(grayGradient)
        .onAppear {
            fetchPreferredBooks()
        }
    }

    private func fetchPreferredBooks() {
        let accessToken = UserManager.shared.accessToken
        bookManager.fetchPreferredBooks(accessToken: accessToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let books):
                    self.preferredBooks = books
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    UserRecommendationView()
}
