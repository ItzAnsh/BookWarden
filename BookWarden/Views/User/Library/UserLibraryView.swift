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
    
    @State var selectedLocation: Location? = nil
    @State var issuedBookAlert: Bool = false
    @State var searchText: String = ""
    @State var currBook: Book? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 35) {
                    ForEach(0..<self.newArr.count, id: \.self) { index in
                        HStack(spacing: 24) {
                            ForEach(newArr[index], id: \.id) { book in
                                CatalogueSingleBookSubView(alertState: $issuedBookAlert, book: book, bookToDelete: $bookToDelete, currBook: $currBook)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
            }
            .searchable(text: $searchText)
            .navigationTitle("Library")
        }
        .sheet(isPresented: $issuedBookAlert, onDismiss: {
            selectedLocation = nil
            currBook = nil
        }) {
            if let currBook = currBook {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading) {
                        HStack {
                            AsyncImage(url: currBook.imageURL ?? URL(string: "https://mir-s3-cdn-cf.behance.net/projects/max_808_webp/244c61196936933.Y3JvcCw3MjksNTcwLDg2LDE0.png")!) { image in
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
                        HStack {
                            Text("Select a library")
                            Spacer()
                            Picker("", selection: $selectedLocation) {
                                ForEach((currBook.location), id: \.self) { location in
                                    Text(location.libraryId.getName())
                                }
                            }
                            .accentColor(.black)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    
                    Button(action: {
                        guard let selectedLocation = selectedLocation else { return }
                        BookManager.shared.issueBook(bookId: currBook.id, libraryId: selectedLocation.libraryId.id, accessToken: UserDefaults.standard.string(forKey: "authToken") ?? "") { result in
                            switch result {
                            case .success:
                                print("Book issued successfully")
                            case .failure:
                                print("Failed to issue book")
                            }
                        }
                    }) {
                        Text("Issue")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .presentationDetents([.medium])
                .onAppear {
                    selectedLocation = currBook.location.first
                }
            }
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
        }
    }
}
