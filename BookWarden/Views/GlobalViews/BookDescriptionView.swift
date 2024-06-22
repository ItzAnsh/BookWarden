import SwiftUI

struct BookTopView: View {
    @State var screenSize: CGSize = .zero
    @Binding var alertState: Bool
    @Binding var liked: Bool
    @Binding var issuedStatus: IssueStatus?
    
    @Environment(\.colorScheme) var colorScheme
    
    var image: URL
    var title: String
    var author: String
    var location: String
    
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    // Book Card
                    VStack {
                        // Book Cover
                        AsyncImage(url: image) {image in
                            image
                                .resizable()
                                .frame(width: 268, height: 365)
                                .scaledToFill()
                            
                            
                        } placeholder: {
                            ProgressView()
                        }
                        
                        
                        Text(title != "" || title.trimmingPrefix(" ").isEmpty ? title : "Book Title")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                        
                        Text(author != "" || author.trimmingPrefix(" ").isEmpty ? author : "Book author")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        
                        HStack {
                            
                            VStack(spacing: 2) {
                                HStack(spacing:0) {
                                    ForEach(0..<4) { _ in
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 12))
                                    }
                                    Image(systemName: "star.leadinghalf.filled")
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 12))
                                }
                                Text("7614 Ratings")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 120)
                            
                            Spacer()
                            
                            
                            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                                Button(action: {
                                    alertState = true
                                }) {
                                    Text("ISSUE")
                                        .fontWeight(.bold)
                                        .padding(.vertical, 11)
                                        .padding(.horizontal, 26)
                                        .background(.accent)
                                        .foregroundColor(.white)
                                        .cornerRadius(.infinity)
                                }
                            }
                            .frame(width: 120)
                            //203 205 251
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Image(systemName: liked ? "heart.fill" : "heart")
                                    .foregroundColor(liked ? .accent : .gray)
                                    .padding(.leading, 10)
                                    .onTapGesture {
                                        liked.toggle()
                                    }
                            }.frame(width: 120)
                                
                        }
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                        
                        if location != "Not available" {
                            Text("Available at Shelf-\((1...40).randomElement()!)")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        }
                        
                        Text("\(location)")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.bottom, 10)
                    }
                    
                    
                    
                    .padding(.top, 32)
                    .padding(.bottom, 21)
                    .background(colorScheme == .light ? .white : Color(UIColor.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12.0))
                    .cornerRadius(18.0)
                    
                }
            }
//            Spacer()
        }
        
        
        
        .frame(height: UIScreen.main.bounds.height - 200)
        .padding(.all, 20)
        
        
        
    }
}

struct BookDescriptionView: View {
    var book: Book
    
    @State var issuedBookAlert: Bool = false
    @State var liked: Bool = false
    @State var issuedStatus: IssueStatus? = nil
    @State var selectedLocation: Location?
    @State var issueAlert : Bool = false
    
//    @State var currBook: Book = self.book
    
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ScrollView {
            NavigationStack {
                
                VStack {
                    BookTopView(screenSize: .zero, alertState: $issuedBookAlert, liked: $liked, issuedStatus: $issuedStatus, image: book.imageURL, title: book.title, author: book.author, location: book.location.count > 0 ? book.location[0].libraryId.getName() : "Not available")
//                    ScrollView(.horizontal) {
                        HStack {
                            VStack(alignment: .center) {
                                Text("GENRE")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("Fiction")
                                    .font(.system(size: 15))
                                    .padding(.top,1)
                                
                            }
                            
                            Spacer()
                            Divider().frame(width: 1)
                            Spacer()
                            
                            VStack(alignment: .center) {
                                Text("LANGUAGE")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("English")
                                    .font(.system(size: 15))
                                    .padding(.top,1)
                            }
                            
                            Spacer()
                            Divider().frame(width: 1)
                            Spacer()
                            
                            VStack(alignment: .center) {
                                Text("LENGTH")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("380 Pages")
                                    .font(.system(size: 15))
                                    .padding(.top,1)
                            }
                            
                            Spacer()
                            Divider().frame(width: 1)
                            Spacer()
                            
                            VStack(alignment: .center) {
                                Text("PUBLISHER")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("Public Domain")
                                    .font(.system(size: 15))
                                    .padding(.top,1)
                            }
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
//                        .padding()
                        .safeAreaPadding()
//                    }
                    
                    Divider()
                    
                    NavigationLink(destination: RatingsAndReviewsView()) {
                        HStack {
                            Text("Ratings and Reviews")
                                .fontWeight(.bold)
                                .foregroundColor(.accent)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.accent)
                        }
                        .padding()
                    }
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ReviewCardView()
                            ReviewCardView()
                        }
                        .padding(.horizontal)
                    }
                    .scrollIndicators(.hidden)
                    
                    NavigationLink(destination: MoreInSeriesView()) {
                        HStack {
                            Text("More in the Series")
                                .fontWeight(.bold)
                                .foregroundColor(.accent)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.accent)
                        }
                        .padding()
                    }
                    
                    HStack {
                        BookCoverView(imageName: "iphone_user_guide")
                        BookCoverView(imageName: "august_expenses")
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    
                    
                }
                
            }
        }
        .background(colorScheme == .light ? Color(UIColor.systemGray6) : Color(.black))
//        .alert("Are you sure?", isPresented: $issuedBookAlert) {
////                Alert("Are you sure?") {
//            Button("Issue", role: .cancel) {
//                BookManager.shared.issueBook(bookId: book.id, libraryId: book.location[0].id, accessToken: UserDefaults.standard.string(forKey: "authToken") ?? "") {
//                    _ in
//                }
//            }
//                Button("Cancel", role: .destructive) {}
//                
////                }
//        } message: {
//            Text("Are you sure you want to issue this book")
//        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $issuedBookAlert, onDismiss: {
            selectedLocation = nil
//            book = nil
        }) {
//            if let currBook = book {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading) {
                        HStack {
                            AsyncImage(url: book.imageURL ?? URL(string: "https://mir-s3-cdn-cf.behance.net/projects/max_808_webp/244c61196936933.Y3JvcCw3MjksNTcwLDg2LDE0.png")!) { image in
                                image
                                    .resizable()
                                    .frame(width: 94, height: 133)
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text(book.author)
                                    .font(.headline)
                                    .fontWeight(.regular)
                            }
                        }
                        Divider()
                        HStack {
                            Text("Select a library")
                            Spacer()
                            Picker("", selection: $selectedLocation) {
                                ForEach((book.location), id: \.self) { location in
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
                        BookManager.shared.issueBook(bookId: book.id, libraryId: selectedLocation.libraryId.id, accessToken: UserDefaults.standard.string(forKey: "authToken") ?? "") { result in
                            switch result {
                            case .success:
                                issueAlert = true
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
                    selectedLocation = book.location.first
                }
//            }
        }
        .alert("Issue Request sent to Librarian", isPresented: $issueAlert) {
            
        }
    }
}

struct ReviewCardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Best")
                .fontWeight(.bold)
            Text("Just loved this book")
            HStack(spacing:1) {
                ForEach(0..<4) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                Image(systemName: "star")
                    .foregroundColor(.yellow)
                
            }
            .font(.system(size: 12))
            Text("YashThakur")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 160)
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        
    }
}

struct BookCoverView: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: 100, height: 150)
            .cornerRadius(10)
    }
}

struct RatingsAndReviewsView: View {
    var body: some View {
        Text("Ratings and Reviews")
    }
}

struct MoreInSeriesView: View {
    var body: some View {
        Text("More in the Series")
    }
}


//#Preview {
//    BookDescriptionView()
//}
