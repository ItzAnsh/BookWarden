import SwiftUI

struct UserProfileView: View {
//    @Environment(\.colorScheme) var isDark
    @ObservedObject var userManager = UserManager.shared
    
    @AppStorage("isDarkMode") private var isDark = false
    
    @State private var isDarkMode: Bool = false
//    @Environment(\.colorScheme) private var isDark
    
    var name: String
    var issuedBooks: [Book]
    var fines: [Fine]
    
    init() {
        self.name = "Ansh Bhasin"
        
        self.issuedBooks = [Book(id: "12312312", title: "New Title", author: "Ansh", description: "New Book", genre: "aksmdasd", price: 123.123, publisher: "Ansh", language: "English", length: 200, imageURL: URL(string: "https://m.media-amazon.com/images/I/61jBLw5Bq9L._AC_UY436_FMwebp_QL65_.jpg")!, isbn10: "1212121212", isbn13: "1212121212121")]
        
        self.fines = [Fine(id: "12312313", issueId: Issue(id: "123131", bookId: Book(id: "12313213", title: "Great Gatsby", author: "James Luthor", description: "aksdmkasmdm kasmdaskm kasmk dmaskmdm aksmkdm kasmd mkasmd kmaksdm kmaskmd msad mkasmdkm as", genre: "NewGenre", price: 123123, publisher: "James Publications", language: "english", length: 400, imageURL: URL(string: "https://m.media-amazon.com/images/I/81w7a13pbnL.AC_SX500.jpg")!, isbn10: "1212121212", isbn13: "1212121212121"), userId: "1231231231", issuedDate: Date(), deadline: Date(), status: .fining, returnDate: Date()) , amount: 123.13, status: .approved, category: .dueDateExceeded, interest: 100)]
        
//        isDarkMode = isDark ? true : false
    }
    
    init(name: String, issuedBooks: [Book], fines: [Fine]) {
        self.name = name
        self.issuedBooks = issuedBooks
        self.fines = fines
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Profile Section
                Section {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text(name)
                                    .font(.title2)
                                    .bold()
                                Text("CUP-9222")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .padding(.top)
                        }
                    }
                    .padding()
                }
                
                // Library Links Section
//                Section(header: Text("LIBRARIES").font(.headline)) {
//                    NavigationLink(destination: UserLibraryView()) {
//                        HStack {
//                            Image(systemName:"building.columns.fill")
////                                .resizable()
////                                .frame(width:27,height:20)
//                                .font(.system(size: 20))
//                                
//                            Text("Select a Library")
//                                .font(.subheadline)
//                            Spacer()
//                        }
//                    }
//                    .frame(minHeight: 40)
//                }
                
                // My Purchases Section
                Section(header: Text("MY PURCHASES").font(.headline)) {
                    
                    NavigationLink(destination: IssuedBooksView(books: issuedBooks)) {
                        HStack {
                            Image(systemName:"book")
                                .resizable()
                                .frame(width:25,height:20)
                                .font(.system(size: 20))

                                
                            
                            Text("Issued Books")
                                .font(.subheadline)
                            Spacer()
                        }
                        .frame(minHeight: 40)
                    }
                    NavigationLink(destination: FinesView(fines: fines)) {
                        HStack {
                            Image(systemName:"creditcard")
                                .resizable()
                                .frame(width:25,height:20)
                                
                            Text("Fines")
                                .font(.subheadline)
                            Spacer()
                        }
                        .frame(minHeight: 40)
                    }
                }
                
                // App Theme Section
                Section(header: Text("APP THEME").font(.headline)) {
                    HStack {
                        Image(systemName:"circle.lefthalf.filled")
                            .resizable()
                            .frame(width:25,height:25)
                            
                        
                        Text("Dark Mode")
                            .font(.subheadline)
                        Spacer()
                        Button(action: {
                            
                        }) {
                            Toggle("", isOn: $isDarkMode)
                                .onChange(of: isDarkMode) { state in
                                    isDark = state
                                }
                        }
                    }
                    .frame(minHeight: 40)
                }
                
                // Sign Out Section
                Section {
                    Button(action: signOut) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .frame(minHeight: 40)
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Profile")
        }
    }

    private func signOut() {
        // Implement sign-out functionality here
        UserDefaults.standard.set(nil, forKey: "authToken")
        UserDefaults.standard.set(nil, forKey: "role")
        userManager.accessToken = ""
        userManager.role = ""
        print("User signed out")
    }
}

/*// Placeholder views for navigation links
struct UserLibraryView: View {
    var body: some View {
        Text("User Library View")
    }
}

struct UserPurchasesView: View {
    var body: some View {
        Text("User Purchases View")
    }
}

struct IssuedBooksView: View {
    var body: some View {
        Text("Issued Books View")
    }
}

struct FinesView: View {
    var body: some View {
        Text("Fines View")
    }
}*/

#Preview {
    UserProfileView()
}

