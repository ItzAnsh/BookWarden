import SwiftUI

struct CreateBookView: View {
    @State private var title = ""
    @State private var author = ""
    @State private var description = ""
    @State private var price = ""
    @State private var genreid = ""
    @State private var publisher = ""
    @State private var language = ""
    @State private var length = ""
    @State private var releaseDate = ""
    @State private var imageURL = ""
    @State private var isbn10 = ""
    @State private var isbn13 = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    @Environment(\.presentationMode) private var presentationMode

    private var isFormValid: Bool {
        !title.isEmpty && !author.isEmpty && !description.isEmpty &&
        !price.isEmpty && !genreid.isEmpty && !publisher.isEmpty &&
        !language.isEmpty && !length.isEmpty && !releaseDate.isEmpty &&
        !imageURL.isEmpty && !isbn10.isEmpty && !isbn13.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Book Details")) {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                    TextField("Description", text: $description)
                    TextField("Price", text: $price)
                        .keyboardType(.numberPad)
                    TextField("Genre ID", text: $genreid)
                    TextField("Publisher", text: $publisher)
                    TextField("Language", text: $language)
                    TextField("Length", text: $length)
                        .keyboardType(.numberPad)
                    TextField("Release Date", text: $releaseDate)
                    TextField("Image URL", text: $imageURL)
                    TextField("ISBN-10", text: $isbn10)
                    TextField("ISBN-13", text: $isbn13)
                }
            }
            .navigationTitle("Add Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        createBook()
                    }) {
                        Text("Done")
                            .foregroundStyle(.accent)
                            .opacity(isFormValid ? 1.0 : 0.2) // Adjust opacity based on form validity
                    }
                    .disabled(!isFormValid) // Disable button if form is not valid
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Book Creation"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                    if alertMessage == "Book created successfully" {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
            }
        }
    }

    private func createBook() {
        guard let url = URL(string: imageURL) else {
            alertMessage = "Invalid Image URL"
            showAlert = true
            return
        }

        guard let priceValue = Double(price), let lengthValue = Int(length) else {
            alertMessage = "Invalid Price or Length"
            showAlert = true
            return
        }

        var bookDictionary : [String: Any] = [:]
        bookDictionary["title"] = title
        bookDictionary["author"] = author
        bookDictionary["description"] = description
        bookDictionary["genre"] = genreid // Assuming Genre is created with an ID
        bookDictionary["price"] = priceValue
        bookDictionary["publisher"] = publisher
        bookDictionary["language"] = language
        bookDictionary["length"] = lengthValue
        bookDictionary["releaseDate"] = releaseDate
        bookDictionary["imageURL"] = imageURL
        bookDictionary["isbn10"] = isbn10
        bookDictionary["isbn13"] = isbn13

        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        BookManager.shared.createBook(bookDictionary: bookDictionary, token: token) { result in
            switch result {
            case .success(let book):
                print(book)
                alertMessage = "Book created successfully"
            case .failure(let error):
                alertMessage = "Failed to create book: \(error.localizedDescription)"
            }
            showAlert = true
        }
    }
}
