import SwiftUI

struct UserProfileView: View {
    @ObservedObject var userManager = UserManager.shared
    
    @AppStorage("isDarkMode") private var isDark = false
    
    @State private var isDarkMode: Bool = false
    
//    var name: String
//    var issuedBooks: [Book]
//    var fines: [Fine]
    
//    init() {
//        self.name = "Ansh Bhasin"
//        
//        self.issuedBooks = [Book(id: "12312312", title: "New Title", author: "Ansh", description: "New Book", genre: Genre(id: "111", name: "11111", v: 0), price: 123.123, publisher: "Ansh", language: "English", length: 200, imageURL: URL(string: "https://m.media-amazon.com/images/I/61jBLw5Bq9L._AC_UY436_FMwebp_QL65_.jpg")!, isbn10: "242", isbn13: "24323", v: 0)]
//        
//        self.fines = [Fine(id: "12312313", issueId: Issue(id: "123131", book: Book(id: "12313213", title: "Great Gatsby", author: "James Luthor", description: "aksdmkasmdm kasmdaskm kasmk dmaskmdm aksmkdm kasmd mkasmd kmaksdm kmaskmd msad mkasmdkm as", genre: Genre(id: "000", name: "222", v: 11), price: 123123, publisher: "James Publications", language: "english", length: 400, imageURL: URL(string: "https://m.media-amazon.com/images/I/81w7a13pbnL.AC_SX500.jpg")!, isbn10: "11", isbn13: "22", v: 0), user: User(id: "1231231231", name: "user", email: "user@mail.com", contactNo: "123", genrePreferences: [], roles: .normalUser), issuedDate: Date(), deadline: Date(), status: .fining, returnDate: Date()) , amount: 123.13, status: .approved, category: .dueDateExceeded, interest: 100)]
//    }
    
//    init(name: String, issuedBooks: [Book], fines: [Fine]) {
//        self.name = name
//        self.issuedBooks = issuedBooks
//        self.fines = fines
//    }
    @State var alertState: Bool = false
    
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
                                Text(userManager.userDetail.name)
                                    .font(.title2)
                                    .bold()
                                Text(userManager.userDetail.email)
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
                
                Section(header: Text("MY PURCHASES").font(.headline)) {
                    NavigationLink(destination: IssuedBooksView()) {
                        HStack {
                            Image(systemName:"book")
                                .resizable()
                                .frame(width:25,height:20)
                            Text("Issued Books")
                                .font(.subheadline)
                            Spacer()
                        }
                        .frame(minHeight: 40)
                    }
                    
                    NavigationLink(destination: FinesView()) {
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
                
//                // App Theme Section
//                Section(header: Text("APP THEME").font(.headline)) {
//                    HStack {
//                        Image(systemName:"circle.lefthalf.filled")
//                            .resizable()
//                            .frame(width:25,height:25)
//                        Text("Dark Mode")
//                            .font(.subheadline)
//                        Spacer()
//                        Button(action: {
//                        }) {
//                            Toggle("", isOn: $isDarkMode)
//                                .onChange(of: isDarkMode) { state in
//                                    isDark = state
//                                }
//                        }
//                    }
//                    .frame(minHeight: 40)
//                }
                
                // Sign Out Section
                Section {
                    Button(action: {
                        alertState = true
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .frame(minHeight: 40)
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Profile")
            .alert("Are you sure?", isPresented: $alertState) {
                Button("Cancel", role: .cancel) {
                    
                }
                Button("Logout", role: .destructive) {
                    signOut()
                }
            } message: {
                Text("Are you sure you want to sign out")
            }
        }
        .onAppear {
            userManager.fetchUserDetails()
        }
        
    }
    
    private func signOut() {
        UserDefaults.standard.set("", forKey: "authToken")
        UserDefaults.standard.set("", forKey: "role")
        userManager.accessToken = ""
        userManager.role = ""
        print("User signed out")
    }
}
