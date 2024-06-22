import SwiftUI

enum CatalogueTypes {
    case member
    case librarian
}

struct CatalogueSingleBookSubView: View {
    @Binding var alertState: Bool
    var book: Book
    var categoryType: CatalogueTypes = .member
    var available: Bool = true
    
//    @Binding var bookLibrary: String?
    @Binding var bookToDelete: String?
    @Binding var currBook: Book?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            NavigationLink(destination: BookDescriptionView(book: book)) {
                AsyncImage(url: book.imageURL) { image in
                    image
                        .resizable()
                        .frame(width: 161, height: 201)
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
            }
            
            VStack {
                HStack {
                    Button(action: {
                        // Action for the Request button
                        currBook = book
                        if categoryType == .member {
                            alertState = true
                            currBook = book
                        } else {
                            
                            bookToDelete = book.id
                        }
                    }) {
                        Text(categoryType == .librarian ? "Request" : "ISSUE")
                            .foregroundStyle(.textTertiaryColors)
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(categoryType == .librarian ? .blue : .accent)
                    .cornerRadius(.infinity)
                    
                    Spacer()
                    
                    Button(action: {
                        if categoryType == .member {
                            
                        } else {
                            alertState = true
                            bookToDelete = book.id
                        }
                    }) {
                        Image(systemName: categoryType == .librarian ? "trash.fill" : "ellipsis")
                            .font(.system(size: 17))
                            .foregroundColor(categoryType == .librarian ? .blue : .textPrimaryColors)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity / 2)
        .frame(width: 161)
    }
}
